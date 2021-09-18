# NSX-T Data Center: Install,Change, Manage 

## Instructor : 현운 (hyun-un@kisec.com)

## Terminology

 - Compute manager : 리소스 관리, vcenter
 - Control plane : routing 계산하는 부분 (CPU), 토폴로지 정보 전달
   Q) LCP와 CCP 차이 : 
      Central control Plane (Manager쪽)
      Local Control Plane (host쪽마다)
      => LCP와 CCP 매핑 현황 볼수 잇나? (sharding)

 - Data plane : 계산 결과 table이 저장되는 부분(Cache), 데이터 전달
 - Fabric node : NSX-T DC 모듈이 설치된 호스트 
 - Logical switch : L2 스위칭 기능 제공
 - Logical Router : L3 라우팅 기능 제공
 - Tier-0 gateway : 물리 네트워크와 연결된 장비
 - Tier-0 logical router : BGP 동작하는 라우터
 - Tier-1 gateway : 
 - Tier-1 logical router :

 - Transport Zone : 통신하고자하는 논리 스위치 묶음
 - Transport Node : Overlay, VLAN 네트워킹을 구현하는 호스트
 - Virutal tunnel endpoint : 

Geneve 터널 (nsx-t)
vxlan 터널 (nsx-v)

 - Segment : logical switch (2.4부터 segment로 표현)

 Q) underlay가 사용하는 network ?

 - Overlay logical network
  host overlay : vte가 host
  networ overlay : vte가 router
  hybrid overlay : vte가 host - router

 Q) 기존 물리 라우터와  터널 테트워크 연동 가능 ?

 - cRUD (CREATE, read, update, delete)


 - Declarative Policy :
 - Imperative policy :

 - stateless config : routing
 - stateful config : related edge (LB config etc)

## Lab env
1조 gerbil01a
(jumphost) MSTsC : vdc-gerbil-a.vmeduc.com
vmeduc\gerbil01a
VMware1!

(student PC)
MSTSC : vm-gerbil01a.vmeduc.com
vclass\administrator   
VMware1!

## High-level Architecture



Management and control plane :NSX manager cluster


Data Plane :  N-VDS (ESXi, KVM ), NSX module (baremetal), NSX Edge 

## installation

- Preparing : 

1. vsphere 
  1-1. nsx manager 설치 (사전 요구 사항 확인, 통신 port/protocal 확인)
  1-2. login to nsx manager 
  1-3. register compute manager
  1-4. add nsx manager nodes to management cluster
  1-5. add nsx edge (요구사항 확인, )
  1-6. nsx edge cluster 구성
  1-7. transport zone 생성
  1-8. transport node 구성
  1-0. 설치 후 확인

2. kvm

3. baremetal


## NSX manager UI

- NSX-T manager VIP는  3대중 1대 노드에  interface alias 형태로 떠있음(예: eth0:1  )
  manual takeover 가능??
- Simplified UI
  > logical segment 
  > 
- Advanced UI

TO  만들면 advanced에서 보이나?

## Network IO Control Profile (Overlay transport zone에 대해서만 가용)

Qos 절차
1) classification (트래픽 분류)
2) Marking (분류된 트래픽 표시) - cisco / 타번더 colering ? 
3) Policy 적용 (분류된 트래픽별 정책 적용)
   > policy 종류 : 
     congestion management : 혼잡상황일때만 적용  (PQ, CQ, WSQ, LQ) queue로 관리
     congestion avoidence : 혼잡상황일때만 적용  () Priority 낮은 애들을 미리 drop 시켜 회피

        1p2q4t : 큐가 3개인데  1개가 pq 이고 쓰레숄드가 4개로  회피 대상 4대 분류

     policing  & shaping  : 혼잡상황과 무관하게  트래픽을 자르거나(policing) 일정 버퍼링후 보내는 (shaping)
      => 2M qos 설정시 3M 들어오면  policing은 1M는 drop , shaping은  !M를 buffering후 보냄
     LFA(잘안씀)



## NSX-T Logical switching

Layer 2
1. 스위칭 동작 방식 (MAC 테이블) -> Overlay, VLAN
2. STP
3. etherchannel
4. inter vlan routing
5. L2 security (arp snooping, dhcp snooping, port security)
6. wireless lan


OSI 7 layer : segment (pdu)  packet, frame 

layer 2 switch : segment (물리 네트워크 구분)
L2 장비간 연결점

NSX-T: segment (logical switch) 

### prereq for logical switching


GENEVE 쓰는 이유
확장성 뛰어남

q-in-q


주요 component 들의 비정상시 동작 매커니즘

mpa
nsx-proxy
nestdb


```bash
[root@sa-esxi-04:~] ps --tree | grep nsx-proxy
  x tq2125045  2125045  nsx-proxy
  x tq2125051  2125045  nsx-proxy
  x mq2125052  2125045  nsx-proxy
[root@sa-esxi-04:~] ps --tree | grep nestdb
  x tq2124995  2124995  nestdb-server
  x mq2125002  2124995  nestdb-server
[root@sa-esxi-04:~] ps --tree | grepmpa
-sh: grepmpa: not found
[root@sa-esxi-04:~] ps --tree | grep mpa
  x tq2126130  2126130  mpa
  x tq2126136  2126130  mpa
  x tq2126137  2126130  mpa
  x tq2126138  2126130  mpa
  x tq2126139  2126130  mpa
  x mq2126140  2126130  mpa
  x tq2126185  2126172  mpa:Active
  x tq2126478  2126172  mpa:Active
[root@sa-esxi-04:~] ps --tree | grep nsx
  x tq2125045  2125045  nsx-proxy
  x tq2125051  2125045  nsx-proxy
  x mq2125052  2125045  nsx-proxy
  x tq2125074  2125074  nsx-context-mux
  x tq2125077  2125074  nsx-context-mux
  x tq2125078  2125074  nsx-context-mux
  x mq2125079  2125074  nsx-context-mux
  x tq2125139  2125139  nsx-platform-client
  x tq2125144  2125139  nsx-platform-client
  x tq2125145  2125139  nsx-platform-client
  x tq2125146  2125139  nsx-platform-client
  x mq2125147  2125139  nsx-platform-client
  x tq2125167  2125167  nsx-sfhc
  x tq2125174  2125167  nsx-sfhc
  x tq2125175  2125167  nsx-sfhc
  x tq2125176  2125167  nsx-sfhc
  x mq2126153  2125167  nsx-sfhc
  x tq2125209  2125209  nsx-exporter
  x tq2125217  2125209  nsx-exporter
  x tq2125218  2125209  nsx-exporter
  x tq2125219  2125209  nsx-exporter
  x tq2125220  2125209  nsx-exporter
  x tq2125221  2125209  nsx-exporter
  x tq2125224  2125209  nsx-exporter
  x tq2125225  2125209  nsx-exporter
  x tq2125226  2125209  nsx-exporter
  x tq2127121  2125209  nsx-exporter
  x tq2127122  2125209  nsx-exporter
  x tq2127123  2125209  nsx-exporter
  x tq2127124  2125209  nsx-exporter
  x tq2127125  2125209  nsx-exporter
  x tq2127126  2125209  nsx-exporter
  x tq2127127  2125209  nsx-exporter
  x tq2127128  2125209  nsx-exporter
  x tq2127129  2125209  nsx-exporter
  x tq2127130  2125209  nsx-exporter
  x tq2127131  2125209  nsx-exporter
  x tq2127132  2125209  nsx-exporter
  x mq2127133  2125209  nsx-exporter
  x x x tq2126220  2126220  nsx-vim
  x x x tq2126269  2126220  nsx-vim
  x x x mq2126270  2126220  nsx-vim
  x x   tq2126262  2126262  nsxaVim_py
  x x   mq2126297  2126262  nsxaVim_py
  x tq2126308  2126172  nsxa:HostdDone
  x tq2126309  2126172  nsxa:logicalSwi
  x tq2126310  2126172  nsxa:HstCfg
  x tq2126311  2126172  Main:nsxa_st
  x tq2126312  2126172  nsxa:updatectl
  x tq2126313  2126172  nsxa:Resync
  x tq2126314  2126172  nsxa:HdlrRdy
[root@sa-esxi-04:~]


```



SNooping : 솔루션(기웃거리기) 
spoofing : 변조 (변조를 막기 위해 snooping으로 본다  arp snooping, dhcp snooping)
sniffing : 훔치기



BUM traffic ovewview (broadcat, unicast, multicast)

BUM traffic replication mode  
 > head mode : 해당 VNI TN들에게 다 뿌림
 > hierachy 2 tier mode  :도메인별 MtEP 인 TN에게만 뿌려줌 