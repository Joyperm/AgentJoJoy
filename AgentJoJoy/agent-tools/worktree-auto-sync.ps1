param(
  [ValidateSet("check", "sync")]
  [string]$Action = "check",

  [string]$WorkspaceRoot = "",

  [string]$MainCheckout = "",

  [switch]$AllowTemplateSource
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

function Invoke-Git {
  param(
    [string]$RepoPath,
    [string[]]$GitArgs
  )

  $previousErrorActionPreference = $ErrorActionPreference
  $ErrorActionPreference = "Continue"
  try {
    $output = & git -C $RepoPath @GitArgs 2>$null
    $exitCode = $LASTEXITCODE
  } finally {
    $ErrorActionPreference = $previousErrorActionPreference
  }

  if ($exitCode -ne 0) {
    throw "git failed in ${RepoPath}: git -C <repo> $($GitArgs -join ' ')"
  }
  return @($output)
}

function Test-GitRepo {
  param([string]$Path)

  try {
    $result = Invoke-Git -RepoPath $Path -GitArgs @("rev-parse", "--is-inside-work-tree")
    return (($result -join "").Trim() -eq "true")
  } catch {
    return $false
  }
}

function Get-TrackerMainCheckout {
  param([string]$TrackerPath)

  if (-not (Test-Path -LiteralPath $TrackerPath)) {
    return ""
  }

  $lines = Get-Content -LiteralPath $TrackerPath
  foreach ($line in $lines) {
    if ($line -match "^\s*>\s*Main checkout lives at:\s*(.+?)\s*$") {
      $value = $matches[1].Trim()
      if ($value -and $value -notmatch "_\(not set" -and $value -notmatch "<.*>") {
        return $value
      }
    }
  }

  return ""
}

function Resolve-MainCheckout {
  param(
    [string]$Root,
    [string]$ExplicitMain,
    [string]$TrackerPath
  )

  if ($ExplicitMain) {
    return (Resolve-Path -LiteralPath $ExplicitMain).Path
  }

  $trackerMain = Get-TrackerMainCheckout -TrackerPath $TrackerPath
  if ($trackerMain) {
    if ([System.IO.Path]::IsPathRooted($trackerMain)) {
      return (Resolve-Path -LiteralPath $trackerMain).Path
    }
    return (Resolve-Path -LiteralPath (Join-Path $Root $trackerMain)).Path
  }

  if (Test-GitRepo -Path $Root) {
    return $Root
  }

  $candidates = @(
    Get-ChildItem -LiteralPath $Root -Directory -ErrorAction SilentlyContinue |
      Where-Object { Test-GitRepo -Path $_.FullName } |
      Sort-Object Name
  )

  if ($candidates.Count -eq 1) {
    return $candidates[0].FullName
  }

  if ($candidates.Count -gt 1) {
    $names = ($candidates | ForEach-Object { $_.FullName }) -join "`n"
    throw "Multiple git repos found. Pass -MainCheckout explicitly.`n$names"
  }

  throw "No git checkout found. Fill 'Main checkout lives at' in progress-tracker.md or pass -MainCheckout."
}

function Get-DisplayPath {
  param(
    [string]$Root,
    [string]$Path
  )

  $rootFull = [System.IO.Path]::GetFullPath($Root).TrimEnd("\", "/")
  $pathFull = [System.IO.Path]::GetFullPath($Path).TrimEnd("\", "/")

  if ($pathFull -eq $rootFull) {
    return "."
  }

  $prefix = $rootFull + [System.IO.Path]::DirectorySeparatorChar
  if ($pathFull.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
    return $pathFull.Substring($prefix.Length)
  }

  return $pathFull
}

function Get-BranchName {
  param([string]$RepoPath)

  $branch = (Invoke-Git -RepoPath $RepoPath -GitArgs @("branch", "--show-current") -join "").Trim()
  if ($branch) {
    return $branch
  }

  $head = (Invoke-Git -RepoPath $RepoPath -GitArgs @("rev-parse", "--short", "HEAD") -join "").Trim()
  return "detached@$head"
}

function Get-WorktreeRecords {
  param([string]$RepoPath)

  $lines = Invoke-Git -RepoPath $RepoPath -GitArgs @("worktree", "list", "--porcelain")
  $records = @()
  $current = @{}

  foreach ($line in $lines) {
    if (-not $line.Trim()) {
      if ($current.ContainsKey("worktree")) {
        $records += [PSCustomObject]$current
      }
      $current = @{}
      continue
    }

    if ($line -match "^worktree\s+(.+)$") {
      $current["worktree"] = $matches[1]
    } elseif ($line -match "^HEAD\s+(.+)$") {
      $current["head"] = $matches[1]
    } elseif ($line -match "^branch\s+refs/heads/(.+)$") {
      $current["branch"] = $matches[1]
    } elseif ($line -eq "detached") {
      $current["branch"] = "detached"
    } elseif ($line -eq "bare") {
      $current["branch"] = "bare"
    }
  }

  if ($current.ContainsKey("worktree")) {
    $records += [PSCustomObject]$current
  }

  return $records
}

function Get-ShortStatusSummary {
  param([string]$RepoPath)

  $status = Invoke-Git -RepoPath $RepoPath -GitArgs @("status", "--short", "--branch")
  $branchLine = if ($status.Count -gt 0) { $status[0] } else { "" }
  $changes = @($status | Select-Object -Skip 1)

  [PSCustomObject]@{
    BranchLine = $branchLine
    ChangeCount = $changes.Count
    State = if ($changes.Count -eq 0) { "clean" } else { "dirty ($($changes.Count) change(s))" }
  }
}

function Build-SyncBlock {
  param(
    [string]$Root,
    [string]$RepoPath
  )

  $repoBranch = Get-BranchName -RepoPath $RepoPath
  $repoStatus = Get-ShortStatusSummary -RepoPath $RepoPath
  $worktrees = Get-WorktreeRecords -RepoPath $RepoPath
  $backtick = [char]96
  $mainCheckoutDisplay = Get-DisplayPath -Root $Root -Path $RepoPath

  $lines = @()
  $lines += "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
  $lines += "Mode: local read-only git scan; no fetch, pull, push, rebase, merge, or branch switch."
  $lines += ""
  $lines += "| Field | Value |"
  $lines += "|---|---|"
  $lines += "| Main checkout | $backtick$mainCheckoutDisplay$backtick |"
  $lines += "| Current branch | $backtick$repoBranch$backtick |"
  $lines += "| Main checkout state | $($repoStatus.State) |"
  $lines += "| Branch status | $backtick$($repoStatus.BranchLine)$backtick |"
  $lines += ""
  $lines += "### Auto-Synced Worktrees"
  $lines += ""
  $lines += "| Worktree path | Branch | State |"
  $lines += "|---|---|---|"

  foreach ($wt in $worktrees) {
    $path = $wt.worktree
    $branch = if ($wt.branch) { $wt.branch } else { "detached" }
    $state = "unknown"
    if (Test-Path -LiteralPath $path) {
      try {
        $state = (Get-ShortStatusSummary -RepoPath $path).State
      } catch {
        $state = "status unavailable"
      }
    } else {
      $state = "missing path"
    }

    $worktreeDisplay = Get-DisplayPath -Root $Root -Path $path
    $lines += "| $backtick$worktreeDisplay$backtick | $backtick$branch$backtick | $state |"
  }

  if ($worktrees.Count -eq 0) {
    $lines += "| _(none detected)_ |  |  |"
  }

  $lines += ""
  $lines += "Note: This block is generated. Keep human task notes in the normal tracker sections below."
  return ($lines -join "`r`n")
}

function Update-ManagedBlock {
  param(
    [string]$TrackerPath,
    [string]$Block
  )

  $begin = "<!-- AGENTJOJOY:WORKTREE-AUTO-SYNC BEGIN -->"
  $end = "<!-- AGENTJOJOY:WORKTREE-AUTO-SYNC END -->"
  $text = Get-Content -LiteralPath $TrackerPath -Raw
  $replacement = "$begin`r`n$Block`r`n$end"
  $pattern = "(?s)<!-- AGENTJOJOY:WORKTREE-AUTO-SYNC BEGIN -->.*?<!-- AGENTJOJOY:WORKTREE-AUTO-SYNC END -->"

  if ($text -match $pattern) {
    $updated = [regex]::Replace($text, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $replacement }, 1)
  } else {
    $section = "## Auto-Synced Git State`r`n`r`n$replacement`r`n`r`n---"
    $insertPattern = "(?m)^---\s*$"
    $updated = [regex]::Replace($text, $insertPattern, "---`r`n`r`n$section", 1)
  }

  Set-Content -LiteralPath $TrackerPath -Value $updated -Encoding UTF8
}

$root = Get-WorkspaceRoot -ExplicitRoot $WorkspaceRoot
$trackerPath = Join-Path $root "progress-tracker.md"
$templateMarker = Join-Path $root "AgentJoJoy\template-lab\.template-source"
$legacyTemplateMarker = Join-Path $root "AgentJoJoy\.template-source"

if (((Test-Path -LiteralPath $templateMarker) -or (Test-Path -LiteralPath $legacyTemplateMarker)) -and -not $AllowTemplateSource) {
  Write-Host "Template source marker detected. Refusing to sync reusable progress-tracker.md."
  Write-Host "Use -AllowTemplateSource only when intentionally testing this tool in the template source repo."
  exit 3
}

if (-not (Test-Path -LiteralPath $trackerPath)) {
  throw "progress-tracker.md not found at workspace root: $root"
}

$repoPath = Resolve-MainCheckout -Root $root -ExplicitMain $MainCheckout -TrackerPath $trackerPath
$block = Build-SyncBlock -Root $root -RepoPath $repoPath

if ($Action -eq "check") {
  Write-Host $block
  exit 0
}

Update-ManagedBlock -TrackerPath $trackerPath -Block $block
Write-Host "Updated: $trackerPath"
exit 0
