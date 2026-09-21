<#
# SystemBanner - Standalone Installation / Configuration
## PURPOSE

This script performs a complete standalone installation and initial
configuration of SystemBanner.

The script is intended to be run directly from the SystemBanner installation
package and does not depend on a separate detection, remediation, or Group
Policy configuration script.

The installation performs the following operations:
 
1. Verifies Administrator privileges.
2. Stops any existing SystemBanner process.
3. Creates the SystemBanner installation directory.
4. Copies the SystemBanner application files.
5. Installs the SystemBanner ADMX policy template.
6. Installs the SystemBanner ADML language file.
7. Configures High DPI awareness compatibility.
8. Configures machine-wide automatic startup.
9. Configures the initial SystemBanner policy.
10. Removes obsolete custom policy values.
11. Validates the complete installation.
12. Starts SystemBanner.

## INITIAL CONFIGURATION

The initial configuration provided by this script is:
 
Classification : UNCLASSIFIED
Position       : TOP ONLY
Startup        : ENABLED FOR ALL USERS

SystemBanner ADMX policy values:
 
Simple        = 1
TopAndBottom  = 0

The custom text and custom color values are removed during installation.

This is intentional. The built-in UNCLASSIFIED classification is used instead
of a custom classification for the initial deployment.

================================================================================
SOURCE DIRECTORY STRUCTURE
==========================

The script expects to be located at the root of the installation package.

Expected structure:
 
<Script Directory>
|
+-- Code
|   |
|   +-- SystemBanner
|       |
|       +-- SystemBanner
|           |
|           +-- bin
|               |
|               +-- Release
|                   |
|                   +-- SystemBanner.exe
|                   +-- other application files
|
+-- Group Policy
    |
    +-- SystemBanner.admx
    |
    +-- en-US
        |
        +-- SystemBanner.adml

The application files are copied from: Code\SystemBanner\SystemBanner\bin\Release\

The policy files are copied to the Windows PolicyDefinitions directory.

================================================================================
INSTALLATION LOCATIONS
======================

Application: C:\Program Files\SystemBanner

Executable: C:\Program Files\SystemBanner\SystemBanner.exe

Machine Group Policy template: C:\Windows\PolicyDefinitions\SystemBanner.admx

English language policy template: C:\Windows\PolicyDefinitions\en-US\SystemBanner.adml

================================================================================
REGISTRY LOCATIONS
==================

High DPI compatibility key path: HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers 
    value of type: REG_SZ (string)
    name value is: the complete path to SystemBanner.exe
    data value is: ~ HIGHDPIAWARE

Machine-wide startup key: HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
    value of type: REG_SZ (string)
    name value is: SystemBanner
    data value is: C:\Program Files\SystemBanner\SystemBanner.exe
 
================================================================================
SYSTEMBANNER POLICY CONFIGURATION
=================================
All SystemBanner policies defined by the ADMX are MACHINE policies.

The SystemBanner ADMX defines the following policy settings.

---

SystemBanner policy configuration key: HKLM\Software\Policies\SystemBanner

    value type of: DWORD
    name value is: Simple
    data value is: singular choice from 0-6
    
 
    Possible values:
    
    0 = UNCONFIGURED
    1 = UNCLASSIFIED
    2 = CUI
    3 = CONFIDENTIAL
    4 = SECRET
    5 = TOP SECRET
    6 = TOP SECRET SCI
 

    When Simple is set to a value from 1 through 6, SystemBanner uses the
    corresponding built-in classification.

    When Simple is set to 0, SystemBanner is UNCONFIGURED and the custom
    classification settings can be used.

    Initial installation:
    
    Simple = 1

    Therefore the initial installation displays:
    
    "UNCLASSIFIED" on a green background with a white foreground

    ---

    ## Banner Position

    value type of: DWORD
    name value is: TopAndBottom
    data value is: 0 or 1
    
    
    Possible values:

    0 = TOP ONLY
    1 = TOP AND BOTTOM
    
    Initial installation:
    
    TopAndBottom = 0

    Therefore the initial installation displays the banner at the top only.

    ---

## Custom Background Color

    Custom background colors are used when: HKLM\Software\Policies\SystemBanner\Simple = 0
    
    names: 
        0 = Red component
        1 = Green component
        2 = Blue component
    type:DWORD
    
    Valid component values: 0 - 255
    
    The three values combine to form an RGB color.

    Example: 
        Red(0)   = 255
        Green(1) = 140
        Blue(2)  = 0
        

    This produces: RGB(255, 140, 0) which is approximately Orange.

---

## Custom Foreground Color

    Custom foreground colors are used when: HKLM\Software\Policies\SystemBanner\Simple = 0

    names: 
        3 = Red component
        4 = Green component
        5 = Blue component
    type:DWORD

    Valid component values: 0 - 255

    The three values combine to form the RGB foreground/text color.

    Example: 
        Red(3)   = 0
        Green(4) = 0
        Blue(5)  = 0

    This produces: RGB(0, 0, 0) which is Black.

---

## Custom Text

    Custom text is used when: HKLM\Software\Policies\SystemBanner\Simple = 0

        value type of: REG_SZ (string)
        name value is: Text
        data value is: any valid string

    Example:
    
    TOP SECRET//SAR-RED CAR/SAR-TIN BAKER//WAIVED

================================================================================
Simple configuration override
=============================
When Simple is configured to a built-in classification, 1-6, such as UNCLASSIFIED (1),
the selected built-in classification overrides any custom text or color configuration.

================================================================================
CUSTOM CONFIGURATION EXAMPLES
=============================

The following examples document how the same installation can be adapted for
other SystemBanner configurations.

These examples are documentation only. The actual initial configuration in
this script remains UNCLASSIFIED / TOP ONLY.

---

## Custom Classification

To use custom text and custom colors:

Simple = 0

Background color:
0 = Background Red
1 = Background Green
2 = Background Blue

Foreground (text) color:
3 = Foreground Red
4 = Foreground Green
5 = Foreground Blue
 
Custom text:
Text = any valid string

Example:
 
Simple = 0
TopAndBottom = 0
Text = TOP SECRET//SAR-RED CAR/SAR-TIN BAKER//WAIVED

0 = 255
1 = 140
2 = 0

3 = 0
4 = 0
5 = 0

This produces a custom orange background with black text.

================================================================================
IMPORTANT CONFIGURATION BEHAVIOR
================================

The SystemBanner ADMX and ADML file instalaltion establishes configuration via 
local gpedit.msc, or Group Policy. The direct registry manipulation is a method
if those methods are not available to you, such as Intune deployment of Windows 
Home edition, or you just like direct registry manipulation.

================================================================================
STARTUP BEHAVIOR
================

SystemBanner run at start is configured in the key path: HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
 
This is a machine-wide startup location.

set a new value of type: REG_SZ (string)
with a name value of: SystemBanner
and a data value of: C:\Program Files\SystemBanner\SystemBanner.exe [path to systembanner executable]

This allows SystemBanner to start automatically when users log on.

The script also starts SystemBanner immediately after successful installation.

================================================================================
#>

# ============================================================
# REQUIRE ADMINISTRATOR PRIVILEGES
# ============================================================

$isAdmin = ([Security.Principal.WindowsPrincipal]([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "SystemBanner installation failed: Administrator privileges are required."
    Break
}

# ============================================================
# PATHS
# ============================================================

$sourceRoot = $PSScriptRoot

$installPath = "C:\Program Files\SystemBanner"
$exePath = Join-Path $installPath "SystemBanner.exe"

$appSource = Join-Path $sourceRoot "Code\SystemBanner\SystemBanner\bin\Release\SystemBanner*"

$admxSource = Join-Path $sourceRoot "Group Policy\SystemBanner.admx"
$admlSource = Join-Path $sourceRoot "Group Policy\en-US\SystemBanner.adml"

$policyDefinitionsPath = "C:\Windows\PolicyDefinitions"
$policyDefinitionsEnUsPath = Join-Path $policyDefinitionsPath "en-US"

$admxPath = Join-Path $policyDefinitionsPath "SystemBanner.admx"
$admlPath = Join-Path $policyDefinitionsEnUsPath "SystemBanner.adml"

$appCompatPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"
$runPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$policyPath = "HKLM:\Software\Policies\SystemBanner"

# ============================================================
# INITIAL CONFIGURATION
# ============================================================

<# Built-in classification:
0 = UNCONFIGURED
1 = UNCLASSIFIED
2 = CUI
3 = CONFIDENTIAL
4 = SECRET
5 = TOP SECRET
6 = TOP SECRET SCI
#>

$SimpleClassificationSetting = 1

<# Banner position:
0 = TOP ONLY
1 = TOP AND BOTTOM
#>

$BannerPositionSetting = 0

# Machine-wide startup command.

$RunCommand = $exePath

# ============================================================
# STOP EXISTING SYSTEMBANNER
# ============================================================

Write-Host "Stopping any existing SystemBanner process..."

Stop-Process -Name "SystemBanner" -Force -ErrorAction SilentlyContinue

# ============================================================
# VALIDATE INSTALLATION SOURCE
# ============================================================

if (-not (Test-Path -LiteralPath $admxSource -PathType Leaf)) {
    Write-Host "SystemBanner cannot continue: Source SystemBanner.admx was not found."
    Break
}

if (-not (Test-Path -LiteralPath $admlSource -PathType Leaf)) {
    Write-Host "SystemBanner cannot continue: Source SystemBanner.adml was not found."
    Break
}

$releasePath = Join-Path $sourceRoot "Code\SystemBanner\SystemBanner\bin\Release"

if (-not (Test-Path -LiteralPath $releasePath -PathType Container)) {
    Write-Host "SystemBanner cannot continue: Source Application Release directory was not found."
    Break
}

# ============================================================
# INSTALL APPLICATION AND SUPPORTING FILES
# ============================================================

try {
    Write-Host "Creating SystemBanner installation directory..."
        
    New-Item -ItemType Directory -Path $installPath -Force -ErrorAction Stop | Out-Null

    Write-Host "Copying SystemBanner application files..."

    Copy-Item -Path $appSource -Destination $installPath -Force -ErrorAction Stop

    Write-Host "Creating PolicyDefinitions en-US directory..."

    New-Item -ItemType Directory -Path $policyDefinitionsEnUsPath -Force -ErrorAction Stop | Out-Null

    Write-Host "Installing SystemBanner ADMX..."

    Copy-Item -Path $admxSource -Destination $admxPath -Force -ErrorAction Stop

    Write-Host "Installing SystemBanner ADML..."

    Copy-Item -Path $admlSource -Destination $admlPath -Force -ErrorAction Stop

    Write-Host "Configuring High DPI compatibility..."

    New-ItemProperty -Path $appCompatPath -Name $exePath -PropertyType String -Value "~ HIGHDPIAWARE" -Force -ErrorAction Stop | Out-Null

    Write-Host "Configuring machine-wide SystemBanner startup..."

    New-ItemProperty -Path $runPath -Name "SystemBanner" -PropertyType String -Value $RunCommand -Force -ErrorAction Stop | Out-Null
    
}
catch {
    Write-Host "SystemBanner installation failed: $($_.Exception.Message)"
    Break
}

# ============================================================
# VALIDATE INSTALLATION
# ============================================================

Write-Host "Validating SystemBanner installation..."

$installationValid = $true

if (-not (Test-Path -LiteralPath $exePath -PathType Leaf)) {
    Write-Host "Installation validation failed: SystemBanner.exe was not found."
    $installationValid = $false
}

if (-not (Test-Path -LiteralPath $admxPath -PathType Leaf)) {
    Write-Host "Installation validation failed: SystemBanner.admx was not found."
    $installationValid = $false
}

if (-not (Test-Path -LiteralPath $admlPath -PathType Leaf)) {
    Write-Host "Installation validation failed: SystemBanner.adml was not found."
    $installationValid = $false
}

$appCompatValue = Get-ItemProperty -Path $appCompatPath -Name $exePath -ErrorAction SilentlyContinue

if ($null -eq $appCompatValue -or $appCompatValue.$exePath -ne "~ HIGHDPIAWARE") {
    Write-Host "Installation validation failed: High DPI compatibility setting is missing or incorrect."
    $installationValid = $false
}

$runValue = Get-ItemProperty -Path $runPath -Name "SystemBanner" -ErrorAction SilentlyContinue

if ($null -eq $runValue -or $runValue.SystemBanner -ne $RunCommand) {
    Write-Host "Installation validation failed: SystemBanner startup entry is missing or incorrect."
    $installationValid = $false
}

if (-not $installationValid) {
    Write-Host "SystemBanner installation validation failed."
    Break
}

# ============================================================
# CONFIGURE SYSTEMBANNER POLICY
# ============================================================

try {
    Write-Host "Creating SystemBanner policy registry key..."

    New-Item -ItemType Directory -Path $policyPath -Force -ErrorAction Stop | Out-Null

    # --------------------------------------------------------
    # Configure built-in UNCLASSIFIED classification.
    # --------------------------------------------------------

    Write-Host "Configuring classification: UNCLASSIFIED..."

    New-ItemProperty -Path $policyPath -Name "Simple" -PropertyType DWord -Value $SimpleClassificationSetting -Force -ErrorAction Stop | Out-Null

    # --------------------------------------------------------
    # Configure banner position: TOP ONLY.
    # --------------------------------------------------------

    Write-Host "Configuring banner position: TOP ONLY..."

    New-ItemProperty -Path $policyPath -Name "TopAndBottom" -PropertyType DWord -Value $BannerPositionSetting -Force -ErrorAction Stop | Out-Null

    <# 
    --------------------------------------------------------
    Remove custom classification values.
    These values are only used when Simple = 0.

    Removing them ensures that an existing custom
    configuration does not remain on the machine.
    --------------------------------------------------------
    If you want to use custom classification values, set Simple = 0 and move 
    this comment block end designator past the foreach loop below #>

    $customPolicyValues = @(
        "0",
        "1",
        "2",
        "3",
        "4",
        "5",
        "Text"
    )

    foreach ($valueName in $customPolicyValues) {
        Remove-ItemProperty -Path $policyPath -Name $valueName -ErrorAction SilentlyContinue
    } 
    # If you want to use custom classification values, move the comment block end designator here.

} catch {
    Write-Host "SystemBanner configuration failed: $($_.Exception.Message)"
    Break
}

# ============================================================
# VALIDATE CONFIGURATION
# ============================================================

Write-Host "Validating SystemBanner configuration..."

$configurationValid = $true

$policy = Get-ItemProperty -Path $policyPath -ErrorAction SilentlyContinue

if ($null -eq $policy) {
    Write-Host "Configuration validation failed: SystemBanner policy key does not exist."
    $configurationValid = $false
} else {
 
    # --------------------------------------------------------
    # Validate classification.
    # --------------------------------------------------------

    if ($null -eq $policy.Simple -or $policy.Simple -ne $SimpleClassificationSetting) {
        Write-Host "Configuration validation failed: Classification is not UNCLASSIFIED."
        $configurationValid = $false
    }

    # --------------------------------------------------------
    # Validate banner position.
    # --------------------------------------------------------

    if ($null -eq $policy.TopAndBottom -or $policy.TopAndBottom -ne $BannerPositionSetting) {
        Write-Host "Configuration validation failed: Banner position is not TOP ONLY."
        $configurationValid = $false
    }

    # --------------------------------------------------------
    # Validate that custom configuration values are absent.
    # --------------------------------------------------------

    foreach ($valueName in $customPolicyValues) {
        $customValue = Get-ItemProperty -Path $policyPath -Name $valueName -ErrorAction SilentlyContinue

        if ($null -ne $customValue) {
            Write-Host "Configuration validation failed: Custom policy value '$valueName' still exists."
            $configurationValid = $false
        }
    }
}

if (-not $configurationValid) {
    Write-Host "SystemBanner installation is valid, but configuration validation failed."
    Break
}

# ============================================================
# START SYSTEMBANNER
# ============================================================

try {
    Write-Host "Starting SystemBanner..."

    Start-Process -FilePath $exePath -ErrorAction Stop
}
catch {
    Write-Host "SystemBanner configuration is valid, but the application could not be started: $($_.Exception.Message)"
    Break
}

# ============================================================
# FINAL RESULT
# ============================================================

Write-Host ""
Write-Host "============================================================"
Write-Host "SystemBanner installation completed successfully."
Write-Host "Classification : UNCLASSIFIED"
Write-Host "Position       : TOP ONLY"
Write-Host "Startup        : ENABLED FOR ALL USERS"
Write-Host "============================================================"
# SIG # Begin signature block
# MIIdrAYJKoZIhvcNAQcCoIIdnTCCHZkCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCvfK+R9QtmGB65
# fcny4PxdTb8uw0o7RFwC1IG5g9VnLqCCF2YwggQoMIICkKADAgECAhAzPyNNUcDa
# q0/+gFiYhInPMA0GCSqGSIb3DQEBCwUAMCwxKjAoBgNVBAMMIU1pa2UgTGFuZSBQ
# b3dlclNoZWxsIENvZGUgU2lnbmluZzAeFw0yNjA5MDMxNTEyMjdaFw0zMTA5MDMx
# NTIyMjdaMCwxKjAoBgNVBAMMIU1pa2UgTGFuZSBQb3dlclNoZWxsIENvZGUgU2ln
# bmluZzCCAaIwDQYJKoZIhvcNAQEBBQADggGPADCCAYoCggGBALT/ONjRJ3+H+cvh
# UrN4JgAmBYPMXnyJSxYxsYYJ3vwW4X74h5sUic6VNSLj50yzf38G83A4o/p/MnXz
# nkvuZBFD2R5RdZWV0WED1fSKHd13XP8myoQtQ7A5EA4x7a+1rMeF06dLtBdp+YH6
# 5QG96dombokCeDoD327OC4svNidqxmZKiHAVPUoMD/gt/IIZmlmNK3aaZjdjj3Vu
# llwXZZj4g/vkJKJbRKB2iyV0QWpSVw5G5k+ok60vs8PkNy1bXTzjJIFi8sUkgA3j
# dye9f+kpKGuxqjbVQjfH8D4kQJ5OEaR3+8lMdxElITqaYprMqWdJ6p2G+FZHk57T
# iR0XuhPTUDpM9AYr8FEllBNEvE+KoxAdW4gtQCZIoXNGRsBeG4CUU3dq7AuboygS
# ngsN9TiCN8ghImDAyvp0XXOqoSAbuTbmSX8aLO2szTAc2vqwikYXuuE+6uZ++clH
# 3k6m3eBOSKvk33vuDG/rTDF1bVuSvLoCtuH5+GswKC4k6eUmeQIDAQABo0YwRDAO
# BgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0OBBYEFGCR
# +1JnfU79XA3Ko/OgkyzLVMiCMA0GCSqGSIb3DQEBCwUAA4IBgQCt46a9U6GzgOuj
# UEy37uRWFGLrJxbSeepdXCRD52s4MrjzUo2KYC/4OVLOvwiWu4F1ggRQNrrT2uLJ
# 1RkvgjHOB2PKnj3ZwonFWmGnK2Lfjb8JAhjmm+9wDXbllGDqR00BFjVNvcejFYm/
# /YQ8bOs2RW+WILxnKkCdJBk2pi3+9OO+T19R+zZ5ZdaJEDjrECYyGU3Wgk/ILafD
# 4deLmm6VgLSh5ShjValE67X3YQDmtI1GiCN3uUiVigEScHXyBzzN0DkKDq/KZwMW
# TKSJXe+8ATB/2ROqXZtLP8aLS3TxVvSdeZFmJch/E3nhEq5ZH8IquyXRsb/Nt6JN
# 6JnCOINEeW+xSW6PbuWbwBI3Vc3ckkxpNsbZ1J7lbiwnxDV7xxQ+gO78nplzsFED
# BczOmy0h37zIxDcZVB0Xmx9sM/O7XaSj0VBEFsJ6jhkCPiPwiy69Q8gYBlD4dU5V
# dPURzVJQYBVdEZ/yW/jzIhYeBVHZ6OeFWWhjb8WAx5JAAPsGO04wggWNMIIEdaAD
# AgECAhAOmxiO+dAt5+/bUOIIQBhaMA0GCSqGSIb3DQEBDAUAMGUxCzAJBgNVBAYT
# AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2Vy
# dC5jb20xJDAiBgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0y
# MjA4MDEwMDAwMDBaFw0zMTExMDkyMzU5NTlaMGIxCzAJBgNVBAYTAlVTMRUwEwYD
# VQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAf
# BgNVBAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBHNDCCAiIwDQYJKoZIhvcNAQEB
# BQADggIPADCCAgoCggIBAL/mkHNo3rvkXUo8MCIwaTPswqclLskhPfKK2FnC4Smn
# PVirdprNrnsbhA3EMB/zG6Q4FutWxpdtHauyefLKEdLkX9YFPFIPUh/GnhWlfr6f
# qVcWWVVyr2iTcMKyunWZanMylNEQRBAu34LzB4TmdDttceItDBvuINXJIB1jKS3O
# 7F5OyJP4IWGbNOsFxl7sWxq868nPzaw0QF+xembud8hIqGZXV59UWI4MK7dPpzDZ
# Vu7Ke13jrclPXuU15zHL2pNe3I6PgNq2kZhAkHnDeMe2scS1ahg4AxCN2NQ3pC4F
# fYj1gj4QkXCrVYJBMtfbBHMqbpEBfCFM1LyuGwN1XXhm2ToxRJozQL8I11pJpMLm
# qaBn3aQnvKFPObURWBf3JFxGj2T3wWmIdph2PVldQnaHiZdpekjw4KISG2aadMre
# Sx7nDmOu5tTvkpI6nj3cAORFJYm2mkQZK37AlLTSYW3rM9nF30sEAMx9HJXDj/ch
# srIRt7t/8tWMcCxBYKqxYxhElRp2Yn72gLD76GSmM9GJB+G9t+ZDpBi4pncB4Q+U
# DCEdslQpJYls5Q5SUUd0viastkF13nqsX40/ybzTQRESW+UQUOsxxcpyFiIJ33xM
# dT9j7CFfxCBRa2+xq4aLT8LWRV+dIPyhHsXAj6KxfgommfXkaS+YHS312amyHeUb
# AgMBAAGjggE6MIIBNjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTs1+OC0nFd
# ZEzfLmc/57qYrhwPTzAfBgNVHSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823IDzAO
# BgNVHQ8BAf8EBAMCAYYweQYIKwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRw
# Oi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRz
# LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcnQwRQYDVR0f
# BD4wPDA6oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNz
# dXJlZElEUm9vdENBLmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQEM
# BQADggEBAHCgv0NcVec4X6CjdBs9thbX979XB72arKGHLOyFXqkauyL4hxppVCLt
# pIh3bb0aFPQTSnovLbc47/T/gLn4offyct4kvFIDyE7QKt76LVbP+fT3rDB6mouy
# XtTP0UNEm0Mh65ZyoUi0mcudT6cGAxN3J0TU53/oWajwvy8LpunyNDzs9wPHh6jS
# TEAZNUZqaVSwuKFWjuyk1T3osdz9HNj0d1pcVIxv76FQPfx2CWiEn2/K2yCNNWAc
# AgPLILCsWKAOQGPFmCLBsln1VWvPJ6tsds5vIy30fnFqI2si/xK4VC0nftg62fC2
# h5b9W9FcrBjDTZ9ztwGpn1eqXijiuZQwgga0MIIEnKADAgECAhANx6xXBf8hmS5A
# QyIMOkmGMA0GCSqGSIb3DQEBCwUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxE
# aWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMT
# GERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBHNDAeFw0yNTA1MDcwMDAwMDBaFw0zODAx
# MTQyMzU5NTlaMGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5j
# LjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBUaW1lU3RhbXBpbmcgUlNB
# NDA5NiBTSEEyNTYgMjAyNSBDQTEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIK
# AoICAQC0eDHTCphBcr48RsAcrHXbo0ZodLRRF51NrY0NlLWZloMsVO1DahGPNRcy
# bEKq+RuwOnPhof6pvF4uGjwjqNjfEvUi6wuim5bap+0lgloM2zX4kftn5B1IpYzT
# qpyFQ/4Bt0mAxAHeHYNnQxqXmRinvuNgxVBdJkf77S2uPoCj7GH8BLuxBG5AvftB
# dsOECS1UkxBvMgEdgkFiDNYiOTx4OtiFcMSkqTtF2hfQz3zQSku2Ws3IfDReb6e3
# mmdglTcaarps0wjUjsZvkgFkriK9tUKJm/s80FiocSk1VYLZlDwFt+cVFBURJg6z
# MUjZa/zbCclF83bRVFLeGkuAhHiGPMvSGmhgaTzVyhYn4p0+8y9oHRaQT/aofEnS
# 5xLrfxnGpTXiUOeSLsJygoLPp66bkDX1ZlAeSpQl92QOMeRxykvq6gbylsXQskBB
# BnGy3tW/AMOMCZIVNSaz7BX8VtYGqLt9MmeOreGPRdtBx3yGOP+rx3rKWDEJlIqL
# XvJWnY0v5ydPpOjL6s36czwzsucuoKs7Yk/ehb//Wx+5kMqIMRvUBDx6z1ev+7ps
# NOdgJMoiwOrUG2ZdSoQbU2rMkpLiQ6bGRinZbI4OLu9BMIFm1UUl9VnePs6BaaeE
# WvjJSjNm2qA+sdFUeEY0qVjPKOWug/G6X5uAiynM7Bu2ayBjUwIDAQABo4IBXTCC
# AVkwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQU729TSunkBnx6yuKQVvYv
# 1Ensy04wHwYDVR0jBBgwFoAU7NfjgtJxXWRM3y5nP+e6mK4cD08wDgYDVR0PAQH/
# BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMIMHcGCCsGAQUFBwEBBGswaTAkBggr
# BgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEEGCCsGAQUFBzAChjVo
# dHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0
# LmNydDBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsMy5kaWdpY2VydC5jb20v
# RGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNybDAgBgNVHSAEGTAXMAgGBmeBDAEEAjAL
# BglghkgBhv1sBwEwDQYJKoZIhvcNAQELBQADggIBABfO+xaAHP4HPRF2cTC9vgvI
# tTSmf83Qh8WIGjB/T8ObXAZz8OjuhUxjaaFdleMM0lBryPTQM2qEJPe36zwbSI/m
# S83afsl3YTj+IQhQE7jU/kXjjytJgnn0hvrV6hqWGd3rLAUt6vJy9lMDPjTLxLgX
# f9r5nWMQwr8Myb9rEVKChHyfpzee5kH0F8HABBgr0UdqirZ7bowe9Vj2AIMD8liy
# rukZ2iA/wdG2th9y1IsA0QF8dTXqvcnTmpfeQh35k5zOCPmSNq1UH410ANVko43+
# Cdmu4y81hjajV/gxdEkMx1NKU4uHQcKfZxAvBAKqMVuqte69M9J6A47OvgRaPs+2
# ykgcGV00TYr2Lr3ty9qIijanrUR3anzEwlvzZiiyfTPjLbnFRsjsYg39OlV8cipD
# oq7+qNNjqFzeGxcytL5TTLL4ZaoBdqbhOhZ3ZRDUphPvSRmMThi0vw9vODRzW6Ax
# nJll38F0cuJG7uEBYTptMSbhdhGQDpOXgpIUsWTjd6xpR6oaQf/DJbg3s6KCLPAl
# Z66RzIg9sC+NJpud/v4+7RWsWCiKi9EOLLHfMR2ZyJ/+xhCx9yHbxtl5TPau1j/1
# MIDpMPx0LckTetiSuEtQvLsNz3Qbp7wGWqbIiOWCnb5WqxL3/BAPvIXKUjPSxyZs
# q8WhbaM2tszWkPZPubdcMIIG7TCCBNWgAwIBAgIQCE/cM09+RU7bww+P+ZIYNTAN
# BgkqhkiG9w0BAQsFADBpMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQs
# IEluYy4xQTA/BgNVBAMTOERpZ2lDZXJ0IFRydXN0ZWQgRzQgVGltZVN0YW1waW5n
# IFJTQTQwOTYgU0hBMjU2IDIwMjUgQ0ExMB4XDTI2MDgwNTAwMDAwMFoXDTM3MTEw
# NDIzNTk1OVowYzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMu
# MTswOQYDVQQDEzJEaWdpQ2VydCBTSEEyNTYgUlNBNDA5NiBUaW1lc3RhbXAgUmVz
# cG9uZGVyIDIwMjYgMTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALZ7
# pvLJ/s1K+NSbTGWz/TjGMPh8CQ6RucZCLv5anHzWJjF/NWJrFIhy24fcpKXlgRik
# y4WAawDfU3YP0BMxt9l3Dm5oCG5Z69AqEN1kgHg2epx+l+lZBcmJCcN0ASURML5u
# FIS80sZsDwO3BSkUxDjLJhBI+qiZP3aixAC/qEGLjsBNlLol9VZ7pfGEXiMlneJI
# C5/YKuizVzNFKZZEeoy/0B8Zm+nzKBgSWG52lCO1w+nCg6XpCtklTJXeIg283hw7
# TmmsZXR+SMbjbrEOvZ3fP2VxIgeR28Y90ZStd3F9VuA5RVynb/whITPAo9b75Zr4
# Ta6Mj3URm26QZYMn/FnbuTegcoRcFEZ9FOqM5T6MTdtr/n74lIT/ug0eeOzmZ6QT
# Fg33otX+bFRsIolvykE1jive4PuESaT8zzVeFWDAMDtozNgLctkGD1ZjkEyZtJrL
# l5ya0m5doH/ScpaZCZVl6pNUOCybMc/kxC6EAmSJY24L0yYKD1Nkddsnb/ItVKi/
# 2nXpQNMu1PT5prW83vV8d67WowuUs0HdY4H8AMLGvdL/WHEj3ZnqMqAQQP9u3Ai9
# t+5eQ02GDwy0ODjdzi0xlp70W+ow63/0++YDEX1M0iwgUHwbrJvfpklkZQvw3+kv
# 3vUPItdwroczk9icflf55W1zOEKAcJVAIXpcMCU9AgMBAAGjggGVMIIBkTAMBgNV
# HRMBAf8EAjAAMB0GA1UdDgQWBBQUyWOKMC7USvtulPPm40B+9ezN4jAfBgNVHSME
# GDAWgBTvb1NK6eQGfHrK4pBW9i/USezLTjAOBgNVHQ8BAf8EBAMCB4AwFgYDVR0l
# AQH/BAwwCgYIKwYBBQUHAwgwgZUGCCsGAQUFBwEBBIGIMIGFMCQGCCsGAQUFBzAB
# hhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wXQYIKwYBBQUHMAKGUWh0dHA6Ly9j
# YWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRHNFRpbWVTdGFtcGlu
# Z1JTQTQwOTZTSEEyNTYyMDI1Q0ExLmNydDBfBgNVHR8EWDBWMFSgUqBQhk5odHRw
# Oi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkRzRUaW1lU3RhbXBp
# bmdSU0E0MDk2U0hBMjU2MjAyNUNBMS5jcmwwIAYDVR0gBBkwFzAIBgZngQwBBAIw
# CwYJYIZIAYb9bAcBMA0GCSqGSIb3DQEBCwUAA4ICAQCNxTphHp1SCt+ZrAmAfn0o
# QLFr0mLywSLaDXQIENoyKqxrFbJblzCVP/pkXmwXOdrOpWygLzlT12os5ipDCy35
# RBCg2UMeApEtrfGhz45F4Wt4WGdNdIbRWt3YTYJmpR+b7lr4d7Uwn+H600u4D7Rn
# OGf8Wj4UNgAdZkfHhHv1mx9EVh71SJelcEN/oORSjXzdjfw1iZH9d8Nh/thn6hH2
# 3d+VsPAr6GAYyzSA02nXD1nYLI7Ijmiv+xLCiYC41DSFYL3GhTiy0PxpawPtGRya
# BVGzq+UiTfM8pD7KVyF5aQyWP4KhVGUUTnmm/RlYJoW3TiXA/+t0YcT2oRVBm3JE
# TjajHug2AL+v5jhtKVnd3D0rbHXEu27o+Q8p4sEWPMqKDB+qbceb6T/6WcwTwXmQ
# 9lOCLLYcsQeSWmvKqzpAec9etE14jOQAzLKWdE3w/TCaKtLRaRT7LCkRYVnhA2D7
# 3FLje1O5b3HR5eHs0NzU/+xX7NbEdcofy0W3Wdwd1XOqtlpg/JgwtKfZM5dqO94l
# bUveOiJBI+xZEbGRsMNbXmMREUTgu+Oca7Y73MPWcslIx2VhkSKSXjDbD6rgg39H
# 5Mh7QfieAIjWagkJNt68Yfim6cjEzVSiLSeZfdkr5dtFPTW6jATlWJdYeeDRGCya
# tf8R1hSjzSvdN8yWQPT9gzGCBZwwggWYAgEBMEAwLDEqMCgGA1UEAwwhTWlrZSBM
# YW5lIFBvd2VyU2hlbGwgQ29kZSBTaWduaW5nAhAzPyNNUcDaq0/+gFiYhInPMA0G
# CWCGSAFlAwQCAQUAoIGEMBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZI
# hvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcC
# ARUwLwYJKoZIhvcNAQkEMSIEIH6vH2+k3KFswL7nII0tY9GXLNz9r/DjeK0GVwml
# uL4kMA0GCSqGSIb3DQEBAQUABIIBgHhjbjVfQb4a9Ev+3t7CnmNO3rq+x+taOVmT
# QqPBLDmIpwoQKpvzq3TDTjjZV516xgtcIPVzr/qONjoQByoqlO0jwmCwq5XWDuzz
# +Q6OnsdkxK75NTF+/6tP/oyueowo3q+8rwvEOYQQ8eHwRyMUXzAKyJG/N+AFpLGn
# FW+QadLn2nJQ6urHUmy47ze2PnWf/XCMB4dNRUGob19zAf+w8WRjGizFop2Z942e
# T25D4coMtwZf6EUVd2fu5F9Vcj7wgVcQGRm68BEf1Ycxzfq382xfLGnE3lTFrbIN
# laRB34PrUypMDfBQNxQdIgEVYk4yiM1qHlOQ2sShAVfmEVxCnLGPskMWqejdYdHD
# 1UjMXYl6Te87tI+7A2rklwceQY3mH+l6jez46CRQZ4Hy42xR7TagEGtVbzN/T8nE
# KYDWaylrrAXc25lvSTgygOHIxPy29pz5lEl+VwGMsa6LXuo+oB4iSGPqdImiasC5
# qZq86u1OStC+UBCl/j3ZukZ9twfSdKGCAyYwggMiBgkqhkiG9w0BCQYxggMTMIID
# DwIBATB9MGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFB
# MD8GA1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBUaW1lU3RhbXBpbmcgUlNBNDA5
# NiBTSEEyNTYgMjAyNSBDQTECEAhP3DNPfkVO28MPj/mSGDUwDQYJYIZIAWUDBAIB
# BQCgaTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0y
# NjA5MTYxNjE4MjlaMC8GCSqGSIb3DQEJBDEiBCC0tF5W6G+QFuZvJ5Q+u578jJ4k
# IBCToDL+5GqgwbgPOjANBgkqhkiG9w0BAQEFAASCAgCLyxwtebAHvO/jqLWTEro4
# 80HSxT8xjxsNybgqepuoox0m2U+WTJyAM4LSWcGWcBrk1M1wM8YOaWuxDDSV1GFt
# Vf1ViGqQQtRYN+lob+CFaiU+RsZcSzCeuk73GN7BZ3n3b9LxXhImOFu/ZYxS0z10
# RqBSUQLVtnTq4YzWDXh9+HWYj7lfUZOo60FFLai5/aJKbzhlqeOIiDiKxUj+BC7o
# 5QeRFHATf+Y0VNdlIfftRSqMDPR3p/wuJVsgpw4432q4kI3eqZRPXR1tZQueOcId
# vaeO1VrTvxlEaXOkRVkf/p4if5yyvXPpnDZRpa20UanA+wand6VA/AFXb83gCbLy
# tirRl2EKamcEcEA/bBuGjzct0Jt6pfWeqg5A9PpInXsEsXLHN+X1RuTrJUiNGIgz
# melISPCbUYJ4nTmd3qgdlNqNtmOzyHY55qtFNuy88IbW31PksSBaS8QZJAADl2j4
# u2WODhe07AmtjGOch7/lbDpxXLl5YaMlDywUGYu6GHtTVxKaCCYdHHONMiHhO23c
# uVl9ykVa4N+PhHfxCMXMbO8UYdhQbU276Xq+VGhwSkY6hw4YdUwEfr+lli76PFpZ
# t8YWSgdbPA/BUdzK/b4XD3jO0bSxVucAFk/UCPoDKU0LikVZlRUth6GNAg8hvd3E
# 0JJbJnKNRMQbKDN8pqlyZg==
# SIG # End signature block
