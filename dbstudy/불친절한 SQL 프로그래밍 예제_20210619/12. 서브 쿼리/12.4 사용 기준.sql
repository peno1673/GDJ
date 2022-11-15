--
SELECT a.deptno, a.dname, b.ename
  FROM dept a, emp b
 WHERE b.deptno = a.deptno;

--
SELECT a.deptno, a.dname
  FROM dept a
 WHERE EXISTS (SELECT 1 FROM emp x WHERE x.deptno = a.deptno);

--
SELECT a.deptno, a.dname
  FROM dept a
     , (SELECT DISTINCT deptno FROM emp) b
 WHERE b.deptno = a.deptno;

--
SELECT DISTINCT a.deptno, a.dname FROM dept a, emp b WHERE b.deptno = a.deptno;

--
SELECT a.empno, a.ename
  FROM emp a
 WHERE EXISTS (SELECT 1 FROM dept x WHERE x.deptno = a.deptno);

--
SELECT a.empno, a.ename FROM emp a, dept b WHERE b.deptno = a.deptno;

--
SELECT a.deptno, a.dname
  FROM dept a
 WHERE NOT EXISTS (SELECT 1 FROM emp x WHERE x.deptno = a.deptno);

--
SELECT a.deptno, a.dname
  FROM dept a
     , (SELECT DISTINCT deptno FROM emp) b
 WHERE b.deptno(+) = a.deptno
   AND b.deptno IS NULL;

--
SELECT a.deptno, a.dname
  FROM dept a
     , (SELECT DISTINCT deptno FROM emp) b
 WHERE b.deptno != a.deptno;

--
SELECT a.deptno, a.dname
     , (SELECT MIN (sal) FROM emp x WHERE x.deptno = a.deptno) AS sal_min
     , (SELECT MAX (sal) FROM emp x WHERE x.deptno = a.deptno) AS sal_max
  FROM dept a;

--
SELECT a.deptno, a.dname, b.sal_min, b.sal_max
  FROM dept a
     , (SELECT deptno, MIN (sal) AS sal_min, MAX (sal) AS sal_max FROM emp GROUP BY deptno) b
 WHERE b.deptno(+) = a.deptno;

--
SELECT   a.deptno, a.dname, MIN (sal) AS sal_min, MAX (sal) AS sal_max
    FROM dept a, emp b
   WHERE b.deptno(+) = a.deptno
GROUP BY a.deptno, a.dname;

--
SELECT a.empno, a.ename
     , (SELECT x.dname FROM dept x WHERE x.deptno = a.deptno) AS dname
  FROM emp a;

--
SELECT a.empno, a.ename, b.dname
  FROM emp a, dept b
 WHERE b.deptno = a.deptno;

--
SELECT a.empno, a.ename
     , (SELECT x.dname
          FROM dept x
         WHERE x.deptno = a.deptno
           AND x.loc = 'DALLAS') AS dname
  FROM emp a;

SELECT a.empno, a.ename, b.dname
  FROM emp a, dept b
 WHERE b.deptno(+) = a.deptno
   AND b.loc(+) = 'DALLAS';

--
SELECT a.empno, a.ename
     , (SELECT x.dname
          FROM dept x
         WHERE x.deptno = a.deptno
           AND a.job = 'CLERK') AS dname
  FROM emp a;

SELECT a.empno, a.ename, b.dname
  FROM emp a
  LEFT OUTER
  JOIN dept b
    ON a.job = 'CLERK'
   AND b.deptno = a.deptno;

--
SELECT a.c1 AS a, b.c1 AS b, c.c1 AS c, d.c1 AS d
  FROM (t1 a LEFT OUTER JOIN t2 b ON b.c1 = a.c1)
  LEFT OUTER
  JOIN (t3 c LEFT OUTER JOIN t4 d ON c.c1 = d.c1)
    ON d.c1 = a.c1;

--
SELECT a.a, a.b, b.c, b.d
  FROM (SELECT a.c1 AS a, b.c1 AS b FROM t1 a, t2 b WHERE b.c1(+) = a.c1) a
     , (SELECT c.c1 AS c, d.c1 AS d FROM t3 c, t4 d WHERE d.c1(+) = c.c1) b
 WHERE b.c(+) = a.a;

--
SELECT   deptno
       , MIN (sal + NVL (comm, 0)) AS sal_min
       , MAX (sal + NVL (comm, 0)) AS sal_max
    FROM emp
GROUP BY deptno;

--
SELECT   deptno
       , MIN (sal) AS sal_min
       , MAX (sal) AS sal_max
    FROM (SELECT deptno, sal + NVL (comm, 0) AS sal FROM emp)
GROUP BY deptno;
