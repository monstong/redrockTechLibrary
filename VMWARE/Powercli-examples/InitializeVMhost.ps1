#--------------------------------------------------------------
#
# Name : InitializeVMhost.ps1
# Creator : Redrock (Hong seok, Kang)
# Date : 2019.06.06
# Description: Initialize new vmhost to the existing vcenter
#   - prerequisites : Deploying vcenter is completed 
#                     All Physical Network connection and Storage connection are ready (means connected)
#                     All devices' location should be same for each purpose (ex: mgmt vss, vmotion vss, iscsi etc... )
#   - steps : 
# Language : Powercli
# 
# In this example, I assume that all devices' location are same like the below 
# vswitch0 (VSS) : vmnic0, vmnic1  (MGMT)
# vswitch1 (VSS) : vmnic2, vmnic3  (vmotion, iscsi)
# Dvswitch (DVS) : vmnic4, vmnic5  (vlan or overlay port group for NSX-T Edge cluster only)
# Datastore(ISCSI) 
# VM Kernel adapter MGMT: 192.168.30.x / VLAN 31
# VM Kernel adapter VMOTION: 192.168.40.x / VLAN 41
# VM Kernel adapter ISCSI: 192.168.50.x / VLAN 51
#
#--------------------------------------------------------------

$vCenter = "192.168.20.10"

$newHosts = @()

$vcCred = Get-Credential
$hostRootCred = Get-Credential

# connect to vcenter
Connect-VIServer $vCenter -Credential $vcCred -ErrorAction:Stop



# disconnect from vcenter
Disconnect-VIServer -Server $vCenter -Confirm:$false

