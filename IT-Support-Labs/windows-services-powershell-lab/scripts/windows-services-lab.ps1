<#
.SYNOPSIS
    Windows services management lab (Google Cloud Skills Boost / Qwiklabs).
.NOTES
    Run in an elevated PowerShell on a lab VM, NOT on your personal machine.
#>

# 1. List all services
Get-Service

# 2. Inspect one service by its short Name
Get-Service wisvc
Get-Service wisvc | Format-List *

# 3. Start and stop a service
Start-Service wisvc
Get-Service wisvc
Stop-Service wisvc
Get-Service wisvc

# 4. Disabled service: fails first, then enable it via Set-Service
Get-Service ScardSvr | Format-List *      # StartType : Disabled
Start-Service ScardSvr                    # Error: CouldNotStartService
Set-Service ScardSvr -StartupType Manual
Start-Service ScardSvr
Get-Service ScardSvr                      # Status : Running

# 5. Install extra Windows features (IIS web server)
Install-WindowsFeature Web-WebServer,Web-Mgmt-Tools -IncludeAllSubFeature
Get-Service IISADMIN

# --- Bonus: security / SOC oriented one-liners ---
# Only running services
Get-Service | Where-Object { $_.Status -eq 'Running' }

# Services that are Disabled (smaller attack surface)
Get-CimInstance Win32_Service | Where-Object { $_.StartMode -eq 'Disabled' } |
    Select-Object Name, DisplayName, State

# Look for newly installed services (Event ID 7045) in the System log
Get-WinEvent -FilterHashtable @{ LogName='System'; Id=7045 } -MaxEvents 20 |
    Select-Object TimeCreated, Message

# Look for service start type changes (Event ID 7040)
Get-WinEvent -FilterHashtable @{ LogName='System'; Id=7040 } -MaxEvents 20 |
    Select-Object TimeCreated, Message
