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
 
 2-2. Cross-Platform Backup and Restore
BACKUP and RESTORE commands feature new options to create a cross-platform compatible backup and to restore the same on a different platform.

This feature reduces operational complexity using cross-platform transportable tablespace and cross-platform transportable database methods to migrate data between platforms.

 2-3. DUPLICATE Enhancements
This feature disables automatic opening of a recovered clone database so that you can perform any database setting changes before using the NOOPEN option. For example, you may want to modify block change tracking or Flashback Database settings before opening the clone database. This feature is also useful for upgrade scenarios where the database must not be open with RESETLOGS prior to running upgrade scripts.

These enhancements provide additional flexibility during DUPLICATE and expand its use for upgrade scenarios. For example, the NOOPEN option allows DUPLICATE to create a new database as part of an upgrade procedure and leaves the database in a state ready for opening in upgrade mode and subsequent execution of upgrade scripts.

 2-4. Multisection Image Copies
Image copies can be taken with the SECTION SIZE option to divide data files into subsections that can be backed up in parallel across multiple channels. This feature reduces image copy creation time for large data files which is especially beneficial in Exadata environments.

This can also reduce completion time for non-backup use cases. For example, copying a file as part of a transportable tablespace procedure or creating a clone with active duplicate.

 2-5. Multisection Incremental Backups
Incremental backups can be taken with the SECTION SIZE option to divide data files into subsections that can be backed up in parallel across multiple channels. This reduces the incremental backup time for large data files which is especially beneficial in Exadata and cloud environment backups.

 2-6. Network-Enabled RESTORE
RESTORE operations can copy data files from one database to another (for example, a physical standby database to a primary database) over the network. Network-enabled restore also supports compression and multisection options.

The RESTORE operation reduces data file copy time from one database to another by reducing data transfer sizes and by better parallelizing restore workload for large data files across multiple channels.

 2-7. RMAN Command-Line Interface Enhancements
Recovery Manager (RMAN) command-line interface has been enhanced to:

Run SQL as-is at the command line, no longer requiring the SQL command.

Support SELECT statements.

Support the DESCRIBE command on tables and views.

These enhancements provide better ease-of-use when running SQL in an RMAN session.

 2-8. Storage Snapshot Optimization
Backup mode can induce additional system and I/O overhead due to writing whole block images into redo, in addition to increasing procedural complexity in large database environments. A third-party storage snapshot that meets the following requirements can be taken without requiring the database to be placed in backup mode:

Database is crash-consistent at the point of the snapshot.
Write ordering is preserved for each file within a snapshot.
Snapshot stores the time at which a snapshot is completed.
A new RECOVER command keyword, SNAPSHOT TIME, is introduced to recover a snapshot to a consistent point, without any additional manual procedures for point-in-time recovery needs.

The overhead consists of logging additional redo and performing a complete database checkpoint.

  2-9. Table-Level Recovery From Backups
Recovery Manager (RMAN) can restore and recover a table or set of tables from existing backups on disk or tape with the new RECOVER TABLE option.

This option reduces time and disk space to recover a table or set of tables from an existing backup versus manually restoring and recovering the required tablespaces to a separate disk location, then exporting the desired tables and importing them to the original database.

To recover a table or table partition, you must have a full backup of undo, SYSTEM, SYSAUX, and the tablespace that contains the table or table partition.

To recover a table, all partitions that contain the dependent objects of the table must be included in the recovery set. If the indexes or partitions for a table in tablespace tbs1 are contained in tablespace tbs2, then you can recover the table only if tablepsace tbs2 is also included in the recovery set. To recover a table, all partitions that contain the dependent objects of the table must be included in the recovery set.



Limitations of Recovering Tables and Table Partitions from RMAN Backups
When you use the RECOVER command to recover tables or table partitions contained in an RMAN backup, the following limitations exist.

Tables and table partitions belonging to SYS schema cannot be recovered.

Tables and table partitions from SYSTEM and SYSAUX tablespaces cannot be recovered.

Tables and table partitions on standby databases cannot be recovered.

Tables with named NOT NULL constraints cannot be recovered with the REMAP option.


About Renaming Recovered Tables and Table Partitions During RMAN Recovery
When you recover tables or table partitions, you can rename the recovered objects after they are imported into the target database. The REMAP TABLE clause enables you to rename recovered tables or table partitions in your target database. To import the recovered tables or table partitions into a tablespace that is different from the one in which these objects originally existed, use the REMAP TABLESPACE clause of the RECOVER command. Only the tables or table partitions that are being recovered are remapped, the existing objects are not changed.

If a table with the same name as the one that you recovered exists in the target database, RMAN displays an error message indicating that the REMAP TABLE clause must be used to rename the recovered table.

When you recover table partitions, each table partition is recovered into a separate table. Use the REMAP TABLE clause to specify the table names into which each recovered partition must be imported. If you do not explicitly specify table names, RMAN generates table names by concatenating the recovered table name and partition name. The generated names are in the format tablename_partitionname. If a table with this name exists in the target database, then RMAN appends _1 to the name. If this name too exists, then RMAN appends _2 to the name and so on.


Prerequisites for Recovering Tables and Table Partitions from RMAN Backups
The target database must be in read-write mode.

The target database must be in ARCHIVELOG mode.

You must have RMAN backups of the tables or table partitions as they existed at the point in time to which you want recover these objects.

To recover single table partitions, the COMPATIBLE initialization parameter for target database must be set to 11.1.0 or higher.

Recover the selected tables or table partitions to the specified point in time by using the RECOVER TABLE command. You must use the AUXILIARY DESTINATION clause and one of the following clauses to specify the point in time for recovery: UNTIL TIME, UNTIL SCN, or UNTIL SEQUENCE.
You can use the following additional clauses in the RECOVER command:

DUMP FILE and DATAPUMP DESTINATION

Specifies the name of the export dump file containing recovered tables or table partitions and the location in which it must be stored. See "About the Data Pump Export Dump File Used During RMAN Table Recovery" for information.

NOTABLEIMPORT

Indicates that the recovered tables or table partitions must not be imported into the target database. See "About Importing Recovered Tables and Table Partitions into the Target Database"

REMAP TABLE

Renames the recovered tables or table partitions in the target database. See "About Renaming Recovered Tables and Table Partitions During RMAN Recovery"

REMAP TABLESPACE

Recovers the tables or table partitions into a tablespace that is different from the one in which these objects originally existed. See "About Renaming Recovered Tables and Table Partitions During RMAN Recovery"

Recover the tables EMP and DEPT using the following clauses in the RECOVER command: DATAPUMP DESTINATION, DUMP FILE, REMAP TABLE, and NOTABLEIMPORT.
The following RECOVER command recovers the EMP and DEPT tables.

RECOVER TABLE SCOTT.EMP, SCOTT.DEPT
    UNTIL TIME 'SYSDATE-1'
    AUXILIARY DESTINATION '/tmp/oracle/recover'
    DATAPUMP DESTINATION '/tmp/recover/dumpfiles'
    DUMP FILE 'emp_dept_exp_dump.dat'
    NOTABLEIMPORT;
    
Recover partitions using the following RECOVER command with the REMAP TABLE and REMAP TABLESPACE clauses.
RECOVER TABLE SH.SALES:SALES_1998, SH.SALES:SALES_1999
    UNTIL SEQUENCE 354
    AUXILIARY DESTINATION '/tmp/oracle/recover'
    REMAP TABLE 'SH'.'SALES':'SALES_1998':'HISTORIC_SALES_1998',
              'SH'.'SALES':'SALES_1999':'HISTORIC_SALES_1999' 
    REMAP TABLESPACE 'SALES_TS':'SALES_PRE_2000_TS';
    



 
### 3. 12c Release 2 New features


RMAN: Syntax Enhancements
You can use the enhanced SET NEWNAME command for the entire tablespace or database instead of on a per file basis. The new MOVE command enables easier movement of files to other locations instead of using backup and delete. The new RESTORE+RECOVER command for data file, tablespace and database performs restore and recovery in one step versus having to issue offline, restore, recover, and online operations.

These enhancements simplify and improve ease-of-use for the SET NEWNAME, MOVE and RESTORE+RECOVER commands.

Related Topics

Oracle® Database Backup and Recovery Reference
SCAN Listener Supports HTTP Protocol
SCAN listener now enables connections for the recovery server coming over HTTP to be redirected to different machines based on the load on the recovery server machines.

This feature enables connections to be load balanced across different recovery server machines.

Related Topics

Oracle® Real Application Clusters Installation Guide for Linux and UNIX
Oracle Recovery Manager - Enhanced Table Recoveries Across Schemas Using REMAP SCHEMA
The Oracle Recovery Manager (RMAN) table recovery feature offers REMAP TABLE and REMAP TABLESPACE options. The REMAP TABLE option is followed by a list of logical objects to be remapped with their new names. It can be used to rename entire tables or to rename table partitions. The REMAP TABLESPACE option, similarly, remaps all of the specified objects in the existing tablespace into a new one. These options, however, do not offer the flexibility of cross-schema table recovery. This feature adds the REMAP SCHEMA option to the RECOVER TABLE command, which is then passed to the Oracle Data Pump import operation. This feature allows a list of tables and table partitions to be recovered to an alternative schema other than the original schema of the table.

This feature adds more flexibility to import or recover tables across different schemas, which provides more freedom to users and may also provide a better understanding of table-related indexes, triggers, constraints, and so on, if these object names are already existing under the same schema.

Related Topics

Oracle® Database Backup and Recovery User's Guide
Disk Space Check During RECOVER TABLE Operation
The Oracle Recovery Manager (RMAN) table recovery feature implicitly creates auxiliary instance, restores, and recovers tablespaces or data files to perform the table recovery option. However, if there is not enough space to create this instance, an operating system level error is returned. This enhancement provides an up front check on the available disk space for the auxiliary instance, before RMAN executes table recovery.

RECOVER TABLE is a database operation that prevents operating system level error messages due to disk space issues. When this feature is implemented, the user is notified upfront if there is not enough space to perform the operation, and the RECOVER TABLE operation is aborted.

Related Topics

Oracle® Database Backup and Recovery User's Guide
Upgrading the Incremental Transportable Scripts
In Oracle Database 12c Release 1 (12.1), Oracle Recovery Manager introduced cross-platform transport capability. This feature addresses the seamless migration process using scripts that perform tasks for the entire process. It includes:

Preparation of source data
Roll forward phase for the destination data state to catch up with the source data
Transport phase
Customers have a migration path to Oracle Exadata using the My Oracle Support (MOS) Note 1389592.1. However, there are plenty of manual steps that are prone to errors. This feature helps in the seamless migrations of Oracle Database 12c to Oracle Exadata, thus expanding the Oracle Exadata adoption.

Cross-Platform Import of a Pluggable Database into a Multitenant Container Database
The concept of pluggable databases (PDBs) was introduced with Oracle Database 12c (multiple databases sharing a single database instance). This feature is the solution for multitenancy on Oracle Database. This feature addresses:

Plugging in a remote PDB through cross-platform transportable tablespace within this release.
Plugging in a remote non-multitenant container database (CDB) through cross-platform transportable tablespace (converting a non-CDB into a PDB with plans to support versions earlier than Oracle Database 12c).
This feature increases customer adoption of consolidating their databases deployed with different architecture into the multitenant database architecture.

Related Topics

Oracle® Database Backup and Recovery User's Guide
Cross-Platform Migration Support for Encrypted Tablespaces
The concept of pluggable databases (PDBs) was introduced in Oracle Database 12c Release 1 (multiple databases sharing a single database instance). This feature addresses support for encrypted tablespaces which are also to be migrated using cross-platform transport.

This feature increases customer adoption of consolidating their databases which have encrypted tablespaces with the multitenant architecture.

Related Topics

Oracle® Database Backup and Recovery User's Guide
Cross-Platform Support Over The Network
This feature addresses three capabilities of Oracle Recovery Manager (RMAN) in a cross-platform migration:

RMAN support for Data Recovery Advisor on a standby database. Basically, when a data file is lost on a primary or standby database, RMAN generates repair scripts to fetch the file from the primary or standby database.
Support for active duplicate scripts with cross-platform transport. The active duplicate defaults to backup set method only when the number of auxiliary channels is equal to or greater than the target channels and there is a TNS alias for the target database. This is required so that we do not break the existing active duplicate scripts.
Active restore needs the added capability to support backup and restore cross-endian. However, this is limited to the tablespaces and not the entire database. This needs an additional FROM SERVICE syntax in the RESTORE FROM PLATFORM <platform> command such that it starts off an active restore session.
Transporting the data across platforms helps in migration, ease of use, and more adoption of Oracle databases.

Related Topics

Oracle® Database Backup and Recovery User's Guide
Data Guard DUPLICATE Command Enhancements
Far Sync Standby Support

Starting with Oracle Database 12c Release 1 (12.1), a new variant of a standby database was introduced called far sync standby. The goal of this enhancement is to allow users to create this type of standby database using the DUPLICATE command.

Normal Duplicate Database From Physical Standby Database

Currently, it is not possible to create a copy of a database when the target database is a physical standby database. Only a physical standby database can be created when connected to a physical standby database as the target database. The goal here is to remove this and the other possible restrictions, and allow the same set of operations when the target database is a primary or a physical standby database. This enhancement leverages the existing physical standby database for more uses by taking load off the primary database.

Oracle Data Guard is a high availability (HA) or Maximum Availability Architecture (MAA) feature critical for disaster recovery deployments. By enabling easier and more efficient methods to enhance the DUPLICATE command to create far sync standby support and by allowing creation of a regular database, this feature increases the benefits for deploying Oracle Data Guard by offloading processes to the standby database.

Related Topics

Oracle® Data Guard Concepts and Administration
DUPLICATE Command Support for Non Auto-Login Wallet Based Encrypted Backups
Currently, it is not possible to run the DUPLICATE command using encrypted backups where the backup keys are stored in a password-based Oracle Wallet or a key store. Even if a user opens the wallet by starting an auxiliary instance, the DUPLICATE command restarts the auxiliary instance many times during the command execution. Hence, the restores from the encrypted backups after the instance bounce fail because of the inability to decrypt the backups (because Oracle Wallet or the key store is not opened). This restriction is removed with this feature.

This feature enables complete support for encrypted backups with encrypted key storage being auto-login wallet, non-auto-login wallet, or user-specified passwords.

Related Topics

Oracle® Database Backup and Recovery User's Guide



### 4. 


### References 

