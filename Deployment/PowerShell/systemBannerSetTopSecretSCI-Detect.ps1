# SystemBanner - Top Secret SCI Detection

$PolicyPath = "HKLM:\Software\Policies\SystemBanner"

if (-not (Test-Path -LiteralPath $PolicyPath)) {
    Write-Host "SystemBanner Top Secret SCI configuration is not present."
    exit 1
}

$Simple = Get-ItemProperty -Path $PolicyPath -Name "Simple" -ErrorAction SilentlyContinue
if ($null -eq $Simple -or $Simple.Simple -ne 6) {
    Write-Host "SystemBanner Top Secret SCI configuration is incorrect."
    exit 1
}

$Position = Get-ItemProperty -Path $PolicyPath -Name "TopAndBottom" -ErrorAction SilentlyContinue
if ($null -eq $Position -or $Position.TopAndBottom -ne 0) {
    Write-Host "SystemBanner Top Secret SCI configuration has incorrect banner position."
    exit 1
}

Write-Host "SystemBanner is correctly configured for TOP SECRET SCI, TOP ONLY."
exit 0