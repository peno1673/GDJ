--
SELECT 'AB' || CHR (10) || ' C' AS c1 FROM DUAL;

--
SELECT LOWER ('abC') AS c1 FROM DUAL;

--
SELECT UPPER ('abC') AS c1 FROM DUAL;

--
SELECT INITCAP ('abC de') AS c1, INITCAP ('abC,de') AS c2 FROM DUAL;

--
SELECT LPAD ('AB', 3) AS c1, LPAD ('AB', 1) AS c2, LPAD ('AB', 5, '12') AS c3 FROM DUAL;

--
SELECT LPAD ('X', 4000, 'X') AS c1 FROM DUAL;

--
SELECT RPAD ('AB', 3) AS c1, RPAD ('AB', 1) AS c2, RPAD ('AB', 5, '12') AS c3 FROM DUAL;

--
SELECT RPAD (NULL, 2, 'X') AS c1 FROM DUAL;

--
SELECT LTRIM (' A ') AS c1, LTRIM ('ABC', 'BA') AS c2, LTRIM ('ABC', 'BC') AS c3 FROM DUAL;

--
SELECT RTRIM (' A ') AS c1, RTRIM ('ABC', 'BA') AS c2, RTRIM ('ABC', 'BC') AS c3 FROM DUAL;

--
SELECT RTRIM (LTRIM ('12A34', '0123456789'), '0123456789') AS c1 FROM DUAL;

--
SELECT TRIM ( LEADING 'A' FROM 'AAB ') AS c1, TRIM ( LEADING FROM 'AAB ') AS c2
     , TRIM (TRAILING 'B' FROM 'AAB ') AS c3, TRIM (TRAILING FROM 'AAB ') AS c4
     , TRIM (    BOTH 'A' FROM 'AAB ') AS c5, TRIM (    BOTH FROM 'AAB ') AS c6
     , TRIM (         'A' FROM 'AAB ') AS c7, TRIM (              'AAB ') AS c8
  FROM DUAL;

--
SELECT SUBSTR ('123456',  4) AS c1, SUBSTR ('123456',  4, 2) AS c2
     , SUBSTR ('123456', -4) AS c3, SUBSTR ('123456', -4, 2) AS c4
     , SUBSTR ('123456',  7) AS c5
  FROM DUAL;

--
SELECT SUBSTR ('가234', 4) AS c1, SUBSTRB ('가234', 4) AS c2 FROM DUAL;

--
SELECT REPLACE ('ABCABC', 'AB'       ) AS c1
     , REPLACE ('ABCABC', 'AB', '1'  ) AS c2
     , REPLACE ('ABCABC', 'AB', '123') AS c3
  FROM DUAL;

--
WITH w1 AS (SELECT 'A   B  C ' AS c1 FROM DUAL)
SELECT c1
     ,                   REPLACE (c1, '  ', ' !')              AS c2
     ,          REPLACE (REPLACE (c1, '  ', ' !'), '! ')       AS c3
     , REPLACE (REPLACE (REPLACE (c1, '  ', ' !'), '! '), '!') AS c4
     , REGEXP_REPLACE (c1, ' +', ' ')                          AS c5
  FROM w1;

--
SELECT TRANSLATE ('AAABBC', 'AB', '1'  ) AS c1
     , TRANSLATE ('AAABBC', 'AB', '1 ' ) AS c2
     , TRANSLATE ('AAABBC', 'AB', '123') AS c3
  FROM DUAL;

--
WITH w1 AS (SELECT 'A' AS c1 FROM DUAL UNION ALL SELECT 'B' AS c1 FROM DUAL)
SELECT c1, TRANSLATE (c1, 'AB', 'CD') AS c2 FROM w1;

--
WITH w1 AS (SELECT 'A1B2C3' AS c1 FROM DUAL)
SELECT c1
     , TRANSLATE (c1, '!1234567890', '!') AS c2
     , TRANSLATE (c1, '1234567890' || c1, '1234567890') AS c3
  FROM w1;

--
SELECT ASCII ('A') AS c1, ASCII ('BC') AS c2, CHR (ASCII ('A') + 1) AS c3 FROM DUAL;

--
SELECT INSTR ('ABABABAB', 'AB'       ) AS c1
     , INSTR ('ABABABAB', 'AC'       ) AS c2, INSTR ('ABABABAB', 'AB',  9   ) AS c3
     , INSTR ('ABABABAB', 'AB',  1, 2) AS c4, INSTR ('ABABABAB', 'AB',  3, 2) AS c5
     , INSTR ('ABABABAB', 'AB', -1, 2) AS c6, INSTR ('ABABABAB', 'AB', -3, 2) AS c7
  FROM DUAL;

--
WITH w1 AS (SELECT ',A,B,' AS c1 FROM DUAL)
SELECT c1
     , SUBSTR (c1, INSTR (c1, ',', 1, 1) + 1
                 , INSTR (c1, ',', 1, 2) - INSTR (c1, ',', 1, 1) - 1) AS c2 -- 1+1, 3-1-1
     , SUBSTR (c1, INSTR (c1, ',', 1, 2) + 1
                 , INSTR (c1, ',', 1, 3) - INSTR (c1, ',', 1, 2) - 1) AS c3 -- 3+1, 5-3-1
     , REGEXP_SUBSTR (c1, '[^,]+', 1, 1) AS c4
     , REGEXP_SUBSTR (c1, '[^,]+', 1, 2) AS c5
  FROM w1;

--
SELECT LENGTH ('AB') AS c1, LENGTH ('AB  ') AS c2 FROM DUAL;

--
SELECT LENGTH ('A가') AS c1, LENGTHB ('A가') AS c2 FROM DUAL;

--
WITH w1 AS (SELECT ',A,B,' AS c1 FROM DUAL)
SELECT c1
     , LENGTH (c1) - LENGTH (REPLACE (c1, ',')) AS c2
     , LENGTH (TRANSLATE (c1, ',' || c1, ','))  AS c3
     , REGEXP_COUNT (c1, ',')                   AS c4
  FROM w1;
