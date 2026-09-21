<#
================================================================================
SystemBanner - Custom TS//SAR//WAIVED Detection
================================================================================

Intune Remediation detection script for the custom SystemBanner
classification banner.

This script verifies that the SystemBanner policy registry values match the
configuration defined in the corresponding remediation script.


IMPORTANT:

The CONFIGURATION section of the remediation script is the authoritative
source for the desired settings.

If the configuration changes, update BOTH scripts so that the detection
values remain aligned with the remediation values.


Registry path:

    HKLM\Software\Policies\SystemBanner


================================================================================
CUSTOM CLASSIFICATION
================================================================================

$SimpleClassificationSetting:

    0 = UNCONFIGURED

        Custom text and custom colors configured by the remediation script
        are only used when this is set to 0.

    1 = UNCLASSIFIED
    2 = CUI
    3 = CONFIDENTIAL
    4 = SECRET
    5 = TOP SECRET
    6 = TOP SECRET SCI


IMPORTANT:

Custom text and custom colors are only used when Simple Classification
is set to UNCONFIGURED (0).

Therefore this custom banner uses:

    Simple = 0


================================================================================
BANNER POSITION
================================================================================

$BannerPositionSetting:

    0 = TOP ONLY
    1 = TOP AND BOTTOM

This configuration uses:

    Top Only = 0


================================================================================
CUSTOM BACKGROUND COLOR
================================================================================

This configuration uses background color:

    #FF8C00

RGB:

    Red   = 255
    Green = 140
    Blue  = 0

ADMX registry mapping:

    "0" = Red
    "1" = Green
    "2" = Blue


================================================================================
CUSTOM FOREGROUND COLOR
================================================================================

This configuration uses foreground color:

    #000000

RGB:

    Red   = 0
    Green = 0
    Blue  = 0

ADMX registry mapping:

    "3" = Red
    "4" = Green
    "5" = Blue


================================================================================
CUSTOM BANNER TEXT
================================================================================

This configuration uses text:

    TOP SECRET//SAR-RED CAR/SAR-TIN BAKER//WAIVED

Registry value:

    "Text"


================================================================================
EXPECTED CONFIGURATION
================================================================================

    Simple         = 0
    TopAndBottom   = 0

    Background     = #FF8C00
                     RGB(255, 140, 0)

    Foreground     = #000000
                     RGB(0, 0, 0)

    Text           = TOP SECRET//SAR-RED CAR/SAR-TIN BAKER//WAIVED


================================================================================
EXIT CODES
================================================================================

    0 = Configuration is correct
    1 = Configuration is not correct

#>


# ==============================================================================
# EXPECTED CONFIGURATION
# ==============================================================================

# Keep these values aligned with the CONFIGURATION section of the corresponding
# remediation script.

$PolicyPath = "HKLM:\Software\Policies\SystemBanner"

# Expected settings:
#
# Simple:
#   0 = UNCONFIGURED
#   1 = UNCLASSIFIED
#   2 = CUI
#   3 = CONFIDENTIAL
#   4 = SECRET
#   5 = TOP SECRET
#   6 = TOP SECRET SCI
#
# TopAndBottom:
#   0 = TOP ONLY
#   1 = TOP AND BOTTOM

$ExpectedSimpleClassification = 0
$ExpectedBannerPosition       = 0

$ExpectedBackgroundColor = @{
    Red   = 255
    Green = 140
    Blue  = 0
}

$ExpectedForegroundColor = @{
    Red   = 0
    Green = 0
    Blue  = 0
}

$ExpectedBannerText = "TOP SECRET//SAR-RED CAR/SAR-TIN BAKER//WAIVED"


# ==============================================================================
# POLICY KEY
# ==============================================================================

if (-not (Test-Path -LiteralPath $PolicyPath)) {
    Write-Host "SystemBanner custom TS//SAR configuration is not present."
    exit 1
}


# ==============================================================================
# SIMPLE CLASSIFICATION
# ==============================================================================

$Simple = Get-ItemProperty -Path $PolicyPath -Name "Simple" -ErrorAction SilentlyContinue

if ($null -eq $Simple -or 
    $Simple.Simple -ne $ExpectedSimpleClassification) {

    Write-Host "Detection failed: Simple Classification does not match the expected configuration."
    exit 1
}


# ==============================================================================
# BANNER POSITION
# ==============================================================================

$Position = Get-ItemProperty -Path $PolicyPath -Name "TopAndBottom" -ErrorAction SilentlyContinue

if ($null -eq $Position -or 
    $Position.TopAndBottom -ne $ExpectedBannerPosition) {

    Write-Host "Detection failed: Banner Position does not match the expected configuration."
    exit 1
}


# ==============================================================================
# BACKGROUND COLOR
#
# ADMX:
#
#     0 = Red
#     1 = Green
#     2 = Blue
# ==============================================================================

$Red = Get-ItemProperty -Path $PolicyPath -Name "0" -ErrorAction SilentlyContinue

$Green = Get-ItemProperty -Path $PolicyPath -Name "1" -ErrorAction SilentlyContinue

$Blue = Get-ItemProperty -Path $PolicyPath -Name "2" -ErrorAction SilentlyContinue

if ($null -eq $Red -or 
    $Red.'0' -ne $ExpectedBackgroundColor.Red) {
        
    Write-Host "Detection failed: Background Red does not match the expected configuration."
    exit 1
}

if ($null -eq $Green -or 
    $Green.'1' -ne $ExpectedBackgroundColor.Green) {

    Write-Host "Detection failed: Background Green does not match the expected configuration."
    exit 1
}

if ($null -eq $Blue -or 
    $Blue.'2' -ne $ExpectedBackgroundColor.Blue) {

    Write-Host "Detection failed: Background Blue does not match the expected configuration."
    exit 1
}


# ==============================================================================
# FOREGROUND COLOR
#
# ADMX:
#
#     3 = Red
#     4 = Green
#     5 = Blue
# ==============================================================================

$ForegroundRed = Get-ItemProperty -Path $PolicyPath -Name "3" -ErrorAction SilentlyContinue

$ForegroundGreen = Get-ItemProperty -Path $PolicyPath -Name "4" -ErrorAction SilentlyContinue

$ForegroundBlue = Get-ItemProperty -Path $PolicyPath -Name "5" -ErrorAction SilentlyContinue

if ($null -eq $ForegroundRed -or 
    $ForegroundRed.'3' -ne $ExpectedForegroundColor.Red) {

    Write-Host "Detection failed: Foreground Red does not match the expected configuration."
    exit 1
}

if ($null -eq $ForegroundGreen -or 
    $ForegroundGreen.'4' -ne $ExpectedForegroundColor.Green) {

    Write-Host "Detection failed: Foreground Green does not match the expected configuration."
    exit 1
}

if ($null -eq $ForegroundBlue -or 
    $ForegroundBlue.'5' -ne $ExpectedForegroundColor.Blue) {

    Write-Host "Detection failed: Foreground Blue does not match the expected configuration."
    exit 1
}


# ==============================================================================
# CUSTOM TEXT
# ==============================================================================

$Text = Get-ItemProperty -Path $PolicyPath -Name "Text" -ErrorAction SilentlyContinue

if ($null -eq $Text -or 
    $Text.Text -ne $ExpectedBannerText) {

    Write-Host "Detection failed: Custom Banner Text does not match the expected configuration."
    exit 1
}


# ==============================================================================
# COMPLETE
# ==============================================================================

Write-Host "SystemBanner custom TS//SAR configuration is correct."

exit 0