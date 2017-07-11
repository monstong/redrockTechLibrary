

# Oracle Database 12c New feature series

## Miscellaneous

### 1. Licensing information


- RMAN Backup Compression : Extra cost (Advanced Compression Option except RMAN DEFAULT COMPRESS)
- RMAN backup encryption : Extra cost (Advanced Security Option)
- Other most RMAN Features : Enterprise Edition or higher
- Data Pump Data Compression (COMPRESSION=METADATA_ONLY does not require the Advanced Compression option)

- Oracle Data Guard—Far Sync Standby : requires Oracle Active Data Guard option
- Oracle Data Guard—Real-Time Cascading Standbys : requires Oracle Active Data Guard option
- In-Memory Column Store on Active Data Guard standby : Requires the Database In-Memory option and the Active Data Guard option
- Oracle Active Data Guard:
Extra cost option: EE, EE-Exa
Included option: PE, DBCS EE-EP, ExaCS

### 2. RMAN

### 3. Online operations







Online Conversion of a Nonpartitioned Table to a Partitioned Table

Nonpartitioned tables can be converted to partitioned tables online. (Indexes are maintained)
(no impact on the ongoing DMLs)

```
ALTER TABLE employees_convert MODIFY
  PARTITION BY RANGE (employee_id) INTERVAL (100)
  ( PARTITION P1 VALUES LESS THAN (100),
    PARTITION P2 VALUES LESS THAN (500)
   ) ONLINE
  UPDATE INDEXES
 ( IDX1_SALARY LOCAL,
   IDX2_EMP_ID GLOBAL PARTITION BY RANGE (employee_id)
  ( PARTITION IP1 VALUES LESS THAN (MAXVALUE))
 );
```




Online MERGE/SPLIT Partition and Subpartition

The partition maintenance operations SPLIT PARTITION and SPLIT SUBPARTITION can now be executed as online operations
(no impact on the ongoing DMLs)

```
ALTER TABLE ... MODIFY PARTITION ... ONLINE UPDATE INDEXES
ALTER TABLE ... SPLIT/MERGE PARTITION  ... ONLINE UPDATE INDEXES
```

Online Table Move

Nonpartitioned tables can be moved as an online operation without blocking any concurrent DML operations. A table move operation now also supports automatic index maintenance as part of the move.

```
SQL> ALTER TABLE MOVE  ... ONLINE UPDATE INDEXES
```


Partitioning: Table Creation for Partition Exchange

A new DDL command allows the creation of a table that exactly matches the shape of a partitioned table and is therefore eligible for a partition or subpartition exchange of a partitioned table. Note that indexes are not created as part of this command.
 
```
12.1
SQL> CRATE TABLE tab_nonpart (id number, name varchar(20));
SQL> ALTER TABLE tab_part EXCHANGE PARTITION p1 WITH TABLE tab_nonpart;

12.2
SQL> CREATE TABLE tab_nonpart TABLESPACE tbs1
FOR EXCHANGE WITH TABLE tab_part;
```








### 4. Diagnosability

Automatic ADR files Purge

you can specify to a retention policy for automatic purging old ADR contents.

SHORTP_POLICY 
value in hour , default = 720(30days)
ADR contents for SHORTP_POLICY : Trace files, Core dump files


LONGP_POLICY 
value in hours , default = 8760 (365 days)
ADR contents for LONGP_POLICY : Incident information, Incident dumps , Alert logs

SIZEP_POLICY
values in size (nn GB, MB, KB etc)
when adr home size is greater then target size, purge ADR contents as time order.

you can also puge the ADR contents manually

12.1

purge -i (incident ID)
 -age (nn minutes)
 -type (alert, incident, trace ...)

12.2

purge -size (nn bytes)

purge [-i {id | start_id end_id} | 
  -age mins [-type {ALERT|INCIDENT|TRACE|CDUMP|HM|UTSCDMP}]]



set control (SHORTP_POLICY = 360)

show control

estimate (SHORTP_POLICY = 8, LONGP_POLICY=90)


examples

This example purges all diagnostic data in the current ADR home based on the default purging policies:

purge

This example purges all diagnostic data for all incidents between 123 and 456:

purge -i 123 456

This example purges all incident data from before the last hour:

purge -age 60 -type incident






### 5. DATAPUMP

### 6. Data Guard





### References
 - [Oracle Help center : https://docs.oracle.com](https://docs.oracle.com)
