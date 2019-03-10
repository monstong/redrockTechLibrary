# **Redrock's Meetup : Powershell Basic**

## **1. What is Powershell**

> Windows PowerShell은 시스템 관리자를 위해 특별히 설계된 Windows 명령줄 셸

-  .NET Framework CLR(공용 언어 런타임) 및 .NET Framework를 기반으로 하며 .NET Framework 개체를 사용하고 반환
- cmdlet - Shell에서 제공하는 단일함수 명령줄 도구 -  을 사용하여 작업 수행 (Predefind / User-Custom 모두 가능)

## **2. Powershell vs Shell script**

Powershell은 다른 Shell script - Unix/Linux 기반의 bash script 이거나, Windows 기존에 조재한 Visual Basic script - 와는 달리 작업을 수행한 결과가 단순한 Text가 아니라, 객체(.net framework 객체) 그자체라는 점이 가장 큰 차이점입니다.

- Powershell 서비스 확인 예시
    ```Powershell
    PS C:\WINDOWS\system32> $w32tmSvc = Get-Service -Name W32Time
    PS C:\WINDOWS\system32> $w32tmSvc

    Status   Name               DisplayName
    ------   ----               -----------
    Running  W32Time            Windows Time


    PS C:\WINDOWS\system32> $w32tmSvc | Stop-Service
    PS C:\WINDOWS\system32> $w32tmSvc

    Status   Name               DisplayName
    ------   ----               -----------
    Stopped  W32Time            Windows Time
    ```

- Bash on Centos 7 서비스 확인 예시 
    ```bash
    [root@centos01 ~]# PGSVC=`systemctl status postgresql-11`
    [root@centos01 ~]# echo $PGSVC
    postgresql-11.service - PostgreSQL 11 database server Loaded: loaded (/usr/lib/systemd/system/postgresql-11.service; enabled; vendor preset: disabled) Active: active (running) since Sat 2019-03-09 01:11:08 EST; 4h 55min ago Docs: https://www.postgresql.org/docs/11/static/ Main PID: 1097 (postmaster) CGroup: /system.slice/postgresql-11.service ├─1097 /usr/pgsql-11/bin/postmaster -D /var/lib/pgsql/11/data/ ├─1151 postgres: logger ├─1287 postgres: checkpointer ├─1288 postgres: background writer ├─1290 postgres: walwriter ├─1291 postgres: autovacuum launcher ├─1292 postgres: stats collector └─1294 postgres: logical replication launcher Mar 09 01:11:07 centos01 systemd[1]: Starting PostgreSQL 11 database server
    ...후략...
    ```

## **3, Basic Syntax and ISE**

- Use Tab key : 기본적으로 Powershell command 창에서 <kbd>Tab</kbd> 키를 이용한 자동완성을 지원합니다. comdlet이 잘 기억나지 않을 때 많이 사용합니다.

- Use recommended version : Windows 2008R2/Windows7 이상에서는 기본적으로 Powershell 설치가 되어 있으나, 잘(?) 사용하기 위해서는 Windows2012R2/Windows 8.1에 기본으로 깔려있는 Powershell 버전을 사용하기를 권고합니다. Powershell 버전이 낮을 경우 Powercli가 지원이 되지 않으며, Powershell 버전 업을 위해서는 Windows management Pack(이중에 Powershell이 포함되어 있음) 과 그에 대응하는 .Net Framework 업데이트가 필요합니다.

    ```powershell
    PS C:\WINDOWS\system32> $psver
    PS C:\WINDOWS\system32> $PSVersionTable

    Name                           Value
    ----                           -----
    PSVersion                      5.1.17134.590
    PSEdition                      Desktop
    PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}
    BuildVersion                   10.0.17134.590
    CLRVersion                     4.0.30319.42000
    WSManStackVersion              3.0
    PSRemotingProtocolVersion      2.3
    SerializationVersion           1.1.0.1


    PS C:\WINDOWS\system32>
    ```

- Use `Get-Command` and `Get-Help` : 명령어가 아예 생각이 나지 않을때나 특정 명령어의 사용법이 궁금할 때 사용해 봅시다.

    ```powrshell
    PS C:\Program Files> Get-Command | select  -last 5

    CommandType     Name                                               Version    Source
    -----------     ----                                               -------    ------
    Cmdlet          Write-Information                                  3.1.0.0    Microsoft.PowerShell.Utility
    Cmdlet          Write-Output                                       3.1.0.0    Microsoft.PowerShell.Utility
    Cmdlet          Write-Progress                                     3.1.0.0    Microsoft.PowerShell.Utility
    Cmdlet          Write-Verbose                                      3.1.0.0    Microsoft.PowerShell.Utility
    Cmdlet          Write-Warning                                      3.1.0.0    Microsoft.PowerShell.Utility


    PS C:\Program Files> get-help Write-Output

    이름
        Write-Output

    구문
        Write-Output [-InputObject] <psobject[]>  [<CommonParameters>]


    별칭
        write
        echo


    설명
        Get-Help가 이 컴퓨터에서 이 cmdlet에 대한 도움말 파일을 찾을 수 없습니다. 일부 도움말만 표시합니다.
            -- 이 cmdlet을 포함하는 모듈에 대한 도움말 파일을 다운로드하여 설치하려면 Update-Help를 사용하십시오.
            -- 이 cmdlet에 대한 도움말 항목을 온라인으로 보려면 "Get-Help Write-Output -Online"을 입력하거나
            https://go.microsoft.com/fwlink/?LinkID=113427(으)로 이동하십시오.

    ```
- Use Powershell ISE : Powershell이 설치되어 있는 경우 기본적으로 Powershell ISE 라고 하는 Powershell 전용의 IDE(통합 개발 환경 - Eclipse나 Visual studio같은) 을 제공합니다.
코딩 작성시 자동 들여쓰기, help, 자동 완성 기능과  디버깅 기능을 제공합니다.

   > 시작 버튼 > Windows Powershell > Windows Powershell ISE 선택

    | 주요 기능 | 해당 키 |
    |-----|-----|
    | 스크립트 실행/계속 | <kbd>F5</kbd> |
    | 디버거 중지 | <kbd>shift</kbd> + <kbd>F5</kbd> |
    | 중단점(Breakpoint) 설정/해제 | <kbd>F9</kbd> |
    | 프로시저 단위 시행 | <kbd>F10</kbd> |
    | 한단계씩 실행 | <kbd> F11 </kbd> |
    | 프로시저 나가기 | <kbd> Shift </kbd> + <kbd> F11 </kbd> |

- UNIx/Linux shell compatible command : ls , cd , echo 등 shell script에 익숙한 유저를 위한 alias 로 몇가지 기본 OS 명령들이 동작합니다.
    * 이외에도 긴이름의 cmdlet 을 별칭으로 줄인 경우도 있습니다.
      (예: gwmi = Get-WmiObject)
    ```
    PS C:\Program Files> Get-Help ls

    이름
        Get-ChildItem

    구문
        Get-ChildItem [[-Path] <string[]>] [[-Filter] <string>]  [<CommonParameters>]

        Get-ChildItem [[-Filter] <string>]  [<CommonParameters>]


    별칭
        gci
        ls
        dir
    ... 후략 ...
    ```

- Differenct Variable notation from Windows classic CLI : Powershell에서의 변수는 $로 시작합니다. 기존의 classic command line에서 %varname% 로 표현되던 것과 차이점이 있습니다.

- Cmdlet Naming Pattern 
    * Get-Something : 특정 또는 전체 해당 객체의 정보를 보여줌
    * Set-Something : 특정 또는 전체 해당 객체의 속성을 수정함
    * New-/Remove-Something : 신규 객체를 생성하거나/제거함
    * Start/Stop-Something : 특정 객체를 시작/중지 함

- Basic Get Cmdlet usage pattern 
    * Get-Something / Select-object 조합
        ```powershell
        PS C:\Program Files> Get-Service | Select-Object Name, Status

        Name                                      Status
        ----                                      ------
        AdobeARMservice                          Running
        AdobeFlashPlayerUpdateSvc                Stopped
        AJRouter                                 Stopped
        ALG                                      Stopped
        ...후략...
        ```
    
    * Get-Something / Select-object /Where-object 조합
        ```powershell
        PS C:\Program Files> Get-Service | Select-Object Name, Status | Where-Object { $_.Name -like 'Web*'}

        Name                 Status
        ----                 ------
        WebClient           Stopped
        WebConferenceProVDI Running


        PS C:\Program Files> Get-Service | Select-Object Name, Status | Where-Object { $_.Name -eq 'winrm'}

        Name   Status
        ----   ------
        WinRM Stopped


        PS C:\Program Files> Get-Service | Select-Object Name, Status | Where-Object { $_.Status -eq 'Stopped'}

        Name                                      Status
        ----                                      ------
        AdobeFlashPlayerUpdateSvc                Stopped
        AJRouter                                 Stopped
        ALG                                      Stopped
        ALMountService                           Stopped
        AppIDSvc                                 Stopped
        AppMgmt                                  Stopped
        AppReadiness                             Stopped
        AppVClient                               Stopped
        AppXSvc                                  Stopped
        ...후략...
        ```

    * Get-Something with argument / Format-list 조합
        ```powershell
        PS C:\Program Files> Get-Service | select -last 1

        Status   Name               DisplayName
        ------   ----               -----------
        Running  ZeroConfigService  Intel(R) PROSet/Wireless Zero Confi...


        PS C:\Program Files> Get-Service | select -last 3 | Format-Table displayname, name, status -AutoSize

        DisplayName                                         Name               Status
        -----------                                         ----               ------
        Xbox Accessory Management Service                   XboxGipSvc        Stopped
        Xbox Live 네트워킹 서비스                           XboxNetApiSvc     Stopped
        Intel(R) PROSet/Wireless Zero Configuration Service ZeroConfigService Running
        ```

- Flow control statement : 자주 사용하는 제어 구문을 살펴보겠습니다. 가장 많이(?) 쓰이는 If/else 구문과 For loop의 일종인 foreach 구문입니다.

    * IF/Else statement

        ```powershell
        PS C:\Program Files> Get-Process  | Where-Object {$_.ProcessName -eq 'iexplore'}

        Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
        -------  ------    -----      -----     ------     --  -- -----------
        1228     121    62372      88628       9.78  11088   1 iexplore
        464      62    16832      16428       0.78  14268   1 iexplore
        782      90    26420      40372       4.92  15768   1 iexplore


        PS C:\Program Files> $procIE = Get-Process  | Where-Object {$_.ProcessName -eq 'iexplore'}
        PS C:\Program Files> $procIE.Count
        3

        PS C:\Program Files> if ( $procIE.Count -ge 1) {
        Write-Host "IE Process normal!" -ForegroundColor Green
        } else {
        Write-Warning "IE Process down!"
        }
        IE Process normal!
        PS C:\Program Files> if ( $procIE.Count -ge 1) {
        Write-Host "IE Process normal!" -ForegroundColor Green
        } else {
        Write-Warning "IE Process down!"
        }
        IE Process normal!
        PS C:\Program Files> $procIE = Get-Process  | Where-Object {$_.ProcessName -eq 'iexplore'}
        PS C:\Program Files> if ( $procIE.Count -ge 1) {
        Write-Host "IE Process normal!" -ForegroundColor Green
        } else {
        Write-Warning "IE Process down!"
        }
        경고: IE Process down!
        ```

    * Foreach statement

        ```powershell
        PS C:\Program Files> Get-ChildItem -path c:\windows  | where { $_.Extension -eq '.log'}


            디렉터리: C:\windows


        Mode                LastWriteTime         Length Name
        ----                -------------         ------ ----
        -a----     2018-03-11   오후 7:28         123490 AhnInst.log
        -a----     2018-05-25   오후 4:44          14767 comsetup.log
        -a----     2018-05-25   오전 8:02           2526 DDACLSys.log
        -a----     2018-12-22   오후 2:36          16748 DPINST.LOG
        -a----     2018-05-25   오후 4:40           4179 DtcInstall.log
        -a----     2019-02-22  오전 10:12         186472 PFRO.log
        -a----     2018-10-16   오후 1:06              0 setuperr.log
        -a----     2019-03-09   오후 3:07            276 WindowsUpdate.log


        PS C:\Program Files> $logfiles = Get-ChildItem -path c:\windows  | where { $_.Extension -eq '.log'}
        PS C:\Program Files>  foreach ( $log in $logfiles) {
        >>  $sizeKb =[System.Math]::Round($log.length/1024,2)
        >> write-host $log.name, $sizeKb
        >> }
        AhnInst.log 120.6
        comsetup.log 14.42
        DDACLSys.log 2.47
        DPINST.LOG 16.36
        DtcInstall.log 4.08
        PFRO.log 182.1
        setuperr.log 0
        WindowsUpdate.log 0.27

        ```

## **4. Powershell with WMI**
대부분 Powershell 내장 cmdlet으로 Windows시스템 정보를 조회할 수 있지만, 좀 더 자세한 정보를 조회하고 싶을때는 Powershell도 동일하게 WMI Object를 직접 조회해야 합니다. (레지스트리키도 마찬가지로 조회가능)

아래 예시는 NIC card별 IP가 설정된 리스트들만 Win32_NetworkAdapterConfiguration WMI object로 조회하여 결과를 HTML포맷으로 출력 및 파일 저장한 케이스입니다.

```powershell
PS C:\> (Get-WmiObject -Class Win32_NetworkAdapterConfiguration).Where{$_.IPAddress}|Format-List


DHCPEnabled      : False
IPAddress        : {192.168.200.1, fe80::10f1:b4c1:ccac:a507}
DefaultIPGateway :
DNSDomain        :
ServiceName      : VBoxNetAdp
Description      : VirtualBox Host-Only Ethernet Adapter
Index            : 1

DHCPEnabled      : True
IPAddress        : {172.30.1.35, fe80::8132:ffde:7b4b:49ff}
DefaultIPGateway : {172.30.1.254}
DNSDomain        :
ServiceName      : Netwtw04
Description      : Intel(R) Dual Band Wireless-AC 8265
Index            : 2

DHCPEnabled      : True
IPAddress        : {192.168.50.1, fe80::cd19:a7a8:a3ba:b975}
DefaultIPGateway :
DNSDomain        :
ServiceName      : VMnetAdapter
Description      : VMware Virtual Ethernet Adapter for VMnet1
Index            : 18

DHCPEnabled      : True
IPAddress        : {192.168.75.1, fe80::45e5:b268:953a:80e9}
DefaultIPGateway :
DNSDomain        :
ServiceName      : VMnetAdapter
Description      : VMware Virtual Ethernet Adapter for VMnet8
Index            : 19



PS C:\> (Get-WmiObject -Class Win32_NetworkAdapterConfiguration).Where{$_.IPAddress}|Format-Table -AutoSize

DHCPEnabled IPAddress                                  DefaultIPGateway DNSDomain ServiceName  Description
----------- ---------                                  ---------------- --------- -----------  -----------
      False {192.168.200.1, fe80::10f1:b4c1:ccac:a507}                            VBoxNetAdp   VirtualBox Host-Only ...
       True {172.30.1.35, fe80::8132:ffde:7b4b:49ff}   {172.30.1.254}             Netwtw04     Intel(R) Dual Band Wi...
       True {192.168.50.1, fe80::cd19:a7a8:a3ba:b975}                             VMnetAdapter VMware Virtual Ethern...
       True {192.168.75.1, fe80::45e5:b268:953a:80e9}                             VMnetAdapter VMware Virtual Ethern...


PS C:\> (Get-WmiObject -Class Win32_NetworkAdapterConfiguration).Where{$_.IPAddress}|Format-Table -AutoSize| ConvertTo-H
tml
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>HTML TABLE</title>
</head><body>
<table>
<colgroup><col/><col/><col/><col/><col/><col/></colgroup>
<tr><th>ClassId2e4f51ef21dd47e99d3c952918aff9cd</th><th>pageHeaderEntry</th><th>pageFooterEntry</th><th>autosizeInfo</th><th>shapeInfo</th><th>groupingEntry</th></tr>
<tr><td>033ecb2bc07a4d43b5ef94ed5a35d280</td><td></td><td></td><td>Microsoft.PowerShell.Commands.Internal.Format.AutosizeInfo</td><td>Microsoft.PowerShell.Commands.Internal.Format.TableHeaderInfo</td><td></td></tr>
<tr><td>9e210fe47d09416682b841769c78b8a3</td><td></td><td></td><td></td><td></td><td></td></tr>
<tr><td>27c87ef9bbda4f709f6b4002fa4af63c</td><td></td><td></td><td></td><td></td><td></td></tr>
<tr><td>27c87ef9bbda4f709f6b4002fa4af63c</td><td></td><td></td><td></td><td></td><td></td></tr>
<tr><td>27c87ef9bbda4f709f6b4002fa4af63c</td><td></td><td></td><td></td><td></td><td></td></tr>
<tr><td>27c87ef9bbda4f709f6b4002fa4af63c</td><td></td><td></td><td></td><td></td><td></td></tr>
<tr><td>4ec4f0187cb04f4cb6973460dfe252df</td><td></td><td></td><td></td><td></td><td></td></tr>
<tr><td>cf522b78d86c486691226b40aa69e95c</td><td></td><td></td><td></td><td></td><td></td></tr>
</table>
</body></html>
PS C:\> (Get-WmiObject -Class Win32_NetworkAdapterConfiguration).Where{$_.IPAddress}|Format-Table -AutoSize| ConvertTo-H
tml | Out-File ips.html

```

## **5. Powershell with WinRM**

- Configuring WinRM on Target Server : 가장 쉽게 WinRM을 Powershell에서 설정하는 방법이나, 개인적으로 권고하진 않습니다. WinRM 설정은 별도로 보안 설정에 맞게 하는 게 좋습니다.

    ```Powershell
    PS> Enable-PSRemoting -Force
    PS> Set-Item wsman:\localhost\client\trustedhosts *
    PS> Restart-Service WinRM
    ```

- About Credential : Remote Server로 접속시 필요한 접속 정보를 Powershell에서는 Credential이란 객체로 생성하여 관리할 수 있습니다. 
    * User/Password 직접 입력 방식
    * Get-credential 호출 방식
    * 별도의 Credential을 생성하여 변수에 저장 방식
    * 생성한 credential을 XML 파일로 저장 방식

- 위의 4가지 방식중 하나의 접속정보를 이용하여 아래 2가지 방식 중 하나로 Remote 서버로 접속 및 원하는 명령을 수행할 수 있습니다.

- using Enter-PSSession 
- using invoke-command


## **6. Simple LAB : Monitoring/Event Logging**

- 2가지 방식 중 선택(본Lab에서는 2번째 방식으로 수행함)
    * 중계 서버에서 WinRM을 통하여 주기적으로 여러 대상 서버로 모니터링 스크립트 수행 
    * 각 대상 서버내 모니터링 스크립트를 주기적으로 수행

- creating owned powershell script : 아래의 양식을 이용하여 각자 원하는 모니터링 스크립트를 만들어 봅시다.

    ```powershell

    $checkResult
    $checThreshold

    # checking status

    # creating event log

    ```

- Eventlogging : Powershell로 Event log를 생성할 수 있습니다.
원하는 ID와 event type으로 생성해 봅시다.

    * New-Eventlog : Custom Event 정의
    * Write-Eventlog : Custom Event 발생

        ```powershell
        New-EventLog -LogName System -Source MyTestApp

        Write-EventLog 
            -LogName Application 
            -Source MyTestApp 
            -EntryType Error 
            -Message "XXX Process Down" 
            -EventId 888
        ```

- registering Task scheduler 

    ```
    $Trigger= New-ScheduledTaskTrigger -At 10:00am –Daily # Specify the trigger settings
    $User= "NT AUTHORITY\SYSTEM" # Specify the account to run the script
    $Action= New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "C:\PS\StartupScript.ps1" # Specify what program to run and with its parameters

    Register-ScheduledTask -TaskName "Monitor1" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest –Force # Specify the name of the task
    ```

- Monitoring Test : 장애를 발생시키고 생성한 스크립트를 실행을 하거나, 아래 명령으로 예약된 작업을 manual하게 실행해 봅니다.

    ```
    PS C:\> Start-ScheduledTask -TaskName "Monitor1"
    ```

## **7. Powershell with Module**

- About PSGallery (https://www.powershellgallery.com) : Github/DockerHub 등과 같이 MS에서 공식적으로 제공하는 Powershell 관련 Module들의 Marketplace 또는 Hub라고 보시면 되겠습니다. Python의 pip, Git의 git clone 등과 같이  원하는 Module을 인터넷의 MS 공식 사이트인 PSgallery에서 다운로드 및 설치하여 사용 가능합니다.

- using find-module/ install-module/ import-module : 각각 현재 설치된 Module 리스트 / 인터넷으로부터 다운로드 / 다운로드된 모듈을 설치하는 명령어입니다.

    * Caution : Install-Module은 Windows 7 / 2008 계열에서는 기본적인 설치가 되지 않습니다. 8.1/2012R2용 Windows management pack을 이용한 powershell 설치 및 대응하는 .net framework 설치가 필요합니다.

    ```powershell
    PS C:\> Find-Module -Name SQLite

    Version    Name                                Repository           Description
    -------    ----                                ----------           -----------
    2.0        SQLite                              PSGallery            The SQLite PowerShell Provider allows PowerShell...


    PS C:\> Install-Module -Name SQLite

    신뢰할 수 없는 리포지토리
    신뢰할 수 없는 리포지토리에서 모듈을 설치하는 중입니다. 이 리포지토리를 신뢰하는 경우 Set-PSRepository cmdlet을
    실행하여 InstallationPolicy 값을 변경하십시오. 'PSGallery'에서 모듈을 설치하시겠습니까?
    [Y] 예(Y)  [A] 모두 예(A)  [N] 아니요(N)  [L] 모두 아니요(L)  [S] 일시 중단(S)  [?] 도움말 (기본값은 "N"):
    PS C:\>

    PS C:\> Import-Module -name SQLite

    ```
- 설치된 Module의 위치 확인 
    ```powershell
    PS C:\> $env:PSModulePath
    C:\Users\{User}\Documents\WindowsPowerShell\Modules;C:\Program Files\WindowsPowerShell\Modules;C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules
    PS C:\>
    ```

- 현재 로그인한 유저에게만 설치하고 싶을 때
    ```powershell
    PS C:\> Install-Module -Name SQLite -Scope CurrentUser

    ```