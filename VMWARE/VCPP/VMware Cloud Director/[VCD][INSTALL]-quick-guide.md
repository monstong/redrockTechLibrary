# VMware Cloud Director Quick Installation Guide


## 1. Pre-req

1. vCenter, ESXi, NSX 설치 (Onecloud 기준)
    - ESX host spec 변경 (cpu: 10, mem: 24 증가, vdisk 5G , 20G 20G 추가)
    - FreeNAS VM에 20G * 5 추가 후  admin ui 에서 다음 작업 수행
        1. volume manager 에서 Hol 볼륨에 추가된 disk 반영
        1. COMP01-1 볼륨에 zvol 증설 반영 (전체의 80%사이즈로 설정)
        1. vsphere client 에서 datastore increase capacity 수행
    - NSX-V 6.4.5 다운로드 및 설치
        1. vcenter & lookup service 등록
        1. controller node 배포
            Controller-IP-Pool 192.168.110.31-33
        1. host preparation
            RegionA0-VTEP-Pool 192.168.130.51-59
        1. install nsx, config VXLAN

2. NFS VM 구성 : VCD cell 간 Data transfer 용 storage
    - vdisk 50G * 3개 추가
    - CentOS 7 기준
    ```
    # yum update
    # yum install nfs-utils nfs-utils-lib
    # systemctl   start nfs-server

    # mkdir /VCD-Storage

    # fdisk -l | grep sd*
    # fdisk /dev/sda
    # fdisk /dev/sdb
    # vgcreate nfsvg /dev/sda1 /dev/sdb1
    # lvcreate -L 100G -n lvvcd nfsvg
    # mkfs.xfs /dev/mapper/nfsvg-lvvcd
    # vi /etc/fstab    and add new line
    /dev/mapper/nfsvg-lvvcd                  /VCD-Storage           xfs     defaults        0 0
    # mount -a
    # df -h | grep VCD
    /dev/mapper/nfsvg-lvvcd                   100G   33M  100G   1% /VCD-Storage

    # vi /etc/exports
    /nfs/VCD 192.168.110.0/24(rw,sync,no_subtree_check,no_root_squash) 
    
    # systemctl restart nfs-server
    # showmount -e nfs-01a.corp.local

    ```
    - Optional (add to additaion disk devices)
    - add vdisks
    - rescan new disk devices
    ```
    # lsscsi
    [0:0:0:0]    disk    VMware   Virtual disk     1.0   /dev/sda
    # echo "- - -" > /sys/class/scsi_host/host0/scan
    or 
    # partprobe
    ```
    - check fdisk and create partition
    ```
    # fdisk -l | grep sd | grep Disk
    # fdisk -l | grep sdd
    Disk /dev/sdd: 107.4 GB, 107374182400 bytes, 209715200 sectors
    # fdisk /dev/sdd
    n > p > enter > enter > enter > w
    # fdisk -l | grep sd | grep Disk
    ```
    - extend vg , extend lvol , extend filesystem
    ```
    # vgextend nfsvg /dev/sdd1 
    # vgs
    # lvs
    LV      VG                    Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
    root    centos_linux-base-01a -wi-ao----  <8.00g                                              
    swap    centos_linux-base-01a -wi-ao----   1.00g                                              
    lvnfsds nfsvg                 -wi-ao----  99.99g                                              
    lvvcd   nfsvg                 -wi-ao---- 100.00g                                              
    
    # lvextend -L +99.99G /dev/mapper/nfsvg-lvnfsds
    # lvs
    LV      VG                    Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
    root    centos_linux-base-01a -wi-ao----  <8.00g                                              
    swap    centos_linux-base-01a -wi-ao----   1.00g                                              
    lvnfsds nfsvg                 -wi-ao---- 299.98g                                              
    lvvcd   nfsvg                 -wi-ao---- 100.00g                                              

    # xfs_growfs /dev/mapper/nfsvg-lvnfsds
    # df -h 
    ```

    - configure nfs datastore for 2nd purpose
    

3. Deploy vcd appliance from ovf


4. certificate 만들기 (임시 root ca)

5. Install RabbitMQ

    - Install erlang
    https://www.rabbitmq.com/which-erlang.html
    https://packagecloud.io/rabbitmq/erlang

    ```
    # yum install -y  epel-release
    # curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash
    # yum install -y erlang-22.3
    ```
    - Install Rabbitmq
    ```
    # rpm --import https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc

    # vi /etc/yum.repo.d/rabbitmq.repo
    [bintray-rabbitmq-server]
    name=bintray-rabbitmq-rpm
    baseurl=https://dl.bintray.com/rabbitmq/rpm/rabbitmq-server/v3.8.x/el/7/
    gpgcheck=0
    repo_gpgcheck=0
    enabled=1

    # yum install -y rabbitmq-server
    ```
    - Enable Mgmt plugin
    ```
    # rabbitmq-plugins enable rabbitmq_management
    ```
    
6. Configure AMQP in VCD
    - Configure Rabbitmq (Basic)
    ```
    # rabbitmqctl add_user vcdamqp VMware1!
    # rabbitmqctl set_user_tags vcdamqp administrator 
    # rabbitmqctl set_permissions -p / vcdamqp “.*” “.*” “.*” 
    ```

    - Configure AMQP in VCD UI







## Resources

- [VCD Official Manual](https://docs.vmware.com/en/VMware-Cloud-Director/10.1/VMware-Cloud-Director-Install-Configure-Upgrade-Guide/GUID-F14315CC-B373-4A21-A3D9-270FFCF0A417.html)





