--
SELECT ename, sal, hiredate FROM emp WHERE deptno = 20 ORDER BY 2, 3, 1;

--
SELECT MIN (hiredate) KEEP (DENSE_RANK FIRST ORDER BY sal) AS c1
     , MAX (hiredate) KEEP (DENSE_RANK FIRST ORDER BY sal) AS c2
     , MIN (hiredate) KEEP (DENSE_RANK LAST  ORDER BY sal) AS c3
     , MAX (hiredate) KEEP (DENSE_RANK LAST  ORDER BY sal) AS c4
  FROM emp
 WHERE deptno = 20;

--
SELECT SUBSTR (MIN (LPAD (sal, 4, '0') || TO_CHAR (hiredate, 'YYYYMMDD')), 5) AS c1
     , SUBSTR (MAX (LPAD (sal, 4, '0') || TO_CHAR (hiredate, 'YYYYMMDD')), 5) AS c4
  FROM emp
 WHERE deptno = 20;
