
# **What's New in Oracle Exadata Database Machine 19.1.0**

Exadata Database Machine도 어느새 19.1 버전이 release 되었네요.
<br/>(작년에 X7용 18.1 버전 eXadata software를 본지 엊그제 같은데 말이죠.)

공식 홈페이지의 문서를 참고하여 제 마음에 드는 (?) 주요 New feature 들을 정리해 보았습니다.

## Oracle Linux Upgraded to Oracle Linux 7.5

나름 최신 버전의 Linux로 업그레이드 되었네요(이글을 작성 시점에 Edelivery상에 최신 버전은 OEL 7.6 입니다.)


### Oracle Database Software Minimum Required Version

- Oracle Database and Oracle Grid Infrastructure
  * 19c / 18c : Minimum version 18.3.0.0.180717
  * 12.2.0.1 : Minimum version 12.2.0.1.180717
  * 12.1.0.2 : Minimum version 12.1.0.2.180831
  * 11.2.0.4 : Minimum version DB : 11.2.0.4.180717 / GI : 12.1.0.2.180831 or higher
  * 11.2.0.3 : Minimum version DB : 11.2.0.3.28 / GI : 12.1.0.2.180831 or higher , OEDA 사용불가

### Server Time Synchronization Uses Chrony

    그동안 Chrony가 있음에도 불구하고, NTPD만 권고하던 오라클이 Exadata 에서 Oracle Linux 7.5를 씀으로써 전격적으로 Chrony 사용하도록 바뀌었네요. (얼마나 버그관리가 될지는 미래일이지만)
    Oracle Linux 7 의 고유 기능을 쓴다는 입장에서는 긍정저인 변화로 보입니다.

### Quorum Disk Manager Service Change

    X7 머신에서 Storage server가 3대이고 ASM High(3way mirror) Redundancy로 구성할 때 선택사항으로 DB server 에 Disk Quorum 을 구성합니다. (ASM high redundancy의 voting disk 자동으로 5개 구성되어야 하므로)

    이 때 Oracle Linux 6 버전은 Quorum Disk manager 로 tgtd Service 를 사용하였고, Oracle Linux 7에서는 Target service를 사용하게 변경되었습니다.

    Oracle Linux 6 -> 7 으로 업그레이드시 해당 서비스도 자동으로 변경(또는 마이그레이션) 된다고 합니다. <br/>
    (Minimum requirements: Oracle Exadata System Software release 19.1.0) <br/>
    (Quorum Disk manager에 대해서는 아래 링크 참조)

    * [Overview of Quorum Disk manager](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/dbmmn/maintaining-exadata-database-servers.html#GUID-13F4FDAC-D97F-4CB5-AF54-33DBB4AB4766)

## Faster Smart Scans Using Column-level Checksum

Checksum computation and validation 기능이 개선되었습니다. 

19.1 이전 버전에서는 Data를 Retrieve 할 때  block 단위 checksum 을 계산하고, Subsequent read 시 validation이 이루어지는 반면, 19.1 버전에서는 single column 단위로 (Block내에는 여러개의 Column 을 포함하죠) checksum 계산및 validation이 이루어진다고 합니다. (checksum이 계산된 후 각 CU header에 저장됨)

이 기능은 In-memory Columnar format on Exadata Smart Flash Cache 기능을 사용할때만 enable 됩니다.

 - Minimum requirements:
   * Oracle Exadata System Software release 19.1.0
   * Exadata Smart Flash Cache
   * INMEMORY_SIZE database initialization parameter

## Enhanced OLTP High Availability During Cell Outages and Flash Failures

마치 Re-silvering과 비슷해 보일수 있는 이 신기능은 Read data의 primary copy가 존재하는 disk 혹은 flash cache가 fail 되었을 때, 동작하는 것이 아닌, secondard mirror copy에 대해 disk뿐 아니라 flash cache도 pre-fetch 하게 되어 cell outages and flash failure에 대해 보다 적극적인 성능 저하를 방지합니다.

Re-silvering은 primary copy쪽 Flash cache가 fail 되었을 때  secondary mirror가 존재하는 cell에서 data를 disk -> flash cache로 로딩하는 개념이라 약간의 차이가 발생합니다.

해당 기능은 아래의 최소 조건에서만 발동하므로, Writeback 모드, HW, Image 버전을 확인하시길 바랍니다. 

 - Minimum requirements:
   * Oracle Exadata System Software release 19.1.0
   * Exadata Write Back Flash Cache on High Capacity storage servers
   * Exadata Database Machine X6 or later (due to flash cache size requirements)

## Automated Cloud Scale Performance Monitoring

마치 RMAN의 DRA(Data Recovery Advisor)처럼 Exadata 내 성능 이슈를 자동으로 감지하여 Root cause를 판단한다고 하는 기능이라고 합니다. 

 - spinning process DB 및 System 성능을 모두 수집하면, Exadata가 자동으로 문제 process를 판단하고 alert 생성합니다.
 - Exacheck에 나오는 Best practice config 설정이 아닐 경우에도 자동 alert 을 생성해 준다고 하네요.
 - MS 서비스의 부분으로써 별도의 설정은 필요 없다고 합니다.

실 사용자 입장에서는 수많은 오탐과 버그를 경계해야할 기능일 수도 있겠습니다. 

- Minimum requirements:
  * Oracle Exadata System Software 19.1.0

## Customizable SYSLOG Format
ALTER CELL (CELLCLI) 또는 ALTER DBSERVER (DBMCLI) 에서 syslogformat이란 속성이 추가되어 설정 가능합니다.

syslogformat 설정시 표준 syslog 출력 방식을 원하는 format으로 설정할 수 있으며, 설정시에 syslog 데몬은 재시작됩니다.
 - MS 서비스가 /etc/rsysclog.conf 에 존재하는 format string을 설정함
 
 - Minimum requirements:
   * Oracle Exadata System Software release 19.1.0

## Support for Host and ILOM on Separate Network

ILOM 과 Management Network을 아예 분리해 버렸습니다.  OOB (ILOM) Network의 중요성과 보안성 강화를 위해 인걸로 보이는데 그만큼 IP 대역이 추가되는 단점도 있을 거 같습니다. - 아래 링크처럼 OEDA에서부터 설정이라 Image upgrade시에는 어떤 절차시 있을지 확인이 필요합니다.
( [Configuring a Separate Network for ILOM](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/dbmin/exadata-network-requirements.html#GUID-81722DF4-4F18-4499-8C0B-BAA2BCB1FE76) )

- Minimum requirements:
   * Oracle Exadata System Software release 19.1.0


## Security Improvements

### Access Control for RESTful Service

아래 처럼 CELLCLI 또는 DBMCLI에서 HTTPS access 통제를 통해 RESTful access에 대한 접근제어가 가능합니다.

```
CellCLI> ALTER CELL httpsAccess="192.168.10.0/24"
```
 - Minimum requirements:
   * Oracle Exadata System Software release 19.1.0

### Password Expiration for Remote Users
Exacli 나 RESTful access 하는 유저에 대해 password expiration을 설정할 수 있습니다.
(celladmin 과 oracle유저는 제외)

 - Minimum requirements:
   * Oracle Exadata System Software release 19.1.0

### Advanced Intrusion Detection Environment (AIDE)
Advanced Intrusion Detection Environment (AIDE) 기능으로 내부에 비인가된 변경을 레포팅한다고 합니다.
서버내 file들에 대한 내부DB를 생성해 관리한다고 하는데, 자세한 내용은 아래 링크 참조하세요.

 - [Guarding Against Unauthorized Operating System Intrusions](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/dbmsq/exadata-security-practices.html#GUID-54A68856-D3EC-49F1-9B10-536EDE10EEC9)

 - Minimum requirements:
   * Oracle Exadata System Software release 19.1.0
   * Oracle Linux 7

### SSHD ClientAliveInterval Changed to 600 Seconds
SSHD 의 The ClientAliveInterval parameter 값이 600으로 설정됩니다.
shell의 TMOUT 환경변수를 사용하시는 곳은 중복 설정으로 보입니다.

### Stronger Password Requirements

패스워드 복잡도 규칙이 아래와 같이 강화됩니다.
- Minimum characters: 8
- Minimum numbers: 1
- Minimum lowercase characters: 1
- Minimum uppercase characters: 1
- Minimum special characters: 1
- Maximum consecutive repeating characters: 3
- Maximum consecutive repeating characters of the same class: 4
- Minimum number of different characters: 8
- Minimum days for password change: 1
- Maximum days for password change: 60
- Dictionary words are not valid or accepted.
- The last ten passwords cannot be reused

### Upload DIAGPACK to Oracle ASR Manager using HTTPs
보안 강화를 위해  운영자가 Management Server (MS) 와 Oracle ASR Manager 간에 DIAGPACK (diagnostic packages) 를 HTTPS를 통해 업로드될 수 있도록 설정 가능합니다.

 - [Enabling Automatic Diag Pack Upload for ASR for information](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/asxqi/index.html)
 
## Deprecated Features in Oracle Exadata System Software Release 19.1.0

19.1.0에서 deprecate 되는 기능입니다. 

 - Deprecation of Interleaved Grid Disks : The interleaving option for grid disks 이 deprecate되어, 해당 option을 선택해도 일반 option으로 griddisk가 생성됩니다.

-- Deprecation of nfsimg Images : Exdata 초기 설치시 PXE boot + nfsimg로 설치가 deprecate됩니다.
   <br/> PXE with iso image install을 사용해야 합니다.

## Desupported Features in Oracle Exadata System Software Release 19.1.0

 - Oracle Exadata V2 is no longer certified (V2는 이제 안녕~ 이네요.)
   쓰는데가 있다면.. Image upgrade는 18 대가 마지막으로 보거나 장비를 교체해야 겠네요.
   
   
   
## References 
 - https://docs.oracle.com/en/engineered-systems/exadata-database-machine/dbmso/whats-new-oracle-exadata-database-machine-19.1.0.html#GUID-9B28B969-7CE1-4290-B381-910703E0700C
 - https://www.actualtech.io/become-nsx-expert-72-hours/?fbclid=IwAR2bY7h2nW5j78A7s7nz-_nqVzvm9hOC7aFaTO95WEuTbvRbnn-wGrIMZLs