# GOG DLC Silent Installer Script

This PowerShell script (`install_gog_dlc.ps1`) automates the installation of multiple GOG DLC installers from a specific directory. It uses standard silent installation flags to avoid wizard prompts and manual interaction.

## Features

*   **Silent Installation:** Runs installers in the background with `/VERYSILENT`, `/NORESTART`, and other standard flags.
*   **Batch Processing:** Scans a directory for matching files and runs them sequentially.
*   **Filtering:** Supports `Include` and `Exclude` wildcards to target specific files (e.g., install all DLCs but skip the main game installer).

## Usage

Run the script from PowerShell, providing the `-SourcePath` argument at a minimum.

```powershell
.\install_gog_dlc.ps1 -SourcePath "Path\To\Installers" [options]
```

### Parameters

| Parameter | Application | Default | Description |
| :--- | :--- | :--- | :--- |
| **`-SourcePath`** | **Required** | N/A | Full path to the directory containing the installer `.exe` files. |
| **`-Include`** | Optional | `setup_*.exe` | Wildcard pattern to match files to install. |
| **`-Exclude`** | Optional | `""` | Wildcard pattern to **skip** files (e.g., exclude base game). |

## Examples

### 1. Basic Installation (Install Everything)
Installs all files matching `setup_*.exe` in the folder.

```powershell
.\install_gog_dlc.ps1 -SourcePath "D:\Downloads\Games\Stellaris\DLCs"
```

### 2. Exclude Base Game (Common Scenario)
If the folder contains both the base game (often labeled with `64bit` or `v1.0`) and DLCs, use `-Exclude` to skip the game installer.

```powershell
.\install_gog_dlc.ps1 -SourcePath "D:\Downloads\Games\Age of Wonders 4" -Exclude "*64bit*"
```

### 3. Custom File Pattern
If the installers have a different naming convention.

```powershell
.\install_gog_dlc.ps1 -SourcePath "D:\Downloads\Games\Wartales" -Include "*.exe"
```

### 4. Complex Exclusion
Exclude multiple types of files (Note: PowerShell wildcards are simple, for complex regex you might need to modify the script, but `*` covers most cases).

```powershell
# Excludes any file containing "Patch" OR "Update"
.\install_gog_dlc.ps1 -SourcePath "..." -Exclude "*Patch*" 
```

## Technical Details

The script executes the installers with the following arguments:
*   `/VERYSILENT`: No progress window.
*   `/NORESTART`: Prevents auto-reboot.
*   `/SP-`: Skips startup confirmation.
*   `/SUPPRESSMSGBOXES`: Answers default to all warnings (e.g., Overwrite).

If you experience issues with a specific game, you can edit the `$installArgs` variable in the script to change these flags (e.g., use `/SILENT` instead of `/VERYSILENT` to see a progress bar).
