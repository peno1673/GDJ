--
DROP TABLE t1 PURGE;
DROP TABLE t2 PURGE;
DROP TABLE t3 PURGE;

CREATE TABLE t2 AS SELECT 2 AS c1 FROM DUAL;
CREATE TABLE t3 AS SELECT 3 AS c1 FROM DUAL;

--
CREATE OR REPLACE SYNONYM t1 FOR t2;

--
SELECT * FROM t1;

--
CREATE OR REPLACE SYNONYM t1 FOR t3;

--
SELECT * FROM t1;

--
SELECT synonym_name, table_owner, table_name FROM user_synonyms WHERE synonym_name = 'T1';

--
CREATE TABLE t1 (c1 NUMBER);

--
ALTER SYNONYM t1 COMPILE;

--
DROP SYNONYM t1;

--
SELECT owner, synonym_name, table_owner, table_name FROM all_synonyms WHERE table_name = 'DUAL';

--
CREATE TABLE dual (c1 NUMBER);

--
SELECT * FROM dual;

--
DROP TABLE dual PURGE;