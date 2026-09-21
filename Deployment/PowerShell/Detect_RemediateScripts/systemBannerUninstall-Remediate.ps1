# ============================================================
# SystemBanner - Uninstall / Remediation
#
# Exit codes:
#   0 = SystemBanner completely uninstalled
#   1 = Uninstall failed
# ============================================================


# ------------------------------------------------------------
# Paths
# ------------------------------------------------------------

$installPath = "C:\Program Files\SystemBanner"
$exePath     = Join-Path $installPath "SystemBanner.exe"

$admxPath = "C:\Windows\PolicyDefinitions\SystemBanner.admx"
$admlPath = "C:\Windows\PolicyDefinitions\en-US\SystemBanner.adml"

$appCompatPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"
$runPath       = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$policyPath    = "HKLM:\Software\Policies\SystemBanner"


# ------------------------------------------------------------
# Stop SystemBanner
# ------------------------------------------------------------

Stop-Process `
    -Name "SystemBanner" `
    -Force `
    -ErrorAction SilentlyContinue


# ============================================================
# REMOVE SYSTEMBANNER
# ============================================================

try {

    # --------------------------------------------------------
    # Remove startup entry
    # --------------------------------------------------------

    Remove-ItemProperty `
        -Path $runPath `
        -Name "SystemBanner" `
        -ErrorAction SilentlyContinue


    # --------------------------------------------------------
    # Remove High DPI compatibility setting
    # --------------------------------------------------------

    Remove-ItemProperty `
        -Path $appCompatPath `
        -Name $exePath `
        -ErrorAction SilentlyContinue


    # --------------------------------------------------------
    # Remove SystemBanner policy configuration
    # --------------------------------------------------------

    if (Test-Path -LiteralPath $policyPath) {

        Remove-Item `
            -LiteralPath $policyPath `
            -Recurse `
            -Force `
            -ErrorAction Stop
    }


    # --------------------------------------------------------
    # Remove application directory
    # --------------------------------------------------------

    if (Test-Path -LiteralPath $installPath) {

        Remove-Item `
            -LiteralPath $installPath `
            -Recurse `
            -Force `
            -ErrorAction Stop
    }


    # --------------------------------------------------------
    # Remove ADMX
    # --------------------------------------------------------

    if (Test-Path -LiteralPath $admxPath) {

        Remove-Item `
            -LiteralPath $admxPath `
            -Force `
            -ErrorAction Stop
    }


    # --------------------------------------------------------
    # Remove ADML
    # --------------------------------------------------------

    if (Test-Path -LiteralPath $admlPath) {

        Remove-Item `
            -LiteralPath $admlPath `
            -Force `
            -ErrorAction Stop
    }

}
catch {
    Write-Host "SystemBanner uninstall failed: $($_.Exception.Message)"
    exit 1
}


# ============================================================
# VALIDATE UNINSTALL
# ============================================================

$uninstallValid = $true


# Installation directory
if (Test-Path -LiteralPath $installPath) {
    Write-Host "Validation failed: SystemBanner installation directory still exists."
    $uninstallValid = $false
}


# ADMX
if (Test-Path -LiteralPath $admxPath) {
    Write-Host "Validation failed: SystemBanner.admx still exists."
    $uninstallValid = $false
}


# ADML
if (Test-Path -LiteralPath $admlPath) {
    Write-Host "Validation failed: SystemBanner.adml still exists."
    $uninstallValid = $false
}


# Startup entry
$runValue = Get-ItemProperty `
    -Path $runPath `
    -Name "SystemBanner" `
    -ErrorAction SilentlyContinue

if ($null -ne $runValue) {
    Write-Host "Validation failed: SystemBanner startup entry still exists."
    $uninstallValid = $false
}


# High DPI compatibility entry
$appCompatValue = Get-ItemProperty `
    -Path $appCompatPath `
    -Name $exePath `
    -ErrorAction SilentlyContinue

if ($null -ne $appCompatValue) {
    Write-Host "Validation failed: SystemBanner compatibility setting still exists."
    $uninstallValid = $false
}


# Policy configuration
if (Test-Path -LiteralPath $policyPath) {
    Write-Host "Validation failed: SystemBanner policy configuration still exists."
    $uninstallValid = $false
}


# Make sure process is no longer running
if (Get-Process -Name "SystemBanner" -ErrorAction SilentlyContinue) {
    Write-Host "Validation failed: SystemBanner process is still running."
    $uninstallValid = $false
}


# ============================================================
# FINAL RESULT
# ============================================================

if ($uninstallValid) {
    Write-Host "SystemBanner has been completely uninstalled."
    exit 0
}

Write-Host "SystemBanner uninstall validation failed."
exit 1