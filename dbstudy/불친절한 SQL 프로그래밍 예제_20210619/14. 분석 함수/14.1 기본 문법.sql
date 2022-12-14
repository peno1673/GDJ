--
SELECT   empno, job, sal
       , SUM (sal) OVER (PARTITION BY job) AS c1
       , SUM (sal) OVER () AS c2
    FROM emp
   WHERE deptno = 30
ORDER BY 2, 1;

--
SELECT   empno, sal, SUM (sal) OVER (ORDER BY sal, empno) AS c1
    FROM emp
   WHERE deptno = 30
ORDER BY 2, 1;

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 NUMBER);

INSERT INTO t1 VALUES (1, 1);
INSERT INTO t1 VALUES (2, 1);
INSERT INTO t1 VALUES (3, 2);
INSERT INTO t1 VALUES (4, 3);
INSERT INTO t1 VALUES (5, 3);
INSERT INTO t1 VALUES (6, 4);
INSERT INTO t1 VALUES (7, 5);
INSERT INTO t1 VALUES (8, 5);
INSERT INTO t1 VALUES (9, 6);
COMMIT;

--
SELECT   c1, c2
       , COUNT (*) OVER (ORDER BY c2 ROWS BETWEEN UNBOUNDED PRECEDING AND         2 PRECEDING) AS r01
       , COUNT (*) OVER (ORDER BY c2 ROWS BETWEEN UNBOUNDED PRECEDING AND         CURRENT ROW) AS r02
       , COUNT (*) OVER (ORDER BY c2 ROWS BETWEEN UNBOUNDED PRECEDING AND         2 FOLLOWING) AS r03
       , COUNT (*) OVER (ORDER BY c2 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS r04
       , COUNT (*) OVER (ORDER BY c2 ROWS BETWEEN         2 PRECEDING AND         1 PRECEDING) AS r05
       , COUNT (*) OVER (ORDER BY c2 ROWS BETWEEN         2 PRECEDING AND         CURRENT ROW) AS r06
       , COUNT (*) OVER (ORDER BY c2 ROWS BETWEEN         2 PRECEDING AND         2 FOLLOWING) AS r07
       , COUNT (*) OVER (ORDER BY c2 ROWS BETWEEN         2 PRECEDING AND UNBOUNDED FOLLOWING) AS r08
       , COUNT (*) OVER (ORDER BY c2 ROWS BETWEEN         CURRENT ROW AND         2 FOLLOWING) AS r09
       , COUNT (*) OVER (ORDER BY c2 ROWS BETWEEN         CURRENT ROW AND UNBOUNDED FOLLOWING) AS r10
       , COUNT (*) OVER (ORDER BY c2 ROWS BETWEEN         1 FOLLOWING AND         2 FOLLOWING) AS r11
       , COUNT (*) OVER (ORDER BY c2 ROWS BETWEEN         1 FOLLOWING AND UNBOUNDED FOLLOWING) AS r12
       , COUNT (*) OVER (ORDER BY c2 ROWS         UNBOUNDED PRECEDING                        ) AS r13
       , COUNT (*) OVER (ORDER BY c2 ROWS                 2 PRECEDING                        ) AS r14
       , COUNT (*) OVER (ORDER BY c2 ROWS                 CURRENT ROW                        ) AS r15
    FROM t1
ORDER BY 1;

--
SELECT   c1, c2
       , COUNT (*) OVER (ORDER BY c2 RANGE BETWEEN UNBOUNDED PRECEDING AND         2 PRECEDING) AS r01
       , COUNT (*) OVER (ORDER BY c2 RANGE BETWEEN UNBOUNDED PRECEDING AND         CURRENT ROW) AS r02
       , COUNT (*) OVER (ORDER BY c2 RANGE BETWEEN UNBOUNDED PRECEDING AND         2 FOLLOWING) AS r03
       , COUNT (*) OVER (ORDER BY c2 RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS r04
       , COUNT (*) OVER (ORDER BY c2 RANGE BETWEEN         2 PRECEDING AND         1 PRECEDING) AS r05
       , COUNT (*) OVER (ORDER BY c2 RANGE BETWEEN         2 PRECEDING AND         CURRENT ROW) AS r06
       , COUNT (*) OVER (ORDER BY c2 RANGE BETWEEN         2 PRECEDING AND         2 FOLLOWING) AS r07
       , COUNT (*) OVER (ORDER BY c2 RANGE BETWEEN         2 PRECEDING AND UNBOUNDED FOLLOWING) AS r08
       , COUNT (*) OVER (ORDER BY c2 RANGE BETWEEN         CURRENT ROW AND         2 FOLLOWING) AS r09
       , COUNT (*) OVER (ORDER BY c2 RANGE BETWEEN         CURRENT ROW AND UNBOUNDED FOLLOWING) AS r10
       , COUNT (*) OVER (ORDER BY c2 RANGE BETWEEN         1 FOLLOWING AND         2 FOLLOWING) AS r11
       , COUNT (*) OVER (ORDER BY c2 RANGE BETWEEN         1 FOLLOWING AND UNBOUNDED FOLLOWING) AS r12
       , COUNT (*) OVER (ORDER BY c2 RANGE         UNBOUNDED PRECEDING                        ) AS r13
       , COUNT (*) OVER (ORDER BY c2 RANGE                 2 PRECEDING                        ) AS r14
       , COUNT (*) OVER (ORDER BY c2 RANGE                 CURRENT ROW                        ) AS r15
    FROM t1
ORDER BY 1;

--
SELECT   c1, c2
       , COUNT (*) OVER (ORDER BY c2 DESC RANGE BETWEEN UNBOUNDED PRECEDING AND         2 PRECEDING) AS r01
       , COUNT (*) OVER (ORDER BY c2 DESC RANGE BETWEEN UNBOUNDED PRECEDING AND         CURRENT ROW) AS r02
       , COUNT (*) OVER (ORDER BY c2 DESC RANGE BETWEEN UNBOUNDED PRECEDING AND         2 FOLLOWING) AS r03
       , COUNT (*) OVER (ORDER BY c2 DESC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS r04
       , COUNT (*) OVER (ORDER BY c2 DESC RANGE BETWEEN         2 PRECEDING AND         1 PRECEDING) AS r05
       , COUNT (*) OVER (ORDER BY c2 DESC RANGE BETWEEN         2 PRECEDING AND         CURRENT ROW) AS r06
       , COUNT (*) OVER (ORDER BY c2 DESC RANGE BETWEEN         2 PRECEDING AND         2 FOLLOWING) AS r07
       , COUNT (*) OVER (ORDER BY c2 DESC RANGE BETWEEN         2 PRECEDING AND UNBOUNDED FOLLOWING) AS r08
       , COUNT (*) OVER (ORDER BY c2 DESC RANGE BETWEEN         CURRENT ROW AND         2 FOLLOWING) AS r09
       , COUNT (*) OVER (ORDER BY c2 DESC RANGE BETWEEN         CURRENT ROW AND UNBOUNDED FOLLOWING) AS r10
       , COUNT (*) OVER (ORDER BY c2 DESC RANGE BETWEEN         1 FOLLOWING AND         2 FOLLOWING) AS r11
       , COUNT (*) OVER (ORDER BY c2 DESC RANGE BETWEEN         1 FOLLOWING AND UNBOUNDED FOLLOWING) AS r12
       , COUNT (*) OVER (ORDER BY c2 DESC RANGE         UNBOUNDED PRECEDING                        ) AS r13
       , COUNT (*) OVER (ORDER BY c2 DESC RANGE                 2 PRECEDING                        ) AS r14
       , COUNT (*) OVER (ORDER BY c2 DESC RANGE                 CURRENT ROW                        ) AS r15
    FROM t1
ORDER BY 1 DESC;

--
SELECT   empno, ename, sal
       , SUM (sal) OVER (ORDER BY sal        ROWS  UNBOUNDED PRECEDING) AS c1
       , SUM (sal) OVER (ORDER BY sal        RANGE UNBOUNDED PRECEDING) AS c2
       , SUM (sal) OVER (ORDER BY sal, empno ROWS  UNBOUNDED PRECEDING) AS c3
       , SUM (sal) OVER (ORDER BY sal, empno RANGE UNBOUNDED PRECEDING) AS c4
    FROM emp
   WHERE deptno = 30
ORDER BY 3, 1;

--
SELECT   job, hiredate, sal
       , SUM (sal) OVER (PARTITION BY job ORDER BY hiredate) AS c1
    FROM emp
   WHERE deptno = 30
ORDER BY 1, 2;

--
SELECT   ename, job, sal, comm
       , MAX (comm) KEEP (DENSE_RANK FIRST ORDER BY sal) OVER (PARTITION BY job) AS c1
    FROM emp
   WHERE deptno = 30
ORDER BY 2, 3, 4;

--
SELECT job, sal, SUM (sal) OVER (ORDER BY job RANGE 1 PRECEDING) AS c1
  FROM emp
 WHERE deptno = 30;

--
SELECT job, sal, SUM (sal) OVER (ORDER BY sal, comm RANGE 1 PRECEDING) AS c1
  FROM emp
 WHERE deptno = 30;

--
SELECT   hiredate, sal
       , SUM (sal) OVER (ORDER BY hiredate RANGE 90 PRECEDING) AS c1
       , SUM (sal) OVER (ORDER BY hiredate RANGE INTERVAL '3' MONTH PRECEDING) AS c2
    FROM emp
   WHERE deptno = 30
ORDER BY 1;

--
SELECT deptno, ename, sal
  FROM emp
 WHERE SUM (sal) OVER (PARTITION BY deptno) >= 10000;

--
SELECT   deptno, ename, sal, c1
    FROM (SELECT a.*, SUM (a.sal) OVER (PARTITION BY a.deptno) AS c1 FROM emp a)
   WHERE c1 >= 10000
ORDER BY 1, 2;

--
SELECT   deptno
       , SUM (sal) AS c1, SUM (SUM (sal)) OVER () AS c2, COUNT (*) OVER () AS c3
    FROM emp
GROUP BY deptno
ORDER BY 1;

--
SELECT   deptno, c1, SUM (c1) OVER () AS c2, COUNT (*) OVER () AS c3
    FROM (SELECT deptno, SUM (sal) AS c1 FROM emp GROUP BY deptno)
ORDER BY 1;

--
SELECT DISTINCT
       deptno, SUM (sal) OVER (PARTITION BY deptno) AS c1
  FROM emp;

--
SELECT deptno, SUM (sal) AS c2 FROM emp GROUP BY deptno;
