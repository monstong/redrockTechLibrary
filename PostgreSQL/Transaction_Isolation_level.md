# Transaction Isolation Levels in DBMS
Prerequisite – Concurrency control in DBMS, ACID Properties in DBMS

To keep DB consistency, it needs to follow ACID properties (Atomicity, Consistency, Isolation and Durability) 

Isolation level is related to tradeoff concurrency performance  vs data consistency

SELECt -> shared lock
DML -> exclusive lock

A transaction isolation level is defined by the following situations –

- Dirty Read : A Dirty read is the situation when a transaction reads a data that has not yet been committed. 
T1 : update A-> B  , but uncommit
T2 : read B
T1 : uncommit , rollback or close
T2 : ?? (B non-existed data)

- Non Repeatable read : Non Repeatable read occurs when a transaction reads same row twice, and get a different value each time. 
T1 : read A
T2 : update A -> B , commit
T1 : read again then B ??

- phantom Read : Phantom Read occurs when two same queries are executed, but the rows retrieved by the two, are different. 
T1 : read A,B where condition C 
T2 : insert or delte some data  where condition C
T1 : re-read (different result)   where condition C

Based on these phenomena, The SQL standard defines four isolation levels :

- Read Uncommitted : Read Uncommitted is the lowest isolation level. 
In this level, one transaction may read not yet committed changes made by other transaction, thereby allowing dirty reads. 
In this level, transactions are not isolated from each other.

- Read Committed : This isolation level guarantees that any data read is committed at the moment it is read. 
Avoid : dirty read (using lock)
May occur : non-repeatable read , phantom read

- Repeatable Read : This is the most restrictive isolation level. 
The transaction holds read locks on all rows it references and writes locks on all rows it inserts, updates, or deletes.
Since other transaction cannot read, update or delete these rows, 
Avoid : non-repeatable read.

- Serializable : This is the Highest isolation level.
A serializable execution is guaranteed to be serializable. 
Serializable execution is defined to be an execution of operations in which concurrently executing transactions appears to be serially executing.