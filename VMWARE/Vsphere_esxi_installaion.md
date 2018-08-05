# How to install and optimize vsphere esxi 6.0


1. Prepare ESXi custom iso  and driver file.

2. BIOS setting
 - enable Hyper threading
 - enable intel(r) VT-d
 - neable NUMA

 - Hujitsu RX specific setting
   * SR-IOV <enable>
   * Power management <High performance or Maximum> 
   * Memory Speed <Max Performance>
   * Memory Power Management <disabled>
   * Turbo Mode <Enable>
   * C1E <Disable>
   * CPU C-States <Disable>
   * Power/Performance Bias <Platform controlled>
   * Platform controlled type <Maximum Performance>
   * Uncore Frequency Scaling <Disable>

 - change boot order (cdrom or pxe)
 - save configuration
 -  reboot

3. CDROM boot  and entering ESX installer screen.


4. Version check  and License agreement (F11 key)

5. select the internal disk to install ESXi

6. select language (korean)

7. set password (root user)

8. select install button.

9. reboot server

10. configure management network in esxi host.
    (F2 key -> root password input)

 -  Choose 'DNS configuration' -> input DNS server, hostname
 - configure Management network -> choose 'set static ipv4 address and network config'
 - choose ipv4 configuration -> input ip address, subnet mask, default gateway
 - choose ipv6 configuration -> disable ipv6
 - restart management network
 - reboot

11. Troubleshooting options -> enable esxi shell, enable ssh

12. ntp setting
 - (on vcenter) each host -> manage > setting > time configuration
 - choose Use network time protocal
 - ntp service startup policy : start and stop with host
 - ntp server : dc#1, dc#2 ip

13. check installed version of esxi host
 - connect each host via ssh
 - vmware -vl
 - after installing vcenter, patch to updates 3 build-5251623

15. install vsphere client and connect host (as root user)

16. create vswitch 
 - configuration > networking > add networking
   * select virtual system
   * select vmnic
   * input network label
   * check summary and done.

17. create vmkernel port
 - configuration > networking > add networking
   * select vmkernel
   * select vswitch0 in management network
   * input network label 'vMotion' <- for vmotion only
   * input ip address and subnet for vmotion
   * check summary and done

18. create the additional network (HB, NAS etc)

19. configure the VSS security setting

 - set the Forged transmits
   * configuration > networking > each vswitch properties click > vswitch double click > security > change value of forged transmits to 'reject'
 - set the MAC address change
   *  configuration > networking > each vswitch properties click > vswitch double click > security > change value of MAC address change to reject 
   (but MSCS use MAc addres has to be shared exception)
 - set the Promiscuous mode
    *  configuration > networking > each vswitch properties click > vswitch double click > security > change value of Promiscuous mode to reject 

20. configure the datastore

 - configuration > storage > add storage
   * select disk type > select luns
   * select filesystem version : VMFS-5
   * check disk layout
   * input datastore name
   * select maximum available size
   * check summary and done.
   * EXTEND LUN : right click the created datastore and select the property > select extend > select the additional luns

21. patch eSXi security path.
 - create the folder in datastore and upload patch file.

 - run this command
 ```
   # esxcli software sources profile list -d /vmfs/volumes/datastore1/image/ESXi600-201711001.zip

   # esxcli software sources profile update -d /vmfs/volumes/datastore1/image/ESXi600-201711001.zip

   # sync;sync
   # reboot

   # vmware -vl
``` 
21. update emulex driver
 - check current version
 ```
  # esxcli software vib list | grep qlnativefc
  ```
 - upload emulex driver file : qlnativefc-2.1.64.0-1OEM.600.0.0.2768847.x86_64.vib

 - install emulex driver
 ```
  # esxcli software vib install -v /vmfs/volumes/datastore1/image/qlnativefc-2.1.64.0-1OEM.600.0.0.2768847.x86_64.vib

  # reboot

  # esxcli software vib list | grep qlnativefc
  ```

22. configure the coredump setting
 - create the coredump file
 ```
  # esxcli system coredump file add -e {internal datastore} -f { filename}
  # esxcli system coredump file add -d aaaesx01:datastore1 -f aaaesx01

  # esxcli system coredump file list
```
 - set the coredump setting
 ```
  # esxcli system coredump file set -p /vmfs/volumes/50ca5adfadsfasdasd/vmkdump/aaaesx01.dumpfile

  # esxcli system coredump file list
```


23. configure the host security setting
 - SSH timeout
   * connect each host via ssh
   * configure setting
```
 # esxcli system settings advanced list -o "/UserVars/ESXiShellTimeOut"
 # esxcli system settings advanced list -o "/UserVars/ESXiShellInteractiveTimeOut"

 # esxcli system settings advanced set -o "/UserVars/ESXiShellTimeOut" --int-value "900"
 # esxcli system settings advanced set -o "/UserVars/ESXiShellInteractiveTimeOut" --int-value "900"
```

 - MOB Setting
```
 # vim-cmd hostsvc/advopt/view
 config.HostAgent.plugins.solo.enableMob
 value = false  -> OK
 value = true   -> 
   # vim-cmd hostsvc/advopt/update
   Config.HostAgent.plugins.soloe.enableMob bool false

 # vim-cmd proxysvc/service_list
  ...
  serverNamespace  = '/mob',
  accessMode = "httpsWithRedirect",
  pipeName = "/var/run/vmware/proxy-mob",
  ...
  if above setting exists, remove mob using the below cmd.

  # vim-cmd proxysvc/remove_service "/mob" "httpsWithRedirect"
```
 - Lockdown Mode setting
   * esxi host > configuration > software > security Profile > Lockdown Mode > Disabled

24. confugring the Guest VM security setting.
 (After creating all GUEST VMs)
  - deactive the console clipboard feature.
  ```
   #esxcli vm process list
   # grep -i 'isolcation.tools.copy.disable' [VMX]
   # grep -i 'isolcation.tools.paste.disable' [VMX]
   # grep -i 'isolcation.tools.dnd.disable' [VMX]
   # grep -i 'isolcation.tools.setGuiOptions.enable' [VMX]

   isolation.tools.copy.diable = TRUE
   isolation.tools.paste.diable = TRUE
   isolation.tools.dnd.diable = TRUE
   isolation.tools.setGuiOptions.enable = FALSE
```

 - limit connected device access to host.
 ```
 # esxcli vm process list
 # grep -i 'isolation.device.connectable.disable' [VMX]
 # grep -i 'isolation.device.edit.disable [VMX]

 isolation.device.connectable.disable = TRUE
 isolation.device.edit.disable = TRUE
 ```

  - remove weak point of hacking ot VNC connection attack.
  ```
  # esxcli vm process list
  # grep -i 'RemoteDisplay.vnc.enabled' [VMX]

  RemoteDisplay.vnc.enabled = FALSE
  ```

  - limit exposing host info.
  ```
  # esxcli vm process list
  # grep -i 'tools.guestlib.enableHostInfo' [VMX]

  tools.guestlib.enableHostInfo = FALSE
```
 - limit maximum vmx file size.
 ```
  # esxcli vm process list
  # grep -i 'tools.setInfo.sizeLimit' [VMX]

  tools.setInfo.sizeLimit = 1048576
```

25. ATS heartbeat setting
 - diactivate the ATS heartbeat.
```
 # esxcli system settings advanced list -o /VMFS3/UseATSForHBonVMFS5

 Path: /VMFS3/UseATSForHBOnVMFS5
 Type : integer
 Int Value:1 <- check this value
 ...

 # esxcli system settings advanced set -i 0 -o /VMFS3/UseATSForHBonVMFS5

 # esxcli system settings advanced list -o /VMFS3/UseATSForHBonVMFS5

 Path: /VMFS3/UseATSForHBOnVMFS5
 Type : integer
 Int Value: 0 <- check this value
 ...

26. testing crash dump creation in each VM.
 - connect esxi host via ssh
```
 # esxcli vm process list

 # /sbin/vmdumper {vm world ID} nmi

```

27. set host license

 vsphere client > configuration > licensed feature > edit > input license key > check


28. install the vCenter

 - pre-installation : create AD/NTP/DNS (need FQDN)

 - install vcenter
  * use iso file and boot vcenter VM
  * select deployment type : embedded deployment
  * configure system network name : FQDN
  * create a new vcenter single sign on : set SSO password
  * vcenter server service account : select windows local system account
    > If got error during service account, grant log on as  service permission
    Run > secpol.msc > Local policies > user rights assignment > log on as a service : Add user or group > input your account

  * Database setting : use an embedded database
  * port : default
  * deployment directory : default
  * uncheck VM customer experience program
  * check summary and install

29. create datacenter and configure cluster
(in vceneter)
 - create datacenter : right click vcenter > new datacenter > DC-name
 - create cluster
  * right clieck created datacenter > new cluster
  * input cluster name > check Vsphere HA
 -* host monitoring status : default
  * VM restart priority : middle
  * VM monitoring : not use
  * EVC : EVC not use
  * swapfile : select 가상시스템과 동일한 디렉토리에 스왑 파일 권장
  * check summary and done
 
 - add esxi host  to  created cluster
  * right click created cluster > add host
  * input host ip, root, password

30. set the optimized setting
  - limit Remote display to 2
    * VM poweroff 
    * edit settings > options > advanced > general > configuration parameter > RemoteDisplay.maxConnection = 2

  - diactivate reducing vm disk feature
    * VM poweroff
    * edit settings > options > advanced > general > configuration parameter > isolation.tools.diskShrink.disable = TRUE
    isolation.tools.diskWiper.disable = TRUE

  - check VM virtual disk mode
    * VM poweroff
    * edit settings > options > advanced > general > configuration parameter > scsiX:Y.mode -> none is OK
    independent nonpersistent 일 경우 persistent 로 변경

  - power management setting
    * each host > manage > settings > power management > edit  > choose high performance

   - install VM tools
     * right click each VM > guest > install vmware tools
     * each VM > summary > check vmware tools status(installed or not)

   - Time synce disable
     * VM poweroff
     * right click VM > edit settings > options > advanced > general > configuration parameter
     * add row and input the below parameter and value

```
tools.syncTime 0
time.synchronize.continue 0
time.synchronize.restore 0
time.synchronize.resume.disk 0
time.synchronize.shrink 0
time.synchronize.tools.startup 0
time.synchronize.tools.enable 0
time.synchronize.resume.host 0

```







 
  
   

