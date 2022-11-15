--
SELECT a.c1, (SELECT MAX (x.c2) FROM t2 x WHERE x.c1 = a.c1) AS c2 FROM t1 a;

--
SELECT (SELECT x.c2 FROM t2 x WHERE x.c1 = a.c1) AS c2 FROM t1 a;

--
SELECT a.deptno, a.dname
     , (SELECT MIN (x.sal) FROM emp x WHERE x.deptno = a.deptno) AS sal_min
     , (SELECT MAX (x.sal) FROM emp x WHERE x.deptno = a.deptno) AS sal_max
  FROM dept a;

--
SELECT a.deptno, a.dname
     , (SELECT MIN (x.sal), MAX (x.sal) FROM emp x WHERE x.deptno = a.deptno) AS sal
  FROM dept a;

--
SELECT deptno, dname
     , TO_NUMBER (REGEXP_SUBSTR (sal, '[^,]+', 1, 1)) AS sal_min
     , TO_NUMBER (REGEXP_SUBSTR (sal, '[^,]+', 1, 2)) AS sal_max
  FROM (SELECT a.deptno, a.dname
             , (SELECT MIN (x.sal) || ',' || MAX (x.sal)
                  FROM emp x
                 WHERE x.deptno = a.deptno) AS sal
          FROM dept a);

--
SELECT a.deptno, a.dname
     , NVL ((SELECT SUM (x.sal) FROM emp x WHERE x.deptno = a.deptno), 0) AS sal
     , CASE
           WHEN (SELECT SUM (x.sal) FROM emp x WHERE x.deptno = a.deptno) >= 10000 THEN 1
           ELSE 2
       END AS grade
  FROM dept a;
