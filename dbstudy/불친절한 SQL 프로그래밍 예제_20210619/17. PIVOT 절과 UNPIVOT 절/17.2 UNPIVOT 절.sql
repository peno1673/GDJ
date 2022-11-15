--
DROP TABLE t1 PURGE;

CREATE TABLE t1 AS
SELECT job, d10_sal, d20_sal, d10_cnt, d20_cnt
  FROM (SELECT job, deptno, sal FROM emp WHERE job IN ('ANALYST', 'CLERK'))
 PIVOT (SUM (sal) AS sal, COUNT (*) AS cnt FOR deptno IN (10 AS d10, 20 AS d20));

--
SELECT * FROM t1 ORDER BY job;

--
SELECT   job, deptno, sal
    FROM t1
 UNPIVOT (sal FOR deptno IN (d10_sal, d20_sal))
   WHERE job = 'CLERK'
ORDER BY 1, 2;

--
SELECT   job, deptno, sal
    FROM t1
 UNPIVOT (sal FOR deptno IN (d10_sal AS 10, d20_sal AS 20))
ORDER BY 1, 2;

--
SELECT   job, deptno, sal
    FROM t1
 UNPIVOT INCLUDE NULLS (sal FOR deptno IN (d10_sal AS 10, d20_sal AS 20))
ORDER BY 1, 2;

--
SELECT   *
    FROM t1
 UNPIVOT ((sal, cnt)
          FOR deptno IN ((d10_sal, d10_cnt) AS 10, (d20_sal, d20_cnt) AS 20))
ORDER BY 1, 2;

--
SELECT   *
    FROM t1
 UNPIVOT ((sal, cnt)
          FOR (deptno, dname) IN ((d10_sal, d10_cnt) AS (10, 'ACCOUNTING')
                                , (d20_sal, d20_cnt) AS (20, 'RESEARCH'  )))
ORDER BY 1, 2;

--
SELECT   *
    FROM (SELECT job, deptno, sal, comm FROM emp)
   PIVOT (SUM (sal) AS sal, SUM (comm) AS comm
          FOR deptno IN (10 AS d10, 20 AS d20, 30 AS d30))
 UNPIVOT INCLUDE NULLS
         ((sal, comm) FOR deptno IN ((d10_sal, d10_comm) AS 10
                                   , (d20_sal, d20_comm) AS 20
                                   , (d30_sal, d30_comm) AS 30))
ORDER BY 1, 2;

--
DROP TABLE t1 PURGE;

CREATE TABLE t1 AS
SELECT TO_CHAR (ADD_MONTHS (DATE '2050-01-01', ROWNUM - 1), 'YYYYMM') AS ym
     , MOD (ROWNUM, 12) AS v1, MOD (ROWNUM, 12) + 1 AS v2
  FROM XMLTABLE ('1 to 24');

--
SELECT * FROM t1;

--
SELECT   *
    FROM (SELECT SUBSTR (ym, 1, 4) AS yy, SUBSTR (ym, 5, 2) AS mm, v1, v2 FROM t1)
 UNPIVOT (vl FOR tp IN (v1, v2))
   PIVOT (MAX (vl) AS vl
          FOR mm IN ('01' AS m01, '02' AS m02, '03' AS m03
                   , '04' AS m04, '05' AS m05, '06' AS m06))
ORDER BY 1, 2;

--
SELECT   a.job
       , DECODE (b.lv, 1, 10       , 2, 20       ) AS deptno
       , DECODE (b.lv, 1, a.d10_sal, 2, a.d20_sal) AS sal
       , DECODE (b.lv, 1, a.d10_cnt, 2, a.d20_cnt) AS cnt
    FROM t1 a
       , (SELECT LEVEL AS lv FROM DUAL CONNECT BY LEVEL <= 2) b
ORDER BY 1, 2;

--
SELECT   a.job, b.lv, a.d10_sal, a.d20_sal, a.d10_cnt, a.d20_cnt
    FROM t1 a
       , (SELECT LEVEL AS lv FROM DUAL CONNECT BY LEVEL <= 2) b
ORDER BY a.job, b.lv;
