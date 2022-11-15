--
SELECT   job
       , COUNT (*) OVER (PARTITION BY job) AS c1
    FROM emp
   WHERE deptno = 30
ORDER BY 1;

--
SELECT   empno, sal, comm
       , MIN (comm) OVER (ORDER BY sal, empno ROWS UNBOUNDED PRECEDING) AS c1
    FROM emp
   WHERE deptno = 30
ORDER BY 2, 1;

--
SELECT   empno, sal, comm
       , MAX (comm) OVER (ORDER BY sal) AS c1
    FROM emp
   WHERE deptno = 30
ORDER BY 2, 1;

--
SELECT   empno, sal
       , SUM (sal) OVER () AS c1
       , SUM (sal) OVER (ORDER BY sal, empno) AS c2
       , EXP (SUM (LN (sal)) OVER (ORDER BY sal, empno)) AS c3
    FROM emp
   WHERE deptno = 30
ORDER BY 2, 1;

--
SELECT   empno, ename, sal
       , AVG (sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS c1
       , COUNT (*) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS c2
    FROM emp
   WHERE deptno = 30
ORDER BY 3, 1;

--
SELECT   empno, ename, sal
       , AVG (sal) OVER (ORDER BY sal RANGE BETWEEN 300 PRECEDING AND 300 FOLLOWING) AS c1
       , COUNT (*) OVER (ORDER BY sal RANGE BETWEEN 300 PRECEDING AND 300 FOLLOWING) AS c2
    FROM emp
   WHERE deptno = 30
ORDER BY 3, 1;

--
DROP TABLE t1 PURGE;

CREATE TABLE t1 AS
SELECT dt, ROWNUM * 100 AS vl
  FROM (SELECT DATE '2050-01-01' + ROWNUM - 1 AS dt FROM XMLTABLE ('1 to 31'))
 WHERE TO_CHAR (dt, 'D') NOT IN ('1', '7');

--
SELECT   dt, vl
       , AVG (vl) OVER (ORDER BY dt ROWS  9 PRECEDING) AS c1
       , AVG (vl) OVER (ORDER BY dt RANGE 9 PRECEDING) AS c2
    FROM t1
ORDER BY 1;

--
SELECT   job, sal
       , STDDEV (sal) OVER (PARTITION BY job) AS c1
    FROM emp
   WHERE deptno = 30
ORDER BY 2, 1;

--
SELECT   job, sal
       , VARIANCE (sal) OVER (PARTITION BY job) AS c1
    FROM emp
   WHERE deptno = 30
ORDER BY 2, 1;

--
SELECT   empno, ename, sal
       , RANK () OVER (ORDER BY sal) AS c1
    FROM emp
   WHERE deptno = 30
ORDER BY 3, 1;

--
SELECT   empno, ename, sal
       , DENSE_RANK () OVER (ORDER BY sal) AS c1
    FROM emp
   WHERE deptno = 30
ORDER BY 3, 1;

--
SELECT   empno, ename, sal
       , ROW_NUMBER () OVER (ORDER BY sal) AS c1
       , ROW_NUMBER () OVER (ORDER BY sal, empno) AS c2
    FROM emp
   WHERE deptno = 30
ORDER BY 3, 1;

--
SELECT empno, ename, sal, deptno
  FROM (SELECT a.*
             , ROW_NUMBER () OVER (PARTITION BY deptno ORDER BY hiredate DESC, empno DESC) AS rn
          FROM emp a)
 WHERE rn = 1;

--
SELECT   empno, ename, sal
       , ROW_NUMBER () OVER (ORDER BY sal) AS c1
       , RANK ()       OVER (ORDER BY sal) AS c2
       , DENSE_RANK () OVER (ORDER BY sal) AS c3
    FROM emp
   WHERE deptno = 30
ORDER BY 2, 1;

--
SELECT   sal
       , NTILE (1) OVER (ORDER BY sal) AS c1, NTILE (2) OVER (ORDER BY sal) AS c2
       , NTILE (3) OVER (ORDER BY sal) AS c3, NTILE (4) OVER (ORDER BY sal) AS c4
       , NTILE (5) OVER (ORDER BY sal) AS c5, NTILE (6) OVER (ORDER BY sal) AS c6
       , NTILE (7) OVER (ORDER BY sal) AS c7
    FROM emp
   WHERE deptno = 30
ORDER BY 1;

--
SELECT   c1, COUNT (*) AS c2, SUM (sal) AS c3
    FROM (SELECT sal, NTILE (4) OVER (ORDER BY sal) AS c1 FROM emp WHERE deptno = 30)
GROUP BY c1
ORDER BY c1;

--
SELECT   c1, COUNT (*) AS c2, SUM (sal) AS c3
    FROM (SELECT sal
               , CEIL (ROW_NUMBER () OVER (ORDER BY sal, empno) / (COUNT (*) OVER () / 4)) AS c1
            FROM emp
           WHERE deptno = 30)
GROUP BY c1
ORDER BY 1;

--
SELECT   c1, COUNT (*) AS c2, SUM (sal) AS c3
    FROM (SELECT sal
               , MOD (ROW_NUMBER () OVER (ORDER BY sal, empno), 4) AS c1
            FROM emp
           WHERE deptno = 30)
GROUP BY c1;

--
SELECT   sal
       , CUME_DIST () OVER (ORDER BY sal) AS c1
       , COUNT (*) OVER (ORDER BY sal) / COUNT (*) OVER () AS c2
    FROM emp
   WHERE deptno = 30
ORDER BY 1;

--
SELECT   sal
       , PERCENT_RANK () OVER (ORDER BY sal) AS c1
       , (RANK () OVER (ORDER BY sal) - 1) / (COUNT (*) OVER () - 1) AS c2
    FROM emp
   WHERE deptno = 30
ORDER BY 1;

--
WITH w1 AS (SELECT LEVEL AS lv FROM DUAL CONNECT BY LEVEL <= 201)
SELECT *
  FROM (SELECT lv, PERCENT_RANK () OVER (ORDER BY lv) AS c1 FROM w1)
 WHERE lv IN (1, 51, 101, 151, 201);

--
SELECT   sal
       , RATIO_TO_REPORT (sal) OVER () AS c1
       , sal / SUM (sal) OVER () AS c2
    FROM emp
   WHERE deptno = 30
ORDER BY sal;

--
SELECT   job, ename, sal
       , PERCENTILE_CONT (0.5) WITHIN GROUP (ORDER BY sal) OVER (PARTITION BY job) AS c1
    FROM emp
   WHERE deptno = 30
ORDER BY 1, 3, empno;

--
SELECT   job, ename, sal
       , PERCENTILE_DISC (0.5) WITHIN GROUP (ORDER BY sal) OVER (PARTITION BY job) AS c1
    FROM emp
   WHERE deptno = 30
ORDER BY 1, 3, empno;

--
SELECT   job, sal
       , MEDIAN (sal) OVER (PARTITION BY job) AS c1
    FROM emp
   WHERE deptno = 30
ORDER BY 1, 2;

--
SELECT   job, hiredate, sal
       , FIRST_VALUE (sal) OVER (PARTITION BY job ORDER BY hiredate) AS c1
    FROM emp
   WHERE deptno = 30
ORDER BY 1, 2;

--
SELECT   sal, comm
       , FIRST_VALUE (comm) OVER (ORDER BY sal) AS c1
       , FIRST_VALUE (comm) IGNORE NULLS OVER (ORDER BY sal) AS c2
       , FIRST_VALUE (comm) IGNORE NULLS OVER (ORDER BY sal RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS c3
    FROM emp
   WHERE deptno = 30
ORDER BY 1, 2;

--
SELECT   job, hiredate, sal
       , LAST_VALUE (sal) OVER (PARTITION BY job ORDER BY hiredate) AS c1
       , LAST_VALUE (sal) OVER (PARTITION BY job ORDER BY hiredate RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS c2
    FROM emp a
   WHERE deptno = 30
ORDER BY 1, 2, 3;

--
SELECT   job, hiredate, sal
       , FIRST_VALUE (sal) OVER (PARTITION BY job ORDER BY hiredate DESC) AS c1
       , LAST_VALUE  (sal) OVER (PARTITION BY job ORDER BY hiredate RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS c2
    FROM emp a
   WHERE deptno = 30
ORDER BY 1, 2 DESC;

--
SELECT   hiredate, sal
       , NTH_VALUE (sal, 1) OVER (ORDER BY hiredate) AS c1
       , NTH_VALUE (sal, 3) OVER (ORDER BY hiredate) AS c2
    FROM emp
   WHERE deptno = 30
ORDER BY 1;

--
SELECT   hiredate, sal
       , NTH_VALUE (sal, 3) FROM LAST OVER (ORDER BY hiredate RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS c1
       , NTH_VALUE (sal, 3) OVER (ORDER BY hiredate DESC) AS c2
    FROM emp
   WHERE deptno = 30
ORDER BY 1;

--
SELECT   hiredate, sal
       , LAG (sal)    OVER (ORDER BY hiredate) AS c1
       , LAG (sal, 3) OVER (ORDER BY hiredate) AS c2
    FROM emp
   WHERE deptno = 30
ORDER BY 1;

--
SELECT   ename, hiredate, comm
       , LAG (comm, 2, 999) IGNORE NULLS OVER (ORDER BY hiredate) AS c1
    FROM emp
   WHERE deptno = 30
ORDER BY 2;

--
SELECT   sal, comm
       , NVL (comm, LAG (comm) IGNORE NULLS OVER (ORDER BY sal, empno)) AS c1
    FROM emp
   WHERE deptno IN (10, 30)
ORDER BY sal, empno;

--
SELECT   hiredate, sal
       , sal / LAG (sal, 1, sal) OVER (ORDER BY hiredate) AS c1
    FROM emp
   WHERE deptno = 30
ORDER BY 1;

--
SELECT   hiredate, sal
       , LEAD (sal)    OVER (ORDER BY hiredate) AS c1
       , LEAD (sal, 3) OVER (ORDER BY hiredate) AS c2
    FROM emp
   WHERE deptno = 30
ORDER BY 1;

--
SELECT   hiredate, sal
       , LAG  (sal) OVER (ORDER BY hiredate DESC) AS c1
       , LEAD (sal) OVER (ORDER BY hiredate     ) AS c2
    FROM emp
   WHERE deptno = 30
ORDER BY 1;

--
SELECT   empno, ename, sal, comm
       , LEAD (comm) OVER (ORDER BY sal) AS c1
    FROM emp
   WHERE deptno = 30
ORDER BY 3, 1;

SELECT   empno, ename, sal, comm
       , LEAD (comm) OVER (ORDER BY sal) AS c1
    FROM emp
   WHERE deptno = 30
ORDER BY 3, 2;

--
SELECT   empno, ename, sal, comm
       , LEAD (comm) OVER (ORDER BY sal, empno) AS c1
    FROM emp
   WHERE deptno = 30
ORDER BY 3, 1;

SELECT   empno, ename, sal, comm
       , LEAD (comm) OVER (ORDER BY sal, empno) AS c1
    FROM emp
   WHERE deptno = 30
ORDER BY 3, 2;

--
SELECT   job, ename
       , LISTAGG (ename, ',') WITHIN GROUP (ORDER BY ename) OVER (PARTITION BY job) AS c1
    FROM emp
   WHERE deptno = 30
ORDER BY 1, 2;
