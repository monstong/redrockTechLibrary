#--------------------------------------------------------------
#
# Name : New-DatastoreUsingFreeLun.ps1
# Creator : Redrock (Hong seok, Kang)
# Date : 2019.07.06
# Description: Create new datastore using free lun (iscsi)
# Language : Powercli
#
#--------------------------------------------------------------

$vCenter = "192.168.20.10"

# vcenter and esxi local admin(root) credential
$vcUser = "administrator@vsphere.local"
$vcSecPasswd = ConvertTo-SecureString "mypassword" -AsPlainText -Force
$vcCred = New-Object System.Management.Automation.PSCredential( $vcUser, $vcSecPasswd )

$esxiUser = "root"
$esxiSecPasswd = ConvertTo-SecureString "mypassword" -AsPlainText -Force
$esxiCred = New-Object System.Management.Automation.PSCredential( $esxiUser, $esxiSecPasswd )
$esxiName = "192.168.20.100"
# connect to vcenter
Connect-VIServer $vCenter -Credential $vcCred -ErrorAction:Stop

$vmhost = Get-VMHost -name $esxiName

$conmgr = Get-View $vmhost.ExtensionData.ConfigManager.DatastoreSystem

$freeLun = $conmgr.QueryAvailableDisksForVmfs($null).canonicalname

New-Datastore -VMHost $vmhost -Path $freeLun -Name "DS00-ISCSI"


# disconnect from vcenter
Disconnect-VIServer -Server $vCenter -Confirm:$false