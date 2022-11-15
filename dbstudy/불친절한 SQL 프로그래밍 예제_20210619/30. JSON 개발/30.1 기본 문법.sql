--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 CLOB, CONSTRAINT t1_c1 CHECK (c2 IS JSON (STRICT)));

--
SELECT table_name, column_name, format, data_type FROM user_json_columns WHERE table_name = 'T1';

--
INSERT INTO t1
SELECT 1 AS c1
     , JSON_OBJECT (KEY 'dept' VALUE
           JSON_ARRAYAGG (
               JSON_OBJECT (KEY 'deptno' VALUE deptno
                          , KEY 'dname'  VALUE dname
                          , KEY 'loc'    VALUE loc))) AS c2
  FROM dept;

--
SELECT * FROM t1;

--
INSERT INTO t1 VALUES (2, 'X');

--
SELECT a.c2.dept           AS c1
     , a.c2.dept.deptno    AS c2
     , a.c2.dept[*].deptno AS c3
  FROM t1 a;

--
SELECT a.c2.dept[0].deptno        AS c1
     , a.c2.dept[0,1].deptno      AS c2
     , a.c2.dept[0 to 2].deptno   AS c3
     , a.c2.dept[0,1 to 3].deptno AS c4
  FROM t1 a;

--
SELECT c1 FROM t1 WHERE c2 IS JSON;

--
SELECT c1 FROM t1 WHERE JSON_EXISTS (c2, '$.dept.deptno');

--
SELECT c1 FROM t1 WHERE JSON_EXISTS (c2, '$.dept[4]');

--
SELECT c1 FROM t1 WHERE JSON_EXISTS (c2, '$.dept?(@.deptno == 50)');

--
SELECT c1
  FROM t1
 WHERE JSON_EXISTS (c2, '$.dept?(@.dname starts with $p)' PASSING 'X' AS "p");

--
SELECT c1
  FROM t1
 WHERE JSON_EXISTS (c2, '$.dept?(@.deptno == 10 && @.dname == "ACCOUNTING")');

--
SELECT c1
  FROM t1
 WHERE JSON_EXISTS (c2, '$.dept?(@.deptno == 50 || @.dname == "ACCOUNTING")');

--
SELECT JSON_OBJECT (KEY 'deptno' VALUE deptno, KEY 'dname' VALUE dname) AS c1 FROM dept;

--
SELECT JSON_OBJECTAGG (KEY TO_CHAR (deptno) VALUE dname) AS c1 FROM dept;

--
SELECT JSON_ARRAY (deptno
                 , JSON_OBJECT (KEY 'dname' VALUE dname)
                 , JSON_OBJECT (KEY 'loc' VALUE loc)) AS c1
  FROM dept;

--
SELECT JSON_ARRAYAGG (dname ORDER BY dname) AS c1 FROM dept;

--
SELECT JSON_VALUE (c2, '$.dept[0].deptno' ERROR ON ERROR) AS c1 FROM t1;

--
SELECT JSON_VALUE (c2, '$.dept.deptno') AS c1 FROM t1;

--
SELECT JSON_VALUE (c2, '$.dept.deptno' DEFAULT '50' ON ERROR) AS c1 FROM t1;

--
SELECT JSON_QUERY (c2, '$.dept.deptno' WITH WRAPPER) AS c1 FROM t1;

--
SELECT JSON_QUERY (c2, '$.dept.deptno') AS c1 FROM t1;

--
SELECT b.*
  FROM t1 a
     , JSON_TABLE (a.c2, '$.dept[*]'
           COLUMNS (deptno NUMBER(2)    PATH '$.deptno'
                  , dname  VARCHAR2(14) PATH '$.dname'
                  , loc    VARCHAR2(13) PATH '$.loc')) b;

--
SELECT b.*
  FROM t1 a
     , JSON_TABLE (a.c2, '$.dept[*]'
           COLUMNS (c1 VARCHAR2(5) EXISTS PATH '$.deptno'
                  , c2 VARCHAR2(80) FORMAT JSON WITH WRAPPER PATH '$.deptno'
                  , c3 FOR ORDINALITY)) b;

--
SELECT *
  FROM JSON_TABLE ('{a:1, b:{c:2, d:3}}', '$'
           COLUMNS (c1 NUMBER PATH '$.a'
                  , NESTED PATH '$.b'
                        COLUMNS (c2 NUMBER PATH '$.c'
                               , c3 NUMBER PATH '$.d')));
