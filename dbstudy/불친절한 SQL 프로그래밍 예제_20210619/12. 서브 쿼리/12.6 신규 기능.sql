--
SELECT a.deptno, a.dname, b.empno, b.ename
  FROM dept a
     , (SELECT x.* FROM emp x WHERE x.deptno = a.deptno) b;

--
SELECT a.deptno, a.dname, b.empno, b.ename
  FROM dept a
     , LATERAL
       (SELECT x.* FROM emp x WHERE x.deptno = a.deptno) b;

--
SELECT a.deptno, a.dname, b.empno, b.ename
  FROM dept a
     , LATERAL
       (SELECT x.* FROM emp x WHERE x.deptno = a.deptno)(+) b;

--
SELECT a.deptno, a.dname, b.sal
  FROM dept a
     , LATERAL
       (SELECT SUM (x.sal) AS sal FROM emp x WHERE x.deptno = a.deptno) b;

--
SELECT a.deptno, a.dname, b.sal
  FROM dept a
     , LATERAL
       (SELECT SUM (x.sal) AS sal FROM emp x WHERE x.deptno = a.deptno GROUP BY ()) b;

--
SELECT a.deptno, a.dname, b.empno, b.ename
  FROM dept a
 CROSS
 APPLY (SELECT x.* FROM emp x WHERE x.deptno = a.deptno) b;

--
SELECT a.deptno, a.dname, b.empno, b.ename
  FROM dept a
 OUTER
 APPLY (SELECT x.* FROM emp x WHERE x.deptno = a.deptno) b;

--
SELECT a.deptno, a.dname
  FROM dept a
 WHERE EXISTS (SELECT 1
                 FROM (SELECT COUNT (*) AS cn FROM emp x WHERE x.deptno = a.deptno)
                WHERE cn >= 5);

--
SELECT a.deptno, a.dname
  FROM dept a
 WHERE EXISTS (SELECT 1
                 FROM (SELECT COUNT (*) AS cn FROM emp x WHERE x.deptno = a.deptno)
                WHERE cn >= 5);

--
SELECT a.deptno, a.dname
  FROM dept a
 WHERE EXISTS (SELECT 1 FROM emp x WHERE x.deptno = a.deptno HAVING COUNT (*) >= 5);

--
SELECT a.deptno, a.dname
     , (SELECT MAX (sal) AS sal
          FROM (SELECT AVG (x.sal) AS sal
                  FROM emp x
                 WHERE x.deptno = a.deptno)) AS sal
  FROM dept a;

--
SELECT a.deptno, a.dname
     , (SELECT   MAX (AVG (x.sal)) AS sal
            FROM emp x
           WHERE x.deptno = a.deptno
        GROUP BY x.deptno) AS sal
  FROM dept a;
