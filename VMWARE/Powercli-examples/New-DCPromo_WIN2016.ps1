#--------------------------------------------------------------
#
# Name : New-DCPromo_WIN2016.ps1
# Creator : Redrock (Hong seok, Kang)
# Date : 2019.07.06
# Description: DC PROMO  in WIndows 2016                   
#                    
# Language : Powershell
#
#--------------------------------------------------------------

#PDC
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

Import-Module ADDSDeployment

Install-ADDSForest -CreateDnsDelegation:$false -DomainMode winThreshold -DomainName "mydomain.com" -DomainNetbiosName "mydomain" -ForestMode winThreshold -InstallDns:$true -NoRebootOnCompletion:$false -Force:$true

Get-Service adws, kdc, netlogon, dns
Get-SmbShare
Get-EventLog "Directory Service" | select entrytype, source, eventid, message
Get-EventLog "Active Directory Web Services" | select entrytype, source, eventid, message

#2nd DC

# Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Install-ADDSDomainController -DomainName "mydomain.com" -credential (Get-Credential) -CreateDnsDelegation:$false -InstallDns:$true


