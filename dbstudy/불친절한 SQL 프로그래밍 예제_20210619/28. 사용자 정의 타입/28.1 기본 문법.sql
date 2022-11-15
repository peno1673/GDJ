--
CREATE OR REPLACE TYPE trc1 AS OBJECT (c1 NUMBER, c2 NUMBER);
/

--
WITH w1 AS (SELECT trc1 (1, 2) AS r1 FROM DUAL)
SELECT r1, a.r1.c1 AS r1_c1, a.r1.c2 AS r1_c2 FROM w1 a;

--
CREATE OR REPLACE TYPE tnt1 IS TABLE OF NUMBER;
/

--
SELECT tnt1 (1, 2, 3) AS c1 FROM DUAL;

--
CREATE OR REPLACE TYPE tnt2 IS TABLE OF trc1;
/

--
SELECT tnt2 (trc1 (1, 2), trc1 (3, 4), trc1 (5, 6)) AS c1 FROM DUAL;

--
CREATE OR REPLACE TYPE tnt3 IS TABLE OF tnt1;
/

--
SELECT tnt3 (tnt1 (1, 2, 3), tnt1 (4, 5, 6)) AS c1 FROM DUAL;

--
CREATE OR REPLACE TYPE tnt4 IS TABLE OF tnt2;
/

--
SELECT tnt4 (tnt2 (trc1 (1, 2), trc1 (3, 4)), tnt2 (trc1 (5, 6), trc1 (7, 8))) AS c1 FROM DUAL;

--
CREATE OR REPLACE TYPE trc2 AS OBJECT (c1 NUMBER, c2 tnt1);
/

--
SELECT trc2 (1, tnt1 (2, 3, 4)) AS c1 FROM DUAL;

--
SELECT type_name, typecode, attributes FROM user_types;

--
SELECT   type_name, attr_name, attr_type_owner, attr_type_name
    FROM user_type_attrs
ORDER BY type_name, attr_no;

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 tnt1) NESTED TABLE c2 STORE AS t1_c2;

--
SELECT table_name, nested FROM user_tables WHERE table_name IN ('T1', 'T1_C2');

--
SELECT column_name, data_type, data_type_owner FROM user_tab_columns WHERE table_name = 'T1';

--
SELECT table_name, index_name, index_type FROM user_indexes WHERE table_name IN ('T1', 'T1_C2');

--
INSERT INTO t1 VALUES (1, tnt1 (1, 2, 2));
INSERT INTO t1 VALUES (2, tnt1 (1, 2, 3));
INSERT INTO t1 VALUES (3, tnt1 ());
INSERT INTO t1 VALUES (4, NULL);
COMMIT;
