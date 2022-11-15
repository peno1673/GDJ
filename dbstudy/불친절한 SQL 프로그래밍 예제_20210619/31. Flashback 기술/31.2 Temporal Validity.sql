--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, PERIOD FOR vt);

--
SELECT   column_name, data_type, nullable, hidden_column
    FROM user_tab_cols
   WHERE table_name = 'T1'
ORDER BY internal_column_id;

--
DROP TABLE t1 PURGE;

CREATE TABLE t1 (
    c1 NUMBER, c2 DATE NOT NULL, c3 DATE NOT NULL, c4 DATE, c5 DATE, PERIOD FOR vt1 (c2, c3));

--
ALTER TABLE t1 ADD PERIOD FOR vt2 (c4, c5);

--
ALTER TABLE t1 DROP (PERIOD FOR vt2);

--
INSERT INTO t1 (c1, c2, c3) VALUES (1, DATE '2000-01-01', DATE '2010-01-01');
INSERT INTO t1 (c1, c2, c3) VALUES (2, DATE '2010-01-01', DATE '2050-01-01');
INSERT INTO t1 (c1, c2, c3) VALUES (3, DATE '2050-01-01', DATE '9999-12-31');
COMMIT;

--
SELECT c1, c2, c3 FROM t1 AS OF PERIOD FOR vt1 DATE '2010-01-01';

--
SELECT * FROM t1 AS OF PERIOD FOR vt1 DATE '2050-01-01';

--
SELECT * FROM t1 WHERE c2 <= DATE '2050-01-01' AND c3 > DATE '2050-01-01';

--
SELECT c1, c2, c3
  FROM t1 VERSIONS PERIOD FOR vt1 BETWEEN DATE '2010-01-01' AND DATE '2050-01-01';

--
SELECT * FROM t1 WHERE c2 <= DATE '2050-01-01' AND c3 > DATE '2010-01-01';

--
SELECT * FROM t1 VERSIONS PERIOD FOR vt BETWEEN DATE '2050-01-01' AND MAXVALUE;

--
SELECT * FROM t1 WHERE c3 > DATE '2050-01-01';

--
EXEC DBMS_FLASHBACK_ARCHIVE.ENABLE_AT_VALID_TIME ('CURRENT')

SELECT * FROM t1;

--
EXEC DBMS_FLASHBACK_ARCHIVE.ENABLE_AT_VALID_TIME ('ASOF', DATE '2050-01-01')

SELECT * FROM t1;

--
EXEC DBMS_FLASHBACK_ARCHIVE.ENABLE_AT_VALID_TIME ('ALL')

SELECT * FROM t1;
