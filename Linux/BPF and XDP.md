
# Linux kernel BPF / XDP

BPF 란 ?
Berkeley Packet Filter : safe dynamic programs and tools
런타임중  안전하게 커널코드를 삽입하는 기술

kernel infrastructure
 -  interpreter  : in-kernel virtual machine
  - hook point : in-kernel callback point
  - map
  - helper


 BPF infrastructure

  kernel += BPF interpreter  + verifier(안전보장 check - if pass, don't panic ) 
  

 BPF instruction set
 64bit  (ebpf 기준)
| imm : 32 | offset:16 | src:4 | dst:4 | opcode :8 |


XDP : BPF를 응용한 프로그램
 iptables 느리다? - 패킷 필터링 구조 복잡 , 성능 튜닝? - 정책 튜닝
 (eXpress Data Path) - network stack 거치지 않고 빠르게 이동? (fast path)

 Network stack normal path (net filter)

 실습
컴파일러 :  clang + llvm 설치
커널 소스 코드 (최신) : git.kernel.org 의 bpf tree (bpf.git)

bpf 프로그램 로더 (bpftool) ^ 위에 있음

xdp설정 도구
iproute2 필요
-> 여기에 ip 명령어 잇음 (ifconfig 안쓴대)


xdp 로드

mount bpffs /sys/fs/bpf -t bpf
./bpftool prog load  ./kern.o  /sys/fs/bpf/xdp

./bpftool prog list


xdp 프로그램 설정

ip link set dev lo xdp on
ip link show dev lo

xdp 프로그램 제거

ip link set dev lo xdp off


pinned obj 삭제

rm /sys/fs/bpf/xdp


iptables vs xdp

packet drop  using iptables

ping 192.168.4.1

iptables -A INPUT -s 192.168.4.2 -d 192.68.4.1 -p icmp -j  DROP

packet drop using xdp

./bpftool prog load ./xdp_icmp_ern.o  /sys/fs/bpf/xdp_icdmp

./bpftool prog list

ip link set dev enp4s0 xdp pin /sys/fs/xdp_icmp
ip link show


