--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 NUMBER, c3 NUMBER);

--
CREATE UNIQUE INDEX t1_u1 ON t1 (c1);

CREATE INDEX t1_x1 ON t1 (c2, c3);

--
SELECT index_name, index_type, uniqueness FROM user_indexes WHERE table_name = 'T1';

--
SELECT   index_name, column_name, column_position, descend
    FROM user_ind_columns
   WHERE table_name = 'T1'
ORDER BY index_name, column_position;

--
ALTER INDEX t1_x1 UNUSABLE;

--
SELECT index_name, status FROM user_indexes WHERE table_name = 'T1';

--
INSERT INTO t1 VALUES (1, 1, 1);

--
ALTER INDEX t1_u1 UNUSABLE;

--
INSERT INTO t1 VALUES (2, 2, 2);

--
ALTER INDEX t1_u1 REBUILD;

ALTER INDEX t1_x1 REBUILD;

--
SELECT index_name, status FROM user_indexes WHERE table_name = 'T1';

--
ALTER INDEX t1_x1 RENAME TO t1_x2;

--
SELECT index_name FROM user_indexes WHERE table_name = 'T1';

--
DROP INDEX t1_x2;

--
SELECT index_name FROM user_indexes WHERE table_name = 'T1';

--
DROP TABLE t1 PURGE;
DROP TABLE t2 PURGE;

CREATE TABLE t1 (c1 NUMBER, c2 NUMBER, CONSTRAINT t1_pk PRIMARY KEY (c1));
CREATE TABLE t2 (c1 NUMBER, c2 NUMBER, CONSTRAINT t2_pk PRIMARY KEY (c1));

CREATE BITMAP INDEX t1_x1 ON t1 (c2);
CREATE BITMAP INDEX t1_x2 ON t1 (t2.c2) FROM t1, t2 WHERE t2.c1 = t1.c1;

--
SELECT index_name, index_type, uniqueness, join_index FROM user_indexes WHERE table_name = 'T1';

--
SELECT index_name, inner_table_name, inner_table_column, outer_table_name, outer_table_column
  FROM user_join_ind_columns;

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 NUMBER, CONSTRAINT t1_pk PRIMARY KEY (c1)) ORGANIZATION INDEX;

CREATE BITMAP INDEX t1_x1 ON t1 (c2);

--
DROP TABLE t1 PURGE;

CREATE TABLE t1 (c1 NUMBER, c2 NUMBER, CONSTRAINT t1_pk PRIMARY KEY (c1)) ORGANIZATION INDEX MAPPING TABLE;

CREATE BITMAP INDEX t1_x1 ON t1 (c2);

--
SELECT b.object_name, b.object_id, b.object_type
  FROM user_objects a, user_objects b
 WHERE a.object_name = 'T1'
   AND b.object_name = 'SYS_IOT_MAP_' || a.object_id;

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 NUMBER);

CREATE INDEX t1_x1 ON t1 (c1 + c2);
CREATE BITMAP INDEX t1_x2 ON t1 (TRUNC (c1));

--
SELECT index_name, index_type FROM user_indexes WHERE table_name = 'T1';

--
SELECT index_name, table_name, column_expression, column_position
  FROM user_ind_expressions
 WHERE table_name = 'T1';

--
SELECT index_name, column_name FROM user_ind_columns WHERE table_name = 'T1';

--
SELECT column_name, data_default, hidden_column, virtual_column, user_generated
  FROM user_tab_cols
 WHERE table_name = 'T1';

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 NUMBER);

CREATE INDEX t1_x1 ON t1 (c1, c2 DESC);

--
SELECT index_name, index_type FROM user_indexes WHERE table_name = 'T1';

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 NUMBER);

CREATE INDEX t1_x1 ON t1 (c1) REVERSE;
CREATE INDEX t1_x2 ON t1 (c1 + c2) REVERSE;

--
SELECT index_name, index_type FROM user_indexes WHERE table_name = 'T1';

--
DROP TABLE t1 PURGE;

CREATE TABLE t1 (
    c1 NUMBER PRIMARY KEY
  , c2 NUMBER CONSTRAINT t1_u1 UNIQUE
  , c3 NUMBER UNIQUE DEFERRABLE
  , c4 NUMBER CONSTRAINT t1_u2 UNIQUE DEFERRABLE
);

--
SELECT index_name, uniqueness FROM user_indexes WHERE table_name = 'T1';

--
ALTER TABLE t1 MODIFY CONSTRAINT SYS_C0000001 DISABLE;
ALTER TABLE t1 MODIFY CONSTRAINT t1_u1        DISABLE KEEP INDEX;
ALTER TABLE t1 MODIFY CONSTRAINT SYS_C0000002 DISABLE;
ALTER TABLE t1 MODIFY CONSTRAINT t1_u2        DISABLE DROP INDEX;

--
SELECT index_name, uniqueness FROM user_indexes WHERE table_name = 'T1';

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER NOT NULL, c2 NUMBER NOT NULL, c3 NUMBER, c4 NUMBER);

CREATE UNIQUE INDEX t1_pk ON t1 (c1, c2);
CREATE INDEX t1_x1 ON t1 (c3, c4);

--
ALTER TABLE t1 ADD CONSTRAINT t1_pk PRIMARY KEY (c1, c2) USING INDEX t1_pk;

--
ALTER TABLE t1 ADD CONSTRAINT t1_u1 UNIQUE (c3, c4) USING INDEX t1_u1;

--
SELECT index_name FROM user_constraints WHERE constraint_name = 'T1_PK';

--
ALTER TABLE t1 MODIFY CONSTRAINT t1_pk DISABLE;

--
SELECT index_name FROM user_indexes WHERE table_name = 'T1';

--
ALTER TABLE t1 ADD CONSTRAINT t1_u1 UNIQUE (c4, c3);

--
SELECT index_name FROM user_constraints WHERE constraint_name = 'T1_U1';

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER NOT NULL, c2 NUMBER, c3 NUMBER);

CREATE INDEX t1_x1 ON t1 (c1, c2);
CREATE UNIQUE INDEX t1_pk ON t1 (c1);

ALTER TABLE t1 ADD CONSTRAINT t1_pk PRIMARY KEY (c1);

--
SELECT index_name FROM user_constraints WHERE constraint_name = 'T1_PK';

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER NOT NULL, c2 NUMBER);

CREATE UNIQUE INDEX t1_pk ON t1 (c1);

ALTER TABLE t1 ADD CONSTRAINT t1_pk PRIMARY KEY (c1);
ALTER TABLE t1 ADD CONSTRAINT t1_u1 UNIQUE (c2);

--
SELECT name, spare1 FROM sys.obj$ WHERE name LIKE 'T1_%';

--
DROP TABLE t1 PURGE;
DROP TABLE t2 PURGE;
DROP TABLE t3 PURGE;

CREATE TABLE t1 (c1 NUMBER);
CREATE TABLE t2 (c1 NUMBER);
CREATE UNIQUE INDEX t1_pk ON t1 (c1);
CREATE UNIQUE INDEX t2_pk ON t2 (c1);
ALTER TABLE t1 ADD CONSTRAINT t1_pk PRIMARY KEY (c1) USING INDEX t1_pk;
ALTER TABLE t2 ADD CONSTRAINT t2_pk PRIMARY KEY (c1) USING INDEX t2_pk;

--
ALTER TABLE t1 RENAME CONSTRAINT t1_pk TO t3_pk;
ALTER TABLE t1 RENAME TO t3;
ALTER INDEX t1_pk RENAME TO t3_pk;

ALTER TABLE t2 RENAME CONSTRAINT t2_pk TO t1_pk;
ALTER TABLE t2 RENAME TO t1;
ALTER INDEX t2_pk RENAME TO t1_pk;
