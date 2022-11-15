--
SELECT c1, c2 FROM t1
UNION ALL
SELECT c1 FROM t2;

--
SELECT c1, c2 FROM t1
UNION ALL
SELECT c2, c1 FROM t2;

--
SELECT c1, c2 FROM t1 ORDER BY c1, c2
UNION ALL
SELECT c1, c2 FROM t2 ORDER BY c1, c2;

--
SELECT c1, c2 FROM t1 UNION ALL
SELECT c1, c2 FROM t2
ORDER BY c1, c2;

--
SELECT c1, c2 FROM (SELECT * FROM t1 ORDER BY c1, c2)
UNION ALL
SELECT c1, c2 FROM (SELECT * FROM t2 ORDER BY c1, c2);

--
SELECT c1, c2 FROM t1 MINUS
SELECT c1, c2 FROM t2 UNION ALL
SELECT c1, c2 FROM t2 MINUS
SELECT c1, c2 FROM t1;

--
(SELECT c1, c2 FROM t1 MINUS SELECT c1, c2 FROM t2) UNION ALL
(SELECT c1, c2 FROM t2 MINUS SELECT c1, c2 FROM t1);

--
SELECT * FROM (SELECT c1, c2 FROM t1 MINUS SELECT c1, c2 FROM t2) UNION ALL
SELECT * FROM (SELECT c1, c2 FROM t2 MINUS SELECT c1, c2 FROM t1);
