--
SELECT a.dname, b.ename
  FROM (SELECT * FROM dept WHERE loc = 'DALLAS') a
     , (SELECT * FROM emp  WHERE job = 'CLERK' ) b
 WHERE b.deptno = a.deptno;

--
SELECT a.dname, b.ename
  FROM dept a, emp b
 WHERE a.loc = 'DALLAS'
   AND b.deptno = a.deptno
   AND b.job = 'CLERK';

--
SELECT a.dname, b.sal
  FROM dept a
     , (SELECT deptno, SUM (sal) AS sal FROM emp GROUP BY deptno) b
 WHERE b.deptno = a.deptno;

--
SELECT   MAX (b.dname) AS dname, SUM (a.sal) AS sal
    FROM emp a, dept b
   WHERE b.deptno = a.deptno
GROUP BY a.deptno;
