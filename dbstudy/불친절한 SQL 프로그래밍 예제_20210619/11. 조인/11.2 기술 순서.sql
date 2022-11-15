--
DROP TABLE t1 PURGE;
DROP TABLE t2 PURGE;
DROP TABLE t3 PURGE;

CREATE TABLE t1 (c1 NUMBER);
CREATE TABLE t2 (c1 NUMBER, c2 NUMBER);
CREATE TABLE t3 (c1 NUMBER, c2 NUMBER, c3 NUMBER);

INSERT INTO t1 VALUES (1);
INSERT INTO t2 VALUES (1, 1);
INSERT INTO t2 VALUES (1, 2);
INSERT INTO t3 VALUES (1, 1, 1);
INSERT INTO t3 VALUES (1, 2, 1);
INSERT INTO t3 VALUES (1, 2, 2);
INSERT INTO t3 VALUES (1, 2, 3);
COMMIT;

--
SELECT *
  FROM t1 a, t2 b, t3 c
 WHERE b.c1 = a.c1
   AND c.c1 = b.c1;

--
SELECT *
  FROM t1 a, t3 c, t2 b
 WHERE c.c1 = a.c1
   AND b.c1 = c.c1;

--
SELECT *
  FROM t2 b, t3 c, t1 a
 WHERE c.c1 = b.c1
   AND a.c1 = c.c1;

--
SELECT *
  FROM t1 a, t2 b, t3 c
 WHERE b.c1 = a.c1
   AND c.c1 = b.c1
   AND c.c3 = 2;

--
SELECT *
  FROM t1 a, t3 c, t2 b
 WHERE c.c1 = a.c1
   AND c.c3 = 2
   AND b.c1 = c.c1;

--
SELECT *
  FROM t1 a, t2 b
 WHERE b.c1(+) = a.c1;

SELECT *
  FROM t1 a, t2 b
 WHERE b.c1 = a.c1(+);

--
SELECT a.ename, b.dname
  FROM emp a, dept b
 WHERE a.job = 'CLERK'     -- 일반 (a)
   AND a.sal >= 1000       -- 일반 (a)
   AND b.deptno = a.deptno -- 조인 (b = a)
   AND b.loc = 'DALLAS'    -- 일반 (b)
;

--
SELECT a.ename, b.dname
  FROM emp a, dept b
 WHERE a.deptno = b.deptno
   AND a.job = 'CLERK'
   AND a.sal >= 1000
   AND b.loc = 'DALLAS';

--
SELECT *
  FROM t1 a, t2 b, t3 c
 WHERE b.c1 = a.c1
   AND c.c2 = b.c1;

--
SELECT *
  FROM t1 a, t2 b, t3 c
 WHERE b.c1 = a.c1
   AND c.c2 = a.c1;
