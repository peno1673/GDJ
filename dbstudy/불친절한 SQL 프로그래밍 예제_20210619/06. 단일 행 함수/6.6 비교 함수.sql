--
SELECT LEAST (1, 2, 3) AS c1, LEAST ('A', 'AB', 'ABC') AS c2, LEAST (1, NULL) AS c3 FROM DUAL;

--
SELECT GREATEST (1, 2, 3) AS c1, GREATEST ('A', 'AB', 'ABC') AS c2
     , GREATEST (1, NULL) AS c3
  FROM DUAL;

--
SELECT GREATEST (1, 'A') AS c1 FROM DUAL;
