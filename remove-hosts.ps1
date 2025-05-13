# 檢查是否為系統管理員
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Host "⚠️ 需要系統管理員權限，正在以系統管理員身份重新啟動..."
    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 移除三筆 hosts 記錄
$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"

$entriesToRemove = @(
    "10.5.4.103  affine.whalin.cc",
    "10.5.4.103  file.whalin.cc",
    "10.5.4.103  ytdlp.whalin.cc"
)

# 讀取所有行並過濾掉欲刪除的內容
$lines = Get-Content -Path $hostsPath
$filtered = $lines | Where-Object { $_.Trim() -notin $entriesToRemove }

# 覆蓋寫回
Set-Content -Path $hostsPath -Value $filtered

Write-Output "🧹 Hosts file entries removed."
