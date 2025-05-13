# 檢查是否為系統管理員
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Host "⚠️ 需要系統管理員權限，正在以系統管理員身份重新啟動..."
    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"

$entries = @(
    "10.5.4.103  affine.whalin.cc",
    "10.5.4.103  file.whalin.cc",
    "10.5.4.103  ytdlp.whalin.cc"
)

foreach ($entry in $entries) {
    if (-not (Select-String -Path $hostsPath -Pattern ([regex]::Escape($entry)) -Quiet)) {
        Add-Content -Path $hostsPath -Value $entry
    }
}

Write-Output "✅ Hosts file updated successfully."
