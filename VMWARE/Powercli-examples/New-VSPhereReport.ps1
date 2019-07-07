#--------------------------------------------------------------
#
# Name : New-VSPhereReport.ps1
# Creator : Redrock (Hong seok, Kang)
# Date : 2019.07.06
# Description: generate vsphere report for VM, cluster, vmhost and datastore information                  
# Language : Powercli
#
#--------------------------------------------------------------

$vCenter = "192.168.20.10"

# vcenter and esxi local admin(root) credential
$vcUser = "administrator@vsphere.local"
$vcSecPasswd = ConvertTo-SecureString "mypassword" -AsPlainText -Force
$vcCred = New-Object System.Management.Automation.PSCredential( $vcUser, $vcSecPasswd )


# connect to vcenter

Write-Host "[" (Get-Date -UFormat "%Y%m%d-%H%M%S").ToString() "]" $vCenter " is connecting..."
Connect-VIServer $vCenter -Credential $vcCred -ErrorAction:Stop
Write-Host "[" (Get-Date -UFormat "%Y%m%d-%H%M%S").ToString() "]" $vCenter " is connected"

# get datacenter

$dc = (Get-View -ViewType Datacenter).name

# get cluster info

$clusterInfo = @()

foreach($clu in Get-View -ViewType ClusterComputeResource){
    $tmpclu = "" | Select-Object Name, numHosts, isVSAN, Moref
    $tmpclu.Name = $clu.Name
    $tmpclu.numHosts = $clu.Host.Count
    $tmpclu.isVSAN = $clu.ConfigurationEx.vsanConfigInfo.Enabled
    $tmpclu.Moref = $clu.Moref

    $clusterInfo += $tmpclu
}

# get host info

$vmhostInfo = @()
$vmhostList = Get-View -ViewType HostSystem

foreach ($vmhost in $vmhostList){
    $tmphost = "" | Select-Object Name, totalCPU, totalMemGB, ParentMoref, DSlist, Moref
    $tmphost.Name = $vmhost.name
    $tmphost.totalCPU = $vmhost.hardware.cpuinfo.numCpucores
    $tmphost.totalMemGB = [math]::Round($vmhost.hardware.memorysize/1024/1024/1024,0)
    $tmphost.ParentMoref = $vmhost.parent
    $tmphost.DSlist = $vmhost.datastore
    $tmphost.Moref = $vmhost.moref

    $vmhostInfo += $tmphost
}

# get datastore info

$dsInfo = @()

foreach ($ds in Get-View -ViewType Datastore){
    $tmpds = "" | Select-Object Name, DSType, isShared, totalCapacityGB, Moref
    $tmpds.Name = $ds.name
    $tmpds.DSType = $ds.summary.type
    $tmpds.isShared = $ds.summary.multiplehostaccess
    $tmpds.totalCapacityGB = [math]::Round($ds.summary.capacity/1024/1024/1024,2)
    $tmpds.Moref = $ds.moref

    $dsInfo += $tmpds
}

# get all vms' info

$vmInfo = @()

foreach ( $clu in $clusterInfo) {
    foreach ( $vm in Get-View -ViewType VirtualMachine -SearchRoot $clu.Moref) {
        $vms = "" | Select-Object VMName, VMPowerState, VMStatus, Hostname, VMHost, ClusterName, ProvisionedSpaceGB, GuestOS, IPAddress, Boottime, TotalCPU, TotalMemGB, TotalNics, HardwareVersion, Folder, Notes, AlarmActionEnabled, NB_last_backup

        $getvm = Get-VM -Id $vm.moref
        $vms.VMName = $vm.name
        $vms.VMPowerState = $vm.Runtime.Powerstate
        $vms.VMStatus = $vm.OverallStatus
        $vms.Hostname = $vm.guest.hostname
        $vms.VMHost = ($vmhostList | Where-Object { $_.MoRef -eq $vm.runtime.host} | select name).name
        $vms.ClusterName = $clu.name
        $vms.ProvisionedSpaceGB = [math]::Round($getvm.ProvisionedSpaceGB,2)
        $vms.GuestOS = $vm.Config.GuestFullName
        $vms.IPAddress = [string]$vm.guest.ipaddress
        $vms.Boottime = $vm.Runtime.BootTime
        $vms.TotalCPU = $vm.summary.config.numcpu
        $vms.TotalMemGB = [math]::Round($vm.summary.config.MemorySizeMB/1024,0)
        $vms.TotalNics = $vm.summary.config.numEhternetCards
        $vms.HardwareVersion = $vm.config.version
        $vms.Folder = $getvm.Folder
        $vms.Notes = $vm.config.Annotation
        $vms.AlarmActionEnabled = $vm.AlarmActionEnabled
        $vms.NB_last_backup = $getvm | Select-Object -ExpandProperty CustomFields | Where-Object {$_.key -eq 'Last Backup'} | Select-Object -ExpandProperty value

        $vmInfo += $vms
    }
}

# generate vm counts, all cpu count, mem size, provisioned space summary by folder

$vmsByFolder = @()

foreach ( $item in $vmInfo | Group-Object -Property Folder ) {
    $vms = "" | Select-Object Folder, VMcount, onVMcount, TotalVcores, TotalMemGB, TotalProvisionedspaceGB, onTotalVcores, onTotalMemGB, onTotalProvisionedspaceGB

    $vms.Folder = $item.name
    $vms.VMcount = $item.count
    $vms.onVMcount = ($item.group | Measure-Object totalcpu -sum).sum
    $vms.TotalVcores = ($item.group | Measure-Object toatlmemgb -sum).sum 
    $vms.TotalMemGB =  ($item.group | Measure-Object provisionedspacegb -sum).sum
    $vms.TotalProvisionedspaceGB =  ($item.group | Where-Object {$_.VMPowerState -eq 'PoweredOn'} | Measure-Object).count
    $vms.onTotalVcores = ($item.group | Where-Object {$_.VMPowerState -eq 'PoweredOn'} | Measure-Object totalcpu -sum).sum
    $vms.onTotalMemGB =  ($item.group | Where-Object {$_.VMPowerState -eq 'PoweredOn'} | Measure-Object toatlmemgb -sum).sum
    $vms.onTotalProvisionedspaceGB = ($item.group | Where-Object {$_.VMPowerState -eq 'PoweredOn'} | Measure-Object provisionedspacegb -sum).sum

    $vmsByFolder += $vms
}

# generate vm counts, all cpu count, mem size, provisioned space summary by cluster

$vmsByCluster = @()
foreach ( $item in $vmInfo | Group-Object -Property clustername ){
    $vms = "" | Select-Object Clustername, VMcount, onVMcount, TotalVcores, TotalMemGB, TotalProvisionedspaceGB, onTotalVcores, onTotalMemGB, onTotalProvisionedspaceGB

    $vms.Clustername = $item.name
    $vms.VMcount = $item.count
    $vms.onVMcount = ($item.group | Measure-Object totalcpu -sum).sum
    $vms.TotalVcores = ($item.group | Measure-Object toatlmemgb -sum).sum 
    $vms.TotalMemGB =  ($item.group | Measure-Object provisionedspacegb -sum).sum
    $vms.TotalProvisionedspaceGB =  ($item.group | Where-Object {$_.VMPowerState -eq 'PoweredOn'} | Measure-Object).count
    $vms.onTotalVcores = ($item.group | Where-Object {$_.VMPowerState -eq 'PoweredOn'} | Measure-Object totalcpu -sum).sum
    $vms.onTotalMemGB =  ($item.group | Where-Object {$_.VMPowerState -eq 'PoweredOn'} | Measure-Object toatlmemgb -sum).sum
    $vms.onTotalProvisionedspaceGB = ($item.group | Where-Object {$_.VMPowerState -eq 'PoweredOn'} | Measure-Object provisionedspacegb -sum).sum

    $vmsByCluster += $vms    
}

# host cluster map

$hostclustermap = @()

foreach ( $tmphost in $vmhostInfo) {
    foreach ($clu in $clusterInfo ) {
        if ($tmphost.parentmoref -eq $clu.moref) {
            $tmphostclumap = "" | Select-Object vmhostname, totalcpu, totalmemgb, clustername, dslist, numhosts, isvsan

            $tmphostclumap.vmhostname = $tmphost.name
            $tmphostclumap.totalcpu = $tmphost.totalcpu
            $tmphostclumap.totalmemgb = $tmphost.totalmemgb
            $tmphostclumap.clustername = $clu.name
            $tmphostclumap.dslist = $tmphost.dslist
            $tmphostclumap.numhosts = $clu.numhosts
            $tmphostclumap.isvsan = $clu.isvsan

            $hostclustermap += $tmphostclumap
        }
    }
}


## host ds map

$rawhostdsmap = @()

foreach ( $tmphost in $hostclustermap) {
    foreach($dsid in $tmphost.dslist) {
        foreach ($ds in $datastoreinfo){
            if($dsid -eq $ds.moref -and $ds.isshared ){
                $tmphost2 = $tmphost.psobject.copy()

                $tmphost2 | Add-Member -MemberType NoteProperty -Name dsname -Value $ds.name
                $tmphost2 | Add-Member -MemberType NoteProperty -Name dstype -Value $ds.dstype
                $tmphost2 | Add-Member -MemberType NoteProperty -Name totalcapacitygb -Value $ds.totalcapacitygb

                $rawhostdsmap += $tmphost2
            }
        }
    }
}


# html generating

$head = @'
<style>
body { font-family:arial;font-size:12pt;}
table { border-collapse:collapse }

table, th, td {
    border: 1px solid black;
    }

tr:nth-child(even) { background-color:#f2f2f2}
tr:hover {background-color:#f5f5f5}
th { background-color:#0d0d0d;color:white }
</style>
'@

$tab1 = $rawhostdsmap | ConvertTo-Html -Fragment -PreContent '<h2>1. info</h2>' | Out-String

$tab2 = $vmsByFolder | ConvertTo-Html -Fragment -PreContent '<h2>2. info</h2>' | Out-String

$tab3 = $vmsByCluster | ConvertTo-Html -Fragment -PreContent '<h2>3. info</h2>' | Out-String


$tab4 = $vmInfo | ConvertTo-Html -Fragment -PreContent '<h2> 4. info </h2>' | Out-String

$title = '<h1> vsphere report </h1>'

ConvertTo-Html -Head $head -PostContent $tab1, $tab2, $tab3, $tab4 -PreContent $title | Out-File "report.html"


# disconnect from vcenter
Disconnect-VIServer -Server $vCenter -Confirm:$false