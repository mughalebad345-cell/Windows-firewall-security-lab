# Windows Firewall Security Lab Documentation

## Project Overview
This project demonstrates a hands-on Windows Firewall security lab using two Windows laptops on the same local network.

Laptop 1 was used as the server and firewall machine. Laptop 2 was used as the client/testing machine.

## Lab Environment
- Laptop 1: Server / Firewall Machine
- Laptop 2: Client / Testing Machine
- Windows Defender Firewall
- Windows PowerShell
- Python HTTP Server
- Wireshark
- Npcap
- GitHub

## Lab Network
Laptop 1:
- IP Address: `192.168.100.66`
- Role: Server + Firewall

Laptop 2:
- IP Address used during testing: `192.168.100.129`
- Role: Client / Testing Machine

## Firewall Profile Check
Command:

```powershell
Get-NetFirewallProfile
```

The Domain, Private, and Public firewall profiles were confirmed as enabled.

## Existing Firewall Rules
Command:

```powershell
Get-NetFirewallRule | Select-Object -First 10 DisplayName, Direction, Action, Enabled
```

This was used to review existing inbound and outbound firewall rules.

## TCP Port 8080 Blocking Test
A custom inbound blocking rule was created:

```powershell
New-NetFirewallRule -DisplayName "Block TCP 8080 Inbound" -Direction Inbound -Protocol TCP -LocalPort 8080 -Action Block
```

The rule was verified using:

```powershell
Get-NetFirewallRule -DisplayName "Block TCP 8080 Inbound"
```

Port details were verified using:

```powershell
Get-NetFirewallRule -DisplayName "Block TCP 8080 Inbound" | Get-NetFirewallPortFilter
```

## Python HTTP Server
A temporary HTTP server was started on Laptop 1:

```powershell
python -m http.server 8080
```

The listening port was verified using:

```powershell
Get-NetTCPConnection -LocalPort 8080
```

The port showed the `Listen` state.

## Blocked Connection Test
Laptop 2 tested the connection using:

```powershell
Test-NetConnection 192.168.100.66 -Port 8080
```

Result:

```text
TcpTestSucceeded : False
```

This confirmed that Windows Firewall blocked the inbound connection.

## Allowed Connection Test
The block rule was disabled:

```powershell
Disable-NetFirewallRule -DisplayName "Block TCP 8080 Inbound"
```

An allow rule was created:

```powershell
New-NetFirewallRule -DisplayName "Allow TCP 8080 Inbound Test" -Direction Inbound -Protocol TCP -LocalPort 8080 -Action Allow
```

Laptop 2 tested the connection again:

```powershell
Test-NetConnection 192.168.100.66 -Port 8080
```

Result:

```text
TcpTestSucceeded : True
```

This confirmed that the inbound connection was allowed.

## Wireshark Traffic Capture
Wireshark was used on Laptop 1 with this display filter:

```text
tcp.port == 8080
```

The TCP handshake was visible:

```text
SYN
SYN, ACK
ACK
```

This confirmed that the connection was successfully established and visible on the network.

## Firewall Logging
Firewall logging was enabled using:

```powershell
Set-NetFirewallProfile -Profile Domain,Private,Public -LogBlocked True -LogAllowed True
```

The logging configuration was verified using:

```powershell
Get-NetFirewallProfile | Select-Object Name,LogFileName,LogAllowed,LogBlocked
```

Firewall log location:

```text
C:\Windows\System32\LogFiles\Firewall\pfirewall.log
```

The latest log entries were checked using:

```powershell
Get-Content "C:\Windows\System32\LogFiles\Firewall\pfirewall.log" -Tail 30
```

A `DROP TCP` entry for port `8080` was observed after Laptop 2 attempted the blocked connection.

## Final Result
The lab successfully demonstrated:
- Firewall profile verification
- Firewall rule inspection
- Inbound TCP port blocking
- Inbound TCP port allowing
- Temporary service hosting on port 8080
- Connectivity testing between two laptops
- Blocked vs allowed comparison
- Wireshark TCP traffic capture
- Windows Firewall blocked traffic logging

## What I Learned
- How Windows Firewall controls inbound traffic
- How to create and verify firewall rules with PowerShell
- How to test TCP connectivity between two systems
- How to verify listening ports
- How to compare blocked and allowed connections
- How to use Wireshark to inspect TCP traffic
- How to enable and review Windows Firewall logs

## Disclaimer
This lab was performed only in a controlled and authorized environment for educational purposes.
