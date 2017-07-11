# Oracle Database 12c New feature series

## In-Memory Column Store

### 1. Licensing Information


 - Data Redaction : required Oracle Advanced Security option
 
    Oracle Advanced Security
    Extra cost option: EE, EE-Exa
    Included option: PE, DBCS EE-HP, DBCS EE-EP, ExaCS

 - Privilege Analysis : required  Oracle Database Vault option
   
   Oracle Database Vault 
   Extra cost option: EE, EE-Exa
   Included option: PE, DBCS EE-HP, DBCS EE-EP, ExaCS

 - Unified Audit : EE or higher


### 2. Data Redaction


12.1 
when you create the policy , you can provide only one "how to redact" specification

12.2 

Each column can its own policy expression

User-defined redaction format available




### 3. Privilege Analysis

12.2  new administrative privilge

SYSRAC : RAC administrator : RAC database management via the Clusterware agent on bahalf of RAC utilties
(CRSCTl, SRVCTL, OCRCONFIG, and CLUVFY )
(no password file support)
used only the CRS oraagent

New OS autentication : OSRACDBA group

It's corresponding to SYSRAC 


Privilege list of SYSRAC

System/ Object privileges
ALTER DATABASE MOUNT
ALTER DATABASE OPEN
ALTER DATABASE OPEN READ ONLY
ALTER DATABASE CLOSE
ALTER SESSION SET EVENTS
ALTER SESSION SET _NOTIFY_CRS
ALTER SESSION SET CONTAINER
ALTER SYSTEM REGISTER
ALTER SYSTEM SET LOCAL_LISTENER
ALTER SYSTEM SET REMOTE_LISTENER
ALTER SYSTEM SET LISTENER_NETWORKS

SELECT X$, GV$, V$ views
EXECUTE
dbms_service
dbms_service_prvt
dbms_session
dbms_ha_alert_prvt

DEQUEUE sys.sys$service_metrics



### 4. Unified Audit


12.1 

1. create audit policy on privileges audited
2. enable policy for all users(default) or 
enable policy for specific users

SQL> CREATE AUDIT POLICY pol_users
PRIVILEGES drop any table;

SQL> AUDIT POLICY pol_users BY hr, sh, oe;

12.2

1. create audit policy on privileges audited
2. enable policy for all users being granted the role.

SQL> CREATE AUDIT POLICY pol_users
PRIVILEGES drop any table;

SQL> AUDIT POLICY pol_users BY USERS WITH GRANTED ROLES dba;




### References
 - [Oracle Help center : https://docs.oracle.com](https://docs.oracle.com)
