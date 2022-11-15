-- SYS
CREATE USER u1 IDENTIFIED BY "u1";

GRANT DBA TO u1;

-- U1
sqlplus u1/u1@ora12cr2

-- U1
CREATE USER u2 IDENTIFIED BY "u2";

-- U2
sqlplus u2/u2@ora12cr2

-- U1
GRANT CREATE SESSION TO u2;

-- U2
sqlplus u2/u2@ora12cr2

-- U2
CREATE TABLE t2 (c1 NUMBER);

-- U1
GRANT CREATE TABLE TO u2;

-- U2
CREATE TABLE t2 (c1 NUMBER);

-- U2
INSERT INTO t2 VALUES (1);

-- U1
GRANT UNLIMITED TABLESPACE TO u2;

-- U2
INSERT INTO t2 VALUES (1);

-- U1
SELECT privilege, admin_option FROM dba_sys_privs WHERE grantee = 'U2';

-- U1
SELECT name FROM system_privilege_map;

-- U1
ALTER USER u1 QUOTA UNLIMITED ON users;

-- U1
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 NUMBER);

-- U2
SELECT * FROM u1.t1;

-- U1
GRANT SELECT ON t1 TO u2;

-- U2
SELECT * FROM u1.t1;

-- U2
INSERT INTO u1.t1 VALUES (1, 1);

-- U1
GRANT INSERT ON t1 TO u2;

-- U2
INSERT INTO u1.t1 VALUES (1, 1);

-- U2
UPDATE u1.t1 SET c2 = 2 WHERE c1 = 1;

-- U1
GRANT UPDATE (c2) ON t1 TO u2;

-- U2
UPDATE u1.t1 SET c2 = 2 WHERE c1 = 1;

-- U2
UPDATE u1.t1 SET c1 = 2 WHERE c1 = 1;

-- U1
SELECT owner, table_name, grantor, privilege, grantable, type
  FROM dba_tab_privs
 WHERE grantee = 'U2';

-- U1
SELECT owner, table_name, column_name, grantor, privilege, grantable
  FROM dba_col_privs
 WHERE grantee = 'U2';

-- U1
SELECT object_type_name, privilege_name FROM v$object_privilege;

-- U1
CREATE SYNONYM u2.t1 FOR u1.t1;

-- U2
SELECT * FROM t1;

-- U1
REVOKE CREATE TABLE, UNLIMITED TABLESPACE FROM u2;

-- U1
SELECT privilege, admin_option FROM dba_sys_privs WHERE grantee = 'U2';

-- U1
REVOKE ALL ON t1 FROM u2;

-- U2
SELECT * FROM u1.t1;
