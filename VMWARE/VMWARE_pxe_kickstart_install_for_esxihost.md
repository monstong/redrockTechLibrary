S.R.E



Deployment
Installing
Removing
Monitoring
Auto-scaling
Auto-healing
 


데이터 분산, API, Hub-and-spoke 아키텍쳐 , infra관리를 위한 전통적인 분산 시스템 소프트웨어 개발


# VMWARE PXE and kickstart install for ESXi host

kernelopt=ks=http://192.168.200.11/ks.cfg

set boot order  in bios
 - local
 - cdrom
 - pxe




TFTPBOOT
 - pxelinux.cfg / 
   default file
   mac address file started with 01- (01-00-08-c9-d8-d9) - lowercase only

 - pxelinux.0
 - menu.c32
 - images/
   boot.cfg (customzied)
   mboot.c32
   prefix=http://XXX.XXX.XXX.XXX/ESXi-6.x.x-XXXXXX/


 Get-ChildItem -path "C:\VMware\Patches" -Recurse -include *.zip | foreach-object{
$ESXSoftwareDepot = Add-EsxSoftwareDepot $_.fullname
get-esxImageProfile | where {$_.Name -notlike "*tools"} |foreach-object{
$IsoFullPath = "C:\VMware\ISO\" + $_.name + ".iso"
Export-esxImageProfile $_.name -ExportToIso -FilePath $IsoFullPath
}
$ESXSoftwareDepot | Remove-EsxSoftwareDepot



connect-viserver 192.168.200.170 -user root -password mypassword

$esxcli = get-esxcli -v2
$argsInstall = $esxcli.software.profile.update.createargs()
$argsInstall.depot = "http://192.168.200.11/ESXi600-201711001/index.html"
$argsInstall.profile = "ESXi-6.0.0-20171104001-standard"
$argsInstall.oktoremove=$true

$esxcli.software.profile.update.invoke($argsInstall)

set-vmhost -State Maintenance
Restart-VMHost -RunAsync -Confirm:$false 


$esxihosts = get-vmhost
foreach ($esxi in $esxihosts)
{
    $esxcli = $esxi |get-esxcli -v2
    $argsInstall = $esxcli.software.profile.install.createargs()
    $argsInstall.depot = "https://hostupdate.vmware.com/software/VUM/PRODUCTION/main/vmw-depot-index.xml"
    $argsInstall.profile = "ESXi-6.5.0-20171204001-standard"
    $esxcli.software.profile.install.invoke($argsInstall)
    $vms = $esxi |get-vm
    if ($vms.count -eq 0)
    {
        $esxi | set-vmhost -State Maintenance
        $esxi | Restart-VMHost -RunAsync -Confirm:$false 
    }
}
}





Function Update-ESXImageProfile ($ImageProfile, $tools){
   if ($ImageProfile.Readonly) {
      Write-Host "Your ImageProfile is read-only and therefore cannot be updated, please use a custom ImageProfile"
   } Else {
      Write "Loading online Software Depot"
      $SD = Add-EsxSoftwareDepot -DepotUrl https://hostupdate.vmware.com/software/VUM/PRODUCTION/main/vmw-depot-index.xml
      If ($tools) {
         $NEWIP = Get-EsxImageProfile -Vendor "VMware, Inc." | Sort ModifiedTime -Descending | Where { $_.Name -notlike "*tools" } | Select -First 1
      } Else {
         $NEWIP = Get-EsxImageProfile -Vendor "VMware, Inc." | Sort ModifiedTime -Descending | Where { $_.Name -like "*tools" } | Select -First 1
      }
      Write-Host "New Image Profile found called $($NEWIP.Name)..."
      Write-Host "Checking for updated packages which do not exist in $ImageProfile"     
      $Compare = Compare-EsxImageProfile -ReferenceProfile $ImageProfile -ComparisonProfile $NEWIP
      $Updates = ($Compare | Select -ExpandProperty UpgradeFromRef)
      If ($Updates) {
         Foreach ($SP in $Updates) {
            $UpdatedPackage = Get-EsxSoftwarePackage | Where {$_.Guid -eq $SP}
            Write-Host "Adding $($UpdatedPackage.Name) to $ImageProfile"
            $Add = Add-EsxSoftwarePackage -ImageProfile $ImageProfile -SoftwarePackage $UpdatedPackage
         }
      }
      $OnlyInComp = ($Compare | Select -ExpandProperty OnlyInComp)
      If ($OnlyInComp) {
         Foreach ($SP in $OnlyInComp) {
            $UpdatedPackage = Get-EsxSoftwarePackage | Where {$_.Guid -eq $SP}
            Write-Host "Adding $($UpdatedPackage.Name) to $ImageProfile"
            $Add = Add-EsxSoftwarePackage -ImageProfile $ImageProfile -SoftwarePackage $UpdatedPackage
         }
      } 
      If ((-not $OnlyInComp) -and (-not $Updates)) {
         Write-Host "No Updates found for $ImageProfile"
      }
   }
}
 
Update-ESXImageProfile -ImageProfile "CustomImageProfile" -Tools $true