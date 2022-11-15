-- S2
SELECT vl FROM t1 WHERE cd = 1;

-- S1
UPDATE t1 SET vl = vl + 10 WHERE cd = 1;
SELECT vl FROM t1 WHERE cd = 1; -- 50

-- S2
SELECT vl FROM t1 WHERE cd = 1;

-- S1
COMMIT;

-- S2
SELECT vl FROM t1 WHERE cd = 1;

--
sqlplus sys/oracle AS SYSDBA

GRANT EXECUTE ON DBMS_LOCK TO scott;

--
CREATE OR REPLACE FUNCTION f1 (i_seconds IN NUMBER)
    RETURN NUMBER
IS
BEGIN
    DBMS_LOCK.SLEEP (i_seconds);
    RETURN 1;
END f1;
/

-- S1
SELECT * FROM t1 WHERE cd = 1 AND f1 (10) = 1;

-- S2
UPDATE t1 SET vl = vl - 10 WHERE cd = 1;
COMMIT;

-- S1
SELECT * FROM t1 WHERE cd = 1;

-- S1
SELECT * FROM t1 FOR UPDATE;

-- S2
UPDATE t1 SET vl = vl + 10 WHERE cd = 1;

-- S1
SELECT SUM (vl) AS vl FROM t1;

SELECT SUM (vl) AS vl FROM t1; -- 100

COMMIT;

-- S2
ROLLBACK;


-- S1
SELECT * FROM t1 FOR UPDATE;

SELECT SUM (vl) AS vl FROM t1;

-- S2
INSERT INTO t1 (cd, vl) VALUES (3, 50);
COMMIT;

-- S3
SELECT SUM (vl) AS vl FROM t1;

COMMIT;

-- S1
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT SUM (vl) AS vl FROM t1;

-- S2
INSERT INTO t1 (cd, vl) VALUES (4, 50);
COMMIT;

-- S1
SELECT SUM (vl) AS vl FROM t1;

COMMIT;

SELECT SUM (vl) AS vl FROM t1;

-- S1
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- S2
UPDATE t1 SET vl = vl + 10 WHERE cd = 1;
COMMIT;

-- S1
UPDATE t1 SET vl = vl - 10 WHERE cd = 1;

ROLLBACK;
