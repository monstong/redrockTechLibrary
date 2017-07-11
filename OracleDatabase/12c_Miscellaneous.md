

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


Parallel Export and Import

enables data from multiple partitions to be loaded in parallel:
 - same partitioning method and parition names only

$ impdp ... DATA_OPTIONS = TRUST_EXISTING_TABLE_PARTITIONS

unloads the data for all table partitions in one partition

$ expdp ... DATA_OPTIONS = GROUP_PARTITION_TABLE_DATA


Dump file validation

check valid data for date and number columns in imported tables
use the option when importing a dump file from an untrusted source (like includes SQL injection code)


$ impdp ... DATA_OPTIONS = VALIDATE_TABLE_DATA

LONG columns Loaded with Network import

12.1

$ impdp ... TABLES=hr.employees NETWORK_LINK=dblink1

-> use INSERT .. AS SELECT method (It can not insert LONG column)

12.2
```
$ impdp ... TABLES=hr.employees   NETWORK_LINK=dblink1
ACCESS_METHOD=DIRECT_PATH DATA_OPTIONS=ENABLE_NETWORK_COMPRESSION
```

ACCESS_METHOD
 DIRECT_PATH -> LONG ok, other may restric
 INSERT_AS_SELECT -> same to pre 12.2
 AUTOMATIC -> autmatically choose one of the above 2 modes for each table



### 6. Data Guard

2.5.6.3 Fast Sync

Data Guard maximum availability supports the use of the NOAFFIRM redo transport attribute. A standby database returns receipt acknowledgment to its primary database as soon as redo is received in memory. The standby database does not wait for the Remote File Server (RFS) to write to a standby redo log file.

This feature provides increased primary database performance in Data Guard configurations using maximum availability and SYNC redo transport. Fast Sync isolates the primary database in a maximum availability configuration from any performance impact due to slow I/O at a standby database.


2.5.6.5 Real-Time Apply is Default Setting for Data Guard

In previous releases, when creating a Data Guard configuration using the SQL command line, the default configuration was to apply redo from archived log files on the standby database. In Oracle Database 12c Release 1 (12.1), the default configuration is to use real-time apply so that redo is applied directly from the standby redo log file.

Recovery time is shortened at failover given that there is no backlog of redo waiting to be applied to the standby database if a failover is required. An active Data Guard user also sees more current data. This enhancement eliminates additional manual configuration (and the requirement that the administrator be aware of the default setting) that was required in past releases. It also makes the default SQL*Plus configuration identical to the default configuration used by the Data Guard broker.


2.5.6.6 Resumable Switchover Operations

In previous releases of Oracle Data Guard broker, if an issue was encountered during a switchover operation, there was no graceful way to resolve the issue and resume the switchover operation from where it left off. Oracle Data Guard broker introduces the capability for resumable switchover along with additional flexibility to facilitate switchover operations when things do not go as expected.

Higher availability during planned maintenance is now available. Issues that may be encountered during switchover operations can be resolved and switchover can resume from where it left off to minimize downtime during planned maintenance operations.


2.5.6.10 Active Data Guard Real-Time Cascade

A standby database that cascades redo to other standby databases can transmit redo directly from its standby redo log file as soon as it is received from the primary database. Cascaded standby databases receive redo in real-time. They no longer have to wait for standby redo log files to be archived before redo is transmitted.

This feature ensures that cascaded standby databases are up-to-date with the primary production database. If used for disaster recovery, cascaded standby databases can deliver nearly the same recover point objective as any other standby database. Read-only queries and reports return up-to-date results.


2.5.6.11 Active Data Guard Far Sync

Far Sync is used to extend zero data loss protection to a remote standby database and avoid the impact to primary database performance of WAN network latency. A primary database ships synchronously to a light-weight instance referred to as a far sync instance (a control file and log files, no data files and no media recovery). The far sync instance then forwards the redo asynchronously to a remote standby database that is the failover target. Additional Far Sync features include the ability to directly service up to 29 remote destinations, and the ability to utilize Oracle Advanced Compression to compress redo for efficient transmission across a WAN. Far Sync is transparent to the administrator with regards to Data Guard role transitions. The same switchover or failover command used for any Data Guard configuration transitions any remote standby databases served by a far sync instance to the primary production role.

Zero data loss protection can be achieved across long distances. The far sync instance is located within a distance of the primary database where synchronous transport does not impact application performance. Far Sync handles all communication with remote standby databases and is transparent when executing a zero data loss failover. Far Sync also offloads the production database of the overhead of servicing multiple remote destinations and redo transport compression.



12.2 

Automatically Synchronize Password Files in Oracle Data Guard Configurations

This feature automatically synchronizes password files across Oracle Data Guard configurations. When the passwords of SYS, SYSDG, and so on, are changed, the password file at the primary database is updated and then the changes are propagated to all standby databases in the configuration.

This feature provides additional automation that further simplifies management of Oracle Data Guard configurations.



Preserving Application Connections to An Active Data Guard Standby During Role Changes

Currently, when a role change occurs and an Active Data Guard standby becomes the primary, all read-only user connections are disconnected and must reconnect, losing their state information. This feature enables a role change to occur without disconnecting the read-only user connections. Instead, the read-only user connections experience a pause while the state of the standby database is changed to primary. Read-only user connections that use a service designed to run in both the primary and physical standby roles are maintained. Users connected through a physical standby only role continue to be disconnected.

This feature improves the user experience and facilitates improved reporting and query capabilities on an Active Data Guard standby during role transitions.



Far Sync Standby Support

Starting with Oracle Database 12c Release 1 (12.1), a new variant of a standby database was introduced called far sync standby. The goal of this enhancement is to allow users to create this type of standby database using the DUPLICATE command.

Normal Duplicate Database From Physical Standby Database

Currently, it is not possible to create a copy of a database when the target database is a physical standby database. Only a physical standby database can be created when connected to a physical standby database as the target database. The goal here is to remove this and the other possible restrictions, and allow the same set of operations when the target database is a primary or a physical standby database. This enhancement leverages the existing physical standby database for more uses by taking load off the primary database.



Oracle Database In-Memory Support on Oracle Active Data Guard

Oracle Active Data Guard allows a standby database to be opened in read-only mode. This capability enables enterprises to off-load production reporting workloads from their primary databases to synchronized standby databases. Thus, you can now use the in-memory column store on an Oracle Active Data Guard standby database. This enables the reporting workload that is processed on the standby database to take advantage of accessing data in a compressed columnar format, in memory. This also enables scans, joins and aggregates to perform much faster than the traditional on-disk formats performed.

It is also possible to populate a completely different set of data in the in-memory column store on the primary and standby databases, effectively doubling the size of the in-memory column store that is available to the application.










### References
 - [Oracle Help center : https://docs.oracle.com](https://docs.oracle.com)
