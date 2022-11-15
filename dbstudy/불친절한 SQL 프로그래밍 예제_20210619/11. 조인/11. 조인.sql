--
SELECT   a.deptno, a.dname, b.empno, b.ename
    FROM dept a, emp b
   WHERE b.deptno = a.deptno
ORDER BY a.deptno, b.empno;
