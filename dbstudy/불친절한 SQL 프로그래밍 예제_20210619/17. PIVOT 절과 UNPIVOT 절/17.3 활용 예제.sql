--
DEF s_af = 'SUM (sal) AS sal';
DEF s_il = 'deptno IN (10 AS d10, 20 AS d20)';

SELECT   *
    FROM (SELECT job, deptno, sal FROM emp)
   PIVOT (&s_af FOR &s_il)
ORDER BY 1;

--
DEF s_af = 'SUM (sal) AS sal, COUNT (*) AS cnt';
DEF s_il = 'deptno IN (10 AS d10)';

SELECT   *
    FROM (SELECT job, deptno, sal FROM emp)
   PIVOT (&s_af FOR &s_il)
ORDER BY 1;

--
WITH w1 AS (
SELECT   job, TO_CHAR (hiredate, 'YYYY') AS hireyear, SUM (sal) AS sal
    FROM emp
GROUP BY job, TO_CHAR (hiredate, 'YYYY'))
SELECT   *
    FROM (SELECT a.*, DENSE_RANK () OVER (ORDER BY a.hireyear) AS dr FROM w1 a)
   PIVOT (MAX (hireyear), MAX (sal) AS sal
          FOR dr IN (1 AS y1, 2 AS y2, 3 AS y3, 4 AS y4, 5 AS y5))
ORDER BY job;

--
WITH w1 AS (
SELECT TO_CHAR (empno) AS empno, ename, job, TO_CHAR (mgr) AS mgr
     , TO_CHAR (hiredate, 'YYYY-MM-DD') AS hiredate, TO_CHAR (sal) AS sal
     , TO_CHAR (comm) AS comm, TO_CHAR (deptno) AS deptno
  FROM emp
 WHERE empno = 7788)
SELECT  *
   FROM w1
UNPIVOT (value
         FOR column_name IN (empno, ename, job, mgr, hiredate, sal, comm, deptno));

--
SELECT   column_name, value, COUNT(*) AS cnt
    FROM (SELECT job, TO_CHAR (deptno) AS deptno FROM emp)
 UNPIVOT (value FOR column_name IN (job, deptno))
GROUP BY column_name, value
ORDER BY 1, 2;

--
WITH w1 AS (
SELECT job
     , NVL (d10_sal, 0) AS d10_sal
     , NVL (d20_sal, 0) AS d20_sal
     , NVL (d30_sal, 0) AS d30_sal
  FROM (SELECT job, deptno, sal FROM emp)
 PIVOT (SUM (sal) AS sal
        FOR deptno IN (10 AS d10, 20 AS d20, 30 AS d30)))
   , w2 AS (
SELECT a.*
     , d10_sal / NVL (NULLIF (d20_sal + d30_sal, 0) / 2, d10_sal) AS d10_ratio
     , d20_sal / NVL (NULLIF (d10_sal + d30_sal, 0) / 2, d20_sal) AS d20_ratio
     , d30_sal / NVL (NULLIF (d10_sal + d20_sal, 0) / 2, d30_sal) AS d30_ratio
  FROM w1 a)
SELECT   job, deptno, sal, ROUND (ratio, 2) * 100 AS ratio
    FROM w2
 UNPIVOT ((sal, ratio) FOR deptno IN ((d10_sal, d10_ratio) AS 10
                                    , (d20_sal, d20_ratio) AS 20
                                    , (d30_sal, d30_ratio) AS 30))
ORDER BY 1, 2;
