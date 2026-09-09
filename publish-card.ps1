param(
    [Parameter(Mandatory=$true)]
    [string]$Name,          # URL slug: use pinyin/english, e.g. "zhangweiwei"
    [Parameter(Mandatory=$true)]
    [string]$SourceFile,    # absolute path to the standalone .html card
    [string]$CommitMsg = "" # optional commit message
)

$ErrorActionPreference = "Stop"
$Repo = Split-Path -Parent $MyInvocation.MyCommand.Path

# 1) validate inputs
if (-not (Test-Path $SourceFile)) { throw "Source file not found: $SourceFile" }
if ($Name -match "[^a-zA-Z0-9\-_]") { throw "URL slug can only contain letters/digits/dash: $Name" }
$DestDir = Join-Path $Repo $Name
New-Item -ItemType Directory -Force -Path $DestDir | Out-Null
$DestFile = Join-Path $DestDir "index.html"

# 2) copy + sanity-check size
Copy-Item $SourceFile $DestFile -Force
$size = (Get-Item $DestFile).Length
if ($size -lt 10000) { throw "Target file too small ($size bytes); aborting" }
Write-Host "Copied: $DestFile ($size bytes)"

# 3) git commit
if (-not (Test-Path (Join-Path $Repo ".git"))) { throw "No .git found; init first" }
git -C $Repo add --all
$msg = if ($CommitMsg) { $CommitMsg } else { "Electronic business card: $Name" }
git -C $Repo commit -m $msg 2>&1 | Out-Null

# 4) push
$remote = (git -C $Repo remote get-url origin 2>$null)
if (-not $remote) { throw "No remote 'origin' configured" }
git -C $Repo push origin main 2>&1 | Out-Null

# 5) output the link
Write-Host ""
Write-Host "Published!" -ForegroundColor Green
Write-Host "Card link: https://suntongqiang.github.io/mingpian-ecard/$Name/"
Write-Host "Source: $SourceFile"
