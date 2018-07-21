# **[redrock's guide] configuring cascading physical standby db in oracle 11.2**

ASM 기반의 Oracle 11.2 database를 이용하여 Cascading Physical standby DB를 구성해 보자.

## 1. Environment
Virtualbox를 이용하여  총 3개의 Linux 서버를  구성한다.
(Physical standby 구성이지만 , Disk group명은 다른 상황을 가정하여 진행)

 * Primary DB server
   - Hostname : oel69prdb
   - OS : Oracle Linux 6.9
   - Databse 환경 : Oracle datbase 11.2.0.4 (Single instance)
   - GI 환경 : Oracle 11.2.0.4 Grid Infrastructure as a standalone server 
   - ASM Disk group : +DATA  (External redundancy, 6GB)

 * Standby DB server
   - Hostname : oel69prdb
   - OS : Oracle Linux 6.9
   - Databse 환경 : Oracle datbase 11.2.0.4 (Single instance)
   - GI 환경 : Oracle 11.2.0.4 Grid Infrastructure as a standalone server 
   - ASM Disk group : +NEWDATA  (External redundancy, 6GB)

 * Cascaded Standby DB server
   - Hostname : oel69prdb
   - OS : Oracle Linux 6.9
   - Databse 환경 : Oracle datbase 11.2.0.4 (Single instance)
   - GI 환경 : Oracle 11.2.0.4 Grid Infrastructure as a standalone server 
   - ASM Disk group : +NEWDATADG  (External redundancy, 6GB)

 * Network Info
   - Public : 192.168.200.x
   - Private(For Dataguard sync) : 192.168.210.x

```bash
$ cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4

192.168.200.111 oel69prdb
192.168.200.112 oel69stddb
192.168.200.113 oel69cstddb

192.168.201.111 oel69prdb-adg
192.168.201.112 oel69stddb-adg
192.168.201.113 oel69cstddb-adg
```
## 2. Primary DB 생성
 dbca를 이용해 primary db를 생성한다.
 - SID : ORCL
 - SYS/SYSTEM password : welcome1


## 3. Enable the archivelog mode and force logging

Physical standby Dataguard 구성을 위해 반드시 DB는 archivelog 모드여야 하고, Force logging이 설정되어 있어야 한다.

```sql
$ sqlplus / as sysdba

SQL*Plus: Release 11.2.0.4.0 Production on Sat Jul 21 10:14:57 2018

Copyright (c) 1982, 2013, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
With the Partitioning, Automatic Storage Management and Real Application Testing options

SQL> select name, open_mode, database_role, log_mode, force_logging from v$database;

NAME      OPEN_MODE            DATABASE_ROLE    LOG_MODE     FOR
--------- -------------------- ---------------- ------------ ---
ORCL      READ WRITE           PRIMARY          ARCHIVELOG   NO

SQL>
```

대부분 archivelog 모드는 운영 서비스 환경이면 사용중이겠지만,
force logging은 default 값은 no 이므로 첫 구성이면 반드시 설정해주어야 한다. (OPEN 상태에서 설정 가능)

```SQL
SQL> alter database force logging;

Database altered.

SQL>  select name, open_mode, database_role, log_mode, force_logging from v$database;

NAME      OPEN_MODE            DATABASE_ROLE    LOG_MODE     FOR
--------- -------------------- ---------------- ------------ ---
ORCL      READ WRITE           PRIMARY          ARCHIVELOG   YES

SQL>
```

## 4. Configuring Dataguard init parameters
Physical standby Dataguard 구성을 위해 최소 아래 init parameter 설정이 필요하다.
(본 구성에서는 DG broker를 미사용하므로, 관련 parameter는 생략)

 - log_archive_config 
 - log_archive_dest_2
 - fal_server
 - standby_file_management
 - db_unique_name

 - db_file_name_convert
 - log_file_name_convert
 - listener_network

 Primary DB(ORCL)에 다음과 같이 DG 관련 init parameter를 추가한다.
 ```SQL
alter system set log_archive_config='dg_config=(ORCL,ORCLDG,ORCLCDG)' scope=both sid='*';
alter system set log_archive_dest_1='location=USE_DB_RECOVERY_FILE_DEST' scope=both sid='*';
alter system set log_archive_dest_2='service=ORCLDG_SYN valid_for=(online_logfile,primary_role) LGWR ASYNC NOAFFIRM delay=0 reopen=10 db_unique_name=ORCLDG' scope=both sid='*';
alter system set fal_server='ORCLDG_SYN' scope=both sid='*';
alter system set standby_file_management=AUTO scope=both sid='*';
alter system set db_file_name_convert='+NEWDATA','+DATA' scope=spfile sid='*';
alter system set log_file_name_convert='+NEWDATA','+DATA' scope=spfile sid='*'; 


 ```


## password 파일 복사
[oracle@oel69prdb ~]$ cd $ORACLE_HOME/dbs
[oracle@oel69prdb dbs]$ cat /etc/hosts | grep db
192.168.200.111 oel69prdb
192.168.200.112 oel69stddb
192.168.200.113 oel69cstddb
192.168.201.111 oel69prdb-adg
192.168.201.112 oel69stddb-adg
192.168.201.113 oel69cstddb-adg
[oracle@oel69prdb dbs]$ scp orapwORCL oel69stddb:`pwd`/orapwORCLDG
oracle@oel69stddb's password:
orapwORCL                                     100% 1536     1.5KB/s   00:00
[oracle@oel69prdb dbs]$ scp orapwORCL oel69cstddb:`pwd`/orapwORCLDG
oracle@oel69cstddb's password:
orapwORCL                                     100% 1536     1.5KB/s   00:00
[oracle@oel69prdb dbs]$ scp orapwORCL oel69cstddb:`pwd`/orapwORCLCDG
oracle@oel69cstddb's password:
orapwORCL                                     100% 1536     1.5KB/s   00:00


## static listenr 설정 및 기동

oracle@oel69stddb admin]$ vi listener.ora
[oracle@oel69stddb admin]$ mv /u01/app/11.2.0.4/grid/network/admin/tnsnames.ora  .
[oracle@oel69stddb admin]$ cat listener.ora
LISTENER_IMSI =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = oel69stddb-adg)(PORT = 1531))
  )

SID_LIST_LISTENER_IMSI =
  (SID_LIST =
    (SID_DESC =
      (SID_NAME = ORCLDG)
      (ORACLE_HOME = /u01/app/oracle/product/11.2.0.4/dbhome_1/)
    )
  )

# su - oracle
[oracle@oel69stddb ~]$ lsnrctl start listener_imsi

LSNRCTL for Linux: Version 11.2.0.4.0 - Production on 21-JUL-2018 11:55:03

Copyright (c) 1991, 2013, Oracle.  All rights reserved.

Starting /u01/app/oracle/product/11.2.0.4/dbhome_1/bin/tnslsnr: please wait...

TNSLSNR for Linux: Version 11.2.0.4.0 - Production
System parameter file is /u01/app/oracle/product/11.2.0.4/dbhome_1/network/admin/listener.ora
Log messages written to /u01/app/oracle/diag/tnslsnr/oel69stddb/listener_imsi/alert/log.xml
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.210.112)(PORT=1531)))

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=oel69stddb-adg)(PORT=1531)))
STATUS of the LISTENER
------------------------
Alias                     listener_imsi
Version                   TNSLSNR for Linux: Version 11.2.0.4.0 - Production
Start Date                21-JUL-2018 11:55:03
Uptime                    0 days 0 hr. 0 min. 0 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /u01/app/oracle/product/11.2.0.4/dbhome_1/network/admin/listener.ora
Listener Log File         /u01/app/oracle/diag/tnslsnr/oel69stddb/listener_imsi/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.210.112)(PORT=1531)))
Services Summary...
Service "ORCLDG" has 1 instance(s).
  Instance "ORCLDG", status UNKNOWN, has 1 handler(s) for this service...
The command completed successfully




## TNS 설정 init용 , 동기화용

$ cd $ORACLE_HOME/network/admin
[oracle@oel69stddb admin]$ cat tnsnames.ora


ORCL_SYN =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = oel69prdb)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = ORCL)
    )
  )


ORCLDG_SYN =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = oel69cstddb)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = ORCLDG)
    )
  )


ORCLCDG_SYN =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = oel69cstddb)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = ORCLCDG)
    )
  )


ORCLDGIMSI_SYN =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = oel69cstddb-adg)(PORT = 1531))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SID = ORCLDG)
    )
  )


ORCLCDGIMSI_SYN =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = oel69cstddb-adg)(PORT = 1531))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SID = ORCLCDG)
    )
  )



## duplicate db

rman target sys/welcome1@orclimsi_syn auxiliary sys/welcome1@orcldgimsi_syn


run {
allocate channel ch1 device type disk;
allocate channel ch2 device type disk;
allocate auxiliary channel sch1 device type disk;
allocate auxiliary channel sch2 device type disk;
duplicate target database for standby 
 from active database
 dorecover;
}



