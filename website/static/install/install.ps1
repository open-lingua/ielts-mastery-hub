#!/usr/bin/env pwsh
#
# IELTS Mastery Hub - Windows installer (PowerShell)
#
# Copyright (C) 2026-present
# Licensed under the MIT License.
#
# TODO(everyone): Keep this script simple and easily auditable.
#
# Usage:
#   irm https://open-lingua.github.io/ielts-mastery-hub/install/install.ps1 | iex
#
# NOTE: `param()` blocks do not work when a script is piped into `iex`.
# To pass arguments in a one-liner, use the scriptblock invocation form:
#
#   &([scriptblock]::Create((irm https://open-lingua.github.io/ielts-mastery-hub/install/install.ps1))) -Package msi
#
# Or download the script first and run it with normal parameters:
#
#   irm https://open-lingua.github.io/ielts-mastery-hub/install/install.ps1 -OutFile install.ps1
#   .\install.ps1 -Package msi
#
# Parameters:
#   -Version      Version to install (e.g. "1.0.1-rc.2"). Defaults to the
#                 latest GitHub release. Falls back to $env:IMH_VERSION.
#   -Package      Package format to install: "nsis" (default, *-setup.exe)
#                 or "msi" (*.msi). Falls back to $env:IMH_PACKAGE.
#   -InstallDir   Custom install directory, forwarded to the NSIS/MSI
#                 installer. Defaults to the installer's own default path.
#   -Silent       Run the installer silently (default behavior).
#   -Interactive  Show the installer's normal UI instead of installing
#                 silently.
#   -Help         Show this help text and exit.
#
# Environment variables:
#   IMH_VERSION   Same as -Version.
#   IMH_PACKAGE   Same as -Package.

[CmdletBinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSAvoidUsingWriteHost', '',
    Justification = 'Colorized, host-friendly progress output is an explicit UX requirement for this interactive installer.')]
param(
    [string]$Version,
    [ValidateSet('nsis', 'msi')]
    [string]$Package,
    [switch]$Silent,
    [switch]$Interactive,
    [string]$InstallDir,
    [switch]$Help
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# Avoid the drastic Invoke-WebRequest slowdown on Windows PowerShell 5.1
# caused by the default progress bar rendering; we print our own progress
# messages instead.
$ProgressPreference = 'SilentlyContinue'

$Repo = 'open-lingua/ielts-mastery-hub'
$AppName = 'ielts-mastery-hub'
$UserAgent = 'ielts-mastery-hub-installer'

# ------------------------------------------------------------------------
# Output helpers
# ------------------------------------------------------------------------

function Write-Info {
    param([string]$Message)
    Write-Host '==> ' -ForegroundColor Cyan -NoNewline
    Write-Host $Message
}

function Write-Success {
    param([string]$Message)
    Write-Host '==> ' -ForegroundColor Green -NoNewline
    Write-Host $Message
}

function Write-WarningMessage {
    param([string]$Message)
    Write-Host 'warning: ' -ForegroundColor Yellow -NoNewline
    Write-Host $Message
}

# ------------------------------------------------------------------------
# --help
# ------------------------------------------------------------------------

function Show-Help {
    @'
IELTS Mastery Hub installer (Windows)

Usage:
  irm https://open-lingua.github.io/ielts-mastery-hub/install/install.ps1 | iex

  # With arguments (param() blocks do not work through `iex`):
  &([scriptblock]::Create((irm https://open-lingua.github.io/ielts-mastery-hub/install/install.ps1))) -Package msi

  # Or download first, then run normally:
  irm https://open-lingua.github.io/ielts-mastery-hub/install/install.ps1 -OutFile install.ps1
  .\install.ps1 [-Version <version>] [-Package nsis|msi] [-InstallDir <path>] [-Silent] [-Interactive] [-Help]

Parameters:
  -Version      Version to install, e.g. -Version 1.0.1-rc.2 (defaults to
                the latest GitHub release).
  -Package      Package format to install: nsis (default) or msi.
  -InstallDir   Custom install directory passed to the installer.
  -Silent       Install silently (default).
  -Interactive  Show the installer UI instead of installing silently.
  -Help         Show this help text and exit.

Environment variables:
  IMH_VERSION   Same as -Version.
  IMH_PACKAGE   Same as -Package.

Examples:
  &([scriptblock]::Create((irm https://open-lingua.github.io/ielts-mastery-hub/install/install.ps1))) -Version 1.0.1-rc.2
  $env:IMH_PACKAGE = 'msi'; irm https://open-lingua.github.io/ielts-mastery-hub/install/install.ps1 | iex
'@ | Write-Host
}

if ($Help) {
    Show-Help
    return
}

# ------------------------------------------------------------------------
# Prerequisite checks
# ------------------------------------------------------------------------

function Test-Prerequisite {
    if ($PSVersionTable.PSVersion.Major -lt 5 -or
        ($PSVersionTable.PSVersion.Major -eq 5 -and $PSVersionTable.PSVersion.Minor -lt 1)) {
        throw "this script requires PowerShell 5.1 or later. You are running $($PSVersionTable.PSVersion)."
    }

    $isWindowsPlatform = $true
    if (Get-Variable -Name IsWindows -Scope Global -ErrorAction SilentlyContinue) {
        # $IsWindows only exists on PowerShell 6+; Windows PowerShell 5.1 is
        # always Windows.
        $isWindowsPlatform = $IsWindows
    }
    if (-not $isWindowsPlatform) {
        throw "this script only supports Windows. On Linux/macOS, use: curl -fsSL https://open-lingua.github.io/ielts-mastery-hub/install/install.sh | sh"
    }

    # Enforce TLS 1.2 for GitHub on Windows PowerShell 5.1, which may
    # default to an older protocol. PowerShell 7+ already supports modern
    # TLS by default, so guard this to avoid unnecessary errors there.
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    } catch {
        Write-WarningMessage "could not enforce TLS 1.2; continuing with the default security protocol."
    }
}

# ------------------------------------------------------------------------
# Architecture detection
# ------------------------------------------------------------------------

function Resolve-Architecture {
    # Prefer the WOW64-aware environment variable when present: a 32-bit
    # process running on 64-bit Windows reports x86 in
    # PROCESSOR_ARCHITECTURE, but the real OS architecture is exposed via
    # PROCESSOR_ARCHITEW6432.
    $rawArch = $env:PROCESSOR_ARCHITEW6432
    if ([string]::IsNullOrEmpty($rawArch)) {
        $rawArch = $env:PROCESSOR_ARCHITECTURE
    }
    if ([string]::IsNullOrEmpty($rawArch)) {
        try {
            $rawArch = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString()
        } catch {
            $rawArch = ''
        }
    }

    switch -Regex ($rawArch) {
        '^(AMD64|x86_64)$' { return 'x64' }
        '^ARM64$' { return 'arm64' }
        default {
            throw "unsupported architecture: '$rawArch'. IELTS Mastery Hub only ships prebuilt Windows binaries for x64 and arm64."
        }
    }
}

# ------------------------------------------------------------------------
# Version resolution
# ------------------------------------------------------------------------

function Resolve-ImhVersion {
    param([string]$RequestedVersion)

    if (-not [string]::IsNullOrEmpty($RequestedVersion)) {
        return $RequestedVersion -replace '^v', ''
    }

    Write-Info 'resolving latest release...'

    $apiUrl = "https://api.github.com/repos/$Repo/releases/latest"
    try {
        $release = Invoke-RestMethod -Uri $apiUrl -Headers @{ 'User-Agent' = $UserAgent } -UseBasicParsing
    } catch {
        $statusCode = $null
        if ($_.Exception.Response) {
            $statusCode = [int]$_.Exception.Response.StatusCode
        }
        if ($statusCode -eq 403) {
            throw "GitHub API rate limit reached while resolving the latest version. Set -Version <version> (or `$env:IMH_VERSION) to skip this step."
        }
        throw "could not reach $apiUrl to resolve the latest version. Set -Version <version> (or `$env:IMH_VERSION) to skip this step. ($($_.Exception.Message))"
    }

    $tag = $release.tag_name
    if ([string]::IsNullOrEmpty($tag)) {
        throw "could not determine the latest version from the GitHub API response. Set -Version <version> (or `$env:IMH_VERSION) to skip this step."
    }

    $version = $tag -replace '^v', ''
    if ($version -notmatch '^\d+\.\d+\.\d+(-rc\.\d+)?$') {
        throw "unexpected version format from GitHub: '$tag'."
    }

    return $version
}

# ------------------------------------------------------------------------
# Asset filename / URL construction
# ------------------------------------------------------------------------

function Get-AssetName {
    param(
        [string]$Version,
        [string]$Arch,
        [string]$Package
    )

    switch ($Package) {
        'nsis' { return "${AppName}_${Version}_${Arch}-setup.exe" }
        'msi' { return "${AppName}_${Version}_${Arch}_en-US.msi" }
        default { throw "unsupported package format: '$Package'. Expected 'nsis' or 'msi'." }
    }
}

# ------------------------------------------------------------------------
# Download
# ------------------------------------------------------------------------

function Get-ImhAsset {
    param(
        [string]$Version,
        [string]$AssetName,
        [string]$DestinationDir
    )

    $url = "https://github.com/$Repo/releases/download/$Version/$AssetName"
    $destinationPath = Join-Path -Path $DestinationDir -ChildPath $AssetName

    Write-Info "downloading $AssetName (version $Version)..."

    try {
        Invoke-WebRequest -Uri $url -Headers @{ 'User-Agent' = $UserAgent } -UseBasicParsing -OutFile $destinationPath
    } catch {
        $statusCode = $null
        if ($_.Exception.Response) {
            $statusCode = [int]$_.Exception.Response.StatusCode
        }
        if ($statusCode -eq 404) {
            throw "failed to download '$AssetName' (HTTP 404). This may mean version '$Version' has no matching asset for your architecture/package. Try a different -Package, or check https://github.com/$Repo/releases"
        }
        throw "failed to download '$AssetName': $($_.Exception.Message)"
    }

    $size = (Get-Item -Path $destinationPath).Length
    Write-Info ("downloaded {0:N1} MB." -f ($size / 1MB))

    return $destinationPath
}

# ------------------------------------------------------------------------
# Checksum verification
# ------------------------------------------------------------------------

function Test-ImhChecksum {
    param(
        [string]$Version,
        [string]$AssetName,
        [string]$FilePath
    )

    $apiUrl = "https://api.github.com/repos/$Repo/releases/tags/$Version"
    try {
        $release = Invoke-RestMethod -Uri $apiUrl -Headers @{ 'User-Agent' = $UserAgent } -UseBasicParsing
    } catch {
        Write-WarningMessage 'could not fetch release metadata to verify checksum; skipping.'
        return
    }

    $asset = $release.assets | Where-Object { $_.name -eq $AssetName } | Select-Object -First 1
    if (-not $asset -or [string]::IsNullOrEmpty($asset.digest)) {
        Write-WarningMessage "no checksum published for '$AssetName'; skipping verification."
        return
    }

    $expectedSha256 = ($asset.digest -replace '^sha256:', '').ToUpperInvariant()
    if ([string]::IsNullOrEmpty($expectedSha256)) {
        Write-WarningMessage "no checksum published for '$AssetName'; skipping verification."
        return
    }

    $actualSha256 = (Get-FileHash -Path $FilePath -Algorithm SHA256).Hash.ToUpperInvariant()

    if ($actualSha256 -ne $expectedSha256) {
        throw "checksum mismatch for '$AssetName': expected $expectedSha256, got $actualSha256"
    }

    Write-Info 'checksum verified.'
}

# ------------------------------------------------------------------------
# Elevation check
# ------------------------------------------------------------------------

function Test-IsElevated {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# ------------------------------------------------------------------------
# Installation
# ------------------------------------------------------------------------

function Install-NsisPackage {
    param(
        [string]$FilePath,
        [bool]$RunSilently,
        [string]$InstallDir
    )

    $argumentList = New-Object System.Collections.Generic.List[string]
    if ($RunSilently) {
        $argumentList.Add('/S')
    }
    if (-not [string]::IsNullOrEmpty($InstallDir)) {
        $argumentList.Add("/D=$InstallDir")
    }

    Write-Info "running installer $(if ($RunSilently) { 'silently' } else { 'interactively' })..."
    $process = Start-Process -FilePath $FilePath -ArgumentList $argumentList -Wait -PassThru

    if ($process.ExitCode -ne 0) {
        throw "installer exited with code $($process.ExitCode)."
    }
}

function Install-MsiPackage {
    param(
        [string]$FilePath,
        [bool]$RunSilently,
        [string]$InstallDir
    )

    $logPath = Join-Path -Path $env:TEMP -ChildPath "$AppName-install.log"

    $msiArgs = New-Object System.Collections.Generic.List[string]
    $msiArgs.Add('/i')
    $msiArgs.Add("`"$FilePath`"")
    if ($RunSilently) {
        $msiArgs.Add('/qn')
    }
    $msiArgs.Add('/norestart')
    $msiArgs.Add('/L*v')
    $msiArgs.Add("`"$logPath`"")
    if (-not [string]::IsNullOrEmpty($InstallDir)) {
        $msiArgs.Add("INSTALLDIR=`"$InstallDir`"")
    }

    Write-Info "running msiexec $(if ($RunSilently) { 'silently' } else { 'interactively' })..."
    $process = Start-Process -FilePath 'msiexec.exe' -ArgumentList $msiArgs -Wait -PassThru

    # 3010 means success but a reboot is required.
    if ($process.ExitCode -ne 0 -and $process.ExitCode -ne 3010) {
        throw "msiexec exited with code $($process.ExitCode). See the install log at: $logPath"
    }

    if ($process.ExitCode -eq 3010) {
        Write-WarningMessage 'installation succeeded, but a reboot is required to finish.'
    }
}

# ------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------

function Invoke-Main {
    param(
        [string]$RequestedVersion,
        [string]$RequestedPackage,
        [switch]$RequestSilent,
        [switch]$RequestInteractive,
        [string]$RequestedInstallDir
    )

    Test-Prerequisite

    $resolvedVersion = if (-not [string]::IsNullOrEmpty($RequestedVersion)) { $RequestedVersion } else { $env:IMH_VERSION }
    $resolvedPackage = if (-not [string]::IsNullOrEmpty($RequestedPackage)) { $RequestedPackage } else { $env:IMH_PACKAGE }
    if ([string]::IsNullOrEmpty($resolvedPackage)) {
        $resolvedPackage = 'nsis'
    }
    if ($resolvedPackage -notin @('nsis', 'msi')) {
        throw "unsupported IMH_PACKAGE/-Package '$resolvedPackage'. Expected one of: nsis, msi"
    }

    if ($RequestSilent.IsPresent -and $RequestInteractive.IsPresent) {
        throw 'cannot specify both -Silent and -Interactive.'
    }
    $runSilently = -not $RequestInteractive.IsPresent

    if (-not (Test-IsElevated)) {
        Write-WarningMessage 'this process is not running as Administrator. The installer may prompt for elevation (UAC), or fail if it requires it.'
    }

    $arch = Resolve-Architecture
    $version = Resolve-ImhVersion -RequestedVersion $resolvedVersion
    $assetName = Get-AssetName -Version $version -Arch $arch -Package $resolvedPackage

    $tmpDir = Join-Path -Path $env:TEMP -ChildPath "imh-install-$([guid]::NewGuid().ToString('N'))"
    New-Item -Path $tmpDir -ItemType Directory -Force | Out-Null

    try {
        $downloadedFile = Get-ImhAsset -Version $version -AssetName $assetName -DestinationDir $tmpDir
        Test-ImhChecksum -Version $version -AssetName $assetName -FilePath $downloadedFile

        if ($resolvedPackage -eq 'nsis') {
            Install-NsisPackage -FilePath $downloadedFile -RunSilently $runSilently -InstallDir $RequestedInstallDir
        } else {
            Install-MsiPackage -FilePath $downloadedFile -RunSilently $runSilently -InstallDir $RequestedInstallDir
        }
    } finally {
        if (Test-Path -Path $tmpDir) {
            Remove-Item -Path $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    Write-Success "IELTS Mastery Hub $version installed successfully."
    Write-Host "Architecture: $arch"
    Write-Host "Package: $resolvedPackage"
    Write-Host 'Launch it from the Start Menu as "IELTS Mastery Hub".'
}

Invoke-Main -RequestedVersion $Version -RequestedPackage $Package -RequestSilent:$Silent -RequestInteractive:$Interactive -RequestedInstallDir $InstallDir
