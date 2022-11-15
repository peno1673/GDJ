--
SELECT deptno, job, hiredate, sal FROM emp WHERE sal > 2000 ORDER BY 1, 2, 3;

--
SELECT SUM (sal) AS c1 FROM emp WHERE sal > 2000 GROUP BY ();

--
SELECT deptno, SUM (sal) AS sal FROM emp WHERE sal > 2000 GROUP BY deptno ORDER BY 1;

--
SELECT   deptno, job, SUM (sal) AS sal
    FROM emp
   WHERE sal > 2000
GROUP BY deptno, job
ORDER BY deptno, job;

--
SELECT   deptno
       , sal
    FROM emp
   WHERE sal > 2000
GROUP BY deptno;

SELECT   deptno
    FROM emp
   WHERE sal > 2000
GROUP BY deptno
ORDER BY sal;

--
SELECT   deptno
       , SUM (sal) AS sal
    FROM emp
   WHERE sal > 2000
GROUP BY deptno;

SELECT   deptno
    FROM emp
   WHERE sal > 2000
GROUP BY deptno
ORDER BY SUM (sal);

--
SELECT   DECODE (deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES') AS dname
       , SUM (sal) AS sal
    FROM emp
   WHERE sal > 2000
GROUP BY deptno
ORDER BY 1;

--
SELECT   deptno, GREATEST (SUM (sal), 5000) AS sal
    FROM emp
   WHERE sal > 2000
GROUP BY deptno
ORDER BY deptno;

--
SELECT   AVG (SUM (sal)) AS c1
    FROM emp
   WHERE sal > 2000
GROUP BY deptno;

SELECT AVG (sal) AS c1
  FROM emp
 WHERE sal > 2000;

--
SELECT deptno FROM emp GROUP BY deptno;

--
SELECT DISTINCT deptno FROM emp;

--
SELECT   TO_CHAR (hiredate, 'YYYY') AS hiredate, SUM (sal) AS sal
    FROM emp
GROUP BY TO_CHAR (hiredate, 'YYYY')
ORDER BY 1;


--
SELECT   CASE WHEN deptno IN (10, 20) THEN 1020 ELSE 3040 END AS deptno
       , SUM (sal) AS sal
    FROM emp
GROUP BY CASE WHEN deptno IN (10, 20) THEN 1020 ELSE 3040 END
ORDER BY 1;

--
SELECT NVL (MAX ('Y'), 'N') AS yn FROM emp WHERE empno = 9999 GROUP BY empno;

--
SELECT   job
       , SUM (DECODE (deptno, 10, sal)) AS d10_sal
       , SUM (DECODE (deptno, 20, sal)) AS d20_sal
       , SUM (DECODE (deptno, 30, sal)) AS d30_sal
       , SUM (DECODE (deptno, 40, sal)) AS d40_sal
    FROM emp
GROUP BY job
ORDER BY job;

--
SELECT   deptno
       , MIN (hiredate) AS c1
       , MIN (hiredate) KEEP (DENSE_RANK FIRST ORDER BY sal) AS c2
    FROM emp
GROUP BY deptno
ORDER BY deptno;
