# **TMAX tech seminar**

## **1. JEUS 8 New feature**

 - JDK 1.7 full support
 - attribute 단위 update
 - Node java 기능 (node js 처럼 동작, single thread event loop)
 - http/2 support
 - DAS(Domain Administrator Server) clustering 개선 - 차이점 잘...
 - Graceful auto scaling 신규 (cloud상에 scaling된후 script 형태로 신규 인스턴스 생성 및 시작)
 - Password validation(복잡도 및 길이 제한 등 강화)
 - Admin account audit (admin 계정 auditing함)


## **2.JEUS 6 -> 7 upgrade 방안ㅎ**

 
 | JEUS 6 | JEUS 7 |
 |-----|-----|
|Node 단위 | Domain단위|

- upgrade 제품 비용 발생
- 대규모일 경우  추가 지원 인건비 발생
- rolling upgrade는 안되나  down time은  인스턴스 재시작 정도 시간


