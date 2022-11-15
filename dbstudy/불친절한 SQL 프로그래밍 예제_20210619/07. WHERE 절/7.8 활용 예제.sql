--
SELECT *
  FROM emp
 WHERE sal * 12 >= 36000;

SELECT *
  FROM emp
 WHERE sal >= 36000 / 12;

--
SELECT *
  FROM emp
 WHERE deptno || job = '10CLERK';

SELECT *
  FROM emp
 WHERE deptno = 10
   AND job = 'CLERK';

--
SELECT *
  FROM emp
 WHERE SUBSTR (ename, 1, 1) = 'A';

SELECT *
  FROM emp
 WHERE ename LIKE 'A%';

--
SELECT *
  FROM emp
 WHERE INSTR (ename, 'ON') > 0;

SELECT *
  FROM emp
 WHERE ename LIKE '%ON%';

--
SELECT *
  FROM emp
 WHERE TO_CHAR (hiredate, 'YYYYMMDD') = '19870419';

SELECT *
  FROM emp
 WHERE hiredate = DATE '1987-04-19';

--
SELECT hiredate
  FROM emp
 WHERE hiredate >= DATE '1987-04-19'
   AND hiredate <  DATE '1987-04-19' + 1;

--
SELECT hiredate
  FROM emp
 WHERE hiredate >= DATE '1980-01-01'
   AND hiredate <  DATE '1980-12-31' + 1;

--
SELECT empno, ename, mgr, deptno
  FROM emp
 WHERE CASE deptno WHEN 10 THEN empno ELSE mgr END = 7839;

--
SELECT empno, ename, mgr, deptno
  FROM emp
 WHERE (   (deptno =  10 AND empno = 7839)
        OR (deptno != 10 AND mgr   = 7839));

--
SELECT empno, ename, mgr, deptno
  FROM emp
 WHERE (   (deptno = 10         AND empno = 7839)
        OR (LNNVL (deptno = 10) AND mgr   = 7839));

--
SELECT ename, deptno, sal
  FROM emp
 WHERE sal >= CASE deptno WHEN 20 THEN 3000 WHEN 30 THEN 2000 ELSE 0 END;

--
SELECT ename, deptno, sal
  FROM emp
 WHERE (   (deptno = 20 AND sal >= 3000)
        OR (deptno = 30 AND sal >= 2000)
        OR (deptno NOT IN (20, 30) AND sal >= 0));

--
SELECT ename, deptno, sal
  FROM emp
 WHERE (   (deptno = 20 AND sal >= 3000)
        OR (deptno = 30 AND sal >= 2000)
        OR ((deptno NOT IN (20, 30) OR deptno IS NULL) AND sal > 0));

--
VAR b1 NUMBER = 10

SELECT ename, deptno
  FROM emp
 WHERE deptno = :b1;

EXEC :b1 := 20

SELECT ename, deptno
  FROM emp
 WHERE deptno = :b1;

--
VAR b1 NUMBER

SELECT ename, deptno
  FROM emp
 WHERE deptno = NVL (:b1, deptno);

EXEC :b1 := 30

SELECT ename, deptno
  FROM emp
 WHERE deptno = NVL (:b1, deptno);

--
SELECT ename, deptno FROM emp WHERE deptno LIKE :b1 || '%';

--
SELECT ename, deptno FROM emp WHERE deptno = DECODE (:b1, 99, deptno, :b1);

--
VAR b1 NUMBER

SELECT ename, sal
  FROM emp
 WHERE (    :b1 IS NULL
        OR (:b1 = 1 AND sal >= 2000)
        OR (:b1 = 2 AND sal >= 3000));

EXEC :b1 := 2

SELECT ename, sal
  FROM emp
 WHERE (    :b1 IS NULL
        OR (:b1 = 1 AND sal >= 2000)
        OR (:b1 = 2 AND sal >= 3000));

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 DATE);

INSERT INTO t1 VALUES (TO_DATE ('2050-01-01 00:00:01', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO t1 VALUES (TO_DATE ('2050-01-02 00:00:01', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO t1 VALUES (TO_DATE ('2050-02-28 00:00:01', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO t1 VALUES (TO_DATE ('2051-12-31 00:00:01', 'YYYY-MM-DD HH24:MI:SS'));
COMMIT;

--
VAR b1 VARCHAR2(4) = '2050'
VAR b2 VARCHAR2(4) = '2051'

SELECT *
  FROM t1
 WHERE c1 >= TO_DATE (:b1 || '01', 'YYYYMM')
   AND c1 <  TO_DATE (:b2 || '1231', 'YYYYMMDD') + 1;

--
VAR b1 VARCHAR2(6) = '205001'
VAR b2 VARCHAR2(6) = '205002'

SELECT *
  FROM t1
 WHERE c1 >= TO_DATE (:b1, 'YYYYMM')
   AND c1 <  LAST_DAY (TO_DATE (:b2, 'YYYYMM')) + 1;

--
VAR b1 VARCHAR2(8) = '20500101'
VAR b2 VARCHAR2(8) = '20500102'

SELECT *
  FROM t1
 WHERE c1 >= TO_DATE (:b1, 'YYYYMMDD')
   AND c1 <  TO_DATE (:b2, 'YYYYMMDD') + 1;

--
SELECT *
  FROM t1
 WHERE c1 BETWEEN TO_DATE (:b1, 'YYYYMMDD') AND TO_DATE (:b2, 'YYYYMMDD');

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 TIMESTAMP);

INSERT INTO t1 VALUES (TIMESTAMP '2050-01-01 00:00:00.000001');
INSERT INTO t1 VALUES (TIMESTAMP '2050-01-02 00:00:00.000001');
INSERT INTO t1 VALUES (TIMESTAMP '2050-02-28 00:00:00.000001');
INSERT INTO t1 VALUES (TIMESTAMP '2051-12-31 00:00:00.000001');
COMMIT;
