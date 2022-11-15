--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 NUMBER) ENABLE ROW MOVEMENT;

--
SELECT current_scn, SYSTIMESTAMP FROM v$database;

--
INSERT INTO t1 VALUES (1, 1);
COMMIT;

--
SELECT * FROM t1 AS OF TIMESTAMP TIMESTAMP '2050-01-01 00:00:00';

--
SELECT * FROM t1 AS OF SCN 10000000;

--
SELECT * FROM t1 AS OF TIMESTAMP TIMESTAMP '2049-12-01 00:00:00';

--
SELECT DBMS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER AS scn FROM DUAL;

--
EXEC DBMS_FLASHBACK.ENABLE_AT_TIME (TIMESTAMP '2050-01-01 00:00:00')

SELECT * FROM t1;

EXEC DBMS_FLASHBACK.DISABLE

--
UPDATE t1 SET c2 = 2 WHERE c1 = 1;
COMMIT;

--
DELETE t1 WHERE c1 = 1;
COMMIT;

--
SELECT   c2, versions_starttime, versions_endtime, versions_xid, versions_operation
    FROM t1 VERSIONS BETWEEN TIMESTAMP TIMESTAMP '2050-01-01 00:00:00' AND MAXVALUE
ORDER BY versions_starttime;

--
SELECT   c2, versions_startscn, versions_endscn, versions_xid, versions_operation
    FROM t1 VERSIONS BETWEEN SCN 10000000 AND MAXVALUE
ORDER BY versions_startscn;

--
SELECT   start_timestamp, commit_timestamp, logon_user, operation, undo_sql
    FROM flashback_transaction_query
   WHERE xid = HEXTORAW ('CCCCCCCCCCCCCCCC')
ORDER BY undo_change#;

--
SELECT supplemental_log_data_min FROM v$database;

--
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;

--
FLASHBACK TABLE t1 TO TIMESTAMP TIMESTAMP '2050-01-01 00:01:00';

--
FLASHBACK TABLE t1 TO SCN 10000010;

--
SELECT * FROM t1;

--
PURGE RECYCLEBIN;

DROP TABLE t1;
DROP TABLE t2 PURGE;

--
SELECT object_name, original_name, operation, droptime FROM user_recyclebin;

--
FLASHBACK TABLE t1 TO BEFORE DROP RENAME TO t2;

--
SELECT * FROM t2;

--
SELECT flashback_on FROM v$database;

--
conn /as sysdba

shutdown immediate
startup mount
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE FLASHBACK ON;
ALTER DATABASE OPEN;

--
conn /as sysdba

shutdown immediate
startup mount
FLASHBACK DATABASE TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '10' MINUTE);
ALTER DATABASE OPEN RESETLOGS;
