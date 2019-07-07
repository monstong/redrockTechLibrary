#--------------------------------------------------------------
#
# Name : Set-DNSClientToVMHosts.ps1
# Creator : Redrock (Hong seok, Kang)
# Date : 2019.06.08
# Description: Configure DNS client setting to multiple vmhosts
# Language : Powercli
#
#--------------------------------------------------------------

$vCenter = "192.168.20.10"
$vcUser = "administrator@vsphere.local"
$vcSecPasswd = ConvertTo-SecureString "mypassword" -AsPlainText -Force
$vcCred = New-Object System.Management.Automation.PSCredential( $vcUser, $vcSecPasswd )
$DNSServers = @("192.168.20.21","192.168.20.22")
$domainSuffix = "example.mydomain"

# connect to vcenter
Connect-VIServer $vCenter -Credential $vcCred -ErrorAction:Stop

# get all or specified vmhosts

$vmhosts = Get-VMHost # | where { $_.Parent -eq 'aaacluster'}

# Set DNS client setting to the specified vmhosts

foreach ($vmhost in $vmhosts) {
    Get-VMHostNetwork -VMHost $vmhost | Set-VMHostNetwork -DomainName $domainSuffix -DnsAddress $DNSServers -Confirm:$false
}

# disconnect from vcenter
Disconnect-VIServer -Server $vCenter -Confirm:$false
