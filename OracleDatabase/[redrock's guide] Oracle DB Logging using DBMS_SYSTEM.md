# Oracle DB Logging using DBMS_SYSTEM package.


Oracle DB 관리시 운영 모니터링 상 필요하나 built-in 되어 있지 않아, 별도로 script화하여 수행 후 결과를 파일로 떨어뜨리고 해당 파일르 모니터링하는 경우가 종종 있다.
(대표적 예로 ASM Diskgroup Usage)

Oracle 에서는 Enterprise Manager를 사용하는 것을 권고하지만 EM을 구성하는 것 자체가 또 다른 관리포인트 증가 및 추가 공수(EM 공부 EM서버 자원 확보, 구성 등)가 되므로  최대한 DB 내에서 해결해 보자.

## 1. The whole process of configuring and applying the user-customed monitoring script in Oracle DB.



(기존)
```
[shell script] - call-> [monitoring .sql file] - write -> alert.log file or other text file.
```

- 기존 방식으로 작성할 경우 shell script 파일에서 sql 문을 sqlplus 명령을 stdin을 통해 수행하고 그결과에 대해서 alert.log 나 다른 output text 파일에 write 하게 한다.
수행시점의 timestamp , log 형태, alert log 파일 경로에 대한 수동 입력 등 추가적으로 스크립트 로직에 신경써야 한다.
정기적 수행을 위해 crontab 에 등록 또른 다른 Job scheduler 활용 필요



(DBMS_SYSTEM 패키지 사용)
```
[monitoring sql]  call-> [DBMS_SYSTEM.ksdwrt procedure]
```
- DBMS_SYSTEM 패키지 사용할 경우 :
   * User-customed monitoring procedure 작성 및 DBMS_SCHEDULER 또는 DBMS_JOBS에 등록으로 위 모든 과정이 해결된다.
   * 해당 monitoring PL/SQL procedure는 다음과 같은 파트로 작성시 모든 걸 포함하며, DBMS_SYSTEM 패키지를 통해 마지막으로 출력할 경로만 지정해주면 알아서 수행시점 timestamp를 마치 일반 오라클 event 발생하는 것처럼 로깅을 해준다.

```
[Procedure body]
{Monitoring SQL} -> Monitoring SQL 수행 및 결과 파전 오직 작성
{DBMS_SYSTEM.ksdwrt()} -> alert log 또는 trace file로 monitoring 결과 출력
[Procedure body end]
```

## 2. DBMS_SYSTEM.ksdwrt procedure 사용 예시

```SQL
SQL> exec DBMS_SYSTEM.ksdwrt(n, 'your messages');

SQL> exec DBMS_SYSTEM.ksdwrt(2,'This is my first message');

PL/SQL procedure successfully completed.

SQL> !tail -5 /u01/app/oracle/diag/rdbms/orcl/ORCL/trace/alert_ORCL.log
Starting background process SMCO
Sun Jun 03 14:43:28 2018
SMCO started with pid=27, OS id=4997
Sun Jun 03 01:48:17 2018 
This is my first message  
```
별도의 시간정보를 설정하지 않아도, alert log 파일에 어디에 있는지 지정하지 않아도 alert log파일에 로깅된 일반 다른 메시지들처럼 'This is my first message'가 저장된걸 확인할 수 있다.

 - 참고 : DBMS_SYSTEM.ksdwrt 프로시저의 첫번째 agrument인 n은  숫자 타입으로 아래와 같은 상수들 중 하나를 사용할 수 있다.
   * 1 : trace file에 메세지 저장
   * 2 : alert log file에 메세지 저장
   * 3 : 둘다 저장


## 3. 활용 예제 (ASM Diskgroup 사용율 Monitoring을 DBMS_SYSTEM 패키지를 이용해 DB내 설정해 보자)

1) 모니터링 PL/SQL Procedure 작성 : 크게 3가지 part로 나누어 설정한다.
모니터링 데이터 수집 - 모니터링 임계치등 판단 - DBMS_SYSTEM.ksdwrt 로 출력
(재사용성을 위해 Warning, critical 사용율 임계치는 인자로 받도록 작성)

```SQL
SQL> CREATE OR REPLACE PROCEDURE monitorASM
(warningThreshold in number, criticalThreshold in number )
IS
	checkVal number; -- ASM 사용율 측정 값 저장
	groupName varchar2(128); -- ASM digk group 명 저장
	outputMsg varchar2(256); -- 모니터링 결과 출력 메세지

    -- ASM diskgroup Usage 조회하여 mycur 에 저장
	CURSOR myCur IS
		select name, round((total_mb-free_mb)*100/total_mb,1) as usage 
		from v$asm_diskgroup;
BEGIN
    FOR asmRec IN myCur LOOP
	    -- ASM diskgroup 별 groupName과 checkVAl(사용율) 변수로 저장
		groupName := asmRec.name;
		checkVal := asmRec.usage;

        --  Procedure 인자로 받은 Warning/ Critical 임계치 초과 여부 점검후 outputMsg 완성 후 alert log에 출력
		IF checkVal > criticalThreshold THEN
			outputMsg := 'ORA-REDROCK-ASM-001 CRITICAL ' || groupName || ' ASM Diskgroup Usage is ' || checkVal || ' now!';
		    DBMS_SYSTEM.ksdwrt(2,outputMsg);
		ELSIF checkVal > warningThreshold AND checkVal <= criticalThreshold THEN
			outputMsg := 'ORA-REDROCK-ASM-002 WARNING ' || groupName || ' ASM Diskgroup Usage is ' || checkVal || ' now!';
            DBMS_SYSTEM.ksdwrt(2,outputMsg);
		END IF;
	END LOOP;
END;
/
```

테스트로 수행 후 Alert log 파일을 확인해 보자.
```SQL
SQL> select name, round((total_mb-free_mb)*100/total_mb,1) as usage from v$asm_diskgroup;   -- ASM usage 사용율 확인

NAME                                USAGE
------------------------------ ----------
DATADG                                 43
FRADG                                  73


SQL>  exec monitorASM(50,80);  -- Warning 이 50%, Critical이 80%이므로 FRADG 만  Waring으로 alert log에 출력되어야 한다.

PL/SQL procedure successfully completed.

SQL>  !tail -20 /u01/app/oracle/diag/rdbms/orclasm/ORCLASM/trace/alert_ORCLASM.log

Sun Jun 03 02:45:33 2018
ORA-REDROCK-ASM-002 WARNING FRADG ASM Diskgroup Usage is 73 now!   -- alert log 확인시 원하는 조건대로 잘 출력됨을 확인할 수 있다.

```

정기적으로 점검하도록 DBMS_JOB에 등록해 보자 (5분마다 수행)
```SQL
SQL> BEGIN
DBMS_JOB.isubmit (
job => 200,
what => 'exec monitorASM(50,80);',
next_date => SYSDATE,
interval => 'SYSDATE + 5/24/60 /* every 5 mins */');
COMMIT;
END;
/

```


## 맺음말
 모니터링 스크립트랑 임계치 활용등은 예시일 뿐이니 사용자 환경에 맞게 수정하면 된다.
 요점은 alert log 파일에 SQL 조회 결과를 추가적인 shell script 이용없이 로깅을 하는 부분이다.

## reference 

 - [DBMS_SYSTEM 패키지 설명 : https://www.morganslibrary.org/reference/pkgs/dbms_system.html](https://www.morganslibrary.org/reference/pkgs/dbms_system.html)
