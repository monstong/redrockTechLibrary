# **Redrock's Meetup : Powercli Basic**

## **1. What is Powercli**

 > VMware PowerCLI is a command-line and scripting tool built on Windows PowerShell, and provides more than 600 cmdlets for managing and automating vSphere, vCloud, vRealize Operations Manager, vSAN, NSX-T, VMware Cloud on AWS, and VMware Horizon environments.

 - Powershell 기반 CLI / Scripting 도구로, vsphere뿐 아니라 다양항 VMware Product 들을 자동화할 수 있게 해줍니다.
 - Powershell 기반이다 보니 Powershell에 대한 기본적인 지식이 있어야 합니다.

## **2. How to Install Powercli**

- Powercli download 페이지에서 버전별로 다운로드 가능하며, 다음의 2가지 방식으로 설치됩니다.

    * Snapin 방식 Install ( 6.5 R1 버전이하 ) : Powercli를 사용하기 위한 powershell snapin방식 파일로 설치 모든항목이 다 들어 있어 무겁고 별도로 Powershell과 별도로 수행 필요합니다.

    * PS Module 방식 Install (6.5.1 버전이상) : Powershell의 Module 로써 설치가능하며, 일반적으로 PSGallery에서 다운로드(Install-Module) 및 설치(Import-Module) 가능, 필요 Module만 Import하여 사용가능하며, Powershell 콘솔로 바로 사용 가능합니다.

    > VMWARE Powercli 11.1.0 Download Link : https://code.vmware.com/web/tool/11.1.0/vmware-powercli

- Pre-requisites (버전마다 조금씩 차이가 있으며, 본 문서에서는 11.1.0 기준입니다.)

    * Check the Compatibility Matrix and Upgrade Powershell version as needed
        | Category | OS Type | 64 bit |
        |-----|-----|-----|
        | Local OS Support | Server | Windows Server 2016, Windows Server 2012 R2, Windows Server 2008 R2 SP1 |
        | Local OS Support | Workstation | Windows 10, Windows 7 SP1, Ubuntu 16.04, macOS 10.12 |
        | Guest OS Support | Server | Windows Server 2016, Red Hat Enterprise Linux 7.4 <br/> NOTE: Guest cmdlets are not compatible with IPv6 environments. |

        | OS Type |	.NET Version | PowerShell Version |
        |-----|-----|-----|
        | Windows | .NET Framework 4.5, 4.5.x, 4.6, 4.6.x or 4.7.x | Windows PowerShell 3.0, 4.0, 5.0, or 5.1 |
        | Ubuntu | .NET Core 2.0 | PowerShell Core 6.1 |
        | macOS | .NET Core 2.0 | PowerShell Core 6.1 |

 - Snapin 방식 설치는 Download한 설치파일을 실행하여 설치를 진행하면 되고, Module 방식 설치는 다음과 같이 수행합니다.

    * VMware.Powercli 모듈이 있는지 검색, 등록된 Repository 또는 PS Gallery를 검색하여 보여줍니다.
        ```powershell
        PS> Find-Module -Name VMware.Powercli

        Version    Name                                Repository           Description
        -------    ----                                ----------           -----------
        11.2.0.... VMware.PowerCLI                     PSGallery            This Windows PowerShell module contains VMware.P...

        ```
    * Powercli 모듈을 PSgallery로부터 다운로드 합니다. 인터넷이 막혀있는경우 다운로드 페이지에서 모듈만 직접 다운로드하여 Private 서버에 위치 시켜도 됩니다.
        ```powershell
        PS> Install-Module -Name VMware.Powercli
        A {Enter}

        (또는 Download page에서 Module zip 파일 직접 다운로드후 Powershell Module Path내 압축 해제합니다.)

        PS> $env:PSModulePath
        C:\Users\kuhel\Documents\WindowsPowerShell\Modules;C:\Program Files\WindowsPowerShell\Modules;C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules
        => 위 예시에서 전체 유저가 사용가능하게 하기 위해 모듈 Path중 C:\Program Files\WindowsPowerShell\Modules경로에 아래와 같이 위치하도록 압축을 해제합니다.

        PS> ls 'C:\Program Files\WindowsPowerShell\Modules\'

            디렉터리: C:\Program Files\WindowsPowerShell\Modules

        Mode                LastWriteTime         Length Name
        ----                -------------         ------ ----
        d-----     2018-04-12   오전 8:38                Microsoft.PowerShell.Operation.Validation
        d-----     2018-08-10   오후 9:15                VMware.PowerCLI
        d-----     2018-08-10   오후 9:13                VMware.Vim
        d-----     2018-08-10   오후 9:14                VMware.VimAutomation.Cis.Core
        d-----     2018-08-10   오후 9:14                VMware.VimAutomation.Cloud
        d-----     2018-08-10   오후 9:13                VMware.VimAutomation.Common
        ...중략...
        d-----     2018-08-10   오후 9:14                VMware.VimAutomation.StorageUtility
        d-----     2018-08-10   오후 9:14                VMware.VimAutomation.Vds
        d-----     2018-08-10   오후 9:14                VMware.VimAutomation.Vmc
        d-----     2018-08-10   오후 9:14                VMware.VimAutomation.vROps
        d-----     2018-08-10   오후 9:14                VMware.VumAutomation
        ```

    * VMware.PowerCLI Module을 Import합니다. 해당 모듈이 대표 Module로 연관된 나머지 모듈까지 Import합니다.
        ```powershell
        PS> Import-Module -Name VMware.Powercli
        A {Enter}

        ```
    * Powercli를 사용하기 위한 ExecutionPolicy 설정과 기본적인 Powercli 동작 관련 설정을 지정합니다.
        ```powershell 
        PS> Get-ExecutionPolicy
        RemoteSigned
        PS> Set-ExecutionPolicy RemoteSigned

        PS> Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -ParticipateInCeip:$false
        ```

## **3. Connecting to vcenter or ESXi Host**

 - Setting LAB environment : 들어가기 전에 LAB 환경을 접속해 봅시다. 본 문서에서는 VMware 에서 무료로 제공하는 Vmware HOL(hand on lab) 을 LAB 환경으로 사용 권고합니다. 장점중 하나는 LAB에서 제공하는 시나리오를 꼭 따라하지 않아도 되고, 몇번이고 재수강이 가능하다는 점입니다.

    1. VMware HOL 사이트 접속 (필요시 계정 생성 ) : https://labs.hol.vmware.com 접속하여 계정이 없을경우 간단하게 가입후 접속합니다.

    1. Powercli 관련 LAB 검색 : 검색창에 `Powercli`로 검색시 **`HOL-1911-05-SDC - VMware vSphere Automation - PowerCLI`** Lab 과정이 나오면 <kbd>ENROLL</kdb> 을 선택합니다.

    1. Lab detail을 확인하시고 `START THIS LAB`을 선택하면 환경 점검 메뉴가 나옵니다. `RUN TEST`후 `START LAB`을 선택하면 LAB 화면에 접속됩니다.

    1. 가상 Windows 환경에서 Chrome 웹브라우저를 수행하면 기본적인 기구성된 vsphere 환경과 관련된 URL들이 등록되어 있는 걸 확인할 수 있습니다.

 - vCenter/ESXi host 접속 : `Connect-VIServer` cmdlet을 사용해 Vcenter server 또는 ESXi host에 접속할 수 있습니다. 이때 powershell의 기본적인 Credential 객체를 이용하거나 직접 ID/PASSWORD를 입력하는 2가지 방식을 모두 사용할 수 있습니다.

    ```powershell
    PS> Connect-VIServer -Server {vcenter or esxi host ip} -Credential (Get-Credential)

    PS> Connect-VIServer {vcenter or esxi host ip} -User root -Password {your Password}

    Name                           Port  User
    ----                           ----  ----
    {vcenter or esxi host ip}      443   root
    ```
 - vCenter/ESXi host 접속 해제 : `Disconnect-VIServer` cmdlet 을 사용해 접속한 vcenter server 또는 ESXi host에서 빠져나올 수 있습니다. 이때 -Server 파라미터에  해당 서버명을 명시해 주는게 좋습니다.
    ```powershell
    PS> Disconnect-VIServer -Server {vcenter or esxi host ip}
    또는
    PS> Disconnect-VIServer -Server {vcenter or esxi host ip} -Confirm:$false
    ```
 - Basic Syntax of Powercli cmdlet
    * Verb-Noun : [동사]-[명사] 형태로 되어 있어 사용하고자 하는 cmdlet을 직관적으로 이해할 수 있습니다.
        * 예1) Get-VM : VM의 정보를 보여준다.
        * 예2) Set-VirtualPortGroup : Portgroup 의 속성을 설정한다.
        * 예3) New-Datacenter : Datacenter 객체를 생성한다.

 - Use Debugging Parameter : 각 Cmdlet은 기본적으로 아래의 Debugging용 Parameter를 가지고 있습니다. 보다 안전한 코드를 위해 또는 불필요 Warning 메세지 Skip을 위해 Debugging용 Parameter를 사용하는 걸 개인적으로 권고합니다.
    ```powershell
    PS> Connect-VIServer -Server 192.168.200.170 -Credential (Get-Credential) -WarningAction:SilentlyContinue
    => 해당 cmdlet 수행에 warning 발생시 silent하게 다음 step으로 진행합니다.
    
    PS> New-Folder -Location (Get-Folder -NoRecursion) -Name Test -ErrorAction:Stop
    => 해당 cmdlet 수행에 error발생시 해당 step에서 stop을 하게 됩니다. 더이상 진행되지 않습니다.
    ```
 - Use WhatIF(Preview) Parameter : Cmdlet에 기본적으로 정의된 Whatif Parameter를 사용시 해당 명령어가 실제 수행되지 않고 예상 결과만 출력해 줍니다. 스크립트 테스트시 유용하게 사용할 수 있습니다. (whatif가 정의된 Cmdlet 또는 Function 에서만 사용가능합니다. 확인 Get-Help나 Tab을 이용해 봅시다.) 
    ```powershell
    PS> > New-Datacenter -Location (Get-Folder -NoRecursion) -Name TESTDC -WhatIf
    WhatIf: 대상 "root datacenter"에서 "New datacenter." 작업을 수행합니다.
    ```
 - 물론 If/Else statement 문을 통해 개별 명령어별 검증하는 로직을 추가해 주거나 Try/catch 등 Exception Handling 형태로 코드를 작성하는 것도 더 좋은 방법입니다.

## **4. Getting information**

- 몇가지 자주 사용할 수 있는 Get- cmdlet 사용 예를 보겠습니다.
    ```powershell
    PS> Get-VM
    PS> Get-VMHost
    PS> Get-Datacenter
    PS> Get-Folder
    PS> Get-VirtualSwitch
    PS> Get-VirtualPortgroup
    PS> Get-Datastore
    PS> Get-Cluster

    (전체 항목 보기)
    PS> Get-VMHost | select *
    
    (Vswitch별로 Security 정책 보기)
    PS> Get-VirtualSwitch | Get-SecurityPolicy   => VSS
    PS> Get-VDSwitch | Get-VDSecurityPolicy      => VDS
    ```

- Get-view를 사용한다면 어떨까?
    * Get-View cmdlet : 기존의 Get-Cmdlet 보다 Advanced feature로 좀 더 빠르고, 유연하게 상세한 정보를 확인할 수 있습니다.
    (https://blogs.vmware.com/PowerCLI/2015/02/get-view-part-1-introduction.html)

    * Get-VM vs Get-View
        ```powershell
        PS> Get-VM -name {VM name}

        PS> Get-View -Viewtype VirtualMachine -filter @{Name='{VM name}'}
        
        (same as Get-VM)
        PS> $myvm = Get-VM -name {VM name}
        PS> $myvm.ExtensionData

        (Get-View 활용)
        PS> $VM = Get-View -Viewtype VirtualMachine -filter @{Name='{VM name}'}
        PS> $VM.Summary.Guest
        PS> $VM.Summary.Runtime
        PS> $VM.Summary.Config

        ```
    * Get-VMHost vs Get-View (속도 비교)
        ```powershell
        PS> Measure-Command { Get-VMHost | select * }
        경고: The 'State' property of VMHost type is deprecated. Use the 'ConnectionState' property instead.
        경고: PowerCLI scripts should not use the 'DatastoreIdList' property of VMHost type. The property will be removed in a
        future release.


        Days              : 0
        Hours             : 0
        Minutes           : 0
        Seconds           : 3
        Milliseconds      : 416
        Ticks             : 34169325
        TotalDays         : 3.95478298611111E-05
        TotalHours        : 0.000949147916666667
        TotalMinutes      : 0.056948875
        TotalSeconds      : 3.4169325
        TotalMilliseconds : 3416.9325

        PS> Measure-Command { Get-View -ViewType HostSystem }

        Days              : 0
        Hours             : 0
        Minutes           : 0
        Seconds           : 0
        Milliseconds      : 281
        Ticks             : 2815191
        TotalDays         : 3.25832291666667E-06
        TotalHours        : 7.819975E-05
        TotalMinutes      : 0.004691985
        TotalSeconds      : 0.2815191
        TotalMilliseconds : 281.5191
        ```

## **5. Set-Cmdlet example (Lab)

 - Configuring some advanced settings for multiple VMs : VM별 보안권고 설정을 확인 및 변경해 봅시다.
    > 보안 권고 Advanced setting : 
    log.keeepOld = 20 
    log.rotateSize = 2097152
    isolation.device.connectable.disable = TRUE 
    isolation.device.edit.disable = TRUE


    * 설정 변경은 Get-VM 으로만 하면 모든 VM이 선택되어 현재 Poweron 된 VM들은 변경 실패할 수 있습니다.
    ```powershell
    (설정 확인)
    $VMs =  Get-VM | Where-Object {$_.PowerState -eq 'PoweredOff'}
    ForEach ($VM in $VMs)
    { 
        $VM.name
        Get-VM $VM.Name | Get-AdvancedSetting isolation.device.connectable.disable
        Get-VM $VM.Name | Get-AdvancedSetting isolation.device.edit.disable
        Get-VM $VM.Name | Get-AdvancedSetting log.keepOld
        Get-VM $VM.Name | Get-AdvancedSetting log.rotateSize
    }

    (설정 변경)
    $VMs =  Get-VM | Where-Object {$_.PowerState -eq 'PoweredOff'}
    ForEach ($VM in $VMs)
    { 
    $VM.name
        Get-VM $VM.Name | New-AdvancedSetting -Name "isolation.device.connectable.disable" -value "TRUE" -Confirm:$false -Force:$True 
        Get-VM $VM.Name | New-AdvancedSetting -Name "isolation.device.edit.disable" -value "TRUE" -Confirm:$false -Force:$True 
        Get-VM $VM.Name | New-AdvancedSetting -Name "log.keepOld" -value "20" -Confirm:$false -Force:$True 
        Get-VM $VM.Name | New-AdvancedSetting -Name "log.rotatesize" -value "2097152" -Confirm:$false -Force:$True 
    }
    ```

 - Configuring SecurityPolicy for Virtualswitch (VDS) : VirtualSwitch별 보안권고 설정을 변경해 봅시다.
    > 보안권고 Virtualswitch Security Policy
    ForgedTransmits = reject
    MacChanges = reject

    ```powershell
    (VDS 확인)
    PS> Get-VDSwitch
    (VDS설정 확인)
    PS> Get-VDSwitch {Your VDS} | Get-VDSecurityPolicy

    (vDS설정 변경)
    PS> Get-VDSwitch {Your VDS} | Get-VDSecurityPolicy | Set-VDSecurityPolicy -ForgedTransmits $false -MacChanges $false
    => 변경된 설정을 WEb client에서도 확인해 봅시다.
    ```
 - Create new VM Kernel adapter
    ```powershell
    (현재 설정 확인)
    PS> Get-VMHostNetworkAdapter
    PS> Get-VDSwitch
    PS> Get-VDPortgroup

    (신규 VSAN VMK 추가)
    PS> Foreach ( $vmhost in Get-VMHost | select -last 1){
        $VDS = Get-VDSwitch
        $NEWPG = $VDS | New-VDPortgroup -Name "VSAN"

        $NEWVMK = New-VMHostNetworkAdapter -PortGroup $NEWPG -VirtualSwitch $VDS -VMHost $vmhost -VsanTrafficEnabled -IP 10.10.50.41 -SubnetMask 255.255.255.0

    }

    (생성 확인 Powercli및 Web client)
    PS> Get-VMHostNetworkAdapter
    PS> Get-VDSwitch
    PS> Get-VDPortgroup
    ```

## **6. Sample scenario : Automatic provisioning VM hosts with vcenter**

- PXE install
https://xenappblog.com/2018/automatically-install-vmware-esxi-6-7/

- Deploy vcsa
http://www.brianjgraf.com/2015/03/16/deploy-vcenter-server-6-vcsa6-powercli/

- Connect vCenter
- Create Datacenter 
- Add Hosts
- Configure Network
- Configure VMKernel adapter
- Configure Datastore
- Create Cluster
- Move host


## **Appendix. Useful References Links

| Web site | URL |
|-----|-----|
|Yellow-Bricks Blog | http://www.yellow-bricks.com/ |
| VMware PowerCLI Blog:  | https://blogs.vmware.com/PowerCLI/ |
| VMware PowerCLI - User's Guide: | https://vdc-download.vmware.com/vmwb-repository/dcr-public/038f9053-d131-4b05-8e7c-c53cb5f02de6/5d6d9aec-66fc-4b83-8d8c-8a07a3f24f20/vmware-powercli-101-user-guide.pdf |
| VMware PowerCLI - Cmdlet Reference Guide: | https://code.vmware.com/docs/6702/cmdlet-reference |
| VMware PowerCLI - GitHub Example Scripts:  | https://github.com/vmware/PowerCLI-Example-Scripts |
