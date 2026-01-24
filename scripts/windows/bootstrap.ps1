#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Windows bootstrap script for development environment setup.
.DESCRIPTION
    Installs core development tools via winget and initializes WSL2 with Ubuntu.
    Run this BEFORE running install.sh inside WSL.
.NOTES
    Run in elevated PowerShell: powershell -ExecutionPolicy Bypass -File bootstrap.ps1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# =============================================================================
# Configuration
# =============================================================================

$Apps = @(
    "Microsoft.WindowsTerminal",
    "Microsoft.VisualStudioCode",
    "Docker.DockerDesktop",
    "Microsoft.PowerToys",
    "7zip.7zip"
)

$WslDistro = "Ubuntu"

# =============================================================================
# Helper Functions
# =============================================================================

function Write-Step {
    param([string]$Message)
    Write-Host "`n>> $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "   ✓ $Message" -ForegroundColor Green
}

function Write-Skip {
    param([string]$Message)
    Write-Host "   - $Message (skipped)" -ForegroundColor Yellow
}

function Test-AppInstalled {
    param([string]$AppId)
    $result = winget list --id $AppId 2>$null
    return $LASTEXITCODE -eq 0 -and $result -match $AppId
}

# =============================================================================
# Main Installation
# =============================================================================

Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║           Windows Development Environment Bootstrap           ║
╚═══════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Magenta

# -----------------------------------------------------------------------------
# 1. Install Core Tools via Winget
# -----------------------------------------------------------------------------

Write-Step "Installing core development tools..."

foreach ($app in $Apps) {
    if (Test-AppInstalled -AppId $app) {
        Write-Skip "$app already installed"
    } else {
        Write-Host "   Installing $app..." -ForegroundColor White
        winget install --id $app --silent --accept-package-agreements --accept-source-agreements
        if ($LASTEXITCODE -eq 0) {
            Write-Success "$app installed"
        } else {
            Write-Warning "   Failed to install $app"
        }
    }
}

# -----------------------------------------------------------------------------
# 2. Initialize WSL2
# -----------------------------------------------------------------------------

Write-Step "Setting up WSL2..."

$wslList = wsl --list --quiet 2>$null
if ($wslList -match $WslDistro) {
    Write-Skip "$WslDistro already installed"
} else {
    Write-Host "   Installing $WslDistro (this may take a few minutes)..." -ForegroundColor White
    wsl --install -d $WslDistro
    Write-Success "$WslDistro installed"
}

# -----------------------------------------------------------------------------
# 3. Optimize WSL: Enable Sparse VHDX
# -----------------------------------------------------------------------------

Write-Step "Optimizing WSL storage..."

# Sparse VHDX ensures deleted files in Linux reclaim Windows disk space
try {
    wsl --manage $WslDistro --set-sparse true 2>$null
    Write-Success "Sparse VHDX enabled for $WslDistro"
} catch {
    Write-Skip "Sparse VHDX (may require WSL to be fully initialized first)"
}

# =============================================================================
# Complete
# =============================================================================

Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║                    Bootstrap Complete!                        ║
╚═══════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Green

Write-Host @"
Next steps:
  1. Restart your computer (recommended before using Docker)
  2. Open Windows Terminal and launch Ubuntu
  3. Clone dotfiles:  git clone <repo> ~/.dotfiles
  4. Run installer:   ~/.dotfiles/install.sh

"@ -ForegroundColor White
