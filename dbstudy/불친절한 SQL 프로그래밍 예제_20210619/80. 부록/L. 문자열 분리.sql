--
DROP TABLE t1 PURGE;
CREATE TABLE t1 AS SELECT '1,2,3' AS c1 FROM DUAL;

--
SELECT SUBSTR (a.c1
             , INSTR (a.c1, ',', 1, b.lv) + 1
             , INSTR (a.c1, ',', 1, b.lv  + 1) - INSTR (a.c1, ',', 1, b.lv) - 1) AS c1
  FROM (SELECT /*+ NO_MERGE */
               ',' || c1 || ',' AS c1
             , LENGTH (c1) - LENGTH (REPLACE (c1, ',')) + 1 AS cn
          FROM t1) a
     , (SELECT LEVEL AS lv FROM DUAL CONNECT BY LEVEL <= 10) b
 WHERE b.lv <= a.cn;

--
SELECT REGEXP_SUBSTR (a.c1, '[^,]+', 1, b.lv) AS c1
  FROM (SELECT /*+ NO_MERGE */ a.*, REGEXP_COUNT (a.c1, ',') + 1 AS cn FROM t1 a) a
     , (SELECT LEVEL AS lv FROM DUAL CONNECT BY LEVEL <= 10) b
 WHERE b.lv <= a.cn;

--
SELECT TRIM (b.COLUMN_VALUE) AS c1
  FROM t1 a, XMLTABLE ('ora:tokenize($p, ",")' PASSING a.c1 AS "p") b;

--
CREATE OR REPLACE TYPE ntt_varchar2 IS TABLE OF VARCHAR2 (4000);
/

CREATE OR REPLACE FUNCTION fnc_split (i_val IN VARCHAR2, i_del IN VARCHAR2 DEFAULT ',')
    RETURN ntt_varchar2 PIPELINED
IS
    v_tmp VARCHAR2 (32767) := i_val || i_del;
    v_pos PLS_INTEGER;
BEGIN
    LOOP
        v_pos := INSTR (v_tmp, i_del);
        EXIT WHEN NVL (v_pos, 0) = 0;
        PIPE ROW (SUBSTR (v_tmp, 1, v_pos - 1));
        v_tmp := SUBSTR (v_tmp, v_pos + 1);
    END LOOP;
END;
/

--
SELECT b.COLUMN_VALUE AS c1 FROM t1 a, TABLE (fnc_split (a.c1)) b;

--
VAR b1 VARCHAR2(100)

EXEC :b1 := '10,20'

SELECT empno, ename, deptno
  FROM emp
 WHERE deptno IN (SELECT COLUMN_VALUE FROM TABLE (fnc_split (:b1)));

--
EXEC :b1 := '30,40'

SELECT empno, ename, deptno
  FROM emp
 WHERE deptno IN (SELECT COLUMN_VALUE FROM TABLE (fnc_split (:b1)));
