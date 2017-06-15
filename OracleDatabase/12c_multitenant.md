# Oracle Database 12c New feature series

## Multitenant

### 1. Licensing information

- For all offerings, if you are not licensed for Oracle Multitenant, then the container database architecture is available in single-tenant mode, that is, with one user-created PDB, one user-created application root, and one user-created proxy PDB. 
- EE: Extra cost option; if you are licensed for Oracle Multitenant, then you can create up to 252 PDBs.
- EE-Exa: Extra cost option; if you are licensed for Oracle Multitenant, then you can create up to 4096 PDBs. (12.2 NF)
- DBCS EE-HP, DBCS EE-EP, and ExaCS: Included option; you can create up to 4096 PDBs. (12.2 NF)

### 2. 12c Release 1 New features

#### 2-1. Multitenant architecture

Multiple databases share nothing within the single consolidation server.
 * Too many background processes
 * High shared/process memory (SGA/PGA)
 * Many copies of Oracle Metadata
 
![archtecture of pre 12c](images/12c_multitenant_img1.PNG)



#### 2-1. component of multitent


#### 2-1. creating cdb


#### 2-1. creating pdb (5 ways)


#### 2-1. managing cdb,pdb (tbs)



#### 2-1. user and privileges (dictionary)



#### 2-1. backup and recovery

### 3. 12c Release 2 New features




