--
SELECT NVL (1, 2) AS c1, NVL (NULL, 2) AS c2 FROM DUAL;

--
SELECT ename, sal, comm, sal + comm AS c1, sal + NVL (comm, 0) AS c2 FROM emp;

--
SELECT NVL2 (1, 2, 3) AS c1, NVL2 (NULL, 2, 3) AS c2 FROM DUAL;

--
SELECT ename, sal, comm, sal + (sal * NVL2 (comm, 0.1, 0.2)) AS c1 FROM emp;

--
SELECT COALESCE (1, 2, 3)       AS c1, COALESCE (NULL, 2, 3) AS c2
     , COALESCE (NULL, NULL, 3) AS c3
  FROM DUAL;

--
SELECT NVL (1, 1 / 0) AS c1 FROM DUAL;

SELECT COALESCE (1, 1 / 0) AS c1 FROM DUAL;

--
SELECT NVL2 (1, 2, 1 / 0) AS c1 FROM DUAL;

SELECT DECODE (1, NULL, 1 / 0, 2) AS c1 FROM DUAL;

SELECT CASE WHEN 1 IS NULL THEN 1 / 0 ELSE 2 END AS c1 FROM DUAL;

--
SELECT NULLIF (1, 1) AS c1, NULLIF (1, 2) AS c2 FROM DUAL;

--
SELECT ename, sal, comm
     , sal /      NULLIF (comm, 0)     AS c1
     , sal / NVL (NULLIF (comm, 0), 1) AS c2
  FROM emp;

--
SELECT ename, comm, '$' || comm AS C1, NULLIF ('$' || comm, '$') AS C2 FROM emp;
