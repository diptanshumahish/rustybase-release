# RustyBase Windows Installer

$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/diptanshumahish/rustybase-release"
$LatestReleaseApi = "https://api.github.com/repos/diptanshumahish/rustybase-release/releases/latest"

Write-Host ">> Initiating RustyBase installation sequence..." -ForegroundColor Cyan

# Detect Architecture
$Arch = $env:PROCESSOR_ARCHITECTURE
if ($Arch -eq "AMD64") {
    $TargetArch = "x86_64"
} else {
    Write-Error "[x] Unsupported architecture: $Arch. Only x64 is supported on Windows currently."
    exit 1
}

$Target = "rustybase-$TargetArch-pc-windows-msvc.exe"

# Fetch latest release tag
Write-Host ">> Searching for latest release metadata..." -ForegroundColor Cyan
try {
    $Release = Invoke-RestMethod -Uri $LatestReleaseApi
    $ReleaseTag = $Release.tag_name
} catch {
    Write-Error "[x] Error: Could not determine latest release version."
    exit 1
}

Write-Host ">> Version identified: $ReleaseTag" -ForegroundColor Cyan
$DownloadUrl = "$RepoUrl/releases/download/$ReleaseTag/$Target"

# Download binary
$TempDir = Join-Path $env:TEMP ([Guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $TempDir | Out-Null

Write-Host ">> Pulling binary from production registry..." -ForegroundColor Cyan
$DestPath = Join-Path $TempDir "rustybase.exe"
try {
    $Response = Invoke-WebRequest -Uri $DownloadUrl -OutFile $DestPath -ErrorAction Stop
    
    # Verify file size (should be > 1MB)
    $FileSize = (Get-Item $DestPath).Length
    if ($FileSize -lt 1MB) {
        throw "Downloaded file is too small ($FileSize bytes). This usually means an error page was downloaded instead of the binary."
    }
} catch {
    Write-Error "[x] Download failed. The binary for $Target could not be found in release $ReleaseTag.`n[!] Check your GitHub Action build status: $RepoUrl/actions"
    exit 1
}

# Install binary
$InstallDir = Join-Path $env:ProgramFiles "RustyBase"
if (-not (Test-Path $InstallDir)) {
    Write-Host ">> Creating installation directory: $InstallDir" -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

Write-Host ">> Deploying binary to $InstallDir..." -ForegroundColor Cyan
try {
    Copy-Item -Path $DestPath -Destination (Join-Path $InstallDir "rustybase.exe") -Force
} catch {
    Write-Host "[!] Permission denied. Please run this script as Administrator." -ForegroundColor Yellow
    exit 1
}

# Add to PATH if not present
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*$InstallDir*") {
    Write-Host ">> Adding $InstallDir to User PATH..." -ForegroundColor Cyan
    [Environment]::SetEnvironmentVariable("Path", "$UserPath;$InstallDir", "User")
}

Write-Host "" -ForegroundColor Green
Write-Host ">> Deployment successful. RustyBase engine is now offline but ready." -ForegroundColor Green
Write-Host ">> Please restart your terminal and execute 'rustybase init' to configure your first instance." -ForegroundColor Cyan
Write-Host ""
