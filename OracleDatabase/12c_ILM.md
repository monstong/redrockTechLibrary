# Oracle Database 12c New feature series

# Oracle database 12c Information Lifecycle Management


## 1. What is ILM ?

### 1-1. the concept of ILM

Information Lifecycle Management (ILM) is a strategy for managing business data over its lifetime.


 - To reduce storage costs
    compress
    move to low cost tablespace
    purge unnecessary rows

 - To improve data access
    partition
    move to  high cost tablespace

![ILM concept 1](images/12c_ILM_img1.PNG)



### 1-2. the solution of ILM

Prior to 12c, DBA has to perform the follow jobs periodically in offine/online time.
 - Plan the lifetime policy per data.
 - Paritionize the target tables.
 - Creating indexes locally or globally.
 - Add New partitions or Remove Old partitions with statistics informations.
 - Optionally Compress rarely used paritions.
 - Moving data to low cost tablespace or other database.
 - Performing a archival(long term) backup.

In 12c, you can operate Above ILM jobs automatically using the following features.

 - Heat Map
 - ADO(Automatic Data Optimization)
 - Paritioning enhancements
 - Compression enhancements



## 2. Licensing information

 - Oracle Partitioning : 
 
    EE and EE-Exa: Extra cost option


 - Heat Map :

    EE and EE-Exa: Requires the Advanced Compression option or the Database In-Memory option (Extra cost options)


 - Automatic Data Optimization :

    EE and EE-Exa: Requires the Advanced Compression option or the Database In-Memory option (Extra cost options)


 - Basic Table Compression : EE or higher (no extra cost option)

 - Oracle Advanced Compression
    
    EE and EE-Exa: Extra cost option

 - Advanced Index Compression

    EE and EE-Exa: Requires the Advanced Compression option

 - Hybrid Columnar Compression

    EE: Requires ZFS, Axiom, or FS1 storage

## 3. Heat Map and Automatic Data Optimization

Heat map : Oracle database 12c includes activity tracking with Heat Map providing the ability to track and mark data as it goes through life cycle changes
 - Data accesses at segment level
 - Data modifications at block and segment levels

Block-level and segment-level statistics  collected in memory are stored in tables in the SYSAUX tablespce.

ADO : Allows you to create policies that use Heat Map statistics to compress and move data only when necessary 
ADO automatically evaluates and executes policies that perform compression and storage tiering actions.

Components of  Heat Map and ADO

 - Data classification
   scope  (tbs level, segment level, row-level
   
 - Automatic Detection(Tracking)
   tracking target operation :  creation, access , modification
   tracking time : After n days/years or tbs full


 - Automatic Action
   compression
   move to other tablespces
   both compress + move


the process to set up Heat map and ADO
picture

ADO policies automatically compress data when it qualifies.
ADO policies automatically move segments when necessary.
ADO is dependent on Heat Map, and will not work unless Heat Map is enabled.

storage tiering read only 추가

enable/diable ado policy per table

ado on/off  database level

stop heat map

clear  heap map stats



## 4. Partitioning enhancements

 Partitioning allows the big segments like tables or indexes to be subdivided into smaller pieces.
 It provides an enhanced I/O performance and easier manageability.
 



12.1
online move partition
(move/split/merge/compress)
DML allowed, not DDL
global and local indexes maintained

12.1.0.2
interval reference paritioning

12.2

 - **Auto-list Partitioning**
 in pre-12c, you create in advanced all partitions for the known values and all unknown values is stored in a DEFAULT partition


in 12.2, you create paritions for known values only and all others are created automatically when using Auto-List partitioning

```
SQL> CREATE TABLE emp ( ... )
PARTITION BY LIST (LOCATION) AUTOMATIC
(PARITION p_EAST VALUES ('NEW YORK'));

SQL> SELECT owner, table_name, partitioning_type AS type, autolist
FROM dba_part_tables
WHERE owner IN('SCOTT');


OWNER	TABLE_NAME	TYPE	AUTOLIST
------  ----------  -----   ---------
SCOTT	EMP	        LIST	YES
```

 - **READ ONLY Partitioning**

Some old partition needs a protection from unexpected DMLs.

In 12.2, you can modify partition in read-only mode.

```
-- set read only mode
SQL> ALTER TABLE sales
MODIFY PARTITION sales_hist READ ONLY;

-- it may be occured an error
SQL> INSERT INTO sales VALUES (1,'A','09-JUL-1980');
ORA-014466: Data in a read-only partition or subpartition cannot be modified

-- set back to read-write mode
SQL> ALTER TABLE sales
MODIFY PARTITION sales_hist READ WRITE;
```


 - **Filtered partition maintenance operations**
 

When MOVE,MERGE and SPLIT partition operations, you can use data filtering with WHERE clause.

```
SQL> ALTER TABLE sales MERGE PARTITION 201601,201602,201603
INTO PARTITION 2016Q1 COMPRESS FOR QUERY HIGH TABLESPACE low_cost_tbs
INCLUDING ROWS WHERE sales_state = 'COMPLETED';
```
 
## 5. Compression enhancements


|Table Compression Method|Direct-Path INSERT|Notes|
|---------|---------|---------|
|Basic table compression<br/>ROW STORE COMPRESS [BASIC]|Rows are compressed with basic table compression.|ROW STORE COMPRESS and ROW STORE COMPRESS BASIC are equivalent. Rows inserted without using direct-path insert and updated rows are uncompressed.|
|Advanced row compression<br/>ROW STORE COMPRESS ADVANCED|Rows are compressed with advanced row compression.|Rows inserted with or without using direct-path insert and updated rows are compressed using advanced row compression.|
|Warehouse compression (Hybrid Columnar Compression)<br/>COLUMN STORE COMPRESS FOR QUERY [LOW/HIGH]|Rows are compressed with warehouse compression.|This compression method can result in high CPU overhead. Updated rows and rows inserted without using direct-path insert are stored in row format instead of column format, and thus have a lower compression level.|
|Archive compression (Hybrid Columnar Compression)<br/>COLUMN STORE COMPRESS FOR ARCHIVE [LOW/HIGH]|Rows are compressed with archive compression.|This compression method can result in high CPU overhead.Updated rows and rows inserted without using direct-path insert are stored in row format instead of column format, and thus have a lower compression level.|


## 6. Customized Evaluation and Execution and Monitoring(DBMS_ILM)

The DBMS_ILM package provides an interface for implementing Information Lifecycle Management (ILM) strategies using Automatic Data Optimization (ADO) policies.

The DBMS_ILM package supports immediate evaluation or execution of Automatic Data Optimization (ADO) related tasks. 

The package supports the following two ways for scheduling ADO actions.

- A database user schedules immediate ADO policy execution on a set of objects.
- A database user views the results of evaluation of ADO policies on a set of objects.The user then adds or deletes objects to this set and reviews the results of ADO policy evaluation again. The user repeats this step to determine the set of objects for ADO execution. The user can then perform immediate scheduling of ADO actions on this set of objects


|Subprogram|Description|
|-----|-----|
|ADD_TO_ILM Procedure|Adds the object specified through the argument to a particular ADO task and evaluates the ADO policies on this object|
|ARCHIVESTATENAME Function|Returns the value of the ORA_ARCHIVE_STATE column of a row-archival enabled table|
|EXECUTE_ILM Procedure|Executes an ADO task.|
|EXECUTE_ILM_TASK Procedure|Executes an ADO task that has been evaluated previously|
|PREVIEW_ILM Procedure|Evaluates all ADO policies in the scope specified by means of an argument|
|REMOVE_FROM_ILM Procedure|Removes the object specified through the argument from a particular ADO task|
|STOP_ILM Procedure|Stops ADO-related jobs created for a particular ADO task|


The DBMS_ILM_ADMIN package provides an interface to customize Automatic Data Optimization (ADO) policy execution. 

|Subprogram|Description|
|-----|-----|
|CLEAR_HEAT_MAP_ALL Procedure|Deletes all rows except the dummy row|
|CLEAR_HEAT_MAP_TABLE Procedure|Clears all or some statistics for the heat map table, deleting rows for a given table or segment which match a given pattern, or all such rows|
|CUSTOMIZE_ILM Procedure|Customizes environment for ILM execution by specifying the values for ILM execution related parameters|
|DISABLE_ILM Procedure|Turns off all background ILM scheduling|
|ENABLE_ILM Procedure|Turns on all background ILM scheduling|
|SET_HEAT_MAP_ALL Procedure|Updates or inserts heat map rows for all tables|
|SET_HEAT_MAP_START Procedure|Sets the start date for collecting heat map data|
|SET_HEAT_MAP_TABLE Procedure|Updates or inserts a row for the specified table or segment|