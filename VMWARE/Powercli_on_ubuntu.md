
install powershell on ubuntu 16.04


curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -


curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft.list

sudo apt-get update



sudo apt-get install powershell



sudo pwsh



PS /home/redrock> Install-Module -Name VMware.PowerCLI

Untrusted repository
You are installing the modules from an untrusted repository. If you trust this
repository, change its InstallationPolicy value by running the Set-PSRepository
 cmdlet. Are you sure you want to install the modules from 'PSGallery'?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help
(default is "N"):a




+ FullyQualifiedErrorId : VMware.VimAutomation.Srm module is not currently supported on the Core edition of PowerShell.,Microsoft.PowerShell.Commands.ImportModuleCommand
오류 해결 방법

https://cloudhat.eu/powercli-10-0-0-linux-error-vmware-vimautomation-srm/

아래 파일에서 
/usr/local/share/powershell/Modules/VMware.PowerCLI/10.2.0.9372002/VMware.PowerCLI.psd1

다음 모듈 # 처리

We need to disable the incompatible modules:
 VMware.VimAutomation.Srm,
 VMware.VimAutomation.License,
 VMware.VimAutomation.vROps,
 VMware.VimAutomation.HA,
 VMware.VimAutomation.HorizonView,
 VMware.VimAutomation.PCloud,
 VMware.VimAutomation.Cloud,
 VMware.VimAutomation.DeployAutomation,
 VMware.VimAutomation.ImageBuilder,
 VMware.VimAutomation.VumAutomation.

 You need to comment each of these lines, by placing a # at the beginning of the line:

#@{“ModuleName”=”VMware.VimAutomation.Srm”;”ModuleVersion”=”10.0.0.7893900″}
#@{“ModuleName”=”VMware.VimAutomation.License”;”ModuleVersion”=”10.0.0.7893904″}
#@{“ModuleName”=”VMware.VimAutomation.vROps”;”ModuleVersion”=”10.0.0.7893921″}
#@{“ModuleName”=”VMware.VimAutomation.HA”;”ModuleVersion”=”6.5.4.7567193″}
#@{“ModuleName”=”VMware.VimAutomation.HorizonView”;”ModuleVersion”=”7.1.0.7547311″}
#@{“ModuleName”=”VMware.VimAutomation.PCloud”;”ModuleVersion”=”10.0.0.7893924″}
#@{“ModuleName”=”VMware.VimAutomation.Cloud”;”ModuleVersion”=”10.0.0.7893901″}
#@{“ModuleName”=”VMware.DeployAutomation”;”ModuleVersion”=”6.5.2.7812840″}
#@{“ModuleName”=”VMware.ImageBuilder”;”ModuleVersion”=”6.5.2.7812840″}
#@{“ModuleName”=”VMware.VumAutomation”;”ModuleVersion”=”6.5.1.7862888″}

