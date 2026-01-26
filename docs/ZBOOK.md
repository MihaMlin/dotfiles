# Windows & WSL2 Development Setup

This guide provides a streamlined workflow for stripping Windows bloat, installing core development tools, and configuring a high-performance WSL2 environment.

---

# 💻 Phase 1: Windows 11 Clean Install Guide (HP ZBook)

This guide outlines the steps for a **clean and optimized installation of Windows 11** on an **HP ZBook workstation**.

---

## 🛠️ Preparation and Backup

### 1. Backup (Mandatory)
- [ ] **BitLocker**: Verify and save the recovery key at
  https://account.microsoft.com/devices/recoverykey
- [ ] **System Image**: Create a full system image on an external drive (fallback option).
- [ ] **Personal Files**: Move all important documents to the cloud or an external medium.

---

### 2. Installation Media Preparation
- **ISO**: Download the official Windows 11 ISO from Microsoft.
- **Rufus**: Use Rufus to create a bootable USB drive.
- **Tip**: In Rufus, enable **“Disable BitLocker automatic device encryption”** (enable it later).

---

### 3. Prepare Critical Drivers (on USB)
Due to HP ZBook hardware specifics, keep these drivers on the USB drive (folder !DRIVERS):
- **Intel Rapid Storage Technology (IRST)**
  Required so the installer can detect the SSD.
- **Wi-Fi / Ethernet Drivers**
  Ensures immediate internet access after installation.

Use 7-Zip to extract drivers to inf files.

---

## 💿 Operating System Installation

### Boot from USB
1. Insert the USB drive.
2. Power on the ZBook.
3. Press **F9** or **ecs** (Boot Menu or Startup Menu).
4. Select the USB device.

### Clean Installation
1. Choose **Custom: Install Windows only (advanced)**.
2. Delete **all existing partitions** on the primary disk until only
   **Unallocated Space** remains.
3. If the disk is not visible:
   - Click **Load Driver**
   - Load the **IRST driver** from the USB drive.
4. Follow on-screen instructions until reaching the desktop.

---

## 🚀 Updates and Drivers

### Windows Update
- Run Windows Update repeatedly until **no updates remain**.

### HP-Specific Software
- Install **HP Support Assistant** or **HP Image Assistant** to update:
  - BIOS
  - Firmware
  - HP-specific drivers (fingerprint reader, NFC, etc.)

### Device Manager
- Verify all devices are properly recognized
  (**no yellow warning icons**).

---

## 🛡️ Optimization (Debloat)

To remove telemetry and unnecessary system components, use
**Chris Titus Tech Windows Utility**.

### Steps
1. Right-click **Start** → **Terminal (Admin)** or **PowerShell (Admin)**.
2. Run:
   ```powershell
   irm https://christitus.com/winutil | iex


# 📦 Phase 2: Tool Installation (Winget)
Use the Windows Package Manager to install essential software without manual downloads.

Run the following in PowerShell:

```powershell
# Browsers
winget install --id Google.Chrome -e

# Core Tools
winget install --id Microsoft.WindowsTerminal -e
winget install --id Microsoft.VisualStudioCode -e
winget install --id Postman.Postman -e

# System Utilities
winget install --id Docker.DockerDesktop -e
winget install --id 7zip.7zip -e
```

# 🐧 Phase 3: WSL2 Setup (Ubuntu 24.04 Manual Install)
This procedure uses the official Ubuntu 24.04 (Noble Numbat) image and allows for a custom installation path, providing better control and portability.

### 0. Enable WSL2
Ensure the Windows Subsystem for Linux is enabled and set to version 2.

Open **PowerShell (Admin)** and run:
```powershell
# Enable WSL (installs kernel and tools without a distro)
wsl --install --no-distribution

# Force WSL 2 as default
wsl --set-default-version 2

# Check version
wsl --status
```
*Note: A system restart is required if this is the first time enabling WSL.*

### 1. Global Resource Limits (.wslconfig)
To prevent WSL from consuming all your system RAM, create a configuration file in your Windows user directory.

1. In PowerShell, create the file:
   ```powershell
   notepad "$env:USERPROFILE\.wslconfig"
   ```
2. Paste the following configuration:
   ```ini
   [wsl2]
   memory=8GB
   processors=4
   swap=2GB
   localhostForwarding=true
   networkingMode=mirrored
   ```
3. Restart WSL to apply:
   ```powershell
   wsl --shutdown
   ```

### 2. Download Official Image (WSL)
Instead of installing Ubuntu from the Microsoft Store, download the official dedicated WSL image directly from the Ubuntu Cloud Archive:
- **File:** `noble-wsl-amd64.wsl`
- **Link:** [Ubuntu Cloud Images](https://cdimages.ubuntu.com/ubuntu-wsl/noble/daily-live/current/)
- **Action:** Save the file to `C:\Temp\` (or another temporary location).

- **Verify file integrity (optional):**
  ```powershell
  Get-FileHash "C:\Temp\noble-wsl-amd64.wsl" -Algorithm SHA256 | Format-List
  ```
  Compare the output with the SHA256 checksum provided on the download page.

### 3. Prepare Installation Directory
Create a folder where your Linux setup will permanently reside. Avoid system folders like Program Files.
- **Create Folder:** `C:\WSL\Ubuntu24`

### 4. Import into WSL2
Open **PowerShell (Admin)** and import the image. This creates a virtual disk (`.vhdx`) from the source file:

```powershell
wsl --import Ubuntu24 C:\WSL\Ubuntu24 C:\Temp\noble-wsl-amd64.wsl --version 2
```

### 5. Storage Optimization (Sparse VHDX)
To automatically reclaim unused disk space:
```powershell
wsl --manage Ubuntu24 --set-sparse true
```

### 6. Configure User
The official image defaults to the `root` user. You must create a standard user account.

**1. Enter the instance:**
```powershell
wsl -d Ubuntu24
```

**2. Create your user (inside Ubuntu):**
Replace `your_username` with your desired username.
```bash
# Create user
adduser your_username

# Add to sudo group (for admin rights)
usermod -aG sudo your_username
```

**3. Set as default user:**
Edit the WSL configuration file:
```bash
nano /etc/wsl.conf
```
Add the following content:
```ini
[user]
default=your_username

[boot]
systemd=true

[automount]
enabled=true
options="metadata"

[network]
generateResolvConf=true
```
Save with `Ctrl+O`, `Enter`, then exit with `Ctrl+X`.

### 7. Finalize Setup
Exit the instance and terminate it to apply changes:

```powershell
wsl --terminate Ubuntu24
```

**Start your new environment:**
```powershell
wsl -d Ubuntu24
```

> **Why this method?**
> - **Clean Install:** No bloatware from the Microsoft Store.
> - **Full Control:** You know exactly where your disk file resides (`C:\WSL\Ubuntu24\ext4.vhdx`).
> - **Portability:** Easily copy the folder to a new machine and re-import.

## 🔗 Phase 4: VS Code Integration
To use the `code` command inside WSL without path errors:

1. Launch VS Code on Windows.
2. Install the WSL Extension (Marketplace ID: `ms-vscode-remote.remote-wsl`).
3. In your Ubuntu terminal, verify the connection:

```bash
code .
```
> **Note:** If "command not found" occurs, ensure your `.zshrc` or `.bashrc` includes the VS Code bin path.

## 📁 Phase 5: Dotfiles Deployment
Once the foundation is set, pull your personalized configurations.

```bash
git clone https://github.com/MihaMlin/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```
