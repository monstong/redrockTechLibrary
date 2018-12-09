# **What is VMKERNEL PORT in VSphere ESXi ?**


백만년만에 외부 기술교육을 듣게 되었습니다.  vSphere ICM 과정!! ㅠ.ㅠ

기존에 vSphere 구축하거나 할 때  영혼없이(?) 그냥 step따라 생성만 하던 이넘의 정체를 교육 과정속에서도 명쾌히  와닿지 않아 역시나 구글링을 시작하여 나름 정리해 보았습니다.

## **1.  두 가지 VMware Network data traffic**

 - **Virtual Machine Traffic**

    Vritual Machine(Guest OS)이 OS 레벨 이상에서 외부 또는 타 VM과 통신하여 위한 일반 Network으로 
    Virtual switch 생성시 (인터널 용도가 아니면) vmnic을 uplink port 매핑만 해주면 VM별로 연결해서 사용할 수 있다. 
    > 내부적으로 좀더 파 봐야겠지만, 대략적으로는 VM에서 보내는 패킷을 vmnic으로 포워딩?? 해주는 느낌
    (물론  VLAN tagging이나  security policy 적용하면 무언가 더 하겠지만)

 - **VMKernel Traffic**

   * vSphere Esxi host 가 외부와 통신시 좀 더 "특별한" data를  주고 받을 수 있게 해주는 Network으로 단순히 Virtual switch 생성외에 별도의 VMKernel Port (VMkernel Networking Adapter)를 생성하여 해당 vSwitch에 매핑한다.
   
   * 각 VMKernel Port 

   * 생성된 virtual adapter는  VMK 라고 vSphere web clinet 등에서 보여진다.  (vmk#) 

   * 

## **2. VMkernel port 가 제공하는 Traffic 종류**

| Name | Desciption |
|-----|-----|
| 





vMotion Traffic
Management Traffic
iSCSI Traffic
NFS Traffic
Fault Tollerance Traffic
vSphere Replication Traffic







VMkernel traffic - this is the standard infrastructure or “system” traffic between the VMkernel services and the physical network.  This traffic can be isolated by configuring additional VMKernel Adapters on the vSwitch that map to VMkernel services.  


Management traffic, aka service console traffic, is communication between the VMware hypervisor and management systems such as vCenter, as well as communication between ESXi hosts for high availability (HA).  Management traffic should be isolated in a network that only network and security administrators are able to access.
vMotion traffic is used for the live migration of a running VM from one host to another.   Since vMotion traffic has a high network utilization, and was not encrypted (until vSphere 6.5), it should be isolated in its own VLAN.  
Fault tolerance traffic – Fault Tolerance creates a secondary VM on a separate host that is a mirror of the primary VM, so that the VM will be available without the need for a reboot if one of the hosts fails.  Fault tolerance traffic is the (unencrypted) traffic that synchronizes the primary and secondary VMs.  
vSphere replication traffic is the result of replication of VMs to recovery sites. Isolating replication traffic is a good practice as it ensures sensitive information is routed only to the appropriate destination.
vSphere replication NFC traffic is the traffic for incoming replication data at the target site. Isolating NFC traffic helps security and manageability.
Virtual SAN – is the virtual SAN traffic on the host. This traffic should be isolated for both performance and security reasons, especially if replication is taking place.


## **References**
 - [https://blog.heroix.com/blog/securing-and-optimizing-the-virtual-network-infrastructure](https://blog.heroix.com/blog/securing-and-optimizing-the-virtual-network-infrastructure)
 - [https://www.quora.com/What-is-a-VMkernel-port-in-VMware](https://www.quora.com/What-is-a-VMkernel-port-in-VMware)


