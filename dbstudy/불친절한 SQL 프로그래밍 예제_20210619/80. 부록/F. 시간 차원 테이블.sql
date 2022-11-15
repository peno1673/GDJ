--
DROP TABLE td PURGE;

CREATE TABLE td (
    cyl_cd   VARCHAR(1)  -- 주기코드
  , std_dt   VARCHAR(8)  -- 기준일자
  , bgn_dt   VARCHAR(8)  -- 시작일자
  , end_dt   VARCHAR(8)  -- 종료일자
  , std_dt_w VARCHAR(6)  -- 기준일자(주간)
  , std_dt_m VARCHAR(6)  -- 기준일자(월간)
  , std_dt_q VARCHAR(6)  -- 기준일자(분기)
  , std_dt_h VARCHAR(6)  -- 기준일자(반기)
  , std_dt_y VARCHAR(4)  -- 기준일자(연간)
  , out_dt   VARCHAR(10) -- 출력일자
  , CONSTRAINT td_pk PRIMARY KEY (cyl_cd, std_dt)
  , CONSTRAINT td_c1 CHECK (bgn_dt <= end_dt))
ORGANIZATION INDEX
PCTFREE 0
PARTITION BY LIST (cyl_cd) (
    PARTITION p_d VALUES ('D')
  , PARTITION p_w VALUES ('W')
  , PARTITION p_m VALUES ('M')
  , PARTITION p_q VALUES ('Q')
  , PARTITION p_h VALUES ('H')
  , PARTITION p_y VALUES ('Y'));

CREATE UNIQUE INDEX td_u1 ON td (cyl_cd, end_dt, bgn_dt, std_dt) LOCAL PCTFREE 0;

--
INSERT INTO td
WITH w1 AS (
SELECT DATE '1950-01-01' AS bgn_dt
     , DATE '2051-01-01' AS end_dt
  FROM DUAL)
   , w1_d AS (
SELECT     'D' AS cyl_cd
         , TO_CHAR (bgn_dt + LEVEL - 1, 'YYYYMMDD') AS std_dt
         , TO_CHAR (bgn_dt + LEVEL - 1, 'YYYYMMDD') AS bgn_dt
         , TO_CHAR (bgn_dt + LEVEL - 1, 'YYYYMMDD') AS end_dt
         , TO_CHAR (bgn_dt + LEVEL - 1, 'IYYYIW') AS std_dt_w
         , TO_CHAR (bgn_dt + LEVEL - 1, 'YYYYMM') AS std_dt_m
         , TO_CHAR (bgn_dt + LEVEL - 1, 'YYYY')
           || LPAD (CEIL (TO_CHAR (bgn_dt + LEVEL - 1, 'MM') / 3) * 3, 2, '0')
           AS std_dt_q
         , TO_CHAR (bgn_dt + LEVEL - 1, 'YYYY')
           || LPAD (CEIL (TO_CHAR (bgn_dt + LEVEL - 1, 'MM') / 6) * 6, 2, '0')
           AS std_dt_h
         , TO_CHAR (bgn_dt + LEVEL - 1, 'YYYY') AS std_dt_y
         , TO_CHAR (bgn_dt + LEVEL - 1, 'YYYY-MM-DD') AS out_dt
      FROM w1
CONNECT BY LEVEL <= end_dt - bgn_dt)
   , w1_w AS (
SELECT   'W' AS cyl_cd
       , TO_CHAR (TO_DATE (std_dt, 'YYYYMMDD'), 'IYYYIW') AS std_dt
       , MIN (bgn_dt)   AS bgn_dt  , MAX (end_dt)   AS end_dt
       , MAX (std_dt_w) AS std_dt_w, MAX (std_dt_m) AS std_dt_m
       , MAX (std_dt_q) AS std_dt_q, MAX (std_dt_h) AS std_dt_h
       , MAX (std_dt_y) AS std_dt_y
       , TO_CHAR (TO_DATE (MAX (std_dt), 'YYYYMMDD'), 'IYYY-IW"W"') AS out_dt
    FROM w1_d
GROUP BY TO_CHAR (TO_DATE (std_dt, 'YYYYMMDD'), 'IYYYIW'))
   , w1_m AS (
SELECT   'M' AS cyl_cd
       , SUBSTR (std_dt, 1, 6) AS std_dt
       , MIN (bgn_dt)   AS bgn_dt  , MAX (end_dt)   AS end_dt
       , MAX (std_dt_w) AS std_dt_w, MAX (std_dt_m) AS std_dt_m
       , MAX (std_dt_q) AS std_dt_q, MAX (std_dt_h) AS std_dt_h
       , MAX (std_dt_y) AS std_dt_y
       , TO_CHAR (TO_DATE (MAX (std_dt), 'YYYYMMDD'), 'YYYY-MM') AS out_dt
    FROM w1_d
GROUP BY SUBSTR (std_dt, 1, 6))
   , w1_q AS (
SELECT   'Q' AS cyl_cd
       , MAX (SUBSTR (std_dt, 1, 6)) AS std_dt
       , MIN (bgn_dt)   AS bgn_dt  , MAX (end_dt)   AS end_dt
       , MAX (std_dt_w) AS std_dt_w, MAX (std_dt_m) AS std_dt_m
       , MAX (std_dt_q) AS std_dt_q, MAX (std_dt_h) AS std_dt_h
       , MAX (std_dt_y) AS std_dt_y
       , TO_CHAR (TO_DATE (MAX (std_dt), 'YYYYMM'), 'YYYY-Q"Q"') AS out_dt
    FROM w1_m
GROUP BY TO_CHAR (TO_DATE (std_dt, 'YYYYMM'), 'YYYYQ'))
   , w1_h AS (
SELECT   'H' AS cyl_cd
       , MAX (SUBSTR (std_dt, 1, 6)) AS std_dt
       , MIN (bgn_dt)   AS bgn_dt  , MAX (end_dt)   AS end_dt
       , MAX (std_dt_w) AS std_dt_w, MAX (std_dt_m) AS std_dt_m
       , MAX (std_dt_q) AS std_dt_q, MAX (std_dt_h) AS std_dt_h
       , MAX (std_dt_y) AS std_dt_y
  , SUBSTR (std_dt, 1, 4) || '-' || CEIL (SUBSTR (std_dt, 5, 2) / 6) || 'H' AS out_dt
    FROM w1_q
GROUP BY SUBSTR (std_dt, 1, 4)
       , CEIL (SUBSTR (std_dt, 5, 2) / 6))
   , w1_y AS (
SELECT   'Y' AS cyl_cd
       , SUBSTR (std_dt, 1, 4) AS std_dt
       , MIN (bgn_dt)   AS bgn_dt  , MAX (end_dt)   AS end_dt
       , MAX (std_dt_w) AS std_dt_w, MAX (std_dt_m) AS std_dt_m
       , MAX (std_dt_q) AS std_dt_q, MAX (std_dt_h) AS std_dt_h
       , MAX (std_dt_y) AS std_dt_y
       , SUBSTR (std_dt, 1, 4) AS out_dt
    FROM w1_h
GROUP BY SUBSTR (std_dt, 1, 4))
SELECT * FROM w1_d UNION ALL
SELECT * FROM w1_w UNION ALL
SELECT * FROM w1_m UNION ALL
SELECT * FROM w1_q UNION ALL
SELECT * FROM w1_h UNION ALL
SELECT * FROM w1_y
ORDER BY 1, 2;

COMMIT;

--
SELECT std_dt, bgn_dt, end_dt
     , std_dt_w, std_dt_m, std_dt_q, std_dt_h, std_dt_y, out_dt
  FROM td
 WHERE cyl_cd = 'D'
   AND std_dt BETWEEN '20500101' AND '20500104';

--
SELECT std_dt, bgn_dt, end_dt
     , std_dt_w, std_dt_m, std_dt_q, std_dt_h, std_dt_y, out_dt
  FROM td
 WHERE cyl_cd = 'W'
   AND std_dt BETWEEN '205001' AND '205004';

--
SELECT std_dt, bgn_dt, end_dt
     , std_dt_w, std_dt_m, std_dt_q, std_dt_h, std_dt_y, out_dt
  FROM td
 WHERE cyl_cd = 'M'
   AND std_dt BETWEEN '205001' AND '205004';

--
SELECT std_dt, bgn_dt, end_dt
     , std_dt_w, std_dt_m, std_dt_q, std_dt_h, std_dt_y, out_dt
  FROM td
 WHERE cyl_cd = 'Q'
   AND std_dt BETWEEN '205001' AND '205012';

--
SELECT std_dt, bgn_dt, end_dt
     , std_dt_w, std_dt_m, std_dt_q, std_dt_h, std_dt_y, out_dt
  FROM td
 WHERE cyl_cd = 'H'
   AND std_dt BETWEEN '204901' AND '205012';

--
SELECT std_dt, bgn_dt, end_dt
     , std_dt_w, std_dt_m, std_dt_q, std_dt_h, std_dt_y, out_dt
  FROM td
 WHERE cyl_cd = 'Y'
   AND std_dt BETWEEN '2047' AND '2050';

--
DROP TABLE t1 PURGE;

CREATE TABLE t1 (bgn_dt DATE, end_dt DATE, val NUMBER);

INSERT INTO t1 VALUES (DATE '2050-01-01', DATE '2050-01-10', 1);
INSERT INTO t1 VALUES (DATE '2050-01-11', DATE '2050-02-10', 2);
INSERT INTO t1 VALUES (DATE '2050-02-11', DATE '2050-04-10', 3);
COMMIT;

--
SELECT   GREATEST (a.bgn_dt, b.bgn_dt) AS bgn_dt
       , LEAST (a.end_dt, b.end_dt) AS end_dt
       , a.val
    FROM t1 a, td b
   WHERE b.cyl_cd = 'M'
     AND b.bgn_dt <= TO_CHAR (a.end_dt, 'YYYYMMDD')
     AND b.end_dt >= TO_CHAR (a.bgn_dt, 'YYYYMMDD')
ORDER BY 1;

--
DROP TABLE t1 PURGE;
DROP TABLE t2 PURGE;

CREATE TABLE t1 AS
WITH w1 AS (
SELECT     CHR (ASCII ('A') + LEVEL - 1) AS cd
      FROM DUAL
CONNECT BY LEVEL <= 2)
   , w2 AS (
SELECT     TO_CHAR (ADD_MONTHS (DATE '2050-01-01', LEVEL - 1), 'YYYYMM') AS std_dt
         , LEVEL * 100 AS val
      FROM DUAL
CONNECT BY LEVEL <= 12)
SELECT a.cd, b.std_dt, b.val
  FROM w1 a, w2 b;

CREATE TABLE t2 AS
SELECT a.cd, a.std_dt, a.val FROM t1 a WHERE MOD (a.val, 3) = 0;

DELETE FROM t1 WHERE std_dt IN ('205005', '205010');
DELETE FROM t2 WHERE std_dt = '205006';
COMMIT;

--
SELECT   b.cd
       , a.std_dt   AS std_dt_m, NVL (b.val, 0) AS val_m
       , a.std_dt_q AS std_dt_q, NVL (c.val, 0) AS val_q
    FROM td a
    LEFT OUTER
    JOIN t1 b PARTITION BY (b.cd)
      ON b.std_dt = a.std_dt
    LEFT OUTER
    JOIN t2 c
      ON c.cd = b.cd
     AND c.std_dt = a.std_dt_q
   WHERE a.cyl_cd = 'M'
     AND a.std_dt BETWEEN '205001' AND '205006'
ORDER BY 1, 2;
