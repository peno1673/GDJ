--
SELECT   deptno, COUNT (*) AS c1
    FROM emp
   WHERE sal > 2000
GROUP BY ROLLUP (deptno)
ORDER BY deptno;

--
SELECT   deptno, job, COUNT (*) AS c1
    FROM emp
   WHERE sal > 2000
GROUP BY ROLLUP (deptno, job)
ORDER BY deptno, job;

--
SELECT   deptno, COUNT (*) AS c1
    FROM emp
   WHERE sal > 2000
GROUP BY CUBE (deptno)
ORDER BY deptno;

--
SELECT   deptno, job, COUNT (*) AS c1
    FROM emp
   WHERE sal > 2000
GROUP BY CUBE (deptno, job)
ORDER BY deptno, job;

--
SELECT   deptno, job, COUNT (*) AS c1
    FROM emp
   WHERE sal > 2000
GROUP BY GROUPING SETS (deptno, job)
ORDER BY deptno, job;

--
SELECT   deptno, job, COUNT (*) AS c1
    FROM emp
   WHERE sal > 2000
GROUP BY GROUPING SETS (deptno, ROLLUP (job))
ORDER BY deptno, job;

--
SELECT   deptno, job, COUNT (*) AS c1
    FROM emp
   WHERE sal > 2000
GROUP BY ROLLUP ((deptno, job))
ORDER BY deptno, job;

--
SELECT   deptno, job, COUNT (*) AS c1
    FROM emp
   WHERE sal > 2000
GROUP BY deptno, ROLLUP (job)
ORDER BY deptno, job;

--
SELECT   deptno, job, COUNT (*) AS c1, GROUPING (deptno) AS g1, GROUPING (job) AS g2
    FROM emp
   WHERE sal > 2000
GROUP BY ROLLUP (deptno, job)
ORDER BY deptno, job;

--
SELECT   CASE
             WHEN GROUPING (deptno) = 1 AND GROUPING (job) = 1 THEN 'TOTAL'
             ELSE TO_CHAR (deptno)
         END AS deptno
       , CASE
             WHEN GROUPING (deptno) = 0 AND GROUPING (job) = 1 THEN 'ALL'
             ELSE job
         END AS job
       , COUNT (*) AS c1, GROUPING (deptno) AS g1, GROUPING (job) AS g2
    FROM emp
   WHERE sal > 2000
GROUP BY ROLLUP (deptno, job)
ORDER BY 4, 5, 1, 2;

--
SELECT   DECODE (GROUPING_ID (deptno, job), 3, 'TOTAL', TO_CHAR (deptno)) AS detpno
       , DECODE (GROUPING_ID (deptno, job), 1, 'ALL', job) AS job
       , COUNT (*) AS c1
       , GROUPING (deptno) AS g1, GROUPING (job) AS g2
       , GROUPING_ID (deptno, job) AS gi
       , BIN_TO_NUM (GROUPING (deptno), GROUPING (job)) AS bn
    FROM emp
   WHERE sal > 2000
GROUP BY ROLLUP (deptno, job)
ORDER BY 6, 1, 2;

--
SELECT   deptno, job, COUNT (*) AS c1, GROUP_ID () AS gi
    FROM emp
   WHERE sal > 2000
GROUP BY deptno, ROLLUP (deptno, job)
