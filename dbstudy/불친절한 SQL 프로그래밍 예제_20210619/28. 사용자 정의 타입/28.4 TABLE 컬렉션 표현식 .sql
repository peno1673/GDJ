--
SELECT * FROM TABLE (tnt1 (1, 2, 3));

--
WITH w1 AS (SELECT tnt2 (trc1 (1, 2), trc1 (3, 4), trc1 (5, 6)) AS c1 FROM DUAL)
SELECT b.* FROM w1 a, TABLE (a.c1) b;

--
WITH w1 AS (SELECT tnt3 (tnt2 (trc1 (1, 2), trc1 (3, 4))
                       , tnt2 (trc1 (5, 6), trc1 (7, 8))) AS c1
              FROM DUAL)
   , w2 AS (SELECT b.COLUMN_VALUE AS c1 FROM w1 a, TABLE (a.c1) b)
SELECT b.* FROM w2 a, TABLE (a.c1) b;

--
SELECT a.c1, b.COLUMN_VALUE AS c2 FROM t1 a, TABLE (a.c2) b;

--
SELECT a.c1, b.COLUMN_VALUE AS c2 FROM t1 a, TABLE (a.c2) (+) b;
