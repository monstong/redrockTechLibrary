# Porstgresql : Column Creation with Defaults value in Table  ( ver 11 vs prior ver 11)

Postgresql 10 버전 이하에서는 default value가 존재하는 column 추가하는 작업은 상당히 주의해야 합니다.
기본적으로 DDL문을 통한 구조 변경을 Workload가 높은 시간대에 하지는 않겠지만, 단순히 성능이나 Lock 이슈가 아닌 그너머(?)의 위험 사항이 있습니다.

# Prior to pgsql 10, Adding Column with default value into the table.

 - default 값이 존재하는 column 추가시 해당 Table에 ACCESS EXCLUSIVE LOCK이 걸립니다. 왜냐하면 Table 자체를 재생성(Re-write) 해버리기 때문입니다. ```마치 Full-Vacuum을 돌리는 것과 같은 효과!!```

 > ACCESS EXCLUSIVE LOCK LEVEL은 LOCK LEVEL 중 가장 높은 레벨

 - 해당 작업을 수행하는 동안 모든 다른 트랜잭션은 Waiting을 하게 됩니다. (select문까지)
 - Table을 재생성하므로 예상치 못한 여유공간 점유이슈 발생 가능합니다. (Filesystem Full등)
 - 결국 Big table 일수록 전체 재생성에 오랜 시간이 소요되므로, 장시간 Lock과 예상치 못한 Disk 여유율 이슈가 발생 가능합니다.

 - 그럼 진짜 재생성할까 실험을 해보면 다음과 같습니다.
   * Test 환경 : Postgresql 9.5 (Cent OS 7)

   * Test용 DB 인 mydb95 생성 및 접속
   ```bash

    postgres=# create database mydb95;
    CREATE DATABASE
    postgres=#
    postgres=#
    postgres=# \c mydb95
    psql (11.1, server 9.5.15)
    You are now connected to database "mydb95" as user "postgres".
    mydb95=# 
    ```

    * emp table 생성 및 sample data 입력
    ```bash
    mydb95=# create table emp(
    mydb95(# no int,
    mydb95(# name varchar(20));
    CREATE TABLE
    mydb95=# insert into emp values(1,'aaa');
    INSERT 0 1
    mydb95=# insert into emp values(2,'bbb');
    INSERT 0 1
    mydb95=# select * from emp;
    no | name
    ----+------
    1 | aaa
    2 | bbb
    (2 rows)
    ```

    * 현재 emp table의 oid 및 실제 data file path를 확인

    ```bash
    mydb95=# select oid, relname from pg_class where relname = 'emp';
    oid  | relname
    -------+---------
    16385 | emp
    (1 row)

    mydb95=# select pg_relation_filepath('emp');
    pg_relation_filepath
    ----------------------
    base/16384/16385
    (1 row)
    ```

    * jobid column을 default 값이 10 이 설정되도록 추가 작업 수행 (with not null constraint)
    
    ```bash
    mydb95=# alter table emp add jobid int default 10;
    ALTER TABLE
    ```

    * add 작업후 emp table의 정보를 다시 조회하면 이럴수가 oid가 변경되어 있음을 알 수 있습니다.

    ```bash
    mydb95=# select oid, relname from pg_class where relname = 'emp';
    oid  | relname
    -------+---------
    16389 | emp
    (1 row)

    mydb95=# select pg_relation_filepath('emp');
    pg_relation_filepath
    ----------------------
    base/16384/16389
    (1 row)
    ```
# pgsql 11, Adding Column with default value into the table.

 - 동일하게 postgresql 11 버전에서 수행하면 어떻게 될까요?
   * Test 환경 postgresql 11 (Cent OS 7)
   * Test용 DB 인 mydb95 생성 및 접속
   ```bash
    postgres-# create database mydb11;
    CREATE DATABASE
    postgres=# \c mydb11
    You are now connected to database "mydb11" as user "postgres".
    mydb11=#
    ```

    * emp table 생성 및 sample data 입력
    ```bash
    mydb11=# create table emp(
    mydb11(# no int,
    mydb11(# name varchar(20));
    CREATE TABLE
    mydb11=#  insert into emp values(1,'aaa');
    INSERT 0 1
    mydb11=# insert into emp values(2,'bbb');
    INSERT 0 1
    mydb11=# select * from emp;
    no | name
    ----+------
    1 | aaa
    2 | bbb
    (2 rows)
    ```

   * 현재 emp table의 oid 및 실제 data file path를 확인

    ```bash
    mydb11=# select oid, relname from pg_class where relname = 'emp';
    oid  | relname
    -------+---------
    16385 | emp
    (1 row)

    mydb11=# select pg_relation_filepath('emp');
    pg_relation_filepath
    ----------------------
    base/16384/16385
    (1 row)

    mydb11=# select attrelid,  attname, atthasmissing ,  attmissingval  from pg_attribute where attrelid = 16385;
    attrelid | attname  | atthasmissing | attmissingval
    ----------+----------+---------------+---------------
        16385 | tableoid | f             |
        16385 | cmax     | f             |
        16385 | xmax     | f             |
        16385 | cmin     | f             |
        16385 | xmin     | f             |
        16385 | ctid     | f             |
        16385 | no       | f             |
        16385 | name     | f             |
    (8 rows)
    ```
    * 3번째 쿼리는 emp table(oid 16485)의 각 column의 특정 속성 atthasmissing과 attmissingval 값을 조회하는 것이다. (9.5버전에는 존재하지 않는 column)

    * jobid column을 default 값이 10 이 설정되도록 추가 작업 수행 (with not null constraint)
    
    ```bash
    mydb11=# alter table emp add jobid int default 10;
    ALTER TABLE

    ```

    * add 작업후 emp table의 정보를 다시 조회하면 oid가 그대로 유지되어 있고, pg_attribute에 조회된 새로운 column jobid에 대해 atthasmissing 이 t(true)이고 attmissingval 이 10 인 것을 확인할 수 있다.
    * table 재생성은 없으며 수행시간 또한 단축된다. (본 예제는 sample data는 얼마 없어 차이가 나지 않지만, 다른 성능 테스트 후기를 보면 200만 행 table 에 대해 column을 추가했을 때 40초 걸리던데 1초이내 완료되었다고 한다.

    ```bash
    mydb11=# select oid, relname from pg_class where relname = 'emp';
    oid  | relname
    -------+---------
    16385 | emp
    (1 row)

    mydb11=# select pg_relation_filepath('emp');
    pg_relation_filepath
    ----------------------
    base/16384/16385
    (1 row)

    mydb11=#  select attrelid,  attname, atthasmissing ,  attmissingval  from pg_attribute where attrelid = 16385;
    attrelid | attname  | atthasmissing | attmissingval
    ----------+----------+---------------+---------------
        16385 | tableoid | f             |
        16385 | cmax     | f             |
        16385 | xmax     | f             |
        16385 | cmin     | f             |
        16385 | xmin     | f             |
        16385 | ctid     | f             |
        16385 | no       | f             |
        16385 | name     | f             |
        16385 | jobid    | t             | {10}
    (9 rows)

    ```
## 그럼 Oracle 은 ?

 - 이미 예전부터 dictionary 에 default value를 저장하는 방식이었고, 이외에 DDL 구문에 production 영향도 최소화를 위해 ONLINE_REDEFINITION 패키지를 지원한다. (12c버전 이후로 다시 많은 개선이 있었다. 버그는... 써봐야.. 음?? ^^;;)

## P.S. 시간상 제약으로 공간 부족시 발생하는 로직은 테스트해 보지 않았다.

## not null 옵션 제거시 10버전 이하라도 table rewrite은 발생하지 않는다.

## Reference 
 - [Postgresql Weelkly Article](https://brandur.org/postgres-default)
 - [americanopeople님 블로그](http://americanopeople.tistory.com/m/272)