--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 XMLTYPE);

--
SELECT column_name, xmlschema, schema_owner, storage_type, anyschema, nonschema
  FROM user_xml_tab_cols
 WHERE table_name = 'T1';

--
INSERT INTO t1 VALUES (1, XMLTYPE ('<emp><ename>SCOTT</ename><job>ANALYST</job></emp>'));

--
INSERT INTO t1
VALUES (2, XMLTYPE (BFILENAME ('DIR_EXT', 'emp.xml'), NLS_CHARSET_ID ('KO16MSWIN949')));

--
DROP TABLE t1 PURGE;

CREATE TABLE t1 AS
SELECT a.deptno AS c1
     , XMLELEMENT ("emps",
           (SELECT XMLAGG (
                       XMLELEMENT ("emp", XMLATTRIBUTES (x.empno    AS "empno")
                                        , XMLFOREST     (x.ename    AS "ename"
                                                       , x.job      AS "job"
                                                       , x.mgr      AS "mgr"
                                                       , x.hiredate AS "hiredate"
                                                       , x.sal      AS "sal"
                                                       , x.comm     AS "comm"))
                           ORDER BY x.empno)
              FROM emp x
             WHERE x.deptno = a.deptno)) AS c2
  FROM dept a;

--
SELECT * FROM t1;

--
DELETE FROM t1 WHERE c1 IN (20, 30, 40);
COMMIT;

--
SELECT a.c2.EXTRACT ('/emps/emp/ename') AS c2 FROM t1 a;

--
SELECT a.c2.EXTRACT ('//job') AS c2  FROM t1 a;

--
SELECT a.c2.EXTRACT ('/emps/emp/ename|//job') AS c2 FROM t1 a;

--
SELECT a.c2.EXTRACT ('/emps/*/ename/..') AS c2 FROM t1 a;

--
SELECT a.c2.EXTRACT ('/emps/emp/@empno') AS c2 FROM t1 a;

--
SELECT a.c2.EXTRACT ('/emps/emp[job = "PRESIDENT"]/ename') AS c2 FROM t1 a;

--
SELECT a.c2.EXTRACT ('/emps/emp[@empno=7934]/ename') AS c2 FROM t1 a;

--
SELECT a.c2.EXTRACT ('/emps/emp[job = "PRESIDENT" or sal >= 2000]/ename') AS c2 FROM t1 a;

--
SELECT a.c2.EXTRACT ('/emps/emp[1]/ename') AS c2 FROM t1 a;

--
SELECT a.c2.EXTRACT ('/emps/emp[position() <= 2]/ename') AS c2 FROM t1 a;

--
SELECT a.c2.EXTRACT ('/emps/emp[last()]/ename') AS c2 FROM t1 a;

--
SELECT a.c2.EXTRACT ('/emps/emp[last()]/ename/text()') AS c2 FROM t1 a;

--
SELECT a.c2.EXISTSNODE ('/emps/emp[@empno=1234]') AS c1
     , a.c2.EXISTSNODE ('/emps/emp[@empno=7934]') AS c2
  FROM t1 a;

--
SELECT a.c2.EXTRACT ('/emps/emp[1]/ename/text()').GETSTRINGVAL () AS c2 FROM t1 a;

--
SELECT a.c2.EXTRACT ('/emps/emp[1]/sal/text()').GETNUMBERVAL () AS c2 FROM t1 a;

--
SELECT a.c2.EXTRACT ('/emps/emp[1]/job/text()').GETCLOBVAL () AS c2 FROM t1 a;

--
SELECT XMLELEMENT ("ename", ename) AS c1 FROM emp WHERE empno = 7788;

--
SELECT XMLELEMENT ("emp", XMLELEMENT ("ename", ename), XMLELEMENT ("job", job)) AS c1
  FROM emp
 WHERE empno = 7788;

--
SELECT XMLELEMENT ("emp", XMLATTRIBUTES (ename, job AS "job")) AS c1
  FROM emp
 WHERE empno = 7788;

--
SELECT XMLELEMENT ("emp", XMLATTRIBUTES (empno AS "empno")
                        , XMLELEMENT ("ename", ename)
                        , XMLELEMENT ("job", job)) AS c1
  FROM emp
 WHERE empno = 7788;

--
SELECT XMLFOREST (ename, job AS "job") AS c1 FROM emp WHERE empno = 7788;

--
SELECT XMLELEMENT ("emp", XMLATTRIBUTES (empno AS "empno")
                        , XMLFOREST (ename AS "ename", job AS "job")) AS c1
  FROM emp
 WHERE empno = 7788;

--
SELECT XMLCONCAT (XMLELEMENT ("ename", ename), XMLELEMENT ("job", job)) AS c1
  FROM emp
 WHERE empno = 7788;

--
SELECT XMLAGG (XMLELEMENT ("ename", ename) ORDER BY empno) AS c1 FROM emp WHERE deptno = 10;

--
SELECT XMLELEMENT ("emps",
           XMLAGG (
               XMLELEMENT ("emp", XMLATTRIBUTES (empno AS "empno")
                                , XMLFOREST (ename AS "ename", job AS "job"))
                   ORDER BY empno)) AS c1
  FROM emp
 WHERE deptno = 10;

--
SELECT XMLPI (NAME "XMLPI", 'pi') AS c1 FROM DUAL;

--
SELECT XMLCOMMENT ('comment') AS c1 FROM DUAL;

--
SELECT XMLSERIALIZE (CONTENT XMLFOREST (ename AS "ename", job AS "job")) AS c1
  FROM emp
 WHERE empno = 7788;

--
SELECT XMLPARSE (CONTENT '<ename>SCOTT</ename><job>ANALYST</job>') as c1 FROM DUAL;

--
SELECT XMLCOLATTVAL (empno, ename AS "ename") AS c1 FROM emp WHERE empno = 7788;

--
SELECT XMLELEMENT ("ename", XMLCDATA (ename)) AS c1 FROM emp WHERE empno = 7788;

--
SELECT SYS_XMLAGG (XMLELEMENT ("ename", ename)) AS c1 FROM emp WHERE deptno = 10;

--
SELECT XMLQUERY ('/emps/emp[1]/ename' PASSING c2 RETURNING CONTENT) AS c2 FROM t1;

--
SELECT b.* FROM t1 a, XMLTABLE ('/emps/emp[1]/ename' PASSING a.c2) b;

--
SELECT b.*, a.c1 AS deptno
  FROM t1 a
     , XMLTABLE ('/emps/emp' PASSING a.c2
                 COLUMNS empno    NUMBER(4)    PATH '//@empno'
                       , ename    VARCHAR2(10) PATH '//ename'
                       , job      VARCHAR2(9)  PATH '//job'
                       , mgr      NUMBER(4)    PATH '//mgr'
                       , hiredate DATE         PATH '//hiredate'
                       , sal      NUMBER(7,2)  PATH '//sal'
                       , comm     NUMBER(7,2)  PATH '//comm' DEFAULT 0) b;

--
SELECT XMLQUERY ('/emps/emp/ename' PASSING c2 RETURNING CONTENT) AS c2
  FROM t1
 WHERE XMLEXISTS ('/emps/emp[@empno=7934]' PASSING c2);

--
SELECT XMLCAST (XMLQUERY ('/emps/emp[1]/ename' PASSING c2 RETURNING CONTENT)
                AS VARCHAR2(10)) AS c2
  FROM t1;

--
SELECT XMLQUERY ('for $x in //emp
                  let $sal := 2000
                  where $x/sal >= $sal
                  order by $x/sal descending
                  return $x/ename'
                 PASSING c2
                 RETURNING CONTENT) AS c2
  FROM t1;

--
UPDATE t1
   SET c2 = XMLQUERY ('copy $i := $p1 modify
                         (for $j in $i//emp[1]
                          return insert node $p2 as last into $j)
                       return $i'
                      PASSING c2 AS "p1", XMLTYPE('<comm>0</comm>') AS "p2"
                      RETURNING CONTENT);

--
UPDATE t1
   SET c2 = XMLQUERY ('copy $i := $p1 modify
                         (for $j in $i//emp[1]/comm
                          return replace node $j with $p2)
                       return $i'
                      PASSING c2 AS "p1"
                            , XMLTYPE('<commision>100</commision>') AS "p2"
                      RETURNING CONTENT);

--
UPDATE t1
   SET c2 = XMLQUERY ('copy $i := $p1 modify
                         (for $j in $i//emp[1]/commision
                          return replace value of node $j with $p2)
                       return $i'
                      PASSING c2 AS "p1", 200 AS "p2"
                      RETURNING CONTENT);

--
UPDATE t1
   SET c2 = XMLQUERY ('copy $i := $p modify
                         (for $j in $i//emp[1]/commision
                          return rename node $j as "comm")
                       return $i'
                      PASSING c2 AS "p"
                      RETURNING CONTENT);

--
UPDATE t1
   SET c2 = XMLQUERY ('copy $i := $p modify
                       delete nodes $i//emp[1]/comm
                       return $i'
                      PASSING c2 AS "p"
                      RETURNING CONTENT);

--
SELECT XMLCAST (XMLQUERY ('((1 + 2) * 3) div 4' RETURNING CONTENT) AS NUMBER) AS c1 FROM DUAL;

--
SELECT * FROM XMLTABLE ('1,2,3' COLUMNS c1 NUMBER PATH '.');

--
SELECT * FROM XMLTABLE ('4 to 6' COLUMNS c1 NUMBER PATH '.');

--
SELECT *
  FROM XMLTABLE ('for $i in 1 to 5 where $i mod 2 = 1 return $i' COLUMNS c1 NUMBER PATH '.');

--
SELECT * FROM XMLTABLE ('for $i in 1 to 2, $j in 1 to 2 let $v := $i * $j return $v'
                        COLUMNS c1 NUMBER PATH '.');

--
SELECT * FROM XMLTABLE ('"A","BC","DEF"' COLUMNS c1 VARCHAR2 (3) PATH '.');

--
SELECT XMLQUERY ('/emps/emp/ename[fn:matches(text(), "K")]' PASSING c2 RETURNING CONTENT) AS c2
  FROM t1;

--
SELECT XMLQUERY ('fn:replace(/emps/emp[2]/ename, "K", "R")' PASSING c2 RETURNING CONTENT) AS c2
  FROM t1;

--
SELECT XMLQUERY ('fn:tokenize($p, ",")' PASSING '1,2,3' AS "p" RETURNING CONTENT) AS c1
  FROM DUAL;

--
SELECT *
  FROM XMLTABLE ('fn:tokenize($p, ",")' PASSING '1,2,3' AS "p" COLUMNS c1 NUMBER PATH '.');

--
WITH w1 AS (SELECT '1,2,3' AS c1 FROM DUAL)
SELECT TRIM (b.COLUMN_VALUE) AS c1
  FROM w1 a, XMLTABLE ('fn:tokenize($p, ",")' PASSING a.c1 AS "p") b;

--
SELECT TRIM (COLUMN_VALUE) AS c1 FROM XMLTABLE ('1,2,3');

--
SELECT XMLQUERY ('fn:distinct-values(fn:tokenize($p, ","))'
                 PASSING '1,2,3,1,2,3' AS "p" RETURNING CONTENT) AS c1
  FROM DUAL;

--
SELECT *
  FROM XMLTABLE ('fn:string-join(
                      for $i in fn:distinct-values(fn:tokenize($p, ","))
                      order by $i
                      return $i
                  , ",")'
                 PASSING '3,2,1,3,2,1' AS "p"
                 COLUMNS c1 VARCHAR2(4000) PATH '.');

--
SELECT XMLQUERY ('for $i in fn:collection("oradb:/SCOTT/DEPT")/ROW[DEPTNO = 10]
                  return $i'
                 RETURNING CONTENT) AS c1
  FROM DUAL;

--
SELECT XMLQUERY ('for $i in fn:collection("oradb:/SCOTT/DEPT")/ROW[DEPTNO = 10]
                    , $j in fn:collection("oradb:/SCOTT/EMP")
                  where $j//DEPTNO = $i//DEPTNO
                    and $j//JOB = "PRESIDENT"
                  return ($i//DEPTNO, $j//EMPNO)'
                 RETURNING CONTENT) AS c1
  FROM DUAL;

--
SELECT DBMS_XMLGEN.GETXML ('SELECT empno, ename FROM emp WHERE deptno = 10') AS c1 FROM DUAL;

--
SELECT DBMS_XMLGEN.GETXMLTYPE ('SELECT empno, ename FROM emp WHERE deptno = 10') AS c1 FROM DUAL;
