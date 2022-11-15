--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 NUMBER, CONSTRAINT t1_pk PRIMARY KEY (c1));

INSERT INTO t1 VALUES (1, 1);
INSERT INTO t1 VALUES (2, 2);
COMMIT;

--
CREATE OR REPLACE VIEW v1 AS SELECT * FROM t1 WHERE c2 = 1;

--
SELECT * FROM v1;

--
INSERT INTO v1 VALUES (3, 3);
INSERT INTO v1 VALUES (4, 1);
COMMIT;

--
SELECT * FROM v1;

--
SELECT text_length, text_vc FROM user_views WHERE view_name = 'V1';

--
SELECT column_name, data_type, nullable FROM user_tab_columns WHERE table_name = 'V1';

--
DROP TABLE t2 PURGE;
DROP TABLE t3 PURGE;

CREATE TABLE t2 (c1 NUMBER, CONSTRAINT t2_pk PRIMARY KEY (c1));
CREATE TABLE t3 (c1 NUMBER, c2 NUMBER, CONSTRAINT t3_pk PRIMARY KEY (c1, c2));

INSERT INTO t2 VALUES (1);
INSERT INTO t3 VALUES (1, 1);
INSERT INTO t3 VALUES (1, 2);
COMMIT

--
CREATE OR REPLACE VIEW v2 AS
SELECT a.c1 AS ac1, b.c1 AS bc1, b.c2 AS bc2 FROM t2 a, t3 b WHERE b.c1 = a.c1;

--
SELECT * FROM v2;

--
INSERT INTO v2 VALUES (3, 3, 3);

--
INSERT INTO v2 (bc1, bc2) VALUES (3, 3);

--
SELECT column_name, updatable, insertable, deletable
  FROM user_updatable_columns
 WHERE table_name = 'V2';

--
UPDATE v1 SET c2 = 4 WHERE c1 = 4;

--
SELECT * FROM v1;

--
CREATE OR REPLACE VIEW v1 AS SELECT * FROM t1 WHERE c2 = 1 WITH CHECK OPTION;

--
UPDATE v1 SET c2 = 0 WHERE c1 = 1;

--
INSERT INTO v1 VALUES (5, 5);

--
SELECT constraint_name, constraint_type FROM user_constraints WHERE table_name = 'V1';

--
UPDATE (SELECT * FROM t1 WHERE c2 = 1 WITH CHECK OPTION) SET c2 = 0;

--
INSERT INTO (SELECT * FROM t1 WHERE c2 = 1 WITH CHECK OPTION) VALUES (5, 5);

--
CREATE OR REPLACE VIEW v1 AS SELECT * FROM t1 WHERE c2 = 1 WITH READ ONLY;

--
DELETE FROM v1;

--
SELECT constraint_name, constraint_type FROM user_constraints WHERE table_name = 'V1';

--
SELECT read_only FROM user_views WHERE view_name = 'V1';

--
SELECT name, type, referenced_owner, referenced_name, referenced_type
  FROM user_dependencies
 WHERE name in ('V1', 'V2');

--
ALTER TABLE t1 RENAME COLUMN c2 TO c3;

--
SELECT * FROM v1;

--
SELECT object_type, status FROM user_objects WHERE object_name = 'V1';

--
ALTER TABLE t1 RENAME COLUMN c3 TO c2;

ALTER VIEW v1 COMPILE;

--
SELECT object_type, status FROM user_objects WHERE object_name = 'V1';

--
EXEC DBMS_UTILITY.COMPILE_SCHEMA (schema => 'SCOTT')

--
DROP VIEW v1;

--
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, hiredate FROM emp WHERE job = 'CLERK' WITH CHECK OPTION;

--
CREATE OR REPLACE VIEW v_dept AS
SELECT a.deptno AS dept_no, a.dname AS dept_nm, b.sal
  FROM dept a
     , (SELECT deptno, SUM (sal) AS sal FROM emp GROUP BY deptno) b
 WHERE b.deptno = a.deptno
  WITH READ ONLY;

--
SELECT * FROM v_dept;

--
CREATE OR REPLACE VIEW v_dept AS
SELECT a.deptno AS dept_no, a.loc AS dept_nm, b.sal
  FROM dept a
     , (SELECT deptno, SUM (sal) AS sal FROM emp GROUP BY deptno) b
 WHERE b.deptno(+) = a.deptno
  WITH READ ONLY;

--
SELECT * FROM v_dept;
