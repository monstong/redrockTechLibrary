#--------------------------------------------------------------
#
# Name : InitializeVCenter.ps1
# Creator : Redrock (Hong seok, Kang)
# Date : 2019.06.06
# Description: Initialize New vcenter
#   - prerequisites : Deploying vcenter is completed 
#                     All Physical Network connection and Storage connection are ready (means connected)
#                     All devices' location should be same for each purpose (ex: mgmt vss, vmotion vss, iscsi etc... )
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
$datacenter = "myRegion01"

$clusters = @("mgmtClu","edgeClu","computeClu")

$newHosts = @("192.168.20.51","192.168.20.52","192.168.20.53","192.168.20.54","192.168.20.55","192.168.20.56")

# vcenter and esxi local admin(root) credential
$vcUser = "administrator@vsphere.local"
$vcSecPasswd = ConvertTo-SecureString "mypassword" -AsPlainText -Force
$vcCred = New-Object System.Management.Automation.PSCredential( $vcUser, $vcSecPasswd )

$esxiUser = "root"
$esxiSecPasswd = ConvertTo-SecureString "mypassword" -AsPlainText -Force
$esxiCred = New-Object System.Management.Automation.PSCredential( $esxiUser, $esxiSecPasswd )

# connect to vcenter
Connect-VIServer $vCenter -Credential (Get-Credential) -ErrorAction:Stop

# get the folder location from top
$location = Get-Folder -NoRecursion

# create datacenter
New-Datacenter -Location $location -Name $datacenter

# add new hosts to vcenter
foreach ( $vmhost in $newHosts ) {
    Add-VMHost -Name $vmhost -Location (Get-Datacenter $datacenter) -Force -Credential $esxiCred -Confirm:$false
}

# create clusters  (enabling vsphere HA  and DRS with fullautomated mode)
foreach ($clu in $clusters) {
    New-Cluster -Name $clu -Location (Get-Datacenter $datacenter) -HAEnabled -DrsEnabled -DrsMode:FullyAutomated 
}

# rename local datastore name(for internal disks) 

foreach ( $ds in Get-Datastore){

$dsexp = $ds.extensiondata

    # is not shared ?
    if ($dsexp.summary.multiplehostaccess -eq $false){
        # is name started with 'datastore' ? 
        if($ds.name -like 'datastore*'){
            $vmhost = Get-VMHost -id ($dsexp.host.key)
            $vmhostname = vmhost.extensiondata.config.network.dnsconfig.hostname

            # rename targeted datastore
            $newdsname = $vmhostname + "_local_ds"
            $ds | Set-Datastore -name $newdsname
        }
    }
}

# get the registered vmhosts
$vmhosts = Get-VMHost

# move new hosts  to each cluster (matched by hostname )
foreach ( $vmhost in $vmhosts ) {
    $tmpVMhostname = (Get-View $vmhost.Extensiondata.ConfigManager.NetworkSystem).DnsConfig.HostName

    $targetClustername = $tmpVMhostname.Substring(0,$tmpVMhostname.Length-6) + "Clu" 
    
    try {
        $targetCluster = Get-Cluster -name $targetClustername
        Move-VMHost -VMHost $vmhost -Location $targetCluster
    } catch {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        Write-Warning "[Exception: " $FailedItem "]" + "Message was " + $ErrorMessage
    }
}


# configuring common VSS
# vswitch0 (VSS) : vmnic0, vmnic1  (MGMT)
# vswitch1 (VSS) : vmnic2, vmnic3  (vmotion, iscsi)
# Dvswitch (DVS) : vmnic4, vmnic5  (vlan or overlay port group for NSX-T Edge cluster only)
# Datastore(ISCSI) 
# VM Kernel adapter MGMT: 192.168.30.x / VLAN 31
# VM Kernel adapter VMOTION: 192.168.40.x / VLAN 41
# VM Kernel adapter ISCSI: 192.168.50.x / VLAN 51

foreach ( $vmhost in $vmhosts ) {
    $vs0 = Get-VirtualSwitch -VMHost $vmhost -name vswitch0

    $vmnic0 = Get-VMHostNetworkAdapter -VMHost $vmhost -Physical -Name vmnic0
    $vmnic1 = Get-VMHostNetworkAdapter -VMHost $vmhost -Physical -Name vmnic1
    $vmnic2 = Get-VMHostNetworkAdapter -VMHost $vmhost -Physical -Name vmnic2
    $vmnic3 = Get-VMHostNetworkAdapter -VMHost $vmhost -Physical -Name vmnic3

    $vs0 | Add-VirtualSwitchPhysicalNetworkAdapter -VMHostPhysicalNic $vmnic0,$vmnic1 -Confirm:$false

    $vs1 = New-VirtualSwitch -name vswitch1 -VMHost $vmhost    
    $vs1 | Add-VirtualSwitchPhyalNetworkAdapter -VMHostPhysicalNic $vmnic2,$vmnic3 -Confirm:$false

    $vmotionPortgroup = New-VirtualPortGroup -VirtualSwitch $vs1 -name "vmotion" -VLanId 41
    $iscsiPortgroup = New-VirtualPortGroup -VirtualSwitch $vs1 -name "iscsi" -VLanId 51

    $tmpstr = [String]$vmhost.name
    $vmkVMotionIP = $tmpstr.Replace('.30.','.40.')
    $vmkIscsiIP = $tmpstr.Replace('.30.','.50.')

    New-VMHostNetworkAdapter -VMHost $vmhost -PortGroup $vmotionPortgroup -VirtualSwitch $vs1 -ip $vmkVMotionIP -SubnetMask 255.255.255.0 -VMotionEnabled:$true
    New-VMHostNetworkAdapter -VMHost $vmhost -PortGroup $iscsiPortgroup -VirtualSwitch $vs1 -ip $vmkIscsiIP -SubnetMask 255.255.255.0 

    # create iscsi software adapter
    Get-VMHostStorage -VMHost $vmhost | Set-VMHostStorage -SoftwareIScsiEnabled:$true

    # check what adapter is created, then break
    while($true){
        $iscsiHba = $vmhost | Get-VMHostHba -Type IScsi | where {$_.model -eq "iSCSI Software Adpater"}

        if($iscsiHba -ne $null) break;
    }

    # add iscsi sending target
    $iscsiTarget = "192.168.50.200"

    $iscsiHba = $vmhost | Get-VMHostHba -Type IScsi | where {$_.model -eq "iSCSI Software Adpater"}
    New-IScsiHbaTarget -IScsiHba $iscsiHba -Address $iscsiTarget

    # vmk port binding for iscsi
    $iscsiVMK = Get-VMHostNetworkAdapter -VMHost $vmhost -PortGroup iscsi

    $esxcli = Get-EsxCli -V2 -VMHost $vmhost
    $cargs = $esxcli.iscsi.networkportal.add.createargs()
    $cargs.adapter = [string]$iscsiHba.device
    $cargs.force = $false
    $cargs.nic = [string]$iscsiHba.devicename
    $esxcli.iscsi.networkportal.add.invoke($cargs)

    Get-VMHostStorage -RescanAllHba -RescanVmfs -VMHost $vmhost



}

# disconnect from vcenter
Disconnect-VIServer -Server $vCenter -Confirm:$false