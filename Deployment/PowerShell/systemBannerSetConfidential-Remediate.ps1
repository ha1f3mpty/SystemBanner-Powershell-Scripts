# ============================================================
# SystemBanner - Confidential Remediation
# ============================================================

$PolicyPath = "HKLM:\Software\Policies\SystemBanner"
$exePath    = "C:\Program Files\SystemBanner\SystemBanner.exe"

try {
    if (-not (Test-Path -LiteralPath $PolicyPath)) {
        New-Item -Path $PolicyPath -Force -ErrorAction Stop | Out-Null
    }

    New-ItemProperty -Path $PolicyPath -Name "Simple" -PropertyType DWord -Value 3 -Force -ErrorAction Stop | Out-Null
    New-ItemProperty -Path $PolicyPath -Name "TopAndBottom" -PropertyType DWord -Value 0 -Force -ErrorAction Stop | Out-Null
}
catch {
    Write-Host "SystemBanner Confidential configuration failed: $($_.Exception.Message)"
    exit 1
}

$Simple   = Get-ItemProperty -Path $PolicyPath -Name "Simple" -ErrorAction SilentlyContinue
$Position = Get-ItemProperty -Path $PolicyPath -Name "TopAndBottom" -ErrorAction SilentlyContinue

if ($null -eq $Simple -or $Simple.Simple -ne 3) {
    Write-Host "Validation failed: Simple Classification is not set to CONFIDENTIAL."
    exit 1
}

if ($null -eq $Position -or $Position.TopAndBottom -ne 0) {
    Write-Host "Validation failed: Banner Position is not set to TOP ONLY."
    exit 1
}

try {
    Start-Process -FilePath $exePath -ErrorAction Stop
}
catch {
    Write-Host "SystemBanner configuration is correct, but the application failed to start: $($_.Exception.Message)"
    exit 1
}

Write-Host "SystemBanner is correctly configured for CONFIDENTIAL, TOP ONLY and has been started."
exit 0