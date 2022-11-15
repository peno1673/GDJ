--
SELECT * FROM v$transaction;

--
INSERT INTO t1 VALUES (3, 50);

--
SELECT xid, xidusn, xidslot, xidsqn, start_date, start_scn FROM v$transaction;

--
COMMIT;

--
SELECT * FROM v$transaction;

--
SELECT cd, vl, ORA_ROWSCN, SCN_TO_TIMESTAMP (ORA_ROWSCN) AS c1 FROM t1;

--
SELECT current_scn FROM v$database;

--
SELECT time_dp, scn_bas FROM sys.smon_scn_time ORDER BY scn_bas DESC;
