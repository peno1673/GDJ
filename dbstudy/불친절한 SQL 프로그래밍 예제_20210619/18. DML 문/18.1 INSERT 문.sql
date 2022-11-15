--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (empno NUMBER(4), ename VARCHAR2(10), deptno NUMBER(2) DEFAULT 20);

--
INSERT INTO t1 (empno, ename, deptno) VALUES (7369, 'SMITH', 20);

--
SELECT * FROM t1;

--
INSERT INTO t1 (empno) VALUES (7566);

--
SELECT * FROM t1;

--
INSERT INTO t1 VALUES (7788, 'SCOTT', 20);

--
INSERT INTO t1 VALUES (7876, 'ADAMS', DEFAULT);

--
SELECT * FROM t1;

--
INSERT INTO t1 VALUES (7902, 'FORD');

INSERT INTO t1 VALUES (7902, 'FORD', 20, ANALYST);

--
ALTER TABLE t1 ADD job VARCHAR2(9);

--
INSERT INTO t1 VALUES (7902, 'FORD', 20);

--
INSERT INTO t1 (empno, ename, deptno) VALUES (7902, 'FORD', 20);

--
INSERT INTO t1 (empno, ename) SELECT empno, ename FROM emp WHERE job = 'ANALYST';

--
INSERT INTO t1 (empno, ename)
SELECT empno , ename FROM emp  WHERE job = 'PRESIDENT'
UNION ALL
SELECT deptno, dname FROM dept WHERE deptno = 10;

--
DROP TABLE t1 PURGE;
DROP TABLE t2 PURGE;

CREATE TABLE t1 (empno NUMBER(4), job VARCHAR2(9));
CREATE TABLE t2 (empno NUMBER(4), mgr NUMBER(4));

--
INSERT ALL
  INTO t1 (empno, job) VALUES (empno, job)
  INTO t2 (empno, mgr) VALUES (empno, mgr)
SELECT * FROM emp WHERE deptno = 10;

--
SELECT * FROM t1;

SELECT * FROM t2;

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (deptno NUMBER(2), tp VARCHAR2(3), sal NUMBER(7,2));

--
INSERT ALL
  INTO t1 VALUES (deptno, 'MIN', sal_min)
  INTO t1 VALUES (deptno, 'MAX', sal_max)
  INTO t1 VALUES (deptno, 'SUM', sal_sum)
  INTO t1 VALUES (deptno, 'AVG', sal_avg)
SELECT   deptno
       , MIN (sal) AS sal_min, MAX (sal) AS sal_max
       , SUM (sal) AS sal_sum, AVG (sal) AS sal_avg
    FROM emp
GROUP BY deptno;

--
SELECT * FROM t1 ORDER BY 1, 2;

--
INSERT
  INTO t1 (deptno, tp, sal)
SELECT  *
   FROM (SELECT   deptno
                , MIN (sal) AS sal_min, MAX (sal) AS sal_max
                , SUM (sal) AS sal_sum, AVG (sal) AS sal_avg
             FROM emp
         GROUP BY deptno)
UNPIVOT (sal FOR tp IN (sal_min AS 'MIN', sal_max AS 'MAX'
                      , sal_sum AS 'SUM', sal_avg AS 'AVG'));

--
DROP TABLE t1 PURGE;
DROP TABLE t2 PURGE;
DROP TABLE t3 PURGE;

CREATE TABLE t1 AS SELECT empno, ename, sal FROM emp WHERE 0 = 1;
CREATE TABLE t2 AS SELECT * FROM t1;
CREATE TABLE t3 AS SELECT * FROM t1;

--
INSERT ALL
  WHEN sal >= 2000 THEN INTO t1
  WHEN sal >= 3000 THEN INTO t2
  ELSE INTO t3
SELECT empno, ename, sal FROM emp WHERE deptno = 10;

--
SELECT * FROM t1;

SELECT * FROM t2;

SELECT * FROM t3;

--
ROLLBACK;

--
INSERT FIRST
  WHEN sal >= 2000 THEN INTO t1
  WHEN sal >= 3000 THEN INTO t2
  ELSE INTO t3
SELECT empno, ename, sal FROM emp WHERE deptno = 10;

--
SELECT * FROM t1;

SELECT * FROM t2;

SELECT * FROM t3;
