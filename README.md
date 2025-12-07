# GOG DLC Silent Installer

This tool helps you install multiple GOG DLCs at once without clicking "Next" hundreds of times.

## How to use (The Easy Way)

The easiest way to use this is to add it to your "Send To" menu. This lets you select files in Explorer and install them with one click.

### 1. Setup (Do this once)
1. Download this folder to your computer.
2. Open the folder.
3. Right-click on `manage_context_menu.ps1` and select **Run with PowerShell**.
4. A blue window will open and ask for an **Action**. 
   - Type `Install` and press **Enter**.
5. It should say "Shortcut created". You are good to go!

### 2. Installing Games/DLCs
1. Go to your GOG game folder (where you downloaded all the `.exe` files).
2. Select all the DLC installer files you want to install.
   - **Tip**: You can click one, hold `Shift`, and click the last one to select a range. Or hold `Ctrl` to select specific ones.
3. **Right-click** on the selected files.
4. Move your mouse to **Send to** -> **GOG Silent Installer**.
5. A window will pop up and start installing them one by one.
6. Sit back and relax. It will tell you when it's done.

### 3. Uninstalling the shortcut
If you don't want the "Send to" option anymore:
1. Open this folder again.
2. Right-click `manage_context_menu.ps1` and select **Run with PowerShell**.
3. When it asks for **Action**, type `Uninstall` and press **Enter**.
4. It will remove the shortcut.

---

## (Advanced) Using via Command Line

If you prefer using the command line (Terminal / PowerShell), you can use the script directly.

```powershell
.\install_gog_dlc.ps1 -SourcePath "D:\Games\MyGame"
```

This will automatically find all `setup_*.exe` files in that folder and install them.

### Options
- `-SourcePath "..."`: The folder to scan.
- `-Exclude "*patch*"`: Skip files with this name (e.g., skip patches or base game).
