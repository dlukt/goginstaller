
<#
.SYNOPSIS
    Silently installs GOG DLCs from a specified directory with flexible filtering.

.DESCRIPTION
    This script finds executable installers in a target directory and runs them with standard GOG/Inno Setup 
    silent install flags (/VERYSILENT /NORESTART /SP- /SUPPRESSMSGBOXES).
    It supports including files by wildcard and excluding specific files (like the base game installer).

.PARAMETER SourcePath
    The directory containing the installer files.

.PARAMETER Include
    Wildcard pattern for files to install. Default is "setup_*.exe".

.PARAMETER Exclude
    Wildcard pattern for files to SKIP. Useful for excluding the base game installer.
    Example: "*64bit*" or "setup_game_1.0.exe"

.EXAMPLE
    .\install_gog_dlc.ps1 -SourcePath "D:\Games\Stellaris" -Exclude "*64bit*"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$SourcePath,

    [string]$Include = "setup_*.exe",

    [string]$Exclude = ""
)

$ErrorActionPreference = "Stop"

# Standard silent install flags for GOG/Inno Setup
$installArgs = "/VERYSILENT /NORESTART /SP- /SUPPRESSMSGBOXES"

if (-not (Test-Path $SourcePath)) {
    Write-Error "Source path not found: $SourcePath"
    exit 1
}

Write-Host "Scanning: $SourcePath" -ForegroundColor Cyan
Write-Host "Including: $Include" -ForegroundColor Cyan
if ($Exclude) {
    Write-Host "Excluding: $Exclude" -ForegroundColor Cyan
}

# Get files matching path and include pattern
$potentialInstallers = Get-ChildItem -Path $SourcePath -Filter $Include -File

if ($potentialInstallers.Count -eq 0) {
    Write-Warning "No files found matching '$Include' in '$SourcePath'"
    exit
}

# Apply exclusion if provided
$dlcInstallers = @()
$excludedFiles = @()

foreach ($file in $potentialInstallers) {
    if (-not [string]::IsNullOrWhiteSpace($Exclude) -and ($file.Name -like $Exclude)) {
        $excludedFiles += $file
    }
    else {
        $dlcInstallers += $file
    }
}

# Report filtered files
if ($excludedFiles.Count -gt 0) {
    Write-Host "`nSkipping $($excludedFiles.Count) files (matched exclusion):" -ForegroundColor Yellow
    $excludedFiles | ForEach-Object { Write-Host " - $($_.Name)" -ForegroundColor DarkGray }
}

if ($dlcInstallers.Count -eq 0) {
    Write-Warning "`nNo installers remaining after exclusion filter."
    exit
}

Write-Host "`nReady to install $($dlcInstallers.Count) files." -ForegroundColor Green
Write-Host "Press any key to start extraction/installation... (Ctrl+C to cancel)"
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

foreach ($file in $dlcInstallers) {
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
