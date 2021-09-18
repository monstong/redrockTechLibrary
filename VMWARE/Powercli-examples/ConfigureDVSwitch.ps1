#--------------------------------------------------------------
#
# Name : ConfigureDVSwitch.ps1
# Creator : Redrock (Hong seok, Kang)
# Date : 2019.07.06
# Description: create and configure DVswitch and portgroup
#                    
# Language : Powercli
#
#--------------------------------------------------------------

$vCenter = "192.168.20.10"

# vcenter and esxi local admin(root) credential
$vcUser = "administrator@vsphere.local"
$vcSecPasswd = ConvertTo-SecureString "mypassword" -AsPlainText -Force
$vcCred = New-Object System.Management.Automation.PSCredential( $vcUser, $vcSecPasswd )

# connect to vcenter
Connect-VIServer $vCenter -Credential $vcCred -ErrorAction:Stop

Set-PowerCLIConfiguration -Scope:User -ParticipateInCeip:$false -Confirm:$false

# select vmhosts for dvs
$selectedHosts = Get-VMHost | where {$_.Parent -eq 'edgeClu'}

# create dvs
New-VDSwitch -name "DVS1" -Location (Get-Datacenter) -Mtu 1600

# add vmhost to dvs
Get-VDSwitch | Add-VDSwitchVMHost -VMHost $selectedHosts

# create portgroups
Get-VDSwitch | New-VDPortgroup -Name external-pg -VlanId 110
Get-VDSwitch | New-VDPortgroup -name overlay-pg -VlanTrunkRange '0-4094'

# assign physical nics (vmnic4,5)

foreach ($vmhost in $selectedHosts){
    $vmnic4 = Get-VMHostNetworkAdapter -VMHost $vmhost -Physical -Name vmnic4
    $vmnic5 = Get-VMHostNetworkAdapter -VMHost $vmhost -Physical -Name vmnic5

    Get-VDSwitch | Add-VDSwitchPhysicalNetworkAdapter -VMHostPhysicalNic $vmnic4,$vmnic5 -Confirm:$false
} 


# disconnect from vcenter
Disconnect-VIServer -Server $vCenter -Confirm:$false