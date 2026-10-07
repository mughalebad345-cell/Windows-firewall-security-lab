# Windows Firewall Security Lab - PowerShell Commands
# Run firewall modification commands in PowerShell as Administrator.

# Check firewall profiles
Get-NetFirewallProfile

# View sample firewall rules
Get-NetFirewallRule | Select-Object -First 10 DisplayName, Direction, Action, Enabled

# Create inbound block rule for TCP port 8080
New-NetFirewallRule -DisplayName "Block TCP 8080 Inbound" -Direction Inbound -Protocol TCP -LocalPort 8080 -Action Block

# Verify block rule
Get-NetFirewallRule -DisplayName "Block TCP 8080 Inbound"

# Verify blocked port details
Get-NetFirewallRule -DisplayName "Block TCP 8080 Inbound" | Get-NetFirewallPortFilter

# Check whether port 8080 is listening
Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue

# Start temporary Python HTTP server
python -m http.server 8080

# Run this on Laptop 2 to test connectivity
Test-NetConnection 192.168.100.66 -Port 8080

# Disable block rule
Disable-NetFirewallRule -DisplayName "Block TCP 8080 Inbound"

# Create inbound allow rule for TCP port 8080
New-NetFirewallRule -DisplayName "Allow TCP 8080 Inbound Test" -Direction Inbound -Protocol TCP -LocalPort 8080 -Action Allow

# Verify allow rule
Get-NetFirewallRule -DisplayName "Allow TCP 8080 Inbound Test"

# Restore blocked state
Enable-NetFirewallRule -DisplayName "Block TCP 8080 Inbound"
Disable-NetFirewallRule -DisplayName "Allow TCP 8080 Inbound Test"

# Verify final state
Get-NetFirewallRule -DisplayName "Block TCP 8080 Inbound","Allow TCP 8080 Inbound Test" | Select-Object DisplayName,Enabled,Action

# Enable firewall logging
Set-NetFirewallProfile -Profile Domain,Private,Public -LogBlocked True -LogAllowed True

# Verify logging
Get-NetFirewallProfile | Select-Object Name,LogFileName,LogAllowed,LogBlocked

# View latest firewall log entries
Get-Content "C:\Windows\System32\LogFiles\Firewall\pfirewall.log" -Tail 30

# Wireshark display filter used in this lab:
# tcp.port == 8080
