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

if ($itemsToDelete.Count -eq 0) {
  Write-Host "No AgentJoJoy wrapper files or folders found to delete at: $root"
  exit 0
}

if ($Action -eq "check") {
  Write-Host "Dry-run check: The following items will be deleted during ejection:"
  foreach ($item in $itemsToDelete) {
    Write-Host " - $item"
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

Write-Host "Ejection complete. The workspace is now unwrapped."
Write-Host "Note: You can manually remove any local gitignored settings (like .claude/settings.local.json or local bridge files) inside your project repo if you no longer need them."
exit 0
