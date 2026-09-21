$installPath = "C:\Program Files\SystemBanner"
$exePath     = Join-Path $installPath "SystemBanner.exe"

$admxPath = "C:\Windows\PolicyDefinitions\SystemBanner.admx"
$admlPath = "C:\Windows\PolicyDefinitions\en-US\SystemBanner.adml"

$appCompatPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"
$runPath       = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$policyPath    = "HKLM:\Software\Policies\SystemBanner"


# Check installation files
if (Test-Path -LiteralPath $installPath) {
    Write-Host "SystemBanner installation detected."
    exit 1
}

if (Test-Path -LiteralPath $admxPath) {
    Write-Host "SystemBanner ADMX detected."
    exit 1
}

if (Test-Path -LiteralPath $admlPath) {
    Write-Host "SystemBanner ADML detected."
    exit 1
}


# Check startup entry
$runValue = Get-ItemProperty -Path $runPath -Name "SystemBanner" -ErrorAction SilentlyContinue

if ($null -ne $runValue) {
    Write-Host "SystemBanner startup entry detected."
    exit 1
}


# Check High DPI compatibility entry
$appCompatValue = Get-ItemProperty -Path $appCompatPath -Name $exePath -ErrorAction SilentlyContinue

if ($null -ne $appCompatValue) {
    Write-Host "SystemBanner compatibility setting detected."
    exit 1
}

# Check policy configuration
$policyValue = Get-ItemProperty -Path $policyPath -Name "Simple" -ErrorAction SilentlyContinue

if ($null -ne $policyValue) {
    Write-Host "SystemBanner policy configuration detected."
    exit 1
}

Write-Host "SystemBanner is not installed."
exit 0