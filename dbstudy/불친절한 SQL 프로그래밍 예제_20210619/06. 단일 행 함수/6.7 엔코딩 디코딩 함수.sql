--
SELECT DECODE (1, 1, 'A', 2, 'B', 'C') AS c1
     , DECODE (2, 1, 'A', 2, 'B', 'C') AS c2
     , DECODE (3, 1, 'A', 2, 'B', 'C') AS c3
  FROM DUAL;

--
SELECT DECODE ('A', 1, 2) AS c1 FROM DUAL;

--
SELECT DECODE (1, 2, 1, 'A') AS c1 FROM DUAL;

--
SELECT DECODE (2, 1, NULL            , 9) AS c1
     , DECODE (2, 1, TO_NUMBER (NULL), 9) AS c2
  FROM DUAL;

--
SELECT DECODE (1, NULL, 'A', 'B') AS c1, NVL2 (1, 'B', 'A') AS c2 FROM DUAL;

--
SELECT DECODE (deptno, 30, DECODE (dname, 'SALES', DECODE (loc, 'CHICAGO', 'Y'))) AS c1
  FROM dept;

--
SELECT DECODE (deptno || dname || loc, '30SALESCHICAGO', 'Y') AS c1 FROM dept;

--
SELECT CASE WHEN deptno = 30 AND dname = 'SALES' AND loc = 'CHICAGO' THEN 'Y' END AS c1
  FROM dept;

--
SELECT DUMP ('ABC', 16) AS c1, DUMP ('ABC', 1016, 2, 2) AS c2 FROM DUAL;

--
SELECT VSIZE (12345)        AS c1, VSIZE ('ABC')                AS c2
     , VSIZE ('°¡³ª´Ù')     AS c3, VSIZE (SYSDATE)              AS c4
     , VSIZE (SYSTIMESTAMP) AS c5, VSIZE (TRUNC (SYSTIMESTAMP)) AS c6
  FROM DUAL;

--
SELECT ORA_HASH (123)           AS c1, ORA_HASH (123, 100) AS c2
     , ORA_HASH (123, 100, 100) AS c3
  FROM DUAL;

--
SELECT STANDARD_HASH (123, 'SHA256') AS c1 FROM DUAL;
