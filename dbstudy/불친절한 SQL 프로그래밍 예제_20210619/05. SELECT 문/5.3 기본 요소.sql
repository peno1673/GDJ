--
SELECT '1!A' AS c1, '2''B' AS c2, '3"C' FROM DUAL;

--
SELECT q'[2'B]' AS c1, q'{[3C]}' AS c2 FROM DUAL;

--
SELECT 'Department' AS c1, deptno FROM dept;

--
SELECT * FROM DUAL;

--
SELECT 1 AS c1, -2 AS c2, 3.4 AS c3, -5.6 AS c4, 1.2E2 AS c5, -3.4E-2 AS c6 FROM DUAL;

--
COL c1 FOR     9.99
COL c2 FOR  0999.99
COL c3 FOR   999.99
COL c4 FOR   990.990
COL c5 FOR 9,990.990

--
SELECT  123.456 AS c1, 123.456 AS c2
     ,    0.456 AS c3,   0.456 AS c4
     , 1200     AS c5
  FROM DUAL;

--
COL c1 FOR A5
COL c2 FOR A5

--
SELECT 'ABC' AS c1, 'ABCDEF' AS c2 FROM DUAL;

--
CL COL

--
ALTER SESSION SET NLS_DATE_FORMAT         = "YYYY-MM-DD HH24:MI:SS";
ALTER SESSION SET NLS_TIMESTAMP_FORMAT    = "YYYY-MM-DD HH24:MI:SS.FF";
ALTER SESSION SET NLS_TIMESTAMP_TZ_FORMAT = "YYYY-MM-DD HH24:MI:SS.FF TZH:TZM";

--
SELECT DATE '2050-01-01' AS c1
     , TO_DATE ('2050-01-01 23:59:59', 'YYYY-MM-DD HH24:MI:SS') AS c2
  FROM DUAL;

--
SELECT TIMESTAMP '2050-01-01 23:59:59.999999999' AS c1 FROM DUAL;

--
SELECT TIMESTAMP '2050-01-01 23:59:59.999999999 +09:00' AS c1 FROM DUAL;

--
SELECT INTERVAL '99'    YEAR          AS c1
     , INTERVAL '99'    MONTH         AS c2
     , INTERVAL '99-11' YEAR TO MONTH AS c3
  FROM DUAL;

--
SELECT INTERVAL '99'                   DAY                 AS c1
     , INTERVAL '863999.999999999'     SECOND(1,9)         AS c2
     , INTERVAL '9 23:59:59.999999999' DAY(1) TO SECOND(9) AS c3
     , INTERVAL '239:59'               HOUR(1) TO MINUTE   AS c4
  FROM DUAL;

--
SELECT NULL AS c1, '' AS c2 FROM DUAL;

--
SELECT 1 + 2 - 3 * 4 / 5 AS c1, 1 + 2 - ((3 * 4) / 5) AS c2 FROM DUAL;

--
SELECT 1 / 0 FROM DUAL;

--
SELECT DATE '2050-01-31' + 31                  AS c1
     , DATE '2050-01-31' + (1 / 24 / 60 / 60)  AS c2
     , DATE '2050-01-31' + INTERVAL '1' SECOND AS c3
  FROM DUAL;

--
SELECT TIMESTAMP '2050-01-31 23:59:59.999999999' + 31                AS c1
     , TIMESTAMP '2050-01-31 23:59:59.999999999' + INTERVAL '31' DAY AS c2
  FROM DUAL;

--
SELECT DATE '2050-01-31' + INTERVAL '1' MONTH AS c1 FROM DUAL;

--
SELECT ADD_MONTHS (DATE '2050-01-31', 1) AS c1 FROM DUAL;

--
SELECT DATE '2050-01-02' - DATE '2050-01-01' AS c1
     , TIMESTAMP '2050-01-02 00:00:00' - TIMESTAMP '2050-01-01 00:00:00' AS c2
     , INTERVAL '2' DAY - INTERVAL '1' DAY AS c3
  FROM DUAL;

--
SELECT 1 + NULL AS c1
     , DATE '2050-01-01' + NULL AS c2
     , TIMESTAMP '2050-01-01 00:00:00' + NULL AS c3
  FROM DUAL;

--
SELECT 1 || NULL || 'A' AS c1 FROM DUAL;

--
SELECT '$' || 1 + 2 AS c1 FROM DUAL;

SELECT 1 + 2 || '$' AS c1 FROM DUAL;

--
SELECT '$' || (1 + 2) AS c1 FROM DUAL;

--
SELECT deptno
     , CASE deptno WHEN 10 THEN 1 WHEN 20 THEN 2 ELSE 9 END AS c1
  FROM dept;

--
SELECT deptno
     , CASE deptno WHEN 10 THEN 1 WHEN 20 THEN 2 END AS c1
  FROM dept;

--
SELECT CASE deptno WHEN '10' THEN 1 WHEN 20 THEN 2 END AS c1 FROM dept;

--
SELECT CASE deptno WHEN 10 THEN '1' WHEN 20 THEN 2 END AS c1 FROM dept;

--
SELECT deptno
     , CASE
           WHEN deptno BETWEEN 10 AND 20 THEN 1
           WHEN deptno BETWEEN 20 AND 30 THEN 2
           ELSE 9
       END AS c1
  FROM dept;

--
SELECT deptno
     , CASE
           WHEN deptno >= 10 THEN 1
           WHEN deptno >= 20 THEN 2
       END AS c1
  FROM dept;

--
SELECT deptno, ROWID AS c1 FROM dept;

--
SELECT /* ????????? ???????? */
       empno    -- ????????? , ename -- ????????
       /*
     , job      -- ????????????
     , hiredate -- ????????????????????
       */
  FROM emp;

--
SELECT name, inverse, version FROM v$sql_hint;
