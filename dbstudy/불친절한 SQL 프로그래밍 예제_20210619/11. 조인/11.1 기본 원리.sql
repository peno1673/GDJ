--
DROP TABLE t1 PURGE;
DROP TABLE t2 PURGE;
DROP TABLE t3 PURGE;

CREATE TABLE t1 (c1 NUMBER, CONSTRAINT t1_pk PRIMARY KEY (c1));
CREATE TABLE t2 (c1 NUMBER, CONSTRAINT t2_pk PRIMARY KEY (c1));
CREATE TABLE t3 (c1 NUMBER, CONSTRAINT t3_pk PRIMARY KEY (c1));

INSERT INTO t1 VALUES (1);
INSERT INTO t1 VALUES (2);
INSERT INTO t1 VALUES (3);
INSERT INTO t2 VALUES (1);
INSERT INTO t2 VALUES (2);
INSERT INTO t3 VALUES (1);
INSERT INTO t3 VALUES (3);
COMMIT;

--
SELECT a.c1 AS a, b.c1 AS b FROM t1 a, t2 b ORDER BY 1, 2;

--
SELECT   a.c1 AS a, b.c1 AS b
    FROM t1 a, t2 b
   WHERE b.c1 = a.c1 -- 조건
ORDER BY 1, 2;

--
SELECT   a.c1 AS a, b.c1 AS b, c.c1 AS c
    FROM t1 a, t2 b, t3 c
   WHERE b.c1 = a.c1 -- 조건1
     AND c.c1 = b.c1 -- 조건2
ORDER BY 1, 2;

--
SELECT   a.c1 AS a, b.c1 AS b
    FROM t1 a, t2 b
   WHERE b.c1 >= a.c1 -- 조건
ORDER BY 1, 2;

--
DROP TABLE t1 PURGE;
DROP TABLE t2 PURGE;

CREATE TABLE t1 (c1 NUMBER NOT NULL, c2 NUMBER, c3 NUMBER);
CREATE TABLE t2 (c1 NUMBER NOT NULL, c2 NUMBER, c3 NUMBER);

INSERT INTO t1 VALUES (1, 1   , 1   );
INSERT INTO t1 VALUES (2, 2   , NULL);
INSERT INTO t1 VALUES (3, 3   , NULL);
INSERT INTO t1 VALUES (4, NULL, NULL);
INSERT INTO t2 VALUES (1, 1   , 1   );
INSERT INTO t2 VALUES (2, 2   , NULL);
INSERT INTO t2 VALUES (3, NULL, 3   );
INSERT INTO t2 VALUES (4, NULL, NULL);
COMMIT;

--
SELECT a.c1 AS ac1, a.c2 AS ac2, a.c3 AS ac3, b.c1 AS bc1, b.c2 AS bc2, b.c3 AS bc3
  FROM t1 a, t2 b
 WHERE b.c1 = a.c1
   AND b.c2 = a.c2
   AND b.c3 = a.c3;

--
SELECT a.c1 AS ac1, a.c2 AS ac2, a.c3 AS ac3, b.c1 AS bc1, b.c2 AS bc2, b.c3 AS bc3
  FROM t1 a,  t2 b
 WHERE b.c1 = a.c1
   AND NVL (b.c2, -1) = NVL (a.c2, -1)
   AND NVL (b.c3, -1) = NVL (a.c3, -1);

--
SELECT a.c1 AS ac1, a.c2 AS ac2, a.c3 AS ac3, b.c1 AS bc1, b.c2 AS bc2, b.c3 AS bc3
  FROM t1 a, t2 b
 WHERE b.c1 = a.c1
   AND ((b.c2 = a.c2) OR (b.c2 IS NULL AND a.c2 IS NULL))
   AND ((b.c3 = a.c3) OR (b.c3 IS NULL AND a.c3 IS NULL));

--
SELECT a.c1 AS ac1, a.c2 AS ac2, a.c3 AS ac3, b.c1 AS bc1, b.c2 AS bc2, b.c3 AS bc3
  FROM t1 a, t2 b
 WHERE b.c1 = a.c1
   AND SYS_OP_MAP_NONNULL (b.c2) = SYS_OP_MAP_NONNULL (a.c2)
   AND SYS_OP_MAP_NONNULL (b.c3) = SYS_OP_MAP_NONNULL (a.c3);

--
SELECT a.c1 AS ac1, a.c2 AS ac2, a.c3 AS ac3, b.c1 AS bc1, b.c2 AS bc2, b.c3 AS bc3
  FROM t1 a, t2 b
 WHERE b.c1 || b.c2 || b.c3 = a.c1 || a.c2 || a.c3;

--
SELECT a.c1 AS ac1, a.c2 AS ac2, a.c3 AS ac3, b.c1 AS bc1, b.c2 AS bc2, b.c3 AS bc3
  FROM t1 a, t2 b
 WHERE b.c1 || '!' || b.c2 || '!' || b.c3 = a.c1 || '!' || a.c2 || '!' || a.c3;

--
DROP TABLE t1 PURGE;
DROP TABLE t2 PURGE;
DROP TABLE t3 PURGE;
DROP TABLE t4 PURGE;

CREATE TABLE t1 (c1 NUMBER, c2 NUMBER);
CREATE TABLE t2 (c1 NUMBER);
CREATE TABLE t3 (c1 NUMBER);
CREATE TABLE t4 (c1 NUMBER);

INSERT INTO t1 VALUES (1, 1);
INSERT INTO t1 VALUES (2, 2);
INSERT INTO t1 VALUES (3, 3);
INSERT INTO t2 VALUES (1);
INSERT INTO t2 VALUES (2);
INSERT INTO t2 VALUES (4);
INSERT INTO t3 VALUES (1);
INSERT INTO t3 VALUES (2);
INSERT INTO t3 VALUES (3);
INSERT INTO t4 VALUES (1);
INSERT INTO t4 VALUES (3);
INSERT INTO t4 VALUES (4);
COMMIT;

--
SELECT a.c1 AS a, b.c1 AS b FROM t1 a, t2 b WHERE b.c1(+) = a.c1 ORDER BY 1;

--
SELECT a.c1 AS a, b.c1 AS b FROM t1 a, t2 b WHERE b.c1 = a.c1(+) ORDER BY 1;

--
SELECT   a.c1 AS a, b.c1 AS b
    FROM t1 a, t2 b
   WHERE a.c1 > 1       -- 조건1
     AND b.c1(+) = a.c1 -- 조건2
ORDER BY 1;

--
SELECT   a.c1 AS a, b.c1 AS b
    FROM t1 a, t2 b
   WHERE b.c1(+) = a.c1 -- 조건1
     AND b.c1 > 1       -- 조건2
ORDER BY 1;

--
SELECT   a.c1 AS a, b.c1 AS b
    FROM t1 a, t2 b
   WHERE b.c1(+) = a.c1 -- 조건1
     AND b.c1(+) > 1    -- 조건2
ORDER BY 1;

--
SELECT   a.c1 AS a, b.c1 AS b
    FROM t1 a, t2 b
   WHERE b.c1(+) = a.c1 -- 조건1
     AND b.c1 IS NULL   -- 조건2
ORDER BY 1;

--
SELECT   a.c1 AS a, b.c1 AS b, c.c1 AS c
    FROM t1 a, t2 b, t3 c
   WHERE b.c1(+) = a.c1 -- 조건1
     AND c.c1(+) = b.c1 -- 조건2
ORDER BY 1;

--
SELECT   a.c1 AS a, b.c1 AS b, c.c1 AS c
    FROM t1 a, t2 b, t3 c
   WHERE b.c1(+) = a.c1 -- 조건1
     AND c.c1(+) = a.c1 -- 조건2
ORDER BY 1;

--
SELECT   a.c1 AS a, b.c1 AS b, c.c1 AS c, d.c1 AS d
    FROM t1 a, t2 b, t3 c, t4 d
   WHERE b.c1(+) = a.c1
     AND c.c1(+) = b.c1
     AND d.c1(+) = c.c1
ORDER BY 1;

--
SELECT   a.c1 AS a, b.c1 AS b, c.c1 AS c, d.c1 AS d
    FROM t1 a, t2 b, t3 c, t4 d
   WHERE b.c1(+) = a.c1 -- 조건1
     AND c.c1    = b.c1 -- 조건2
     AND d.c1(+) = c.c1 -- 조건3
ORDER BY 1;

--
SELECT   a.c1 AS a, b.c1 AS b, c.c1 AS c, d.c1 AS d
    FROM t1 a, t2 b, t3 c, t4 d
   WHERE b.c1(+) = a.c1 -- 조건1
     AND c.c1(+) = b.c1 -- 조건2
     AND d.c1    = c.c1 -- 조건3
ORDER BY 1;

--
SELECT   a.c1 AS a, b.c1 AS b
    FROM t1 a, t2 b
   WHERE b.c1(+) = a.c1
     AND b.c1(+) IN (1, 4)
ORDER BY 1;

--
SELECT   a.c1 AS a, b.c1 AS b
    FROM t1 a, t2 b
   WHERE b.c1(+) = a.c1    -- 조건1
     AND b.c1(+) IN (1, 4) -- 조건2
ORDER BY 1;

--
SELECT * FROM t1 a, t2 b WHERE b.c1(+) IN (a.c1, a.c2);

--
SELECT   a.c1 AS a, b.c1 AS b, c.c1 AS c
    FROM t1 a, t2 b, t3 c
   WHERE b.c1(+) = a.c1
     AND c.c1 = b.c1(+)
ORDER BY 1, 2, 3;

--
SELECT   a.c1 AS a, b.c1 AS b, c.c1 AS c
    FROM t1 a, t2 b, t3 c
   WHERE b.c1(+) = a.c1
     AND c.c1 = b.c1(+)
ORDER BY 1, 2, 3;

--
DROP TABLE t1 CASCADE CONSTRAINTS PURGE;
DROP TABLE t2 CASCADE CONSTRAINTS PURGE;

CREATE TABLE t1 (c1 NUMBER, CONSTRAINT t1_pk PRIMARY KEY (c1));
CREATE TABLE t2 (c1 NUMBER, c2 NUMBER, CONSTRAINT t2_pk PRIMARY KEY (c1, c2));
ALTER TABLE t2 ADD CONSTRAINT t2_f1 FOREIGN KEY (c1) REFERENCES t1 (c1);

INSERT INTO t1 VALUES (1);
INSERT INTO t1 VALUES (2);
INSERT INTO t1 VALUES (3);
INSERT INTO t2 VALUES (1, 1);
INSERT INTO t2 VALUES (2, 1);
INSERT INTO t2 VALUES (2, 2);
COMMIT;

--
SELECT   a.c1 AS a1, b.c1 AS b1, b.c2 AS b2
    FROM t1 a, t2 b
   WHERE b.c1 = a.c1 -- 조건
ORDER BY 1, 2, 3;

--
SELECT   b.c1 AS b1, b.c2 AS b2, a.c1 AS a1
    FROM t2 b, t1 a
   WHERE a.c1 = b.c1
ORDER BY 1, 2, 3;

--
SELECT   a.c1 AS a, b.c1 AS b1, b.c2 AS b2
    FROM t1 a, t2 b
   WHERE b.c1 = a.c1 -- 조건1
     AND b.c2 = 1    -- 조건2
ORDER BY 1, 2, 3;

--
SELECT   b.c1 AS b1, b.c1 AS b2, a.c1 AS a1
    FROM t2 b, t1 a
   WHERE a.c1 > b.c1
ORDER BY 1, 2, 3;
