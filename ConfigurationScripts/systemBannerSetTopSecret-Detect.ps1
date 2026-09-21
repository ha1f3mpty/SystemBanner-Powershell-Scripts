# SystemBanner - Top Secret Detection

$PolicyPath = "HKLM:\Software\Policies\SystemBanner"

if (-not (Test-Path -LiteralPath $PolicyPath)) {
    Write-Host "SystemBanner Top Secret configuration is not present."
    exit 1
}

$Simple = Get-ItemProperty -Path $PolicyPath -Name "Simple" -ErrorAction SilentlyContinue
if ($null -eq $Simple -or $Simple.Simple -ne 5) {
    Write-Host "SystemBanner Top Secret configuration is incorrect."
    exit 1
}

$Position = Get-ItemProperty -Path $PolicyPath -Name "TopAndBottom" -ErrorAction SilentlyContinue
if ($null -eq $Position -or $Position.TopAndBottom -ne 0) {
    Write-Host "SystemBanner Top Secret configuration has incorrect banner position."
    exit 1
}

Write-Host "SystemBanner is correctly configured for TOP SECRET, TOP ONLY."
exit 0