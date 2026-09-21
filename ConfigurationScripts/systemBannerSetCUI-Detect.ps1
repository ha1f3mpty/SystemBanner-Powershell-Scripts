# ============================================================
# SystemBanner - CUI Detection
#
# Exit codes:
#   0 = Configuration is correct
#   1 = Configuration is not correct
# ============================================================

$PolicyPath = "HKLM:\Software\Policies\SystemBanner"

$ExpectedSimpleClassification = 2
$ExpectedBannerPosition       = 0

if (-not (Test-Path -LiteralPath $PolicyPath)) {
    Write-Host "SystemBanner CUI configuration is not present."
    exit 1
}

$Simple = Get-ItemProperty -Path $PolicyPath -Name "Simple" -ErrorAction SilentlyContinue
if ($null -eq $Simple -or $Simple.Simple -ne $ExpectedSimpleClassification) {
    Write-Host "SystemBanner CUI configuration is incorrect: Simple is not set to 2."
    exit 1
}

$Position = Get-ItemProperty -Path $PolicyPath -Name "TopAndBottom" -ErrorAction SilentlyContinue
if ($null -eq $Position -or $Position.TopAndBottom -ne $ExpectedBannerPosition) {
    Write-Host "SystemBanner CUI configuration is incorrect: TopAndBottom is not set to 0."
    exit 1
}

Write-Host "SystemBanner is correctly configured for CUI, TOP ONLY."
exit 0