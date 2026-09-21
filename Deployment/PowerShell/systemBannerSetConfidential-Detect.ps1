# ============================================================
# SystemBanner - Confidential Detection
# ============================================================

$PolicyPath = "HKLM:\Software\Policies\SystemBanner"

if (-not (Test-Path -LiteralPath $PolicyPath)) {
    Write-Host "SystemBanner Confidential configuration is not present."
    exit 1
}

$Simple = Get-ItemProperty -Path $PolicyPath -Name "Simple" -ErrorAction SilentlyContinue
if ($null -eq $Simple -or $Simple.Simple -ne 3) {
    Write-Host "SystemBanner Confidential configuration is incorrect."
    exit 1
}

$Position = Get-ItemProperty -Path $PolicyPath -Name "TopAndBottom" -ErrorAction SilentlyContinue
if ($null -eq $Position -or $Position.TopAndBottom -ne 0) {
    Write-Host "SystemBanner Confidential configuration has incorrect banner position."
    exit 1
}

Write-Host "SystemBanner is correctly configured for CONFIDENTIAL, TOP ONLY."
exit 0