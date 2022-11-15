--
DROP TABLE t1 PURGE;

CREATE TABLE t1 (
    c1 NUMBER
  , c2 NUMBER(2) DEFAULT 2
  , c3 NUMBER(3) DEFAULT 3 NOT NULL);

--
SELECT table_name FROM user_tables WHERE table_name = 'T1';

--
SELECT   column_name, data_type, data_precision, data_scale, nullable, data_default
    FROM user_tab_columns
   WHERE table_name = 'T1'
ORDER BY column_id;

--
DROP TABLE t2 PURGE;

CREATE TABLE t2 AS SELECT * FROM t1 WHERE 0 = 1;

--
SELECT   column_name, data_type, data_precision, data_scale, nullable, data_default
    FROM user_tab_columns
   WHERE table_name = 'T2'
ORDER BY column_id;

--
DROP TABLE t2 PURGE;

CREATE TABLE t2 (c1, c2 DEFAULT 2, c4 DEFAULT 3) AS SELECT * FROM t1 WHERE 0 = 1;

--
SELECT   column_name, data_type, data_precision, data_scale, nullable, data_default
    FROM user_tab_columns
   WHERE table_name = 'T2'
ORDER BY column_id;

--
DROP TABLE t2 PURGE;

CREATE TABLE t2 AS
SELECT 1234 AS c1
     , 'AB' AS c2
     , CAST (1234 AS NUMBER(10)  ) AS c3
     , CAST ('AB' AS VARCHAR2(10)) AS c4
  FROM DUAL;

--
SELECT column_name, data_type, data_length, data_precision, data_scale
  FROM user_tab_columns
 WHERE table_name = 'T2';

--
DROP TABLE t1 PURGE;

CREATE TABLE t1 AS SELECT NULL AS c1 FROM DUAL;

--
DROP TABLE t1 PURGE;

CREATE TABLE t1 AS
SELECT CAST (NULL AS NUMBER) AS c1, CAST (NULL AS VARCHAR2(1)) AS c2 FROM DUAL;

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 TABLESPACE users AS SELECT ROWNUM AS c1 FROM XMLTABLE ('1 to 10000');

--
SELECT tablespace_name FROM user_tables WHERE table_name = 'T1';

--
SELECT segment_type, tablespace_name, bytes, blocks
  FROM user_segments
 WHERE segment_name = 'T1';

--
SELECT extent_id, bytes, blocks FROM user_extents WHERE segment_name = 'T1';

--
SELECT default_tablespace FROM dba_users WHERE username = 'SCOTT';

--
CREATE OR REPLACE FUNCTION fnc_unit (
    i_val IN NUMBER
  , i_div IN NUMBER DEFAULT 1024
)
    RETURN VARCHAR2
IS
    v_val NUMBER := i_val;
    v_idx NUMBER := 1;
BEGIN
    CASE
        WHEN i_val IS NULL THEN
            RETURN NULL;
        ELSE
            LOOP
                EXIT WHEN v_val < i_div;
                v_val := v_val / i_div;
                v_idx := v_idx + 1;
            END LOOP;

            RETURN TO_CHAR (ROUND (v_val, 2), LPAD ('9', LENGTH (i_div) - 1, '9') || '0.90') || TRANSLATE (v_idx, '123456789', ' KMGTPEZY');
    END CASE;
END;
/

--
SELECT initial_extent, fnc_unit (initial_extent) AS c1
     , max_extents   , fnc_unit (max_extents)    AS c2
     , num_rows      , fnc_unit (num_rows, 1000) AS c3
  FROM user_tables
 WHERE table_name = 'EMP';

--
DROP TABLE t1 PURGE;

ALTER TABLE t2 RENAME TO t1;

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 AS SELECT ROWNUM AS c1 FROM XMLTABLE ('1 to 10000');

--
ALTER TABLE t1 MOVE INCLUDING ROWS WHERE c1 <= 5000 TABLESPACE users;

--
SELECT COUNT (*) AS c1 FROM t1;

--
ALTER TABLE t1 READ ONLY;

--
INSERT INTO t1 (c1) VALUES (1);

--
SELECT table_name, read_only FROM user_tables WHERE table_name = 'T1';

--
DROP TABLE t1 CASCADE CONSTRAINTS PURGE;

--
TRUNCATE TABLE t1;

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 NUMBER);

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 NUMBER, CONSTRAINT t1_pk PRIMARY KEY (c1)) ORGANIZATION INDEX;

--
SELECT object_name, data_object_id, object_type
  FROM user_objects
 WHERE object_name IN ('T1', 'T1_PK');

--
SELECT segment_name, segment_type
  FROM user_segments
 WHERE segment_name IN ('T1', 'T1_PK');

--
SELECT table_name, iot_type FROM user_tables WHERE table_name = 'T1';

--
sqlplus sys/oracle AS SYSDBA

CREATE OR REPLACE DIRECTORY dir_ext AS 'c:\app\ora12cr2\admin\ora12cr2\ext';

GRANT ALL ON DIRECTORY dir_ext TO scott;

--
SELECT owner, directory_name, directory_path
  FROM all_directories
 WHERE directory_name = 'DIR_EXT';

--
SELECT grantee, owner, table_name, grantor, privilege, type
  FROM user_tab_privs
 WHERE table_name = 'DIR_EXT';

--
DROP TABLE t1 PURGE;

CREATE TABLE t1 (deptno NUMBER(2), dname VARCHAR2(14), loc VARCHAR2(13))
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY dir_ext
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        NOBADFILE NOLOGFILE NODISCARDFILE
        FIELDS TERMINATED BY ',')
    LOCATION ('ext_dept.txt')
) REJECT LIMIT UNLIMITED;

--
SELECT * FROM t1;

--
SELECT type_name, default_directory_name, access_parameters
  FROM user_external_tables
 WHERE table_name = 'T1';

--
SELECT location, directory_name FROM user_external_locations WHERE table_name = 'T1';

--
zip ext_dept.zip ext_dept.txt

--
DROP TABLE t1 PURGE;

CREATE TABLE t1 (deptno NUMBER(2), dname VARCHAR2(14), loc VARCHAR2(13))
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY dir_ext
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        PREPROCESSOR dir_ext:'ext_unzip.cmd'
        NOBADFILE NOLOGFILE NODISCARDFILE
        FIELDS TERMINATED BY ',')
    LOCATION ('ext_dept.zip')
) REJECT LIMIT UNLIMITED;

--
SELECT * FROM t1;

--
DROP TABLE t1 PURGE;

CREATE TABLE t1 (
    yyyymmdd  VARCHAR2(10)
  , ampm      VARCHAR2(10)
  , hhmi      VARCHAR2(10)
  , file_size NUMBER
  , file_name VARCHAR2(255)
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY dir_ext
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        PREPROCESSOR dir_ext:'ext_dir.cmd'
        LOAD WHEN file_size != '<DIR>'
        NOBADFILE NOLOGFILE NODISCARDFILE
        DISABLE_DIRECTORY_LINK_CHECK
        FIELDS TERMINATED BY WHITESPACE
    ) LOCATION ('ext_dir.cmd')
) REJECT LIMIT UNLIMITED;

--
SELECT   TO_DATE (yyyymmdd || ampm || hhmi, 'YYYY-MM-DDAMHH:MI') AS file_date
       , file_size, file_name
    FROM t1
ORDER BY 1 DESC;

--
DROP CLUSTER c1# INCLUDING TABLES;

CREATE CLUSTER c1# (c1 NUMBER) INDEX;

--
DROP INDEX c1#_x1;

CREATE INDEX c1#_x1 ON CLUSTER c1#;

--
DROP TABLE t1 PURGE;
DROP TABLE t2 PURGE;

CREATE TABLE t1 (c1 NUMBER, c2 NUMBER) CLUSTER c1# (c1);
CREATE TABLE t2 (c1 NUMBER, c2 NUMBER) CLUSTER c1# (c1);

--
SELECT cluster_name, cluster_type FROM user_clusters WHERE cluster_name = 'C1#';

--
SELECT cluster_name, clu_column_name, table_name, tab_column_name
  FROM user_clu_columns
 WHERE cluster_name = 'C1#';

--
SELECT table_name, cluster_name FROM user_tables WHERE table_name IN ('T1', 'T2');

--
SELECT index_type, table_owner, table_name, table_type
  FROM user_indexes
 WHERE index_name = 'C1#_X1';

--
TRUNCATE TABLE t1;

--
TRUNCATE CLUSTER c1#;

--
DROP CLUSTER c1# INCLUDING TABLES;
CREATE CLUSTER c1# (c1 NUMBER) HASHKEYS 100;

--
DROP TABLE t1 PURGE;
DROP TABLE t2 PURGE;

CREATE TABLE t1 (c1 NUMBER, c2 NUMBER) CLUSTER c1# (c1);
CREATE TABLE t2 (c1 NUMBER, c2 NUMBER) CLUSTER c1# (c1);

--
SELECT cluster_name, cluster_type, function, hashkeys
  FROM user_clusters
 WHERE cluster_name = 'C1#';

--
DROP CLUSTER c1# INCLUDING TABLES;
CREATE CLUSTER c1# (c1 NUMBER) SINGLE TABLE HASHKEYS 100;

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 NUMBER) CLUSTER c1# (c1);

--
SELECT cluster_name, single_table FROM user_clusters WHERE cluster_name = 'C1#';

--
DROP CLUSTER c1# INCLUDING TABLES;
CREATE CLUSTER c1# (c1 NUMBER, c2 NUMBER SORT) HASHKEYS 100 HASH IS c1;

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 NUMBER, c3 NUMBER) CLUSTER c1# (c1, c2);

--
SELECT hash_expression FROM user_cluster_hash_expressions WHERE cluster_name = 'C1#';

--
DROP TABLE t1 PURGE;
CREATE GLOBAL TEMPORARY TABLE t1 (c1 NUMBER) ON COMMIT DELETE ROWS;

--
INSERT INTO t1 VALUES (1);

SELECT * FROM t1;

COMMIT;

SELECT * FROM t1;

--
DROP TABLE t1 PURGE;
CREATE GLOBAL TEMPORARY TABLE t1 (c1 NUMBER) ON COMMIT PRESERVE ROWS;

--
INSERT INTO t1 VALUES (1);
COMMIT;

SELECT * FROM t1;

SELECT * FROM t1;

-- S1
INSERT INTO t1 VALUES (1);
COMMIT;

-- S2
INSERT INTO t1 VALUES (2);
COMMIT;

-- S1
SELECT * FROM t1;

-- S2
SELECT * FROM t1;
