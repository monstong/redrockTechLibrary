# step 0. remove unnecessary files

root$ cd /stage
root$ rm -rf database
root$ rm -rf Packages
root$ rm -rf *.zip

# step 2. upload files /stage using winscp

scripts : install12c.sh , dbsw.rsp , createDB.sh , dbca.rsp 
sw binary : linux64_12201_database.zip

# step 3. install SW (12.2)

root$ cd /stage
root$ sh -x install12c.sh /stage

After script completed,please run root.sh script as the instruction.

# step 4. create DB

root$ su - ora12c
ora12c$ cd /stage
ora12c$ sh -x createDB.sh /stage ORCL12 /oradata/DUPORCL


# step 5. create sample user and data and tablespaces

su - ora12c
sqlplus / as sysdba
create tablespace TBM;
create tablespace INDX;

create user scott identified by tiger default tablespace TBM;
grant connect, resource, unlimited tablespace to scott;

create user jamesidentified by tiger;
grant connect, resource, unlimited tablespace to james;


conn scott/tiger

create table emp (id number, name varchar2(10));
create index emp_idx emp(id) tablespace INDX;

insert into emp values(1,'aaa');
insert into emp values(2,'bbb');
commit;

exit


# step 6. backup database
rman target /
backup database;

exit

# step 7. drop table emp and record the time before you drop the table

sqlplus / as sysdba
select systimestamp from dual;

drop table scott.emp purge;
exit


# step 8. run table recovery 1

su - ora12c
mkdir -p /diskbackup/12c/aux
mkdir -p /diskbackup/12c/dump

rman target /

RMAN> RECOVER TABLE SCOTT.EMP, SCOTT.DEPT
      UNTIL TIME "to_date(time as you recorded before)"
      AUXILIARY DESTINATION '/diskbackup/12c/aux'
      DATAPUMP DESTINATION '/diskbackup/12c/dump'
      DUMP FILE 'emp_exp_dump.dat'
      NOTABLEIMPORT;
exit

import the table using data pump

# step 9. run table recovery 2

mkdir -p /diskbackup/12c/aux2

RMAN> RECOVER TABLE "SCOTT"."EMP"
      UNTIL TIME "to_date(time as you recorded before)"
      AUXILIARY DESTINATION '/diskbackup/12c/aux2'
      REMAP TABLE "SCOTT"."EMP":"JAMES"."EMP"
      REMAP TABLESPACE "TBS":"USERS";

RMAN> exit
sqlplus james/scott
select * from emp;
select tablespace_name from user_segments where segment_name = 'EMP';
