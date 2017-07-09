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


12.1
그대로

12.2 

## 6. Customized Evaluation and Execution and Monitoring(DBMS_ILM)
그대로