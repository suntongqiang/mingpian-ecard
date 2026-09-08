param(
    [Parameter(Mandatory=$true)]
    [string]$Name,          # 卡片人名的拼音/英文标识，用于 URL 路径，如 "zhangweiwei"
    [Parameter(Mandatory=$true)]
    [string]$SourceFile,    # 要发布的单文件 .html 绝对路径
    [string]$CommitMsg = "" # 可选提交信息
)

$ErrorActionPreference = "Stop"
$Repo = Split-Path -Parent $MyInvocation.MyCommand.Path

# 1) 校验输入
if (-not (Test-Path $SourceFile)) { throw "源文件不存在: $SourceFile" }
if ($Name -match "[^a-zA-Z0-9\-_]") { throw "URL 标识只能含字母数字连字符: $Name" }
$DestDir = Join-Path $Repo $Name
New-Item -ItemType Directory -Force -Path $DestDir | Out-Null
$DestFile = Join-Path $DestDir "index.html"

# 2) 复制 + 校验文件
Copy-Item $SourceFile $DestFile -Force
$size = (Get-Item $DestFile).Length
if ($size -lt 10000) { throw "目标文件过小($size 字节)，疑似非完整卡片，已中止" }
"复制完成: $DestFile ($size 字节)"

# 3) 用 git 提交
if (-not (Test-Path (Join-Path $Repo ".git"))) { throw "目录下没有 .git，请先 init" }
git -C $Repo add --all
$msg = if ($CommitMsg) { $CommitMsg } else { "电子名片 · $Name" }
git -C $Repo commit -m $msg 2>&1 | Out-Null

# 4) 推送
$remote = (git -C $Repo remote get-url origin 2>$null)
if (-not $remote) { throw "没有配置远程 origin，请先加 remote" }
git -C $Repo push origin main 2>&1 | Out-Null

# 5) 输出链接
Write-Host ""
Write-Host "发布成功！" -ForegroundColor Green
Write-Host "卡片链接: https://suntongqiang.github.io/mingpian-ecard/$Name/"
Write-Host "来源: $SourceFile"
