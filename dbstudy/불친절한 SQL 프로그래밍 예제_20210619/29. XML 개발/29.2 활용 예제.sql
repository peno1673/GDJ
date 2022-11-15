--
SELECT LTRIM (XMLCAST (XMLAGG (XMLELEMENT (x, ',', ename) ORDER BY ename) AS CLOB), ',') AS c1
  FROM emp;

--
SELECT table_name
     , DBMS_XMLGEN.GETXMLTYPE ('SELECT COUNT (*) AS c FROM ' || owner || '.' ||
       table_name).EXTRACT('/ROWSET/ROW/C/text()').GETNUMBERVAL() AS cnt
  FROM all_tables
 WHERE owner = 'SCOTT'
   AND table_name IN ('DEPT', 'EMP');

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 VARCHAR2(1) DEFAULT 'A');

--
SELECT 'DEFAULT ' || data_default AS c1 FROM user_tab_cols WHERE table_name = 'T1';

--
SELECT 'DEFAULT ' || data_default AS c1
  FROM XMLTABLE ('ROWSET/ROW'
                 PASSING (SELECT DBMS_XMLGEN.GETXMLTYPE (q'[SELECT data_default FROM user_tab_cols WHERE table_name = 'T1']') AS c1 FROM DUAL)
                 COLUMNS data_default VARCHAR2(4000) PATH 'DATA_DEFAULT');
