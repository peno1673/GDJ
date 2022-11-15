--
SELECT SUM (sal) AS sal FROM emp WHERE SUM (sal) > 25000;

--
SELECT SUM (sal) AS sal FROM emp HAVING SUM (sal) > 25000;

--
SELECT   deptno, SUM (sal) AS sal
    FROM emp
GROUP BY deptno
  HAVING SUM (sal) > 10000;

--
SELECT   deptno, SUM (sal) AS sal
    FROM emp
GROUP BY deptno
  HAVING MAX (sal) >= 5000;

--
SELECT   deptno, SUM (sal) AS sal
    FROM emp
GROUP BY deptno
  HAVING deptno != 30
ORDER BY deptno;

--
SELECT   deptno, SUM (sal) AS sal
    FROM emp
   WHERE deptno != 30
GROUP BY deptno
ORDER BY deptno;

--
SELECT   deptno, job, COUNT (*) AS c1, GROUP_ID () AS gi
    FROM emp
   WHERE sal > 2000
GROUP BY deptno, ROLLUP (deptno, job)
  HAVING GROUP_ID () = 0;
