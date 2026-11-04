# IT Troubleshooting Toolkit

![Superior Networks Logo](logo.png)

**Version:** 3.20.1
**Copyright:** 2025-2026  
**Developed by:** Superior Networks LLC

---

## Overview

The **IT Troubleshooting Toolkit** is a comprehensive PowerShell-based solution designed for IT professionals and Managed Service Providers (MSPs) managing **StorageCraft ShadowProtect** backup environments. This toolkit provides powerful automation tools for backup management, FTP synchronization, ImageManager integration, and service diagnostics.

### Key Capabilities

- **StorageCraft Backup Management** - Complete toolset for managing ShadowProtect backups
- **ConnectWise RMM Repair** - Automated utilities to clear stuck ScreenConnect agents and redeploy RMM agents
- **Claude Temporary Access** - Opens temporary admin SSH access for Claude over Tailscale, then removes it automatically
- **HP M404dn Printer Repair** - Guided connectivity diagnostics, spooler repair, and driver reinstall for HP LaserJet Pro M404dn printers
- **macOS OneDrive Repair** - A dry-run-first terminal workflow for post-update OneDrive synchronization failures
- **FTP Synchronization** - Multiple methods to sync backups to offsite FTP servers
- **ImageManager Integration** - Query replication queue and manage backup jobs
- **Service Management** - Control ImageManager service (start/stop/restart/status)
- **StorageCraft Log Browsing** - Built-in log library and pager for StorageCraft SPX and ImageManager logs
- **Project Planner** - Scans a file share and builds an offline migration planning report (sizes, problem names, folder tree, optional MRPeasy link check)
- **Automated Deployment** - One-command installation and auto-update system
- **Comprehensive Logging** - Track all operations with detailed audit trails

---

## Quick Start

### One-Command Installation & Launch

#### For Windows 10/11 and Server 2016+

Run this command in PowerShell (as Administrator):

```powershell
$ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; New-Item -ItemType Directory C:\ITTools -Force | Out-Null; Invoke-WebRequest -UseBasicParsing -Uri https://raw.githubusercontent.com/SuperiorNetworks/IT-Troubleshooting-Toolkit/master/bootstrap.ps1 -OutFile C:\ITTools\bootstrap.ps1; Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; & C:\ITTools\bootstrap.ps1
```

#### For Windows Server 2012 R2 / Windows 7/8 (PowerShell 4.0)

Run this command in PowerShell (as Administrator):

```powershell
$ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; New-Item -ItemType Directory C:\ITTools -Force | Out-Null; Invoke-WebRequest -UseBasicParsing -Uri https://raw.githubusercontent.com/SuperiorNetworks/IT-Troubleshooting-Toolkit/master/bootstrap_ps4.ps1 -OutFile C:\ITTools\bootstrap_ps4.ps1; Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; & C:\ITTools\bootstrap_ps4.ps1
```

**What this does:**
- Automatically installs the toolkit to `C:\ITTools\Scripts` (if not present)
- Checks for updates and auto-updates if available
- Launches the main menu
- Can be run from anywhere - handles everything automatically
- Works on all Windows versions (Server 2012 R2 through Server 2025)

**Why it downloads the file first:** older instructions ran the download straight from memory (`PowerShell.exe -ExecutionPolicy Bypass -Command "irm ... | iex"`). Microsoft Defender's cloud protection flags that pattern as `Trojan:Win32/Commando.A!ml` and blocks it. This command saves `bootstrap.ps1` to `C:\ITTools`, allows scripts for this PowerShell window only, and runs the file. Paste it into a **PowerShell** window (not Command Prompt or the Run box).

For client PCs you manage, deploying through ConnectWise RMM avoids pasting commands at all.

#### Testing a branch (test boxes only)

Both Windows bootstraps install `master` unless the `SUPERIOR_NETWORKS_BRANCH` environment variable is set. To install another branch (for example `dev`) on a **test box**, run in PowerShell as Administrator:

```powershell
$env:SUPERIOR_NETWORKS_BRANCH='dev'; $ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; New-Item -ItemType Directory C:\ITTools -Force | Out-Null; Invoke-WebRequest -UseBasicParsing -Uri https://raw.githubusercontent.com/SuperiorNetworks/IT-Troubleshooting-Toolkit/dev/bootstrap_ps4.ps1 -OutFile C:\ITTools\bootstrap_ps4.ps1; Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; & C:\ITTools\bootstrap_ps4.ps1
```

The bootstrap shows a yellow `TEST BRANCH` line and always reinstalls the branch. `$env:` only lasts for that PowerShell window, so close it when done. The launcher's update option still reinstalls from `master`.

### macOS OneDrive Repair

The macOS tools run in native **Terminal** with Bash and Git; **PowerShell is not required**. Run the following command as the signed-in macOS user, not with `sudo`:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/SuperiorNetworks/IT-Troubleshooting-Toolkit/master/bootstrap_macos.sh)"
```

The Git bootstrapper clones the version-controlled toolkit to `~/ITTools/Scripts`, reports whether the current version was installed or no changes were needed, displays release notes after an update, and launches the macOS terminal. Before cloning, it verifies that Apple Command Line Tools are actually installed—not just that the macOS Git launcher exists. If they are missing, it opens the Apple installer, makes no partial installation, and tells the technician to rerun the same command after setup completes. From the menu, choose **Option 1 - OneDrive Sync Repair** for the dry-run-first repair flow or **Option 2 - Check GitHub for Toolkit Updates** when an update is desired.

For direct script use after installation, run:

```bash
cd ~/ITTools/Scripts
./Fix-OneDriveSync-macOS.sh --dry-run
./Fix-OneDriveSync-macOS.sh
```

See [MAC_TROUBLESHOOTER_GUIDE.md](MAC_TROUBLESHOOTER_GUIDE.md) for prerequisites, Git diagnostics, safeguards, logs, backups, and post-repair verification.

### After Installation

The toolkit creates a launcher at: `C:\ITTools\Scripts\launcher.bat`

**To launch the toolkit:**
- Double-click `launcher.bat`, or
- Create a desktop shortcut to `launcher.bat`, or
- Run the bootstrap command again (it will detect existing installation)

---

## Main Menu Structure

```
SUPERIOR NETWORKS LLC
IT Troubleshooting Toolkit - v3.20.1

Toolkit Management:
  1. Download and Install Latest Version
  2. Toolkit Logs

Troubleshooting Tools:
  3. StorageCraft Troubleshooter
  4. ConnectWise RMM Troubleshooter
  6. HP M404dn Printer Troubleshooter

Project Tools:
  7. Project Planner (share scan and migration report)

Remote Support:
  8. Claude Temporary Access (SSH, removed automatically)

Windows/Office Activation:
  5. Run MassGrave Activation Scripts (MAS)
  5B. Run MAS (Alternative DoH Method)

  Q. Quit
```

---

## macOS Troubleshooter Terminal

The **macOS Troubleshooter Terminal** provides a signed-in-user workflow for macOS repair tasks. It retrieves the master toolkit version dynamically from `launch_menu.ps1` when the repository is present locally, with a GitHub fallback for standalone deployment. The interface uses a clean, high-contrast Superior Networks dashboard with the canonical local logo on iTerm2, an accessible Superior Networks wordmark fallback in standard Terminal, boxed instructions, explicit status labels, numbered steps, an always-visible version footer, and a built-in Help Guide.

```
SUPERIOR NETWORKS LLC
macOS Troubleshooter Terminal - Toolkit v3.20.1

START HERE
  Choose a task below. Every repair explains its impact before it makes a change.

TROUBLESHOOTING
  [ 1 ]  OneDrive Sync Repair
         Dry-run previews only. Live repair closes, verifies, then reopens OneDrive.

TOOLKIT MANAGEMENT
  [ 2 ]  Check GitHub for Toolkit Updates
         User-initiated only. Git history and local changes are protected.

SUPPORT
  [ H ]  Help Guide
         Workflow, safeguards, log locations, and operating limits.
  [ Q ]  Quit

Footer: Help Guide: Select [ H ] in this terminal | Superior Networks macOS Toolkit v3.20.1
```

### Help Guide (Option H)

**Purpose:** Display the everyday operating guide within the terminal without requiring a browser or a separate document search.

**Content:** Explains the dry-run-first OneDrive repair, Git update behavior, local-change protection, audit and transcript locations, and the important operating limit that OneDrive folder content is never deleted. The terminal footer always identifies the Help Guide entry point and the current master version.

### Option 2 - Check GitHub for Toolkit Updates

**Purpose:** Perform an on-demand Git update of the macOS toolkit without silently updating during terminal startup.

**Behavior:** Runs `bootstrap_macos.sh`, fetches `origin/master`, and uses `git pull --ff-only` only when a newer commit exists. The update flow clearly reports either that no changes were made because the installed toolkit is current, or that a new version was installed along with its matching release notes. If local uncommitted changes exist, the update stops and displays the Git status without overwriting those changes.

**Installation:** The supported one-command bootstrap clones the repository to `~/ITTools/Scripts` and preserves `.git` history for `git status`, `git log`, and future updates. The bootstrapper first validates Apple Command Line Tools with `xcode-select -p`. If the tools are missing, it invokes `xcode-select --install`, clearly states that no clone was attempted, and exits so the technician can rerun the same bootstrap command after Apple finishes the installation.

### Option 1 - OneDrive Sync Repair

**Purpose:** Repair common OneDrive synchronization failures after a macOS update without resetting or deleting local OneDrive content.

**Workflow:** The terminal presents a high-contrast **What This Repair Does** card before it starts. The dry run then reports the close, verify, repair, and relaunch sequence while leaving OneDrive fully unchanged. A numbered **Step 2 of 3 - Your Approval** card states that the live repair will close the OneDrive app and the separate **OneDrive Sync Service**, verify their processes have stopped, repair the protected settings, and then reopen OneDrive. The technician must type `YES` before that live workflow begins. If any OneDrive component cannot be closed, the live script stops before it changes any credentials or preference files and automatically opens its transcript for review.

**Features:**
- Checks for files modified in the last 15 minutes before a live repair and requires confirmation if recent edits are found.
- Stops OneDrive and related Office processes, clears known stale OneDrive Keychain credentials, and backs up affected preference plists before removing them.
- Flushes the macOS preference cache and relaunches OneDrive for a clean sign-in.
- Never deletes files from the user's OneDrive folder.
- Automatically opens every completed dry-run or live-repair transcript in TextEdit for review, while keeping `--no-open-log` available for unattended or diagnostic use.
- Records menu selections, approvals, OneDrive closure verification, transcript-open outcome, relaunch outcome, completion states, and errors in the macOS master audit log.

**Files:**
- `mac_troubleshooter_terminal.sh` - Interactive macOS terminal menu
- `Fix-OneDriveSync-macOS.sh` - OneDrive synchronization repair script
- `MAC_TROUBLESHOOTER_GUIDE.md` - Deployment, repair, and validation guide

**Logs:**
- Master Audit Log: `~/Library/Logs/SuperiorNetworks/master_audit_log.txt`
- OneDrive Repair Transcript: `~/Library/Logs/SuperiorNetworks/Fix-OneDriveSync-<timestamp>.log`
- Plist Backup Folder: `~/Desktop/OneDrive-Plist-Backup-<timestamp>/`

---

## ConnectWise RMM Troubleshooter

The **ConnectWise RMM Troubleshooter** submenu (option #4) provides automated repair utilities to resolve stuck agent installations (such as the "ScreenConnect Installation Pending" error) and restore full remote access.

```
SUPERIOR NETWORKS LLC
ConnectWise RMM Troubleshooter - Toolkit v3.20.1

Step 1 - ScreenConnect Cleanup:
  1. Repair ScreenConnect (Uninstall/Cleanup)
     Detects and removes all ScreenConnect Client instances via
     PackageManagement and WMI. Cleans up leftover services.
     Run this FIRST to clear a stuck or broken installation.

Step 2 - ConnectWise RMM Agent Repair (Redeploy):
  2. Repair ConnectWise RMM (Platform Watchdog)
     Downloads and runs the official CW RMM repair utility.
     Use healthcheckandrestore to redeploy ScreenConnect after cleanup.
     Download to: C:\ITTools\Scripts\Downloads\CWRMM

  B. Back to Main Menu
```

### Repair Workflow

When an endpoint shows **"ScreenConnect Installation Pending"** or the agent is unresponsive, follow this exact workflow:

1. **Run Option 1 (ScreenConnect Cleanup)**: This script aggressively hunts down orphaned ScreenConnect installations using WMI and PowerShell PackageManagement, force-uninstalls them, and deletes any leftover `sc` services blocking a fresh install.
2. **Run Option 2 (ConnectWise RMM Repair)**: Select the `healthcheckandrestore` action. The toolkit downloads the official `platform-watchdog.exe` utility from ConnectWise. The watchdog will detect that ScreenConnect is missing and **automatically push a fresh installation** from the RMM platform to the endpoint.

**Files:**
- `cwrmm_troubleshooter.ps1` - Main submenu
- `screenconnect_repair.ps1` - Cleanup utility
- `connectwise_rmm_repair.ps1` - Watchdog utility

---

## Project Planner

**Project Planner** (option #7, `project_planner.ps1`) scans a folder or file share and builds a complete, offline planning report for a migration project, for example a file server moving to SharePoint or Azure Blob.

It reads names, sizes, dates and attributes only. It never opens, changes, moves or deletes files, and OneDrive cloud-only files stay in the cloud. No admin rights needed. Requires Windows PowerShell 5.1 or later (the menu option checks this).

**Start screen:** client name, project description, ticket #, **Folder to scan**, **Save report to** (default `C:\ITTools\Reports`; not inside the folder being scanned), optional MRPeasy links CSV and Azure Blob base URL, optional hashing of local files and permissions for the top two folder levels. **Open previous report** opens a `report.html`, or rebuilds a report from a `capture.json` without rescanning (for example to add the MRPeasy check later). Recent reports are listed for double-click.

**Problem checks:** characters that break web links (`#`, `%`, `?`), paths over 260 characters, trailing dots and spaces, names that differ only by case, duplicate names and copies, junk and zero-byte files, bad dates, and Azure Blob name and URL length limits.

**MRPeasy check (optional):** matches each link from the MRPeasy *Settings > Database Maintenance > Export file links* CSV to a real file, flags case mismatches, and drafts `mrp-link-update-DRAFT.csv` (old link, new Blob link).

**Output:** reports go to `C:\ITTools\Reports` by default (created if missing; outside `Scripts`, so toolkit updates never touch them). Each scan writes `<Save report to>\<client>-<ticket>-<yyyyMMdd-HHmm>\` with `report.html` (tabs: Summary, Folders, Files, Issues, MRPeasy links, Help Guide), `capture.json`, `summary.json`, CSVs and `device-info.txt`, plus a `.zip` of the same name to send back.

**Duplicates and space savings:** `LIKELY_DUPLICATE` (same name and size) and, with *Hash local files*, `DUP_CONTENT` (identical contents, even under different names) are grouped into sets. Clicking either issue on the report lists each set with every folder its copies are in and the space it could save. The Summary tab, the console and `summary.json` show the **total a cleanup could save** (proven when files were hashed, otherwise likely), its share of the scan, and the size after cleanup. `duplicates.csv` lists every copy. Program folders inflate these numbers, because apps ship their own copies of runtime files; they matter most on document shares.

**Optional checks, when to use them:** *Hash local files* proves which files are identical and how much space a cleanup saves. Use it before a duplicate cleanup; it reads every file, so it is slow on big shares. *Permissions* lists who can open the top two folder levels. Use it for SharePoint or Teams moves; it isn't needed for Azure Blob.

**When the scan finishes** a *Scan complete* window shows where the report was saved, with **Open report**, **Open folder** (File Explorer with the zip selected) and **Email** buttons. **Outlook** opens a new email to Superior Networks with the zip already attached (desktop Outlook). **Gmail** opens a filled-in Gmail message in the browser and the folder next to it, so the zip can be dragged in (browsers can't attach files by themselves). The same Open folder, Outlook and Gmail buttons are on the report page. Zips over 20 MB get a warning to share a OneDrive or Google Drive link instead.

**Standalone use** (PC without the full toolkit): copy `project_planner.ps1` and `run_project_planner.cmd` into one folder and double-click the `.cmd`. Unattended:

```powershell
powershell -ExecutionPolicy Bypass -File .\project_planner.ps1 -NoGui -Client "Acme" -Project "File server to Azure" -Ticket 12345 -Path "D:\Shares\Design"
```

Tests (fake share, end-to-end checks) live in the repo under `tests/project_planner/` and are not installed on client machines.

---

## Claude Temporary Access

**Claude Temporary Access** (option #8) lets a technician give Claude on sn-claude1026 a temporary admin shell on a Windows PC, without opening any port on the client's network.

**Open access** asks how many hours (1 to 12, default 4), asks for confirmation, then asks for a Tailscale auth key. Use the reusable key saved in Keeper, and paste it only at the prompt on the PC. To make a new one at [Tailscale Keys](https://login.tailscale.com/admin/settings/keys), turn Reusable and Ephemeral on, set 90 days, and choose tag `tag:temp-support`.

It then:
- Joins the PC to the Superior Networks Tailscale network as `<computer name>-temp`, with DNS and routes left alone
- Runs a private OpenSSH copy as service `SNClaudeSSH`, on port 2222, on the Tailscale address only
- Adds local admin `svc-claude-temp` with a random password nobody sees, key login only
- Allows only sn-claude1026 through the firewall and blocks port forwarding
- Sets a SYSTEM scheduled task that closes everything when the time is up

**Close access now** removes the service, account, firewall rule, Tailscale, task and files. Windows can hold the profile folder until the next reboot, and the log says if it did. A one-time startup task then removes it. If opening fails at any step, it removes what it added.

**Good to know:**
- Needs Windows PowerShell 5.1 or later and 64-bit Intel or AMD Windows, run as admin
- Access survives a reboot of the PC, so the session can continue after one
- Stops if Tailscale is already on the PC, so its settings are left alone
- Leaves any OpenSSH already on the PC alone
- This is full admin access. Use it only with the client's work in scope
- Each login is listed in `C:\ProgramData\SN-ClaudeAccess\access.log`, which stays after closing
- Open and close are also logged to `master_audit_log.txt`

---

## HP M404dn Printer Troubleshooter

The **HP M404dn Printer Troubleshooter** submenu (option #6) provides a guided workflow for diagnosing and repairing common HP LaserJet Pro M404dn printing failures, including loss of network or USB connectivity, stuck print jobs, and corrupted printer drivers.

```
SUPERIOR NETWORKS LLC
HP M404dn Printer Troubleshooter - Toolkit v3.20.1

  1. Connectivity Test (network / USB diagnostics)
  2. Spooler Repair (stuck jobs / hung spooler)
  3. Install as Network Printer / Driver Reinstall

  B. Back to Main Menu
```

### Recommended Repair Workflow

Start with **Connectivity Test** to identify whether the workstation can reach the printer over Ethernet or whether Windows can see the USB-connected hardware. If the printer is reachable but jobs remain stuck, run **Spooler Repair** to stop the Print Spooler service, clear orphaned spool files, and restart the service. Use **Driver Reinstall** only after the connectivity and spooler checks, when the installed printer object, TCP/IP port, or HP PCL-6 driver is corrupted or incorrectly configured.

**Files:**
- `hp_m404dn_troubleshooter.ps1` - Main printer troubleshooting submenu
- `hp_m404dn_connectivity_test.ps1` - Network and USB connectivity diagnostics
- `hp_m404dn_spooler_repair.ps1` - Stuck-job and Print Spooler repair utility
- `hp_m404dn_driver_reinstall.ps1` - Clean printer, port, and driver reinstall utility

### Tool Features

#### Option 1 - Connectivity Test

- Detects an installed M404dn queue and retrieves the configured TCP/IP port address when available.
- Tests ICMP reachability and TCP ports 9100, 80, 443, and 161 for a network-connected printer.
- Enumerates HP USB printer devices and flags common device-class misidentification symptoms.
- Checks the Windows Print Spooler service and presents a plain-language diagnosis summary.

#### Option 2 - Spooler Repair

- Lists pending jobs for the HP M404dn queue before repair.
- Stops the Print Spooler, clears orphaned `.SHD` and `.SPL` files from `C:\Windows\System32\spool\PRINTERS`, then restarts and verifies the service.
- Includes a quick spooler restart option and a manual spool-folder cleanup option.
- Requires an elevated toolkit session but does not trigger a second UAC prompt.

#### Option 3 - Driver Reinstall

- **On open**, if the M404dn is not installed, is connected by USB, WSD or a local port, or is installed more than once, the tool asks "Install the HP M404dn as a network printer now?" and then asks for the printer's IP (with a tip on finding it; when existing copies all use one IP it is offered as the default, and when they use different IPs it lists them and the technician types the right one).
- **View Current Install** lists every M404dn printer copy with its connection (USB cable, WSD, or network IP), driver and queued jobs, and warns when there is more than one copy.
- **Install as Network Printer** (option 2, also offered on open) checks before it changes anything: validates the IP, tests TCP 9100 on the printer, and finds a usable HP driver (keeps the one already installed; the HP M404 driver is not built into Windows, so it asks for the HP package `.inf` only when none is present). It then shows the plan and asks for confirmation, clears stuck jobs, removes the old copies and their TCP/IP ports, restarts the spooler (if a stuck job still blocks a copy, it offers to clear the spool folder and retry; if a copy still will not delete, it stops without adding a duplicate), creates one standard TCP/IP port and one printer, verifies it, and offers a test page. If any step fails it reports FAILED, and if it stops before the plan is confirmed nothing is changed.
- **Remove Selected Copies** removes only the copies picked from a numbered list (for example an old USB copy or a "(Copy 1)" duplicate), after confirmation.
- The HP driver is never deleted. Set the default printer while logged in as the user; default printers are per user.

---

## StorageCraft Troubleshooter

The **StorageCraft Troubleshooter** submenu (option #3) provides comprehensive backup management tools:

```
SUPERIOR NETWORKS LLC
StorageCraft Troubleshooter - Toolkit v3.20.1

Manual Tools:
  1. Upload Single File (PowerShell FTP)
  2. Sync Local Backups to FTP (WinSCP)
  3. Upload ImageManager Queue (WinSCP)
  4. Test FTP Connectivity (PS Checker)

ImageManager Service Management:
  5. Start ImageManager Service
  6. Stop ImageManager Service
  7. Restart ImageManager Service
  8. Check ImageManager Service Status

Logs and Diagnostics:
   9. StorageCraft Logs (SPX & ImageManager)
  10. View FTP Upload Logs

Utilities:
  11. Download/Install WinSCP
  12. Install Access Database Engine

  B. Back to Main Menu
```

---

## Large File Transfer Fix Guide (18GB+ Stalls)

If you are experiencing FTP transfer stalls with very large files (e.g., 18GB+ StorageCraft full backups), this is a known limitation of the FTP protocol over NAT firewalls. The control connection times out while the data connection is busy.

A comprehensive four-layer fix guide has been added to the toolkit to permanently resolve this issue. It covers:
1. **Client-Side Script Improvements** (Already implemented in v3.7.10)
2. **FileZilla Server Settings** (Timeouts and Passive Ports)
3. **UDM Firewall Tuning** (Port Forwarding)
4. **SFTP Migration** (The permanent fix using OpenSSH)

Please refer to the `Large_File_Transfer_Fix_Guide.md` file in the repository for the complete step-by-step instructions.

---

## Feature Details

### 1. Upload Single File (PowerShell FTP)

**Purpose:** Manual file selection and FTP upload when ImageManager replication fails

**Features:**
- Browse and select `.spi` backup files from local directory
- Multi-file selection support
- Upload to FTP server with progress tracking
- Pre-configured for ftp.sndayton.com
- Comprehensive logging to `ftp_upload_log.txt`
- Error handling and retry logic

**Use Case:** When ImageManager FTP replication is stuck or failing, manually upload critical backup files

**File:** `ftp_troubleshooter_tool.ps1`

---

### 2. Sync Local Backups to FTP (WinSCP)

**Purpose:** Compare local backup directory with FTP server to identify missing files

**Features:**
- Scans local directory for `-cd.spi` files (incremental backups)
- Connects to FTP server using **WinSCP** (professional FTP client)
- Compares files by name and size
- Displays detailed sync report showing files on local but not on FTP
- Bulk upload missing files using WinSCP engine
- Automatic WinSCP portable download (first run only)
- Export report to text file
- Comprehensive logging to `ftp_sync_log.txt`

**Technology:**
- Uses **WinSCP 6.5.5 Portable** (open-source, trusted by millions)
- Auto-downloads from winscp.net on first run (~8 MB)
- Installs to `C:\ITTools\Scripts\WinSCP`
- No installation required - fully portable

**Use Case:** Monitor backup sync status and identify which incremental backups need uploading

**File:** `ftp_sync_tool.ps1`

---

### 3. Upload ImageManager Queue (WinSCP) ⭐

**Purpose:** Query ImageManager database for replication queue and upload queued files via FTP

**Features:**
- **Queries ImageManager.mdb database** directly
- Automatic database schema discovery
- Finds replication-related tables (ReplicationQueue, Jobs, Tasks, etc.)
- Extracts file paths from queue data
- Displays all files waiting to replicate
- Shows source table and column for each file
- Upload queued files via WinSCP
- Pre-configured for ftp.sndayton.com
- Comprehensive logging to `ftp_sync_imagemanager_log.txt`

**Technology:**
- Uses **Microsoft ACE OLE DB Provider** to query .mdb database
- Connection: `Provider=Microsoft.ACE.OLEDB.12.0`
- Auto-detects if ACE provider is missing and offers to install
- Smart table discovery algorithm
- Searches for `.spi` files in database fields

**Requirements:**
- Microsoft Access Database Engine (ACE) OLE DB Provider
- Automatically prompts to install if missing (menu option #12)
- Free Microsoft component (~25 MB download)
- Works on all Windows versions (Server 2008 R2+, Windows 7+)

**Database Location:** `C:\Program Files (x86)\StorageCraft\ImageManager\ImageManager.mdb`

**Why This Is Better:**
- ✅ Reads directly from ImageManager's queue
- ✅ Shows only files ImageManager has queued for replication
- ✅ More accurate than directory comparison
- ✅ Reflects ImageManager's actual state
- ✅ Helps troubleshoot why files aren't replicating

**Use Case:** Upload files that ImageManager has queued but hasn't replicated yet. Perfect for troubleshooting replication issues.

**Files:** 
- `ftp_sync_imagemanager.ps1` - Main tool
- `imagemanager_db_module.ps1` - Database query utility module

---

### 4. Test FTP Connectivity (PS Checker) ⭐ NEW

**Purpose:** Test FTP connectivity, authentication, and directory listing using pure PowerShell without relying on external tools like WinSCP.

**Features:**
- Pure PowerShell implementation (no WinSCP dependency)
- Tests TCP Port 21 connectivity
- Tests FTP authentication
- Tests FTP directory listing
- Verbose troubleshooting output
- Comprehensive logging to master audit log

**Use Case:** Useful for isolating network/firewall issues when FTP uploads fail.

**File:** `ftp_ps_checker.ps1`

---

### 5-8. ImageManager Service Management

**Purpose:** Control the StorageCraft ImageManager Windows service

**Features:**
- **Start Service** - Start ImageManager service
- **Stop Service** - Stop ImageManager service
- **Restart Service** - Restart ImageManager service
- **Check Status** - Display detailed service information

**Requirements:** Administrator privileges

**Service Name:** `StorageCraft ImageManager`

**Use Case:** Quickly manage ImageManager service without opening Services console

---

### 11. Download/Install WinSCP

**Purpose:** Install WinSCP portable for FTP sync operations

**Features:**
- Downloads WinSCP 6.5.5 installer from GitHub repository
- Extracts portable version to `C:\ITTools\Scripts\WinSCP`
- Detects existing installation
- Shows version information
- Silent installation (no user interaction)
- TLS 1.2 support for older systems

**Use Case:** Required for FTP Sync tools (options #2 and #3)

---

### 12. Install Access Database Engine

**Purpose:** Install Microsoft Access Database Engine for ImageManager database access

**Features:**
- **Triple detection method** - Registry, OLE DB providers, and DLL files
- **Auto-detects system architecture** - 64-bit vs 32-bit
- **Works on all Windows versions** - Server 2008 R2 through Server 2022, Windows 7-11
- **Verbose troubleshooting** - Detailed on-screen output and logging
- **Comprehensive logging** - All operations logged to toolkit logs
- **Always asks confirmation** - User control before installation
- **Silent installation** - No user interaction during install
- **Post-installation verification** - Tests provider availability
- **Error handling** - Retry option and manual instructions
- **Disk space validation** - Ensures 200 MB free space
- **Administrator check** - Validates privileges before proceeding

**What It Installs:**
- Microsoft Access Database Engine (ACE) OLE DB Provider
- Size: ~25 MB download, ~50 MB installed
- Official Microsoft component
- Does NOT install Microsoft Access application
- Only installs database drivers and OLE DB providers

**Detection Methods:**
1. **Registry Check** - Searches Office registry paths for ACE installation
2. **OLE DB Provider Test** - Tests if ACE providers are available (12.0, 14.0, 15.0, 16.0)
3. **DLL File Check** - Looks for ACEOLEDB.DLL in Common Files

**Installation Process:**
1. Detects if already installed (skips if present)
2. Checks Windows version and architecture
3. Validates disk space (200 MB required)
4. Asks user confirmation
5. Downloads installer from Microsoft (~25 MB)
6. Runs silent installation
7. Verifies installation success
8. Offers retry or manual instructions if failed

**Use Case:** Required for option #3 (Upload ImageManager Queue). The tool will auto-prompt to install if missing.

**Hybrid Approach:**
- **Menu Option #12** - Install manually anytime
- **Auto-Prompt** - When using option #3, automatically detects and offers to install

**File:** `install_access_engine.ps1`

---

### 9. StorageCraft Logs (SPX & ImageManager) - NEW in v3.17.0

**Purpose:** Browse, search, and open the StorageCraft logs that explain what SPX and ImageManager
actually did, without hunting through Explorer or remembering log paths.

**Searched Locations:**

- `C:\ProgramData\StorageCraft\spx\log` - ShadowProtect SPX service and backup job logs
- `%LocalAppData%\StorageCraft\spx-gui\log` - SPX GUI and context menu logs (current user)
- Other local user profiles that contain SPX GUI logs (detected only when present)
- `C:\Program Files\StorageCraft\ImageManager\Logs` and `C:\Program Files (x86)\StorageCraft\ImageManager\Logs`
- `C:\ProgramData\StorageCraft\ImageManager\Logs`

**Log Library:**

- One table combining every discovered log with its **source**, **date modified**, **size**, and **file name**
- Sorts by date modified (newest first), file name, or size (largest first)
- Filters by source (`SPX Service`, `SPX GUI`, `ImageManager`) and by file name text
- Page navigation for long lists, plus a source status header showing which paths were found or missing

**Built-in Log Viewer:**

- Select any file by number to open it inside the toolkit; no external viewer is required
- Page forward and backward through large logs, jump to a specific line, or jump to the start or end of the file
- Find text with a match list (line numbers plus preview) and jump straight to a match
- Highlight every match on the visible page, and optionally wrap long lines to the window width
- Open the selected log in Notepad, open its containing folder, or export a timestamped copy for a support ticket

**Diagnostics Features:**

- **Cross-log search** - scan every discovered log for one string and see which files matched
- **Export for support** - copies a selected log to `C:\ITTools\Scripts\Logs\LogExports` with a timestamp
- **Verbose troubleshooting mode** - optional on-screen trace written to `C:\ITTools\Scripts\Logs\storagecraft_log_viewer_log.txt`
- **Master audit logging** - every file opened, search run, filter change, and error is recorded
- **Administrator recommended** - reading `ProgramData` and `Program Files` logs may require elevated rights

**Use Case:** Confirm whether a backup actually ran, diagnose failed or missed SPX jobs, and review
ImageManager verification, consolidation, and retention behavior when a replication or retention
problem is reported.

**File:** `storagecraft_log_viewer.ps1`

---

### 10. View FTP Upload Logs

**Purpose:** View and analyze FTP operation logs

**Features:**
- Opens log file in Notepad
- Shows log file size and last modified date
- Handles missing log files gracefully
- Color-coded log entries (ERROR, WARN, SUCCESS)

**Log Locations:**
- FTP Upload Log: `C:\ITTools\Scripts\Logs\ftp_upload_log.txt`
- FTP Sync Log: `C:\ITTools\Scripts\Logs\ftp_sync_log.txt`
- FTP Sync (ImageManager) Log: `C:\ITTools\Scripts\Logs\ftp_sync_imagemanager_log.txt`
- Master Audit Log: `C:\ITTools\Scripts\Logs\master_audit_log.txt`

---

### Toolkit Logs Menu

**Purpose:** Centralized log viewer for all toolkit operations

**Features:**
- View Master Audit Log
- View FTP Upload Log
- View FTP Sync Log
- Opens logs in Notepad
- Shows file size and last modified date
- Handles missing logs gracefully

**Use Case:** Troubleshoot toolkit operations and track historical activity

---

### ConnectWise RMM Troubleshooter (Option 4)

#### Option 1 — Repair ScreenConnect (Uninstall/Cleanup)

**Purpose:** Remove all stuck, broken, or orphaned ScreenConnect Client installations from an endpoint.

**Features:**
- Detects all installed ScreenConnect Client packages via PowerShell `Get-Package` (PackageManagement)
- Secondary detection via WMI `Win32_Product` for instances not visible to PackageManagement
- Force-uninstalls all discovered instances
- Stops and removes leftover `ScreenConnect Client*` Windows services via `sc.exe delete`
- Verbose on-screen output and full logging to `screenconnect_repair_log.txt`
- Administrator privilege enforcement

**When to Use:** Run this first when the RMM dashboard shows "ScreenConnect Installation Pending" or when a ScreenConnect agent is stuck and cannot be reinstalled over the top of an existing broken install.

**File:** `screenconnect_repair.ps1`

---

#### Option 2 — Repair ConnectWise RMM (Platform Watchdog)

**Purpose:** Download and run the official ConnectWise RMM Platform Watchdog repair utility to diagnose, restore, or cleanly remove the RMM agent.

**Features:**
- Downloads `platform-watchdog.exe` from the official ConnectWise source to `C:\ITTools\Scripts\Downloads\CWRMM`
- Skips re-download if the file already exists
- Presents four repair actions via an interactive sub-menu
- Verbose on-screen output and full logging to `cw_rmm_repair_log.txt`
- TLS 1.2 enforced for compatibility with Windows Server 2012 R2
- Administrator privilege enforcement

**Available Actions:**

| Action | Flag | Description |
|---|---|---|
| Health Check | `-action=healthcheck -display=yes` | Scans agent components and reports health status without making changes |
| Health Check and Restore | `-action=healthcheckandrestore -display=yes` | Scans and automatically repairs or redeploys missing components including ScreenConnect |
| Uninstall | `-action=uninstall -display=yes` | Completely removes the ConnectWise RMM agent from the endpoint |
| Auto Update Cleanup | `-action=autoupdatecleanup -display=yes` | Clears cached update files that may be causing agent update failures |

**When to Use:** Run this second, after the ScreenConnect Cleanup (Option 1). Select **Health Check and Restore** to trigger an automatic redeployment of ScreenConnect from the RMM platform.

**Download Source:** `https://prod.setup.itsupport247.net/windows/RepairUtility/32/Platform-Watchdog/EXE/utility`

**File:** `connectwise_rmm_repair.ps1`

---

### HP M404dn Printer Troubleshooter (Option 6)

**Purpose:** Diagnose and repair HP LaserJet Pro M404dn printing problems from a single guided submenu.

**Features:**
- **Connectivity Test:** Checks network reachability, raw printing and management ports, USB device detection, and Print Spooler status.
- **Spooler Repair:** Clears stuck jobs and orphaned spool files, then restarts and verifies the Print Spooler service.
- **Driver Reinstall:** Removes a broken M404dn printer installation and rebuilds it with a standard TCP/IP port and the appropriate HP driver.
- **Unified Versioning:** Every banner reads the master toolkit version dynamically from `launch_menu.ps1`.
- **No Duplicate Elevation:** Repair tools report a missing elevated session instead of reopening themselves with a second UAC prompt.

**Files:** `hp_m404dn_troubleshooter.ps1`, `hp_m404dn_connectivity_test.ps1`, `hp_m404dn_spooler_repair.ps1`, and `hp_m404dn_driver_reinstall.ps1`

---

### Windows/Office Activation (MAS)

**Purpose:** Activate Windows and Office using MassGrave Activation Scripts

**Features:**
- Launches official MassGrave Activation Scripts (MAS)
- Direct download from GitHub
- Supports Windows and Office activation
- Industry-standard activation tool

**Source:** https://github.com/massgravel/Microsoft-Activation-Scripts

---

## Installation Details

### Directory Structure

```
C:\ITTools\
├── Scripts\                    # Main installation directory
│   ├── launch_menu.ps1        # Main launcher
│   ├── cwrmm_troubleshooter.ps1
│   ├── connectwise_rmm_repair.ps1
│   ├── screenconnect_repair.ps1
│   ├── hp_m404dn_troubleshooter.ps1
│   ├── hp_m404dn_connectivity_test.ps1
│   ├── hp_m404dn_spooler_repair.ps1
│   ├── hp_m404dn_driver_reinstall.ps1
│   ├── bootstrap_macos.sh
│   ├── mac_terminal_ui.sh
│   ├── mac_troubleshooter_terminal.sh
│   ├── Fix-OneDriveSync-macOS.sh
│   ├── MAC_TROUBLESHOOTER_GUIDE.md
│   ├── assets\superior-networks-logo.png
│   ├── storagecraft_troubleshooter.ps1
│   ├── storagecraft_log_viewer.ps1
│   ├── project_planner.ps1
│   ├── run_project_planner.cmd
│   ├── ftp_troubleshooter_tool.ps1
│   ├── ftp_sync_tool.ps1
│   ├── ftp_sync_imagemanager.ps1
│   ├── imagemanager_db_module.ps1
│   ├── bootstrap.ps1
│   ├── launcher.bat           # Quick launcher
│   ├── README.md
│   ├── Temp\                  # Temporary installer and updater files
│   └── Logs\                  # Log directory
│       ├── master_audit_log.txt
│       ├── ftp_upload_log.txt
│       ├── ftp_sync_log.txt
│       ├── ftp_sync_imagemanager_log.txt
│       ├── cw_rmm_repair_log.txt
│       ├── screenconnect_repair_log.txt
│       ├── hp_m404dn_troubleshooter_log.txt
│       ├── hp_m404dn_connectivity_log.txt
│       ├── hp_m404dn_spooler_log.txt
│       ├── hp_m404dn_driver_log.txt
│       ├── storagecraft_log_viewer_log.txt
│       └── LogExports\         # Exported log copies for support tickets
│   ├── Downloads\             # ConnectWise RMM repair utility download
│   │   └── CWRMM\
│   │       └── platform-watchdog.exe
│   └── WinSCP\                # WinSCP portable installation
│       ├── WinSCP.com
│       ├── WinSCP.exe
│       └── ...
```

### System Requirements

- **Operating System:** Windows 7 or later, Windows Server 2012 R2 or later
- **PowerShell:** 4.0 or higher
  - PowerShell 4.0: Windows Server 2012 R2, Windows 7/8 (use `bootstrap_ps4.ps1`)
  - PowerShell 5.1+: Windows 10/11, Server 2016+ (use `bootstrap.ps1`)
- **Permissions:** Administrator privileges (for service management)
- **Internet Access:** Required for initial download and updates
- **Disk Space:** ~20 MB (including WinSCP)

### Optional Requirements

**For ImageManager Integration:**
- StorageCraft ImageManager installed
- ImageManager.mdb database present
- Microsoft Access Database Engine (ACE) OLE DB Provider
  - Usually pre-installed on Windows
  - If not: Download from Microsoft (free)

---

## Update System

### Automatic Updates

The toolkit includes a smart auto-update system:

1. **Version Detection** - Compares installed version with GitHub
2. **Automatic Download** - Downloads new version if available
3. **Staged Update** - Safely replaces files while avoiding locks
4. **Automatic Restart** - Restarts toolkit with new version
5. **Changelog Display** - Shows what's new after update

### Manual Update Check

Select **"1. Download and Install Latest Version"** from main menu

### Bootstrap Installer

The `bootstrap.ps1` script handles:
- Initial installation (if toolkit not present)
- Update checking and installation
- Version comparison
- Launching from correct location
- Error handling and user feedback

---

## FTP Server Configuration

### Default FTP Server

The toolkit is pre-configured for: **ftp.sndayton.com**

### Changing FTP Server

You can enter a different FTP server when prompted by any FTP tool.

### FTP Credentials

All FTP tools prompt for:
- FTP Server (default: ftp.sndayton.com)
- FTP Username
- FTP Password

Credentials are **not stored** - you must enter them each time for security.

---

## Logging and Auditing

### Master Audit Log

**Location:** `C:\ITTools\Scripts\Logs\master_audit_log.txt`

**Purpose:** Tracks all toolkit operations

**Contents:**
- Toolkit launches
- Menu selections
- Tool executions
- Service operations
- Errors and warnings

### FTP Operation Logs

**FTP Upload Log:** `C:\ITTools\Scripts\Logs\ftp_upload_log.txt`
- Manual FTP tool operations
- File uploads
- FTP connection details
- Errors and retries

**FTP Sync Log:** `C:\ITTools\Scripts\Logs\ftp_sync_log.txt`
- Directory comparison operations
- File sync reports
- WinSCP operations
- Missing file lists

**FTP Sync (ImageManager) Log:** `C:\ITTools\Scripts\Logs\ftp_sync_imagemanager_log.txt`
- Database query operations
- Queue file extraction
- Upload operations
- Database errors

### HP M404dn Printer Logs

**HP M404dn Troubleshooter Log:** `C:\ITTools\Scripts\Logs\hp_m404dn_troubleshooter_log.txt`
- Printer submenu starts, selections, missing-file errors, and returns to the main menu

**Connectivity Test Log:** `C:\ITTools\Scripts\Logs\hp_m404dn_connectivity_log.txt`
- Printer discovery, network or USB diagnostics, port results, spooler status, and diagnosis summary

**Spooler Repair Log:** `C:\ITTools\Scripts\Logs\hp_m404dn_spooler_log.txt`
- Queue inspection, spooler service state changes, spool-file cleanup, and verification results

**Driver Reinstall Log:** `C:\ITTools\Scripts\Logs\hp_m404dn_driver_log.txt`
- Printer, driver, and port removal; driver discovery; TCP/IP port creation; reinstall and test-page results

### macOS Troubleshooter Logs

**macOS Master Audit Log:** `~/Library/Logs/SuperiorNetworks/master_audit_log.txt`
- Terminal starts, menu selections, dry-run results, live-repair approvals, outcomes, and errors

**OneDrive Repair Transcript:** `~/Library/Logs/SuperiorNetworks/Fix-OneDriveSync-<timestamp>.log`
- Detailed pre-flight results, process handling, Keychain cleanup, preference backup and removal, and post-repair instructions; automatically opens in TextEdit after a completed run

### StorageCraft Log Viewer Logs

**Log Viewer Activity Log:** `C:\ITTools\Scripts\Logs\storagecraft_log_viewer_log.txt`
- Log inventory refreshes, files opened, searches run, filters, exports, and errors
- Verbose troubleshooting mode writes its detailed trace here and to the screen

**Exported Log Copies:** `C:\ITTools\Scripts\Logs\LogExports\`
- Timestamped copies of StorageCraft logs collected for a support ticket or escalation

### Log Format

```
[2025-12-10 14:30:15] [INFO] FTP Sync Tool started
[2025-12-10 14:30:20] [SUCCESS] Connected to ftp.sndayton.com
[2025-12-10 14:30:25] [WARN] File not found on FTP: backup-001.spi
[2025-12-10 14:30:30] [ERROR] Upload failed: Connection timeout
```

---

## Troubleshooting

### Common Issues

**Issue:** "ImageManager database NOT found"
- **Solution:** Ensure StorageCraft ImageManager is installed
- **Path:** `C:\Program Files (x86)\StorageCraft\ImageManager\ImageManager.mdb`

**Issue:** "WinSCP download failed"
- **Solution:** Download manually from https://winscp.net/
- **Extract to:** `C:\ITTools\Scripts\WinSCP`

**Issue:** "Administrator privileges required"
- **Solution:** Right-click PowerShell and select "Run as Administrator"

**Issue:** "ScreenConnect Installation Pending" in ConnectWise RMM dashboard
- **Solution:** Use Option 4 (ConnectWise RMM Troubleshooter) from the main menu
  1. Run Option 1 (ScreenConnect Cleanup) to remove the broken client
  2. Run Option 2 (CW RMM Repair) and select Health Check and Restore

**Issue:** `platform-watchdog.exe` download fails
- **Solution:** Download manually from `https://prod.setup.itsupport247.net/windows/RepairUtility/32/Platform-Watchdog/EXE/utility` and place in `C:\ITTools\Scripts\Downloads\CWRMM\platform-watchdog.exe`

**Issue:** ScreenConnect cleanup finds no packages but agent is still stuck
- **Solution:** Manually check Add/Remove Programs for any entry matching `ScreenConnect Client (xxxxxxxxxxxxxxxx)` and remove it, then re-run Option 2 (Health Check and Restore)

---

### Do I Need to Remove the Device from the ConnectWise RMM Portal Before Reinstalling?

This depends on the scenario. The table below covers the most common situations a tech will encounter:

| Scenario | Remove from Portal First? | Notes |
|---|---|---|
| Reinstalling on the same machine (broken agent) | **No** | Use `healthcheckandrestore` — the agent repairs in place and the portal record stays intact |
| ScreenConnect stuck / "Installation Pending" | **No** | Run Option 1 (Cleanup) then Option 2 (Health Check and Restore) — portal updates automatically |
| Replacing a machine with new hardware | **Yes** | Delete the old device record from the portal to avoid a stale ghost entry consuming a license seat |
| Duplicate device records appear after reinstall | **No** | Delete the offline/stale duplicate from the portal; keep the record showing Online |

**For the standard "ScreenConnect Installation Pending" fix, you never need to touch the portal.** The `healthcheckandrestore` action re-registers the agent and clears the pending status automatically. Log into the ConnectWise RMM portal after running the repair to confirm the device returns to **Online** status and the ScreenConnect indicator is green.

**Issue:** "Service not found: StorageCraft ImageManager"
- **Solution:** Install StorageCraft ImageManager

### Getting Help

**Check Logs:**
1. Select "2. Toolkit Logs" from main menu
2. View relevant log file
3. Look for ERROR or WARN entries

**GitHub Issues:**
- https://github.com/SuperiorNetworks/IT-Troubleshooting-Toolkit/issues

---

## Security Considerations

### Claude Temporary Access

Option 8 grants full admin access for a limited time. The private key exists only on sn-claude1026. The script holds only the public key, and logins are limited to one account from one address. See [Claude Temporary Access](#claude-temporary-access).

### Execution Policy

The toolkit requires `ExecutionPolicy Bypass` to run PowerShell scripts.

**Bootstrap command includes:** `-ExecutionPolicy Bypass`

This is safe when running trusted scripts from Superior Networks.

### FTP Credentials

- **Not stored** - You must enter credentials each time
- **Not logged** - Passwords are never written to log files
- **Secure input** - Password prompts use `-AsSecureString` when possible

### Administrator Privileges

Required only for:
- Service management (start/stop/restart ImageManager)
- Some system-level operations

Not required for:
- FTP operations
- Log viewing
- Database queries

---

## License and Disclaimer

**Copyright © 2025 Superior Networks LLC**

This software is provided as-is without warranty of any kind.

**Use at your own risk.** Always test in a non-production environment first.

**StorageCraft, ShadowProtect, and ImageManager** are trademarks of StorageCraft Technology Corporation (now Arcserve).

**WinSCP** is open-source software licensed under GNU GPL.

---

## Credits

**Developed by:** Superior Networks LLC

**Third-Party Components:**
- **WinSCP** - https://winscp.net/ (GNU GPL)
- **MassGrave Activation Scripts** - https://github.com/massgravel/Microsoft-Activation-Scripts (GNU GPL)
- **ConnectWise Platform Watchdog** - https://docs.connectwise.com/ConnectWise_RMM/Agents/Agent_Repair_Utility (ConnectWise LLC)

---

## Support

For support, feature requests, or bug reports:

**GitHub Issues:** https://github.com/SuperiorNetworks/IT-Troubleshooting-Toolkit/issues

**Website:** https://github.com/SuperiorNetworks/IT-Troubleshooting-Toolkit

---

## Change Log

### Version 3.20.1 (2026-11-04) - CLAUDE TEMPORARY ACCESS FOR REPEAT USE

- Uses one reusable tagged Tailscale key from Keeper instead of a new key for each job
- Passes the key through a locked file, so it never shows in a process command line
- A warning from Tailscale no longer stops the join; the exit code decides
- The SSH service starts late and keeps retrying, so access comes back after a reboot
- A profile folder held by Windows is removed at the next startup

### Version 3.20.0 (2026-11-03) - CLAUDE TEMPORARY ACCESS

- **New Feature**: Added **Claude Temporary Access** as main-menu **Option 8**. It opens temporary admin SSH access for Claude on sn-claude1026 over Tailscale, with no open port on the client's network.
- **Automatic Removal**: A SYSTEM scheduled task closes access after 1 to 12 hours (default 4). If opening fails at any step, the tool removes what it added.
- **Locked Down**: Private OpenSSH copy on port 2222, Tailscale address only, key login only, one account, one source address, port forwarding off. Both downloads are SHA-256 pinned.
- **Installer**: Both bootstraps now require `claude_temp_access.ps1`.

### Version 3.19.4 (2026-10-08) - HP M404DN SUBMENU WORKFLOW COVERS OPTION 3
- **Recommended Workflow**: The HP M404dn submenu now says when to use option 3 (printer on USB, just moved to Ethernet, or duplicated; or still failing after options 1 and 2) and to have the printer's IP ready from its Configuration Report.

### Version 3.19.3 (2026-10-08) - HP M404DN: OFFER NETWORK INSTALL ON OPEN
- **Guided Start**: Driver Reinstall now checks the PC when it opens. If the M404dn is missing, on USB/WSD/a local port, or installed more than once, it asks to install it as a network printer and asks for the IP, so the technician does not have to know which option to pick.
- **IP Prompt**: Explains how to find the printer's IP (Configuration Report from the printer's Reports menu, or the UniFi client list / DHCP reservation) and offers the existing IP as the default only when all network copies agree (different IPs are listed instead, since one is stale).
- **Labels**: Option 2 is now "Install as Network Printer"; the HP submenu shows "Install as Network Printer / Driver Reinstall"; the view shows each copy's connection type.

### Version 3.19.2 (2026-10-08) - HP M404DN STUCK-JOB REMOVAL
- **Stuck Jobs**: A copy whose stuck job is reloaded on every spooler restart (seen with the real HP V4 driver and a test page to an offline printer) stayed "pending deletion". The tool now offers to clear the spool folder and retry, after a confirmation that warns it deletes queued jobs for every printer.
- **No Duplicates**: If an old copy still will not delete, Network Reinstall stops and reports FAILED instead of adding a second "(Network)" printer next to it.

### Version 3.19.1 (2026-10-07) - HP M404DN DRIVER REINSTALL SAFETY FIXES
- **Checks First**: Network Reinstall now validates the IP, tests the printer on TCP 9100 and finds a usable driver before removing anything. Before, it removed every copy and the driver first, and could leave the PC with no printer while still reporting "Complete".
- **Keeps the Driver**: The installed HP M404 driver is reused instead of deleted. Driver names are matched by wildcard (V3/V4 names).
- **Stuck Jobs**: Queued jobs are cleared and the spooler restarted so copies with a stuck job are really removed; each removal is verified.
- **Pick-list Removal**: New option to remove only selected duplicate or old USB/WSD copies, with confirmation.
- **View Fixed**: View Current Install shows its printer, port and driver tables again.
- **Default Printer**: No longer set from the admin session (it applied to the admin, not the user).

### Version 3.19.0 (2026-10-06) - PROJECT PLANNER DUPLICATE SETS AND SAVINGS
- **Duplicate Sets**: Clicking `LIKELY_DUPLICATE`, `DUP_CONTENT` or `DUP_NAME` on the Issues tab now lists each set of copies with every folder they are in ("Where the copies are"), largest savings first. Before, each copy was listed alone, so it was not clear what it duplicated.
- **Space Savings**: Each set shows how much keeping one copy would save (size x (copies - 1)). The Summary tab, console and `summary.json` show likely savings, proven savings (with *Hash local files*), and a **total**: the proven figure when files were hashed, otherwise the likely figure (they overlap, so they are not added), with its percentage of the scan and the size after cleanup.
- **duplicates.csv**: New file listing every duplicate set and each copy's path, for Excel.
- **Option Hints**: The start screen explains when to use *Hash local files* (duplicate cleanup, reliable savings; slow) and *Permissions* (SharePoint/Teams moves; not needed for Azure Blob). The Help Guide covers the same.
- **Files Updated**: `project_planner.ps1`, `tests/project_planner/run_tests.ps1`, `launch_menu.ps1`, `README.md`.

### Version 3.18.4 (2026-10-06) - INSTALL COMMAND NO LONGER FLAGGED BY DEFENDER
- **New Install Commands**: The one-command installs now download `bootstrap.ps1` (or `bootstrap_ps4.ps1`) to `C:\ITTools`, allow scripts for that PowerShell window only, and run the file. The old commands ran the download straight from memory (`PowerShell.exe -ExecutionPolicy Bypass -Command "irm ... | iex"`), which Microsoft Defender cloud protection flagged as `Trojan:Win32/Commando.A!ml` and blocked.
- **Tested**: On a Windows test PC with Defender cloud protection on, the old command was detected and blocked; the new command installed and opened the menu with no detection, under both the RemoteSigned and the default Windows 10/11 Restricted policy.
- **Progress Off**: The command turns off the download progress bar, which fails without a real console (for example through RMM) and slows downloads in Windows PowerShell 5.1.
- **Paste Into PowerShell**: The new command must be pasted into a PowerShell window (it no longer starts with `PowerShell.exe`, so it does not work from Command Prompt or the Run box).
- **Files Updated**: `README.md`, `BOOTSTRAP_GUIDE.md`, `bootstrap.ps1`, `bootstrap_ps4.ps1` (usage notes), `launch_menu.ps1`.

### Version 3.18.3 (2026-10-06) - PROJECT PLANNER SHOWS WHERE THE REPORT IS
- **Console**: The scan ends with a "REPORT SAVED" block showing the report folder, `report.html` and the `.zip` to send back. When started from the start screen (menu option 7 or `run_project_planner.cmd`), the window now stays open until Enter is pressed; before, it closed as soon as the scan finished.
- **Completion Box**: "Scan complete" now shows the report folder and zip path before asking to open the report.
- **Report Page**: `report.html` has a "Report saved to" bar under the header with the folder path, a Copy path button, the zip name and the computer it was saved on.
- **Scan Complete Window**: Replaces the "Open the report now?" box. Shows the report folder and zip size, with **Open report**, **Open folder** (Explorer with the zip selected), and **Email** to Superior Networks: **Outlook** opens a new email with the zip attached (desktop Outlook; falls back to a filled-in email plus Explorer for New Outlook), **Gmail** opens a filled-in Gmail message plus Explorer to drag the zip in. Warns when the zip is over 20 MB.
- **Report Page Buttons**: The "Report saved to" bar adds **Open folder** and **Outlook** / **Gmail** email buttons (To, Subject and Body filled in; the zip must be attached by hand because browsers can't attach files).
- **Plain Labels**: The start screen says **Folder to scan** (with the hint "Everything inside this folder is scanned. Files are only read, never changed.") and **Save report to**, instead of *Parent path* and *Report path*. Error messages and the report use the same wording.
- **Files Updated**: `project_planner.ps1`, `launch_menu.ps1`, `README.md`.

### Version 3.18.2 (2026-10-06) - PROJECT PLANNER PROGRESS AND HASHING
- **No More Frozen Look**: The scan progress line now updates every second instead of every 1,000 items. With *Hash local files* on, a big share could sit at "Scanning ..." for many minutes with nothing on screen. Files of 50 MB or more show their name and size while they are hashed, and the scan warns up front that hashing reads every file.
- **Faster, More Reliable Hashing**: Uses .NET MD5 directly instead of `Get-FileHash`, which works on long paths in PowerShell 5.0. Files that can't be hashed (locked, access denied) are counted and listed in the scan errors instead of being skipped silently. On PCs in FIPS mode (MD5 blocked) the scan says so and continues without hashes.
- **Files Updated**: `project_planner.ps1`, `launch_menu.ps1`, `README.md`.

### Version 3.18.1 (2026-10-06) - PROJECT PLANNER REPORT FOLDER
- **Default Report Folder**: Project Planner now saves to `C:\ITTools\Reports` by default and creates the folder if it is missing. It sits beside `C:\ITTools\Scripts`, so toolkit updates never remove saved reports. A different folder chosen on the start screen is still remembered. `-NoGui` runs use it when `-ReportPath` is not given.
- **Version Display**: The Project Planner window title, footer and reports now show the toolkit version from the script header instead of `v1.0.0`.
- **Files Updated**: `project_planner.ps1`, `launch_menu.ps1`, `README.md`.

### Version 3.18.0 (2026-10-06) - PROJECT PLANNER
- **New Tool**: Added option 7, **Project Planner** (`project_planner.ps1`), under a new *Project Tools* menu section. It scans a folder or share and builds an offline migration planning report: totals, file types, dates and growth, path lengths, problem names, an expandable folder tree, and a severity-ranked issues list.
- **MRPeasy Link Check**: Optionally matches an MRPeasy file-links export to the scan and drafts an old/new link update CSV for Azure Blob.
- **Read-Only**: Reads metadata only; OneDrive cloud-only files are not downloaded. Requires PowerShell 5.1+, checked before launch. Runs in its own PowerShell window.
- **Tested on Windows PowerShell 5.1**: Full scan of `C:\Program Files` (61,401 files) matched an independent file count. Works without a real console (SSH, RMM): progress-bar errors no longer mark folders as unreadable, and the zip uses .NET ZipFile (no 2 GB per-file limit).
- **Installer**: `project_planner.ps1` added to the required-file check; the repo `tests` folder is no longer copied to client machines (bootstraps and the launcher update option).
- **Execution Policy Fix**: Both bootstraps now allow scripts for their own PowerShell window only (Process scope) before opening the menu. On Windows 10/11 desktops with the default *Restricted* policy, the bootstrap installed the toolkit but could not open the menu ("running scripts is disabled on this system"). The machine's policy is not changed. If the menu still can't start (for example, the policy is set by Group Policy), the bootstrap points to `launcher.bat`.
- **Files Added**: `project_planner.ps1`, `run_project_planner.cmd`, `tests/project_planner/`.
- **Files Updated**: `launch_menu.ps1`, `bootstrap.ps1`, `bootstrap_ps4.ps1`, `README.md`.

### Version 3.17.2 (2026-10-06) - TLS 1.2 FOR WINDOWS 10/11 INSTALL
- **Install Command Fix**: The Windows 10/11 / Server 2016+ one-command install now turns on TLS 1.2 before downloading, like the PowerShell 4.0 command already did. On PCs whose .NET still defaults to TLS 1.0, GitHub refused the download and the install failed.
- **Bootstrap and Launcher**: `bootstrap.ps1` and `launch_menu.ps1` now enable TLS 1.2 at startup, so the bootstrap's own downloads and the launcher's *Download and Install Latest Version* option work on those PCs too.
- **Files Updated**: `bootstrap.ps1`, `launch_menu.ps1`, `README.md`, `BOOTSTRAP_GUIDE.md`.

### Version 3.17.1 (2026-10-06) - BRANCH TESTING ON WINDOWS
- **Branch Override**: `bootstrap.ps1` and `bootstrap_ps4.ps1` now accept the `SUPERIOR_NETWORKS_BRANCH` environment variable, matching `bootstrap_macos.sh`. When it is not set they install `master` exactly as before.
- **Test Branch Behavior**: A non-master branch shows a yellow `TEST BRANCH` line and always reinstalls, since a test branch often has the same version number as the installed copy.
- **Extract Folder Detection**: The bootstraps find the toolkit folder inside the downloaded ZIP instead of assuming `IT-Troubleshooting-Toolkit-master`, so branch names containing `/` also work.
- **Cleanup**: Removed the stale one-off scripts `sync_versions.py` and `update_readme.py` (hardcoded 3.7.x versions).
- **Headers**: Both Windows bootstraps now use the standard Superior Networks script header.
- **Files Updated**: `bootstrap.ps1`, `bootstrap_ps4.ps1`, `launch_menu.ps1`, `README.md`, `BOOTSTRAP_GUIDE.md`.

### Version 3.17.0 (2026-09-24) - STORAGECRAFT LOG VIEWER
- **StorageCraft Logs Section**: Added option 9, `StorageCraft Logs (SPX & ImageManager)`, to the StorageCraft Troubleshooter submenu.
- **Log Library**: Combines the SPX service log path, the SPX GUI log path (current user plus any other local profile that has one), and both common ImageManager log paths into one list showing source, date modified, size, and file name.
- **Built-in Viewer**: Selecting a log opens it in an internal pager with page navigation, jump-to-line, start/end jumps, text search with a match list, match highlighting, and optional line wrap, so very large logs can be reviewed without opening an external editor.
- **Support Workflow**: Logs can be opened in Notepad, their folder opened in Explorer, or a timestamped copy exported to `C:\ITTools\Scripts\Logs\LogExports` for a support ticket.
- **Cross-Log Search**: Optionally scans every discovered log for one string at a time and reports which files matched.
- **Diagnostics**: Adds a verbose troubleshooting mode (screen plus `storagecraft_log_viewer_log.txt`) and master audit logging for opened files, searches, filter changes, and errors.
- **Menu Renumbering**: `View FTP Upload Logs` is now option 10, `Download/Install WinSCP` is option 11, and `Install Access Database Engine` is option 12; all documentation references were updated to match.
- **Files Updated**: `storagecraft_log_viewer.ps1` (new), `storagecraft_troubleshooter.ps1`, `launch_menu.ps1`, and `README.md`.

### Version 3.16.0 (2026-09-16) - MACOS PREREQUISITE FIX
- **Apple Command Line Tools Check**: The macOS bootstrapper now validates `xcode-select -p` before it calls Git. This distinguishes a real Git installation from macOS's placeholder Git launcher.
- **Guided Installation**: When the tools are missing, the bootstrapper requests the Apple installer, states that no toolkit download or partial installation was created, and provides the exact instruction to rerun the same bootstrap command after installation completes.
- **Clearer Failure State**: If Command Line Tools are present but Git still cannot run, the bootstrapper provides a separate diagnostic path instead of reporting a misleading clone failure.
- **Files Updated**: `bootstrap_macos.sh`, `MAC_TROUBLESHOOTER_GUIDE.md`, `launch_menu.ps1`, and `README.md`.

### Version 3.15.0 (2026-09-16) - ONEDRIVE SYNC SERVICE FIX
- **Sync Service Shutdown**: Added explicit detection and shutdown handling for Microsoft's separate `OneDrive Sync Service`, which can remain active after the main OneDrive app exits.
- **PID-Aware Safety Verification**: Replaced the broad process check with PID-aware filtering so the repair ignores its own process while still detecting real OneDrive components. The live repair verifies the app and Sync Service are down before touching credentials or preferences.
- **Safe-Stop Review**: A repair stopped because a OneDrive component remains running now finalizes and automatically opens its timestamped transcript, just like a completed repair or dry run.
- **Files Updated**: `Fix-OneDriveSync-macOS.sh`, `mac_troubleshooter_terminal.sh`, `MAC_TROUBLESHOOTER_GUIDE.md`, `launch_menu.ps1`, and `README.md`.

### Version 3.14.0 (2026-09-16) - TRANSCRIPT REVIEW
- **Automatic Transcript Review**: Every completed OneDrive dry-run or live repair now opens its timestamped transcript automatically in TextEdit. If TextEdit is unavailable, the script tries the macOS default application and prints the manual file path if neither launch succeeds.
- **Operational Control**: Added `--no-open-log` for unattended or diagnostic use when a technician does not want the script to open the transcript window.
- **Auditability**: The master audit log records whether automatic transcript opening succeeded, was skipped, or failed.
- **Files Updated**: `Fix-OneDriveSync-macOS.sh`, `mac_troubleshooter_terminal.sh`, `MAC_TROUBLESHOOTER_GUIDE.md`, `launch_menu.ps1`, and `README.md`.

### Version 3.13.0 (2026-09-16) - BRANDING AND REPAIR SEQUENCE
- **Superior Networks Logo**: Added canonical-logo rendering to the macOS terminal. iTerm2 displays the local PNG inline when available; standard macOS Terminal shows a high-contrast Superior Networks wordmark fallback.
- **Dry-Run Safety**: Clarified and enforced that `--dry-run` reports the full stop, verify, repair, and relaunch sequence but does not close or reopen OneDrive because dry-run makes no changes.
- **Live Repair Sequence**: The live repair now closes OneDrive first, verifies no OneDrive-related process remains before it can alter credentials or preferences, then logs and relaunches OneDrive at completion. If OneDrive will not close, the repair exits before changing those settings.
- **Auditability**: Added master-audit entries for OneDrive closure verification, a blocked repair, and relaunch success, skip, or failure.
- **Files Updated**: `mac_terminal_ui.sh`, `mac_troubleshooter_terminal.sh`, `Fix-OneDriveSync-macOS.sh`, `MAC_TROUBLESHOOTER_GUIDE.md`, `launch_menu.ps1`, and `README.md`.

### Version 3.12.0 (2026-09-16) - USER EXPERIENCE
- **Graphical Terminal Redesign**: Rebuilt the macOS Troubleshooter Terminal as a branded ANSI dashboard using the Superior Networks visual standards: neutral panels, high-contrast instruction cards, explicit status labels, and step indicators.
- **Actionable Instructions**: Added prominent **Start Here**, **What This Repair Does**, **Preview Complete - Action Required**, and **Repair Complete** cards so technicians can identify decisions and safe next steps at a glance.
- **Built-In Help Guide**: Added **Option H - Help Guide** with the core OneDrive workflow, Git update behavior, operating limits, and support-log locations directly in the terminal.
- **Visible Versioning**: Added a persistent footer to terminal pages showing the current master toolkit version and Help Guide entry point.
- **Brand Asset**: Added the canonical Superior Networks logo at `assets/superior-networks-logo.png` with an optional inline iTerm2 rendering enhancement.
- **Files Added**: `mac_terminal_ui.sh` and `assets/superior-networks-logo.png`.
- **Files Updated**: `mac_troubleshooter_terminal.sh`, `MAC_TROUBLESHOOTER_GUIDE.md`, `launch_menu.ps1`, and `README.md`.

### Version 3.11.0 (2026-09-16) - GIT DEPLOYMENT
- **New Feature**: Added `bootstrap_macos.sh`, a one-command native macOS Bash installer that clones the GitHub repository to `~/ITTools/Scripts` and launches the macOS troubleshooting terminal.
- **Version Control**: The macOS installation keeps its `.git` directory, preserves commit history, and uses Git `pull --ff-only` for safe updates from the `master` branch.
- **On-Demand Updates**: Added macOS terminal **Option 2 - Check GitHub for Toolkit Updates**. It explicitly reports when no changes are required or when a new version is installed, and shows that version's release notes.
- **Local-Change Protection**: Git updates do not overwrite uncommitted local changes; the bootstrapper stops and displays Git status for review.
- **Native macOS Deployment**: The installer and terminal use Bash, Git, and curl; PowerShell is not required on macOS.
- **Files Added**: `bootstrap_macos.sh`.
- **Files Updated**: `mac_troubleshooter_terminal.sh`, `MAC_TROUBLESHOOTER_GUIDE.md`, `launch_menu.ps1`, and `README.md`.

### Version 3.10.0 (2026-09-16) - NEW FEATURE
- **New Feature**: Added `mac_troubleshooter_terminal.sh`, a macOS companion terminal with **Option 1 - OneDrive Sync Repair** for post-update synchronization failures.
- **Safe Repair Workflow**: The terminal runs `Fix-OneDriveSync-macOS.sh --dry-run` first and requires a typed `YES` before the live repair. The repair backs up targeted OneDrive preference plists and never deletes OneDrive sync-folder data.
- **Unified Versioning**: The macOS terminal and OneDrive repair script dynamically read the master toolkit version from `launch_menu.ps1`, with a GitHub fallback for standalone macOS deployment.
- **Verbose Auditability**: Added timestamped OneDrive transcripts and a macOS `master_audit_log.txt` that records menu selections, approvals, outcomes, and errors.
- **Files Added**: `mac_troubleshooter_terminal.sh`, `Fix-OneDriveSync-macOS.sh`, and `MAC_TROUBLESHOOTER_GUIDE.md`.
- **Files Updated**: `launch_menu.ps1` and `README.md`.

### Version 3.9.0 (2026-09-14) - NEW FEATURE
- **New Feature**: Added the **HP M404dn Printer Troubleshooter** as main-menu **Option 6**, with a guided connectivity, spooler-repair, and driver-reinstall workflow.
- **Unified Versioning**: All new HP M404dn menus read and display the master toolkit version dynamically from `launch_menu.ps1`.
- **Elevation Handling**: Spooler repair and driver reinstall require an elevated toolkit session without re-launching themselves or prompting a second time through UAC.
- **Installer Manifest**: Added required-file validation for the HP M404dn module to both bootstrap installers.
- **Path Standardization**: Moved temporary, download, and WinSCP locations under `C:\ITTools\Scripts` to keep toolkit files within the established installation structure.
- **Files Added**: `hp_m404dn_troubleshooter.ps1`, `hp_m404dn_connectivity_test.ps1`, `hp_m404dn_spooler_repair.ps1`, `hp_m404dn_driver_reinstall.ps1`.
- **Files Updated**: `launch_menu.ps1`, `bootstrap.ps1`, `bootstrap_ps4.ps1`, `connectwise_rmm_repair.ps1`, `cwrmm_troubleshooter.ps1`, `storagecraft_troubleshooter.ps1`, `ftp_sync_tool.ps1`, `ftp_sync_imagemanager.ps1`, and `README.md`.

### Version 3.8.3 (2026-07-01) - WORKFLOW REORDER
- **UX Fix**: Reordered ConnectWise RMM Troubleshooter submenu into logical repair workflow order
  - **Option 1**: Repair ScreenConnect (Uninstall/Cleanup) — run this first to remove the broken client
  - **Option 2**: Repair ConnectWise RMM (Platform Watchdog) — run this second to redeploy via healthcheckandrestore

### Version 3.8.2 (2026-07-01) - PATH FIX
- **Bug Fix**: Corrected download directory from `C:\ITStuff\Downloads\CWRMM` to `C:\ITTools\Scripts\Downloads\CWRMM` in `connectwise_rmm_repair.ps1` and `cwrmm_troubleshooter.ps1` to stay consistent with the `C:\ITTools` base path used across the entire toolkit

### Version 3.8.1 (2026-07-01) - MENU RESTRUCTURE
- **Menu Fix**: Moved ConnectWise RMM Troubleshooter out of StorageCraft submenu and onto the main menu as its own **Option 4**
- **New Script**: `cwrmm_troubleshooter.ps1` — standalone submenu for CW RMM and ScreenConnect repair
- **Renumbered**: MAS Activation moved from Option 4/4B to **Option 5/5B**

### Version 3.8.0 (2026-07-01) - RMM REPAIR TOOLS
- **New Feature**: Added ConnectWise RMM Agent Repair Utility (`connectwise_rmm_repair.ps1`) — downloads and runs the official `platform-watchdog.exe` with actions: healthcheck, healthcheckandrestore, uninstall, autoupdatecleanup
- **New Feature**: Added ScreenConnect Repair Utility (`screenconnect_repair.ps1`) — detects and uninstalls all ScreenConnect Client instances via PackageManagement and WMI; cleans up leftover services

### Version 3.7.15 (2026-05-15) - SFTP MIGRATION + OPENSSH GUIDE

**New Feature:** Added SFTP protocol support to `ftp_sync_tool.ps1`. At the credential prompt, select `2` for SFTP (encrypted, port 22) or press Enter to keep FTP (plain text, port 21). SFTP uses a single encrypted TCP connection and permanently eliminates the NAT firewall idle stall that causes large file transfers to hang at 0.0 bytes/s.

**New File:** `OpenSSH_Deployment_Guide.md` — step-by-step instructions for installing Win32-OpenSSH on Windows Server 2012 R2, including Windows Firewall rules and UDM port forwarding.

**Technical Detail:** The `Build-OpenString` helper function generates the correct WinSCP `open` command for each protocol. FTP uses `FtpPingType=1 FtpPingInterval=10` keepalive rawsettings. SFTP uses `-hostkey="*"` to accept any server host key (replace with the actual fingerprint for production hardening).

### Version 3.7.14 (2026-05-15) - STAT PARSER FIX

**Bug Fix:** Fixed `Test-FtpFileSizeMatch` to correctly parse WinSCP stat output across two different formats that exist depending on WinSCP version installed. Format A (newer WinSCP): `Size: 18989239512` block format. Format B (older WinSCP): `---------- 0 5710848 May 12 ...` ls-style format. Both formats are now detected and the size extracted correctly. Fixed stat temp file path from `$env:TEMP` to `C:\ITTools\Scripts\Logs`.

### Version 3.7.13 (2026-05-15) - FTP SCAN FIX

**Bug Fix:** Fixed `Retrieved 0 backup file(s)` error. WinSCP scripting mode does not support `ls -R`. Replaced with a multi-pass approach that lists the root directory, then each Level 1 subfolder, then Level 2 subfolders (e.g., `Incrementals`), up to 3 levels deep. This correctly maps the full directory structure: `/SERVER-02/`, `/SQL/`, `/VSN-SERVER22/`, etc. and all files within each.

### Version 3.7.12 (2026-05-15) - MAINTENANCE
- **Unified Versioning**: Removed all individual per-script version numbers. Every script in the toolkit now uses the single master toolkit version from `launch_menu.ps1`. One version number, one place to update.
- **Rule going forward**: Any change to any script = bump `launch_menu.ps1` version = all banners and headers update automatically.

### Version 3.7.11 (2026-05-15) ⭐ NEW
- **Dynamic Version Banners**: All scripts now dynamically read the master toolkit version from `launch_menu.ps1` at runtime.
- **Unified Branding**: Added "SUPERIOR NETWORKS LLC" branding to all tool headers.
- **Simplified Updates**: Bumping the master version in `launch_menu.ps1` now automatically updates the version displayed across the entire toolkit.

### Version 3.7.10 (2026-05-15) 🐛 BUG FIXES
- **Large File Transfer Fix**: Replaced invalid `option keepuptodate` with correct WinSCP `-rawsettings FtpPingType=1 FtpPingInterval=10` to prevent script breakage while maintaining NAT state.
- **StorageCraft File Filter**: Updated `ftp_sync_tool.ps1` to only sync base images (`*.spf`) and daily consolidated images (`*-cd*.spi`). Excludes raw intra-daily incrementals and weekly/monthly/rolling consolidations.
- **Pre-upload Existence Check**: Added check to skip files not found on local disk instead of wasting retries.
- **Manual File List Upload**: Added option to paste a list of filenames to upload manually inside the FTP Sync Tool.
- **Per-module Version Checking**: Updater now checks each individual script's version against GitHub.
- **ASCII Compliance**: Purged all non-ASCII characters from all `.ps1` files to ensure strict PowerShell 4.0 / Server 2012 R2 compatibility.
- **ACE Provider Detection**: Fixed architecture detection in `install_access_engine.ps1` to use `Is64BitProcess` instead of `Is64BitOperatingSystem`.
- **FTP PS Checker**: Added pure PowerShell FTP connectivity tester (`ftp_ps_checker.ps1`) that doesn't require WinSCP.
- **DoH Fallback**: Added MAS Activation DoH Fallback (Option 4B) in `launch_menu.ps1`.

### Version 3.7.9 (2026-05-15)
- **Large File Verification Fix**: Replaced `Test-FtpFileExists` with `Test-FtpFileSizeMatch` in `ftp_sync_tool.ps1`.
- **Stall Recovery**: When a large file transfer stalls due to control channel timeout, the script now opens a fresh session and compares the remote file size against the local file size. If they match exactly, the transfer is marked as successful (`STALL-BUT-COMPLETE`) instead of deleting the file and restarting the upload.

### Version 3.7.4 (2026-04-14) ⭐ NEW + BUG FIXES
- **New Feature**: Added manual file list upload option to FTP Sync Tool
- **New Feature**: Added FTP PS Checker (pure PowerShell FTP connectivity tester)
- **New Feature**: Added DoH fallback for MAS activation
- **Bug Fix**: Updated FTP Sync Tool file filter to include all StorageCraft backup types (.spi, .spf, .spa)
- **Bug Fix**: Fixed ACE provider detection logic in install_access_engine.ps1 and ftp_sync_imagemanager.ps1
- **Bug Fix**: Fixed WinSCP installer verification logic

### Version 3.6.0 (2025-12-11) ⚡ PERFORMANCE + BUG FIX
- **Major Performance Optimization**: 50% faster toolkit updates
  - Moved WinSCP installer (12 MB) to GitHub Releases
  - Removed 13.3 MB of bloat from repository
  - Repository size reduced from 26 MB to 13 MB
  - WinSCP still downloaded on-demand from your GitHub (not on every update)
  - Update time reduced from 30-60s to 15-30s on slow connections
- **Bug Fix**: Improved ImageManager Queue database query
  - Now checks FTP queue tables (ftp1Queue, ftp2Queue, etc.)
  - Finds .spi files even without full paths
  - Automatically builds full paths from separate columns
  - Shows sample data from tables for diagnostics
  - Better detection of queued files in different database structures
- **Files Removed** (13.3 MB):
  - `WinSCP-6.5.5-Setup.exe` (12 MB) - Moved to GitHub Releases
  - `toolkit_screenshot.png` (1.2 MB)
  - `changelog_backup.md`, `CHANGELOG_DISPLAY_EXAMPLE.md`, `HOTFIX_SUMMARY.md`
  - `IMPLEMENTATION_SUMMARY.md`, `AUDIT_LOGGING_GUIDE.md`
  - `test_changelog.ps1`, `imagemanager_db_module.ps1`
- **Files Updated**:
  - `ftp_sync_imagemanager.ps1` (v1.2.0 → v1.3.0)
  - `ftp_sync_tool.ps1` - Updated WinSCP URL
  - `storagecraft_troubleshooter.ps1` - Updated WinSCP URL
  - `launch_menu.ps1` (v3.5.1 → v3.6.0)

**WinSCP Download**: https://github.com/SuperiorNetworks/IT-Troubleshooting-Toolkit/releases/download/v3.5.1-assets/WinSCP-6.5.5-Setup.exe

### Version 3.5.1 (2025-12-11) 🐛 BUG FIX
- **Bug Fix**: Fixed ImageManager Queue tool database query errors
  - Added proper null value handling in database row iteration
  - Added try-catch blocks to skip inaccessible columns
  - Fixed "Cannot index into a null array" error
  - Better error handling for different database structures
  - Tool now gracefully handles null/empty values in database fields
- **Files Updated**:
  - `ftp_sync_imagemanager.ps1` (v1.1.0 → v1.2.0)
  - `launch_menu.ps1` (v3.5.0 → v3.5.1)

**Use Case**: Users can now successfully query ImageManager database even when some fields contain null values or have unexpected structures.

### Version 3.5.0 (2025-12-11) ⭐ NEW
- **Major Feature**: Access Database Engine Auto-Installer
  - New menu option #10: "Install Access Database Engine"
  - Hybrid approach: Manual installation via menu + auto-prompt when needed
  - Required for option #3 (Upload ImageManager Queue) to read ImageManager.mdb
  - Triple detection method: Registry, OLE DB providers, and DLL files
  - Auto-detects 64-bit vs 32-bit systems
  - Works on all Windows versions (Server 2008 R2+, Windows 7-11)
  - Verbose troubleshooting output on-screen
  - Comprehensive logging to toolkit logs
  - Always asks for user confirmation before installing
  - Silent installation with progress tracking
  - Post-installation verification
  - Retry option and manual instructions if installation fails
  - Disk space validation (200 MB required)
  - Administrator privilege check
- **Auto-Detection Integration**:
  - Option #3 (Upload ImageManager Queue) now auto-detects missing ACE
  - Prompts user to install if not found
  - Seamless integration - no manual steps required
  - Can also install manually via menu option #10 anytime
- **What It Installs**:
  - Microsoft Access Database Engine (ACE) OLE DB Provider
  - Size: ~25 MB download, ~50 MB installed
  - Official Microsoft component (not third-party)
  - Only installs database drivers (not Access application)
  - Safe for all Windows Server versions
- **Files Added**:
  - `install_access_engine.ps1` (v1.0.0) - ACE installer with verbose logging
- **Files Updated**:
  - `storagecraft_troubleshooter.ps1` (v1.6.0 → v1.7.0) - Added menu option #10
  - `ftp_sync_imagemanager.ps1` (v1.0.0 → v1.1.0) - Added ACE auto-detection
  - `launch_menu.ps1` (v3.4.0 → v3.5.0)
  - `README.md` - Added comprehensive ACE installer documentation

**Use Case**: Users on fresh Windows installations or systems without Office can now easily install the required Access Database Engine to use the ImageManager Queue tool. The tool automatically detects and offers to install if missing.

### Version 3.4.0 (2025-12-10)
- **Improved UX**: Clearer Menu Names for FTP Tools
  - Renamed confusing menu options for better clarity
  - Each name now describes what the tool does and which technology it uses
- **Menu Changes**:
  - "Manual FTP Tool" → **"Upload Single File (PowerShell FTP)"**
  - "FTP Sync" → **"Sync Local Backups to FTP (WinSCP)"**
  - "FTP Sync (ImageManager Queue)" → **"Upload ImageManager Queue (WinSCP)"**
- **Benefits**:
  - Immediately understand what each tool does
  - Know which technology is used (PowerShell vs WinSCP)
  - No more confusion between two "FTP Sync" options
  - Action-focused naming (Upload, Sync)
- **Files Updated**:
  - `storagecraft_troubleshooter.ps1` (v1.5.0 → v1.6.0)
  - `launch_menu.ps1` (v3.3.0 → v3.4.0)
  - `README.md` - Updated all documentation

**Use Case**: Users can now quickly identify which tool to use based on clear, descriptive names instead of generic "FTP Sync" labels.

### Version 3.3.0 (2025-12-10)
- **Major Improvement**: WinSCP Now Downloaded from GitHub Repository
  - Uploaded WinSCP 6.5.5 installer to GitHub repository (11.11 MB)
  - All download functions now use GitHub-hosted installer
  - Much more reliable than downloading from winscp.net
  - No more SSL/TLS connection errors on Server 2012 R2
  - Uses silent installer extraction instead of ZIP files
- **Benefits**:
  - Single source of truth (your own repository)
  - Faster downloads (GitHub CDN)
  - No dependency on external websites
  - Works perfectly on PowerShell 4.0 (Server 2012 R2)
  - Consistent download experience across all systems
- **Files Updated**:
  - `storagecraft_troubleshooter.ps1` (v1.4.0 → v1.5.0)
  - `ftp_sync_tool.ps1` - Updated download URL and method
  - `ftp_sync_imagemanager.ps1` - Updated download URL and method
  - `launch_menu.ps1` (v3.2.0 → v3.3.0)
- **New File**:
  - `WinSCP-6.5.5-Setup.exe` - Hosted in repository

**Use Case**: WinSCP downloads are now 100% reliable on all Windows versions, including Server 2012 R2. No more external download failures.

### Version 3.2.0 (2025-12-10)
- **New Feature**: WinSCP Download Menu Option
  - Added option #9 in StorageCraft Troubleshooter: "Download/Install WinSCP"
  - Manual WinSCP download/installation from menu
  - Automatic detection of existing WinSCP installation
  - Version display if already installed
  - Prevents re-downloading if already present
- **Improved Download Reliability**:
  - All WinSCP download functions now auto-enable TLS 1.2
  - Changed from `Invoke-WebRequest` to `WebClient` for PowerShell 4.0 compatibility
  - Works on Windows Server 2012 R2 (PowerShell 4.0)
  - No more "Unable to connect to remote server" errors on older systems
- **Files Updated**:
  - `storagecraft_troubleshooter.ps1` (v1.3.0 → v1.4.0)
  - `ftp_sync_tool.ps1` - Improved download function
  - `ftp_sync_imagemanager.ps1` - Improved download function
  - `launch_menu.ps1` (v3.1.0 → v3.2.0)

**Use Case**: Users on Windows Server 2012 R2 can now download WinSCP automatically without SSL/TLS errors. Menu option allows manual retry if automatic download fails during FTP Sync tool launch.

### Version 3.1.0 (2025-12-10)
- **New Feature**: FTP Sync with ImageManager Integration
  - Query ImageManager.mdb database for replication queue
  - Display files waiting to replicate from ImageManager queue
  - Upload queued files directly via FTP using WinSCP
  - Automatic database schema discovery
  - Pre-configured for ftp.sndayton.com
  - New menu option: "FTP Sync (ImageManager Queue)"
- **New Files**:
  - `ftp_sync_imagemanager.ps1` - ImageManager-integrated FTP sync tool
  - `imagemanager_db_module.ps1` - Database query module (utility)
- **Updated Files**:
  - `storagecraft_troubleshooter.ps1` (v1.2.0 → v1.3.0)
    - Added option 3: FTP Sync (ImageManager Queue)
    - Renumbered all subsequent menu options (4-8)
  - `launch_menu.ps1` (v3.0.3 → v3.1.0)

**Use Case**: Administrators can now upload files directly from ImageManager's replication queue, ensuring only files that ImageManager has queued for replication are uploaded via FTP. This is more accurate than directory comparison.

### Version 3.0.3 (2025-12-08)
- **Bug Fix**: Fixed WinSCP download URL (404 error)
  - Changed from GitHub releases URL to official winscp.net download
  - Updated to WinSCP 6.5.5 (latest version)
  - URL: https://winscp.net/download/WinSCP-6.5.5-Portable.zip
  - This URL is more reliable and directly from WinSCP official site
  - Download should now work correctly

### Version 3.0.2 (2025-12-08)
- **Version Bump**: Maintenance release
  - No functional changes
  - Version increment for deployment tracking

### Version 3.0.1 (2025-12-08)
- **Bug Fix**: Fixed WinSCP download and extraction error
  - Changed download URL to GitHub releases (more reliable)
  - Updated to WinSCP 6.3.5 (latest stable)
  - Replaced `Expand-Archive` with .NET `ZipFile.ExtractToDirectory` for better compatibility
  - Changed download method from `WebClient` to `Invoke-WebRequest` for reliability
  - Fixed "End of Central Directory record" extraction error
  - Better error messages with manual download instructions

### Version 3.7.0 (2026-04-14)
- Added FTP PS Checker tool to test FTP connectivity using pure PowerShell
- Added DoH fallback method for MassGrave Activation Scripts (MAS)
- Fixed WinSCP installer verification to ensure executable exists before reporting success
- Updated documentation to reflect new menu options and versions

### Version 3.6.0 (2025-12-08)
- **Major Rewrite: FTP Sync now uses WinSCP**: Professional-grade FTP synchronization
  - Completely rewrote FTP Sync tool to use WinSCP open-source FTP client
  - Eliminates all PowerShell parsing issues with custom FTP code
  - Automatic WinSCP portable download on first run (no installation needed)
  - Pre-configured for ftp.sndayton.com
  - WinSCP handles all FTP operations (listing, comparison, upload)
  - Much more reliable and battle-tested than custom code
  - Professional features: resume support, error handling, logging
- **Features**:
  - Auto-downloads WinSCP 5.21.7 Portable (only once)
  - Installs to C:\ITTools\Scripts\WinSCP
  - Uses WinSCP scripting interface for automation
  - Comprehensive WinSCP logging to C:\ITTools\Scripts\Logs\winscp.log
  - Still filters for *-cd.spi files
  - Shows detailed sync report
  - Bulk upload with WinSCP engine
- **Why WinSCP**:
  - Open-source, trusted by millions
  - Handles all FTP edge cases and errors
  - No PowerShell string parsing issues
  - Professional-grade reliability
  - Active development and support

### Version 2.9.3 (2025-12-08)
- **Bug Fix**: FTP Sync syntax error fix (third attempt - using string concatenation)
  - Format operator still caused parser errors in PowerShell 5.1
  - Changed to simple string concatenation with intermediate variable
  - `$summaryText = "Total: " + $count + " files (" + $totalGB + " GB)"`
  - Then: `Write-Host $summaryText -ForegroundColor Cyan`
  - This completely avoids all string interpolation and format operator issues
  - Most reliable approach that works in all PowerShell versions
  - No complex parsing - just basic string concatenation

### Version 2.9.2 (2025-12-08)
- **Bug Fix**: Corrected FTP Sync syntax error fix (second attempt)
  - Previous fix using `${totalGB}` still caused parser errors in PowerShell 5.1
  - Changed to use format operator: `("{0} files ({1} GB)" -f $count, $totalGB)`
  - Format operator avoids string interpolation issues entirely
  - FTP Sync tool now loads correctly without parser errors
  - More reliable cross-version PowerShell compatibility

### Version 2.9.1 (2025-12-08)
- **Bug Fix**: Fixed PowerShell syntax error in FTP Sync tool
  - Corrected string interpolation issue on line 291
  - Changed `($totalGB GB)` to `(${totalGB} GB)` to prevent parser error
  - FTP Sync tool now loads and runs correctly
- **New Feature: Toolkit Logs Menu**: Added log viewer submenu to main launcher
  - New option #2 under "Toolkit Management" section
  - Opens dedicated submenu for viewing all toolkit logs
  - Renumbered existing menu options (StorageCraft now #3, MAS now #4)
- **Log Viewer Features**:
  - View Master Audit Log in Notepad
  - View FTP Upload Log in Notepad
  - View FTP Sync Log in Notepad
  - Shows log file size and last modified date
  - Handles missing log files gracefully
  - Returns to submenu after viewing

### Version 2.9.0 (2025-12-08)
- **New Feature: FTP Sync Tool**: Compare local backup files with FTP destination
  - Scans local directory for StorageCraft backup files ending in `-cd.spi`
  - Connects to FTP server and retrieves file listing
  - Compares files by name and size to identify sync status
  - Shows files on source (local) but not on destination (FTP)
  - Displays detailed report with file names, sizes, and dates
  - Allows bulk upload of missing files
  - Export report option for documentation
  - Comprehensive logging to `ftp_sync_log.txt`
- **Menu Enhancement**: Added FTP Sync to StorageCraft Troubleshooter submenu
  - New option #2 under "Manual Tools" section
  - Renumbered existing menu options for consistency
  - Updated StorageCraft Troubleshooter to v1.2.0
- **Use Case**: Identify which backup files need to be uploaded to FTP for replication
  - Perfect for monitoring backup sync status
  - Quick identification of missing incremental backups
  - Streamlines manual backup replication workflows

### Version 2.8.0 (2025-12-08)
- **Bootstrap Installer**: Smart one-command installer and launcher
  - Automatically installs toolkit if not present
  - Checks for updates and auto-updates if available
  - Launches toolkit from correct location (`C:\ITTools\Scripts`)
  - Can be run from anywhere - handles everything automatically
  - Perfect for technicians - single command to run
  - Can be bookmarked or added to shortcuts
- **Usage Options**:
  - **Option 1**: Direct from GitHub (no download needed):
    ```powershell
    PowerShell.exe -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/SuperiorNetworks/IT-Troubleshooting-Toolkit/master/bootstrap.ps1 | iex"
    ```
  - **Option 2**: Download bootstrap.ps1 and run:
    ```powershell
    PowerShell.exe -ExecutionPolicy Bypass -File bootstrap.ps1
    ```
  - **Option 3**: Use launcher.bat (after installation):
    - Located at: `C:\ITTools\Scripts\launcher.bat`
- **Smart Features**:
  - Version detection and comparison
  - Automatic installation to `C:\ITTools\Scripts`
  - Update checking against GitHub
  - Clean error handling and user feedback
  - Professional installation experience

### Version 2.7.2 (2025-12-08)
- **Added launcher.bat**: Proper toolkit launcher included in repository
  - Ensures toolkit always runs from `C:\ITTools\Scripts`
  - Prevents running from wrong location (e.g., TEMP folder)
  - Automatically installed with toolkit
  - Error handling if toolkit not found
  - Professional launch experience
- **Usage**: Double-click `launcher.bat` to start the toolkit
  - Located at: `C:\ITTools\Scripts\launcher.bat`
  - Can create desktop shortcut to this file
  - Always runs the correct installed version

### Version 2.7.1 (2025-12-08)
- **Dynamic Version Display**: Version now reads dynamically from script header
  - No more hardcoded version strings
  - Menu always shows correct version
  - Prevents version display mismatches
  - Automatically updates when script updates
- **Bug Fix**: Fixed version display showing old version after update
  - Menu now reflects actual installed version
  - Reads version from `Version:` field in script header
  - Single source of truth for version number

### Version 2.7.0 (2025-12-08)
- **Proper Self-Update Mechanism**: Fixed file replacement during updates
  - Implements staged update with batch file
  - Avoids Windows file locking issues
  - PowerShell exits, batch file copies new files, then restarts toolkit
  - Industry-standard approach for self-updating applications
- **Automatic Restart**: Toolkit automatically restarts after update
  - No manual intervention needed
  - Seamless update experience
  - Shows "Applying Update" progress screen
- **Update Flow**:
  1. Downloads new version to temp
  2. Stages files in temporary location
  3. Creates update batch script
  4. Exits PowerShell (releases file locks)
  5. Batch script copies staged files
  6. Batch script restarts toolkit with new version
  7. Self-cleans batch file

---

**For complete version history, see the full changelog in the repository.**


## Changelog

### v3.7.10 (2026-04-15)
- **Keepalive Fix**: Replaced invalid `option keepuptodate` with correct WinSCP `-rawsettings FtpPingType=1 FtpPingInterval=10` to prevent script breakage while maintaining NAT state.
- **StorageCraft File Filter**: Updated `ftp_sync_tool.ps1` to only sync base images (`*.spf`) and daily consolidated images (`*-cd*.spi`). Excludes raw intra-daily incrementals and weekly/monthly/rolling consolidations which are handled by remote ImageManager.
- **Pre-upload Existence Check**: Added check to skip files not found on local disk instead of wasting retries.
- **Manual File List Upload**: Added option to paste a list of filenames to upload manually inside the FTP Sync Tool.
- **Per-module Version Checking**: Updater now checks each individual script's version against GitHub.
- **ASCII Compliance**: Purged all non-ASCII characters from all `.ps1` files to ensure strict PowerShell 4.0 / Server 2012 R2 compatibility.
- **ACE Provider Detection**: Fixed architecture detection in `install_access_engine.ps1` to use `Is64BitProcess` instead of `Is64BitOperatingSystem`.
- **FTP PS Checker**: Added pure PowerShell FTP connectivity tester (`ftp_ps_checker.ps1`) that doesn't require WinSCP.
- **DoH Fallback**: Added MAS Activation DoH Fallback (Option 4B) in `launch_menu.ps1`.

### Technical Notes

#### WinSCP Keepalive
When scripting WinSCP for long-running FTP transfers over NAT/WAN, NOOP keepalives are required to prevent the control channel from timing out. 
**CRITICAL:** Do NOT use `option keepuptodate` or `keepalive` commands in WinSCP scripts, as these are GUI-only or invalid and will break the script. 
Instead, use the `-rawsettings` parameter on the `open` command:
`open ftp://user:pass@server/ -rawsettings FtpPingType=1 FtpPingInterval=10`

#### StorageCraft File Filter Logic
The `ftp_sync_tool.ps1` is specifically designed to replicate StorageCraft backups to a remote ImageManager instance. It only syncs:
- Base images (`*.spf`)
- Daily consolidated images (`*-cd*.spi`)

It explicitly excludes:
- Raw intra-daily incrementals (`*-i####.spi`)
- Weekly consolidated (`*-cw*.spi`)
- Monthly consolidated (`*-cm*.spi`)
- Rolling consolidated (`*-cr*.spi`)

This is because the remote ImageManager instance will generate its own weekly, monthly, and rolling consolidations from the daily files. Syncing them over the WAN wastes bandwidth and causes conflicts.

#### PowerShell 4.0 Compatibility
All `.ps1` files in this repository must remain pure ASCII. PowerShell 4.0 (Server 2012 R2) parses scripts as ASCII/ANSI by default and will throw `TerminatorExpectedAtEndOfString` errors if it encounters UTF-8 multi-byte characters (like checkmarks or em-dashes).
