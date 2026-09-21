$exePath = "C:\Program Files\SystemBanner\SystemBanner.exe"

if (Test-Path -LiteralPath $exePath -PathType Leaf) {
    Write-Host "SystemBanner is installed."
    exit 0
}

Write-Host "SystemBanner is not installed."
exit 1