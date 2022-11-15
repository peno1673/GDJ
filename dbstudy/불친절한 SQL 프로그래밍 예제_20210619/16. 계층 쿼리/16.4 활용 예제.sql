--
SELECT LEVEL AS lv FROM DUAL CONNECT BY LEVEL <= 100;

--
SELECT ROWNUM AS rn FROM XMLTABLE ('1 to 100');

--
DROP TABLE t1 PURGE;

CREATE TABLE t1 (
    ym    VARCHAR2(6) -- 연월
  , bf    VARCHAR2(4) -- 변경 전 코드
  , af    VARCHAR2(4) -- 변경 후 코드
);

INSERT INTO t1 VALUES ('205001', 'A', 'B');
INSERT INTO t1 VALUES ('205001', 'I', 'J');
INSERT INTO t1 VALUES ('205001', 'X', 'Y');
INSERT INTO t1 VALUES ('205004', 'B', 'C');
INSERT INTO t1 VALUES ('205004', 'J', 'K');
INSERT INTO t1 VALUES ('205007', 'C', 'D');
COMMIT;

--
SELECT   bf, af, ym
    FROM (SELECT     ym, CONNECT_BY_ROOT bf AS bf, af, CONNECT_BY_ISLEAF AS lf
                FROM t1
          CONNECT BY bf = PRIOR af)
   WHERE lf = 1
ORDER BY 1;

--
SELECT   bf, cd, ym, cn
    FROM (SELECT     CONNECT_BY_ROOT bf AS bf
                   , SUBSTR (SYS_CONNECT_BY_PATH (af, ','), 2) AS cd
                   , SUBSTR (SYS_CONNECT_BY_PATH (ym, ','), 2) AS ym
                   , LEVEL AS cn
                   , CONNECT_BY_ISLEAF AS lf
                FROM t1 a
          START WITH NOT EXISTS (SELECT 1 FROM t1 x WHERE x.af = a.bf)
          CONNECT BY bf = PRIOR af)
   WHERE lf = 1
ORDER BY 1;

--
SELECT   af, cd, ym, cn
    FROM (SELECT     CONNECT_BY_ROOT af AS af
                   , SUBSTR (SYS_CONNECT_BY_PATH (bf, ','), 2) AS cd
                   , SUBSTR (SYS_CONNECT_BY_PATH (ym, ','), 2) AS ym
                   , LEVEL AS cn
                   , CONNECT_BY_ISLEAF AS lf
                FROM t1 a
          START WITH NOT EXISTS (SELECT 1 FROM t1 x WHERE x.bf = a.af)
          CONNECT BY af = PRIOR bf)
   WHERE lf = 1
ORDER BY 1;

--
DROP TABLE t1 PURGE;

CREATE TABLE t1 (
    cd VARCHAR2(1) -- 계정
  , c1 VARCHAR2(1) -- 계산계정1
  , c2 VARCHAR2(1) -- 계산계정2
  , c3 VARCHAR2(1) -- 계산계정3
  , c4 VARCHAR2(1) -- 계산계정4
);

INSERT INTO t1 VALUES ('A', 'B', 'C' , 'D' , 'E' );
INSERT INTO t1 VALUES ('B', 'F', 'G' , 'H' , NULL);
INSERT INTO t1 VALUES ('C', 'I', 'J' , NULL, NULL);
INSERT INTO t1 VALUES ('D', 'K', NULL, NULL, NULL);
INSERT INTO t1 VALUES ('E', 'B', 'C' , NULL, NULL);
INSERT INTO t1 VALUES ('F', 'C', 'D' , NULL, NULL);
COMMIT;

--
SELECT     cd, MAX (LEVEL) AS lv
      FROM t1 a
START WITH NOT EXISTS (SELECT 1 FROM t1 x WHERE x.cd IN (a.c1, a.c2, a.c3, a.c4))
CONNECT BY PRIOR cd IN (c1, c2, c3, c4)
  GROUP BY cd
  ORDER BY 2, 1;

--
WITH w1 (empno, ename, mgr, sal, lv, c1) AS (
SELECT empno, ename, mgr, sal, 1 AS lv, sal AS c1
  FROM emp
 WHERE mgr IS NULL
 UNION ALL
SELECT c.empno, c.ename, c.mgr, c.sal, p.lv + 1 AS lv, p.c1 + c.sal AS c1
  FROM w1 p, emp c
 WHERE c.mgr = p.empno)
SEARCH DEPTH FIRST BY empno SET so
SELECT   lv, empno, LPAD (' ', lv - 1, ' ') || ename AS ename, mgr, sal, c1
    FROM w1
ORDER BY so;

--
SELECT     LEVEL AS lv, empno, LPAD (' ', LEVEL - 1, ' ') || ename AS ename, mgr
         , sal, sal + PRIOR sal AS c1
      FROM emp
START WITH mgr IS NULL
CONNECT BY mgr = PRIOR empno;
