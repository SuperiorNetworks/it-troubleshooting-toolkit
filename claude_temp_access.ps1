<#
.SYNOPSIS
Claude Temporary Access - Opens and removes temporary SSH access for Claude

.DESCRIPTION
Name: claude_temp_access.ps1
Version: 3.20.0
Purpose: Opens temporary admin SSH access to this PC for Claude on sn-claude1026 over Tailscale,
         then removes it automatically after a set time.
Author: Dwain Henderson Jr. | Superior Networks LLC
Contact: (937) 985-2480 | dhenderson@superiornetworks.biz
Copyright: 2026, Superior Networks LLC
Path: C:\ITTools\Scripts\claude_temp_access.ps1

What This Script Does:
  - Open: joins this PC to the Superior Networks Tailscale network, then runs a private copy of
    OpenSSH as its own service on port 2222, listening on the Tailscale address only
  - Open: adds local admin svc-claude-temp with a random password nobody sees, key login only,
    and a firewall rule that allows sn-claude1026 only
  - Open: sets a SYSTEM scheduled task that closes everything after the chosen hours (default 4)
  - Open: if any step fails, it removes everything it added
  - Close: removes the service, account, profile, firewall rule, Tailscale, task and files
  - Close: Windows can hold the profile folder until the next reboot; the log says if it did
  - Status: shows what is open now
  - Does not touch any OpenSSH already on this PC, and stops if Tailscale is already here

Input:
  - Menu choices, or -Action Open | Close | Status
  - -Hours 1 to 12, how long access stays open
  - Tailscale auth key, typed at the prompt on this PC (or -AuthKey). Use an ephemeral,
    single-use key with a 1-day expiry
  - -LanTest skips Tailscale and allows 192.168.1.36 (DASHBOARD testing only)
  - -Yes skips the confirmation prompt

Output:
  - C:\ProgramData\SN-ClaudeAccess\access.log, kept after close, with each login listed
  - C:\ITTools\Scripts\Logs\master_audit_log.txt

Dependencies:
  - Windows PowerShell 5.1 or later (New-LocalUser, Expand-Archive), run as admin, internet access
  - Downloads Win32-OpenSSH 9.8.3.0p2 (GitHub) and Tailscale 1.104.5, both SHA-256 pinned
  - sn-claude1026 holds the only private key for the public key below

Change Log:
2026-11-03 v3.20.0 - Initial release (Dwain Henderson Jr)
#>
[CmdletBinding()]
param(
  [ValidateSet('Menu', 'Open', 'Close', 'Status')] [string]$Action = 'Menu',
  [ValidateRange(1, 12)] [int]$Hours = 4,
  [string]$AuthKey,
  [switch]$LanTest,
  [switch]$Yes
)

$ProgressPreference = 'SilentlyContinue'
$Root      = 'C:\ProgramData\SN-ClaudeAccess'
$Log       = "$Root\access.log"
$Self      = "$Root\claude_temp_access.ps1"
$AuditFile = 'C:\ITTools\Scripts\Logs\master_audit_log.txt'
$Svc       = 'SNClaudeSSH'
$User      = 'svc-claude-temp'
$Port      = 2222
$Rule      = 'SN Claude temp SSH'
$Task      = 'SN-ClaudeAccess-Close'
$TsExe     = 'C:\Program Files\Tailscale\tailscale.exe'
$PubKey    = 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG+Vkkd9b7Qp7xl5gtdaMhDhoumrBcaz6F1N3wtkmVN8 claude-temp@sn-claude1026'
$Source    = if ($LanTest) { '192.168.1.36' } else { '100.84.207.70' }
$SshUrl    = 'https://github.com/PowerShell/Win32-OpenSSH/releases/download/v9.8.3.0p2-Preview/OpenSSH-Win64.zip'
$SshHash   = '0CA131F3A78F404DC819A6336606CAEC0DB1663A692CCC3AF1E90232706ADA54'
$TsUrl     = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.104.5-amd64.msi'
$TsHash    = '3C41318C83C5D95D0B017B1BAA08BA7C99FD5334166122BBB1931E55AF99839C'

function Write-Log {
  param([string]$Text)
  $line = "$(Get-Date -Format 'yyyy-MM-dd h:mm:ss tt')  $Text"
  Write-Output $line
  if (Test-Path $Root) { Add-Content -Path $Log -Value $line }
}

function Write-AuditLog {
  param([string]$action, [string]$details = '', [string]$level = 'INFO')
  try {
    $dir = Split-Path $AuditFile
    if (-not (Test-Path $dir)) { New-Item $dir -ItemType Directory -Force | Out-Null }
    $entry = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] [$level] [Admin] $env:USERNAME@$env:COMPUTERNAME`n"
    $entry += "  Action: $action`n"
    if ($details) { $entry += "  Details: $details`n" }
    $entry += "  $('=' * 70)`n"
    Add-Content -Path $AuditFile -Value $entry -ErrorAction SilentlyContinue
  } catch { }
}

function Get-Verified {
  param([string]$Url, [string]$Hash, [string]$Path)
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  Invoke-WebRequest -UseBasicParsing -Uri $Url -OutFile $Path
  if ((Get-FileHash $Path -Algorithm SHA256).Hash -ne $Hash) {
    Remove-Item $Path -Force
    throw "Hash check failed for $Url"
  }
}

function Close-Access {
  $ErrorActionPreference = 'Continue'
  Write-Log 'Closing access'
  $state = $null
  if (Test-Path "$Root\state.json") { $state = Get-Content "$Root\state.json" -Raw | ConvertFrom-Json }

  if (Get-Service $Svc -ErrorAction SilentlyContinue) {
    Stop-Service $Svc -Force -ErrorAction SilentlyContinue
    sc.exe delete $Svc | Out-Null
  }
  Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.Path -like "$Root\*" } | Stop-Process -Force -ErrorAction SilentlyContinue
  Get-NetFirewallRule -DisplayName $Rule -ErrorAction SilentlyContinue | Remove-NetFirewallRule

  $acct = Get-LocalUser -Name $User -ErrorAction SilentlyContinue
  if ($acct) {
    Get-Process -IncludeUserName -ErrorAction SilentlyContinue | Where-Object { $_.UserName -like "*\$User" } | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 3
    $sid = $acct.SID.Value
    Get-CimInstance Win32_UserProfile -Filter "SID='$sid'" -ErrorAction SilentlyContinue | Remove-CimInstance -ErrorAction SilentlyContinue
    Remove-LocalUser -Name $User
  }
  Get-ChildItem 'C:\Users' -Force -Filter "$User*" -ErrorAction SilentlyContinue | ForEach-Object { cmd /c rd /s /q "$($_.FullName)" 2>&1 | Out-Null }

  if ($state -and $state.TailscaleOurs) {
    if (Test-Path $TsExe) { & $TsExe logout 2>&1 | Out-Null }
    $ts = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*', 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -eq 'Tailscale' -and $_.PSChildName -like '{*' }
    foreach ($t in $ts) { Start-Process msiexec.exe -ArgumentList "/x $($t.PSChildName) /qn /norestart" -Wait }
    Remove-Item 'C:\ProgramData\Tailscale', 'C:\Program Files\Tailscale' -Recurse -Force -ErrorAction SilentlyContinue
  }

  if (Test-Path "$Root\sshd.log") {
    Select-String -Path "$Root\sshd.log" -Pattern 'Accepted ' | ForEach-Object { Write-Log "Login record: $($_.Line)" }
  }
  if (Test-Path $Root) { Get-ChildItem $Root -Force | Where-Object { $_.Name -ne 'access.log' } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue }

  $left = @()
  if (Get-Service $Svc -ErrorAction SilentlyContinue) { $left += 'service' }
  if (Get-LocalUser -Name $User -ErrorAction SilentlyContinue) { $left += 'account' }
  if (Get-ChildItem 'C:\Users' -Force -Filter "$User*" -ErrorAction SilentlyContinue) { $left += 'profile folder until next reboot' }
  if (Get-NetFirewallRule -DisplayName $Rule -ErrorAction SilentlyContinue) { $left += 'firewall rule' }
  if ($state -and $state.TailscaleOurs -and (Test-Path $TsExe)) { $left += 'Tailscale' }
  if (@(Get-ChildItem $Root -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne 'access.log' }).Count) { $left += 'files' }
  $result = "Access closed. Left behind: $(if ($left) { $left -join ', ' } else { 'nothing' })"
  Write-Log $result
  Write-AuditLog -action 'Claude Temporary Access' -details $result

  Unregister-ScheduledTask -TaskName $Task -Confirm:$false -ErrorAction SilentlyContinue
}

function Open-Access {
  $ErrorActionPreference = 'Stop'
  if (Get-Service $Svc -ErrorAction SilentlyContinue) { throw 'Access is already open. Use Status or Close.' }
  if (Get-LocalUser -Name $User -ErrorAction SilentlyContinue) { throw "Account $User already exists. Use Close first." }
  if (-not $LanTest -and (Test-Path $TsExe)) { throw 'Tailscale is already on this PC. Stopped so its settings are left alone.' }

  $closeAt = (Get-Date).AddHours($Hours)
  New-Item $Root -ItemType Directory -Force | Out-Null
  icacls $Root /inheritance:r /grant:r '*S-1-5-18:(OI)(CI)F' '*S-1-5-32-544:(OI)(CI)F' | Out-Null
  if ($LASTEXITCODE) { throw 'Could not lock down the working folder.' }
  @{ TailscaleOurs = (-not $LanTest); OpenedBy = $env:USERNAME; CloseAt = $closeAt.ToString('s') } | ConvertTo-Json | Set-Content "$Root\state.json"
  Write-Log "Opening access on $env:COMPUTERNAME for $Hours hours, run by $env:USERNAME"

  if ($PSCommandPath -ne $Self) { Copy-Item $PSCommandPath $Self -Force }
  $act = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$Self`" -Action Close"
  $trg = New-ScheduledTaskTrigger -Once -At $closeAt
  $prn = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest
  $set = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Minutes 30)
  Register-ScheduledTask -TaskName $Task -Action $act -Trigger $trg -Principal $prn -Settings $set -Force | Out-Null
  Write-Log "Auto-close set for $($closeAt.ToString('yyyy-MM-dd h:mm tt'))"

  $listen = '0.0.0.0'
  if (-not $LanTest) {
    Write-Log 'Installing Tailscale'
    $msi = "$Root\tailscale.msi"
    Get-Verified $TsUrl $TsHash $msi
    $p = Start-Process msiexec.exe -ArgumentList "/i `"$msi`" /qn /norestart TS_NOLAUNCH=true" -Wait -PassThru
    if ($p.ExitCode -ne 0) { throw "Tailscale install failed with exit code $($p.ExitCode)" }
    $n = 0
    while ((Get-Service Tailscale -ErrorAction SilentlyContinue).Status -ne 'Running' -and $n -lt 30) { Start-Sleep -Seconds 1; $n++ }
    $name = "$($env:COMPUTERNAME.ToLower())-temp"
    $out = & $TsExe up "--authkey=$AuthKey" "--hostname=$name" --accept-dns=false --accept-routes=false --unattended --timeout=60s 2>&1
    if ($LASTEXITCODE) { throw "Tailscale would not connect: $out" }
    $listen = (& $TsExe ip -4 | Select-Object -First 1).Trim()
    Write-Log "Tailscale connected as $name at $listen"
  }

  Write-Log 'Setting up the private OpenSSH copy'
  $zip = "$Root\openssh.zip"
  Get-Verified $SshUrl $SshHash $zip
  Expand-Archive $zip -DestinationPath $Root -Force
  Remove-Item $zip -Force
  $ssh = "$Root\OpenSSH-Win64"
  # The login helper runs as a low-rights account and must be able to read these program files
  icacls $ssh /grant '*S-1-1-0:(OI)(CI)RX' /T | Out-Null
  if ($LASTEXITCODE) { throw 'Could not set read access on the OpenSSH folder.' }
  & "$ssh\ssh-keygen.exe" -q -t ed25519 -f "$Root\ssh_host_ed25519_key" -N '""'
  if ($LASTEXITCODE) { throw 'Could not make the SSH host key.' }
  $ascii = New-Object Text.ASCIIEncoding
  [IO.File]::WriteAllText("$Root\authorized_keys", "from=`"$Source`",no-port-forwarding,no-agent-forwarding,no-X11-forwarding $PubKey`n", $ascii)
  $conf = @(
    "Port $Port"
    "ListenAddress $listen"
    'HostKey __PROGRAMDATA__/SN-ClaudeAccess/ssh_host_ed25519_key'
    'PidFile __PROGRAMDATA__/SN-ClaudeAccess/sshd.pid'
    'AuthorizedKeysFile __PROGRAMDATA__/SN-ClaudeAccess/authorized_keys'
    'PubkeyAuthentication yes'
    'PasswordAuthentication no'
    'AuthenticationMethods publickey'
    "AllowUsers $User"
    'AllowTcpForwarding no'
    'GatewayPorts no'
    'PermitTunnel no'
  ) -join "`n"
  [IO.File]::WriteAllText("$Root\sshd_config", "$conf`n", $ascii)
  foreach ($f in 'ssh_host_ed25519_key', 'authorized_keys', 'sshd_config') {
    icacls "$Root\$f" /setowner '*S-1-5-18' | Out-Null
    icacls "$Root\$f" /inheritance:r /grant:r '*S-1-5-18:F' '*S-1-5-32-544:F' | Out-Null
    if ($LASTEXITCODE) { throw "Could not lock down $f." }
    icacls "$Root\$f" /remove:g "*$([Security.Principal.WindowsIdentity]::GetCurrent().User.Value)" | Out-Null
  }

  $bytes = New-Object byte[] 24
  [Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
  $pw = ConvertTo-SecureString ('Aa1!' + [Convert]::ToBase64String($bytes)) -AsPlainText -Force
  New-LocalUser -Name $User -Password $pw -AccountExpires $closeAt -PasswordNeverExpires -UserMayNotChangePassword -Description 'Temporary Claude access, removed automatically' | Out-Null
  Add-LocalGroupMember -SID 'S-1-5-32-544' -Member $User
  Write-Log "Account $User added"

  New-NetFirewallRule -DisplayName $Rule -Direction Inbound -Action Allow -Protocol TCP -LocalPort $Port -RemoteAddress $Source -Profile Any | Out-Null
  New-Service -Name $Svc -BinaryPathName "`"$ssh\sshd.exe`" -f `"$Root\sshd_config`" -E `"$Root\sshd.log`"" -DisplayName 'SN Claude temporary SSH' -StartupType Automatic | Out-Null
  sc.exe failure $Svc reset= 0 actions= restart/30000/restart/30000/restart/60000 | Out-Null
  Start-Service $Svc
  Start-Sleep -Seconds 2
  if ((Get-Service $Svc).Status -ne 'Running') { throw 'The SSH service would not stay running.' }

  $done = "ACCESS OPEN. Address $listen port $Port, allowed from $Source only, closes $($closeAt.ToString('yyyy-MM-dd h:mm tt'))"
  Write-Log $done
  Write-AuditLog -action 'Claude Temporary Access' -details $done
}

function Start-Open {
  if (-not $Yes) {
    Write-Host ''
    Write-Host "  This gives Claude admin SSH access to $env:COMPUTERNAME for $Hours hours, then removes it." -ForegroundColor Yellow
    if ((Read-Host '  Type YES to go ahead') -cne 'YES') { Write-Host '  Stopped. Nothing changed.'; return }
  }
  if (-not $LanTest -and -not $AuthKey) {
    $sec = Read-Host '  Paste the Tailscale auth key' -AsSecureString
    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec)
    $script:AuthKey = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
  }
  try { Open-Access }
  catch {
    Write-Log "FAILED: $($_.Exception.Message)"
    Write-AuditLog -action 'Claude Temporary Access' -level 'ERROR' -details "Open failed: $($_.Exception.Message)"
    if (Test-Path "$Root\sshd.log") { Get-Content "$Root\sshd.log" -Tail 6 | ForEach-Object { Write-Log "sshd: $_" } }
    Write-Log 'Removing everything this run added'
    Close-Access
    $script:OpenFailed = $true
  }
}

function Show-Status {
  "Service:    $((Get-Service $Svc -ErrorAction SilentlyContinue).Status)"
  "Account:    $(if (Get-LocalUser -Name $User -ErrorAction SilentlyContinue) { 'present' } else { 'none' })"
  "Firewall:   $(if (Get-NetFirewallRule -DisplayName $Rule -ErrorAction SilentlyContinue) { 'present' } else { 'none' })"
  "Tailscale:  $(if (Test-Path $TsExe) { & $TsExe ip -4 } else { 'not installed' })"
  "Auto-close: $((Get-ScheduledTaskInfo -TaskName $Task -ErrorAction SilentlyContinue).NextRunTime)"
  if (Test-Path $Log) { Get-Content $Log -Tail 8 }
}

function Show-ToolMenu {
  do {
    try { Clear-Host } catch { }
    $isOpen = [bool](Get-Service $Svc -ErrorAction SilentlyContinue)
    Write-Host ''
    Write-Host '  =================================================================' -ForegroundColor Cyan
    Write-Host '                     SUPERIOR NETWORKS LLC                        ' -ForegroundColor White
    Write-Host '           Claude Temporary Access - Toolkit v3.20.0              ' -ForegroundColor Cyan
    Write-Host '  =================================================================' -ForegroundColor Cyan
    Write-Host ''
    if ($isOpen) { Write-Host '  Access is OPEN on this PC.' -ForegroundColor Yellow } else { Write-Host '  Access is closed.' -ForegroundColor Green }
    Write-Host ''
    Write-Host '    1. Open access (needs a Tailscale auth key)' -ForegroundColor Cyan
    Write-Host '    2. Show status' -ForegroundColor Gray
    Write-Host '    3. Close access now' -ForegroundColor Cyan
    Write-Host '    Q. Back to main menu' -ForegroundColor Red
    Write-Host ''
    $choice = Read-Host '  Select an option'
    switch ($choice.ToUpper()) {
      '1' {
        $h = Read-Host '  Hours to stay open, 1 to 12 [4]'
        if ($h -match '^\d+$' -and [int]$h -ge 1 -and [int]$h -le 12) { $script:Hours = [int]$h } else { $script:Hours = 4 }
        Start-Open
        Read-Host '  Press Enter to continue' | Out-Null
      }
      '2' { Show-Status; Read-Host '  Press Enter to continue' | Out-Null }
      '3' { Close-Access; Read-Host '  Press Enter to continue' | Out-Null }
      'Q' { return }
    }
  } while ($true)
}

if ($PSVersionTable.PSVersion.Major -lt 5) { Write-Output 'This tool needs Windows PowerShell 5.1 or later.'; exit 1 }
$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $admin) { Write-Output 'Run this in PowerShell as admin.'; exit 1 }

$OpenFailed = $false
switch ($Action) {
  'Menu' { Show-ToolMenu }
  'Status' { Show-Status }
  'Close' { Close-Access }
  'Open' { Start-Open; if ($OpenFailed) { exit 1 } }
}
