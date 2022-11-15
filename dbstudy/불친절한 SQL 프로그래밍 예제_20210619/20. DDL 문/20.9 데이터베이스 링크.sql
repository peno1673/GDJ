--
DROP TABLE t1 PURGE;
CREATE TABLE t1 AS SELECT 1 AS c1 FROM DUAL;

--
DROP DATABASE LINK dl1;
DROP DATABASE LINK dl2;

CREATE DATABASE LINK dl1 USING 'ora12cr2';

CREATE DATABASE LINK dl2 CONNECT TO scott IDENTIFIED BY lion USING 'ora12cr2';

--
CREATE DATABASE LINK d1 USING '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=127.0.0.1)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=ORA12CR2)))';

--
SELECT * FROM t1@dl1;

--
SELECT * FROM t1@dl2;

--
SELECT db_link, username, host FROM user_db_links;

--
ALTER DATABASE LINK dl2 CONNECT TO scott IDENTIFIED BY tiger;

--
SELECT * FROM t1@dl2;

--
DROP DATABASE LINK dl2;

--
SELECT * FROM t1@dl1;

--
SELECT db_link, logged_on, open_cursors, in_transaction FROM v$dblink;

--
COMMIT;

--
SELECT db_link, logged_on, open_cursors, in_transaction FROM v$dblink;

--
ALTER SESSION CLOSE DATABASE LINK dl1;

--
SELECT db_link, logged_on, open_cursors, in_transaction FROM v$dblink;

--
SELECT db_name, host_name, ip_address, last_logon_time, logon_count FROM dba_db_link_sources;

--
CREATE OR REPLACE SYNONYM t1_dl1 FOR t1@dl1;

--
SELECT * FROM t1_dl1;
