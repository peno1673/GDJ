--
SELECT   *
    FROM (SELECT job, deptno, sal FROM emp)
   PIVOT (SUM (sal) FOR deptno IN (10, 20, 30))
ORDER BY 1;

--
SELECT   *
    FROM (SELECT job, TO_CHAR (hiredate, 'YYYY') AS yyyy, deptno, sal FROM emp)
   PIVOT (SUM (sal) FOR deptno IN (10, 20, 30))
ORDER BY 1, 2;

--
SELECT   *
    FROM (SELECT job, deptno, sal FROM emp)
   PIVOT (SUM (sal) AS sal FOR deptno IN (10 AS d10, 20 AS d20, 30 AS d30))
ORDER BY 1;

--
SELECT   job, d20_sal
    FROM (SELECT job, deptno, sal FROM emp)
   PIVOT (SUM (sal) AS sal FOR deptno IN (10 AS d10, 20 AS d20, 30 AS d30))
   WHERE d20_sal > 2500
ORDER BY 1;

--
SELECT   *
    FROM (SELECT job, deptno, sal FROM emp)
   PIVOT (SUM (sal) AS sal, COUNT (*) AS cnt FOR deptno IN (10 AS d10, 20 AS d20))
ORDER BY 1;

--
SELECT   *
    FROM (SELECT TO_CHAR (hiredate, 'YYYY') AS yyyy, deptno, job, sal FROM emp)
   PIVOT (SUM (sal) AS sal, COUNT (*) as cnt
          FOR (deptno, job) IN ((10, 'ANALYST') AS d10a, (10, 'CLERK') AS d10C
                              , (20, 'ANALYST') AS d20a, (20, 'CLERK') AS d20c))
ORDER BY 1;

--
SELECT   *
    FROM (SELECT job, deptno, sal FROM emp)
   PIVOT XML (SUM (sal) AS sal FOR deptno IN (SELECT deptno FROM dept))
ORDER BY 1;

--
SELECT   *
    FROM (SELECT job, deptno, sal FROM emp)
   PIVOT XML (SUM (sal) AS sal FOR deptno IN (ANY))
ORDER BY 1;

--
SELECT *
  FROM (SELECT job, deptno, sal FROM emp)
 PIVOT XML (SUM (sal) AS sal, COUNT (*) AS cnt FOR (deptno, job) IN (ANY, ANY));

--
SELECT   job
       , SUM (DECODE (deptno, 10, sal)) AS d10_sal
       , SUM (DECODE (deptno, 20, sal)) AS d20_sal
       , SUM (DECODE (deptno, 30, sal)) AS d30_sal
    FROM emp
GROUP BY job
ORDER BY 1;
