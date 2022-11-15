--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER);

--
ALTER TABLE t1 ADD (c2 NUMBER(2), c3 VARCHAR2(2));

--
SELECT column_name, data_type, data_length, data_precision, data_scale
  FROM user_tab_columns
 WHERE table_name = 'T1';

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER(2), c2 NUMBER(2), c3 VARCHAR2(2), c4 DATE);

INSERT INTO t1 VALUES (1, 1, 'A', DATE '2050-01-01');
COMMIT;

--
ALTER TABLE t1 MODIFY (c1 DEFAULT 1);

--
ALTER TABLE t1 MODIFY (c2 NUMBER(1));

--
ALTER TABLE t1 MODIFY (c3 VARCHAR2(1));

--
ALTER TABLE t1 MODIFY (c2 NUMBER(3), c3 VARCHAR2(3));

--
ALTER TABLE t1 MODIFY (c4 TIMESTAMP);

--
SELECT column_name, data_type, data_length, data_precision, data_scale, data_default
  FROM user_tab_columns
 WHERE table_name = 'T1';

--
ALTER TABLE t1 RENAME COLUMN c4 TO c5;

--
SELECT * FROM t1;

--
ALTER TABLE t1 DROP (c3, c5);

--
SELECT * FROM t1;

--
ALTER TABLE t1 SET UNUSED (c2);

--
SELECT * FROM t1;

--
SELECT * FROM user_unused_col_tabs;

--
SELECT column_name, hidden_column FROM user_tab_cols WHERE table_name = 'T1';

--
ALTER TABLE t1 DROP UNUSED COLUMNS;

--
SELECT * FROM user_unused_col_tabs;

--
SELECT parameter, value
  FROM v$nls_parameters
 WHERE parameter IN ('NLS_CHARACTERSET', 'NLS_LENGTH_SEMANTICS');

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 VARCHAR2(1), c2 VARCHAR2(1 CHAR), c3 VARCHAR2(1 BYTE));

--
SELECT column_name, data_type, data_length FROM user_tab_columns WHERE table_name = 'T1';

--
INSERT INTO t1 (c1) VALUES ('°¡');

--
INSERT INTO t1 (c2) VALUES ('°¡');

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 NUMBER(3, 2));

--
SELECT column_name, data_type, data_length, data_precision, data_scale
  FROM user_tab_columns
 WHERE table_name = 'T1';

--
INSERT INTO t1 (c2) VALUES (9.995);

--
INSERT INTO t1 VALUES (4 / 3, 4 / 3);
COMMIT;

--
SELECT * FROM t1;

--
SELECT VSIZE (c1) AS c1, VSIZE (c2) AS c2 FROM t1;

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 DATE);

--
SELECT column_name, data_type, data_length FROM user_tab_columns WHERE table_name = 'T1';

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 TIMESTAMP);

--
SELECT column_name, data_type, data_length, data_scale
  FROM user_tab_columns
 WHERE table_name = 'T1';

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 INTERVAL YEAR TO MONTH, c2 INTERVAL DAY TO SECOND);

INSERT INTO t1 (c1, c2) VALUES (INTERVAL '1-11' YEAR TO MONTH, INTERVAL '1 12:34:56.789' DAY TO SECOND);
COMMIT;

--
SELECT column_name, data_type, data_length, data_precision, data_scale
  FROM user_tab_columns
 WHERE table_name = 'T1';

--
SELECT c1, c2
     , TIMESTAMP '2050-01-01 00:00:00' + c1 AS c3
     , TIMESTAMP '2050-01-01 00:00:00' + c2 AS c4
  FROM t1;

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 CLOB);

INSERT INTO t1 VALUES (TO_CLOB (LPAD ('A', 4000, 'A')) || LPAD ('B', 4000, 'B'));
COMMIT;

--
SELECT column_name, segment_name, index_name FROM user_lobs WHERE table_name = 'T1';

--
SELECT segment_name, segment_type
  FROM user_segments
 WHERE segment_name IN ('SYS_LOB0000108967C00001$$', 'SYS_IL0000108967C00001$$');

--
SELECT index_type FROM user_indexes WHERE index_name = 'SYS_IL0000108967C00001$$';

--
DROP TABLE t2 PURGE;

CREATE TABLE t2 (c1 CLOB, c2 CLOB)
LOB (c1) STORE AS (ENABLE  STORAGE IN ROW)
LOB (c2) STORE AS (DISABLE STORAGE IN ROW);

--
SELECT column_name, in_row FROM user_lobs WHERE table_name = 'T2';

--
SELECT * FROM t1 WHERE c1 = 'A';

--
SELECT * FROM t1 WHERE c1 LIKE 'A%';

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 CLOB);

INSERT INTO t1 VALUES (1, NULL);
INSERT INTO t1 VALUES (2, EMPTY_CLOB ());
INSERT INTO t1 VALUES (3, 'X');
COMMIT;

--
SELECT * FROM t1;

--
SELECT * FROM t1 WHERE c2 IS NULL;

--
SELECT * FROM t1 WHERE c2 IS NOT NULL;

--
SELECT * FROM t1 WHERE LENGTH (c2) = 0;

--
SELECT * FROM t1 WHERE NULLIF (LENGTH (c2), 0) IS NULL;

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 CHAR(2), c2 CHAR(3));

INSERT INTO t1 VALUES ('A', 'A');
INSERT INTO t1 VALUES ('B', 'B ');
COMMIT;

--
SELECT c1, c2, c2 || 'Z' AS c3 FROM t1 WHERE c1 = c2;

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 CHAR(2), c2 VARCHAR2(2));

INSERT INTO t1 VALUES ('A', 'A');
INSERT INTO t1 VALUES ('B', 'B ');
COMMIT;

--
SELECT c1, c2 FROM t1 WHERE c1 = c2;

--
SELECT c1, c2 FROM t1 WHERE TRIM (c1) = c2;

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 LONG);

INSERT INTO t1 VALUES ('A');
COMMIT;

--
SELECT * FROM t1 WHERE c1 = 'A';

--
DROP TABLE t2 PURGE;
CREATE TABLE t2 AS SELECT TO_LOB (c1) AS c1 FROM t1;

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 NUMBER DEFAULT 2, c3 NUMBER DEFAULT ON NULL 3);

INSERT INTO t1 (c1) VALUES (1);
INSERT INTO t1 VALUES (2, DEFAULT, DEFAULT);
INSERT INTO t1 VALUES (3, NULL, NULL);
COMMIT;

--
SELECT * FROM t1 ORDER BY c1;

--
SELECT column_name, data_default, default_on_null FROM user_tab_columns WHERE table_name = 'T1';

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 NUMBER, c3 NUMBER);

INSERT INTO t1 (c1) VALUES (1);
COMMIT;

--
ALTER TABLE t1 MODIFY c2 DEFAULT 1 NOT NULL;

--
ALTER TABLE t1 MODIFY c3 DEFAULT 1;
ALTER TABLE t1 ADD (c4 NUMBER DEFAULT 1 NOT NULL);
ALTER TABLE t1 ADD (c5 NUMBER DEFAULT 1 NULL);

INSERT INTO t1 (c1) VALUES (2);
COMMIT;

--
SELECT * FROM t1;

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 NUMBER, c3 NUMBER GENERATED ALWAYS AS (c1 + c2) VIRTUAL);

INSERT INTO t1 (c1, c2) VALUES (1, 2);
COMMIT;

--
SELECT * FROM t1;

--
INSERT INTO t1 (c3) VALUES (3);

--
SELECT   column_name, data_type, column_id, data_default, virtual_column, segment_column_id
    FROM user_tab_cols
   WHERE table_name = 'T1'
ORDER BY internal_column_id;

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER INVISIBLE, c2 NUMBER);

--
INSERT INTO t1 VALUES (1);
INSERT INTO t1 (c1, c2) VALUES (2, 2);
COMMIT;

--
SELECT * FROM t1;

SELECT c1, c2 FROM t1;

--
SELECT   column_name, column_id, segment_column_id, internal_column_id, hidden_column
    FROM user_tab_cols
   WHERE table_name = 'T1'
ORDER BY internal_column_id;

--
ALTER TABLE t1 MODIFY c1 VISIBLE;

--
SELECT   column_name, column_id, segment_column_id, internal_column_id, hidden_column
    FROM user_tab_cols
   WHERE table_name = 'T1'
ORDER BY internal_column_id;

--
SELECT * FROM t1;

--
ALTER TABLE t1 MODIFY c2 INVISIBLE;
ALTER TABLE t1 MODIFY c2 VISIBLE;

--
SELECT   column_name, column_id, internal_column_id
    FROM user_tab_cols
   WHERE table_name = 'T1'
ORDER BY internal_column_id;

--
CREATE OR REPLACE PROCEDURE prc_chg_col (
    i_owner       IN VARCHAR2
  , i_table_name  IN VARCHAR2
  , i_column_name IN VARCHAR2
  , i_column_id   IN NUMBER
)
IS
    v_sql_text VARCHAR2 (4000) :=
        'ALTER TABLE ' || i_owner || '.' || i_table_name || ' MODIFY ';
BEGIN
    EXECUTE IMMEDIATE v_sql_text || i_column_name || ' INVISIBLE';
    EXECUTE IMMEDIATE v_sql_text || i_column_name || ' VISIBLE';

    FOR c1 IN (SELECT   column_name
                   FROM all_tab_columns
                  WHERE owner = i_owner
                    AND table_name = i_table_name
                    AND column_name != i_column_name
                    AND column_id >= i_column_id
               ORDER BY column_id)
    LOOP
        EXECUTE IMMEDIATE v_sql_text || c1.column_name || ' INVISIBLE';
        EXECUTE IMMEDIATE v_sql_text || c1.column_name || ' VISIBLE';
    END LOOP;
END;
/

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c3 NUMBER, c2 NUMBER, c1 NUMBER);

INSERT INTO t1 VALUES (3, 2, 1);
COMMIT;

--
EXEC prc_chg_col ('SCOTT', 'T1', 'C1', 1)

EXEC prc_chg_col ('SCOTT', 'T1', 'C2', 2)
