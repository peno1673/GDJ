--
SELECT a.c1 AS a, b.c1 AS b FROM t1 a NATURAL JOIN t2 a;

--
SELECT * FROM t1 JOIN t2 USING (c1);

--
SELECT a.c1 AS a, b.c1 AS b
  FROM t1 a
 CROSS
  JOIN t2 b;

SELECT a.c1 AS a, b.c1 AS b
  FROM t1 a
     , t2 b;

--
SELECT a.c1 AS a, b.c1 AS b
  FROM t1 a
 INNER
  JOIN t2 b
    ON b.c1 = a.c1;

SELECT a.c1 AS a, b.c1 AS b
  FROM t1 a
     , t2 b
 WHERE b.c1 = a.c1;

--
SELECT a.c1 AS a, b.c1 AS b
  FROM t1 a
  JOIN t2 b
    ON b.c1 = a.c1
  JOIN t3 c
    ON c.c1 = b.c1;

SELECT a.c1 AS a, b.c1 AS b
  FROM t1 a
     , t2 b
     , t3 c
 WHERE b.c1 = a.c1
   AND c.c1 = b.c1;

--
SELECT a.c1 AS a, b.c1 AS b
  FROM t1 a
  JOIN t2 b
    ON b.c1 = a.c1
 WHERE b.c1 > 1;

SELECT a.c1 AS a, b.c1 AS b
  FROM t1 a
     , t2 b
 WHERE b.c1 = a.c1
   AND b.c1 > 1;

--
SELECT a.c1 AS a, b.c1 AS b
  FROM t1 a
  JOIN t2 b
    ON b.c1 = a.c1
 WHERE b.c2 > 1;

SELECT a.c1 AS a, b.c1 AS b
  FROM t1 a
  JOIN t2 b
    ON b.c1 = a.c1
   AND b.c2 > 1;

--
SELECT a.c1 AS a, b.c1 AS b
  FROM t1 a
  LEFT OUTER
  JOIN t2 b
    ON b.c1 = a.c1;

SELECT a.c1 AS a, b.c1 AS b
  FROM t1 a
     , t2 b
 WHERE b.c1(+) = a.c1;

--
SELECT a.c1 AS a, b.c1 AS b
  FROM t1 a
 RIGHT OUTER
  JOIN t2 b
    ON b.c1 = a.c1;

SELECT a.c1 AS a, b.c1 AS b
  FROM t1 a
     , t2 b
 WHERE b.c1 = a.c1(+);

--
SELECT a.c1 AS a, b.c1 AS b
  FROM t1 a
  LEFT OUTER
  JOIN t2 b
    ON b.c1 = a.c1
 WHERE a.c1 > 1;

SELECT a.c1 AS a, b.c1 AS b
  FROM t1 a
     , t2 b
 WHERE a.c1 > 1
   AND b.c1(+) = a.c1;

--
SELECT   a.c1 AS a, b.c1 AS b
    FROM t1 a
    LEFT OUTER
    JOIN t2 b
      ON a.c1 > 1
     AND b.c1 = a.c1
ORDER BY 1;

SELECT   a.c1 AS a, b.c1 AS b
    FROM t1 a, t2 b
   WHERE a.c1 > CASE WHEN b.c1(+) IS NOT NULL THEN 1 ELSE 1 END
     AND b.c1(+) = a.c1
ORDER BY 1;

--
SELECT a.c1 AS a, b.c1 AS b
  FROM t1 a
  LEFT OUTER
  JOIN t2 b
    ON b.c1 = a.c1
   AND b.c1 > 1;

SELECT a.c1 AS a, b.c1 AS b
  FROM t1 a
     , t2 b
 WHERE b.c1(+) = a.c1
   AND b.c1(+) > 1;

--
SELECT a.c1 AS a, b.c1 AS b
  FROM t1 a
  LEFT OUTER
  JOIN t2 b
    ON b.c1 = a.c1
 WHERE b.c1 > 1;

SELECT a.c1 AS a, b.c1 AS b
  FROM t1 a
     , t2 b
 WHERE b.c1(+) = a.c1
   AND b.c1 > 1;

--
SELECT a.c1 AS a, b.c1 AS b
     , c.c1 AS c, d.c1 AS d
  FROM t1 a
  LEFT OUTER
  JOIN t2 b
    ON b.c1 = a.c1
  LEFT OUTER
  JOIN t3 c
    ON c.c1 = b.c1
  JOIN t4 d
    ON d.c1 = c.c1;

SELECT a.c1 AS a, b.c1 AS b
     , c.c1 AS c, d.c1 AS d
  FROM t1 a
     , t2 b
     , t3 c
     , t4 d
 WHERE b.c1(+) = a.c1
   AND c.c1(+) = b.c1
   AND d.c1 = c.c1;

--
SELECT   a.c1 AS a, b.c1 AS b, c.c1 AS c
    FROM t1 a
    LEFT OUTER
    JOIN t2 b
      ON b.c1 = a.c1 -- 조건1
   RIGHT OUTER
    JOIN t3 c
      ON c.c1 = b.c1 -- 조건2
ORDER BY 3;

--
SELECT   a.c1 AS a, b.c1 AS b, c.c1 AS c, d.c1 AS d
    FROM (t1 a LEFT OUTER JOIN t2 b ON b.c1 = a.c1)
    LEFT OUTER
    JOIN (t3 c LEFT OUTER JOIN t4 d ON c.c1 = d.c1)
      ON d.c1 = a.c1
ORDER BY 1;

--
SELECT   a.c1 AS a, b.c1 AS b
    FROM t1 a
    FULL OUTER
    JOIN t2 b
      ON b.c1 = a.c1 -- 조건
ORDER BY 1, 2;

--
SELECT *
  FROM t1 a
 INNER
  JOIN t2 b
    ON b.c1 = a.c1;

SELECT *
  FROM t1 a
     , t2 b
 WHERE b.c1 = a.c1;

--
SELECT *
  FROM t1 a
  LEFT OUTER
  JOIN t2 b
    ON b.c1 = a.c1;

SELECT *
  FROM t1 a
     , t2 b
 WHERE b.c1(+) = a.c1;

--
SELECT *
  FROM t1 a
  LEFT OUTER
  JOIN t2 b
    ON b.c1 = a.c1
 WHERE b.c1 IS NULL;

SELECT *
  FROM t1 a
     , t2 b
 WHERE b.c1(+) = a.c1
   AND b.c1 IS NULL;

--
SELECT *
  FROM t1 a
 RIGHT OUTER
  JOIN t2 b
    ON b.c1 = a.c1;

SELECT *
  FROM t1 a
     , t2 b
 WHERE b.c1 = a.c1(+);

--
SELECT *
  FROM t1 a
 RIGHT OUTER
  JOIN t2 b
    ON b.c1 = a.c1
 WHERE a.c1 IS NULL;

SELECT *
  FROM t1 a
     , t2 b
 WHERE b.c1 = a.c1(+)
   AND a.c1 IS NULL;

--
SELECT *
  FROM t1 a
  FULL OUTER
  JOIN t2 b
    ON b.c1 = a.c1;

--
SELECT *
  FROM t1 a
  FULL OUTER
  JOIN t2 b
    ON b.c1 = a.c1
 WHERE (   a.c1 IS NULL
        OR b.c1 IS NULL);
