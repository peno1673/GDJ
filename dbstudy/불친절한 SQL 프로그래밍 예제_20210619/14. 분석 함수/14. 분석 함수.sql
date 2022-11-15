--
SELECT   a.empno, a.sal, b.sal AS c1, a.sal / b.sal AS c2
    FROM emp a
       , (SELECT deptno, SUM (sal) AS sal FROM emp GROUP BY deptno) b
   WHERE a.deptno = 10
     AND b.deptno = a.deptno
ORDER BY 1;

--
SELECT   empno, sal
       , SUM (sal) OVER () AS c1
       , RATIO_TO_REPORT (sal) OVER () AS c2
    FROM emp
   WHERE deptno = 10
ORDER BY 1;

--
SELECT empno, sal, SUM (sal) AS c1 FROM emp WHERE deptno = 10;
