# RustyBase Windows Installer
# Targets: Windows (x64, ARM64)

$ErrorActionPreference = "Stop"

# Fix terminal encoding to ensure text appears correctly
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

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

function Show-Success {
    param($InstallPath)
    Write-Host "`n┌───────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
    Write-Host "│                                                           │" -ForegroundColor Cyan
    Write-Host "│           INSTALLATION COMPLETE : RUSTYBASE               │" -ForegroundColor Cyan
    Write-Host "└───────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
    Write-Host "`n  >> System operational. Server engine is now local." -ForegroundColor White
    Write-Host "  >> Executable located at: $InstallPath" -ForegroundColor Gray
    Write-Host "  >> Execute 'rustybase init' to configure your instance.`n" -ForegroundColor Cyan
    
    if ($args[0] -ne "NoPause") {
        Write-Host "Press any key to close this window..."
        [void][Console]::ReadKey($true)
    }
}

Print-Banner
Write-Host "  >> Initiating RustyBase installation sequence..." -ForegroundColor White

# 1. Handle Admin Elevation or User-Local Fallback
$IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    Write-Host "  [!] Not running as Administrator." -ForegroundColor Yellow
    $Choice = Read-Host "  >> Would you like to attempt elevation? (Y/n)"
    if ($Choice -ne "n") {
        if ($PSCommandPath) {
            Write-Host "  >> Attempting to elevate..." -ForegroundColor Cyan
            try {
                Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
                exit
            } catch {
                Write-Host "  [!] Elevation failed or rejected. Switching to user-local installation..." -ForegroundColor Yellow
            }
        }
    } else {
        Write-Host "  >> Continuing with user-local installation..." -ForegroundColor Cyan
    }
}

# 2. Determine Installation Directory
if ($IsAdmin) {
    $InstallDir = Join-Path $env:ProgramFiles "RustyBase"
} else {
    $InstallDir = Join-Path $HOME ".rustybase\bin"
}

# 3. Detect Architecture
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

# 4. Fetch latest release tag
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

# 5. Version Check Optimization
$InstalledExe = Join-Path $InstallDir "rustybase.exe"
if (Test-Path $InstalledExe) {
    Write-Host "  >> Checking existing installation... " -NoNewline -ForegroundColor Cyan
    try {
        $VersionOutput = & $InstalledExe --version 2>$null
        if ($VersionOutput -match "(\d+\.\d+\.\d+)") {
            $CurrentVersion = $Matches[1]
            $LatestVersionNormalized = $ReleaseTag -replace '^v', ''
            if ($CurrentVersion -eq $LatestVersionNormalized) {
                Write-Host "[v] Up to date ($ReleaseTag)" -ForegroundColor Green
                Show-Success $InstalledExe "NoPause"
                exit 0
            }
            Write-Host "[!] Update available ($CurrentVersion -> $LatestVersionNormalized)" -ForegroundColor Yellow
        } else {
            Write-Host "[!] Unknown version." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "[!] Error checking version." -ForegroundColor Yellow
    }
}

# 6. Download and Install
$TempDir = Join-Path $env:TEMP ("rustybase-install-" + [Guid]::NewGuid().ToString().Substring(0,8))
New-Item -ItemType Directory -Path $TempDir -Force | Out-Null

try {
    Write-Host "  >> Pulling binary from production registry..." -ForegroundColor Cyan
    $DestPath = Join-Path $TempDir "rustybase.exe"
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $DestPath -ErrorAction Stop
    $ProgressPreference = 'Continue'

    Write-Host "  >> Deploying binary to $InstallDir... " -NoNewline -ForegroundColor Cyan
    if (-not (Test-Path $InstallDir)) {
        New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    }
    Copy-Item -Path $DestPath -Destination (Join-Path $InstallDir "rustybase.exe") -Force
    Write-Host "[v]" -ForegroundColor Green

    # 7. Robust PATH Management
    Write-Host "  >> Updating environment variables... " -NoNewline -ForegroundColor Cyan
    try {
        $UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
        if ($UserPath -notlike "*$InstallDir*") {
            $NewPath = "$UserPath;$InstallDir".Replace(";;", ";")
            [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
            # Update current process too
            $env:Path = "$env:Path;$InstallDir".Replace(";;", ";")
        }
        Write-Host "[v]" -ForegroundColor Green
    } catch {
        Write-Host "[!]" -ForegroundColor Yellow
        Write-Host "`n  [!] Could not update PATH automatically. Please add this directory manually:" -ForegroundColor Yellow
        Write-Host "      $InstallDir" -ForegroundColor White
    }

    Show-Success $InstalledExe

} catch {
    Write-Host "`n  [x] Installation failed: $($_.Exception.Message)" -ForegroundColor Red
} finally {
    if (Test-Path $TempDir) {
        Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
