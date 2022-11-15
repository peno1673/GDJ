--
SELECT name, isdefault, value
  FROM v$ses_optimizer_env
 WHERE sid = SYS_CONTEXT ('USERENV', 'SID')
   AND name IN ('approx_for_aggregation', 'approx_for_count_distinct', 'approx_for_percentile');

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 AS SELECT ROWNUM AS c1 FROM XMLTABLE ('1 to 10000000');

--
SELECT COUNT (DISTINCT c1) AS c1 FROM t1;

--
SELECT PERCENTILE_CONT (0.5) WITHIN GROUP (ORDER BY c1) AS c1 FROM t1;

--
ALTER SESSION SET APPROX_FOR_AGGREGATION = TRUE;

--
SELECT name, isdefault, value
  FROM v$ses_optimizer_env
 WHERE sid = SYS_CONTEXT ('USERENV', 'SID')
   AND name IN ('approx_for_aggregation', 'approx_for_count_distinct', 'approx_for_percentile');

--
SELECT COUNT (DISTINCT c1) AS c1 FROM t1;

--
SELECT PERCENTILE_CONT (0.5) WITHIN GROUP (ORDER BY c1) AS c1 FROM t1;
