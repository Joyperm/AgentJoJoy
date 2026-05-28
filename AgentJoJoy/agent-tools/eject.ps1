param(
  [ValidateSet("check", "eject")]
  [string]$Action = "check",

  [switch]$Force,

  [string]$WorkspaceRoot = ""
)

$ErrorActionPreference = "Stop"

function Get-WorkspaceRoot {
  param([string]$ExplicitRoot)

  if ($ExplicitRoot) {
    return (Resolve-Path -LiteralPath $ExplicitRoot).Path
  }

  $scriptPath = $PSCommandPath
  if (-not $scriptPath) {
    throw "Unable to resolve script path. Pass -WorkspaceRoot explicitly."
  }

  $toolsDir = Split-Path -Parent $scriptPath
  $agentDir = Split-Path -Parent $toolsDir
  return (Split-Path -Parent $agentDir)
}

$root = Get-WorkspaceRoot -ExplicitRoot $WorkspaceRoot

# Files and folders to delete relative to the workspace root
$targets = @(
  "CLAUDE.md",
  "AGENTS.md",
  "progress-tracker.md",
  "AgentJoJoy"
)

# Expand targets to absolute paths
$itemsToDelete = @()
foreach ($target in $targets) {
  $targetPath = Join-Path $root $target
  if (Test-Path -LiteralPath $targetPath) {
    $itemsToDelete += $targetPath
  }
}

# Check if VS Code settings contain Distraction-Free Mode exclusions
$vscodeSettingsPath = Join-Path $root ".vscode\settings.json"
$hasVSCodeCleanup = $false
if (Test-Path -LiteralPath $vscodeSettingsPath) {
  try {
    $settingsContent = Get-Content -Raw -LiteralPath $vscodeSettingsPath -Encoding UTF8
    $settings = $settingsContent | ConvertFrom-Json
    if ($settings -and $settings.PSObject.Properties.Name -contains "files.exclude") {
      $exclude = $settings."files.exclude"
      $keysToRemove = @("AgentJoJoy/", "CLAUDE.md", "AGENTS.md", "VERSION", "progress-tracker.md")
      foreach ($key in $keysToRemove) {
        if ($exclude.PSObject.Properties.Name -contains $key) {
          $hasVSCodeCleanup = $true
          break
        }
      }
    }
  } catch {}
}

if ($itemsToDelete.Count -eq 0 -and -not $hasVSCodeCleanup) {
  Write-Host "No AgentJoJoy wrapper files, folders, or VS Code settings found to clean up at: $root"
  exit 0
}

if ($Action -eq "check") {
  Write-Host "Dry-run check: The following items will be cleaned up during ejection:"
  foreach ($item in $itemsToDelete) {
    Write-Host " - $item (permanent deletion)"
  }
  if ($hasVSCodeCleanup) {
    Write-Host " - $vscodeSettingsPath (will clean up Distraction-Free Mode exclusions)"
  }
  Write-Host "To execute ejection, run with -Action eject"
  exit 0
}

# Action is "eject"
if (-not $Force) {
  Write-Host "WARNING: You are about to cleanly eject AgentJoJoy from this workspace."
  Write-Host "This will permanently delete the following files and folders:"
  foreach ($item in $itemsToDelete) {
    Write-Host " - $item"
  }
  if ($hasVSCodeCleanup) {
    Write-Host "And it will clean up Distraction-Free Mode exclusions from: $vscodeSettingsPath"
  }
  Write-Host ""
  $confirmation = Read-Host "Are you sure you want to proceed? (Type 'y' or 'yes' to confirm)"
  if ($confirmation -notmatch "^(y|yes)$") {
    Write-Host "Ejection cancelled by user."
    exit 0
  }
}

# Perform deletion
Write-Host "Ejecting AgentJoJoy from workspace: $root"
foreach ($item in $itemsToDelete) {
  if (Test-Path -LiteralPath $item) {
    if (Test-Path -PathType Container -LiteralPath $item) {
      Write-Host "Deleting directory: $item"
      Remove-Item -Recurse -Force -LiteralPath $item
    } else {
      Write-Host "Deleting file: $item"
      Remove-Item -Force -LiteralPath $item
    }
  }
}

# Clean up VS Code settings if present
if ($hasVSCodeCleanup -and (Test-Path -LiteralPath $vscodeSettingsPath)) {
  Write-Host "Cleaning up Distraction-Free Mode exclusions from $vscodeSettingsPath..."
  try {
    $settingsContent = Get-Content -Raw -LiteralPath $vscodeSettingsPath -Encoding UTF8
    $settings = $settingsContent | ConvertFrom-Json
    if ($settings -and $settings.PSObject.Properties.Name -contains "files.exclude") {
      $exclude = $settings."files.exclude"
      $keysToRemove = @("AgentJoJoy/", "CLAUDE.md", "AGENTS.md", "VERSION", "progress-tracker.md")
      $changed = $false
      
      foreach ($key in $keysToRemove) {
        if ($exclude.PSObject.Properties.Name -contains $key) {
          $exclude.PSObject.Properties.Remove($key)
          $changed = $true
        }
      }
      
      if ($changed) {
        # If files.exclude is empty, remove it completely
        $excludePropertyCount = ($exclude.PSObject.Properties | Measure-Object).Count
        if ($excludePropertyCount -eq 0) {
          $settings.PSObject.Properties.Remove("files.exclude")
        }
        
        # Check if the entire settings object is now empty
        $settingsPropertyCount = ($settings.PSObject.Properties | Measure-Object).Count
        if ($settingsPropertyCount -eq 0) {
          Write-Host "Settings file is now empty, deleting it..."
          Remove-Item -Force -LiteralPath $vscodeSettingsPath
          
          # If .vscode folder is now empty, delete it too
          $vscodeFolder = Split-Path -Parent $vscodeSettingsPath
          $vscodeChildren = Get-ChildItem -LiteralPath $vscodeFolder -Force -ErrorAction SilentlyContinue
          if (-not $vscodeChildren) {
            Write-Host "Deleting empty .vscode folder..."
            Remove-Item -Force -LiteralPath $vscodeFolder
          }
        } else {
          Write-Host "Updating settings.json..."
          $updatedJson = $settings | ConvertTo-Json -Depth 100
          Set-Content -Path $vscodeSettingsPath -Value $updatedJson -NoNewline -Encoding UTF8
        }
      }
    }
  } catch {
    Write-Warning "Could not parse or update .vscode/settings.json: $_"
  }
}

Write-Host "Ejection complete. The workspace is now unwrapped."
Write-Host "Note: You can manually remove any local gitignored settings (like .claude/settings.local.json or local bridge files) inside your project repo if you no longer need them."
exit 0
