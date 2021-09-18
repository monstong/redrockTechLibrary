# **/storage/log Filesystem Full in VCSA**

VCSA 환경에서 /storage/log filesystem이 full 발생시 조치 방법 정리해 보았습니다.

일반적인 Log영역 파일시스템 사용량 임계치 초과시 조치 방법은 크게 2가지 입니다.
 - 불필요 또는 과거 로그 파일들을 삭제 
 - 파일시스템 자체 크기를 증설

VCSA 환경에서도 동일하게 2가지 조치 방법 중 1가지로 조치하시면 됩니다.

단 Appliance(?)이다 보니 파일 삭제는 임의로 진행하시면 side-effect이 발생할 수 있으니 조심해야 겠죠? ^^

> **/storage/log 파일시스템**
 VCSA내 각종 서비스가 실행중에 logging 되는 파일들이 저장되는 영역입니다. os syslog 부터 storage 관리 log 등 다양하게 존재합니다. 

## **Simptom**
아시다시피 어떤 Software라도 Logging이 불가능해질 경우 해당 서비스가 중지되거나 행 상태를 유지하게 됩니다.
(DBMS의 경우 주로 Hang상태로 나름 빅 장애에 해당할수 있죠)

서비스가 중지된 원인을 `service-control --status [service-name]` 으로 확인해 보면 아래 Error를 확인할 수 있습니다.

- **Error No** : `errno 28 no space left on device` 


## **Solution**

 **- 불필요 또는 과거 Log file 제거**
 /storage/log 영역내에 삭제 가능한(서비스 영향없는) log 파일들을 제거합니다.

 
   1. connect to VCSA with SSH(root유저) : VCSA에 SSH를 통하여 접속합니다. (putty등 터미널 클라이언트 이용)
      * 필요시 vCenter Management URL에서 SSH enable 진행합니다.

   1. Shell 모드로 진입 : 버전별로 좀 다르지만 아래와 같이 shell모드로 진입합니다.

        ```
        (Prior to VCSA 6.5)
        Command> shell.set --enabled True
        Command> shell

        (VCSA 6.5 or higher)
        Command> shell
        ```

   1. check the filesystem usage (which filesystem has no free space : 100% used) : `df` 명령으로 파일시스템별 사용량을 확인합니다.

        ```
        root@photon-machine [ ~ ]# df -h
        Filesystem                                Size  Used Avail Use% Mounted on
        devtmpfs                                  4.9G     0  4.9G   0% /dev
        tmpfs                                     4.9G   24K  4.9G   1% /dev/shm
        tmpfs                                     4.9G  688K  4.9G   1% /run
        tmpfs                                     4.9G     0  4.9G   0% /sys/fs/cgroup
        /dev/sda3                                  11G  4.1G  6.0G  41% /
        tmpfs                                     4.9G  1.4M  4.9G   1% /tmp
        /dev/sda1                                 120M   35M   80M  30% /boot
        /dev/mapper/core_vg-core                   25G   45M   24G   1% /storage/core
        /dev/mapper/log_vg-log                    9.8G   9.8G   0G 100% /storage/log
        /dev/mapper/db_vg-db                      9.8G   98M  9.2G   2% /storage/db
        /dev/mapper/dblog_vg-dblog                 15G  102M   14G   1% /storage/dblog
        /dev/mapper/seat_vg-seat                  9.8G   50M  9.2G   1% /storage/seat
        /dev/mapper/netdump_vg-netdump            985M  1.3M  932M   1% /storage/netdump
        /dev/mapper/autodeploy_vg-autodeploy      9.8G   23M  9.2G   1% /storage/autodeploy
        /dev/mapper/imagebuilder_vg-imagebuilder  9.8G   23M  9.2G   1% /storage/imagebuilder
        /dev/mapper/updatemgr_vg-updatemgr         99G   75M   94G   1% /storage/updatemgr
        ```

   1. If it is log area like /storage/log filesystem, you can remove the old or unused logfile. : /storage/log 파일시스템이 100%인걸 확인할 수 있습니다. `du` 명령어와 `sort`명령어 조합을 통해 Big file 이나 작은 크기의 여러개 file들을 확인후 삭제합니다.

        ```
        root@photon-machine [ ~ ]# cd /storage/log
        root@photon-machine [ /storage/log ]# du -ms * | sort -n 
        root@photon-machine [ /storage/log/vmware/sso ]# du -ms * | sort -n
        root@photon-machine [ /storage/log/vmware/sso ]# ls -arlt
        => 위와 같이 크기가 큰 디렉토리를 찾아 들어가는 방식을 반복합니다. 
        
        root@photon-machine [ /storage/log/vmware/sso ]# rm {old log file}
        => current log file은 가급적 건드리지 말고 과거 파일중 서비스 영향 없는 log file들을 삭제하길 권고합니다.
        ```

   1. 삭제후 현재 파일시스템 재확인 : 사용량이 떨어진 걸 확인할 수 있습니다.
        ```
        root@photon-machine [ /storage/log/vmware/sso ]# df -h .
        Filesystem              Size  Used Avail Use% Mounted on
        /dev/mapper/log_vg-log  9.8G   46M  9.2G   1% /storage/log
        ```

 **- 해당 파일시스템 크기 증설**
  autogrow 스크립트를 통하여 파일시스템 자체를 증가시킵니다. 이작업을 위해서는 datastore내 여유 공간이 있어야 하며, VCSA VM의 해당 Virtual harddisk 식별및 expand가 먼저 선행되어야 합니다.

   1. connect to VCSA with SSH(root유저) : VCSA에 SSH를 통하여 접속합니다. (putty등 터미널 클라이언트 이용)
      * 필요시 vCenter Management URL에서 SSH enable 진행합니다.

   1. Shell 모드로 진입 : 버전별로 좀 다르지만 아래와 같이 shell모드로 진입합니다.

        ```
        (Prior to VCSA 6.5)
        Command> shell.set --enabled True
        Command> shell

        (VCSA 6.5 or higher)
        Command> shell
        ```

   1. check the filesystem usage (which filesystem has no free space : 100% used) : `df` 명령으로 파일시스템별 사용량을 확인합니다.

        ```
        root@photon-machine [ ~ ]# df -h
        Filesystem                                Size  Used Avail Use% Mounted on
        devtmpfs                                  4.9G     0  4.9G   0% /dev
        tmpfs                                     4.9G   24K  4.9G   1% /dev/shm
        tmpfs                                     4.9G  688K  4.9G   1% /run
        tmpfs                                     4.9G     0  4.9G   0% /sys/fs/cgroup
        /dev/sda3                                  11G  4.1G  6.0G  41% /
        tmpfs                                     4.9G  1.4M  4.9G   1% /tmp
        /dev/sda1                                 120M   35M   80M  30% /boot
        /dev/mapper/core_vg-core                   25G   45M   24G   1% /storage/core
        /dev/mapper/log_vg-log                    9.8G   9.8G   0G 100% /storage/log
        /dev/mapper/db_vg-db                      9.8G   98M  9.2G   2% /storage/db
        /dev/mapper/dblog_vg-dblog                 15G  102M   14G   1% /storage/dblog
        /dev/mapper/seat_vg-seat                  9.8G   50M  9.2G   1% /storage/seat
        /dev/mapper/netdump_vg-netdump            985M  1.3M  932M   1% /storage/netdump
        /dev/mapper/autodeploy_vg-autodeploy      9.8G   23M  9.2G   1% /storage/autodeploy
        /dev/mapper/imagebuilder_vg-imagebuilder  9.8G   23M  9.2G   1% /storage/imagebuilder
        /dev/mapper/updatemgr_vg-updatemgr         99G   75M   94G   1% /storage/updatemgr
        ```

   1. 증설대상 파일시스템의 disk device 식별 : 현재 100% Full 상태인 /storage/log 파일시스템에 해당하는 Disk device를 먼저 식별합니다.
      * 위 예시에서는 LVM으로 구성된 `/dev/mapper/log_vg-log` 이 Logical volume을 기준으로 확인해 갑니다.
      * log_vg가 vg명, log 가 lv명임을 알 수 있습니다. 

        ``` 
        root@photon-machine [ /storage/log/vmware/sso ]# lvs
        LV           VG              Attr       LSize    Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
        autodeploy   autodeploy_vg   -wi-ao----    9.99g
        core         core_vg         -wi-ao----   24.99g
        db           db_vg           -wi-ao----    9.99g
        dblog        dblog_vg        -wi-ao----   14.99g
        imagebuilder imagebuilder_vg -wi-ao----    9.99g
        log          log_vg          -wi-ao----    9.99g => 해당 logical volume임
        netdump      netdump_vg      -wi-ao---- 1016.00m
        seat         seat_vg         -wi-ao----    9.99g
        swap1        swap_vg         -wi-ao----   24.99g
        updatemgr    updatemgr_vg    -wi-ao----   99.99g
        root@photon-machine [ /storage/log/vmware/sso ]# pvs
        PV         VG              Fmt  Attr PSize    PFree
        /dev/sdc   swap_vg         lvm2 a--    24.99g    0
        /dev/sdd   core_vg         lvm2 a--    24.99g    0
        /dev/sde   log_vg          lvm2 a--     9.99g    0 => log_vg에 할당된 physical volume임
        /dev/sdf   db_vg           lvm2 a--     9.99g    0
        /dev/sdg   dblog_vg        lvm2 a--    14.99g    0
        /dev/sdh   seat_vg         lvm2 a--     9.99g    0
        /dev/sdi   netdump_vg      lvm2 a--  1016.00m    0
        /dev/sdj   autodeploy_vg   lvm2 a--     9.99g    0
        /dev/sdk   imagebuilder_vg lvm2 a--     9.99g    0
        /dev/sdl   updatemgr_vg    lvm2 a--    99.99g    0
        => sda,sdb device는 OS영역 등으로 사용되므로 LVM으로 구성되어 있지 않아 위 명령에서는 보이지 않습니다.

        root@photon-machine [ /storage/log/vmware/sso ]# fdisk -l | grep Disk | grep sd => fdisk명령으로 다시 확인
        Disk /dev/sda: 12 GiB, 12884901888 bytes, 25165824 sectors 
        Disk /dev/sdb: 1.8 GiB, 1919942656 bytes, 3749888 sectors
        Disk /dev/sdc: 25 GiB, 26843545600 bytes, 52428800 sectors
        Disk /dev/sdd: 25 GiB, 26843545600 bytes, 52428800 sectors
        Disk /dev/sde: 10 GiB, 10737418240 bytes, 20971520 sectors => 대상 disk device 재확인 (다섯째 생성된 10G 볼륨임)
        Disk /dev/sdf: 10 GiB, 10737418240 bytes, 20971520 sectors
        Disk /dev/sdg: 15 GiB, 16106127360 bytes, 31457280 sectors
        Disk /dev/sdh: 10 GiB, 10737418240 bytes, 20971520 sectors
        Disk /dev/sdi: 1 GiB, 1073741824 bytes, 2097152 sectors
        Disk /dev/sdj: 10 GiB, 10737418240 bytes, 20971520 sectors
        Disk /dev/sdk: 10 GiB, 10737418240 bytes, 20971520 sectors
        Disk /dev/sdl: 100 GiB, 107374182400 bytes, 209715200 sectors
        ```

   1. VCSA VM의 대상 Harddisk 식별 : VCSA는 자동 deploy되므로 보통 생성된 device명 순서와 VM setting에서 보이는 Harddisk순서가 일치합니다.  아래 예시에서는 Powercli를 이용하지만, vsphere client > VCSA VM > edit setting 에서 확인 및 증설하셔도 됩니다.
      * 아래 예시는 Powercli 사전 설치가 필요합니다.
      * Powercli 관련해서는 별도로 포스팅할 예정입니다.

        ```
        (vcenter 접속)
        PS> Connect-VIServer {your vcenter IP} -user {your admin username} -password {your password}

        Name                           Port  User
        ----                           ----  ----
        192.168.75.138                 443   VSPHERE.LOCAL\Administrator

        (vcsa VM 명 확인)
        PS> Get-VM

        Name                 PowerState Num CPUs MemoryGB
        ----                 ---------- -------- --------
        vc65                 PoweredOn  2        10.000

        (Vcsa VM에 생성된 Harddisk 확인 )
        PS> Get-HardDisk -VM vc65  | select id, CapacityGB, Filename

        Id                          CapacityGB Filename
        --                          ---------- --------
        VirtualMachine-vm-12/2000           12 [datastore1] vc65/vc65.vmdk
        VirtualMachine-vm-12/2001 1.7880859375 [datastore1] vc65/vc65_1.vmdk
        VirtualMachine-vm-12/2002           25 [datastore1] vc65/vc65_2.vmdk
        VirtualMachine-vm-12/2003           25 [datastore1] vc65/vc65_3.vmdk
        VirtualMachine-vm-12/2004           10 [datastore1] vc65/vc65_4.vmdk => 대상
        VirtualMachine-vm-12/2005           10 [datastore1] vc65/vc65_5.vmdk
        VirtualMachine-vm-12/2006           15 [datastore1] vc65/vc65_6.vmdk
        VirtualMachine-vm-12/2008           10 [datastore1] vc65/vc65_7.vmdk
        VirtualMachine-vm-12/2009            1 [datastore1] vc65/vc65_8.vmdk
        VirtualMachine-vm-12/2010           10 [datastore1] vc65/vc65_9.vmdk
        VirtualMachine-vm-12/2011           10 [datastore1] vc65/vc65_10.vmdk
        VirtualMachine-vm-12/2012          100 [datastore1] vc65/vc65_11.vmdk
        => 다섯번째 10GB 볼륨인 vc65/vc65_4.vmdk 확인
        ```

   1. 확인된 VCSA VM의 Harddisk (다섯번째 10GB 볼륨) 를 expand 합니다. 대상 Harddisk의 ID 는 VirtualMachine-vm-12/2004 입니다.

        ```
        (해당 디스크만 Where-object로 추출)
        PS> Get-HardDisk -VM vc65  | where {$_.Id -eq 'VirtualMachine-vm-12/2004'}

        CapacityGB      Persistence                                                    Filename
        ----------      -----------                                                    --------
        10.000          Persistent                                [datastore1] vc65/vc65_4.vmdk

        (해당 디스크를 set-harddisk 로 10 -> 12G로 expand수행)
        PS> Get-HardDisk -VM vc65  | where {$_.Id -eq 'VirtualMachine-vm-12/2004'} | Set-HardDisk -CapacityGB 12

        확인
        이 작업을 수행하시겠습니까?
        대상 "Hard disk 5"에서 "Setting CapacityGB: 12." 작업을 수행합니다.
        [Y] 예(Y)  [A] 모두 예(A)  [N] 아니요(N)  [L] 모두 아니요(L)  [S] 일시 중단(S)  [?] 도움말 (기본값은 "Y"): y

        CapacityGB      Persistence                                                    Filename
        ----------      -----------                                                    --------
        12.000          Persistent                                [datastore1] vc65/vc65_4.vmdk
        
        => 확인 메세지를 skip하고 싶으면 `-Confirm:$false`를 옵션으로 추가하시면 됩니다.
    
        ```
    
   1. 해당 파일시스템을 auto grow 스크립트로 VCSA OS 단에서도 증설합니다. 온라인중 작업 가능하나 가급적 비업무 시간대 수행을 권고합니다.

        ```
        (VCSA 6.0)
        root@photon-machine [ ~ ]#  vpxd_servicecfg storage lvm autogrow

        (VCSA 6.5 or higher)
        root@photon-machine [ ~ ]# /usr/lib/applmgmt/support/scripts/autogrow.sh

        Sat Feb 9 06:42:46 UTC 2019 Disk Util: INFO: Scanning Hard disk sizes
        Syncing file systems
        which: no multipath in (/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/java/jre-vmware/bin:/opt/vmware/bin:/opt/vmware/bin)
        Scanning SCSI subsystem for new devices and remove devices that have disappeared
        Scanning host 0 for  SCSI target IDs  0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15, all LUNs
        Scanning for device 0 0 0 0 ...
        ... 중략 ...
        1 physical volume(s) resized / 0 physical volume(s) not resized
        Sat Feb 9 06:42:52 UTC 2019 Disk Util: INFO: Resizing PV /dev/sde
        Physical volume "/dev/sde" changed
        1 physical volume(s) resized / 0 physical volume(s) not resized
        Sat Feb 9 06:42:52 UTC 2019 Disk Util: INFO: Resizing PV /dev/sdf
        Physical volume "/dev/sdf" changed
        ... 중략 ...
        Sat Feb 9 06:42:54 UTC 2019 Disk Util: INFO: LV Resizing /dev/core_vg/core
        Sat Feb 9 06:42:54 UTC 2019 Disk Util: INFO: LV Resizing /dev/swap_vg/swap1
        Sat Feb 9 06:42:54 UTC 2019 Disk Util: INFO: LV Resizing /dev/seat_vg/seat
        Sat Feb 9 06:42:54 UTC 2019 Disk Util: INFO: LV Resizing /dev/dblog_vg/dblog
        Sat Feb 9 06:42:54 UTC 2019 Disk Util: INFO: LV Resizing /dev/autodeploy_vg/autodeploy
        Sat Feb 9 06:42:54 UTC 2019 Disk Util: INFO: LV Resizing /dev/log_vg/log
        Size of logical volume log_vg/log changed from 9.99 GiB (1279 extents) to 11.99 GiB (1535 extents).
        Logical volume log successfully resized.
        resize2fs 1.42.13 (17-May-2015)
        Filesystem at /dev/mapper/log_vg-log is mounted on /storage/log; on-line resizing required
        old_desc_blocks = 1, new_desc_blocks = 1
        The filesystem on /dev/mapper/log_vg-log is now 3143680 (4k) blocks long.

        Sat Feb 9 06:42:56 UTC 2019 Disk Util: INFO: LV Resizing /dev/netdump_vg/netdump
        Sat Feb 9 06:42:56 UTC 2019 Disk Util: INFO: LV Resizing /dev/imagebuilder_vg/imagebuilder
        Sat Feb 9 06:42:56 UTC 2019 Disk Util: INFO: LV Resizing /dev/updatemgr_vg/updatemgr
        Sat Feb 9 06:42:56 UTC 2019 Disk Util: INFO: LV Resizing /dev/db_vg/db
        ```

   1. `df`명령으로 증설 여부 최종 확인합니다.
        ```   
        root@photon-machine [ ~ ]# df -h
        Filesystem                                Size  Used Avail Use% Mounted on
        devtmpfs                                  4.9G     0  4.9G   0% /dev
        tmpfs                                     4.9G   24K  4.9G   1% /dev/shm
        tmpfs                                     4.9G  688K  4.9G   1% /run
        tmpfs                                     4.9G     0  4.9G   0% /sys/fs/cgroup
        /dev/sda3                                  11G  4.1G  6.0G  41% /
        tmpfs                                     4.9G  1.4M  4.9G   1% /tmp
        /dev/sda1                                 120M   35M   80M  30% /boot
        /dev/mapper/core_vg-core                   25G   45M   24G   1% /storage/core
        /dev/mapper/log_vg-log                     12G   52M   12G   1% /storage/log => 12G로 증설됨
        /dev/mapper/db_vg-db                      9.8G   98M  9.2G   2% /storage/db
        /dev/mapper/dblog_vg-dblog                 15G  102M   14G   1% /storage/dblog
        /dev/mapper/seat_vg-seat                  9.8G   50M  9.2G   1% /storage/seat
        /dev/mapper/netdump_vg-netdump            985M  1.3M  932M   1% /storage/netdump
        /dev/mapper/autodeploy_vg-autodeploy      9.8G   23M  9.2G   1% /storage/autodeploy
        /dev/mapper/imagebuilder_vg-imagebuilder  9.8G   23M  9.2G   1% /storage/imagebuilder
        /dev/mapper/updatemgr_vg-updatemgr         99G   75M   94G   1% /storage/updatemgr
        ```

## **reference**
 - [https://www.vgarethlewis.com/2018/08/13/vmware-vcenter-server-appliance-storage-log-full/](https://www.vgarethlewis.com/2018/08/13/vmware-vcenter-server-appliance-storage-log-full/)
