# **Strace 간단 사용법**

## 1. pre-requisites

strace 설치 확인

```bash
# rpm -qa | grep strace
strace-4.8-10.el6.x86_64

```
## 2. 자주 사용하는 옵션

```bash
strace 
 -p : pid
 -t : timestamp
 -o : output file
 -r : 각 시스템 콜에 대한 엔트리 상의 관련 타임스탬프를 출력, 성공한 시스템 콜 간의 시간 차를 기록함
 -c : 시스템 콜 통계 정보
 -T : 시스템 콜에 소요된 시간
 -f : 추적 중인 프로세스가 fork한 자식 프로세스까지 추적
 -s strsize : 출력할 수 있는 최대 문자열 크기를 지정, 기본값은 32이고, 파일명은 문자열로 간주되지 않아 모두 출력함.

```
