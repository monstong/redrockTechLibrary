# Oracle Database 12c New feature series

## Multitenant

### 1. Licensing information

- For all offerings, if you are not licensed for Oracle Multitenant, then the container database architecture is available in single-tenant mode, that is, with one user-created PDB, one user-created application root, and one user-created proxy PDB. 
- EE: Extra cost option; if you are licensed for Oracle Multitenant, then you can create up to 252 PDBs.
- EE-Exa: Extra cost option; if you are licensed for Oracle Multitenant, then you can create up to 4096 PDBs. (12.2 NF)
- DBCS EE-HP, DBCS EE-EP, and ExaCS: Included option; you can create up to 4096 PDBs. (12.2 NF)

### 2. 12c Release 1 New features

#### 2-1. Multitenant architecture

In Oracle 11g R2, <br/>
Multiple databases share nothing within the single consolidation server.
 * Too many background processes
 * High shared/process memory (SGA/PGA)
 * Many copies of Oracle Metadata
 
![archtecture of pre 12c](images/12c_multitenant_img1.PNG)

In Oracle 12c,<br/>
A multitenant environment enables the central management of multiple PDBs in a single installation and enables you to accomplish several goals.
 * Less then Instance resources(BG processes and memory usage)
 * provides isolation between PDBs
 * Share Oracle-supplied dictionary objects(metadata)

![archtecture of 12c](images/12c_multitenant_img2.PNG)

#### 2-2. The purpose of multitenant environment

 * Cost reduction <br/> 
 By consolidating hardware and database infrastructure to a single set of background processes, and efficiently sharing computational and memory resources, you reduce costs for hardware and maintenance.

 * Easier and more rapid movement of data and code <br/>
 By design, you can plug a PDB into a CDB, unplug the PDB from the CDB, and then plug this PDB into a different CDB. Therefore, you can easily move an application's database back end from one server to another.

 * Easier management and monitoring of the physical database <br/>
 The CDB administrator can manage the environment as an aggregate by executing a single operation, such as patching or performing an RMAN backup, for all hosted tenants and the CDB root.

 * Separation of data and code <br/>
 Although consolidated into a single physical CDB, PDBs mimic the behavior of traditional non-CDBs. For example, a PDB administrator can flush the shared pool or buffer cache in the context of a PDB without affecting other PDBs in the CDB.

 * Fewer patches and upgrades : It is easier to apply a patch to one CDB than to multiple non-CDBs and to upgrade one CDB than to upgrade several non-CDBs.

 * To change the DB configuration easier <br/>
 It can be changed easire between RAC, single , ADG and etc.

#### 2-3. Components of a CDB
CDB is the Parent Container Database in a multitenant environment. It is physical instance by itself. Its container ID is 0 

A CDB includes the following components(containers):

 - Root
 
 The root, named CDB$ROOT, stores Oracle-supplied metadata and common users. An example of metadata is the source code for Oracle-supplied PL/SQL packages. A common user is a database user known in every container. A CDB has exactly one root. Its container ID is 1

 - Seed
 
 The seed, named PDB$SEED, is a template that you can use to create new PDBs. You cannot add objects to or modify objects in the seed. A CDB has exactly one seed. Its container ID is 2

- PDBs

A PDB appears to users and applications as if it were a non-CDB. For example, a PDB can contain the data and code required to support a specific application. A PDB is fully backward compatible with Oracle Database releases before Oracle Database 12c.
(Maximum available PDBs : 253 include Seed PDB)

#### 2-4. Configurations of multitenant container database.
There are 3 possible configurations in oracle database 12c.
 * multitenant environment : 1 CDB and more then 1 PDBs
 * singletenant environment : 1 CDB and 1 PDB (no extra cost)
 * non-CDB : like the classical 11g DB

 Multitenent container database consists of
![archtecture of 12c](images/12c_multitenant_img3.PNG)

 Seperating SYSTEM and USER DATA

 Shared Resources
 - Instance(SGA and Background processes)
 - Control files and Redo log files(online/archived)
 - ADR(Automatic Diagnostic Repository : alert log file etc)
 - Parameter file(SPfile/Pfile) and Password file
 - Oracle Net configuration files(listener.ora, sqlnet.ora, tnsnames.ora)
 - UNDO tablespace per CDB instance
 - Default temporary tablespace
 - Chacracterset per CDB instance(Unicode recommended)
 - AWR(Automatic Workload Repository)
 - Common Objects(including PL/SQL) : Oracle-supplied object like OBJ$,TAB$ etc

 Non-shared Resources
 - SYSTEM, SYSAUX tablespace : oracle supplied objects pointing to Root containers's Dictionary
 - Local temporary tablespace (optional)
 - User tablespace
 - Local users and roles

#### 2-5. Creating a CDB

You can create a CDB using,
 - DBCA is a utility with a graphical user interface that enables you to configure a CDB, create PDBs, plug in PDBs, and unplug PDBs.

 - Oracle Enterprise Manager Cloud Control is a system management tool with a graphical user interface that enables you to manage and monitor a CDB and its PDBs.

 - Oracle SQL Developer is a graphical version of SQL*Plus that gives database developers a convenient way to perform basic tasks.

 - The Server Control (SRVCTL) utility can create and manage services for PDBs.

 - EM Express


Creating a CDB using DBCA


#### 2-1. Creating and Dropping a PDB
There are 4 ways to create a PDB in Oracle 12c.

 - Preparing for PDBs
 
 Prerequisites must be met before creating a PDB.

 - Creating a PDB Using the Seed
 
 You can use the CREATE PLUGGABLE DATABASE statement to create a PDB in a CDB using the files of the seed.

 - Creating a PDB by Cloning an Existing PDB or Non-CDB
 
 You can create a PDB by cloning a local PDB, a remote PDB, or a non-CDB.

 - Creating a PDB by Plugging an Unplugged PDB into a CDB
 
 You can create a PDB by plugging an unplugged PDB into a CDB.

 - Creating a PDB Using a Non-CDB 
 
 You can create a PDB using a non-CDB in different ways.

 - Unplugging a PDB from a CDB
 
 You can unplug a PDB from a CDB.

 - Dropping a PDB
 
 The DROP PLUGGABLE DATABASE statement drops a PDB. You can drop a PDB when you want to move the PDB from one CDB to another or when you no longer need the PDB.




#### 2-1. Managing a CDB and PDBs

- connecting a CDB and PDB

- Start and stop a CDB and PDB


- Multitenant data dictionary

![archtecture of 12c](images/12c_multitenant_img4.PNG)

- Shared and Non-shared Object

    * Metadata-linked object
   * Object-linked object

- Configuring an initialization parameter


#### 2-1. user and privileges (dictionary)



#### 2-1. backup and recovery

### 3. 12c Release 2 New features


### References
[Oracle Help center : https://docs.oracle.com](https://docs.oracle.com)


