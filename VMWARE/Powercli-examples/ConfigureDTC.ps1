#--------------------------------------------------------------
#
# Name : ConfigureDTC.ps1
# Creator : Redrock (Hong seok, Kang)
# Date : 2019.07.06
# Description: install DTC and configure DTC security option
#   - prerequisites : configure WINRM with HTTPS                     
#                    
# Language : Powershell
#
#--------------------------------------------------------------


$osUser = "myadmin"
$osSecPasswd = ConvertTo-SecureString "mypassword" -AsPlainText -Force
$osCred = New-Object System.Management.Automation.PSCredential( $osUser, $osSecPasswd )

$so = New-PSSessionOption -SkipCACheck -SkipCNCheck

$sess = New-PSSession -ComputerName $targetComputer -Credential $osCred -UseSSL -SessionOption $so

Invoke-Command "Install-Dtc -StartType AutoStart" -SessionName $sess -SessionOption $so


Invoke-Command "Start-Service -name MSDTC" -SessionName $sess -SessionOption $so 

Invoke-Command "Set-DtcNetworkSetting -DtcName local -AuthenticationLevel:Mutual -RemoteClientAccessEnabled:$true -InboundTransactionsEnabled:$true -OutboundTransactionsEnabled:$true" -SessionName $sess -SessionOption $so

Invoke-Command "Get-DtcNetworkSetting -DtcName local" -SessionName $sess -SessionOption $so

