param(
    [Parameter(Mandatory=$true)]
    [string]$Name,          # existing URL slug, e.g. "lingjionghuan" -> link stays the same
    [Parameter(Mandatory=$true)]
    [string]$SourceFile,    # absolute path to the new .html card
    [string]$CommitMsg = "" # optional commit message
)

$ErrorActionPreference = "Stop"
$Repo = Split-Path -Parent $MyInvocation.MyCommand.Path

# 1) validate inputs
if (-not (Test-Path $SourceFile)) { throw "Source file not found: $SourceFile" }
if ($Name -match "[^a-zA-Z0-9\-_]") { throw "URL slug can only contain letters/digits/dash: $Name" }
$DestFile = Join-Path $Repo (Join-Path $Name "index.html")
if (-not (Test-Path $DestFile)) { throw "No existing card at $Name. Use publish-card.ps1 to create a new card first." }

# 2) overwrite the SAME index.html (name unchanged -> link unchanged)
Copy-Item $SourceFile $DestFile -Force
$size = (Get-Item $DestFile).Length
if ($size -lt 10000) { throw "Target file too small ($size bytes); aborting" }
Write-Host "Updated: $DestFile ($size bytes)"

# 3) git commit
if (-not (Test-Path (Join-Path $Repo ".git"))) { throw "No .git found; init first" }
git -C $Repo add --all
$msg = if ($CommitMsg) { $CommitMsg } else { "Update electronic business card: $Name" }
git -C $Repo commit -m $msg 2>&1 | Out-Null

# 4) push
$remote = (git -C $Repo remote get-url origin 2>$null)
if (-not $remote) { throw "No remote 'origin' configured" }
git -C $Repo push origin main 2>&1 | Out-Null

# 5) same link (unchanged)
Write-Host ""
Write-Host "Updated on the SAME link!" -ForegroundColor Green
Write-Host "Link (unchanged): https://suntongqiang.github.io/mingpian-ecard/$Name/"
Write-Host "Source: $SourceFile"
