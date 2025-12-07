<#
.SYNOPSIS
    Installs or uninstalls the "GOG Silent Installer" shortcut in the user's SendTo folder.

.DESCRIPTION
    This script creates a shortcut in the current user's "SendTo" folder.
    The shortcut targets the `install_selected.ps1` script located in the same directory as this script.
    It uses `pwsh.exe` (PowerShell Core) if available, falling back to `powershell.exe`.

.PARAMETER Action
    Specify 'Install' to create the shortcut, or 'Uninstall' to remove it.
#>

param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("Install", "Uninstall")]
    [string]$Action
)

$ErrorActionPreference = "Stop"

$scriptPath = Join-Path $PSScriptRoot "install_selected.ps1"
$sendToFolder = [Environment]::GetFolderPath("SendTo")
$shortcutPath = Join-Path $sendToFolder "GOG Silent Installer.lnk"

if ($Action -eq "Install") {
    Write-Host "Installing shortcut..." -ForegroundColor Cyan

    if (-not (Test-Path $scriptPath)) {
        Write-Error "Could not find target script: $scriptPath"
        exit 1
    }

    # Determine PowerShell executable
    $psExe = if (Get-Command pwsh -ErrorAction SilentlyContinue) { "pwsh.exe" } else { "powershell.exe" }

    try {
        $wshShell = New-Object -ComObject WScript.Shell
        $shortcut = $wshShell.CreateShortcut($shortcutPath)
        
        # We run powershell.exe with -File so arguments are passed correctly
        $shortcut.TargetPath = $psExe
        $shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
        $shortcut.IconLocation = "shell32.dll,261" # Generic installer icon
        $shortcut.Description = "Install selected GOG DLCs silently"
        $shortcut.WindowStyle = 1 # Normal window
        $shortcut.Save()

        Write-Host "Shortcut created at: $shortcutPath" -ForegroundColor Green
        Write-Host "You can now select multiple .exe files, Right Click -> Send To -> GOG Silent Installer" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to create shortcut: $($_.Exception.Message)"
    }
}
elseif ($Action -eq "Uninstall") {
    Write-Host "Uninstalling shortcut..." -ForegroundColor Cyan

    if (Test-Path $shortcutPath) {
        Remove-Item $shortcutPath -Force
        Write-Host "Shortcut removed." -ForegroundColor Green
    }
    else {
        Write-Warning "Shortcut not found at: $shortcutPath"
    }
}
