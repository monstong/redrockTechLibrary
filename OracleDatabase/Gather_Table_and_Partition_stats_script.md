
```bash
#!/bin/bash
# Gather Oracle table and partition statistics
# (Target : STATS is STALE or null)

export ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1
export ORACLE_USER=oracle
export ORACLE_SID=ORCL1
export DATE=`date +%Y%m%d`
export LOG=/logdir/dba/log/$ORACLE_SID_anal.$DATE.log

echo "------------------------------------" > $LOG
echo "Start time : " `date +%D" "%T` >> $LOG
echo "------------------------------------" >> $LOG
echo $ORACLE_SID "\'s object analyzing started..." >> $LOG

$ORACLE_HOME/bin/sqlplus -s / as sysdba <<TEOF

set timing off
set head off
set feedback off
set pages 0
set lines 300
spool /analdir/dba/bin/analyze_$ORACLE_SID.sql

-- non-partitioned table

SELECT 'exec DBMS_STATS.GATHER_TABLE_STATS(ownname=>'''||a.owner||''',tabname=>'''||a.table_name||''', estimate_percent=> 15, block_sample=>FALSE, method_opt=> ''FOR ALL COLUMNS'', degree=> 6, cascade=>TRUE);'
FROM dba_tab_statistics A,dba_tables B
where a.table_name = b.table_name
and a.owner = b.owner
and b.partitioned = 'NO'
and (a.stale_stats='YES' or a.table_stats is null)
and a.object_type = 'TABLE';

-- partitions from partitioned tables

SELECT 'exec DBMS_STATS.GATHER_TABLE_STATS(ownname=>'''||a.owner||''',tabname=>'''||a.table_name||''', estimate_percent=> 15, block_sample=>FALSE, method_opt=> ''FOR ALL COLUMNS'', degree=> 6, cascade=>TRUE,granularity=>''PARTITION'');'
FROM dba_tab_statistics A
where (a.stale_stats='YES' or a.table_stats is null)
and a.object_type = 'PARTITION';

--  partitioned table global

SELECT 'exec DBMS_STATS.GATHER_TABLE_STATS(ownname=>'''||a.owner||''',tabname=>'''||a.table_name||''', estimate_percent=> 15, block_sample=>FALSE, method_opt=> ''FOR ALL COLUMNS'', degree=> 6, cascade=>TRUE,granularity=>''GLOBAL'');'
FROM dba_tab_statistics A
where (a.stale_stats='YES' or a.table_stats is null)
and a.object_type = 'PARTITION';



-- subpartitions from partitioned tables

SELECT 'exec DBMS_STATS.GATHER_TABLE_STATS(ownname=>'''||a.owner||''',tabname=>'''||a.table_name||''', estimate_percent=> 15, block_sample=>FALSE, method_opt=> ''FOR ALL COLUMNS'', degree=> 6, cascade=>TRUE,granularity=>''SUBPARTITION'');'
FROM dba_tab_statistics A
where (a.stale_stats='YES' or a.table_stats is null)
and a.object_type = 'SUBPARTITION';


-- partitions from subpartitioned tables

SELECT 'exec DBMS_STATS.GATHER_TABLE_STATS(ownname=>'''||a.owner||''',tabname=>'''||a.table_name||''', estimate_percent=> 15, block_sample=>FALSE, method_opt=> ''FOR ALL COLUMNS'', degree=> 6, cascade=>TRUE,granularity=>''PARTITION'');'
FROM dba_tab_statistics A
where (a.stale_stats='YES' or a.table_stats is null)
and a.object_type = 'SUBPARTITION';


-- subpartitioned table global

SELECT 'exec DBMS_STATS.GATHER_TABLE_STATS(ownname=>'''||a.owner||''',tabname=>'''||a.table_name||''', estimate_percent=> 15, block_sample=>FALSE, method_opt=> ''FOR ALL COLUMNS'', degree=> 6, cascade=>TRUE,granularity=>''GLOBAL'');'
FROM dba_tab_statistics A
where (a.stale_stats='YES' or a.table_stats is null)
and a.object_type = 'SUBPARTITION';

spool off

@/analdir/dba/bin/analyze_$ORACLE_SID.sql

exit

TEOF


echo $ORACLE_SID "\'s object analyzing completed..." >> $LOG
echo "------------------------------------" >> $LOG
echo "end time : " `date +%D" "%T` >> $LOG
echo "------------------------------------" >> $LOG

```