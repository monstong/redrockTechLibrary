# Postgresql database

## Streaming replication

### 1. 

### 2. 

### 3. 


Interaction with HOT
HOT (Heap-only tuples) is a major performance feature that was added in Postgres 8.3. This allowed UPDATES to rows (which, owing to Postgres's MVCC architecture, are implemented with a deletion and insertion of physical tuples) to only have to create a new physical heap tuple when inserting, and not a new index tuple, if and only if the update did not affect indexed columns.
With HOT, it became possible for an index scan to traverse a so-called HOT chain; it could get from the physical index tuple (which would probably have been created by an original INSERT, and related to an earlier version of the logical tuple), to the corresponding physical heap tuple. The heap tuple would itself contain a pointer to the next version of the tuple (that is, the tuple ctid), which might, in turn, have a pointer of its own. The index scan eventually arrives at tuple that is current according to the query's snapshot.
HOT also enables opportunistic mini-vacuums, where the HOT chain is "pruned".
All told, this performance optimisation has been found to be very valuable, particularly for OLTP workloads. It is quite natural that tuples that are frequently updated are generally not indexed. However, when considering creating a covering index, the need to maximise the number of HOT updates should be carefully weighed.
You can monitor the total proportion of HOT updates for each relation using this query.




This section provides an overview of TOAST (The Oversized-Attribute Storage Technique).

PostgreSQL uses a fixed page size (commonly 8 kB), and does not allow tuples to span multiple pages. Therefore, it is not possible to store very large field values directly. To overcome this limitation, large field values are compressed and/or broken up into multiple physical rows. This happens transparently to the user, with only small impact on most of the backend code. The technique is affectionately known as TOAST (or "the best thing since sliced bread"). The TOAST infrastructure is also used to improve handling of large data values in-memory.


timelineId

switch over 시미다 증가
8자리앞

arch, wal segment file . history  pitr 정보 보관 


recovery.conf

standby_mode = 'on'
primary_conninfo = 'user=edbadmin password=edbadmin host=localhost port=6666 sslmode=prefer sslcompression=1 krbsrvname=postgres target_session_attrs=any'
trigger_file='/PAS/PROD/trigger'
restore_command='cp /PAS/PROD/pgarch/%f %p'

switch over 시 arch 공유 하거나 미리 이동

trigger file 만드는 수간  promotion  발생

rsync는  pg_basebackup 말고 수동 데이터 디렉토리 싱크  리모트로
(start bakcup > rsync > stop backu)
또는
pg_basebackup 

-R 옵션은  recovery.conf 자동 생성


