#--------------------------------------------------------------
#
# Name : Set-NTPConfigToVMHosts.ps1
# Creator : Redrock (Hong seok, Kang)
# Date : 2019.06.06
# Description: apply ntp configuration to multiple vmhosts
# Language : Powercli
#
#--------------------------------------------------------------

$vCenter = "192.168.20.10"

$NTPServers = @("192.168.20.11","192.168.20.12")

# connect to vcenter
Connect-VIServer $vCenter -Credential (Get-Credential) -ErrorAction:Stop

# get all or specified vmhosts

$vmhosts = Get-VMHost # | where { $_.Parent -eq 'aaacluster'}

# get the current ntp configuration from the specified vmhosts.

$vmhosts | Get-VMHostNtpServer
$vmhosts | Get-VMHostService | where { $_.key -eq 'ntpd'}
$vmhosts | Get-VMHostFirewallException | where { $_.name -eq 'NTP client'}

# Set the NTP configuration (add NTP server and enable NTPd, add FW exception rule for ntp client

foreach ($vmhost in $vmhosts) {
    # add NTP servers
    Add-VMHostNtpServer -VMHost $vmhost -NtpServer $NTPServers[0]
    Add-VMHostNtpServer -VMHost $vmhost -NtpServer $NTPServers[1]

    # start ntp client and  set the automatic startup
    Get-VMHostService -VMHost $vmhost | where { $_.key -eq 'ntpd'} | Start-VMHostService 
    Get-VMHostService -VMHost $vmhost | where { $_.key -eq 'ntpd'} | Set-VMHostService -Policy Automatic

    # enable firewall exception for ntp client from all
    Get-VMHostFirewallException -VMHost $vmhost | where { $_.name -eq 'NTP client'} | Set-VMHostFirewallException -Enabled:$true
}

# disconnect from vcenter
Disconnect-VIServer -Server $vCenter -Confirm:$false
