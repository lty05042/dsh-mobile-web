<#
  pair.ps1 —— 在运行 DSH 的电脑上取一枚一次性配对链接。

  用法（在电脑上，PowerShell 里执行）：
      powershell -ExecutionPolicy Bypass -File tools\pair.ps1
      powershell -ExecutionPolicy Bypass -File tools\pair.ps1 -Port 8748
      powershell -ExecutionPolicy Bypass -File tools\pair.ps1 -Client https://your.page/

  参数：
      -Port    指定 DSH 端口（默认自动发现）
      -Client  你的客户端页面地址（如 GitHub Pages 地址）。
               给了它，脚本会额外输出一条「一键配对深链」：
                   https://your.page/?pair=<wss 配对链接>
               手机点开这条链接就会自动配对，省去粘贴步骤（并复制这条深链）。

  配对码 30 秒有效、一次性；过期就重新运行。
#>
param(
  [int]$Port = 0,
  [string]$Client = ""
)

$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch { }

function Test-PairEndpoint([int]$p) {
  try {
    $r = Invoke-RestMethod -Uri "http://127.0.0.1:$p/remote-bridge/pair/token" -TimeoutSec 3 -Method Get
    if ($r -and $r.token) { return $r }
  } catch { }
  return $null
}

function Get-CandidatePorts {
  $pids = @()
  foreach ($name in @('DeepSeek Harness', 'dsh', 'node')) {
    try { $pids += (Get-Process -Name $name -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Id) } catch { }
  }
  if (-not $pids) { return @() }
  try {
    return @(Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue |
      Where-Object { $pids -contains $_.OwningProcess } |
      Select-Object -ExpandProperty LocalPort -Unique)
  } catch { return @() }
}

$info = $null
if ($Port -gt 0) {
  $info = Test-PairEndpoint $Port
} else {
  foreach ($p in (Get-CandidatePorts)) {
    $info = Test-PairEndpoint $p
    if ($info) { $Port = $p; break }
  }
}

if (-not $info) {
  Write-Host "没找到 DSH 的配对端点。请确认 DSH 正在运行，或用 -Port 手动指定端口。" -ForegroundColor Red
  exit 1
}

$link = if ($info.pairingUrl) { $info.pairingUrl } else { $info.url }
$ttl = [int][math]::Round((($info.expiresAt - [DateTimeOffset]::Now.ToUnixTimeMilliseconds()) / 1000), 0)

$deep = ""
if ($Client -and $Client.Trim() -ne "") {
  $sep = if ($Client.Contains("?")) { "&" } else { "?" }
  $deep = $Client + $sep + "pair=" + [uri]::EscapeDataString($link)
}

$toBeCopied = if ($deep) { $deep } else { $link }
try { Set-Clipboard -Value $toBeCopied } catch { }

Write-Host ""
Write-Host "  DSH 配对（30 秒内用完，一次性）" -ForegroundColor Cyan
Write-Host "  ------------------------------------------------------------"
Write-Host "  端口      : $Port"
Write-Host "  公网地址  : $($info.origin) [$($info.originSource)]"
Write-Host "  剩余有效期: ${ttl}s"
Write-Host ""
Write-Host "  配对链接  :" -ForegroundColor Yellow
Write-Host "  $link"
Write-Host ""

if ($deep) {
  Write-Host "  一键配对深链（手机点开即自动配对）:" -ForegroundColor Green
  Write-Host "  $deep"
  Write-Host ""
  Write-Host "  已复制深链到剪贴板，直接发到手机打开即可。" -ForegroundColor Green
} else {
  Write-Host "  已复制到剪贴板。把它发到手机，在客户端里粘贴后点「连接」。" -ForegroundColor Green
  Write-Host "  提示：加 -Client https://你的页面/ 可以生成一键深链，省去粘贴。" -ForegroundColor DarkGray
}
Write-Host "  过期就重新运行本脚本。" -ForegroundColor DarkGray
Write-Host ""
