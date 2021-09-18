##########################3 fresh  install ###########################

[root@esx01:~] df -h
Filesystem   Size   Used Available Use% Mounted on
VMFS-5      42.5G 972.0M     41.6G   2% /vmfs/volumes/datastore1
vfat       249.7M   8.0K    249.7M   0% /vmfs/volumes/b979de7a-0902ce67-7618-aac59f57f14c
vfat       249.7M 149.6M    100.1M  60% /vmfs/volumes/69ef8c73-35eee8b6-943c-71c6e577fe27
vfat         4.0G   3.9M      4.0G   0% /vmfs/volumes/5c53034f-1b8eeae8-02ab-000c2979903c
vfat       285.8M 209.1M     76.8M  73% /vmfs/volumes/5c530347-531c1ae6-eca6-000c2979903c
[root@esx01:~] ls
altbootbank      dev              locker           productLocker    tardisks         var
bin              etc              mbr              sbin             tardisks.noauto  vmfs
bootbank         lib              opt              scratch          tmp              vmimages
bootpart.gz      lib64            proc             store            usr              vmupgrade
[root@esx01:~] pwd
/


[root@esx01:~] ps
WID    CID    WorldName
65537  0      idle1
65538  0      idle2
65539  0      idle3
65540  0      SVGAConsole
65541  0      debugtermlivedump
65542  0      logSysAlert
65543  0      serialLogger
65544  0      tlbflushcount
65545  0      tlbflushcounttryflush
65546  0      PageRetire
65547  0      idle0
65548  0      netLegacyRx
65549  0      NetEventWorld
65550  0      netCoalesce2World
65551  0      netCoalesce2FineWorld
65552  0      ndiscWorld
65553  0      UplinkWatchdogWorld
65554  0      uplinkLoadBalancerWorld
65555  0      PktCapWorld
65556  0      PktCapSessionFreeWorld
65557  0      CmdCompl-0
65558  0      CmdCompl-1
65559  0      CmdCompl-2
65560  0      CmdCompl-3
65561  0      ScsiFilterTransWorld
65562  0      AsyncTimeout
65563  0      DeviceTaskmgmtWatchdog
65564  0      PathTaskmgmtWatchdog
65565  0      SCSI-GenPurpose-0
65566  0      directMapUnmap
65567  0      RCUWorld
65568  0      HELPER_IMMEDIATE_QUEUE-0-0
65569  0      HELPER_MISC_QUEUE-1-0
65570  0      HELPER_MISC_QUEUE-1-1
65571  0      HELPER_MISC_QUEUE-1-2
65572  0      HELPER_VMFS_JOURNAL_QUEUE-2-0
65573  0      HELPER_LVM_DRIVER_QUEUE-3-0
65574  0      HELPER_VMFS_HEARTBEAT_QUEUE-4-0
65575  0      HELPER_VMFS_HEARTBEAT_QUEUE-4-1
65576  0      HELPER_VMFS_HEARTBEAT_QUEUE-4-2
65577  0      HELPER_VMXNET2_MISC_QUEUE-5-0
65578  0      HELPER_VMXNET2_MISC_QUEUE-5-1
65579  0      HELPER_SWAP_QUEUE-6-0
65580  0      HELPER_SWAP_QUEUE-6-1
65581  0      HELPER_SWAP_QUEUE-6-2
65582  0      HELPER_SWAP_QUEUE-6-3
65583  0      HELPER_LLSWAP_QUEUE-7-0
65584  0      HELPER_MEMSCHED_QUEUE-8-0
65585  0      HELPER_SCSI_QUEUE-9-0
65586  0      HELPER_SCSI_QUEUE-9-1
65587  0      HELPER_E1000_PAGE_IN_QUEUE-10-0
65588  0      HELPER_LVM_ASYNCIO_QUEUE-11-0
65589  0      HELPER_UPLINK_ASYNC_CALL_QUEUE-12-0
65590  0      HELPER_NETWORK_MISC_QUEUE-13-0
65591  0      HELPER_NETWORK_MISC_QUEUE-13-1
65592  0      HELPER_WATCHDOG_QUEUE-14-0
65593  0      HELPER_MISC_INFRA_QUEUE-15-0
65594  0      HELPER_MISC_INFRA_QUEUE-15-1
65595  0      HELPER_MISC_INFRA_QUEUE-15-2
65596  0      HELPER_VMXNET3_PT_QUEUE-16-0
65597  0      HELPER_VMXNET3_PT_QUEUE-16-1
65598  0      HELPER_VMXNET3_STATS_QUEUE-17-0
65599  0      HELPER_PT_MANAGER_QUEUE-18-0
65600  0      HELPER_PAGERETIRE_QUEUE-19-0
65601  0      HELPER_IODM_QUEUE-20-0
65602  0      HELPER_USERMEM_QUEUE-21-0
65603  0      HELPER_DEFER_WORK_QUEUE-22-0
65604  0      systemSwapPDL
65605  0      VMK swapper helper queue-23-0
65621  0      llswap defragmenter
65622  0      gsSwapRefill
65623  0      retireWld.0000
65624  0      retireWld.0001
65625  0      retireWld.0002
65626  0      retireWld.0003
65627  0      itRebalance
65628  0      memschedRealloc-fast
65629  0      memschedRealloc
65630  0      memmetrics-periodic
65631  0      memsched-periodic
65632  0      pshare-est
65633  0      lpage-est
65634  0      lpage
65635  0      CpuSchedAgingVtimes
65636  0      CpuSchedPeriodic
65637  0      CpuMetricsLoadHistory
65638  0      CpuSchedExtendedCore
65639  0      PktSlabMemoryStats
65640  0      netpoll cleanup helpers-24-0
65642  0      PSEventHelper-25-0
65646  0      PortEventHelper-26-0
65654  0      fssAIO-27-0
65658  0      DCFlushCaches
65659  0      OCFlush
65660  0      VCHelperQueue-28-0
65676  0      devfsHelper-29-0
65677  0      bcsyncd
65678  0      BCFlush-0
65679  0      fdsAIO-30-0
65683  0      VSCSI HBA Helper Queue-31-0
65684  0      VSCSI HBA Helper Queue-31-1
65685  0      VSCSI HBA Helper Queue-31-2
65686  0      VSCSI HBA Helper Queue-31-3
65687  0      VSCSI Helper Queue-32-0
65691  0      VSCSI Emulation Helper Queue-33-0
65695  0      VSCSIPoll
65696  0      reset-handler
65697  0      reset-watchdog
65698  0      SCSI Event Framework helpers-34-0
65706  0      Storage-APD
65707  0      SCSI periodic path probe-35-0
65708  0      SCSI periodic path probe-35-1
65711  0      SCSI periodic path probe-35-4
65715  0      SCSI periodic device probe-36-0
65717  0      SCSI periodic device probe-36-2
65720  0      SCSI periodic device probe-36-5
65723  0      SCSI periodic reclaim-37-0
65724  0      SCSIDeviceSchedQCleanup
65725  0      SCSI path scan helpers-38-0
65726  0      SCSI path scan helpers-38-1
65727  0      SCSI path scan helpers-38-2
65728  0      SCSI path scan helpers-38-3
65729  0      SCSI path scan helpers-38-4
65730  0      SCSI device scan helpers-39-0
65735  0      SCSI device APD helpers-40-0
65751  0      serialSwitcher
65752  0      logterm
65753  0      logterm-scroll
65754  0      SchedPowerEnergy
65755  0      memMap-adj
65756  0      VMKPCIPassthruUnmask
65757  0      RandomEntropySpillOverHelper-41-0
65758  0      RandomEntropySpillOverHelper-41-1
65759  0      RandomEntropySpillOverHelper-41-2
65760  0      RandomEntropySpillOverHelper-41-3
65761  0      NRandomHwrng
65762  0      tq:incompatTQ
65763  0      asyncRemapHelpers-42-0
65764  0      swapglobal-groupmove
65765  0      DeviceTaskmgmtHandler
65766  0      PathTaskmgmtHandler
65767  0      serial rx tty1
65768  0      serial rx tty2
65769  0      userMemTouchEst-430383237000
65770  65770  init
65819  65819  wdog-65820
65820  65820  vmsyslogd
65821  65820  vmsyslogd
65822  65820  vmsyslogd
65830  65830  sh
65841  65841  vobd
65845  65841  vobd
65846  65841  vobd
65847  65841  vobd
65848  65841  vobd
65849  65841  vobd
65850  65841  vobd
65851  65841  vobd
65852  65841  vobd
65853  65841  vobd
65854  65841  vobd
65855  65841  vobd
65856  65841  vobd
65857  65841  vobd
65858  65841  vobd
65859  65841  vobd
65860  65841  vobd
65865  65865  sh
65872  65872  vmkeventd
65873  65841  vobd
65874  65841  vobd
65881  0      vprobeDrainEngine
65893  0      tq:VmkapiV2_1_0_0TimerQueue
65899  0      tq:vmkata
65900  0      thread taskq_0
65901  0      thread taskq_1
65902  0      thread taskq_2
65903  0      thread taskq_3
65904  0      cam.doneq0
65905  0      cam.doneq1
65906  0      cam.doneq2
65907  0      cam.doneq3
65908  0      CAM taskq
65909  0      cam.scanner
65911  0      iscsi_trans_vmklink
65912  0      tq:vmklinux
65913  0      vmklnx Helper-43-0
65914  0      vmklnx Helper-43-1
65915  0      vmklnx Helper-43-2
65916  0      vmklnx Helper-43-3
65917  0      vmklnx Helper-43-4
65918  0      vmklnx Helper-43-5
65919  0      vmklnx Helper-43-6
65920  0      vmklnx Helper-43-7
65921  0      vmklnx Helper-43-8
65922  0      vmklnx Helper-43-9
65923  0      vmklnx Helper-43-10
65924  0      vmklnx Helper-43-11
65925  0      vmklnx Helper-43-12
65926  0      vmklnx Helper-43-13
65927  0      vmklnx Helper-43-14
65928  0      vmklnx Helper-43-15
65930  0      tq:vmkusb
65931  0      thread taskq_0
65932  0      thread taskq_1
65933  0      thread taskq_2
65934  0      thread taskq_3
65935  0      cam.doneq0
65936  0      cam.doneq1
65937  0      cam.doneq2
65938  0      cam.doneq3
65939  0      CAM taskq
65940  0      cam.scanner
65941  0      usbus0
65942  0      usbus0
65943  0      usbus0
65944  0      usbus0
65945  0      usbus1
65946  0      usbus1
65947  0      usbus1
65948  0      usbus1
65949  65949  vmkdevmgr
65953  0      advUnicastAddrWorld
65954  0      MirrorAgent
65955  0      etherswitchHelper-44-0
65963  0      vmnic0-pollWorld-0
65964  0      vmnic0-pollWorld-backup
65970  0      tq:NMP
65971  0      NMP Failover Helper-45-0
65974  0      tq:VMW_SATP_LOCAL
65983  0      VMCI Helper Queue-46-0
65984  0      VMCI Socket Helper Queue-47-0
65986  0      tq:NetHealthcheck
65987  0      HC_Ticket-48-0
65988  0      L2Echo Rx
65991  0      tq:VLANMTUCheck
65993  0      HeartbeatHelper-49-0
65995  0      tq:Shaper Schedule
65997  0      tq:lldp
66000  0      IpfixHelper-50-0
66001  0      ipfix_sender
66003  0      tq:tcpip4
66004  0      tq:tcpip4-flow-affinitizer
66005  0      tcpip-isr
66006  0      Tcpip4 wtask
66007  0      TCP/IP net event Helper-51-0
66011  0      TcpipPktComp#0
66012  0      TcpipFlowCleaner_
66015  0      dvfilter-52-0
66016  0      DVFilter-ReplyWorld
66017  0      DVFilter-HeartbeatWorld
66018  0      DVFilter-Comm-XmitWorld
66019  0      DVFilter-Comm-2
66028  0      tq:dvfilter-generic-fastpath
66037  66037  sh
66048  66048  net-lacp
66049  66048  net-lacp
66050  66048  net-lacp
66052  0      Cmpl-vmhba0-0
66053  0      Cmpl-vmhba64-0
66054  0      DVS sync world
66055  0      DVSSync send world
66056  0      DVSSync ack world
66057  0      DVSSync recv world
66059  0      vmk0-rx-0
66060  0      vmk0-tx
66063  66063  dhclient-uw
66066  0      vmnic0-0-tx
66092  0      COWRECacheMgr
66101  0      SunRPCAsyncIO-0
66102  0      SunRPCAsyncIO-1
66103  0      SunRPC GSS CTX Monitor
66107  0      J6ReplayHelper-53-0
66123  0      asyncReplayHelperQueue-54-0
66139  0      Vol3JournalExtendMgrWorld
66140  0      FS3FdUnlockMgr
66141  0      fil3HelperQueue-55-0
66144  0      VMFS6-v24-PB3-PBGC-Manager
66145  0      FS3DiskHeartbeat
66146  0      gblHelperQueue-56-0
66156  0      FS3ResMgr
66157  0      res3HelperQueueVMFS5-57-0
66158  0      res3HelperQueueVMFS5-57-1
66159  0      res3HelperQueueVMFS5-57-2
66160  0      res3HelperQueueVMFS5-57-3
66166  0      res3HelperQueueVMFS5-57-9
66167  0      res3HelperQueueVMFS5-57-10
66168  0      res3HelperQueueVMFS5-57-11
66169  0      res3HelperQueueVMFS5-57-12
66170  0      res3HelperQueueVMFS5-57-13
66171  0      res3HelperQueueVMFS5-57-14
66172  0      res3HelperQueueVMFS5-57-15
66173  0      FS3ResMgr
66174  0      res3HelperQueueVMFS6-58-0
66190  0      oio3HelperQ-59-0
66191  0      Res6AffinityMgrWorld
66192  0      AffMgr-Helper-Queue-60-0
66196  0      FSUnmapManager
66197  0      FSUnmapLockBreaker
66198  0      Unmap Helper Queue-61-0
66214  0      Unmap Helper Queue-62-0
66230  0      Unmap Helper Queue-63-0
66246  0      Unmap Helper Queue-64-0
66275  66275  sh
66286  66286  nfsgssd
66290  0      NFSv3-RemountHandler
66291  0      NFSv3-ServerMonitor
66292  0      NFSv3-LockMonitor
66294  0      tq:NFS41
66295  0      NFS41SMConnQueue-0
66296  0      NFS41SMSessQueue-0
66297  0      NFS41SMClusQueue-0
66298  0      NFS41SMNotifQueue-0
66299  0      NFS41WorkQueueGeneric-0
66300  0      NFS41WorkQueueGeneric-1
66301  0      NFS41WorkQueueGeneric-2
66302  0      NFS41WorkQueueGeneric-3
66308  0      vFlashHelperQueue-65-0
66334  66334  busybox
66338  0      rdmaAddrResQ-66-0
66339  0      rdmaCMWorkQ-67-0
66343  0      rdmaCMAWorkQ-68-0
66353  0      vrdmaHelperQueue-69-0
66359  0      ballonVMCINotificationWorld
66361  0      HBR helper queue-70-0
66369  0      HbrDemandLogWorld
66371  0      FTCptListener
66372  0      ftCptHelperQueue-71-0
66380  66380  busybox
66382  0      filtmod-watchdog
66386  0      vmotionServer
66388  0      VFC Cache Helper Queue-72-0
66521  66521  sh
66531  66531  vmware-usbarbitrator
66573  66573  sh
66586  66586  ioFilterVPServer
66589  66586  ioFilterVPServer
66621  66621  sh
66632  66632  swapobjd
66656  66656  sh
66667  66667  sdrsInjector
66675  66675  sh
66686  66686  storageRM
66785  66785  sh
66795  66795  hostdCgiServer
66796  66795  worker
66797  66795  worker
66798  66795  worker
66799  66795  worker
66800  66795  IO
66801  66795  IO
66802  66795  fair
66844  66844  sh
66860  66860  net-lbt
66913  66913  sh
66923  66923  hostd-worker
66933  66923  hostd-worker
66934  66923  hostd-worker
66936  66923  hostd-worker
66937  66923  hostd-worker
66938  66938  sh
66947  66947  rhttpproxy
66948  66947  rhttpproxy-work
66949  66947  rhttpproxy-work
66950  66947  rhttpproxy-work
66951  66947  rhttpproxy-work
66952  66947  rhttpproxy-IO
66953  66947  rhttpproxy-IO
66954  66947  rhttpproxy-fair
66955  66947  rhttpproxy-poll
66991  66923  hostd-worker
66993  66923  hostd-worker
67283  66923  hostd-poll
67295  67295  slpd
67303  67303  sh
67313  67313  dcbd
67315  0      dcb_vmklink
67323  67323  sh
67336  67336  net-cdp
67344  67344  sh
67353  67353  nscd
67354  67353  nscd
67355  67353  nscd
67356  67353  nscd
67357  67353  nscd
67358  67353  nscd
67387  67387  sh
67398  67398  smartd
67407  67407  sh
67419  67419  vpxa
67432  67419  vpxa-worker
67433  67419  vpxa-worker
67434  67419  vpxa-worker
67437  67419  vpxa-worker
67438  67419  vpxa-IO
67439  67419  vpxa-IO
67440  67419  vpxa-fair
67443  67419  vpxa-worker
67444  67419  vpxa-worker
67445  67419  vpxa-worker
67446  67419  vpxa-worker
67447  67419  vpxa-worker
67448  67419  vpxa-worker
67449  67419  vpxa-worker
67450  67419  vpxa-worker
67451  67419  vpxa-worker
67461  67419  vpxa-worker
67462  67419  vpxa-worker
67463  67419  vpxa-worker
67464  67419  vpxa-worker
67465  67419  vpxa-worker
67466  67419  vpxa-poll
67467  67419  vpxa
67468  66947  rhttpproxy-work
67505  67505  sh
67516  67516  vmtoolsd
67533  66923  hostd-worker
67534  66923  hostd-worker
67536  66923  hostd-worker
67537  66923  hostd-worker
67538  66923  hostd-worker
67566  66923  hostd-worker
67567  66923  hostd-worker
67568  66923  hostd-worker
67569  66923  hostd-worker
67571  66923  hostd-worker
67577  66923  hbr
67585  66923  hostd
67597  67597  sh
67598  67598  dcui
67628  67598  dcui
67658  66947  rhttpproxy-work
67659  66947  rhttpproxy-work
67771  67598  dcui
67772  67598  dcui
67846  67846  sshd
67849  67849  sh
67872  67872  ps


[root@esx01:~] ps -J

  WID    CID    WorldName
1
mq65770  65770  init
  tq65819  65819  wdog-65820
  x tq65820  65820  vmsyslogd
  x tq65821  65820  vmsyslogd
  x mq65822  65820  vmsyslogd
  tq65830  65830  sh
  x tq65841  65841  vobd
  x tq65845  65841  vobd
  x tq65846  65841  vobd
  x tq65847  65841  vobd
  x tq65848  65841  vobd
  x tq65849  65841  vobd
  x tq65850  65841  vobd
  x tq65851  65841  vobd
  x tq65852  65841  vobd
  x tq65853  65841  vobd
  x tq65854  65841  vobd
  x tq65855  65841  vobd
  x tq65856  65841  vobd
  x tq65857  65841  vobd
  x tq65858  65841  vobd
  x tq65859  65841  vobd
  x tq65860  65841  vobd
  x tq65873  65841  vobd
  x mq65874  65841  vobd
  tq65865  65865  sh
  x mq65872  65872  vmkeventd
  tq65949  65949  vmkdevmgr
  tq66037  66037  sh
  x tq66048  66048  net-lacp
  x tq66049  66048  net-lacp
  x mq66050  66048  net-lacp
  tq66063  66063  dhclient-uw
  tq66275  66275  sh
  x mq66286  66286  nfsgssd
  tq66334  66334  busybox
  tq66380  66380  busybox
  x mq67846  67846  sshd
  x   mq67849  67849  sh
  x     mq67888  67888  ps
  tq66521  66521  sh
  x mq66531  66531  vmware-usbarbitrator
  tq66573  66573  sh
  x tq66586  66586  ioFilterVPServer
  x mq66589  66586  ioFilterVPServer
  tq66621  66621  sh
  x mq66632  66632  swapobjd
  tq66656  66656  sh
  x mq66667  66667  sdrsInjector
  tq66675  66675  sh
  x mq66686  66686  storageRM
  tq66785  66785  sh
  x tq66795  66795  hostdCgiServer
  x tq66796  66795  worker
  x tq66797  66795  worker
  x tq66798  66795  worker
  x tq66799  66795  worker
  x tq66800  66795  IO
  x tq66801  66795  IO
  x mq66802  66795  fair
  tq66844  66844  sh
  x mq66860  66860  net-lbt
  tq66913  66913  sh
  x tq66923  66923  hostd-worker
  x tq66933  66923  hostd-worker
  x tq66934  66923  hostd-worker
  x tq66936  66923  hostd-worker
  x tq66937  66923  hostd-worker
  x tq66991  66923  hostd-worker
  x tq66993  66923  hostd-worker
  x tq67283  66923  hostd-poll
  x tq67533  66923  hostd-worker
  x tq67534  66923  hostd-worker
  x tq67536  66923  hostd-worker
  x tq67537  66923  hostd-worker
  x tq67538  66923  hostd-worker
  x tq67566  66923  hostd-worker
  x tq67567  66923  hostd-worker
  x tq67568  66923  hostd-worker
  x tq67569  66923  hostd-worker
  x tq67571  66923  hostd-worker
  x tq67577  66923  hbr
  x mq67585  66923  hostd
  tq66938  66938  sh
  x tq66947  66947  rhttpproxy
  x tq66948  66947  rhttpproxy-work
  x tq66949  66947  rhttpproxy-work
  x tq66950  66947  rhttpproxy-work
  x tq66951  66947  rhttpproxy-work
  x tq66952  66947  rhttpproxy-IO
  x tq66953  66947  rhttpproxy-IO
  x tq66954  66947  rhttpproxy-fair
  x tq66955  66947  rhttpproxy-poll
  x tq67468  66947  rhttpproxy-work
  x tq67658  66947  rhttpproxy-work
  x mq67659  66947  rhttpproxy-work
  tq67295  67295  slpd
  tq67303  67303  sh
  x mq67313  67313  dcbd
  tq67323  67323  sh
  x mq67336  67336  net-cdp
  tq67344  67344  sh
  x tq67353  67353  nscd
  x tq67354  67353  nscd
  x tq67355  67353  nscd
  x tq67356  67353  nscd
  x tq67357  67353  nscd
  x mq67358  67353  nscd
  tq67387  67387  sh
  x mq67398  67398  smartd
  tq67407  67407  sh
  x tq67419  67419  vpxa
  x tq67432  67419  vpxa-worker
  x tq67433  67419  vpxa-worker
  x tq67434  67419  vpxa-worker
  x tq67437  67419  vpxa-worker
  x tq67438  67419  vpxa-IO
  x tq67439  67419  vpxa-IO
  x tq67440  67419  vpxa-fair
  x tq67443  67419  vpxa-worker
  x tq67444  67419  vpxa-worker
  x tq67445  67419  vpxa-worker
  x tq67446  67419  vpxa-worker
  x tq67447  67419  vpxa-worker
  x tq67448  67419  vpxa-worker
  x tq67449  67419  vpxa-worker
  x tq67450  67419  vpxa-worker
  x tq67451  67419  vpxa-worker
  x tq67461  67419  vpxa-worker
  x tq67462  67419  vpxa-worker
  x tq67463  67419  vpxa-worker
  x tq67464  67419  vpxa-worker
  x tq67465  67419  vpxa-worker
  x tq67466  67419  vpxa-poll
  x mq67467  67419  vpxa
  tq67505  67505  sh
  x mq67516  67516  vmtoolsd
  tq67597  67597  sh
  tq67598  67598  dcui
  tq67628  67598  dcui
  tq67771  67598  dcui
  mq67772  67598  dcui


################################################


###################### add vcsa #########################

[root@esx01:~] df -h
Filesystem   Size   Used Available Use% Mounted on
VMFS-5      42.5G 972.0M     41.6G   2% /vmfs/volumes/datastore1
VMFS-6     299.8G  24.6G    275.2G   8% /vmfs/volumes/ds1
vfat         4.0G   6.4M      4.0G   0% /vmfs/volumes/5c53034f-1b8eeae8-02ab-000c2979903c
vfat       285.8M 209.1M     76.8M  73% /vmfs/volumes/5c530347-531c1ae6-eca6-000c2979903c
vfat       249.7M   8.0K    249.7M   0% /vmfs/volumes/b979de7a-0902ce67-7618-aac59f57f14c
vfat       249.7M 149.6M    100.1M  60% /vmfs/volumes/69ef8c73-35eee8b6-943c-71c6e577fe27
[root@esx01:~] ls
altbootbank      dev              local.tgz        proc             store            usr              vmupgrade
bin              etc              locker           productLocker    tardisks         var
bootbank         lib              mbr              sbin             tardisks.noauto  vmfs
bootpart.gz      lib64            opt              scratch          tmp              vmimages
[root@esx01:~] ps -e
ps: invalid option -- 'e'
ps
    -C           Display only cartels
    -P           Display PCID
    -T           Display used time
    -c           Display verbose command line
    -g           Display session ID and process group
    -i           Display summary information
    -j           Display GID
    -n           Display nChildren (only with --tree)
    -N           Display nThreads  (only with --tree)
    -s           Display state
    -t           Display type
    -u           Display only userworlds
    -U [N]       Display [only] userspace ID
    -v           Display non truncated values
    -Z           Display the security domain
    -z           Display zombie cartels
    -J or --tree Display userworlds in a tree layout
[root@esx01:~] ps
WID    CID    WorldName
65537  0      idle1
65538  0      idle2
65539  0      idle3
65540  0      SVGAConsole
65541  0      debugtermlivedump
65542  0      logSysAlert
65543  0      serialLogger
65544  0      tlbflushcount
65545  0      tlbflushcounttryflush
65546  0      PageRetire
65547  0      idle0
65548  0      netLegacyRx
65549  0      NetEventWorld
65550  0      netCoalesce2World
65551  0      netCoalesce2FineWorld
65552  0      ndiscWorld
65553  0      UplinkWatchdogWorld
65554  0      uplinkLoadBalancerWorld
65555  0      PktCapWorld
65556  0      PktCapSessionFreeWorld
65557  0      CmdCompl-0
65558  0      CmdCompl-1
65559  0      CmdCompl-2
65560  0      CmdCompl-3
65561  0      ScsiFilterTransWorld
65562  0      AsyncTimeout
65563  0      DeviceTaskmgmtWatchdog
65564  0      PathTaskmgmtWatchdog
65565  0      SCSI-GenPurpose-0
65566  0      directMapUnmap
65567  0      RCUWorld
65568  0      HELPER_IMMEDIATE_QUEUE-0-0
65569  0      HELPER_MISC_QUEUE-1-0
65570  0      HELPER_MISC_QUEUE-1-1
65571  0      HELPER_MISC_QUEUE-1-2
65572  0      HELPER_VMFS_JOURNAL_QUEUE-2-0
65573  0      HELPER_LVM_DRIVER_QUEUE-3-0
65574  0      HELPER_VMFS_HEARTBEAT_QUEUE-4-0
65575  0      HELPER_VMFS_HEARTBEAT_QUEUE-4-1
65576  0      HELPER_VMFS_HEARTBEAT_QUEUE-4-2
65577  0      HELPER_VMXNET2_MISC_QUEUE-5-0
65578  0      HELPER_VMXNET2_MISC_QUEUE-5-1
65579  0      HELPER_SWAP_QUEUE-6-0
65580  0      HELPER_SWAP_QUEUE-6-1
65581  0      HELPER_SWAP_QUEUE-6-2
65582  0      HELPER_SWAP_QUEUE-6-3
65583  0      HELPER_LLSWAP_QUEUE-7-0
65584  0      HELPER_MEMSCHED_QUEUE-8-0
65585  0      HELPER_SCSI_QUEUE-9-0
65586  0      HELPER_SCSI_QUEUE-9-1
65587  0      HELPER_E1000_PAGE_IN_QUEUE-10-0
65588  0      HELPER_LVM_ASYNCIO_QUEUE-11-0
65589  0      HELPER_UPLINK_ASYNC_CALL_QUEUE-12-0
65590  0      HELPER_NETWORK_MISC_QUEUE-13-0
65591  0      HELPER_NETWORK_MISC_QUEUE-13-1
65592  0      HELPER_WATCHDOG_QUEUE-14-0
65593  0      HELPER_MISC_INFRA_QUEUE-15-0
65594  0      HELPER_MISC_INFRA_QUEUE-15-1
65595  0      HELPER_MISC_INFRA_QUEUE-15-2
65596  0      HELPER_VMXNET3_PT_QUEUE-16-0
65597  0      HELPER_VMXNET3_PT_QUEUE-16-1
65598  0      HELPER_VMXNET3_STATS_QUEUE-17-0
65599  0      HELPER_PT_MANAGER_QUEUE-18-0
65600  0      HELPER_PAGERETIRE_QUEUE-19-0
65601  0      HELPER_IODM_QUEUE-20-0
65602  0      HELPER_USERMEM_QUEUE-21-0
65603  0      HELPER_DEFER_WORK_QUEUE-22-0
65604  0      systemSwapPDL
65605  0      VMK swapper helper queue-23-0
65621  0      llswap defragmenter
65622  0      gsSwapRefill
65623  0      retireWld.0000
65624  0      retireWld.0001
65625  0      retireWld.0002
65626  0      retireWld.0003
65627  0      itRebalance
65628  0      memschedRealloc-fast
65629  0      memschedRealloc
65630  0      memmetrics-periodic
65631  0      memsched-periodic
65632  0      pshare-est
65633  0      lpage-est
65634  0      lpage
65635  0      CpuSchedAgingVtimes
65636  0      CpuSchedPeriodic
65637  0      CpuMetricsLoadHistory
65638  0      CpuSchedExtendedCore
65639  0      PktSlabMemoryStats
65640  0      netpoll cleanup helpers-24-0
65642  0      PSEventHelper-25-0
65646  0      PortEventHelper-26-0
65654  0      fssAIO-27-0
65658  0      DCFlushCaches
65659  0      OCFlush
65660  0      VCHelperQueue-28-0
65676  0      devfsHelper-29-0
65677  0      bcsyncd
65678  0      BCFlush-0
65679  0      fdsAIO-30-0
65683  0      VSCSI HBA Helper Queue-31-0
65684  0      VSCSI HBA Helper Queue-31-1
65685  0      VSCSI HBA Helper Queue-31-2
65686  0      VSCSI HBA Helper Queue-31-3
65687  0      VSCSI Helper Queue-32-0
65691  0      VSCSI Emulation Helper Queue-33-0
65695  0      VSCSIPoll
65696  0      reset-handler
65697  0      reset-watchdog
65698  0      SCSI Event Framework helpers-34-0
65706  0      Storage-APD
65707  0      SCSI periodic path probe-35-0
65715  0      SCSI periodic device probe-36-0
65723  0      SCSI periodic reclaim-37-0
65724  0      SCSIDeviceSchedQCleanup
65725  0      SCSI path scan helpers-38-0
65726  0      SCSI path scan helpers-38-1
65727  0      SCSI path scan helpers-38-2
65728  0      SCSI path scan helpers-38-3
65729  0      SCSI path scan helpers-38-4
65730  0      SCSI device scan helpers-39-0
65735  0      SCSI device APD helpers-40-0
65751  0      serialSwitcher
65752  0      logterm
65753  0      logterm-scroll
65754  0      SchedPowerEnergy
65755  0      memMap-adj
65756  0      VMKPCIPassthruUnmask
65757  0      RandomEntropySpillOverHelper-41-0
65761  0      NRandomHwrng
65762  0      tq:incompatTQ
65763  0      asyncRemapHelpers-42-0
65764  0      swapglobal-groupmove
65765  0      DeviceTaskmgmtHandler
65766  0      PathTaskmgmtHandler
65767  0      serial rx tty1
65768  0      serial rx tty2
65769  0      userMemTouchEst-430383237000
65770  65770  init
65822  65822  wdog-65823
65823  65823  vmsyslogd
65824  65823  vmsyslogd
65825  65823  vmsyslogd
65833  65833  sh
65844  65844  vobd
65848  65844  vobd
65849  65844  vobd
65850  65844  vobd
65851  65844  vobd
65852  65844  vobd
65853  65844  vobd
65854  65844  vobd
65855  65844  vobd
65856  65844  vobd
65857  65844  vobd
65858  65844  vobd
65859  65844  vobd
65860  65844  vobd
65861  65844  vobd
65862  65844  vobd
65863  65844  vobd
65868  65868  sh
65875  65875  vmkeventd
65881  65844  vobd
65882  65844  vobd
65884  0      vprobeDrainEngine
65896  0      tq:VmkapiV2_1_0_0TimerQueue
65902  0      tq:vmkata
65903  0      thread taskq_0
65904  0      thread taskq_1
65905  0      thread taskq_2
65906  0      thread taskq_3
65907  0      cam.doneq0
65908  0      cam.doneq1
65909  0      cam.doneq2
65910  0      cam.doneq3
65911  0      CAM taskq
65912  0      cam.scanner
65914  0      iscsi_trans_vmklink
65915  0      tq:vmklinux
65916  0      vmklnx Helper-43-0
65917  0      vmklnx Helper-43-1
65918  0      vmklnx Helper-43-2
65919  0      vmklnx Helper-43-3
65920  0      vmklnx Helper-43-4
65921  0      vmklnx Helper-43-5
65922  0      vmklnx Helper-43-6
65923  0      vmklnx Helper-43-7
65924  0      vmklnx Helper-43-8
65925  0      vmklnx Helper-43-9
65926  0      vmklnx Helper-43-10
65927  0      vmklnx Helper-43-11
65928  0      vmklnx Helper-43-12
65929  0      vmklnx Helper-43-13
65930  0      vmklnx Helper-43-14
65931  0      vmklnx Helper-43-15
65933  0      tq:vmkusb
65934  0      thread taskq_0
65935  0      thread taskq_1
65936  0      thread taskq_2
65937  0      thread taskq_3
65938  0      cam.doneq0
65939  0      cam.doneq1
65940  0      cam.doneq2
65941  0      cam.doneq3
65942  0      CAM taskq
65943  0      cam.scanner
65944  0      usbus0
65945  0      usbus0
65946  0      usbus0
65947  0      usbus0
65948  0      usbus1
65949  0      usbus1
65950  0      usbus1
65951  0      usbus1
65952  65952  vmkdevmgr
65956  0      advUnicastAddrWorld
65957  0      MirrorAgent
65958  0      etherswitchHelper-44-0
65966  0      vmnic0-pollWorld-0
65967  0      vmnic0-pollWorld-backup
65973  0      tq:NMP
65974  0      NMP Failover Helper-45-0
65977  0      tq:VMW_SATP_LOCAL
65986  0      VMCI Helper Queue-46-0
65987  0      VMCI Socket Helper Queue-47-0
65989  0      tq:NetHealthcheck
65990  0      HC_Ticket-48-0
65991  0      L2Echo Rx
65994  0      tq:VLANMTUCheck
65996  0      HeartbeatHelper-49-0
65998  0      tq:Shaper Schedule
66000  0      tq:lldp
66003  0      IpfixHelper-50-0
66004  0      ipfix_sender
66006  0      tq:tcpip4
66007  0      tq:tcpip4-flow-affinitizer
66008  0      tcpip-isr
66009  0      Tcpip4 wtask
66010  0      TCP/IP net event Helper-51-0
66014  0      TcpipPktComp#0
66015  0      TcpipFlowCleaner_
66018  0      dvfilter-52-0
66019  0      DVFilter-ReplyWorld
66020  0      DVFilter-HeartbeatWorld
66021  0      DVFilter-Comm-XmitWorld
66022  0      DVFilter-Comm-2
66032  0      tq:dvfilter-generic-fastpath
66041  66041  sh
66052  66052  net-lacp
66053  66052  net-lacp
66054  66052  net-lacp
66056  0      Cmpl-vmhba0-0
66057  0      Cmpl-vmhba64-0
66058  0      DVS sync world
66059  0      DVSSync send world
66060  0      DVSSync ack world
66061  0      DVSSync recv world
66063  0      vmk0-rx-0
66064  0      vmk0-tx
66067  66067  dhclient-uw
66079  0      COWRECacheMgr
66082  0      SunRPCAsyncIO-0
66083  0      SunRPCAsyncIO-1
66084  0      SunRPC GSS CTX Monitor
66088  0      J6ReplayHelper-53-0
66104  0      asyncReplayHelperQueue-54-0
66120  0      Vol3JournalExtendMgrWorld
66121  0      FS3FdUnlockMgr
66122  0      fil3HelperQueue-55-0
66125  0      VMFS6-v24-PB3-PBGC-Manager
66126  0      FS3DiskHeartbeat
66127  0      gblHelperQueue-56-0
66137  0      FS3ResMgr
66138  0      res3HelperQueueVMFS5-57-0
66154  0      FS3ResMgr
66155  0      res3HelperQueueVMFS6-58-0
66171  0      oio3HelperQ-59-0
66172  0      Res6AffinityMgrWorld
66173  0      AffMgr-Helper-Queue-60-0
66177  0      FSUnmapManager
66178  0      FSUnmapLockBreaker
66179  0      Unmap Helper Queue-61-0
66195  0      Unmap Helper Queue-62-0
66211  0      Unmap Helper Queue-63-0
66227  0      Unmap Helper Queue-64-0
66256  66256  sh
66269  66269  nfsgssd
66271  0      NFSv3-RemountHandler
66272  0      NFSv3-ServerMonitor
66273  0      NFSv3-LockMonitor
66275  0      tq:NFS41
66276  0      NFS41SMConnQueue-0
66277  0      NFS41SMSessQueue-0
66278  0      NFS41SMClusQueue-0
66279  0      NFS41SMNotifQueue-0
66280  0      NFS41WorkQueueGeneric-0
66281  0      NFS41WorkQueueGeneric-1
66282  0      NFS41WorkQueueGeneric-2
66283  0      NFS41WorkQueueGeneric-3
66289  0      vFlashHelperQueue-65-0
66315  66315  busybox
66319  0      rdmaAddrResQ-66-0
66320  0      rdmaCMWorkQ-67-0
66324  0      rdmaCMAWorkQ-68-0
66334  0      vrdmaHelperQueue-69-0
66340  0      ballonVMCINotificationWorld
66342  0      HBR helper queue-70-0
66350  0      HbrDemandLogWorld
66352  0      FTCptListener
66353  0      ftCptHelperQueue-71-0
66360  66360  busybox
66363  0      filtmod-watchdog
66367  0      vmotionServer
66369  0      VFC Cache Helper Queue-72-0
66503  66503  sh
66513  66513  vmware-usbarbitrator
66562  66562  sh
66572  66572  ioFilterVPServer
66576  66572  ioFilterVPServer
66599  66599  sh
66610  66610  swapobjd
66634  66634  sh
66643  66643  sdrsInjector
66651  66651  sh
66660  66660  storageRM
66760  66760  sh
66771  66771  hostdCgiServer
66772  66771  worker
66773  66771  worker
66774  66771  worker
66775  66771  worker
66776  66771  IO
66777  66771  IO
66778  66771  fair
66823  66823  sh
66838  66838  net-lbt
66886  66886  sh
66895  66895  hostd-worker
66905  66895  hostd-worker
66906  66895  hostd-worker
66907  66895  hostd-worker
66908  66895  hostd-worker
66909  66909  sh
66920  66920  rhttpproxy
66921  66920  rhttpproxy-work
66922  66920  rhttpproxy-work
66923  66920  rhttpproxy-work
66924  66920  rhttpproxy-work
66925  66920  rhttpproxy-IO
66926  66920  rhttpproxy-IO
66927  66920  rhttpproxy-fair
66928  66920  rhttpproxy-poll
66968  66895  hostd-worker
66969  66895  hostd-worker
66970  66895  hostd-worker
66972  66895  hostd-worker
67258  66895  hostd-poll
67270  67270  slpd
67278  67278  sh
67291  67291  dcbd
67292  0      dcb_vmklink
67300  67300  sh
67309  67309  net-cdp
67317  67317  sh
67328  67328  nscd
67329  67328  nscd
67330  67328  nscd
67331  67328  nscd
67332  67328  nscd
67333  67328  nscd
67364  67364  sh
67375  67375  smartd
67390  67390  sh
67401  67401  vpxa
67403  67401  vpxa-worker
67404  67401  vpxa-worker
67405  67401  vpxa-worker
67406  67401  vpxa-worker
67407  67401  vpxa-IO
67408  67401  vpxa-IO
67409  67401  vpxa-fair
67418  67401  vpxa-worker
67419  67401  vpxa-worker
67420  67401  vpxa-worker
67421  67401  vpxa-worker
67422  67401  vpxa-worker
67423  67401  vpxa-worker
67424  67401  vpxa-worker
67425  67401  vpxa-worker
67426  67401  vpxa-worker
67436  67401  vpxa-worker
67437  67401  vpxa-worker
67438  67401  vpxa-worker
67439  67401  vpxa-worker
67440  67401  vpxa-worker
67441  67401  vpxa-poll
67442  67401  vpxa
67443  66920  rhttpproxy-work
67479  67479  sh
67490  67490  vmtoolsd
67505  66895  hostd-worker
67506  66895  hostd-worker
67507  66895  hostd-worker
67535  66895  hostd-worker
67536  66895  hostd-worker
67537  66895  hostd-worker
67541  66895  hbr
67546  66895  hostd
67570  67570  sh
67571  67571  dcui
67598  67571  dcui
67607  66920  rhttpproxy-work
67617  66920  rhttpproxy-work
67743  0      vmnic0-0-tx
67789  66920  rhttpproxy-work
67848  0      res3HelperQueueVMFS6-58-1
67854  0      res3HelperQueueVMFS6-58-2
67856  0      res3HelperQueueVMFS6-58-3
67858  0      res3HelperQueueVMFS6-58-4
67862  0      res3HelperQueueVMFS6-58-5
67864  0      res3HelperQueueVMFS6-58-6
67865  0      res3HelperQueueVMFS6-58-7
67866  0      res3HelperQueueVMFS6-58-8
67874  66920  rhttpproxy-work
67899  0      res3HelperQueueVMFS6-58-9
67921  0      res3HelperQueueVMFS6-58-10
67944  0      res3HelperQueueVMFS6-58-11
67954  0      res3HelperQueueVMFS6-58-12
67991  0      res3HelperQueueVMFS6-58-13
67993  0      res3HelperQueueVMFS6-58-14
67994  0      res3HelperQueueVMFS6-58-15
68109  0      J6AsyncReplayManager
68125  68125  vmx
68126  0      vmm0:vc01
68127  0      NetWorld-VM-68126
68128  0      vmast.68126
68129  0      vmm1:vc01
68130  68125  vmx-vthread-6
68131  68125  vmx-vthread-7:vc01
68132  68125  vmx-vthread-8:vc01
68133  68125  vmx-vthread-9:vc01
68134  68125  vmx-mks:vc01
68135  68125  vmx-svga:vc01
68136  68125  vmx-vcpu-0:vc01
68137  0      LSI-68126:0
68138  0      LSI-68126:1
68139  68125  vmx-vcpu-1:vc01
68445  0      SCSI periodic device probe-36-3
68620  0      SCSI periodic device probe-36-2
68621  0      SCSI periodic path probe-35-2
68650  0      SCSI periodic device probe-36-3
68651  0      SCSI periodic path probe-35-3
68680  0      res3HelperQueueVMFS5-57-1
68685  0      res3HelperQueueVMFS5-57-2
68695  0      res3HelperQueueVMFS5-57-3
68696  66920  rhttpproxy-work
68697  66920  rhttpproxy-work
68698  66920  rhttpproxy-work
68699  66920  rhttpproxy-work
68700  66920  rhttpproxy-work
68701  66920  rhttpproxy-work
68702  66920  rhttpproxy-work
68703  66920  rhttpproxy-work
68710  0      RandomEntropySpillOverHelper-41-1
68729  68729  sshd
68732  68732  sh
68740  0      res3HelperQueueVMFS5-57-4
68741  0      res3HelperQueueVMFS5-57-5
68742  0      RandomEntropySpillOverHelper-41-2
68743  0      res3HelperQueueVMFS5-57-6
68744  0      res3HelperQueueVMFS5-57-7
68748  68748  ps

[root@esx01:~] ps -J

  WID    CID    WorldName
1
mq65770  65770  init
  tq65822  65822  wdog-65823
  x tq65823  65823  vmsyslogd
  x tq65824  65823  vmsyslogd
  x mq65825  65823  vmsyslogd
  tq65833  65833  sh
  x tq65844  65844  vobd
  x tq65848  65844  vobd
  x tq65849  65844  vobd
  x tq65850  65844  vobd
  x tq65851  65844  vobd
  x tq65852  65844  vobd
  x tq65853  65844  vobd
  x tq65854  65844  vobd
  x tq65855  65844  vobd
  x tq65856  65844  vobd
  x tq65857  65844  vobd
  x tq65858  65844  vobd
  x tq65859  65844  vobd
  x tq65860  65844  vobd
  x tq65861  65844  vobd
  x tq65862  65844  vobd
  x tq65863  65844  vobd
  x tq65881  65844  vobd
  x mq65882  65844  vobd
  tq65868  65868  sh
  x mq65875  65875  vmkeventd
  tq65952  65952  vmkdevmgr
  tq66041  66041  sh
  x tq66052  66052  net-lacp
  x tq66053  66052  net-lacp
  x mq66054  66052  net-lacp
  tq66067  66067  dhclient-uw
  tq66256  66256  sh
  x mq66269  66269  nfsgssd
  tq66315  66315  busybox
  tq66360  66360  busybox
  x mq68729  68729  sshd
  x   mq68732  68732  sh
  x     mq68749  68749  ps
  tq66503  66503  sh
  x mq66513  66513  vmware-usbarbitrator
  tq66562  66562  sh
  x tq66572  66572  ioFilterVPServer
  x mq66576  66572  ioFilterVPServer
  tq66599  66599  sh
  x mq66610  66610  swapobjd
  tq66634  66634  sh
  x mq66643  66643  sdrsInjector
  tq66651  66651  sh
  x mq66660  66660  storageRM
  tq66760  66760  sh
  x tq66771  66771  hostdCgiServer
  x tq66772  66771  worker
  x tq66773  66771  worker
  x tq66774  66771  worker
  x tq66775  66771  worker
  x tq66776  66771  IO
  x tq66777  66771  IO
  x mq66778  66771  fair
  tq66823  66823  sh
  x mq66838  66838  net-lbt
  tq66886  66886  sh
  x tq66895  66895  hostd-worker
  x tq66905  66895  hostd-worker
  x tq66906  66895  hostd-worker
  x tq66907  66895  hostd-worker
  x tq66908  66895  hostd-worker
  x tq66968  66895  hostd-worker
  x tq66969  66895  hostd-worker
  x tq66970  66895  hostd-worker
  x tq66972  66895  hostd-worker
  x tq67258  66895  hostd-poll
  x tq67505  66895  hostd-worker
  x tq67506  66895  hostd-worker
  x tq67507  66895  hostd-worker
  x tq67535  66895  hostd-worker
  x tq67536  66895  hostd-worker
  x tq67537  66895  hostd-worker
  x tq67541  66895  hbr
  x mq67546  66895  hostd
  tq66909  66909  sh
  x tq66920  66920  rhttpproxy
  x tq66921  66920  rhttpproxy-work
  x tq66922  66920  rhttpproxy-work
  x tq66923  66920  rhttpproxy-work
  x tq66924  66920  rhttpproxy-work
  x tq66925  66920  rhttpproxy-IO
  x tq66926  66920  rhttpproxy-IO
  x tq66927  66920  rhttpproxy-fair
  x tq66928  66920  rhttpproxy-poll
  x tq67443  66920  rhttpproxy-work
  x tq67607  66920  rhttpproxy-work
  x tq67617  66920  rhttpproxy-work
  x tq67789  66920  rhttpproxy-work
  x tq67874  66920  rhttpproxy-work
  x tq68696  66920  rhttpproxy-work
  x tq68697  66920  rhttpproxy-work
  x tq68698  66920  rhttpproxy-work
  x tq68699  66920  rhttpproxy-work
  x tq68700  66920  rhttpproxy-work
  x tq68701  66920  rhttpproxy-work
  x tq68702  66920  rhttpproxy-work
  x mq68703  66920  rhttpproxy-work
  tq67270  67270  slpd
  tq67278  67278  sh
  x mq67291  67291  dcbd
  tq67300  67300  sh
  x mq67309  67309  net-cdp
  tq67317  67317  sh
  x tq67328  67328  nscd
  x tq67329  67328  nscd
  x tq67330  67328  nscd
  x tq67331  67328  nscd
  x tq67332  67328  nscd
  x mq67333  67328  nscd
  tq67364  67364  sh
  x mq67375  67375  smartd
  tq67390  67390  sh
  x tq67401  67401  vpxa
  x tq67403  67401  vpxa-worker
  x tq67404  67401  vpxa-worker
  x tq67405  67401  vpxa-worker
  x tq67406  67401  vpxa-worker
  x tq67407  67401  vpxa-IO
  x tq67408  67401  vpxa-IO
  x tq67409  67401  vpxa-fair
  x tq67418  67401  vpxa-worker
  x tq67419  67401  vpxa-worker
  x tq67420  67401  vpxa-worker
  x tq67421  67401  vpxa-worker
  x tq67422  67401  vpxa-worker
  x tq67423  67401  vpxa-worker
  x tq67424  67401  vpxa-worker
  x tq67425  67401  vpxa-worker
  x tq67426  67401  vpxa-worker
  x tq67436  67401  vpxa-worker
  x tq67437  67401  vpxa-worker
  x tq67438  67401  vpxa-worker
  x tq67439  67401  vpxa-worker
  x tq67440  67401  vpxa-worker
  x tq67441  67401  vpxa-poll
  x mq67442  67401  vpxa
  tq67479  67479  sh
  x mq67490  67490  vmtoolsd
  tq67570  67570  sh
  tq67571  67571  dcui
  tq67598  67571  dcui
  tq68125  68125  vmx
  tq68130  68125  vmx-vthread-6
  tq68131  68125  vmx-vthread-7:vc01
  tq68132  68125  vmx-vthread-8:vc01
  tq68133  68125  vmx-vthread-9:vc01
  tq68134  68125  vmx-mks:vc01
  tq68135  68125  vmx-svga:vc01
  tq68136  68125  vmx-vcpu-0:vc01
  mq68139  68125  vmx-vcpu-1:vc01

[root@esx01:~] cat /etc/passwd
root:x:0:0:Administrator:/:/bin/sh
daemon:x:2:2:System daemons:/:/sbin/nologin
nfsnobody:x:65534:65534:Anonymous NFS User:/:/sbin/nologin
dcui:x:100:100:DCUI User:/:/sbin/nologin
vpxuser:x:500:100:VMware VirtualCenter administration account:/:/sbin/nologin

#################################################33


#### inside vcsa ############

login as: root

VMware vCenter Server Appliance 6.5.0.23000

Type: vCenter Server with an embedded Platform Services Controller

root@192.168.75.135's password:
Connected to service

    * List APIs: "help api list"
    * List Plugins: "help pi list"
    * Launch BASH: "shell"

Command> shell
Shell access is granted to root
root@photon-machine [ ~ ]# df -h
Filesystem                                Size  Used Avail Use% Mounted on
devtmpfs                                  4.9G     0  4.9G   0% /dev
tmpfs                                     4.9G   24K  4.9G   1% /dev/shm
tmpfs                                     4.9G  696K  4.9G   1% /run
tmpfs                                     4.9G     0  4.9G   0% /sys/fs/cgroup
/dev/sda3                                  11G  4.1G  6.0G  41% /
tmpfs                                     4.9G  1.5M  4.9G   1% /tmp
/dev/sda1                                 120M   35M   80M  30% /boot
/dev/mapper/core_vg-core                   25G   45M   24G   1% /storage/core
/dev/mapper/log_vg-log                    9.8G   42M  9.2G   1% /storage/log
/dev/mapper/db_vg-db                      9.8G   95M  9.2G   2% /storage/db
/dev/mapper/dblog_vg-dblog                 15G  102M   14G   1% /storage/dblog
/dev/mapper/seat_vg-seat                  9.8G   49M  9.2G   1% /storage/seat
/dev/mapper/netdump_vg-netdump            985M  1.3M  932M   1% /storage/netdump
/dev/mapper/autodeploy_vg-autodeploy      9.8G   23M  9.2G   1% /storage/autodeploy
/dev/mapper/imagebuilder_vg-imagebuilder  9.8G   23M  9.2G   1% /storage/imagebuilder
/dev/mapper/updatemgr_vg-updatemgr         99G   75M   94G   1% /storage/updatemgr
root@photon-machine [ ~ ]# cat /etc/passwd
root:x:0:0:root:/root:/bin/appliancesh
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon User:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
systemd-bus-proxy:x:72:72:systemd Bus Proxy:/:/bin/false
systemd-journal-gateway:x:73:73:systemd Journal Gateway:/:/bin/false
systemd-journal-remote:x:74:74:systemd Journal Remote:/:/bin/false
systemd-journal-upload:x:75:75:systemd Journal Upload:/:/bin/false
systemd-network:x:76:76:systemd Network Management:/:/bin/false
systemd-resolve:x:77:77:systemd Resolver:/:/bin/false
systemd-timesync:x:78:78:systemd Time Synchronization:/:/bin/false
nobody:x:65534:65533:Unprivileged User:/dev/null:/bin/false
sshd:x:50:50:sshd PrivSep:/var/lib/sshd:/bin/false
named:x:999:999::/var/lib/bind:/bin/false
rpc:x:31:31::/var/lib/rpcbind:/bin/false
tftp:x:998:998:tftp:/home/tftp:/sbin/nologin
apache:x:25:25:Apache Server:/srv/www:/bin/false
ntp:x:87:87:Network Time Protocol:/var/lib/ntp:/bin/false
smmsp:x:26:26:Sendmail Daemon:/dev/null:/bin/false
cm:x:1001:100::/home/cm:/bin/bash
netdumper:x:1015:997:VMware Netdumper User:/var/core/netdumps:/sbin/nologin
vapiEndpoint:x:1002:100::/home/vapiEndpoint:/bin/bash
mbcs:x:1004:100::/home/mbcs:/bin/bash
content-library:x:1006:100::/home/content-library:/bin/bash
eam:x:1005:100::/home/eam:/bin/bash
imagebuilder:x:1007:100:imagebuilder:/usr/lib/vmware-imagebuilder:/sbin/nologin
deploy:x:1019:996:Deploy User:/var/lib/rbd:/sbin/nologin
updatemgr:x:1017:995:Update Manager User:/usr/lib/vmware-updatemgr:/sbin/nologin
vsan-health:x:1008:100::/home/vsan-health:/bin/bash
vsm:x:1009:100::/home/vsm:/bin/bash
vsphere-client:x:1010:100::/home/vsphere-client:/bin/bash
perfcharts:x:1011:100::/home/perfcharts:/bin/bash
vsphere-ui:x:1016:100::/home/vsphere-ui:/bin/bash
dnsmasq:x:997:994::/home/dnsmasq:/bin/appliancesh
vpostgres:x:1012:100::/opt/vmware/vpostgres/9.4:/sbin/nologin
vpxd:x:1014:59001::/home/vpxd:/bin/false
root@photon-machine [ ~ ]# cd /etc/vmware
vmware/                 vmware-imagebuilder/    vmware-rhttpproxy/      vmware-tools/           vmware-vsan-health/
vmware-cis-license/     vmware-mbcs/            vmware-sca/             vmware-vapi/            vmware-vsm/
vmware-content-library/ vmware-netdump/         vmware-sps/             vmware-vcha/
vmware-eam/             vmware-perfcharts/      vmware-sso/             vmware-vpx/
vmware-identity/        vmware-rbd/             vmware-syslog/          vmware-vpxd-svcs/
root@photon-machine [ ~ ]# cd /etc/vmware-vpx
vmware-vpx/       vmware-vpxd-svcs/
root@photon-machine [ ~ ]# cd /etc/vmware-vpx
root@photon-machine [ /etc/vmware-vpx ]# ls
coreLocale         licenses               proxy.xml              vami-sfcb.tpl        vsan_mo.xml
core.schema.patch  locale                 rhttpproxy.properties  vcdb.properties      vsan_types_default.xml
docRoot            odbc.ini.postgres.tpl  sca-config.prop        vcdb.properties.tpl  vsan_types.xml
embedded_db.cfg    odbc.ini.tpl           ssl                    vcdbsupport.xml
extensions         odbcinst.ini.tpl       startup                vc-extn-cisreg.prop
firstboot          oracle                 syslog-ng.conf         vpxd.cfg
instance.cfg       pre-startup            sysprep                vsan_mo_default.xml
root@photon-machine [ /etc/vmware-vpx ]# cat vcdb.properties
driver = org.postgresql.Driver
dbtype = PostgreSQL
url = jdbc:postgresql://localhost:5432/VCDB
username = vc
password = BbRU)2%|>SxAMC3?
password.encrypted = false
root@photon-machine [ /etc/vmware-vpx ]# ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 15:27 ?        00:00:08 /lib/systemd/systemd --switched-root --system --deserialize 21
root         2     0  0 15:27 ?        00:00:00 [kthreadd]
root         3     2  0 15:27 ?        00:00:01 [ksoftirqd/0]
root         5     2  0 15:27 ?        00:00:00 [kworker/0:0H]
root         7     2  0 15:27 ?        00:00:02 [rcu_sched]
root         8     2  0 15:27 ?        00:00:00 [rcu_bh]
root         9     2  0 15:27 ?        00:00:00 [migration/0]
root        10     2  0 15:27 ?        00:00:00 [watchdog/0]
root        11     2  0 15:27 ?        00:00:00 [watchdog/1]
root        12     2  0 15:27 ?        00:00:00 [migration/1]
root        13     2  0 15:27 ?        00:00:01 [ksoftirqd/1]
root        15     2  0 15:27 ?        00:00:00 [kworker/1:0H]
root        16     2  0 15:27 ?        00:00:00 [kdevtmpfs]
root        17     2  0 15:27 ?        00:00:00 [netns]
root        18     2  0 15:27 ?        00:00:00 [perf]
root        19     2  0 15:27 ?        00:00:00 [khungtaskd]
root        20     2  0 15:27 ?        00:00:00 [writeback]
root        21     2  0 15:27 ?        00:00:00 [ksmd]
root        23     2  0 15:27 ?        00:00:13 [khugepaged]
root        24     2  0 15:27 ?        00:00:00 [crypto]
root        25     2  0 15:27 ?        00:00:00 [kintegrityd]
root        26     2  0 15:27 ?        00:00:00 [bioset]
root        27     2  0 15:27 ?        00:00:00 [kblockd]
root        28     2  0 15:27 ?        00:00:00 [ata_sff]
root        29     2  0 15:27 ?        00:00:00 [devfreq_wq]
root        31     2  0 15:27 ?        00:00:00 [kswapd0]
root        32     2  0 15:27 ?        00:00:00 [vmstat]
root        33     2  0 15:27 ?        00:00:00 [fsnotify_mark]
root        34     2  0 15:27 ?        00:00:00 [xfsalloc]
root        35     2  0 15:27 ?        00:00:00 [xfs_mru_cache]
root        47     2  0 15:27 ?        00:00:00 [kthrotld]
root        48     2  0 15:27 ?        00:00:00 [acpi_thermal_pm]
root        49     2  0 15:27 ?        00:00:00 [ttm_swap]
root        50     2  0 15:27 ?        00:00:00 [bioset]
root        51     2  0 15:27 ?        00:00:00 [bioset]
root        52     2  0 15:27 ?        00:00:00 [bioset]
root        53     2  0 15:27 ?        00:00:00 [bioset]
root        54     2  0 15:27 ?        00:00:00 [bioset]
root        55     2  0 15:27 ?        00:00:00 [bioset]
root        56     2  0 15:27 ?        00:00:00 [bioset]
root        57     2  0 15:27 ?        00:00:00 [bioset]
root        58     2  0 15:27 ?        00:00:00 [bioset]
root        59     2  0 15:27 ?        00:00:00 [bioset]
root        60     2  0 15:27 ?        00:00:00 [bioset]
root        61     2  0 15:27 ?        00:00:00 [bioset]
root        62     2  0 15:27 ?        00:00:00 [bioset]
root        63     2  0 15:27 ?        00:00:00 [bioset]
root        64     2  0 15:27 ?        00:00:00 [bioset]
root        65     2  0 15:27 ?        00:00:00 [bioset]
root        66     2  0 15:27 ?        00:00:00 [bioset]
root        67     2  0 15:27 ?        00:00:00 [bioset]
root        68     2  0 15:27 ?        00:00:00 [bioset]
root        69     2  0 15:27 ?        00:00:00 [bioset]
root        70     2  0 15:27 ?        00:00:00 [bioset]
root        71     2  0 15:27 ?        00:00:00 [bioset]
root        72     2  0 15:27 ?        00:00:00 [bioset]
root        73     2  0 15:27 ?        00:00:00 [bioset]
root        74     2  0 15:27 ?        00:00:00 [iscsi_eh]
root        75     2  0 15:27 ?        00:00:00 [kmpath_rdacd]
root        76     2  0 15:27 ?        00:00:00 [scsi_eh_0]
root        77     2  0 15:27 ?        00:00:00 [scsi_tmf_0]
root        78     2  0 15:27 ?        00:00:00 [scsi_eh_1]
root        79     2  0 15:27 ?        00:00:00 [scsi_tmf_1]
root        82     2  0 15:27 ?        00:00:00 [mpt_poll_0]
root        83     2  0 15:27 ?        00:00:00 [mpt/0]
root        84     2  0 15:27 ?        00:00:00 [bioset]
root        87     2  0 15:27 ?        00:00:00 [scsi_eh_2]
root        88     2  0 15:27 ?        00:00:00 [scsi_tmf_2]
root        89     2  0 15:27 ?        00:00:00 [bioset]
root        90     2  0 15:27 ?        00:00:00 [mpt_poll_1]
root        91     2  0 15:27 ?        00:00:00 [mpt/1]
root        93     2  0 15:27 ?        00:00:00 [bioset]
root        95     2  0 15:27 ?        00:00:00 [bioset]
root        97     2  0 15:27 ?        00:00:00 [bioset]
root        99     2  0 15:27 ?        00:00:00 [bioset]
root       101     2  0 15:27 ?        00:00:00 [bioset]
root       103     2  0 15:27 ?        00:00:00 [bioset]
root       105     2  0 15:27 ?        00:00:00 [bioset]
root       107     2  0 15:27 ?        00:00:00 [bioset]
root       109     2  0 15:27 ?        00:00:00 [bioset]
root       111     2  0 15:27 ?        00:00:00 [bioset]
root       113     2  0 15:27 ?        00:00:00 [bioset]
root       121     2  0 15:27 ?        00:00:00 [scsi_eh_3]
root       122     2  0 15:27 ?        00:00:00 [scsi_tmf_3]
root       125     2  0 15:27 ?        00:00:00 [ipv6_addrconf]
root       128     2  0 15:27 ?        00:00:00 [deferwq]
root       184     2  0 15:27 ?        00:00:00 [kauditd]
root       312     2  0 15:27 ?        00:00:03 [kworker/0:1H]
root       320     2  0 15:27 ?        00:00:02 [kworker/1:1H]
root       337     2  0 15:27 ?        00:00:04 [jbd2/sda3-8]
root       338     2  0 15:27 ?        00:00:00 [ext4-rsv-conver]
root       405     1  0 15:27 ?        00:00:00 /usr/sbin/dmeventd -f
root       420     1  0 15:27 ?        00:00:02 /lib/systemd/systemd-journald
root       428     1  0 15:27 ?        00:00:00 /usr/sbin/lvmetad -f
root       445     1  0 15:27 ?        00:00:01 /lib/systemd/systemd-udevd
root       589     2  0 15:27 ?        00:00:00 [kpsmoused]
root       672     2  0 15:27 ?        00:00:00 [jbd2/sda1-8]
root       673     2  0 15:27 ?        00:00:00 [ext4-rsv-conver]
root       682     1  0 15:27 ?        00:00:00 /sbin/auditd -n
message+   710     1  0 15:29 ?        00:00:01 /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --syst
root       714     1  0 15:29 ?        00:00:01 /usr/sbin/haveged -w 1024 -v 1 --Foreground
root       715     1  0 15:29 ?        00:00:00 /lib/systemd/systemd-logind
root       716     1  0 15:29 ?        00:00:00 /usr/bin/VGAuthService -s
root       731     1  0 15:29 ?        00:00:00 /usr/sbin/irqbalance --foreground
root       741     1  0 15:29 ?        00:00:00 /usr/sbin/saslauthd -m /run/saslauthd -a pam
root       742   741  0 15:29 ?        00:00:00 /usr/sbin/saslauthd -m /run/saslauthd -a pam
root       743   741  0 15:29 ?        00:00:00 /usr/sbin/saslauthd -m /run/saslauthd -a pam
root       744   741  0 15:29 ?        00:00:00 /usr/sbin/saslauthd -m /run/saslauthd -a pam
root       745   741  0 15:29 ?        00:00:00 /usr/sbin/saslauthd -m /run/saslauthd -a pam
root       749     1  0 15:29 tty1     00:00:00 /sbin/agetty --noclear tty1 linux
root       757     1  0 15:29 ?        00:00:00 /usr/sbin/crond -n
root       773     1  0 15:29 ?        00:00:00 /usr/sbin/xinetd -stayalive -pidfile /var/run/xinetd.pid
root       836     1  0 15:29 ?        00:00:10 /usr/bin/vmtoolsd
root      1151     2  0 15:34 ?        00:00:01 [kworker/1:0]
root      1262     1  0 15:35 tty2     00:00:01 /usr/bin/python /usr/lib/applmgmt/base/bin/vherdrunner /usr/lib/applmgmt/dcu
root      1913     2  0 15:40 ?        00:00:00 [kdmflush]
root      1914     2  0 15:40 ?        00:00:00 [bioset]
root      1991     2  0 15:40 ?        00:00:00 [kdmflush]
root      1992     2  0 15:40 ?        00:00:00 [bioset]
root      2046     2  0 15:40 ?        00:00:00 [kdmflush]
root      2048     2  0 15:40 ?        00:00:00 [bioset]
root      2097     2  0 15:40 ?        00:00:00 [kdmflush]
root      2098     2  0 15:40 ?        00:00:00 [bioset]
root      2153     2  0 15:40 ?        00:00:00 [kdmflush]
root      2154     2  0 15:40 ?        00:00:00 [bioset]
root      2213     2  0 15:41 ?        00:00:00 [kdmflush]
root      2215     2  0 15:41 ?        00:00:00 [bioset]
root      2272     2  0 15:41 ?        00:00:00 [kdmflush]
root      2273     2  0 15:41 ?        00:00:00 [bioset]
root      2331     2  0 15:41 ?        00:00:00 [kdmflush]
root      2333     2  0 15:41 ?        00:00:00 [bioset]
root      2392     2  0 15:41 ?        00:00:00 [kdmflush]
root      2393     2  0 15:41 ?        00:00:00 [bioset]
root      2458     2  0 15:41 ?        00:00:00 [kdmflush]
root      2460     2  0 15:41 ?        00:00:00 [bioset]
root      2478     2  0 15:41 ?        00:00:00 [kworker/u128:2]
root      2502     2  0 15:41 ?        00:00:00 [jbd2/dm-1-8]
root      2503     2  0 15:41 ?        00:00:00 [ext4-rsv-conver]
root      2505     2  0 15:41 ?        00:00:02 [jbd2/dm-2-8]
root      2506     2  0 15:41 ?        00:00:00 [ext4-rsv-conver]
root      2507     2  0 15:41 ?        00:00:01 [jbd2/dm-3-8]
root      2508     2  0 15:41 ?        00:00:00 [ext4-rsv-conver]
root      2509     2  0 15:41 ?        00:00:00 [jbd2/dm-4-8]
root      2510     2  0 15:41 ?        00:00:00 [ext4-rsv-conver]
root      2511     2  0 15:41 ?        00:00:01 [jbd2/dm-5-8]
root      2512     2  0 15:41 ?        00:00:00 [ext4-rsv-conver]
root      2513     2  0 15:41 ?        00:00:00 [jbd2/dm-6-8]
root      2514     2  0 15:41 ?        00:00:00 [ext4-rsv-conver]
root      2515     2  0 15:41 ?        00:00:00 [jbd2/dm-7-8]
root      2516     2  0 15:41 ?        00:00:00 [ext4-rsv-conver]
root      2517     2  0 15:41 ?        00:00:00 [jbd2/dm-8-8]
root      2518     2  0 15:41 ?        00:00:00 [ext4-rsv-conver]
root      2519     2  0 15:41 ?        00:00:00 [jbd2/dm-9-8]
root      2520     2  0 15:41 ?        00:00:00 [ext4-rsv-conver]
systemd+  3965     1  0 15:45 ?        00:00:00 /lib/systemd/systemd-networkd
systemd+  4154     1  0 15:45 ?        00:00:00 /lib/systemd/systemd-resolved
dnsmasq   4167     1  0 15:45 ?        00:00:00 /usr/sbin/dnsmasq -k
rpc       4247     1  0 15:45 ?        00:00:00 /usr/sbin/rpcbind -w
root      4748     1  0 15:48 ?        00:00:00 /opt/likewise/sbin/lwsmd --start-as-daemon --syslog
root      4753  4748  0 15:48 ?        00:00:08 /opt/likewise/sbin/lwregd --syslog
root      4764  4748  0 15:48 ?        00:00:00 /opt/likewise/sbin/netlogond --syslog
root      4768  4748  0 15:48 ?        00:00:00 /opt/likewise/sbin/lwiod --syslog
root      4773  4748  0 15:48 ?        00:00:00 /opt/likewise/sbin/lsassd --syslog
root      4815  4748  0 15:48 ?        00:00:00 /opt/likewise/sbin/dcerpcd -f
root      4823  4748  0 15:48 ?        00:00:12 /usr/lib/vmware-vmafd/sbin/vmafdd -s
root      5071  4748  0 15:48 ?        00:00:00 /usr/lib/vmware-vmca/sbin/vmcad -s
root      5367  4748  0 15:48 ?        00:00:15 /usr/lib/vmware-vmdir/sbin/vmdird -s -l 0 -f /usr/lib/vmware-vmdir/share/con
root      5429  4748  0 15:49 ?        00:00:01 /usr/lib/vmware-vmdns/sbin/vmdnsd -s
root      5676     1  0 15:49 ?        00:00:00 vmware-sts-idmd -procname vmware-sts-idmd -wait 120 -server -Xmx168m -XX:Com
root      5677  5676  1 15:49 ?        00:00:30 vmware-sts-idmd -procname vmware-sts-idmd -wait 120 -server -Xmx168m -XX:Com
root      6082     1  0 15:49 ?        00:00:00 vmware-stsd -procname vmware-stsd -home /usr/java/jre-vmware -server -pidfil
root      6084  6082  6 15:49 ?        00:01:52 vmware-stsd -procname vmware-stsd -home /usr/java/jre-vmware -server -pidfil
root      7100     2  0 15:50 ?        00:00:00 [kworker/0:3]
root      7114     2  0 15:50 ?        00:00:00 [kworker/u128:1]
root      7120     1  0 15:50 ?        00:00:00 /usr/lib/vmware-vmon/vmon
root      7155  7120  0 15:50 ?        00:00:08 /usr/lib/vmware-rhttpproxy/rhttpproxy -r /etc/vmware-rhttpproxy/config.xml -
root      7429  7120  1 15:50 ?        00:00:31 /usr/java/jre-vmware/bin/vmware-cm.launcher -Xmx100m -XX:CompressedClassSpac
root      8118  7120  1 15:51 ?        00:00:18 /usr/java/jre-vmware/bin/vmware-cis-license.launcher -Xmx128m -XX:Compressed
root      8333     1  0 15:51 ?        00:00:00 vmware-psc-client -procname vmware-psc-client -home /usr/java/jre-vmware -se
root      8334  8333  3 15:51 ?        00:00:53 vmware-psc-client -procname vmware-psc-client -home /usr/java/jre-vmware -se
root      8826  7120  1 15:52 ?        00:00:24 /usr/java/jre-vmware/bin/vmware-sca.launcher -Xmx64m -XX:CompressedClassSpac
vapiEnd+  9350  7120  3 15:52 ?        00:00:51 /usr/java/jre-vmware/bin/vmware-vapi-endpoint.launcher -Xmx160m -XX:Compress
root      9743  7120  0 15:53 ?        00:00:00 /usr/lib/vmware-vmon/vapi/vmon-vapi-provider -p 8900 -l info
root      9985     1  0 15:53 ?        00:00:00 /usr/sbin/rsyslogd -n
root      9994  7120  0 15:53 ?        00:00:00 /usr/bin/python /usr/lib/applmgmt/base/bin/vherdrunner /usr/lib/applmgmt/tra
root     10012  9994  1 15:53 ?        00:00:20 /usr/bin/python /usr/lib/applmgmt/base/bin/vherdrunner /usr/lib/applmgmt/tra
root     10013  9994  0 15:53 ?        00:00:01 /usr/bin/python /usr/lib/applmgmt/base/bin/vherdrunner /usr/lib/applmgmt/tra
root     10014  9994  0 15:53 ?        00:00:03 /usr/bin/python /usr/lib/applmgmt/base/bin/vherdrunner /usr/lib/applmgmt/tra
root     10015  9994  0 15:53 ?        00:00:01 /usr/bin/python /usr/lib/applmgmt/base/bin/vherdrunner /usr/lib/applmgmt/tra
root     10157  7120  0 15:53 ?        00:00:00 /usr/lib/vmware-pschealth/sbin/pschealthd -s
root     10202  7120  0 15:53 ?        00:00:00 /usr/lib/vmware-statsmonitor/statsMonitor /etc/vmware/statsmonitor/statsMoni
vpostgr+ 10415  7120  0 15:53 ?        00:00:00 /opt/vmware/vpostgres/current/bin/postgres -D /storage/db/vpostgres
vpostgr+ 10416 10415  0 15:53 ?        00:00:00 postgres: logger process
vpostgr+ 10418 10415  0 15:53 ?        00:00:02 postgres: checkpointer process
vpostgr+ 10419 10415  0 15:53 ?        00:00:00 postgres: writer process
vpostgr+ 10420 10415  0 15:53 ?        00:00:00 postgres: wal writer process
vpostgr+ 10421 10415  0 15:53 ?        00:00:00 postgres: autovacuum launcher process
vpostgr+ 10422 10415  0 15:53 ?        00:00:00 postgres: stats collector process
vpostgr+ 10423 10415  0 15:53 ?        00:00:00 postgres: bgworker: health_status_worker
root     10921  7120  3 15:54 ?        00:00:52 /usr/java/jre-vmware/bin/vmware-vpxd-svcs.launcher -Xmx789m -XX:CompressedCl
vpostgr+ 11028 10415  0 15:54 ?        00:00:00 postgres: vc VCDB 127.0.0.1(39020) idle
vsphere+ 11930  7120 21 15:54 ?        00:04:57 /usr/java/jre-vmware/bin/vsphere-client.launcher -Xmx597m -XX:CompressedClas
vsphere+ 12533  7120 17 15:55 ?        00:03:44 /usr/java/jre-vmware/bin/vsphere-ui.launcher -Xmx597m -XX:CompressedClassSpa
vpxd     13974  7120  0 15:57 ?        00:00:11 /usr/lib/vmware-vpx/vpxd
vpostgr+ 14110 10415  0 15:57 ?        00:00:00 postgres: vc VCDB 127.0.0.1(40356) idle
vpostgr+ 14111 10415  0 15:57 ?        00:00:03 postgres: vc VCDB 127.0.0.1(40358) idle
vpostgr+ 14112 10415  0 15:57 ?        00:00:01 postgres: vc VCDB 127.0.0.1(40360) idle
vpostgr+ 14113 10415  0 15:57 ?        00:00:00 postgres: vc VCDB 127.0.0.1(40362) idle
vpostgr+ 14114 10415  0 15:57 ?        00:00:00 postgres: vc VCDB 127.0.0.1(40364) idle
vpostgr+ 14115 10415  0 15:57 ?        00:00:00 postgres: vc VCDB 127.0.0.1(40366) idle
vpostgr+ 14116 10415  0 15:57 ?        00:00:00 postgres: vc VCDB 127.0.0.1(40368) idle
vpostgr+ 14117 10415  0 15:57 ?        00:00:00 postgres: vc VCDB 127.0.0.1(40370) idle
vpostgr+ 14118 10415  0 15:57 ?        00:00:00 postgres: vc VCDB 127.0.0.1(40372) idle
vpostgr+ 14119 10415  0 15:57 ?        00:00:00 postgres: vc VCDB 127.0.0.1(40374) idle
content+ 14949  7120  6 15:59 ?        00:01:16 /usr/java/jre-vmware/bin/vmware-content-library.launcher -Xmx277m -XX:Compre
vpostgr+ 15513 10415  0 16:00 ?        00:00:00 postgres: vc VCDB 127.0.0.1(41296) idle
vpostgr+ 15514 10415  0 16:00 ?        00:00:00 postgres: vc VCDB 127.0.0.1(41298) idle
vpostgr+ 15515 10415  0 16:00 ?        00:00:00 postgres: vc VCDB 127.0.0.1(41300) idle
vpostgr+ 15516 10415  0 16:00 ?        00:00:00 postgres: vc VCDB 127.0.0.1(41302) idle
vpostgr+ 15521 10415  0 16:00 ?        00:00:01 postgres: vc VCDB 127.0.0.1(41312) idle
root     15972     1  0 16:01 ?        00:00:00 /usr/sbin/anacron -s -S /var/spool/anacron
eam      16298  7120  2 16:01 ?        00:00:21 /usr/java/jre-vmware/bin/vmware-eam.launcher -Xmx104m -XX:CompressedClassSpa
root     16955  7120  2 16:01 ?        00:00:25 /usr/java/jre-vmware/bin/vmware-sps.launcher -Xmx350m -XX:CompressedClassSpa
vpostgr+ 17210 10415  0 16:02 ?        00:00:00 postgres: vc VCDB 127.0.0.1(42154) idle
updatem+ 17827  7120  2 16:02 ?        00:00:25 /usr/lib/vmware-updatemgr/bin/updatemgr /usr/lib/vmware-updatemgr/bin/vci-in
updatem+ 18002 17827  0 16:02 ?        00:00:05 jre/bin/java -Dhttps.protocols=TLSv1 -Djavax.net.ssl.trustStore=ssl/vmware-v
vpostgr+ 18015 10415  3 16:02 ?        00:00:32 postgres: vumuser VCDB 127.0.0.1(42570) idle
vpostgr+ 18016 10415  0 16:02 ?        00:00:00 postgres: vumuser VCDB 127.0.0.1(42572) idle
vpostgr+ 18017 10415  0 16:02 ?        00:00:00 postgres: vumuser VCDB 127.0.0.1(42574) idle
vpostgr+ 18018 10415  0 16:02 ?        00:00:00 postgres: vumuser VCDB 127.0.0.1(42576) idle
vpostgr+ 18019 10415  0 16:02 ?        00:00:00 postgres: vumuser VCDB 127.0.0.1(42578) idle
vpostgr+ 18020 10415  0 16:02 ?        00:00:00 postgres: vumuser VCDB 127.0.0.1(42580) idle
vpostgr+ 18021 10415  0 16:02 ?        00:00:00 postgres: vumuser VCDB 127.0.0.1(42582) idle
vpostgr+ 18022 10415  0 16:02 ?        00:00:00 postgres: vumuser VCDB 127.0.0.1(42584) idle
vpostgr+ 18023 10415  0 16:02 ?        00:00:00 postgres: vumuser VCDB 127.0.0.1(42586) idle
vpostgr+ 18024 10415  0 16:02 ?        00:00:00 postgres: vumuser VCDB 127.0.0.1(42588) idle
vsan-he+ 18755  7120  2 16:03 ?        00:00:20 /usr/bin/python /usr/lib/vmware-vpx/vsan-health/VsanHealthServer.py -p 8006
root     19310  7120  2 16:03 ?        00:00:17 /usr/java/jre-vmware/bin/vmware-vsm.launcher -Xmx96m -XX:CompressedClassSpac
perfcha+ 19940  7120  6 16:04 ?        00:00:48 /usr/java/jre-vmware/bin/vmware-perfcharts.launcher -Xmx261m -XX:CompressedC
vpostgr+ 20172 10415  0 16:04 ?        00:00:00 postgres: vc VCDB 127.0.0.1(43694) idle
root     20752     1  0 16:05 ?        00:00:00 /opt/vmware/sbin/vami-lighttpd -f /opt/vmware/etc/lighttpd/lighttpd.conf
root     21417     1  0 16:07 ?        00:00:00 sendmail: accepting connections
root     21786     2  0 16:08 ?        00:00:00 [kworker/0:1]
root     22418     2  0 16:09 ?        00:00:00 [kworker/1:1]
root     23488     2  0 16:12 ?        00:00:00 [kworker/u128:0]
root     23950     2  0 16:13 ?        00:00:00 [kworker/0:0]
root     24874     1  0 16:16 ?        00:00:00 /usr/sbin/sshd -D
root     24921 24874  0 16:16 ?        00:00:00 sshd: root@pts/0
root     24957 24921  0 16:16 pts/0    00:00:00 /usr/bin/python /usr/lib/applmgmt/base/bin/vherdrunner /usr/lib/applmgmt/lin
root     24974 24957  0 16:16 pts/0    00:00:00 /bin/bash -i -l
root     25360 10012  0 16:17 ?        00:00:00 /usr/bin/vmstat 1 2
root     25364 24974  6 16:17 pts/0    00:00:00 ps -ef
root@photon-machine [ /etc/vmware-vpx ]# cd /opt/vmware/vpostgres/
9.4/     current/
root@photon-machine [ /etc/vmware-vpx ]# cd /opt/vmware/vpostgres/9.4/
root@photon-machine [ /opt/vmware/vpostgres/9.4 ]# cd bin/
root@photon-machine [ /opt/vmware/vpostgres/9.4/bin ]# ./psql -U vc -p 5432 VCDB
Password for user vc:
psql.bin (9.4.19 (VMware Postgres 9.4.19.0-10162245 release))
Type "help" for help.

Cannot read termcap database;
using dumb terminal settings.
VCDB=> \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
-----------+----------+----------+-------------+-------------+-----------------------
 VCDB      | vc       | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =Tc/vc               +
           |          |          |             |             | vc=CTc/vc
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(4 rows)

VCDB=> \l+
                                                                    List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   |  Size   | Tablespace |
 Description
-----------+----------+----------+-------------+-------------+-----------------------+---------+------------+---------------
-----------------------------
 VCDB      | vc       | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =Tc/vc               +| 66 MB   | pg_default |
           |          |          |             |             | vc=CTc/vc             |         |            |
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 6540 kB | pg_default | default admini
strative connection database
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +| 6409 kB | pg_default | unmodifiable e
mpty database
           |          |          |             |             | postgres=CTc/postgres |         |            |
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +| 6417 kB | pg_default | default templa
te for new databases
           |          |          |             |             | postgres=CTc/postgres |         |            |
(4 rows)

VCDB=> select version();
                                                                       version

----------------------------------------------------------------------------------------------------------------------------
-------------------------
 PostgreSQL 9.4.19 (VMware Postgres 9.4.19.0-10162245 release) on x86_64-unknown-linux-gnu, compiled by x86_64-vmk-linux-gnu
-gcc (GCC) 4.8.4, 64-bit
(1 row)

VCDB=> select pg_postmaster_startup_time();
ERROR:  function pg_postmaster_startup_time() does not exist
LINE 1: select pg_postmaster_startup_time();
               ^
HINT:  No function matches the given name and argument types. You might need to add explicit type casts.
VCDB=> select name, setting from pg_settings where name like 'wal%';
             name             |   setting
------------------------------+-------------
 wal_block_size               | 8192
 wal_buffers                  | 1396
 wal_keep_segments            | 0
 wal_level                    | hot_standby
 wal_log_hints                | on
 wal_receiver_status_interval | 10
 wal_receiver_timeout         | 60000
 wal_segment_size             | 2048
 wal_sender_timeout           | 60000
 wal_sync_method              | fdatasync
 wal_writer_delay             | 200
(11 rows)

VCDB=> select name, setting from pg_settings where name like 'arch%';
      name       |  setting
-----------------+------------
 archive_command | (disabled)
 archive_mode    | off
 archive_timeout | 0
(3 rows)

VCDB=>  select name, setting from pg_settings where name like 'log%';
            name             |     setting
-----------------------------+-----------------
 log_autovacuum_min_duration | 1000
 log_checkpoints             | on
 log_connections             | off
 log_destination             | stderr
 log_disconnections          | off
 log_duration                | off
 log_error_verbosity         | default
 log_executor_stats          | off
 log_file_mode               | 0600
 log_hostname                | off
 log_line_prefix             | %m %c %x %d %u
 log_lock_waits              | on
 log_min_duration_statement  | 1000
 log_min_error_statement     | error
 log_min_messages            | warning
 log_parser_stats            | off
 log_planner_stats           | off
 log_rotation_age            | 1440
 log_rotation_size           | 10240
 log_statement               | none
 log_statement_stats         | off
 log_temp_files              | -1
 log_timezone                | UTC
 log_truncate_on_rotation    | on
 logging_collector           | on
(25 rows)

VCDB=>  select name, setting from pg_settings where name like '%vacuum%';
                name                 |  setting
-------------------------------------+-----------
 autovacuum                          | on
 autovacuum_analyze_scale_factor     | 0.1
 autovacuum_analyze_threshold        | 50
 autovacuum_freeze_max_age           | 200000000
 autovacuum_max_workers              | 6
 autovacuum_multixact_freeze_max_age | 400000000
 autovacuum_naptime                  | 15
 autovacuum_vacuum_cost_delay        | 20
 autovacuum_vacuum_cost_limit        | -1
 autovacuum_vacuum_scale_factor      | 0.2
 autovacuum_vacuum_threshold         | 50
 autovacuum_work_mem                 | -1
 log_autovacuum_min_duration         | 1000
 vacuum_cost_delay                   | 0
 vacuum_cost_limit                   | 200
 vacuum_cost_page_dirty              | 20
 vacuum_cost_page_hit                | 1
 vacuum_cost_page_miss               | 10
 vacuum_defer_cleanup_age            | 0
 vacuum_freeze_min_age               | 50000000
 vacuum_freeze_table_age             | 150000000
 vacuum_multixact_freeze_min_age     | 5000000
 vacuum_multixact_freeze_table_age   | 150000000
(23 rows)

VCDB=> select * from pg_stat_activity;
 datid | datname  |  pid  | usesysid | usename  | application_name | client_addr | client_hostname | client_port |         b
ackend_start         |          xact_start           |          query_start          |         state_change          | waiti
ng | state  | backend_xid | backend_xmin |                                                                              quer
y
-------+----------+-------+----------+----------+------------------+-------------+-----------------+-------------+----------
---------------------+-------------------------------+-------------------------------+-------------------------------+------
---+--------+-------------+--------------+----------------------------------------------------------------------------------
-------------------------------------------------------------------------------
 12156 | postgres | 10423 |       10 | postgres |                  |             |                 |             |
                     |                               |                               |                               |
   |        |             |              | <insufficient privilege>
 16385 | VCDB     | 11028 |    16386 | vc       |                  | 127.0.0.1   |                 |       39020 | 2019-01-3
1 15:54:16.610584+00 |                               | 2019-01-31 16:02:10.954731+00 | 2019-01-31 16:02:10.954784+00 | f
   | idle   |             |              | SELECT KV_PROVIDER, KV_KEY, KV_VALUE, KV_GENERATION FROM CIS_KV_KEYVALUE WHERE KV
_PROVIDER=$1 AND KV_GENERATION >= $2 ORDER BY KV_GENERATION
 16385 | VCDB     | 14110 |    16386 | vc       |                  | 127.0.0.1   |                 |       40356 | 2019-01-3
1 15:57:58.52021+00  |                               | 2019-01-31 16:19:59.829139+00 | 2019-01-31 16:19:59.829327+00 | f
   | idle   |             |              | COMMIT
 16385 | VCDB     | 14111 |    16386 | vc       |                  | 127.0.0.1   |                 |       40358 | 2019-01-3
1 15:57:58.527831+00 |                               | 2019-01-31 16:20:10.023701+00 | 2019-01-31 16:20:10.023756+00 | f
   | idle   |             |              | DEALLOCATE "_PLAN0x7f85f043ecf0"
 16385 | VCDB     | 14112 |    16386 | vc       |                  | 127.0.0.1   |                 |       40360 | 2019-01-3
1 15:57:58.535919+00 |                               | 2019-01-31 16:16:04.082896+00 | 2019-01-31 16:16:04.083797+00 | f
   | idle   |             |              | COMMIT
 16385 | VCDB     | 14113 |    16386 | vc       |                  | 127.0.0.1   |                 |       40362 | 2019-01-3
1 15:57:58.543408+00 |                               | 2019-01-31 16:05:47.642888+00 | 2019-01-31 16:05:47.642971+00 | f
   | idle   |             |              | COMMIT
 16385 | VCDB     | 14114 |    16386 | vc       |                  | 127.0.0.1   |                 |       40364 | 2019-01-3
1 15:57:58.555655+00 |                               | 2019-01-31 15:58:13.420035+00 | 2019-01-31 15:58:13.421922+00 | f
   | idle   |             |              | COMMIT
 16385 | VCDB     | 14115 |    16386 | vc       |                  | 127.0.0.1   |                 |       40366 | 2019-01-3
1 15:57:58.560156+00 |                               | 2019-01-31 15:58:13.152521+00 | 2019-01-31 15:58:13.152551+00 | f
   | idle   |             |              | ROLLBACK
 16385 | VCDB     | 14116 |    16386 | vc       |                  | 127.0.0.1   |                 |       40368 | 2019-01-3
1 15:57:58.563876+00 |                               | 2019-01-31 15:58:13.179624+00 | 2019-01-31 15:58:13.181419+00 | f
   | idle   |             |              | COMMIT
 16385 | VCDB     | 14117 |    16386 | vc       |                  | 127.0.0.1   |                 |       40370 | 2019-01-3
1 15:57:58.589722+00 |                               | 2019-01-31 15:57:58.623478+00 | 2019-01-31 15:57:58.624192+00 | f
   | idle   |             |              | select oid, typbasetype from pg_type where typname = 'lo'
 16385 | VCDB     | 14118 |    16386 | vc       |                  | 127.0.0.1   |                 |       40372 | 2019-01-3
1 15:57:58.625986+00 |                               | 2019-01-31 15:57:58.657877+00 | 2019-01-31 15:57:58.658627+00 | f
   | idle   |             |              | select oid, typbasetype from pg_type where typname = 'lo'
 16385 | VCDB     | 14119 |    16386 | vc       |                  | 127.0.0.1   |                 |       40374 | 2019-01-3
1 15:57:58.660879+00 |                               | 2019-01-31 15:57:58.667847+00 | 2019-01-31 15:57:58.668427+00 | f
   | idle   |             |              | select oid, typbasetype from pg_type where typname = 'lo'
 16385 | VCDB     | 15513 |    16386 | vc       |                  | 127.0.0.1   |                 |       41296 | 2019-01-3
1 16:00:28.021632+00 |                               | 2019-01-31 16:20:27.952581+00 | 2019-01-31 16:20:27.952602+00 | f
   | idle   |             |              | SELECT VERSION()
 16385 | VCDB     | 15514 |    16386 | vc       |                  | 127.0.0.1   |                 |       41298 | 2019-01-3
1 16:00:28.326279+00 |                               | 2019-01-31 16:20:27.952422+00 | 2019-01-31 16:20:27.952443+00 | f
   | idle   |             |              | SELECT VERSION()
 16385 | VCDB     | 15515 |    16386 | vc       |                  | 127.0.0.1   |                 |       41300 | 2019-01-3
1 16:00:28.340019+00 |                               | 2019-01-31 16:20:27.952222+00 | 2019-01-31 16:20:27.952244+00 | f
   | idle   |             |              | SELECT VERSION()
 16385 | VCDB     | 15516 |    16386 | vc       |                  | 127.0.0.1   |                 |       41302 | 2019-01-3
1 16:00:28.369173+00 |                               | 2019-01-31 16:20:27.952013+00 | 2019-01-31 16:20:27.952044+00 | f
   | idle   |             |              | SELECT VERSION()
 16385 | VCDB     | 17210 |    16386 | vc       |                  | 127.0.0.1   |                 |       42154 | 2019-01-3
1 16:02:10.965603+00 |                               | 2019-01-31 16:20:50.955614+00 | 2019-01-31 16:20:50.95566+00  | f
   | idle   |             |              | SELECT KV_PROVIDER, KV_KEY, KV_VALUE, KV_GENERATION FROM CIS_KV_KEYVALUE WHERE KV
_PROVIDER=$1 AND KV_KEY LIKE $2 AND KV_GENERATION >= $3 ORDER BY KV_GENERATION
 16385 | VCDB     | 18015 |    26682 | vumuser  |                  |             |                 |             |
                     |                               |                               |                               |
   |        |             |              | <insufficient privilege>
 16385 | VCDB     | 18016 |    26682 | vumuser  |                  |             |                 |             |
                     |                               |                               |                               |
VCDB=>
