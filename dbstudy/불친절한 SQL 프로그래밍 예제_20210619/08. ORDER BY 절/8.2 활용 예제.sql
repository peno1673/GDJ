--
SELECT   job, sal
    FROM emp
   WHERE deptno = 20
ORDER BY DECODE (job, 'MANAGER', 1, 'CLERK', 2)
       , sal;

--
SELECT   deptno, sal, comm
    FROM emp
   WHERE deptno IN (10, 30)
ORDER BY deptno
       , DECODE (deptno, 10, sal) DESC
       , DECODE (deptno, 30, comm)
       , sal;

--
VAR b1 NUMBER = 1

SELECT   *
    FROM dept
ORDER BY DECODE (:b1, 1, dname, 2, loc);

EXEC :b1 := 2

SELECT   *
    FROM dept
ORDER BY DECODE (:b1, 1, dname, 2, loc);

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 VARCHAR2(10));

INSERT INTO t1 VALUES ('@');
INSERT INTO t1 VALUES ('!');
INSERT INTO t1 VALUES ('2');
INSERT INTO t1 VALUES ('1');
INSERT INTO t1 VALUES ('B');
INSERT INTO t1 VALUES ('A');
INSERT INTO t1 VALUES ('나');
INSERT INTO t1 VALUES ('가');
COMMIT;

--
SELECT c1 FROM t1 ORDER BY c1;

--
SELECT   c1
    FROM t1
ORDER BY REGEXP_INSTR (c1, '^[^[:punct:][:digit:][:lower:][:upper:]]') DESC -- 한글
       , REGEXP_INSTR (c1, '^[[:lower:][:upper:]]') DESC                    -- 영문
       , REGEXP_INSTR (c1, '^[[:digit:]]') DESC                             -- 숫자
       , REGEXP_INSTR (c1, '^[[:punct:]]') DESC                             -- 특수
       , c1;
