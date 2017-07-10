# Oracle Database 12c New feature series

## In-Memory Column Store

### 1. What is an In-Memory Database

Data is getting bigger explosive every year.

New feature that provides the faster SQL performance for the very large tables, is required in most huge databasae systems, especially a data warehousing environment.

In-memory database commonly consists of two parts.

- Column oriented database

- Full data caching



![IM DB img1](images/12c_IM_img1.PNG)


LIst of INDB solutions

|Vendor|Solution|
|-----|-----|
|SAP|HANA, ASE|
|Oracle| TimesTen, Oracle 12c|
|IBM|SolidDB, BLU|
|Microsoft|SQL Server|
|Altibase|Altibase|
|Sunje soft|SunDB|
|Etc|Pivotal,VoltDB,Aerospike,MemSQL,Teradata,Kognito,Exasol etc|

**Fact & Dimension Table?**

 - Fact Table : 
 Fact tables contain the data corresponding to a particular business process. Each row represents a single event associated with that process and contains the measurement data associated with that event. <br/> For example, a retail organization might have fact tables related to customer purchases, customer service telephone calls, and product returns. The customer purchases table would likely contain information about the amount of the purchase, any discounts applied and the sales tax paid.

 - Dimension Table : 
 Dimensions describe the objects involved in a business intelligence effort. While facts correspond to events, dimensions correspond to people, items, or other objects. For example, in the retail scenario, we discussed that purchases, returns, and calls are facts. On the other hand, customers, employees, items and stores are dimensions and should be contained in dimension tables.

 - refer to [Facts vs. Dimensions Tables In Database Understanding Key Business Intelligence Terms](https://www.thoughtco.com/facts-vs-dimensions-1019646)


### 2. Oracle In-Memory Column Store

Goals of In-Memory Column Store

Instanct query response:
 Faster queries on very large tables on any columns(100x)
 Using scans, joins, and aggregates
 Best suited for analytics : few columns/ many rows  
 (ex : A fact table that has numeric columns (Qty, Amount, etc in an OLAP system)

Faster DML : Removal of most analytics indexes (3 ~ 4x)

 
Benefits

Active Cata in In-memory column store

Fully supported on RAC
Fully supported with multitenant architecture
To use In-Memory Column Store
 No SQL tuning anymore
 No restriction on SQL
 No change for backup and recovery operations
 No migration of data


### 3. Licensing information
Oracle Database In-Memory option : 
Extra cost option for EE, EE-Exa
Included option for  PE, DBCS EE-EP, ExaCS

Includes the following features:
 - In-Memory Column Store
 - Fault Tolerant In-Memory Column Store
 = In-Memory Aggregation
 - Heat Map
 - Automatic Data Optimization

### 4. IM Column Store architecture

* Columnar format  (inmemory_size -  no lru, not work asmm)

- In-Memory Column Unit  (IMCU : Chunk) has several columns
- IMCO : coordinator process (population of IM objects)
- SMCO/Wnnn : worker process (population of IM objects)
- TX journel :
- PRIORITY - order of loading IM objects to Columnar format area. 
    NONE: default, on demand
    CRITICAL : when instance startup
    HIGH/MEDIUM/LOW : as an priority
  MEMCOMPRESS : 
    NO MEMCOMPRESS
    MEMPROCESS FOR QUERY [LOW/HIGH] 
    MEMCOMPRESS FOR cAPACITY [LOW/HIGH]

  DUPLICATE :
    NO DUPLICATE : [default] 1 copy of imcu on RAC
    DUPLICATE : copy of imcu across some instance on RAC
    DUPLICATE ALL : copies of imcu across all instances on RAC




### 5. Deploying IM column store



### 6. Recommendations



### In-memory caching

full db caching

big table caching
(Auto mode)

12.2 NF

set dynamic param  im_memory_size

im faststart

query table : join groups

cu  to enable  expression, virtual columns



### References
 - [Oracle Help center : https://docs.oracle.com](https://docs.oracle.com)

 - [Exam : http://exem.tistory.com/771](http://exem.tistory.com/771)