# RustyBase Windows Installer
# Targets: Windows (x64, ARM64)

$ErrorActionPreference = "Stop"

# Force TLS 1.2 for older PowerShell 5.1 environments
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$RepoUrl = "https://github.com/diptanshumahish/rustybase-release"
$LatestReleaseApi = "https://api.github.com/repos/diptanshumahish/rustybase-release/releases/latest"

function Print-Banner {
    Write-Host " "
    Write-Host "░█████████                           ░██               ░██                                         " -ForegroundColor Cyan
    Write-Host "░██     ░██                          ░██               ░██                                         " -ForegroundColor Cyan
    Write-Host "░██     ░██ ░██    ░██  ░███████  ░████████ ░██    ░██ ░████████   ░██████    ░███████   ░███████  " -ForegroundColor Cyan
    Write-Host "░█████████  ░██    ░██ ░██           ░██    ░██    ░██ ░██    ░██       ░██  ░██        ░██    ░██ " -ForegroundColor Cyan
    Write-Host "░██   ░██   ░██    ░██  ░███████     ░██    ░██    ░██ ░██    ░██  ░███████   ░███████  ░█████████ " -ForegroundColor Cyan
    Write-Host "░██    ░██  ░██   ░███        ░██    ░██    ░██   ░███ ░███   ░██ ░██   ░██         ░██ ░██        " -ForegroundColor Cyan
    Write-Host "░██     ░██  ░█████░██  ░███████      ░████  ░█████░██ ░██░█████   ░█████░██  ░███████   ░███████  " -ForegroundColor Cyan
    Write-Host "                                                   ░██                                             " -ForegroundColor Cyan
    Write-Host "                                             ░███████                                              " -ForegroundColor Cyan
    Write-Host " "
}

Print-Banner
Write-Host "  >> Initiating RustyBase installation sequence..." -ForegroundColor White

# Check for Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    if ($PSCommandPath) {
        Write-Host "  [!] Administrative privileges required. Attempting to elevate..." -ForegroundColor Yellow
        $Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
        try {
            Start-Process powershell.exe -Verb RunAs -ArgumentList $Arguments
            exit
        } catch {
            Write-Host "  [x] Failed to elevate. Please run PowerShell as Administrator." -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "  [x] Error: Administrative privileges required. Please run this script in an Elevated PowerShell session." -ForegroundColor Red
        exit 1
    }
}

# Detect Architecture
$Arch = $env:PROCESSOR_ARCHITECTURE
if ($Arch -eq "AMD64") {
    $TargetArch = "x86_64"
} elseif ($Arch -eq "ARM64") {
    $TargetArch = "aarch64"
} else {
    Write-Host "  [x] Unsupported architecture: $Arch. Only x64 and ARM64 are supported." -ForegroundColor Red
    exit 1
}

$Target = "rustybase-$TargetArch-pc-windows-msvc.exe"

# Fetch latest release tag
Write-Host "  >> Searching for latest release metadata... " -NoNewline -ForegroundColor Cyan
try {
    $Release = Invoke-RestMethod -Uri $LatestReleaseApi
    $ReleaseTag = $Release.tag_name
    Write-Host "[v] Identified: $ReleaseTag" -ForegroundColor Green
} catch {
    Write-Host "`n  [x] Error: Could not determine latest release version." -ForegroundColor Red
    exit 1
}

$DownloadUrl = "$RepoUrl/releases/download/$ReleaseTag/$Target"

# Optimization: Check if latest version is already installed
$InstallDir = Join-Path $env:ProgramFiles "RustyBase"
$InstalledExe = Join-Path $InstallDir "rustybase.exe"

if (Test-Path $InstalledExe) {
    Write-Host "  >> Checking existing installation... " -NoNewline -ForegroundColor Cyan
    try {
        # Attempt to get version from existing binary
        $VersionOutput = & $InstalledExe --version 2>$null
        # Normalize: 'rustybase 0.1.1' or just '0.1.1'
        if ($VersionOutput -match "(\d+\.\d+\.\d+)") {
            $CurrentVersion = $Matches[1]
            # Release tag might have 'v' prefix, normalize that too
            $LatestVersionNormalized = $ReleaseTag -replace '^v', ''
            
            if ($CurrentVersion -eq $LatestVersionNormalized) {
                Write-Host "[v] Up to date ($ReleaseTag)" -ForegroundColor Green
                Write-Host "`n  >> Success: RustyBase is already at the latest version ($ReleaseTag)." -ForegroundColor White
                Write-Host "  >> Execute 'rustybase init' to configure your instance.`n" -ForegroundColor Cyan
                exit 0
            } else {
                Write-Host "[!] Update available ($CurrentVersion -> $LatestVersionNormalized)" -ForegroundColor Yellow
            }
        } else {
            Write-Host "[!] Could not determine version." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "[!] Error checking version." -ForegroundColor Yellow
    }
}

# Temporary directory for installation assets
$TempDir = Join-Path $env:TEMP ("rustybase-install-" + [Guid]::NewGuid().ToString().Substring(0,8))
New-Item -ItemType Directory -Path $TempDir -Force | Out-Null

try {
    Write-Host "  >> Pulling binary from production registry..." -ForegroundColor Cyan
    $DestPath = Join-Path $TempDir "rustybase.exe"
    
    # Disable progress bar for faster download in PS 5.1
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $DestPath -ErrorAction Stop
    $ProgressPreference = 'Continue'
    
    # Verify file size (should be > 1MB)
    $FileSize = (Get-Item $DestPath).Length
    if ($FileSize -lt 1MB) {
        throw "Downloaded file is too small ($FileSize bytes). This usually means an error page was downloaded instead of the binary."
    }

    # Install binary
    $InstallDir = Join-Path $env:ProgramFiles "RustyBase"
    Write-Host "  >> Deploying binary to $InstallDir... " -NoNewline -ForegroundColor Cyan

    if (-not (Test-Path $InstallDir)) {
        New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    }

    try {
        Copy-Item -Path $DestPath -Destination (Join-Path $InstallDir "rustybase.exe") -Force
        Write-Host "[v]" -ForegroundColor Green
    } catch {
        Write-Host "`n  [!] Permission denied. Please run this script as Administrator." -ForegroundColor Yellow
        exit 1
    }

    # Add to PATH if not present
    $UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($UserPath -notlike "*$InstallDir*") {
        Write-Host "  >> Adding $InstallDir to User PATH..." -ForegroundColor Cyan
        $NewPath = "$UserPath;$InstallDir"
        [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
        # Update current session path
        $env:Path = "$env:Path;$InstallDir"
    }

    Write-Host "`n┌───────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
    Write-Host "│                                                           │" -ForegroundColor Cyan
    Write-Host "│           INSTALLATION COMPLETE : RUSTYBASE               │" -ForegroundColor Cyan
    Write-Host "└───────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
    Write-Host "`n  >> System operational. Server engine is now local." -ForegroundColor White
    Write-Host "  >> Execute 'rustybase init' to configure your instance.`n" -ForegroundColor Cyan

} finally {
    if (Test-Path $TempDir) {
        Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

