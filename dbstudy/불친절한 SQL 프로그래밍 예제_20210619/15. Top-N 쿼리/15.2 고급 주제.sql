--
SELECT empno, sal, deptno, dname
  FROM (SELECT   a.empno, a.sal, a.deptno, b.dname
            FROM emp a, dept b
           WHERE b.deptno(+) = a.deptno
        ORDER BY a.sal, a.empno)
 WHERE ROWNUM <= 2;

--
SELECT   a.empno, a.sal, a.deptno, b.dname
    FROM (SELECT *
            FROM (SELECT empno, sal, deptno FROM emp ORDER BY sal, empno)
           WHERE ROWNUM <= 2) a
       , dept b
   WHERE b.deptno(+) = a.deptno
ORDER BY a.sal, a.empno;

--
SELECT a.empno, a.sal, a.deptno
     , (SELECT x.dname FROM dept x WHERE x.deptno = a.deptno) AS dname
  FROM (SELECT empno, sal, deptno FROM emp ORDER BY sal, empno) a
 WHERE ROWNUM <= 2;

--
SELECT empno, sal, deptno, dname
  FROM (SELECT   a.empno, a.sal, a.deptno, b.dname
            FROM emp a, dept b
           WHERE b.deptno = a.deptno
             AND b.loc = 'DALLAS'
        ORDER BY a.sal, a.empno)
 WHERE ROWNUM <= 2;

--
SELECT   a.empno, a.sal, a.deptno, b.dname
    FROM (SELECT empno, sal, deptno
            FROM (SELECT empno, sal, deptno FROM emp ORDER BY sal, empno)
           WHERE ROWNUM <= 2) a
       , dept b
   WHERE b.deptno(+) = a.deptno
     AND b.loc(+) = 'DALLAS'
ORDER BY a.sal, a.empno;

--
SELECT tp, no, name
  FROM (SELECT 1 AS tp, deptno AS no, dname AS name FROM dept
        UNION ALL
        SELECT 2 AS tp, empno  AS no, ename AS name FROM emp
        ORDER BY tp, no)
 WHERE ROWNUM <= 3;

--
SELECT tp, no, name
  FROM (SELECT tp, no, name
          FROM (SELECT 1 AS tp, deptno AS no, dname AS name FROM dept ORDER BY no)
         WHERE ROWNUM <= 3
        UNION ALL
        SELECT tp, no, name
          FROM (SELECT 2 AS tp, empno  AS no, ename AS name FROM emp  ORDER BY no)
         WHERE ROWNUM <= 3)
 WHERE ROWNUM <= 3;
