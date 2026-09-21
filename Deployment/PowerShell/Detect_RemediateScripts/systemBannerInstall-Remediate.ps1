# ============================================================
# SystemBanner - Install / Remediation
#
# Exit codes:
#   0 = Installation is valid
#   1 = Installation failed
# ============================================================


# ------------------------------------------------------------
# Paths
# ------------------------------------------------------------

$sourceRoot  = $PSScriptRoot
$installPath = "C:\Program Files\SystemBanner"
$exePath     = Join-Path $installPath "SystemBanner.exe"

$admxSource = Join-Path $sourceRoot "Group Policy\SystemBanner.admx"
$admlSource = Join-Path $sourceRoot "Group Policy\en-US\SystemBanner.adml"

$admxPath = "C:\Windows\PolicyDefinitions\SystemBanner.admx"
$admlPath = "C:\Windows\PolicyDefinitions\en-US\SystemBanner.adml"

$appCompatPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"
$runPath       = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"


# ------------------------------------------------------------
# Stop SystemBanner if it is running
# ------------------------------------------------------------

Stop-Process -Name "SystemBanner" -Force -ErrorAction SilentlyContinue


# ============================================================
# INSTALLATION
# ============================================================

try {

    # Create installation directory
    New-Item `
        -ItemType Directory `
        -Path $installPath `
        -Force `
        -ErrorAction Stop | Out-Null


    # Copy application files
    $appSource = Join-Path `
        $sourceRoot `
        "Code\SystemBanner\SystemBanner\bin\Release\SystemBanner*"

    Copy-Item `
        -Path $appSource `
        -Destination $installPath `
        -Force `
        -ErrorAction Stop


    # Copy ADMX
    Copy-Item `
        -Path $admxSource `
        -Destination "C:\Windows\PolicyDefinitions\" `
        -Force `
        -ErrorAction Stop


    # Ensure en-US PolicyDefinitions directory exists
    New-Item `
        -ItemType Directory `
        -Path "C:\Windows\PolicyDefinitions\en-US" `
        -Force `
        -ErrorAction Stop | Out-Null


    # Copy ADML
    Copy-Item `
        -Path $admlSource `
        -Destination $admlPath `
        -Force `
        -ErrorAction Stop


    # Set High DPI awareness compatibility setting
    New-ItemProperty `
        -Path $appCompatPath `
        -Name $exePath `
        -PropertyType String `
        -Value "~ HIGHDPIAWARE" `
        -Force `
        -ErrorAction Stop | Out-Null


    # Add SystemBanner to startup
    New-ItemProperty `
        -Path $runPath `
        -Name "SystemBanner" `
        -PropertyType String `
        -Value $exePath `
        -Force `
        -ErrorAction Stop | Out-Null

}
catch {
    Write-Host "SystemBanner installation failed: $($_.Exception.Message)"
    exit 1
}


# ============================================================
# VALIDATE INSTALLATION
# ============================================================

$installationValid = $true


# SystemBanner.exe
if (-not (Test-Path -LiteralPath $exePath -PathType Leaf)) {
    Write-Host "Validation failed: SystemBanner.exe was not found."
    $installationValid = $false
}


# ADMX
if (-not (Test-Path -LiteralPath $admxPath -PathType Leaf)) {
    Write-Host "Validation failed: SystemBanner.admx was not found."
    $installationValid = $false
}


# ADML
if (-not (Test-Path -LiteralPath $admlPath -PathType Leaf)) {
    Write-Host "Validation failed: SystemBanner.adml was not found."
    $installationValid = $false
}


# High DPI compatibility setting
$appCompatValue = Get-ItemProperty `
    -Path $appCompatPath `
    -Name $exePath `
    -ErrorAction SilentlyContinue

if ($null -eq $appCompatValue -or
    $appCompatValue.$exePath -ne "~ HIGHDPIAWARE") {

    Write-Host "Validation failed: High DPI compatibility setting is missing or incorrect."
    $installationValid = $false
}


# Startup entry
$runValue = Get-ItemProperty `
    -Path $runPath `
    -Name "SystemBanner" `
    -ErrorAction SilentlyContinue

if ($null -eq $runValue -or
    $runValue.SystemBanner -ne $exePath) {

    Write-Host "Validation failed: SystemBanner startup entry is missing or incorrect."
    $installationValid = $false
}


# ============================================================
# FINAL RESULT
# ============================================================

if ($installationValid) {
    Write-Host "SystemBanner installation is valid."
    exit 0
}

Write-Host "SystemBanner installation validation failed."
exit 1