#--------------------------------------------------------------
#
# Name : New-WindowsVMfromTemplate.ps1
# Creator : Redrock (Hong seok, Kang)
# Date : 2019.07.06
# Description: create windows VM  from template
#   - prerequisites : Windows VM template already exists.
#                     template should not have any network adapter.
#                     download winrm init script(https://github.com/ansible/ansible/blob/devel/examples/scripts/ConfigureRemotingForAnsible.ps1)
#                    
# Language : Powercli
#
#--------------------------------------------------------------

$vCenter = "192.168.20.10"

# vcenter and esxi local admin(root) credential
$vcUser = "administrator@vsphere.local"
$vcSecPasswd = ConvertTo-SecureString "mypassword" -AsPlainText -Force
$vcCred = New-Object System.Management.Automation.PSCredential( $vcUser, $vcSecPasswd )

# Cluster info

$cluName = "compClu"

# Datastore info

$dsName = "DS00-Shared-01"

# VM info

$winTemplateName = "WIN2016"
$VMname = "testwin01"
$Vnetwork = "VM network"
$vmhostname = "192.168.20.101"

$vmUser = "administrator"
$vmPasswd = ConvertTo-SecureString "mypassword" -AsPlainText -Force
$vmCred = New-Object System.Management.Automation.PSCredential( $vmUser, $vmSecPasswd )

$ipAddr = "10.20.20.20"
$gw = "10.20.20.1"
$dnsServer = "10.20.20.10,10.20.20.11"

# connect to vcenter
Connect-VIServer $vCenter -Credential $vcCred -ErrorAction:Stop

$winTemplate = Get-Template -Name $winTemplateName
$ds = Get-Datastore -Name $dsName
$vmhost = Get-VMHost -name $vmhostname
$vmnet = Get-VirtualPortGroup -VMHost $vmhost -Name $Vnetwork


# create vm and configure basic hw spec
New-VM -Name $VMname -VMHost $vmhost -Template $winTemplate -Datastore $ds -Confirm:$false

$newVM = get-vm -name $VMname
Set-VM -VM $newVM -CoresPerSocket 2 -NumCpu 2 -MemoryGB 4 -Confirm:$false
New-NetworkAdapter -VM $newVM -Portgroup $vmnet -Type Vmxnet3 -StartConnected:$true -Confirm:$false

# run sysprep manually.

Invoke-VMScript -ScriptText "c:\windows\system32\sysprep\sysprep.exe /quiet /oobe /generalize" -vm $newVM -GuestCredential $vmCred -ScriptType Powershell


# restart vm

Restart-VMGuest -vm $newVM -Confirm:$false

# rename hostname

$script = "Rename-Computer #hostname#"
$script = $script.Replace("#hostname#",$VMname)
Invoke-VMScript -ScriptText $script -vm $newVM -GuestCredential $vmCred -ScriptType Powershell

# configure network setting (IP and DNS)

$script = "New-NetIPAddress -InterfaceAlias (Get-NetAdapter).name -IPAddress #IPADDR# -DefaultGateway #GW# -AddressFamily IPv4 -PrefixLength 24"
$script = $script.Replace("#IPADDR#",$ipAddr)
$script = $script.Replace("#GW#",$gw)

Invoke-VMScript -ScriptText $script -vm $newVM -GuestCredential $vmCred -ScriptType Powershell

$script = "Set-DnsClientServerAddress -InterfaceAlias (Get-NetAdapter).name -ServerAddresses #DNSs#"
$script = $script.Replace("#DNSs#",$dnsServer)

Invoke-VMScript -ScriptText $script -vm $newVM -GuestCredential $vmCred -ScriptType Powershell

# configure timezone
Invoke-VMScript -ScriptText "Set-TimeZone -id 'Korea Standard Time'" -vm $newVM -GuestCredential $vmCred -ScriptType Powershell

# restart vm
Restart-VMGuest -vm $newVM -Confirm:$false


# create folder 
Invoke-VMScript -ScriptText "New-Item -ItemType Directory -Path c:\MGMT" -vm $newVM -GuestCredential $vmCred -ScriptType Powershell

# upload and run ansible script 

$winRMscr = "C:\temp\ConfigureRemotingForAnsible.ps1"

Copy-VMGuestFile -Source $winRMscr -Destination "C:\MGMT" -LocalToGuest -VM $newVM -GuestCredential $vmCred -Force:$true
Invoke-VMScript -ScriptText "C:\MGMT\ConfigureRemotingForAnsible.ps1" -vm $newVM -GuestCredential $vmCred -ScriptType Powershell

# test winrm
$so = New-PSSessionOption -SkipCACheck -SkipCNCheck 
$sess = New-PSSession -ComputerName $ipAddr -Credential $vmCred -UseSSL -SessionOption $so

Copy-Item -Path "c:\temp\a.txt" -Destination "C:\MGMT" -ToSession $sess -Force:$true

Remove-PSSession -Session $sess

#rename admin username
Invoke-VMScript -ScriptText "rename-localuser -name administrator -newname myadmin" -vm $newVM -GuestCredential $vmCred -ScriptType Powershell

# disconnect from vcenter
Disconnect-VIServer -Server $vCenter -Confirm:$false