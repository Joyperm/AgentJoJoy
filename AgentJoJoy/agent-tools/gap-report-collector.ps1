param(
  [ValidateSet("collect", "export", "check", "list", "summarize", "purge")]
  [string]$Action = "collect",

  [string]$WorkspaceRoot = "",

  [switch]$CompanyMachine,

  [switch]$Force
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

function Test-UnsafeText {
  param([string]$Text)

  $patterns = @(
    @{ Name = "windows-user-path"; Pattern = "[A-Za-z]:\\Users\\" },
    @{ Name = "url"; Pattern = "https?://" },
    @{ Name = "git-remote"; Pattern = "(git@|ssh://|\.git\b)" },
    @{ Name = "credential-keyword"; Pattern = "(?i)(password|passwd|secret|token|api[_-]?key|credential|private[_-]?key)" },
    @{ Name = "ip-address"; Pattern = "\b(?:\d{1,3}\.){3}\d{1,3}\b" },
    @{ Name = "email"; Pattern = "\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b" }
  )

  $hits = @()
  foreach ($entry in $patterns) {
    if ($Text -match $entry.Pattern) {
      $hits += $entry.Name
    }
  }

  return ($hits | Sort-Object -Unique)
}

function Get-FieldValue {
  param(
    [string[]]$Lines,
    [string]$Label
  )

  $labelPattern = "^\s*[-*]?\s*\*\*$([regex]::Escape($Label))\*\*\s*:\s*(.+)$"
  foreach ($line in $Lines) {
    if ($line -match $labelPattern) {
      return $matches[1].Trim()
    }
  }

  $plainPattern = "^\s*[-*]?\s*$([regex]::Escape($Label))\s*:\s*(.+)$"
  foreach ($line in $Lines) {
    if ($line -match $plainPattern) {
      return $matches[1].Trim()
    }
  }

  return ""
}

function New-GapRecord {
  param([System.IO.FileInfo]$File)

  $text = Get-Content -LiteralPath $File.FullName -Raw
  $lines = $text -split "`r?`n"
  $unsafe = Test-UnsafeText -Text $text

  $category = Get-FieldValue -Lines $lines -Label "Gap Category"
  $friction = Get-FieldValue -Lines $lines -Label "Observed Friction"
  $workaround = Get-FieldValue -Lines $lines -Label "AI Workaround Applied"
  $improvement = Get-FieldValue -Lines $lines -Label "Suggested Improvement for Template"

  [PSCustomObject]@{
    File = $File.Name
    LastWriteTime = $File.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
    GapCategory = $category
    ObservedFriction = $friction
    AIWorkaroundApplied = $workaround
    SuggestedImprovement = $improvement
    UnsafeSignals = ($unsafe -join ", ")
    IsExportable = ($unsafe.Count -eq 0)
  }
}

function Write-Index {
  param(
    [array]$Records,
    [string]$OutputPath,
    [switch]$CompanyMachine
  )

  $lines = @()
  $lines += "# Gap Report Collector Index"
  $lines += ""
  $lines += "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
  $lines += "Mode: local-only"
  if ($CompanyMachine) {
    $lines += "Company machine policy: remote sync/upload hard-blocked; manual transfer only."
  } else {
    $lines += "Remote sync/upload: not implemented by this tool; local export only."
  }
  $lines += ""
  $lines += "## Summary"
  $lines += ""
  $lines += "- Reports found: $($Records.Count)"
  $lines += "- Exportable reports: $(($Records | Where-Object { $_.IsExportable }).Count)"
  $lines += "- Blocked reports: $(($Records | Where-Object { -not $_.IsExportable }).Count)"
  $lines += ""
  $lines += "## Reports"
  $lines += ""

  foreach ($record in $Records) {
    $lines += "### $($record.File)"
    $lines += ""
    $lines += "- Last write: $($record.LastWriteTime)"
    $lines += "- Category: $(if ($record.GapCategory) { $record.GapCategory } else { '_not set_' })"
    if ($record.IsExportable) {
      $lines += "- Exportable: yes"
      $lines += "- Observed friction: $(if ($record.ObservedFriction) { $record.ObservedFriction } else { '_not set_' })"
      $lines += "- AI workaround: $(if ($record.AIWorkaroundApplied) { $record.AIWorkaroundApplied } else { '_not set_' })"
      $lines += "- Suggested improvement: $(if ($record.SuggestedImprovement) { $record.SuggestedImprovement } else { '_not set_' })"
    } else {
      $lines += "- Exportable: no"
      $lines += "- Block reason: unsafe signals detected ($($record.UnsafeSignals))"
      $lines += "- Action: manually redact the source report before export."
    }
    $lines += ""
  }

  Set-Content -LiteralPath $OutputPath -Value $lines -Encoding UTF8
}

$root = Get-WorkspaceRoot -ExplicitRoot $WorkspaceRoot
$gapsDir = Join-Path $root "AgentJoJoy\agent-runtime\gaps"
$collectorDir = Join-Path $gapsDir "_collector"
$exportDir = Join-Path $gapsDir "_exports"

New-Item -ItemType Directory -Path $gapsDir -Force | Out-Null

$gapFiles = @(
  Get-ChildItem -LiteralPath $gapsDir -Filter "gap-*.md" -File -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime
)

$records = @()
foreach ($file in $gapFiles) {
  $records += New-GapRecord -File $file
}

$writesIndex = @("collect", "check", "export") -contains $Action
$indexPath = Join-Path $collectorDir "gap-report-index.md"
if ($writesIndex) {
  New-Item -ItemType Directory -Path $collectorDir -Force | Out-Null
  Write-Index -Records $records -OutputPath $indexPath -CompanyMachine:$CompanyMachine
}

if ($Action -eq "check") {
  Write-Host "Gap reports found: $($records.Count)"
  Write-Host "Blocked reports: $(($records | Where-Object { -not $_.IsExportable }).Count)"
  Write-Host "Index: $indexPath"
  exit 0
}

if ($Action -eq "collect") {
  Write-Host "Index written: $indexPath"
  exit 0
}

if ($Action -eq "list") {
  if ($records.Count -eq 0) {
    Write-Host "No gap reports found in: $gapsDir"
    exit 0
  }
  Write-Host ("{0,-32} {1,-22} {2,-12} {3}" -f "File", "Last write", "Status", "Category")
  Write-Host ("{0,-32} {1,-22} {2,-12} {3}" -f "----", "----------", "------", "--------")
  foreach ($record in $records) {
    $status = if ($record.IsExportable) { "exportable" } else { "blocked" }
    $cat = if ($record.GapCategory) { $record.GapCategory } else { "_not set_" }
    Write-Host ("{0,-32} {1,-22} {2,-12} {3}" -f $record.File, $record.LastWriteTime, $status, $cat)
  }
  Write-Host ""
  Write-Host "Total: $($records.Count) report(s). Run with -Action summarize for pattern analysis."
  exit 0
}

if ($Action -eq "summarize") {
  if ($records.Count -eq 0) {
    Write-Host "No gap reports found in: $gapsDir"
    Write-Host "Nothing to summarize yet — the Automated Gap Reporter writes here when AI observes recurring friction."
    exit 0
  }

  Write-Host "Gap Report Summary"
  Write-Host "=================="
  Write-Host "Workspace: $root"
  $exportableCount = @($records | Where-Object { $_.IsExportable }).Count
  $blockedCount = @($records | Where-Object { -not $_.IsExportable }).Count
  Write-Host "Reports analyzed: $($records.Count) ($exportableCount exportable, $blockedCount blocked)"
  Write-Host ""

  Write-Host "By category:"
  $groups = $records | Group-Object -Property GapCategory | Sort-Object Count -Descending
  foreach ($group in $groups) {
    $label = if ($group.Name) { $group.Name } else { "_not set_" }
    Write-Host (" - {0,-3} x {1}" -f $group.Count, $label)
  }
  Write-Host ""

  $withFriction = @($records | Where-Object { $_.IsExportable -and $_.ObservedFriction })
  if ($withFriction.Count -gt 0) {
    Write-Host "Recent exportable friction samples (up to 5):"
    $sample = $withFriction | Sort-Object LastWriteTime -Descending | Select-Object -First 5
    foreach ($record in $sample) {
      Write-Host " - [$($record.GapCategory)] $($record.ObservedFriction)"
    }
    Write-Host ""
  }

  $blocked = @($records | Where-Object { -not $_.IsExportable })
  if ($blocked.Count -gt 0) {
    Write-Host "Blocked reports (manually redact before sharing):"
    foreach ($record in $blocked) {
      Write-Host " - $($record.File) — unsafe signals: $($record.UnsafeSignals)"
    }
    Write-Host ""
  }

  Write-Host "---"
  Write-Host "Want to suggest these as template improvements? Open an issue at"
  Write-Host "https://github.com/Joyperm/AgentJoJoy/issues and paste the redacted summary above."
  Write-Host "Sharing is fully optional — nothing leaves your machine unless you choose to send it."
  exit 0
}

if ($Action -eq "purge") {
  $targets = @()
  foreach ($file in $gapFiles) { $targets += $file.FullName }
  if (Test-Path -LiteralPath $collectorDir) { $targets += $collectorDir }
  if (Test-Path -LiteralPath $exportDir) { $targets += $exportDir }

  if ($targets.Count -eq 0) {
    Write-Host "Nothing to purge. Gaps folder is already clean: $gapsDir"
    exit 0
  }

  Write-Host "Purge will delete the following local gap data:"
  foreach ($target in $targets) {
    Write-Host " - $target"
  }
  Write-Host ""

  if (-not $Force) {
    Write-Host "Refusing to purge without -Force. Re-run with -Force to confirm deletion."
    Write-Host "Example: powershell -ExecutionPolicy Bypass -File AgentJoJoy/agent-tools/gap-report-collector.ps1 -Action purge -Force"
    exit 2
  }

  foreach ($file in $gapFiles) {
    Remove-Item -LiteralPath $file.FullName -Force
  }
  if (Test-Path -LiteralPath $collectorDir) {
    Remove-Item -Recurse -Force -LiteralPath $collectorDir
  }
  if (Test-Path -LiteralPath $exportDir) {
    Remove-Item -Recurse -Force -LiteralPath $exportDir
  }
  Write-Host "Purged $($gapFiles.Count) gap report(s) and collector outputs."
  exit 0
}

if ($Action -eq "export") {
  $blocked = @($records | Where-Object { -not $_.IsExportable })
  if ($blocked.Count -gt 0) {
    Write-Host "Export blocked. Redact flagged reports first."
    Write-Host "Index: $indexPath"
    exit 2
  }

  New-Item -ItemType Directory -Path $exportDir -Force | Out-Null
  $exportPath = Join-Path $exportDir ("gap-report-bundle-{0}.md" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
  Copy-Item -LiteralPath $indexPath -Destination $exportPath
  Write-Host "Local export written: $exportPath"
  if ($CompanyMachine) {
    Write-Host "Company machine policy: do not upload from this machine. Transfer manually if approved."
  }
  exit 0
}
