--
SELECT empno, ename, mgr FROM emp;

--
SELECT b.empno, b.ename, b.mgr
  FROM emp a, emp b
 WHERE a.ename = 'JONES'
   AND b.mgr = a.empno;

--
SELECT c.empno, c.ename, c.mgr
  FROM emp a, emp b, emp c
 WHERE a.ename = 'JONES'
   AND b.mgr = a.empno
   AND c.mgr = b.empno;

--
SELECT b.empno, b.ename, b.mgr
  FROM emp a, emp b
 WHERE a.ename = 'SMITH'
   AND b.empno = a.mgr;

--
SELECT c.empno, c.ename, c.mgr
  FROM emp a, emp b, emp c
 WHERE a.ename = 'SMITH'
   AND b.empno = a.mgr
   AND c.empno = b.mgr;
