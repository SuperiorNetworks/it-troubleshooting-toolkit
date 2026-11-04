<#
.SYNOPSIS
IT Troubleshooting Toolkit - Interactive Launcher Menu

.DESCRIPTION
Name: launch_menu.ps1
Version: 3.20.0
Purpose: Centralized launcher menu for IT troubleshooting tools and service management.
         Provides quick access to FTP file transfer tools and StorageCraft ImageManager service control.
Path: /scripts/launch_menu.ps1
Copyright: 2025

Key Features:
- Self-updating toolkit installation from GitHub
- Automatic extraction to C:\ITTools\Scripts with file overwrite
- FTP Troubleshooter Tool access (manual file uploads)
- StorageCraft ImageManager service management (start/stop/restart/status)
- User-friendly color-coded menu interface
- Comprehensive master audit logging for troubleshooting
- Administrator privilege detection
- Superior Networks branding

Input:
- User menu selection (1-6 or Q)

Output:
- Downloaded and extracted files to C:\ITTools\Scripts
- Launched FTP troubleshooter tool
- Service status changes

Dependencies:
- Windows PowerShell 5.1 or higher
- Internet connection (for download option)
- Expand-Archive cmdlet (built-in)
- Administrator privileges (for service management)

Change Log:
2025-11-21 v1.0.0 - Initial release
2025-11-21 v1.1.0 - Added StorageCraft ImageManager service management options
2025-11-21 v1.2.0 - Updated installation path to C:\ITTools\Scripts
2025-11-21 v1.3.0 - Fixed file overwrite during installation; always show menu first
2025-11-21 v1.4.0 - Rebranded as IT Troubleshooting Toolkit Launcher
2025-11-21 v1.5.0 - Updated installation path to C:\ITTools\Scripts
2025-11-22 v1.6.0 - Integrated Superior Networks branding and color scheme
2025-11-22 v1.7.0 - Fixed encoding issues with ASCII art branding
2025-11-22 v2.0.0 - Added MassGrave PowerShell Utilities integration; Renamed repo to IT-Troubleshooting-Toolkit
2025-11-22 v2.1.0 - Reorganized menu: Grouped StorageCraft tools under 'StorageCraft Troubleshooter'; Renamed FTP tool to 'Manual FTP Tool'
2025-11-22 v2.2.0 - Created separate StorageCraft Troubleshooter script with submenu; Simplified main launcher
2025-11-22 v2.3.0 - Enhanced Manual FTP Tool with retry logic, resume support, and logging; Added log viewer
2025-12-08 v2.4.0 - Added version detection with update notifications and embedded release notes display
2025-12-08 v2.5.0 - Added comprehensive master audit logging system; Removed persistent ImageManager status display
2025-12-08 v2.5.1 - Added debug logging to changelog extraction for troubleshooting
2025-12-08 v2.5.2 - Enhanced debug logging to show extraction folder contents
2025-12-08 v2.5.3 - Testing version for changelog extraction diagnosis
2025-12-08 v2.5.4 - Changed temp directory to C:\ITTools\Temp; Added README search fallback
2025-12-08 v2.5.5 - Added complete extraction folder tree debug output
2025-12-08 v2.6.0 - Fixed changelog display; Simplified README path logic; Removed debug code
2025-12-08 v2.6.1 - Testing version to verify changelog display works correctly
2025-12-08 v2.7.0 - Implemented proper self-update mechanism with batch file staging
2025-12-08 v2.7.1 - Fixed version display; Made version dynamic instead of hardcoded
2025-12-08 v2.7.2 - Added launcher.bat for proper toolkit execution from correct directory
2025-12-08 v2.8.0 - Added bootstrap.ps1 smart installer (auto-install/update/launch)
2026-04-14 v3.7.0 - Added DoH fallback for MAS activation
2026-04-14 v3.7.1 - Version sync; ACE provider detection fix in sub-scripts
2026-04-14 v3.7.2 - Updated FTP Sync Tool file filter to include .spa files
2026-04-14 v3.7.3 - Added manual file list upload option to FTP Sync Tool
2026-04-14 v3.7.4 - Version sync and changelog update
2026-04-14 v3.7.5 - Rewrote updater to check all script versions independently
2026-04-15 v3.7.6 - Updated ftp_sync_tool.ps1 to v2.1.8 (recursive sync, stall detection)
2026-04-15 v3.7.7 - Added WinSCP NOOP keepalive to prevent NAT session drops
2026-04-15 v3.7.8 - Added pre-upload file existence check to ftp_sync_tool.ps1
2026-04-15 v3.7.9 - Added WinSCP rawsettings SendBuf=0 SshSimple=0 to prevent buffer
                   timeouts on large file transfers
2026-05-15 v3.7.10 - Added four-layer large file transfer fix guide (FileZilla Server
                    timeout settings, UDM firewall passive ports, OpenSSH SFTP migration)
2026-05-15 v3.7.11 - Fixed false STALL/RETRY loop on 18GB+ files (ftp_sync_tool v2.3.0):
                    replaced exit-code-only verification with fresh-session byte-for-byte
                    size comparison; file fully on server after NAT control channel drop
                    is now correctly marked STALL-BUT-COMPLETE instead of triggering
                    a full re-upload. RULE: any script change bumps this master version.
2026-07-01 v3.8.0 - Added ConnectWise RMM Repair and ScreenConnect Repair utilities
2026-07-01 v3.8.1 - Moved CW RMM Troubleshooter to main menu as Option 4 (standalone);
                    renumbered MAS Activation to Options 5 and 5B;
                    created cwrmm_troubleshooter.ps1 submenu
2026-07-01 v3.8.2 - Fixed download path from C:\ITStuff to C:\ITTools\Downloads\CWRMM
2026-07-01 v3.8.3 - Reordered CW RMM submenu: ScreenConnect Cleanup=Option 1, CW RMM Repair=Option 2
2026-09-14 v3.9.0 - Added HP M404dn Printer Troubleshooter as Option 6; added connectivity, spooler repair, and driver reinstall tools.
2026-09-16 v3.10.0 - Added macOS Troubleshooter Terminal with OneDrive Sync Repair as Option 1; added dry-run-first workflow, verbose transcripts, and macOS master audit logging.
2026-09-16 v3.11.0 - Added native macOS Git bootstrapper and on-demand menu updates; Git history is retained in ~/ITTools/Scripts and updates use fast-forward-only pulls.
2026-09-16 v3.12.0 - Redesigned macOS Troubleshooter Terminal with branded graphical panels, actionable instruction cards, status labels, version footer, and in-terminal Help Guide.
2026-09-16 v3.13.0 - Added Superior Networks logo rendering and clarified OneDrive dry-run/live sequencing: live repair closes, verifies, and relaunches OneDrive with audit logging.
2026-09-16 v3.14.0 - Added automatic TextEdit opening of each completed OneDrive repair transcript, with audit logging and a --no-open-log override.
2026-09-16 v3.15.0 - Added explicit OneDrive Sync Service shutdown and PID-aware verification; blocked runs now automatically open their transcript for review.
2026-09-16 v3.16.0 - Improved macOS bootstrap prerequisite handling: detects missing Apple Command Line Tools before clone, requests install, and provides clear rerun guidance.
2026-09-24 v3.17.0 - Added StorageCraft Logs to the StorageCraft Troubleshooter submenu; new
                    storagecraft_log_viewer.ps1 lists SPX, SPX GUI, and ImageManager logs with
                    date, name, and size, and opens them in a built-in pager with search.
2026-10-06 v3.17.1 - Windows bootstraps accept SUPERIOR_NETWORKS_BRANCH to install a test branch
                    (default master); removed stale sync_versions.py and update_readme.py.
2026-10-06 v3.17.2 - Enable TLS 1.2 at startup so the update option works on PCs with older .NET defaults;
                    Windows 10/11 install command now sets TLS 1.2 before downloading.
2026-10-06 v3.18.0 - Added option 7, Project Planner (project_planner.ps1): scans a share and builds an
                    offline migration planning report. Installers no longer copy the repo tests folder.
2026-10-06 v3.18.1 - Project Planner reports default to C:\ITTools\Reports; planner shows the toolkit version.
2026-10-06 v3.18.2 - Project Planner: progress every second and faster, more reliable file hashing.
2026-10-06 v3.18.3 - Project Planner shows where the report was saved (console, completion box, report page).
2026-10-06 v3.18.4 - Install commands download bootstrap.ps1 to C:\ITTools and run it (Defender flagged irm | iex).
2026-10-06 v3.19.0 - Project Planner: duplicate sets with locations, space a cleanup could save (with total), option hints.
2026-10-07 v3.19.1 - HP M404dn Driver Reinstall: checks IP and driver before removing anything, keeps the HP driver,
                    pick-list removal of duplicate copies, view option shows its tables again.
2026-10-08 v3.19.2 - HP M404dn Driver Reinstall: clears the spool folder (with confirmation) when a stuck job blocks
                    removal; does not add a duplicate printer if an old copy will not delete.
2026-10-08 v3.19.3 - HP M404dn Driver Reinstall: on open, offers to install the printer as a network printer and
                    asks for the IP when it is missing, on USB/WSD, or duplicated.
2026-10-08 v3.19.4 - HP M404dn submenu: recommended workflow covers option 3 (network install, have the IP ready).
2026-11-03 v3.20.0 - Added Claude Temporary Access as menu option 8 (temporary SSH over Tailscale, removed automatically).
.RELEASE_NOTES
v2.5.0:
- Added comprehensive master audit logging system for troubleshooting
- Logs all user actions, menu selections, and errors to C:\ITTools\Scripts\Logs\master_audit_log.txt
- Captures diagnostic info: username, computer, admin status, PS version, OS version, timestamps
- Removed persistent ImageManager status from main menu (cleaner interface)

v2.4.0:
- Added version detection and update notifications
- Display release notes when downloading/updating
- Show whether toolkit is new install, update, or already current

v2.3.0:
- Enhanced Manual FTP Tool with retry logic and resume support
- Added FTP upload log viewer in StorageCraft submenu
- Fixed version number displays across all menus

v2.2.0:
- Created separate StorageCraft Troubleshooter script with submenu
- Simplified main launcher menu structure

v2.0.0:
- Added MassGrave PowerShell Utilities integration
- Renamed repository to IT-Troubleshooting-Toolkit

.NOTES
This launcher provides centralized access to multiple IT troubleshooting tools and utilities.
Designed for IT professionals and MSPs to streamline common troubleshooting tasks.
#>

# Enable TLS 1.2 for GitHub downloads (older .NET defaults to TLS 1.0, which GitHub refuses)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Configuration
$repoOwner = "SuperiorNetworks"
$repoName = "IT-Troubleshooting-Toolkit"
$installPath = "C:\ITTools\Scripts"
$scriptName = "ftp_troubleshooter_tool.ps1"
$serviceName = "StorageCraft ImageManager"
$logDirectory = "C:\ITTools\Scripts\Logs"
$auditLogFile = Join-Path $logDirectory "master_audit_log.txt"

# Ensure log directory exists
if (-not (Test-Path $logDirectory)) {
    New-Item -ItemType Directory -Path $logDirectory -Force | Out-Null
}

function Write-AuditLog {
    param (
        [string]$action,
        [string]$details = "",
        [string]$level = "INFO",
        [string]$errorMessage = ""
    )
    
    try {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $username = $env:USERNAME
        $computername = $env:COMPUTERNAME
        $isAdmin = Test-Administrator
        $adminStatus = if ($isAdmin) { "Admin" } else { "User" }
        $psVersion = $PSVersionTable.PSVersion.ToString()
        $osVersion = [System.Environment]::OSVersion.VersionString
        
        # Build log entry with all diagnostic information
        $logEntry = "[$timestamp] [$level] [$adminStatus] $username@$computername`n"
        $logEntry += "  Action: $action`n"
        
        if ($details) {
            $logEntry += "  Details: $details`n"
        }
        
        if ($errorMessage) {
            $logEntry += "  Error: $errorMessage`n"
            $logEntry += "  Stack: $($Error[0].ScriptStackTrace)`n"
        }
        
        $logEntry += "  Environment: PS $psVersion | $osVersion`n"
        $logEntry += "  Path: $installPath`n"
        $logEntry += "  $("="*70)`n"
        
        # Write to audit log file
        Add-Content -Path $auditLogFile -Value $logEntry -ErrorAction SilentlyContinue
        
    } catch {
        # Silently fail if logging fails - don't disrupt user experience
    }
}

function Get-AuditLogSummary {
    if (Test-Path $auditLogFile) {
        $content = Get-Content $auditLogFile -Raw
        $lines = $content -split "`n"
        $totalEntries = ($lines | Select-String -Pattern "^\[\d{4}-\d{2}-\d{2}").Count
        $errorEntries = ($lines | Select-String -Pattern "\[ERROR\]").Count
        $warnEntries = ($lines | Select-String -Pattern "\[WARN\]").Count
        $fileSize = (Get-Item $auditLogFile).Length
        $fileSizeKB = [math]::Round($fileSize / 1KB, 2)
        
        return @{
            TotalEntries = $totalEntries
            ErrorCount = $errorEntries
            WarnCount = $warnEntries
            FileSizeKB = $fileSizeKB
            LastModified = (Get-Item $auditLogFile).LastWriteTime
        }
    }
    return $null
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Show-Menu {
    Clear-Host
    
    # Get version dynamically from script header
    $scriptVersion = "3.20.0"
    $scriptPath = $PSCommandPath
    if (Test-Path $scriptPath) {
        $content = Get-Content $scriptPath -Raw
        if ($content -match 'Version:\s*(\d+\.\d+\.\d+)') {
            $scriptVersion = $matches[1]
        }
    }
    
    # Superior Networks Branding Header
    Write-Host ""
    Write-Host "  =================================================================" -ForegroundColor Cyan
    Write-Host "                     SUPERIOR NETWORKS LLC                        " -ForegroundColor White
    Write-Host "               IT Troubleshooting Toolkit - v$scriptVersion                " -ForegroundColor Cyan
    Write-Host "  =================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Toolkit Management:" -ForegroundColor White
    Write-Host "    1. Download and Install Latest Version" -ForegroundColor Green
    Write-Host "    2. Toolkit Logs" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Troubleshooting Tools:" -ForegroundColor White
    Write-Host "    3. StorageCraft Troubleshooter" -ForegroundColor Cyan
    Write-Host "    4. ConnectWise RMM Troubleshooter" -ForegroundColor Cyan
    Write-Host "    6. HP M404dn Printer Troubleshooter" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Project Tools:" -ForegroundColor White
    Write-Host "    7. Project Planner (share scan and migration report)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Remote Support:" -ForegroundColor White
    Write-Host "    8. Claude Temporary Access (SSH, removed automatically)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Windows/Office Activation:" -ForegroundColor White
    Write-Host "    5. Run MassGrave Activation Scripts (MAS)" -ForegroundColor Magenta
    Write-Host "    5B. Run MAS (Alternative DoH Method)" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "    Q. Quit" -ForegroundColor Red
    Write-Host ""
    Write-Host "  Installation Path: $installPath" -ForegroundColor Gray
    Write-Host ""
}

function Get-ScriptVersion {
    param([string]$filePath)
    if (Test-Path $filePath) {
        try {
            $content = Get-Content $filePath -Raw
            if ($content -match 'Version:\s*(\d+\.\d+\.\d+)') {
                return [version]$matches[1]
            }
        }
        catch {
            return $null
        }
    }
    return $null
}

function Get-CurrentVersion {
    return Get-ScriptVersion -filePath (Join-Path $installPath "launch_menu.ps1")
}

function Get-ChangelogFromReadme {
    param(
        [string]$version,
        [string]$readmePath = ""
    )
    
    # Use provided README path or default to installed version
    $readme = if ($readmePath) { $readmePath } else { Join-Path $installPath "README.md" }
    
    if (-not (Test-Path $readme)) {
        return @()
    }
    
    try {
        $content = Get-Content $readme -Raw -ErrorAction Stop
        
        # Extract changelog section for specific version
        # Pattern: ### Version X.X.X (date) followed by bullet points until next version or section
        $pattern = "### Version $version \([^)]+\)\s*([\s\S]*?)(?=### Version|## |\z)"
        
        if ($content -match $pattern) {
            $changelogText = $matches[1].Trim()
            
            if ($changelogText.Length -eq 0) {
                return @()
            }
            
            # Split into lines and filter for bullet points and sub-bullets
            $lines = $changelogText -split "`n" | Where-Object { $_.Trim() -ne "" }
            
            return $lines
        }
    }
    catch {
        return @()
    }
    
    return @()
}

function Download-And-Install {
    Write-Host "`n=== Checking for Updates ===" -ForegroundColor Cyan
    
    # Get current version if installed
    $currentVersion = Get-CurrentVersion
    $isNewInstall = $null -eq $currentVersion
    
    if ($isNewInstall) {
        Write-Host "No existing installation found." -ForegroundColor Yellow
    }
    else {
        Write-Host "Current version: $currentVersion" -ForegroundColor Cyan
    }
    
    try {
        # Create installation directory if it doesn't exist
        if (-not (Test-Path $installPath)) {
            Write-Host "Creating installation directory: $installPath" -ForegroundColor Yellow
            New-Item -ItemType Directory -Path $installPath -Force | Out-Null
        }

        # Download the latest release as ZIP
        $zipUrl = "https://github.com/$repoOwner/$repoName/archive/refs/heads/master.zip"
        $tempDir = Join-Path $installPath "Temp"
        
        # Create temp directory if it doesn't exist
        if (-not (Test-Path $tempDir)) {
            New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
        }
        
        $zipFile = Join-Path $tempDir "ftp-troubleshooter.zip"
        $extractPath = Join-Path $tempDir "ftp-troubleshooter-extract"

        Write-Host "Downloading from GitHub..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile -UseBasicParsing

        Write-Host "Extracting files..." -ForegroundColor Yellow
        
        # Remove old extraction folder if it exists
        if (Test-Path $extractPath) {
            Remove-Item -Path $extractPath -Recurse -Force
        }
        
        Expand-Archive -Path $zipFile -DestinationPath $extractPath -Force

        # Get new version from downloaded files
        $sourceFolder = Join-Path $extractPath "$repoName-master"
        $newLauncherPath = Join-Path $sourceFolder "launch_menu.ps1"
        $newVersion = Get-ScriptVersion -filePath $newLauncherPath
        
        # Check if ANY script has an update
        $updateNeeded = $false
        $updatedScripts = @()
        
        if ($isNewInstall) {
            $updateNeeded = $true
        } else {
            # Compare all .ps1 files
            $downloadedScripts = Get-ChildItem -Path $sourceFolder -Filter "*.ps1"
            foreach ($script in $downloadedScripts) {
                $localScriptPath = Join-Path $installPath $script.Name
                $newScriptVer = Get-ScriptVersion -filePath $script.FullName
                $localScriptVer = Get-ScriptVersion -filePath $localScriptPath
                
                if ($null -ne $newScriptVer) {
                    if ($null -eq $localScriptVer -or $newScriptVer -gt $localScriptVer) {
                        $updateNeeded = $true
                        $updatedScripts += [PSCustomObject]@{
                            Name = $script.Name
                            OldVer = if ($localScriptVer) { $localScriptVer.ToString() } else { "None" }
                            NewVer = $newScriptVer.ToString()
                        }
                    }
                }
            }
        }

        # For updates, use staged approach with batch file to avoid file locking issues
        if ($updateNeeded -and -not $isNewInstall) {
            Write-Host "Staging update files..." -ForegroundColor Yellow
            
            # Create staging directory
            $stagingPath = Join-Path $tempDir "staged"
            if (Test-Path $stagingPath) {
                Remove-Item -Path $stagingPath -Recurse -Force
            }
            New-Item -ItemType Directory -Path $stagingPath -Force | Out-Null
            
            # Copy files to staging
            Copy-Item -Path "$sourceFolder\*" -Destination $stagingPath -Recurse -Force
            # Repo tests are not installed on client machines
            Remove-Item -Path (Join-Path $stagingPath "tests") -Recurse -Force -ErrorAction SilentlyContinue
            
            # Create update batch file
            $batchFile = Join-Path $tempDir "update.bat"
            $batchContent = @"
@echo off
echo.
echo ================================================================
echo                    Applying Update
echo ================================================================
echo.
echo Please wait while the update is applied...
echo.

:: Wait for PowerShell to fully exit
timeout /t 2 /nobreak >nul

:: Copy staged files to installation directory
echo Copying updated files...
xcopy /E /I /Y /Q "$stagingPath\*" "$installPath\"

:: Cleanup
echo Cleaning up temporary files...
rd /s /q "$stagingPath" 2>nul
rd /s /q "$extractPath" 2>nul
del /q "$zipFile" 2>nul

:: Restart the launcher
echo.
echo Update complete! Restarting toolkit...
echo.
timeout /t 2 /nobreak >nul

cd /d "$installPath"
powershell.exe -ExecutionPolicy Bypass -File "$installPath\launch_menu.ps1"

:: Self-delete the batch file
del "%~f0"
"@
            Set-Content -Path $batchFile -Value $batchContent -Force
            
            Write-Host "Update staged successfully." -ForegroundColor Green
            Write-Host ""
            Write-Host "The toolkit will now restart to apply the update..." -ForegroundColor Yellow
            Write-Host ""
            Write-Host "Press any key to continue..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            
            # Launch batch file and exit PowerShell
            Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$batchFile`"" -WindowStyle Normal
            exit
        }
        else {
            # For new installs or same version, direct copy is fine
            Write-Host "Installing to $installPath..." -ForegroundColor Yellow
            Write-Host "Overwriting existing files if present..." -ForegroundColor Yellow
            
            # Copy each item individually with force to ensure overwrite
            Get-ChildItem -Path $sourceFolder -File | ForEach-Object {
                Copy-Item -Path $_.FullName -Destination $installPath -Force
            }
            
            # Copy directories recursively with force (repo tests are not installed)
            Get-ChildItem -Path $sourceFolder -Directory | Where-Object { $_.Name -ne "tests" } | ForEach-Object {
                $destDir = Join-Path $installPath $_.Name
                if (Test-Path $destDir) {
                    Remove-Item -Path $destDir -Recurse -Force
                }
                Copy-Item -Path $_.FullName -Destination $installPath -Recurse -Force
            }

            # Cleanup
            Remove-Item -Path $zipFile -Force
            Remove-Item -Path $extractPath -Recurse -Force
        }

        # Display results
        Write-Host ""
        Write-Host "=================================================================" -ForegroundColor Cyan
        
        if ($isNewInstall) {
            Write-Host "                  Installation Complete                          " -ForegroundColor White
            Write-Host "=================================================================" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "  [OK] Installed IT Troubleshooting Toolkit v$newVersion" -ForegroundColor Green
        }
        elseif ($updateNeeded) {
            Write-Host "                    Update Complete                              " -ForegroundColor White
            Write-Host "=================================================================" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "  [OK] Toolkit updated successfully!" -ForegroundColor Green
            Write-Host ""
            Write-Host "  Updated Modules:" -ForegroundColor Cyan
            foreach ($mod in $updatedScripts) {
                Write-Host "  - $($mod.Name): v$($mod.OldVer) -> v$($mod.NewVer)" -ForegroundColor White
            }
        }
        else {
            Write-Host "                  Already Up-to-Date                             " -ForegroundColor White
            Write-Host "=================================================================" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "  [OK] All modules are already at the latest version." -ForegroundColor Green
            Write-Host ""
            Write-Host "  No updates available." -ForegroundColor Yellow
        }
        
        # Show changelog if new install or update
        if ($isNewInstall -or $updateNeeded) {
            Write-Host ""
            Write-Host "  What's New in v$newVersion`:" -ForegroundColor Cyan
            Write-Host "" 
            
            # Get changelog from the newly installed README.md (after files are copied)
            $installedReadmePath = Join-Path $installPath "README.md"
            $changelog = Get-ChangelogFromReadme -version $newVersion.ToString() -readmePath $installedReadmePath
            
            if ($changelog.Count -gt 0) {
                foreach ($line in $changelog) {
                    # Format different line types with appropriate colors
                    if ($line -match '^-\s*\*\*') {
                        # Main bullet with bold (e.g., - **Feature**: description)
                        Write-Host "  $line" -ForegroundColor Green
                    }
                    elseif ($line -match '^\s+-\s+') {
                        # Sub-bullet (indented)
                        Write-Host "  $line" -ForegroundColor Gray
                    }
                    elseif ($line -match '^-\s+') {
                        # Regular bullet
                        Write-Host "  $line" -ForegroundColor White
                    }
                    else {
                        # Other text
                        Write-Host "  $line" -ForegroundColor White
                    }
                }
            }
            else {
                Write-Host "  - Bug fixes and improvements" -ForegroundColor White
            }
        }
        
        Write-Host ""
        Write-Host "  Installation Path: $installPath" -ForegroundColor Gray
        Write-Host ""
        
        # Log successful installation
        $installType = if ($isNewInstall) { "New Install" } elseif ($newVersion -gt $currentVersion) { "Update" } else { "Reinstall" }
        Write-AuditLog -action "Download and Install" -details "$installType completed: v$newVersion" -level "INFO"
        
    }
    catch {
        Write-Host ""
        Write-Host "=================================================================" -ForegroundColor Red
        Write-Host "                    Installation Failed                          " -ForegroundColor White
        Write-Host "=================================================================" -ForegroundColor Red
        Write-Host ""
        Write-Error "Failed to download and install: $_"
        
        # Log installation failure
        Write-AuditLog -action "Download and Install" -level "ERROR" -errorMessage $_.Exception.Message
        Write-Host "`nTroubleshooting tips:" -ForegroundColor Yellow
        Write-Host "- Check your internet connection" -ForegroundColor Yellow
        Write-Host "- Ensure you have write permissions to $installPath" -ForegroundColor Yellow
        Write-Host "- Try running PowerShell as Administrator" -ForegroundColor Yellow
        Write-Host ""
    }
    
    Write-Host "Press any key to return to menu..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Run-StorageCraftTroubleshooter {
    Write-Host "`n=== Launching StorageCraft Troubleshooter ===" -ForegroundColor Cyan
    
    $scScriptName = "storagecraft_troubleshooter.ps1"
    $scriptPath = Join-Path $installPath $scScriptName
    
    if (Test-Path $scriptPath) {
        Write-Host "Starting StorageCraft Troubleshooter..." -ForegroundColor Green
        Write-Host ""
        
        Write-AuditLog -action "StorageCraft Troubleshooter" -details "Launched submenu script: $scScriptName"
        
        # Run the StorageCraft submenu script
        & $scriptPath
        
    }
    else {
        Write-Host "`nError: StorageCraft Troubleshooter not found!" -ForegroundColor Red
        Write-Host "Expected location: $scriptPath" -ForegroundColor Yellow
        Write-Host "`nPlease use Option 1 to download and install first." -ForegroundColor Yellow
        
        Write-AuditLog -action "StorageCraft Troubleshooter" -level "ERROR" -errorMessage "Script not found: $scriptPath"
        
        Write-Host "`nPress any key to return to menu..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}

function Run-CWRMMTroubleshooter {
    Write-Host "`n=== Launching ConnectWise RMM Troubleshooter ===" -ForegroundColor Cyan
    
    $cwScriptName = "cwrmm_troubleshooter.ps1"
    $scriptPath = Join-Path $installPath $cwScriptName
    
    if (Test-Path $scriptPath) {
        Write-Host "Starting ConnectWise RMM Troubleshooter..." -ForegroundColor Green
        Write-Host ""
        
        Write-AuditLog -action "CW RMM Troubleshooter" -details "Launched submenu script: $cwScriptName"
        
        & $scriptPath
        
    }
    else {
        Write-Host "`nError: ConnectWise RMM Troubleshooter not found!" -ForegroundColor Red
        Write-Host "Expected location: $scriptPath" -ForegroundColor Yellow
        Write-Host "`nPlease use Option 1 to download and install first." -ForegroundColor Yellow
        
        Write-AuditLog -action "CW RMM Troubleshooter" -level "ERROR" -errorMessage "Script not found: $scriptPath"
        
        Write-Host "`nPress any key to return to menu..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}

function Run-HPM404dnTroubleshooter {
    Write-Host "`n=== Launching HP M404dn Printer Troubleshooter ===" -ForegroundColor Cyan

    $hpScriptName = "hp_m404dn_troubleshooter.ps1"
    $scriptPath = Join-Path $installPath $hpScriptName

    if (Test-Path $scriptPath) {
        Write-Host "Starting HP M404dn Printer Troubleshooter..." -ForegroundColor Green
        Write-Host ""

        Write-AuditLog -action "HP M404dn Printer Troubleshooter" -details "Launched submenu script: $hpScriptName"

        # Run the HP M404dn submenu script
        & $scriptPath

    }
    else {
        Write-Host "`nError: HP M404dn Printer Troubleshooter not found!" -ForegroundColor Red
        Write-Host "Expected location: $scriptPath" -ForegroundColor Yellow
        Write-Host "`nPlease use Option 1 to download and install first." -ForegroundColor Yellow

        Write-AuditLog -action "HP M404dn Printer Troubleshooter" -level "ERROR" -errorMessage "Script not found: $scriptPath"

        Write-Host "`nPress any key to return to menu..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}

function Run-ClaudeTempAccess {
    Write-Host "`n=== Launching Claude Temporary Access ===" -ForegroundColor Cyan

    $scriptPath = Join-Path $installPath "claude_temp_access.ps1"

    if (-not (Test-Path $scriptPath)) {
        Write-Host "`nError: Claude Temporary Access not found!" -ForegroundColor Red
        Write-Host "Expected location: $scriptPath" -ForegroundColor Yellow
        Write-Host "`nPlease use Option 1 to download and install first." -ForegroundColor Yellow

        Write-AuditLog -action "Claude Temporary Access" -level "ERROR" -errorMessage "Script not found: $scriptPath"

        Write-Host "`nPress any key to return to menu..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        return
    }

    if (-not (Test-Administrator)) {
        Write-Host "`nClaude Temporary Access must run in PowerShell as admin." -ForegroundColor Red
        Write-AuditLog -action "Claude Temporary Access" -level "WARN" -details "Not started: not running as admin"

        Write-Host "`nPress any key to return to menu..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        return
    }

    Write-AuditLog -action "Claude Temporary Access" -details "Launched claude_temp_access.ps1"
    & $scriptPath
}

function Run-ProjectPlanner {
    Write-Host "`n=== Launching Project Planner ===" -ForegroundColor Cyan

    $ppScriptName = "project_planner.ps1"
    $scriptPath = Join-Path $installPath $ppScriptName

    if (-not (Test-Path $scriptPath)) {
        Write-Host "`nError: Project Planner not found!" -ForegroundColor Red
        Write-Host "Expected location: $scriptPath" -ForegroundColor Yellow
        Write-Host "`nPlease use Option 1 to download and install first." -ForegroundColor Yellow

        Write-AuditLog -action "Project Planner" -level "ERROR" -errorMessage "Script not found: $scriptPath"

        Write-Host "`nPress any key to return to menu..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        return
    }

    if ($PSVersionTable.PSVersion.Major -lt 5) {
        Write-Host "`nProject Planner needs Windows PowerShell 5.1 or later." -ForegroundColor Red
        Write-Host "This computer has PowerShell $($PSVersionTable.PSVersion). Install WMF 5.1 or run it from another PC that can see the share." -ForegroundColor Yellow

        Write-AuditLog -action "Project Planner" -level "WARN" -details "Not started: PowerShell $($PSVersionTable.PSVersion) is below 5.1"

        Write-Host "`nPress any key to return to menu..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        return
    }

    Write-Host "Opening the Project Planner start screen..." -ForegroundColor Green
    Write-Host "Scan progress shows in a new window. This menu returns when Project Planner closes." -ForegroundColor Gray
    Write-Host ""

    Write-AuditLog -action "Project Planner" -details "Launched $ppScriptName in a new PowerShell window"

    # Separate process: the start screen needs STA, and the script defines PowerShell classes
    # that can't be redefined if it runs twice in the same session.
    $ppArgs = "-NoProfile -ExecutionPolicy Bypass -STA -File `"$scriptPath`""
    $ppProcess = Start-Process -FilePath "powershell.exe" -ArgumentList $ppArgs -Wait -PassThru

    if ($ppProcess.ExitCode -ne 0) {
        Write-Host "Project Planner exited with code $($ppProcess.ExitCode)." -ForegroundColor Yellow
        Write-AuditLog -action "Project Planner" -level "WARN" -details "Exited with code $($ppProcess.ExitCode)"
    }
    else {
        Write-AuditLog -action "Project Planner" -details "Closed normally"
    }

    Write-Host "`nPress any key to return to menu..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Show-ToolkitLogs {
    do {
        Clear-Host
        
        Write-Host ""
        Write-Host "  =================================================================" -ForegroundColor Cyan
        Write-Host "                     SUPERIOR NETWORKS LLC                        " -ForegroundColor White
        Write-Host "                      Toolkit Logs Viewer                         " -ForegroundColor Cyan
        Write-Host "  =================================================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  Available Logs:" -ForegroundColor White
        Write-Host "    1. View Master Audit Log" -ForegroundColor Green
        Write-Host "    2. View FTP Upload Log" -ForegroundColor Yellow
        Write-Host "    3. View FTP Sync Log" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "    B. Back to Main Menu" -ForegroundColor Gray
        Write-Host ""
        Write-Host "  Log Directory: $logDirectory" -ForegroundColor Gray
        Write-Host ""
        
        Write-Host "  Select an option (1-3 or B): " -NoNewline -ForegroundColor White
        $choice = Read-Host
        
        switch ($choice.ToUpper()) {
            '1' {
                Write-AuditLog -action "Toolkit Logs" -details "Opening Master Audit Log"
                Open-LogInEditor -logPath $auditLogFile -logName "Master Audit Log"
            }
            '2' {
                $ftpLogPath = Join-Path $logDirectory "ftp_upload_log.txt"
                Write-AuditLog -action "Toolkit Logs" -details "Opening FTP Upload Log"
                Open-LogInEditor -logPath $ftpLogPath -logName "FTP Upload Log"
            }
            '3' {
                $ftpSyncLogPath = Join-Path $logDirectory "ftp_sync_log.txt"
                Write-AuditLog -action "Toolkit Logs" -details "Opening FTP Sync Log"
                Open-LogInEditor -logPath $ftpSyncLogPath -logName "FTP Sync Log"
            }
            'B' {
                Write-Host "`nReturning to main menu..." -ForegroundColor Cyan
                return
            }
            default {
                Write-Host "`nInvalid selection. Please choose 1-3 or B." -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
    } while ($true)
}

function Open-LogInEditor {
    param (
        [string]$logPath,
        [string]$logName
    )
    
    Write-Host ""
    Write-Host "=== Opening $logName ===" -ForegroundColor Cyan
    Write-Host ""
    
    if (-not (Test-Path $logPath)) {
        Write-Host "Log file not found: $logPath" -ForegroundColor Yellow
        Write-Host "The log file will be created when the corresponding tool is used." -ForegroundColor Gray
        Write-Host ""
        Write-Host "Press any key to return to logs menu..." -ForegroundColor Gray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        return
    }
    
    $logInfo = Get-Item $logPath
    $logSizeKB = [math]::Round($logInfo.Length / 1KB, 2)
    
    Write-Host "Log File: $logPath" -ForegroundColor Gray
    Write-Host "Size: $logSizeKB KB | Last Modified: $($logInfo.LastWriteTime)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Opening in Notepad..." -ForegroundColor Green
    
    try {
        Start-Process notepad.exe -ArgumentList $logPath
        Write-Host "Notepad launched successfully." -ForegroundColor Green
    }
    catch {
        Write-Host "Error opening log file: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "Press any key to return to logs menu..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Run-MassGraveActivation {
    param (
        [bool]$UseDoH = $false
    )
    Write-Host "`n=== MassGrave Activation Scripts (MAS) ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "This will launch the Microsoft Activation Scripts (MAS) utility." -ForegroundColor Yellow
    Write-Host "MAS provides activation methods for Windows and Office products." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Features:" -ForegroundColor White
    Write-Host "  - HWID (Digital License) for Windows 10-11" -ForegroundColor Gray
    Write-Host "  - Ohook for Office (Permanent)" -ForegroundColor Gray
    Write-Host "  - TSforge for Windows/ESU/Office" -ForegroundColor Gray
    Write-Host "  - Online KMS (180 days, renewable)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Source: https://massgrave.dev/" -ForegroundColor Cyan
    Write-Host ""
    
    $confirm = Read-Host "Do you want to launch MAS? (Y/N)"
    
    if ($confirm.ToUpper() -eq 'Y') {
        Write-Host ""
        Write-Host "Launching MassGrave Activation Scripts..." -ForegroundColor Green
        Write-Host "Please wait..." -ForegroundColor Yellow
        Write-Host ""
        
        Write-AuditLog -action "MassGrave Activation" -details "User confirmed launch, downloading from get.activated.win"
        
        try {
            # Execute the MAS script
            if ($UseDoH) {
                Write-AuditLog -action "MassGrave Activation" -details "Using DoH fallback method"
                Invoke-Expression (curl.exe -s --doh-url https://1.1.1.1/dns-query https://get.activated.win | Out-String)
            } else {
                Invoke-Expression (Invoke-RestMethod -Uri 'https://get.activated.win')
            }
            Write-AuditLog -action "MassGrave Activation" -details "MAS script executed successfully"
        }
        catch {
            Write-Host "Error launching MAS: $_" -ForegroundColor Red
            Write-AuditLog -action "MassGrave Activation" -level "ERROR" -errorMessage $_.Exception.Message
            Write-Host ""
            Write-Host "Troubleshooting:" -ForegroundColor Yellow
            Write-Host "- Check your internet connection" -ForegroundColor Yellow
            Write-Host "- Verify the URL is not blocked by your ISP/DNS" -ForegroundColor Yellow
            Write-Host "- Try running PowerShell as Administrator" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "Press any key to return to menu..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
    }
    else {
        Write-AuditLog -action "MassGrave Activation" -details "User cancelled MAS launch"
        Write-Host ""
        Write-Host "MAS launch cancelled." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Press any key to return to menu..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}

# Log script startup
Write-AuditLog -action "Script Started" -details "IT Troubleshooting Toolkit Launcher v3.20.0"

# Main menu loop
do {
    Show-Menu
    Write-Host "  Select an option (1-8 or Q): " -NoNewline -ForegroundColor White
    $choice = Read-Host
    
    switch ($choice.ToUpper()) {
        '1' {
            Write-AuditLog -action "Menu Selection" -details "Option 1: Download and Install Latest Version"
            try {
                Download-And-Install
            } catch {
                Write-AuditLog -action "Download and Install" -level "ERROR" -errorMessage $_.Exception.Message
                throw
            }
        }
        '2' {
            Write-AuditLog -action "Menu Selection" -details "Option 2: Toolkit Logs"
            try {
                Show-ToolkitLogs
            } catch {
                Write-AuditLog -action "Toolkit Logs" -level "ERROR" -errorMessage $_.Exception.Message
                throw
            }
        }
        '3' {
            Write-AuditLog -action "Menu Selection" -details "Option 3: StorageCraft Troubleshooter"
            try {
                Run-StorageCraftTroubleshooter
            } catch {
                Write-AuditLog -action "StorageCraft Troubleshooter" -level "ERROR" -errorMessage $_.Exception.Message
                throw
            }
        }
        '4' {
            Write-AuditLog -action "Menu Selection" -details "Option 4: ConnectWise RMM Troubleshooter"
            try {
                Run-CWRMMTroubleshooter
            } catch {
                Write-AuditLog -action "ConnectWise RMM Troubleshooter" -level "ERROR" -errorMessage $_.Exception.Message
                throw
            }
        }
        '6' {
            Write-AuditLog -action "Menu Selection" -details "Option 6: HP M404dn Printer Troubleshooter"
            try {
                Run-HPM404dnTroubleshooter
            } catch {
                Write-AuditLog -action "HP M404dn Printer Troubleshooter" -level "ERROR" -errorMessage $_.Exception.Message
                throw
            }
        }
        '7' {
            Write-AuditLog -action "Menu Selection" -details "Option 7: Project Planner"
            try {
                Run-ProjectPlanner
            } catch {
                Write-AuditLog -action "Project Planner" -level "ERROR" -errorMessage $_.Exception.Message
                throw
            }
        }
        '8' {
            Write-AuditLog -action "Menu Selection" -details "Option 8: Claude Temporary Access"
            try {
                Run-ClaudeTempAccess
            } catch {
                Write-AuditLog -action "Claude Temporary Access" -level "ERROR" -errorMessage $_.Exception.Message
                throw
            }
        }
        '5' {
            Write-AuditLog -action "Menu Selection" -details "Option 5: Run MassGrave Activation Scripts"
            try {
                Run-MassGraveActivation -UseDoH $false
            } catch {
                Write-AuditLog -action "MassGrave Activation" -level "ERROR" -errorMessage $_.Exception.Message
                throw
            }
        }
        '5B' {
            Write-AuditLog -action "Menu Selection" -details "Option 5B: Run MassGrave Activation Scripts (DoH Fallback)"
            try {
                Run-MassGraveActivation -UseDoH $true
            } catch {
                Write-AuditLog -action "MassGrave Activation" -level "ERROR" -errorMessage $_.Exception.Message
                throw
            }
        }
        'Q' {
            Write-AuditLog -action "Script Exited" -details "User selected Quit"
            Write-Host "`nExiting..." -ForegroundColor Cyan
            exit 0
        }
        default {
            Write-AuditLog -action "Invalid Menu Selection" -level "WARN" -details "User entered: $choice"
            Write-Host "`nInvalid selection. Please choose 1-8 or Q." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
} while ($true)
