<#
.SYNOPSIS
    Silently installs GOG DLCs from a list of selected files (Send To target).

.DESCRIPTION
    This script is designed to be the target of a "Send To" shortcut.
    It takes a list of file paths (passed by Windows Explorer when multiple files are selected),
    filters for executables, and runs them with standard GOG/Inno Setup silent install flags.

.PARAMETER Paths
    The list of file paths passed as arguments.
#>

param(
    [Parameter(Mandatory = $true, ValueFromRemainingArguments = $true)]
    [string[]]$Paths
)

$ErrorActionPreference = "Stop"

# Standard silent install flags for GOG/Inno Setup
$installArgs = "/VERYSILENT /NORESTART /SP- /SUPPRESSMSGBOXES"

Write-Host "GOG Silent Installer - 'Send To' Batch Mode" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# Filter for existing files that are likely installers (.exe)
$installers = @()
foreach ($path in $Paths) {
    if (Test-Path $path -PathType Leaf) {
        if ($path -match "\.exe$") {
            $installers += (Get-Item $path)
        } else {
            Write-Warning "Skipping non-executable: $path"
        }
    } else {
        Write-Warning "Skipping invalid path: $path"
    }
}

if ($installers.Count -eq 0) {
    Write-Warning "No valid executable installers selected."
    Write-Host "`nPress any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

Write-Host "`nReady to install $($installers.Count) files." -ForegroundColor Green
Write-Host "Files:"
$installers | ForEach-Object { Write-Host " - $($_.Name)" -ForegroundColor DarkGray }

Write-Host "`nPress any key to start extraction/installation... (Ctrl+C to cancel)"
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

foreach ($file in $installers) {
    Write-Host "Installing $($file.Name)..." -NoNewline
    try {
        $process = Start-Process -FilePath $file.FullName -ArgumentList $installArgs -Wait -PassThru -NoNewWindow
        
        if ($process.ExitCode -eq 0) {
            Write-Host " [OK]" -ForegroundColor Green
        }
        else {
            Write-Host " [DONE] (Exit Code: $($process.ExitCode))" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host " [ERROR] $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nAll operations complete." -ForegroundColor Cyan
Write-Host "Press any key to close..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
