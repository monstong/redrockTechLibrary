# Oracle Dictionary & fixed objects 통계 정보 수집

## 목적
 - DB 운영간  Dictionary view (Dynamic/static) 조회시 SQL 성능 저하 발생 가능하므로, 주요 큰 변경 작업이 있거나, 성능 이슈 발생시 주기적으로 Dictionary 에 대한 통계 정보도 수집이 필요하다.


## DBMS_STATS 패키지 이용

 - Oracle Dictionary Object 종류별로 DBMS_STATS 패키지내 아래 프로시저 중 선택해서 수행한다.
 (보통 2개다 돌리는게 좋다.)

  1) Static (DBA_/ALL_/USER_): GATHER_DICTIONARY_STATS()
  2) Dynamic(Fixed object(V$)) : DBMS_FIXED_OBJECTS_STATS();

  ## Dictionary 통계 정보 수집 절차

   1) 통계 정보 EXPORT 테이블 생성

```SQL
exec DBMS_STATS.CREATE_STAT_TABLE(OWNNAME=>'SYS',STATTAB=>'ANAL_DICT_STATS',TBLSPACE=>'SYSAUX');
```

   2) 기존 통계 정보 백업 (STATID는 영문으로 시작해야함)
```SQL
exec DBMS_STATS.EXPORT_FIXED_OBJECTS_STATS(STATTAB=>'ANAL_DICT_STATS',STATID=>'FIEXED_YYYYMMDD',STATOWN=>'SYS');
exec DBMS_STATS.EXPORT_DICTIONARY_STATS(STATTAB=>'ANAL_DICT_STATS',STATID=>'DICT_YYYYMMDD',STATOWN=>'SYS');
```

   3) 통계 정보 갱신
```SQL
exec DBMS_STATS.GATHER_FIXED_OBJECTS_STATS;
exec DBMS_STATS.GATHER_DICTIONARY_STATS;
```

   4) 백업 결과 확인
```SQL
SQL> select statid,count(*) from anal_dict_stats 
group by statid;
STATID              COUNT(*)
----------------------------
FIXED_YYYYMMDD      19308
DICT_YYYYMMDD       25410
```

## 덧. RMAN 백업 테이블 통계 정보 제거 및 고정

RMAN 백업 이력 관련 테이블은 통계 정보 수집등에서 제외 및 Lock 설정 필요 (불필요 dictionary 통계수집방지)

```SQL
exec dbms_stats.UNLOCK_TABLE_STATS('SYS','X$KCCRRSR');
exec dbms_stats.DELETE_TABLE_STATS('SYS','X$KCCRRSR');
exec dbms_stats.LOCK_TABLE_STATS('SYS','X$KCCRRSR');
```