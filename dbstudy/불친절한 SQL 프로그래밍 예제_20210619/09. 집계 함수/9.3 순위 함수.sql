--
SELECT   sal
    FROM emp
   WHERE deptno = 30
ORDER BY sal;

SELECT   sal, comm
    FROM emp
   WHERE deptno = 30
ORDER BY sal, comm;

--
SELECT RANK (1500) WITHIN GROUP (ORDER BY sal) AS c1
     , RANK (1500, 500) WITHIN GROUP (ORDER BY sal, comm) AS c2
  FROM emp
 WHERE deptno = 30;

--
SELECT DENSE_RANK (1500) WITHIN GROUP (ORDER BY sal) AS c1
     , DENSE_RANK (1500, 500) WITHIN GROUP (ORDER BY sal, comm) AS c2
  FROM emp
 WHERE deptno = 30;

--
SELECT CUME_DIST (1500) WITHIN GROUP (ORDER BY sal) AS c1
     , CUME_DIST (1500, 500) WITHIN GROUP (ORDER BY sal, comm) AS c2
  FROM emp
 WHERE deptno = 30;

--
SELECT PERCENT_RANK (1500) WITHIN GROUP (ORDER BY sal) AS c1
     , PERCENT_RANK (1500, 500) WITHIN GROUP (ORDER BY sal, comm) AS c2
  FROM emp
 WHERE deptno = 30;
