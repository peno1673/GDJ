--
SELECT parameter, value
  FROM nls_database_parameters
 WHERE parameter IN ('NLS_CHARACTERSET', 'NLS_NCHAR_CHARACTERSET');

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 VARCHAR2(10), c3 NVARCHAR2(10));

--
INSERT INTO t1 VALUES (1, '国',  '国');
INSERT INTO t1 VALUES (2, '国', N'国');
COMMIT;

--
SELECT * FROM t1;
