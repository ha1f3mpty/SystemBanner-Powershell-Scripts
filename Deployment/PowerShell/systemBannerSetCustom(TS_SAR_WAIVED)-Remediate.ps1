<#
================================================================================
SystemBanner - Custom TS//SAR Remediation
================================================================================

Direct registry configuration for the SystemBanner Group Policy settings.

This remediation script configures a custom SystemBanner classification banner
without requiring Group Policy Editor (gpedit.msc).

The SystemBanner ADMX defines all policies as MACHINE policies under:

    HKLM\Software\Policies\SystemBanner


================================================================================
SIMPLE CLASSIFICATION
================================================================================

$SimpleClassificationSetting:

    0 = UNCONFIGURED
    1 = UNCLASSIFIED
    2 = CUI
    3 = CONFIDENTIAL
    4 = SECRET
    5 = TOP SECRET
    6 = TOP SECRET SCI

IMPORTANT:

When this is set to anything other than 0, the selected classification
is displayed and the custom text/color settings are NOT used.

Setting this to 0 allows the custom text and custom color settings below
to be used.

This custom configuration therefore uses:

    0 = UNCONFIGURED


================================================================================
BANNER POSITION
================================================================================

$BannerPositionSetting:

    0 = TOP ONLY
    1 = TOP AND BOTTOM

This configuration uses:

    0 = TOP ONLY


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
CUSTOM TEXT
================================================================================

This configuration uses banner text:

    TOP SECRET//SAR-RED CAR/SAR-TIN BAKER//WAIVED

This text is displayed because Simple Classification is UNCONFIGURED (0).


================================================================================
FINAL CONFIGURATION
================================================================================

    Simple Classification = UNCONFIGURED (0)

    Banner Position = TOP ONLY (0)

    Background = #FF8C00
                 RGB(255, 140, 0)

    Foreground = #000000
                 RGB(0, 0, 0)

    Text = TOP SECRET//SAR-RED CAR/SAR-TIN BAKER//WAIVED


================================================================================
REGISTRY
================================================================================

Policy path:

    HKLM\Software\Policies\SystemBanner


================================================================================
EXIT CODES
================================================================================

    0 = Configuration successfully applied
    1 = Configuration failed

#>


# ==============================================================================
# CONFIGURATION
# ==============================================================================

# IMPORTANT:
#
# The detection script contains matching expected values.
#
# If any of the values below are changed, update the corresponding expected
# values in the detection script so both scripts remain aligned.


# ------------------------------------------------------------------------------
# SIMPLE CLASSIFICATION
#
# 0 = UNCONFIGURED
# 1 = UNCLASSIFIED
# 2 = CUI
# 3 = CONFIDENTIAL
# 4 = SECRET
# 5 = TOP SECRET
# 6 = TOP SECRET SCI
# ------------------------------------------------------------------------------

$SimpleClassificationSetting = 0


# ------------------------------------------------------------------------------
# BANNER POSITION
#
# 0 = TOP ONLY
# 1 = TOP AND BOTTOM
# ------------------------------------------------------------------------------

$BannerPositionSetting = 0


# ------------------------------------------------------------------------------
# CUSTOM BACKGROUND COLOR
#
# Hex: #FF8C00
# RGB: 255, 140, 0
# ------------------------------------------------------------------------------

$BackgroundColor = @(255, 140, 0)


# ------------------------------------------------------------------------------
# CUSTOM FOREGROUND COLOR
#
# Hex: #000000
# RGB: 0, 0, 0
# ------------------------------------------------------------------------------

$ForegroundColor = @(0, 0, 0)


# ------------------------------------------------------------------------------
# CUSTOM BANNER TEXT
# ------------------------------------------------------------------------------

$BannerText = "TOP SECRET//SAR-RED CAR/SAR-TIN BAKER//WAIVED"


# ==============================================================================
# REGISTRY
# ==============================================================================

$PolicyPath = "HKLM:\Software\Policies\SystemBanner"


# ==============================================================================
# CONFIGURATION VALIDATION
# ==============================================================================

if ($SimpleClassificationSetting -notin 0..6) {
    Write-Host "Configuration error: SimpleClassificationSetting must be between 0 and 6."
    exit 1
}

if ($BannerPositionSetting -notin 0..1) {
    Write-Host "Configuration error: BannerPositionSetting must be 0 or 1."
    exit 1
}

if ($BackgroundColor.Count -ne 3) {
    Write-Host "Configuration error: BackgroundColor must contain exactly three RGB values."
    exit 1
}

if ($ForegroundColor.Count -ne 3) {
    Write-Host "Configuration error: ForegroundColor must contain exactly three RGB values."
    exit 1
}

foreach ($Value in ($BackgroundColor + $ForegroundColor)) {
    if ($Value -lt 0 -or $Value -gt 255) {
        Write-Host "Configuration error: All RGB values must be between 0 and 255."
        exit 1
    }
}


# ==============================================================================
# CREATE POLICY KEY AND APPLY CONFIGURATION
# ==============================================================================

try {

    if (-not (Test-Path -LiteralPath $PolicyPath)) {
        New-Item -Path $PolicyPath -Force -ErrorAction Stop | Out-Null
    }


    # ==========================================================================
    # SIMPLE CLASSIFICATION
    # ==========================================================================

    New-ItemProperty `
        -Path $PolicyPath `
        -Name "Simple" `
        -PropertyType DWord `
        -Value $SimpleClassificationSetting `
        -Force `
        -ErrorAction Stop | Out-Null


    # ==========================================================================
    # BANNER POSITION
    # ==========================================================================

    New-ItemProperty `
        -Path $PolicyPath `
        -Name "TopAndBottom" `
        -PropertyType DWord `
        -Value $BannerPositionSetting `
        -Force `
        -ErrorAction Stop | Out-Null


    # ==========================================================================
    # BACKGROUND COLOR
    #
    # ADMX:
    #
    #     0 = Red
    #     1 = Green
    #     2 = Blue
    # ==========================================================================

    New-ItemProperty `
        -Path $PolicyPath `
        -Name "0" `
        -PropertyType DWord `
        -Value $BackgroundColor[0] `
        -Force `
        -ErrorAction Stop | Out-Null

    New-ItemProperty `
        -Path $PolicyPath `
        -Name "1" `
        -PropertyType DWord `
        -Value $BackgroundColor[1] `
        -Force `
        -ErrorAction Stop | Out-Null

    New-ItemProperty `
        -Path $PolicyPath `
        -Name "2" `
        -PropertyType DWord `
        -Value $BackgroundColor[2] `
        -Force `
        -ErrorAction Stop | Out-Null


    # ==========================================================================
    # FOREGROUND COLOR
    #
    # ADMX:
    #
    #     3 = Red
    #     4 = Green
    #     5 = Blue
    # ==========================================================================

    New-ItemProperty `
        -Path $PolicyPath `
        -Name "3" `
        -PropertyType DWord `
        -Value $ForegroundColor[0] `
        -Force `
        -ErrorAction Stop | Out-Null

    New-ItemProperty `
        -Path $PolicyPath `
        -Name "4" `
        -PropertyType DWord `
        -Value $ForegroundColor[1] `
        -Force `
        -ErrorAction Stop | Out-Null

    New-ItemProperty `
        -Path $PolicyPath `
        -Name "5" `
        -PropertyType DWord `
        -Value $ForegroundColor[2] `
        -Force `
        -ErrorAction Stop | Out-Null


    # ==========================================================================
    # CUSTOM TEXT
    # ==========================================================================

    New-ItemProperty `
        -Path $PolicyPath `
        -Name "Text" `
        -PropertyType String `
        -Value $BannerText `
        -Force `
        -ErrorAction Stop | Out-Null
}
catch {
    Write-Host "SystemBanner custom TS//SAR configuration failed: $($_.Exception.Message)"
    exit 1
}


# ==============================================================================
# CONFIGURATION VALIDATION
# ==============================================================================

$Simple = Get-ItemProperty `
    -Path $PolicyPath `
    -Name "Simple" `
    -ErrorAction SilentlyContinue

if ($null -eq $Simple -or $Simple.Simple -ne $SimpleClassificationSetting) {
    Write-Host "Validation failed: Simple Classification does not match the configured value."
    exit 1
}


$Position = Get-ItemProperty `
    -Path $PolicyPath `
    -Name "TopAndBottom" `
    -ErrorAction SilentlyContinue

if ($null -eq $Position -or $Position.TopAndBottom -ne $BannerPositionSetting) {
    Write-Host "Validation failed: Banner Position does not match the configured value."
    exit 1
}


# ------------------------------------------------------------------------------
# BACKGROUND COLOR
# ------------------------------------------------------------------------------

$Red = Get-ItemProperty `
    -Path $PolicyPath `
    -Name "0" `
    -ErrorAction SilentlyContinue

$Green = Get-ItemProperty `
    -Path $PolicyPath `
    -Name "1" `
    -ErrorAction SilentlyContinue

$Blue = Get-ItemProperty `
    -Path $PolicyPath `
    -Name "2" `
    -ErrorAction SilentlyContinue

if ($null -eq $Red -or $Red.'0' -ne $BackgroundColor[0]) {
    Write-Host "Validation failed: Background Red does not match the configured value."
    exit 1
}

if ($null -eq $Green -or $Green.'1' -ne $BackgroundColor[1]) {
    Write-Host "Validation failed: Background Green does not match the configured value."
    exit 1
}

if ($null -eq $Blue -or $Blue.'2' -ne $BackgroundColor[2]) {
    Write-Host "Validation failed: Background Blue does not match the configured value."
    exit 1
}


# ------------------------------------------------------------------------------
# FOREGROUND COLOR
# ------------------------------------------------------------------------------

$ForegroundRed = Get-ItemProperty `
    -Path $PolicyPath `
    -Name "3" `
    -ErrorAction SilentlyContinue

$ForegroundGreen = Get-ItemProperty `
    -Path $PolicyPath `
    -Name "4" `
    -ErrorAction SilentlyContinue

$ForegroundBlue = Get-ItemProperty `
    -Path $PolicyPath `
    -Name "5" `
    -ErrorAction SilentlyContinue

if ($null -eq $ForegroundRed -or $ForegroundRed.'3' -ne $ForegroundColor[0]) {
    Write-Host "Validation failed: Foreground Red does not match the configured value."
    exit 1
}

if ($null -eq $ForegroundGreen -or $ForegroundGreen.'4' -ne $ForegroundColor[1]) {
    Write-Host "Validation failed: Foreground Green does not match the configured value."
    exit 1
}

if ($null -eq $ForegroundBlue -or $ForegroundBlue.'5' -ne $ForegroundColor[2]) {
    Write-Host "Validation failed: Foreground Blue does not match the configured value."
    exit 1
}


# ------------------------------------------------------------------------------
# CUSTOM TEXT
# ------------------------------------------------------------------------------

$Text = Get-ItemProperty `
    -Path $PolicyPath `
    -Name "Text" `
    -ErrorAction SilentlyContinue

if ($null -eq $Text -or $Text.Text -ne $BannerText) {
    Write-Host "Validation failed: Custom Banner Text does not match the configured value."
    exit 1
}


# ==============================================================================
# START SYSTEMBANNER
# ==============================================================================

$exePath = "C:\Program Files\SystemBanner\SystemBanner.exe"

if (-not (Test-Path -LiteralPath $exePath -PathType Leaf)) {
    Write-Host "SystemBanner executable was not found: $exePath"
    exit 1
}

try {
    Stop-Process -Name "SystemBanner" -Force -ErrorAction SilentlyContinue

    Start-Process `
        -FilePath $exePath `
        -ErrorAction Stop
}
catch {
    Write-Host "SystemBanner configuration is correct, but the application failed to start: $($_.Exception.Message)"
    exit 1
}


# ==============================================================================
# COMPLETE
# ==============================================================================

Write-Host "SystemBanner custom TS//SAR configuration is correct and has been started."

exit 0