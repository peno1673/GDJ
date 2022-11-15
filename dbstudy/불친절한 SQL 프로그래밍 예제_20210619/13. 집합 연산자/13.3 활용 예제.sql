--
SELECT ename, sal, deptno
  FROM emp
 WHERE ((deptno = 10 AND sal >= 2000) OR (deptno = 20 AND sal >= 3000));

--
SELECT ename, sal, deptno FROM emp WHERE deptno = 10 AND sal >= 2000 UNION ALL
SELECT ename, sal, deptno FROM emp WHERE deptno = 20 AND sal >= 3000;

--
SELECT ename, mgr, deptno FROM emp WHERE (mgr = 7839 OR deptno = 10);

--
SELECT ename, mgr, deptno FROM emp WHERE mgr = 7839
UNION ALL
SELECT ename, mgr, deptno FROM emp WHERE deptno = 10;

--
SELECT ename, mgr, deptno FROM emp WHERE mgr = 7839
UNION ALL
SELECT ename, mgr, deptno FROM emp WHERE mgr != 7839 AND deptno = 10;

--
SELECT ename, mgr, deptno FROM emp WHERE mgr = 7839
UNION ALL
SELECT ename, mgr, deptno FROM emp WHERE (mgr != 7839 OR mgr IS NULL) AND deptno = 10;

--
SELECT ename, mgr, deptno FROM emp WHERE mgr = 7839
UNION ALL
SELECT ename, mgr, deptno FROM emp WHERE LNNVL (mgr = 7839) AND deptno = 10;

--
SELECT dname, loc
  FROM dept
 WHERE ((:b1 = 1 AND dname = :b2) OR (:b1 = 2 AND loc = :b2));

--
VAR b1 NUMBER = 1
VAR b2 VARCHAR2(100) = 'ACCOUNTING'

SELECT dname, loc
  FROM dept
 WHERE :b1 = 1
   AND dname = :b2
UNION ALL
SELECT dname, loc
  FROM dept
 WHERE :b1 = 2
   AND loc = :b2;

EXEC :b1 := 2
EXEC :b2 := 'CHICAGO'

SELECT dname, loc
  FROM dept
 WHERE :b1 = 1
   AND dname = :b2
UNION ALL
SELECT dname, loc
  FROM dept
 WHERE :b1 = 2
   AND loc = :b2;

--
SELECT * FROM dept ORDER BY DECODE (:b1, 1, dname, 2, loc);

--
VAR b1 NUMBER = 1

SELECT *
  FROM (SELECT   dname, loc
            FROM dept
           WHERE :b1 = 1
        ORDER BY dname)
UNION ALL
SELECT *
  FROM (SELECT   dname, loc
            FROM dept
           WHERE :b1 = 2
        ORDER BY loc);

EXEC :b1 := 2

SELECT *
  FROM (SELECT   dname, loc
            FROM dept
           WHERE :b1 = 1
        ORDER BY dname)
UNION ALL
SELECT *
  FROM (SELECT   dname, loc
            FROM dept
           WHERE :b1 = 2
        ORDER BY loc);

--
SELECT   COALESCE (a.c1, b.c1) AS c1, a.c2 AS t1, b.c2 AS t2
    FROM (SELECT c1, SUM (c2) AS c2 FROM t1 GROUP BY c1) a
    FULL OUTER
    JOIN (SELECT c1, SUM (c2) AS c2 FROM t2 GROUP BY c1) b
      ON b.c1= a.c1
ORDER BY 1;

--
SELECT   c1, SUM (t1) AS t1, SUM (t2) AS t2
    FROM (SELECT c1, c2   AS t1, NULL AS t2 FROM t1
          UNION ALL
          SELECT c1, NULL AS t1, c2   AS t2 FROM t2)
GROUP BY c1
ORDER BY 1;

--
DROP TABLE ts PURGE;
DROP TABLE tt PURGE;

CREATE TABLE ts (c1 NUMBER, c2 NUMBER, CONSTRAINT ts_pk PRIMARY KEY (c1));
CREATE TABLE tt (c1 NUMBER, c2 NUMBER, CONSTRAINT tt_pk PRIMARY KEY (c1));

INSERT INTO ts VALUES (1, 0);
INSERT INTO ts VALUES (2, 2);
INSERT INTO ts VALUES (4, 4);
INSERT INTO tt VALUES (1, 1);
INSERT INTO tt VALUES (2, 2);
INSERT INTO tt VALUES (3, 3);
COMMIT;

--
SELECT   c1, c2, COUNT (sc) AS sc, COUNT (tg) AS tg
    FROM (SELECT c1, c2, 1 AS sc, NULL AS tg FROM ts
          UNION ALL
          SELECT c1, c2, NULL AS sc, 1 AS tg FROM tt)
GROUP BY c1, c2
ORDER BY 1, 3, 4;

--
WITH w1 AS (
SELECT   c1, c2, COUNT (sc) AS sc, COUNT (tg) AS tg
   FROM (SELECT c1, c2, 1 AS sc, NULL AS tg FROM ts
         UNION ALL
         SELECT c1, c2, NULL AS sc, 1 AS tg FROM tt)
GROUP BY c1, c2)
SELECT a.*
     , CASE
           WHEN a.cn = 1 AND a.sc = 1 THEN 'C' -- 입력
           WHEN a.cn = 1 AND a.tg = 1 THEN 'D' -- 삭제
           WHEN a.cn = 2              THEN 'U' -- 수정
       END AS tp
  FROM (SELECT a.*, COUNT (*) OVER (PARTITION BY c1) AS cn
          FROM w1 a
         WHERE a.sc != a.tg) a
 WHERE (   (a.cn = 1 AND a.sc = 1)
        OR (a.cn = 1 AND a.tg = 1)
        OR (a.cn = 2 AND a.sc = 1));

--
WITH w1 AS (
SELECT   deptno, 'Y'  AS c1, NULL AS c2
    FROM emp
   WHERE job = 'CLERK'
UNION ALL
SELECT   deptno, NULL AS c1, 'Y'  AS c2
    FROM emp
GROUP BY deptno
  HAVING COUNT (*) >= 4)
SELECT   a.deptno, b.dname, a.c1, a.c2
    FROM (SELECT deptno, MAX (c1) AS c1, MAX (c2) AS c2 FROM w1 GROUP BY deptno) a
       , dept b
   WHERE b.deptno = a.deptno
ORDER BY 1;

--
SELECT c1, c2 FROM t1
INTERSECT
SELECT c1, c2 FROM t2;

SELECT DISTINCT
       a.c1, a.c2
  FROM t1 a
 WHERE EXISTS (SELECT 1
                 FROM t2 x
                WHERE x.c1 = a.c1
                  AND LNNVL (x.c2 != a.c2));

--
SELECT c1, c2 FROM t1
MINUS
SELECT c1, c2 FROM t2;

SELECT DISTINCT
       a.c1, a.c2
  FROM t1 a
 WHERE NOT EXISTS (SELECT 1
                     FROM t2 x
                    WHERE x.c1 = a.c1
                      AND LNNVL (x.c2 != a.c2));
