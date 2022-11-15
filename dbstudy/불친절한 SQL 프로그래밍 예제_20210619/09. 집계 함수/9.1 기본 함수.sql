--
SELECT COUNT (*) AS c1, COUNT (comm) AS c2, COUNT (DISTINCT deptno) AS c3 FROM emp;

--
SELECT MIN (ename) AS c1, MIN (hiredate) AS c2, MIN (comm) AS c3 FROM emp;

--
SELECT COUNT (comm) AS c1, MIN (comm) AS c2 FROM emp WHERE deptno = 10;

--
SELECT MAX (ename) AS c1, MAX (hiredate) AS c2, MAX (comm) AS c3 FROM emp;

--
SELECT 'Y' AS c1
  FROM emp
 WHERE empno = 0;

SELECT NVL ('Y', 'N') AS c1
  FROM emp
 WHERE empno = 0;

--
SELECT MAX ('Y') AS c1
  FROM emp
 WHERE empno = 0;

SELECT NVL (MAX ('Y'), 'N') AS c1
  FROM emp
 WHERE empno = 0;

--
SELECT SUM (sal) AS c1, SUM (DISTINCT sal) AS c2, SUM (comm) AS c3 FROM emp;

--
SELECT sal, comm, sal + comm AS c1 FROM emp WHERE deptno = 10;

--
SELECT SUM (sal + comm)                         AS c1
     , SUM (sal) + SUM (comm)                   AS c2
     , SUM (NVL (sal, 0)) + SUM (NVL (comm, 0)) AS c3
     , NVL (SUM (sal), 0) + NVL (SUM (comm), 0) AS c4
     , NVL (SUM (sal) + SUM (comm), 0)          AS c5
  FROM emp
 WHERE deptno = 10;

--
SELECT   deptno, sal
       , DECODE (deptno, 10, sal) AS d10_sal
       , DECODE (deptno, 20, sal) AS d20_sal
       , DECODE (deptno, 30, sal) AS d30_sal
       , DECODE (deptno, 40, sal) AS d40_sal
    FROM emp
ORDER BY deptno, sal;

--
SELECT SUM (DECODE (deptno, 10, sal)) AS d10_sal
     , SUM (DECODE (deptno, 20, sal)) AS d20_sal
     , SUM (DECODE (deptno, 30, sal)) AS d30_sal
     , SUM (DECODE (deptno, 40, sal)) AS d40_sal
  FROM emp;

--
SELECT SUM (CASE WHEN deptno IN (10, 20) THEN  sal END)
     - SUM (CASE WHEN deptno = 30 THEN  sal END) AS c1
     , SUM (CASE WHEN deptno IN (10, 20) THEN  sal
                 WHEN deptno = 30 THEN -sal END) AS c2
  FROM emp;

--
SELECT EXP (SUM (LN (sal))) AS c1 FROM emp WHERE deptno = 10;

--
SELECT AVG (sal)  AS c1, AVG (DISTINCT sal)  AS c2
     , AVG (comm) AS c3, AVG (NVL (comm, 0)) AS c4
  FROM emp;

--
SELECT SUM (sal)          / COUNT (sal)          AS c1 -- 29025 / 14
     , SUM (DISTINCT sal) / COUNT (DISTINCT sal) AS c2 -- 24775 / 12
     , SUM (comm)         / COUNT (comm)         AS c3 --  2200 /  4
     , SUM (comm)         / COUNT (*)            AS c4 --  2200 / 14
  FROM emp;
