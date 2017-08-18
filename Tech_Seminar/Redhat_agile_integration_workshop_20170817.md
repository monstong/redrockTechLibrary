# Redhat Agile Integration Workshop

##### - 2017.08.17

## 1. Enterprise IT is undergoing fundamental change.

|Category|change|
|-----|-----|
|Infrastructure|Data center > Cloud|
|Deployment|Server/VM > Container|
|Deployment process|Waterfall > CI/CD|
|Architecture|Monolith > Microservice|
|Service Endpoints|Webservices > APIs|

## 2. Agile Integration steps

classical --->  modern <br/>
SOA > Microservice > API > Event-Base > Container > DEVOPS


### 2-1. SOA AND ESB

 - too big and heavy, hard to deploy (slower)
 - Stringent scalability
 - slow team co-ordiation
 - complex service registry
 - long software delivery cycle

### 2-2. Microservices

 - Faster software delivery
 - resource scalability 
 - Failure isolation

 - organization (6 ~ 8 people, one pizza team)

 - simple, small
 - boundary and replaceable
 - independence

 - SMART ENDPOINT <br/>
   client  -  microservice by fuse [  API (interface, contracts) , Routing, transformation, procotol endpoints  ] - data

 - Simple pipe
   * needs granularity , security


 |
[orchastration layers]
 |
[ base layers]

### 2-3. APIs

microservice 간 공유 위한 사용 feature
 - JSON,XML 
 - RESTFUL, HTTP
 - Swagger documentation

API management를 위해 Redhat 솔루션 : 3-scale API management(Package, Distribute, control, monetize)


### 2-4. Containers

Immutable delivery 
 - OS, JVM, side-car app, configuration

container  오래전부터 존재해 왔으나,
Docker 이후  dockerfile을 통해 손쉽게  생성 , 활용 가능


 - wraps application and its dependencies into a self-contained unit
  - OS level virtualization
  - handles the networking
  - lightweight


  Container's life cycle


  빠른 release > failure 감지 > HA 보장 > multi-tenancy > scaling 관리 > 처음으로


### 2-5. CI/CD

 - Distributied Integration : 단일 Silo가 아니라 cloud로 laptop으로 on-premise로 다양한 환경에서 관리
 (apache camel, apache karaf, spring boot, fuse)
 - Container : CI/CD를 보다 용이하게 해줌
 (openshift:kebernetes, docker, fabric8)
 - API : service간 데이터 통신 , 재사용성 확보
(apache camel, 3scale, fuse)




https://developers.redhat.com

Books
- Microservices for java developers
- Enterprise Integration Patterns
- Camel in Action
- Apache camel Developer's cookbook
   (http://camel,apache.org)

### LABS

Distributed integration 

lightweight
 - spring boot deployment
 - DSL
 - S2i

Pattern base 
 - enterprise integration pattern

Reusable connector
 - camel components


LAB 1)

account = jboss/r3dh4t1!

http://github.com/jbossdemocentral/fuse-introlab






