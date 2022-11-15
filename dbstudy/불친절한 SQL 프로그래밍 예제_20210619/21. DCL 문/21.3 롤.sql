-- U1
CREATE ROLE r1;

-- U1
GRANT CREATE SESSION, CREATE TABLE TO r1;

-- U1
SELECT privilege, admin_option FROM dba_sys_privs WHERE grantee = 'R1';

-- U1
CREATE ROLE r2;

-- U1
GRANT SELECT, INSERT, UPDATE (c2) ON t1 to r2;

-- U1
SELECT owner, table_name, grantor, privilege, grantable, type
  FROM dba_tab_privs
 WHERE grantee = 'R2';

-- U1
SELECT owner, table_name, column_name, grantor, privilege, grantable
  FROM dba_col_privs
 WHERE grantee = 'R2';

-- U1
CREATE ROLE r2;

-- U1
GRANT SELECT, INSERT, UPDATE (c2) ON t1 to r2;

-- U1
SELECT owner, table_name, grantor, privilege, grantable, type
  FROM dba_tab_privs
 WHERE grantee = 'R2';

-- U1
SELECT owner, table_name, column_name, grantor, privilege, grantable
  FROM dba_col_privs
 WHERE grantee = 'R2';

-- U1
GRANT r2 TO r1;

-- U1
SELECT granted_role, admin_option FROM dba_role_privs WHERE grantee  = 'R1';

-- U1
SELECT role, password_required FROM dba_roles WHERE role IN ('R1', 'R2');

-- U1
GRANT r1 TO u2;

-- U2
sqlplus u2/u2@ora12cr2

-- U1
ALTER ROLE r1 IDENTIFIED BY "r1";

-- U1
DROP ROLE r2;

-- U1
WITH w1 AS (
    SELECT NULL    AS p, username     AS c, 'U' AS t FROM dba_users     UNION
    SELECT grantee AS p, privilege    AS c, 'P' AS t FROM dba_sys_privs UNION
    SELECT grantee AS p, granted_role AS c, 'R' AS t FROM dba_role_privs)
SELECT     t, LPAD (' ', (LEVEL - 1) * 4) || c AS privilege
      FROM w1
START WITH p IS NULL
       AND c = 'U2'
CONNECT BY p = PRIOR c;

-- U1
SELECT role, password_required FROM dba_roles WHERE role = 'R1';

-- U2
sqlplus u2/u2@ora12cr2

CREATE TABLE t3 (c1 NUMBER);

-- U2
SET ROLE r1 IDENTIFIED BY "r1";

CREATE TABLE t3 (c1 NUMBER);

-- U2
SELECT * FROM session_privs;

SELECT * FROM session_roles;

-- U1
ALTER ROLE r1 NOT IDENTIFIED;

-- U1
SELECT granted_role, default_role FROM dba_role_privs WHERE grantee = 'U2';

-- U1
ALTER USER u2 DEFAULT ROLE NONE;

-- U2
sqlplus u2/u2@ora12cr2

CREATE TABLE t4 (c1 NUMBER);

-- U2
SET ROLE ALL;

CREATE TABLE t4 (c1 NUMBER);
