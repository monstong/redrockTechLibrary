# **How to exchange the UNDO Tablespace in Oracle 11.2**

일반적으로 UNDO Tablespace 변경은 단순히 UNDO_TABLESPACE 파라미터 값을 변경 후 인스턴스 재기동하면 반영이 된다.
그런데 Oracle DB에서 아주 중요한 기능(Read consistency, Instance Recovery 등)을 하는 게 UNDO이고, 특히 DB 성능을 위해 _rolback_segment_count 등을 설정했거나 다음의 예와 같이 동일 UNDO Tablespace명으로 재생성시 좀 더 신중하게 아래와 같이 변경해 볼순 있겠다.

## 1. Pre-task
 - spfile 여부 확인 : pfile 사용시 parameter 변경은 pfile에 직접 편집후 재기동 필요, 물론 작업전 백업은 필수!!

 ```
 SQL> show parameter spfile
NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
spfile                               string      /u01/app/oracle/product/11.2.0/dbhome_1/dbs/spfileORCL.ora
 ```

 - Undo parameter 확인 :qusr
```
SQL> show parameter undo

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
undo_management                      string      AUTO
undo_retention                       integer     900
undo_tablespace                      string      UNDOTBS1

```

 - Undo 관련 Hidden parameter 확인 : (_rollback_segment_count : 기본적으로 UNDO_MANAGEMENT=AUTO이면 오라클이 알아서 undo segment를 관리하나 조금 더 성능 향상(?)을 위한 튜닝을 위해 인스턴스 기동시 미리 UNDO segment를 미리 해당 파라미터 수만큼 할당할 수 있다.) -> 미사용시 해당 step skip!!

```
SQL> show parameter rollback_segment_count

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
_rollback_segment_count              integer     500
```
 - UNDO tablespace 확인
```
SQL> select tablespace_name, file_name, bytes/1024/1024 from dba_data_files
 where tablespace_name like 'UNDO%' order by 1,2

TABLESPACE FILE_NAME                                                                        BYTES/1024/1024
---------- -------------------------------------------------------------------------------- ---------------
UNDOTBS1   /oradata/ORCL/ORCL/datafile/o1_mf_undotbs1_d8jrxghx_.dbf                                     200
```

## 2. Main task
 - Dummy undo Tablespace 생성 : 임시용 UNDO Tablespace 를 서버 환경에 맞게 생성한다. (ASM?OMF? FS?)
 ```
SQL> create undo tablespace undo_imsi add datafile '+DATADG' size 10m;

 ```

 - Undo 관련 parameter 변경 : 히든 파라미터 설정시에는 diable하고(미사용이면 skip!), 임시용 UNDO Tablespace로 변경
 ```
(Spfile일때)
SQL> create pfile='/tmp/inittemp.ora' from spfile;   -- spfile 내용 백업(rman backup spfile 이용해도 무방)

SQL> alter system set "_rollback_segment_count"=0 scope=spfile sid='ORCL1';
SQL> alter system set undo_management=MANUAL scope=spfile sid='ORCL1';
SQL> alter system set undo_tablespace=UNDO_IMSI scope=spfile sid='ORCL1';

(pfile일때)

$ cp $ORACLE_HOME/dbs/initORCL1.ora  /tmp/inittemp.ora     <- pfile 내용 백업
$ vi $ORACLE_HOME/dbs/initORCL1.ora   <- 아래와 같이 수정후 저장
ORCL1._rollback_segment_count=0
ORCL1.undo_management=MANUAL
ORCL1.undo_tablespace=UNDO_IMSI
 ```
 - Instance 재기동
 ```
SQL> shutdown immediate;
SQL> startup 
 ```

 - Undo parameter 확인 (변경한 설정으로 유지되고 있는지 확인)
 ```
 SQL> show parameter undo
 SQL> show parameter rollback_segment_count

 ```

 - 기존 Undo Tablespace에서 online 상태의 undo segment 존재하는지 확인 : 아직 online 상태의 undo segment가 있다면 아래 명령어로 offline 상태로 변경한다.

 ```
 SQL> select owner, segment_name, tablespace_name, status from dba_rollback_segs 
 where tablespace_name in ('UNDOTBS1','UDNO_IMSI')
 order by 2,3;

 (old undo tablespace인 UNDOTBS1에 online 상태의 undo segment가 존재하면 다음 명령어로 offline 상태로 변경하자)
SQL> alter rollback segment '<해당 rollback segment>' offline;

 ```

 - 기존 UNDO Tablespace (UNDOTBS1) 삭제후 재생성
 ```
SQL> drop tablespace UNDOTBS1 including contents and datafiles;

SQL> select file_name from dba_data_files 
where tablespace_name = 'UNDOTBS1';

SQL> create undo tablespace UNDOTBS1 datafile '+DATADG' size 10g;
SQL> alter tablespace UNDOTBS1 add datafile '+DATADG' size 10g;

 ```

  - undo 관련 parameter 원복
 ```
(Spfile일때)
SQL> alter system set "_rollback_segment_count"=500 scope=spfile sid='ORCL1'; -- 미사용시 skip!
SQL> alter system set undo_management=AUTO scope=spfile sid='ORCL1';
SQL> alter system set undo_tablespace=UNDOTBS1 scope=spfile sid='ORCL1';

(pfile일때)

$ vi $ORACLE_HOME/dbs/initORCL1.ora   <- 아래와 같이 수정후 저장
ORCL1._rollback_segment_count=500
ORCL1.undo_management=AUTO
ORCL1.undo_tablespace=UNDOTBS1
 ```
 - Instance 재기동
 ```
SQL> shutdown immediate;
SQL> startup 
 ```

 - Undo parameter 확인 (변경한 설정으로 유지되고 있는지 확인)
 ```
 SQL> show parameter undo
 SQL> show parameter rollback_segment_count
```

## 주의 사항
 - UNDO 는 인스턴스 당 1개씩 사용하므로 파라미터 변경시 반드시 현재 파라미터 한정으로 설정하도록 한다.
 (RAC 일경우 다른 인스턴스로 지정하거나, sid='*' 사용금지)

  - RAC 일 경우 가급적 1개 인스턴스씩  순차적으로 수행할 것
  


