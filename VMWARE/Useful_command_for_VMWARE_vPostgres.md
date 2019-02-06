# **Useful command for VMWARE vPostgres in VCSA**

vSphere 6.0 부터 제공되는 VCenter Server Appliance는  내부 데이터 저장용 DBMS로 Embedded Postgresql을 사용합니다.

일반적인 상황에서는  vSphere Web Client 등의 인터페이스만으로 관리가 가능하지만, VCSA 자체 이슈로 인한 VM startup failed 나 Upgrade failed 이슈를 Troubleshooting하기 위해 SSH 터미널로 접속하여 , 특히  vPostgres(vCenter Embedded Postgresql)을 확인하거나 조치해야할 수도 있습니다.

기본적으로 vPostgres도 Postgresql의 일부분을 VMWARE에서 Customizing 한 경우라  대부분의 기본적인 Diagnose는 Postgresql 점검 방식과 유사하게 확인하시면 됩니다.


## Terminology

오라클이나 MySQL등 일반적으로 알려진(주로 오라클) DB에서의 기본 개념과 매핑한 Postgresql 내 주요 개념을 간단하게 정리해 보았습니다.

 - Relation : Table 객체를 이야기 합니다. 1개이상의 열들을 가지고 있으며, 행단위로 데이터가 저장됩니다.
 - Attribute : Table 객체를 이루는 Column(열)을 의미합니다. 다양한 Data type(Boolean, int, varchar 등)으로 생성시 선언할 수 있습니다.
 - Tuple : 데이터가 입력되는 단위 (오라클에서는 Row 에 해당) 
 - Page : Data가 저장되느 최소 단위 입니다. (오라클에서는 Data block에 해당) 8KB 크기로 고정이며, 한 Page내 Header 및 Tail외 실제 Tuple들이 Tail 영역 앞단부터 뒤에서 입력됩니다.
 - Tablespace : 오라클과 달리  Postgresql내에서는 Tablespace = OS의 특정 Directory 그자체로 보시면 됩니다. 별도의 Tablespace 미지정시 DB 생성시 정의된 Default tablespace 또는 pg_default Tablespace내 데이터 파일이 저장됩니다. 
 - Data file : MSSQL(.mdf, .ndf) 나 오라클(.dbf) 파일들과 달리 Postgresql에서는 Relation(=Table)자체가  데이터파일(실제로는 oid 이름으로 파일이 생성)이 됩니다. 용량이 커지면  파일명 뒤에 .1  .2 들의 넘버링이 붙어 분기되어 생성됩니다.

 - XID(Transaction ID) : DBMS내에서 각 시점이 됩니다. (오라클에서는 SCN에 해당) 처음부터 대용량 DB를 고려해서 시작된 프로젝트가 아니기에  XID가 저장되는 변수가 4 Bytes (unsined int) 크기로 DB 를 장기간 사용시 XID가 소진되는 이슈가 발생할 수 있어, Wrap Around라는 개념으로 해소하였습니다. Long Transaction에 대한 XID Wrap around 이슈 발생 방지를 위해 Frozen XID라는 개념도 있습니다.

 - VACUUM : 오라클이나 MYSQL과 달리 UNDO 라는 개념이 없고, Multi-generation Architecture로 MVCC가 동작합니다. Update할때마다 새로운 Tuple을 생성하며, Before Tuple은 commit이 되면, Dead tuple로 표시되므로, DML이 자주 발생할때 실제 데이터보다 데이터파일이 커지는(Bloating) 현상이 발생합니다.  이를 위해 정기적으로 Dead tuple을 정리해 주는 작업이 Vacuum입니다. (기본적으로 자동으로 동작하나, 특정 테이블이 너무 크거나 Vacuum 수행 시간이 오래걸릴때는 별도로 수동 수행이 필요합니다.)

 - WAL(Write-Ahead Log) : RDBMS의 핵심인 모든 변경 사항이 기록되는 로그 영역입니다. MSSQL에서는 Transaction log, 오라클에서는 Redo log  라고 부릅니다.

## Entering a shell and Connecting a vPostgres DB

1. SSH Enabled 하기 : vCenter의 Management interface URL로 접속하여 SSH Enabled 여부를 확인합니다.
  (가급적 보안상 필요시에는 Enable 후 Disable 해주는 걸 권고합니다.)

   - Web browser에서 ```https://{Vcenter server IP address}:5480/``` URL로 root유저로 접속
   - Left Pane 에서 Access 메뉴를 선택 후 SSH Login의 상태를 확인하여 Disabled 인 경우 Edit 버튼 선택하여 Enabled로 변경

1. 터미널 클라이언트로 SSH 접속하여 shell모드로 변경합니다. (shell모드로 변경후에 기본적인 OS 명령을 사용할 수 있습니다.)
   - Putty 등의 터미널 클라이언트로 Vcenter Server IP address로 SSH 접속 (root유저)
   - 아래 명령을 수행하여 Shell 모드로 진입합니다.
    ```
    6.0 version)
    Command> shell.set --enabled true
    Command> shell
    root #

    6.5 or higher version)
    Command> shell
    root #
    ```
1. /etc/vmware-vpx 경로에서 DB 접속 정보를 확인합니다.
   - 일부 문서에는 동일 경로에 embedded_db.cfg 파일로 확인하라고 하는 경우가 있는데 Password 정보가 불일치하는 경우가 있으므로, vcdb.properties를 확인하도록 합니다. 
    ```
    root@photon-machine [ / ]# cd /etc/vmware-vpx
    root@photon-machine [ /etc/vmware-vpx ]# cat vcdb.properties
    driver = org.postgresql.Driver
    dbtype = PostgreSQL
    url = jdbc:postgresql://localhost:5432/VCDB
    username = vc
    password = {YOUR PASSWORD}
    password.encrypted = false
    ```
    - vcdb.properties에서 필요한 정보는 Port(5432) 및 DB명(VCDB) 그리고 접속 username(vc) 와 password 정보입니다.
      * **주의!! : 해당 정보는 위와 같이 패스워드 정보를 포함하고 있으므로, 필요시에만 확인 및 사용합시다.**

1. Postgres 엔진(Software)이  설치된 경로를 확인합니다.
    ```
    root@photon-machine [ /etc/vmware-vpx ]# ps -ef | grep postgres
    vpostgr+ 10312  8223  0 11:25 ?        00:00:00 /opt/vmware/vpostgres/current/bin/postgres -D /storage/db/vpostgres
    => Postgresql의 Main Process입니다. 일반 Postgresql에서는 Postmaster 이 EDB의PAS 에서는 edb-postgres가 이에 해당합니다. 
    /opt/vmware/vpostgres/current 가 vPostgres 의 엔진이 설치된 경로임을 확인할 수 있습니다.

    vpostgr+ 10318 10312  0 11:25 ?        00:00:00 postgres: logger process
    vpostgr+ 10328 10312  0 11:25 ?        00:00:01 postgres: checkpointer process
    vpostgr+ 10329 10312  0 11:25 ?        00:00:00 postgres: writer process
    vpostgr+ 10330 10312  0 11:25 ?        00:00:00 postgres: wal writer process
    vpostgr+ 10331 10312  0 11:25 ?        00:00:00 postgres: autovacuum launcher process
    vpostgr+ 10332 10312  0 11:25 ?        00:00:01 postgres: stats collector process
    vpostgr+ 10333 10312  0 11:25 ?        00:00:00 postgres: bgworker: health_status_worker
    vpostgr+ 10700  8223  0 11:26 ?        00:00:01 /opt/vmware/vpostgres/current/bin/pg_archiver --directory /storage/archive
    vpostgr+ 10701 10312  0 11:26 ?        00:00:00 postgres: wal sender process archiver [local] streaming 0/35905B8
    => Postgersql DB의 Background process 들입니다. 내부적으로 동작하는데 필요한 역할별로 Process가 실행되어 있습니다.
    해당 결과는 6.7버전의 결과로 이전 버전에는 pg_archiver가 미구동 상태입니다. (No archive mode)
    
    vpostgr+ 10904 10312  0 11:26 ?        00:00:00 postgres: vc VCDB 127.0.0.1(40648) idle
    vpostgr+ 13104 10312  0 11:29 ?        00:00:00 postgres: vc VCDB 127.0.0.1(41476) idle
    => vc 유저로 vcenter및 psc용 VCDB의 메인 schema(유저) 로 실행된 일반 클라이언트 세션들입니다.

    ... 중략 ...
    vpostgr+ 16921 10312  0 11:35 ?        00:00:03 postgres: vumuser VCDB 127.0.0.1(43566) idle
    => vumuser schema(유저)로 실행된 일반 클라이언트 세션들입니다.
    6.5 버전부터는 Vmware Update Manager가 VCSA내 내장되어 있어 vumuser 세션들을 확인할 수 있으나, 6.0 버전에서는 vc유저 세션들만 확인됩니다.

    ... 후략 ...
    ```
1. psql 명령어로 VCDB 접속하기

    - DB 접속 정보를 다시 한번 확인한다.
    ```
    root@photon-machine [ ~ ]# cat /etc/vmware-vpx/vcdb.properties
    driver = org.postgresql.Driver
    dbtype = PostgreSQL
    url = jdbc:postgresql://localhost:5432/VCDB
    username = vc
    password = {YOUR PASSWORD}
    password.encrypted = false
    ```
    - 위에서 확인된 DB Listening Port (5432)와 DB name (VCDB)  그리고 DB username/password(vc/{YOUR PASSWORD})를 이용하여 아래와 같이 psql 을 통해 접속합니다.
    ```
    6.5 이하 버전 : $PATH에 vPostgres의 bin 디렉토리가 포함되어 있지 않아 절대경로로 실행)
    root@photon-machine [ ~ ]# /opt/vmware/vpostgres/current/bin/psql -U vc -p 5432 VCDB
    6.7 버전 : psql만 실행)
    root@photon-machine [ ~ ]# psql -U vc -p 5432 VCDB

    Password for user vc:
    psql (9.6.9)
    Type "help" for help.

    VCDB=>
    ```
    - 접속한 psql 세션을 종료하고 싶으면 `\q` 실행하면 Shell 모드로 빠져나옵니다.

## vPostgres DB related filesystems in VBSA

- shell 모드에서 아래와 같이 `df -h`를 수행하였을 때 보여지는 파일시스템중 다음 3개의 영역이 vpostgres DB 영역으로 사용됩니다.
 * /storage/db/ : vpostgres의 메인 Cluster - 여기서 cluster는 postgresql에서 사용되는 인스턴스 단위입니다 - 경로로 일반적인 postgresql에서는 $PGDATA 환경 변수에 저장되는 경로에 해당됩니다. (실제 경로는 /storage/db/vpostgres 입니다.)
 * /storage/dblog/ : vpostgres의 WAL log 저장영역입니다. (실제 경로는 /storage/dblog/vpostgres/pg_xlog 입니다.)
 * /storage/seat/ : VCDB의 각 실제 user tablespace들이 저장되는 영역입니다.  
 * /storage/archive/ (6.7 only) : 6.7버전부터 확인되는 파일시스템으로 vpostgres HA 구성시 사용되는 replication 설정시 사용될 영역으로 추정됩니다.(추가 확인 필요)

```
root@photon-machine [ ~ ]# df -h
Filesystem                                Size  Used Avail Use% Mounted on
devtmpfs                                  4.9G     0  4.9G   0% /dev
... 중략 ...
/dev/mapper/seat_vg-seat                  9.8G   52M  9.2G   1% /storage/seat
/dev/mapper/db_vg-db                      9.8G  106M  9.1G   2% /storage/db
/dev/mapper/archive_vg-archive             50G   79M   47G   1% /storage/archive
/dev/mapper/dblog_vg-dblog                 15G   86M   14G   1% /storage/dblog
... 중략 ...
/dev/mapper/log_vg-log                    9.8G  122M  9.1G   2% /storage/log => vpostgres용 DB log가 아니라 VCSA전반적인 log가 저장되는 영역입니다. 
/dev/mapper/autodeploy_vg-autodeploy      9.8G   23M  9.2G   1% /storage/autodeploy

```

- /storage/db/vpostgres 경로를 보면 아래와 같이 postgresql.conf 파일 등 Postgresql cluster 인스턴스 생성시 볼 수 잇는 기본 구조를 확인할 수 있고, WAL log 영역은  symbolic link로 /storage/dblog 경로로 연결되어 있음을 알 수 있습니다.

```
root@photon-machine [ /storage/db/vpostgres ]# ls -al
total 136
drwx------ 18 vpostgres root   4096 Feb  6 15:40 .
drwxr-xr-x  9 root      root   4096 Feb  2 11:25 ..
drwx------  7 vpostgres users  4096 Feb  3 09:23 base  => pg_default tablespace 경로
drwx------  2 vpostgres users  4096 Feb  6 15:41 global -> pg_global tablespace 경로
-rw-------  1 vpostgres users   659 Feb  6 15:36 health_status_worker.conf
drwx------  2 vpostgres users  4096 Feb  2 11:25 pg_clog -> clog 저장 경로
drwx------  2 vpostgres users  4096 Feb  2 11:25 pg_commit_ts
drwx------  2 vpostgres users  4096 Feb  2 11:25 pg_dynshmem
-rw-------  1 vpostgres users  4259 Feb  2 11:25 pg_hba.conf -> host-based authentication 파일(접근제어)로 localhost만 허용토록 설정되어 있음
-rw-------  1 vpostgres users  1664 Feb  2 11:25 pg_ident.conf
drwx------  4 vpostgres users  4096 Feb  6 15:52 pg_logical
drwx------  4 vpostgres users  4096 Feb  2 11:25 pg_multixact
drwx------  2 vpostgres users  4096 Feb  6 15:36 pg_notify
drwx------  3 vpostgres users  4096 Feb  2 11:26 pg_replslot
drwx------  2 vpostgres users  4096 Feb  2 11:25 pg_serial
-rw-------  1 vpostgres users   138 Feb  2 11:25 pg_service.conf
drwx------  2 vpostgres users  4096 Feb  2 11:25 pg_snapshots
drwx------  2 vpostgres users  4096 Feb  6 15:36 pg_stat => DB 통계 정보 저장 경로
drwx------  2 vpostgres users  4096 Feb  6 15:36 pg_stat_tmp
drwx------  2 vpostgres users  4096 Feb  2 11:25 pg_subtrans
drwx------  2 vpostgres users  4096 Feb  2 11:26 pg_tblspc => user tablespace의 base 경로 해당 경로 아래 symbolic link로 실제 경로로 연결되어 있음
drwx------  2 vpostgres users  4096 Feb  2 11:25 pg_twophase
-rw-------  1 vpostgres users     4 Feb  2 11:25 PG_VERSION
lrwxrwxrwx  1 vpostgres users    32 Feb  2 11:25 pg_xlog -> /storage/dblog/vpostgres/pg_xlog => WAL log 저장 경로 ,symbolic link로 /storage/dblog 파일시스템으로 연결되어 있음
-rw-------  1 vpostgres users    88 Feb  2 11:25 postgresql.auto.conf
-rw-------  1 vpostgres users 20799 Feb  6 15:36 postgresql.conf => 파라미터 설정 파일
-rw-------  1 vpostgres users   299 Feb  6 15:35 postgresql.conf.auto
-rw-------  1 vpostgres users    68 Feb  6 15:36 postmaster.opts => postgresql cluster 시작된 옵션 저장됨
-rw-------  1 vpostgres users    84 Feb  6 15:36 postmaster.pid => 현재 실행중인 postgresql cluster 프로세스 pid 저장됨

```

## Basic information
psql에 vc 유저로 VCDB에 접속한 후 아래 psql 명령및 SQL 문으로 기본적인 정보를 확인할 수 있습니다.

- Version 확인 (6.7기준)
 * 참고 6.5에서는 Postgresql 9.4 버전을 그리고 6.0에서는  Postgresql 9.3 버전을 확인할 수 있습니다. Postgresql 자체적으로는 9.6 이후 사용을 **개인적으로** 권고합니다. 현재 최신 Postgresql버전은 11입니다. 
```
VCDB=> select version();
                                                                   version

-----------------------------------------------------------------------------------------------------------------------
----------------------
 PostgreSQL 9.6.9 (VMware Postgres 9.6.9.0-8615968 release) on x86_64-pc-linux-gnu, compiled by x86_64-vmk-linux-gnu-gc
c (GCC) 4.8.4, 64-bit
(1 row)

```

- Database List 확인 : `\l` 로 확인가능하며, `\l+`를 하면 좀 더 상세한 정보를 확인할 수 있습니다.
  * VCDB : vPostgresq 메인 DB
  * postgres : postgres 자체 관리하는 metadata용 DB
  * template0 , 1 : User-custom용 template용 DB (create database 수행시 템플릿으로 활용됨)
```
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
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   |  Size   | Tablespace |                Description
-----------+----------+----------+-------------+-------------+-----------------------+---------+------------+--------------------------------------------
 VCDB      | vc       | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =Tc/vc               +| 64 MB   | pg_default |
           |          |          |             |             | vc=CTc/vc             |         |            |
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                       | 7071 kB | pg_default | default administrative connection database
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +| 6953 kB | pg_default | unmodifiable empty database
           |          |          |             |             | postgres=CTc/postgres |         |            |
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +| 6953 kB | pg_default | default template for new databases
           |          |          |             |             | postgres=CTc/postgres |         |            |
(4 rows)

```
  * `pg_default`는 cluster 전체적인 Default tablespace 영역으로 `create database` 또는 `create table`시 별도의 tablespace를 지정하지 않으면 해당 경로에 데이터 파일이 생성됩니다. vpostgres에서 실제 경로는 `/storage/db/vpostgres/base` 입니다.

- Archive mode 확인 : 아래와 같이 pg_settings system catalog를 조회하면 Archive mode가 off되어 있음을 알 수 있습니다.
  * Vpostgres HA(replication) 구성시에는 해당 설정이 변경될 걸로 추정됩니다. 추후 별도 테스트후 포스팅하겠습니다.
```
VCDB=> select name, setting from pg_Settings where name in ('archive_command','archive_mode');
      name       |  setting
-----------------+------------
 archive_command | (disabled)
 archive_mode    | off
(2 rows)

```

- Tablespace List 확인 : `\db` 명령으로 생성된 tablespace 목록을 확인할 수 있습니다. 대부분 /storage/seat 파일시스템내 생성되어 있음을 확인할 수 있습니다. 
  * `pg_default`와 `pg_global`은 default tablespace로  /storage/db/vpostgres 경로내에 존재합니다.

```
VCDB=> \db
                    List of tablespaces
    Name    |  Owner   |              Location
------------+----------+------------------------------------
 alarm      | vc       | /storage/seat/vpostgres/alarmtblsp
 event      | vc       | /storage/seat/vpostgres/eventtblsp
 hs1        | vc       | /storage/seat/vpostgres/hs1tblsp
 hs2        | vc       | /storage/seat/vpostgres/hs2tblsp
 hs3        | vc       | /storage/seat/vpostgres/hs3tblsp
 hs4        | vc       | /storage/seat/vpostgres/hs4tblsp
 pg_default | postgres |
 pg_global  | postgres |
 task       | vc       | /storage/seat/vpostgres/tasktblsp
(9 rows)

```

- Logging 관련 주요 파라미터 확인
  * postgresql.conf 파일에서 확인 : shell 모드에서 postgresql.conf 파일에서 확인합니다. 
    ```
    root@photon-machine [ /storage/db/vpostgres ]# cat postgresql.conf | grep -v "^#" | grep "^log"
    logging_collector = on
    log_directory = '/var/log/vmware/vpostgres' => DB관련 에러 로그등이 기록되는 경로입니다. 트러블슈팅의 시작점이 되겠죠
    log_filename = 'postgresql-%d.log' => 저장되는 파일 포맷입니다. 최신 로그 파일 확인시 참조합니다.
    log_truncate_on_rotation = on 
    log_rotation_age = 1440 => log 파일 rotation 주기가 1440분입니다. (하루마다 파일이 새로 생성됩니다.)
    log_min_duration_statement = 1s
    log_checkpoints = on
    log_line_prefix = '%m %c %x %d %u '
    log_lock_waits = on
    log_timezone = 'UTC'
    log_autovacuum_min_duration = 1s
    ```
  * pg_settings 뷰에서 확인 : SQL문으로도 확인 가능합니다. postgresql.conf 파일에서 주석 처러되어 있거나, 존재하지 않는 파라미터들은 모두 default값으로 적용되므로, 현재 실행중인 DB에 적용된 파라미터 값 확인시 유용합니다.
  ```
    VCDB=> select name, setting from pg_settings where name like 'log%';
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
    log_replication_commands    | off
    log_rotation_age            | 1440
    log_rotation_size           | 10240
    log_statement               | none
    log_statement_stats         | off
    log_temp_files              | -1
    log_timezone                | UTC
    log_truncate_on_rotation    | on
    logging_collector           | on
    (26 rows)
  ```
  * log_directory와 같은 일부 파라미터는 superuser만 확인 가능하므로 vc 유저로 일부 파라미터는 확인이 어려울수 있습니다.

- Vacuum 관련 파라미터 확인 : vacuum 관련 파라미터의 경우 전체 설명은 생략하겠습니다.(범위가..ㅜㅜ) 일단 아래 2개의 파라미터 정도는 확인하는 게 좋습니다. 
  * autovacuum = on : auto vaccum이 활성화됩니다. (정기적으로 postgresql 내부적으로 테이블별 vacuum을 수행함)
  * maintenance_work_mem = 70656 : DB의 메모리 영역 중 maintenance 관련 작업이 수행되는 메모리 영역의 크기입니다. 주로 vacuum, reindex 등이 수행되므로, auto vacuum이 정상적으로 수행이 되지 않거나 vacuum관련 이슈 발생시 튜닝 포인트에 해당합니다.

```
VCDB=> select name, setting from pg_settings where name like '%vacuum%';
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

VCDB=> select name, setting from pg_settings where name like '%work_mem%';
         name         | setting
----------------------+---------
 autovacuum_work_mem  | -1
 maintenance_work_mem | 70656
 work_mem             | 311

```

## Basic Diagnosing

vpostgres는 VCSA의 embedded DB이며, VCSA 내부 metadata 저장용으로 활용되므로, 가급적 별도의 직접 튜닝 보다는 증상 파악용으로만 확인하시길 권고합니다. 

정식 조치는 VMWARE Support를 통하여 진행하는게 좋겠죠? ^^;

대부분 특별한 VCSA 자체 bug가 있지 않고서야 DB space full 관련 이슈 정도만 발생할 걸로 보입니다.


- 시작은 로그 확인 부터 : 파라미터 log_directory 값에 설정된 경로내에 DB log 중 최신 파일을 통해 에러 등 이력을 확인합니다.
```
(vcdb.properties 파일에서 DB 접속 정보 확인)
root@photon-machine [ /storage/db/vpostgres ]# cat /etc/vmware-vpx/vcdb.properties
driver = org.postgresql.Driver
dbtype = PostgreSQL
url = jdbc:postgresql://localhost:5432/VCDB
username = vc
password = {YOUR PASSWORD}
password.encrypted = false

(ps 로 현재 실행중인 postgresql cluster 경로(PGDATA) 확인)
root@photon-machine [ /storage/db/vpostgres ]# ps -ef | grep postgres
vpostgr+  2856  2148  0 15:36 ?        00:00:01 /opt/vmware/vpostgres/current/bin/postgres -D /storage/db/vpostgres
... 후략 ...

(해당 경로로 이동후 postgresql.conf 파일에서 log_direcotry와 log_file format 확인)
root@photon-machine [ /storage/db/vpostgres ]# cd /storage/db/vpostgres
root@photon-machine [ /storage/db/vpostgres ]# cat postgresql.conf | grep -e log_directory  -e log_filename
log_directory = '/var/log/vmware/vpostgres'
log_filename = 'postgresql-%d.log'

(log 경로로 이동하여 최신 log 파일을 확인한다.)
root@photon-machine [ /storage/db/vpostgres ]# cd /var/log/vmware/vpostgres
root@photon-machine [ /var/log/vmware/vpostgres ]# ls -alrt
total 584
-rw-------  1 vpostgres users     42 Feb  2 11:25 serverlog-2.stdout
-rw-------  1 vpostgres users    445 Feb  2 11:25 serverlog-2.stderr
-rw-------  1 vpostgres users     42 Feb  2 11:26 pg_archiver.log-4.stdout
...중략 ...
-rw-------  1 vpostgres users  67867 Feb  6 16:47 postgresql-06.log
root@photon-machine [ /var/log/vmware/vpostgres ]# tail -3 postgresql-06.log
2019-02-06 16:47:59.158 UTC 5c5afeec.b59 0   LOG:  Writing instance status...
2019-02-06 16:47:59.158 UTC 5c5afeec.b59 0   LOG:  Wrote instance status successfully.
2019-02-06 16:47:59.158 UTC 5c5afeec.b59 0   LOG:  Updated instance status successfully.
```

- Active Session List : 현재 접속한 세션들 중 state가 active 상태인 세션들만 pg_stat_activity에서 확인합니다. postgresql 9.6 버전부터 pg_stat_activity에서 세션들의 wait event에 대하여 좀더 상세하게 확인 가능합니다. 

```
VCDB=> select * from pg_stat_activity where state = 'active';
 datid | datname |  pid  | usesysid | usename | application_name | client_addr | client_hostname | client_port |         backend_start         |          xact_start
   |          query_start          |         state_change          | wait_event_type | wait_event | state  | backend_xid | backend_xmin |                         query

-------+---------+-------+----------+---------+------------------+-------------+-----------------+-------------+-------------------------------+----------------------------
---+-------------------------------+-------------------------------+-----------------+------------+--------+-------------+--------------+-----------------------------------
---------------------
 16386 | VCDB    | 21338 |    16387 | vc      | psql             |             |                 |          -1 | 2019-02-06 16:30:03.459547+00 | 2019-02-06 16:38:04.132286+
00 | 2019-02-06 16:38:04.132286+00 | 2019-02-06 16:38:04.132289+00 |                 |            | active |             |        30226 | select * from pg_stat_activity whe
re state = 'active';
(1 row)


```

- 현재 접속 세션 수와 전체 허용 세션 수 비교 : psql에서 max_connections 파라미터와 pg_stat_activity 뷰의 count(*) 값을 비교해 봅니다. connection 이 maximum이 도달시 추가 세션 접속이 차단되는 이슈 확인용입니다.

```
VCDB=> select name, setting from pg_Settings where name = 'max_connections';
      name       | setting
-----------------+---------
 max_connections | 345
(1 row)

VCDB=> select count(*) from pg_stat_activity;
 count
-------
    30
(1 row)

```

- vacuum 및 analyze 수행 이력 확인 : 테이블별로  vacuum 또는 analyze가 마지막으로 수행된 시간을 확인할 수 있습니다.
(static한 테이블의 경우 - 수행 불필요 - 수행시간이 없을 수도 있습니다.)
  * `\d {table name}` 명령으로 해당 테이블 또는 뷰의 구조를 확인할 수 있습니다.

```
VCDB=> \d pg_stat_user_tables
           View "pg_catalog.pg_stat_user_tables"
       Column        |           Type           | Modifiers
---------------------+--------------------------+-----------
 relid               | oid                      |
 schemaname          | name                     |
 relname             | name                     |
 seq_scan            | bigint                   |
 seq_tup_read        | bigint                   |
 idx_scan            | bigint                   |
 idx_tup_fetch       | bigint                   |
 n_tup_ins           | bigint                   |
 n_tup_upd           | bigint                   |
 n_tup_del           | bigint                   |
 n_tup_hot_upd       | bigint                   |
 n_live_tup          | bigint                   |
 n_dead_tup          | bigint                   |
 n_mod_since_analyze | bigint                   |
 last_vacuum         | timestamp with time zone |
 last_autovacuum     | timestamp with time zone |
 last_analyze        | timestamp with time zone |
 last_autoanalyze    | timestamp with time zone |
 vacuum_count        | bigint                   |
 autovacuum_count    | bigint                   |
 analyze_count       | bigint                   |
 autoanalyze_count   | bigint                   |

```
  * schemaname 이 vc 인 유저의 table에 대해 pg_stat_user_tables 를 조회합니다. 이때 n_dead_tup(dml이 commit되어 dead tuple처리된 갯수) 나  last_vaccum 또는 last_autovacuum이 수행된지 오래된 테이블들이 있는지 해당 테이블이 과도한 사이즈를 차지하고 있는 건 아닌지를 확인합니다.
```
VCDB=> select schemaname,relname,n_dead_tup,last_vacuum,last_autovacuum,last_analyze,last_autoanalyze from pg_stat_user_tables where schemaname = 'vc' order by last_autovacuum desc;
 schemaname |            relname             | n_dead_tup |          last_vacuum          |        last_autovacuum        |         last_analyze          |       last_autoa
nalyze
------------+--------------------------------+------------+-------------------------------+-------------------------------+-------------------------------+-----------------
--------------
 vc         | vpx_hist_stat4_62              |          0 |                               |                               |                               |
... 중략 ...
 vc         | vpx_event_86                   |          0 |                               |                               |                               | 2019-02-06 15:51
:37.201657+00
 vc         | vpx_binary_data                |          0 |                               |                               |                               |
... 후략 ...

```
  * 위 결과에서 vpx_event_86 테이블이 의심스럽다고 가정하였을때 해당 테이블의 사이즈를 확인해 봅니다.

  ```
    VCDB=> select pg_size_pretty(pg_total_relation_size('vpx_event_86'));
    pg_size_pretty
    ----------------
    408 kB
    (1 row)

    VCDB=> select pg_size_pretty(pg_relation_size('vpx_event_86'));
    pg_size_pretty
    ----------------
    88 kB
    (1 row)

    VCDB=> select pg_relation_filepath('vpx_event_86');
                pg_relation_filepath
    ----------------------------------------------
    pg_tblspc/16397/PG_9.6_201608131/16386/17135
    (1 row)
  ```

  *위와 반대로 shell 모드에서 du 명령으로 용량이 큰 데이터 파일을 찾아 psql에서 역으로 조회해 보는 방법도 있습니다.

## Vacuum 과 Vacuum full

마지막으로 vacuum 과 vacuum full 에 대하여 설명을 하도록 하겠습니다.
 - vacuum : DML이 완료(commit)된  before image에 해당하는 dead tuple을 재사용 가능한 tuple로 처리 (실제 테이터 파일 용량이 줄어들진 않으나, 신규 DML 발생시 해당 영역을 사용가능케 함으로 용량 확보합니다. 온라인중에 가능하며, autovacuum이 이에 해당합니다.
 - vacuum full : dead tuple을 제외한 data 들도 새로운 테이블을 생성하고 기존 테이블은 제거하는 방식으로 vacuum full을 수행하면 테이블 전체에 Exclusive lock이 걸려 트랜잭션이 불가합니다. 오프라인이 반드시 필요한 작업이며, 테이블을 동일 공간에 새로 만드는 형태라 여유 공간 부족시  작업이 실패할 수도 있습니다.



 