--
SELECT type, name, description FROM v$lock_type ORDER BY type;

-- S1
SELECT USERENV ('SID') FROM DUAL;

-- S2
SELECT USERENV ('SID') FROM DUAL;

-- S1
UPDATE t1 SET vl = vl + 10 WHERE cd = 1;

-- S2
UPDATE t1 SET vl = vl - 10 WHERE cd = 2;

--
SELECT lock_type, mode_held, mode_requested, blocking_others
  FROM dba_lock
 WHERE session_id = 100
   AND lock_type in ('DML', 'Transaction');

--
SELECT lock_type, mode_held, mode_requested, blocking_others
  FROM dba_lock
 WHERE session_id = 200
   AND lock_type in ('DML', 'Transaction');

-- S1
ROLLBACK;

-- S2
ROLLBACK;

--
SELECT lock_type, mode_held, mode_requested, blocking_others
  FROM dba_lock
 WHERE session_id IN (100, 200)
   AND lock_type in ('DML', 'Transaction');

-- S1
UPDATE t1 SET vl = vl + 10 WHERE cd = 1;

-- S2
UPDATE t1 SET vl = vl - 10 WHERE cd = 1;

--
SELECT lock_type, mode_held, mode_requested, blocking_others
  FROM dba_lock
 WHERE session_id = 100
   AND lock_type in ('DML', 'Transaction');

--
SELECT lock_type, mode_held, mode_requested, blocking_others
  FROM dba_lock
 WHERE session_id = 200
   AND lock_type in ('DML', 'Transaction');

--
DROP TABLE t1;

-- S1
ROLLBACK;

-- S2
ROLLBACK;

-- S1
LOCK TABLE t1 IN ROW EXCLUSIVE MODE;

-- S2
LOCK TABLE t1 IN EXCLUSIVE MODE NOWAIT;

-- S3
ROLLBACK;

-- S1
COLUMN vl NEW_VALUE s_vl

SELECT vl FROM t1 WHERE cd = 1;

-- S2
UPDATE t1 SET vl = vl + 10 WHERE cd = 1;
COMMIT;

-- S1
UPDATE t1 SET vl = &s_vl + 10 WHERE cd = 1;

SELECT vl FROM t1 WHERE cd = 1;

--
UPDATE t1 SET vl = 40 WHERE cd = 1;
COMMIT;

-- S1
SELECT * FROM t1 WHERE cd = 1 FOR UPDATE;

-- S2
SELECT * FROM t1 WHERE cd = 1 FOR UPDATE;

-- S1
UPDATE t1 SET vl = vl + 10 WHERE cd = 1;
COMMIT;

-- S2
UPDATE t1 SET vl = vl - 10 WHERE cd = 1;
COMMIT;

-- S1
SELECT * FROM t1 WHERE cd = 1 FOR UPDATE;

-- S2
SELECT * FROM t1 WHERE cd = 1 FOR UPDATE NOWAIT;

-- S1
COMMIT;

-- S1
SELECT * FROM t1 WHERE cd = 1 FOR UPDATE;

-- S2
SELECT * FROM t1 WHERE cd = 1 FOR UPDATE WAIT 10;

-- S1
COMMIT;

-- S1
SELECT * FROM t1 WHERE cd = 1 FOR UPDATE;

-- S2
SELECT * FROM t1 FOR UPDATE SKIP LOCKED;

-- S1
COMMIT;

-- S2
COMMIT;

-- S1
SELECT *
  FROM emp a, dept b
 WHERE b.deptno = a.deptno
   FOR UPDATE OF a.deptno;

-- S2
SELECT * FROM dept FOR UPDATE NOWAIT;

SELECT * FROM emp FOR UPDATE NOWAIT;

-- S1
COMMIT;

-- S2
COMMIT;

--
DROP TABLE tp PURGE;
DROP TABLE tc PURGE;

CREATE TABLE tp (cd VARCHAR2(1), CONSTRAINT tp_pk PRIMARY KEY (cd));

CREATE TABLE tc (cd VARCHAR2(1) -- 코드
               , bd DATE        -- 시작일자
               , ed DATE        -- 종료일자
               , vl NUMBER      -- 값
               , CONSTRAINT tc_pk PRIMARY KEY (cd, bd)
               , CONSTRAINT tc_f1 FOREIGN KEY (cd) REFERENCES tp (cd));

INSERT INTO tp VALUES ('A');
INSERT INTO tc VALUES ('A', DATE '2050-01-01', DATE '9999-12-31', 1);
COMMIT;

--
SELECT * FROM tp WHERE cd = 'A' FOR UPDATE;

UPDATE tc -- 기존 이력 단절
   SET ed = DATE '2050-02-01' - 1
 WHERE cd = 'A'
   AND ed = DATE '9999-12-31';

INSERT
  INTO tc -- 신규 이력 생성
VALUES ('A', DATE '2050-02-01', DATE '9999-12-31', 2);

COMMIT;

--
SELECT * FROM tc ORDER BY 2;

--
ALTER TABLE tc DROP CONSTRAINT tc_pk;
ALTER TABLE tc ADD  CONSTRAINT tc_pk PRIMARY KEY (cd, ed);

--
SELECT * FROM tp WHERE cd = 'A' FOR UPDATE;

INSERT
  INTO tc -- 기존 이력 단절
SELECT cd, bd, DATE '2050-03-01' - 1 AS ed, vl
  FROM tc
 WHERE cd = 'A'
   AND ed = DATE '9999-12-31';

UPDATE tc -- 신규 이력 생성
   SET bd = DATE '2050-03-01', vl = 3
 WHERE cd = 'A'
   AND ed = DATE '9999-12-31';

COMMIT;

--
SELECT * FROM tc ORDER BY 2;

-- S1
COLUMN vl NEW_VALUE s_vl

SELECT vl FROM t1 WHERE cd = 1;

-- S2
UPDATE t1 SET vl = vl + 10 WHERE cd = 1;
COMMIT;

-- S1
UPDATE t1
   SET vl = vl + 10
 WHERE cd = 1
   AND vl = &s_vl;

--
ALTER TABLE t1 ADD md DATE DEFAULT DATE '2050-01-01' NOT NULL;

-- S1
COLUMN md NEW_VALUE s_md

SELECT md FROM t1 WHERE cd = 1;

-- S2
UPDATE t1
   SET vl = vl - 10, md = SYSDATE
 WHERE cd = 1;

COMMIT;

-- S1
UPDATE t1
   SET vl = vl - 10
 WHERE cd = 1
   AND md = TO_DATE ('&s_md', 'YYYY-MM-DD HH24:MI:SS');
