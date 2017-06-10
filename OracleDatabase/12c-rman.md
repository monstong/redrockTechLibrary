# Oracle Database 12c New feature series

## RMAN enhancements

### 1. Licensing information

- RMAN Backup Compression : Extra cost (Advanced Compression Option except RMAN DEFAULT COMPRESS)
- RMAN backup encryption : Extra cost (Advanced Security Option)
- Other most RMAN Features : Enterprise Edition or higher

### 2. 12c Release 1 New features

#### 2-1. Active Database Duplication Enhancements
 Active ```DUPLICATE``` supports the ```SECTION SIZE``` option to divide data files into subsections that are restored in parallel 
 across multiple channels on the auxiliary database. Active ```DUPLICATE``` supports compression during the restore phase.
 
 The benefits of this new feature include:
 - Reduce active duplicate time for databases with large data files by more evenly spreading out the restore workload across multiple channels on the auxiliary database.
 - Reduce active duplicate time by more efficiently using network bandwidth using compression during data transfer operations.
 
 ```SQL
 DUPLICATE TARGET DATABASE TO dup_db
     FROM ACTIVE DATABASE
     PASSWORD FILE          
     SECTION SIZE 400M;
 ```
 
#### 2-2. Cross-Platform Backup and Restore
BACKUP and RESTORE commands feature new options to create a cross-platform compatible backup and to restore the same on a different platform.

This feature reduces operational complexity using cross-platform transportable tablespace and cross-platform transportable database methods to migrate data between platforms.

#### 2-3. DUPLICATE Enhancements
This feature disables automatic opening of a recovered clone database so that you can perform any database setting changes before using the ```NOOPEN``` option. 

For example, you may want to modify block change tracking or Flashback Database settings before opening the clone database. 

This feature is also useful for upgrade scenarios where the database must not be open with RESETLOGS prior to running upgrade scripts.


#### 2-4. Multisection Image Copies
Image copies can be taken with the ```SECTION SIZE``` option to divide data files into subsections that can be backed up in parallel across multiple channels. 

This feature reduces image copy creation time for large data files which is especially beneficial in Exadata environments.

#### 2-5. Multisection Incremental Backups
Incremental backups can be taken with the ```SECTION``` SIZE option to divide data files into subsections that can be backed up in parallel across multiple channels. 

This reduces the incremental backup time for large data files which is especially beneficial in Exadata and cloud environment backups.

#### 2-6. Network-Enabled RESTORE
RESTORE operations can copy data files from one database to another (for example, a physical standby database to a primary database) over the network. Network-enabled restore also supports compression and multisection options.

The RESTORE operation reduces data file copy time from one database to another by reducing data transfer sizes and by better parallelizing restore workload for large data files across multiple channels.

#### 2-7. RMAN Command-Line Interface Enhancements
 RMAN command-line interface has been enhanced to:

 - Run SQL as-is at the command line, no longer requiring the SQL command.
 - Support SELECT statements.
 - Support the DESCRIBE command on tables and views.

#### 2-8. Storage Snapshot Optimization
Backup mode can induce additional system and I/O overhead due to writing whole block images into redo, in addition to increasing procedural complexity in large database environments. 
A third-party storage snapshot that meets the following requirements can be taken without requiring the database to be placed in backup mode:
 - Database is crash-consistent at the point of the snapshot.
 - Write ordering is preserved for each file within a snapshot.
 - Snapshot stores the time at which a snapshot is completed.

A new RECOVER command keyword, SNAPSHOT TIME, is introduced to recover a snapshot to a consistent point, without any additional manual procedures for point-in-time recovery needs.

The overhead consists of logging additional redo and performing a complete database checkpoint.

#### 2-9. Table-Level Recovery From Backups
  RMAN can restore and recover a table or set of tables from existing backups on disk or tape with the new RECOVER TABLE option.

 - Required Tablespaces
   
   * a full backup of undo, SYSTEM, SYSAUX, and the tablespace that contains the table or table partition.
   * To recover a table, all partitions that contain the dependent objects of the table must be included in the recovery set. 
     (ex : index is stored other tablespace )
 
 - Limitations of Recovering Tables and Table Partitions from RMAN Backups

   * Tables and table partitions belonging to SYS schema cannot be recovered.
   * Tables and table partitions from SYSTEM and SYSAUX tablespaces cannot be recovered.
   * Tables and table partitions on standby databases cannot be recovered.
   * Tables with named NOT NULL constraints cannot be recovered with the REMAP option.

 - About Renaming Recovered Tables and Table Partitions During RMAN Recovery
   
   The REMAP TABLE clause enables you to rename recovered tables or table partitions in your target database. 
   
   To import the recovered tables or table partitions into a tablespace that is different from the one in which these objects originally existed, use the REMAP TABLESPACE clause of the RECOVER command. Only the tables or table partitions that are being recovered are remapped, the existing objects are not changed.
   
   If a table with the same name as the one that you recovered exists in the target database, RMAN displays an error message indicating that the REMAP TABLE clause must be used to rename the recovered table.
   
   When you recover table partitions, each table partition is recovered into a separate table. Use the REMAP TABLE clause to specify the table names into which each recovered partition must be imported. 
   If you do not explicitly specify table names, RMAN generates table names by concatenating the recovered table name and partition name. 
   The generated names are in the format tablename_partitionname. If a table with this name exists in the target database, then RMAN appends _1 to the name. If this name too exists, then RMAN appends _2 to the name and so on.


 - Prerequisites for Recovering Tables and Table Partitions from RMAN Backups
    * The target database must be in read-write mode.
    * The target database must be in ARCHIVELOG mode.
    * You must have RMAN backups of the tables or table partitions as they existed at the point in time to which you want recover these objects.
    * To recover single table partitions, the COMPATIBLE initialization parameter for target database must be set to 11.1.0 or higher.

 - RECOVER TABLE optoins
    * AUXILIARY DESTINATION clause and one of the following clauses to specify the point in time for recovery: 
    * UNTIL TIME, UNTIL SCN, or UNTIL SEQUENCE.
    * DUMP FILE and DATAPUMP DESTINATION : Specifies the name of the export dump file containing recovered tables or table partitions and the location in which it must be stored. See "About the Data Pump Export Dump File Used During RMAN Table Recovery" for information.
    * NOTABLEIMPORT : Indicates that the recovered tables or table partitions must not be imported into the target database. See "About Importing Recovered Tables and Table Partitions into the Target Database"
    * REMAP TABLE : Renames the recovered tables or table partitions in the target database. See "About Renaming Recovered Tables and Table Partitions During RMAN Recovery"
    * REMAP TABLESPACE : Recovers the tables or table partitions into a tablespace that is different from the one in which these objects originally existed. 
    
 - Examples
    1) Recover the tables EMP and DEPT using the following clauses in the RECOVER command: DATAPUMP DESTINATION, DUMP FILE, REMAP TABLE, and NOTABLEIMPORT.
    ```SQL
    RMAN> RECOVER TABLE SCOTT.EMP, SCOTT.DEPT
          UNTIL TIME 'SYSDATE-1'
          AUXILIARY DESTINATION '/tmp/oracle/recover'
          DATAPUMP DESTINATION '/tmp/recover/dumpfiles'
          DUMP FILE 'emp_dept_exp_dump.dat'
          NOTABLEIMPORT;
    ```

    2) Recover partitions using the following RECOVER command with the REMAP TABLE and REMAP TABLESPACE clauses.
    ```SQL
    RMAN> RECOVER TABLE SH.SALES:SALES_1998, SH.SALES:SALES_1999
          UNTIL SEQUENCE 354
          AUXILIARY DESTINATION '/tmp/oracle/recover'
          REMAP TABLE 'SH'.'SALES':'SALES_1998':'HISTORIC_SALES_1998',
              'SH'.'SALES':'SALES_1999':'HISTORIC_SALES_1999' 
          REMAP TABLESPACE 'SALES_TS':'SALES_PRE_2000_TS';
    ```

### 3. 12c Release 2 New features

 3-1. upgrade and drop the recovery catalog in one command (noprompt available)
 ```
 RMAN> UPGRADE CATALOG NOPROMPT;
 
 RMAN> DROP CATALOG NOPROMPT;
 ```
 
 3-2. REPAIR command enhancements
 When you recover some data files to prior to 12.2, you have to follow the below steps.
  - take files offline
  - restore files
  - recover files
  - take files online
  
  In 12,2 , you can use one command ```REPAIR``` to recover some files.
  
  ```SQL
  RMAN> REPAIR DATABASE;
  
  RMAN> REPAIR PLUGGABLE DATABASE pdb1;
  
  RMAN> REPAIR TABLESPACE tbs1;
  
  RMAN> REPAIR DATAFILE 15;
  ```
 
 3-3. Recover database until available redo
 When you recover database using arhived redo logs prior to 12.2 , you have to find the last available archived log file(redo) manually using ```UNTIL CANCEL``` clause.
 
 In 12.2 you can use ```UNTIL AVAILABLE REDO``` clause then oracle apply the last available redo log(archived or redo log file) automatically
 
 ```SQL
 RMAN> RECOVER DATABASE UNTIL AVAILABLE REDO;
 
 RMAN> ALTER DATABASE OPEN RESETLOGS;
 ```
 
  3-4. Table recovery enhancement
  In 12.1 you can recover the table/partition within same schema.
  In 12.2 you can recover the table/partition across different schema.
  
  ```SQL
  RMAN> RECOVER TABLE "SCOTT"."EMP"
  UNTIL TIME 'SYSDATE -2/24'
  AUXILIARY DESTINATION '/opt/oradata/aux'
  REMAP TABLE "SCOTT"."EMP":"JAMES"."EMP2";
  ```
 
 In 12.1 disk space is not checked before the auxiliary instance is created
 In 12.2 disk space is cheked before the auxiliary instance is created 
 -> If there is not enough free space for the table recovery, the error is ocurred immediately and the table recovery is not executed.
 
 3-5. Data Guard DUPLICATE Command Enhancements
 - Far Sync Standby Support :
 
   Starting with Oracle Database 12c Release 1 (12.1), a new variant of a standby database was introduced called far sync standby. 
   The goal of this enhancement is to allow users to create this type of standby database using the DUPLICATE command.

- Normal Duplicate Database From Physical Standby Database : 

  Currently, it is not possible to create a copy of a database when the target database is a physical standby database. 
  Only a physical standby database can be created when connected to a physical standby database as the target database. 
  The goal here is to remove this and the other possible restrictions, and allow the same set of operations when the target 
  database is a primary or a physical standby database. 
  This enhancement leverages the existing physical standby database for more uses by taking load off the primary database.


### References 
- [Oracle Help Center](https://docs.oracle.com)


