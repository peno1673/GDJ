--
DROP TABLE t1 PURGE;
DROP TABLE t2 PURGE;

CREATE TABLE t1 AS SELECT deptno, dname, 0 AS sal, 0 AS comm FROM dept;
CREATE TABLE t2 AS SELECT empno, ename, sal, comm, deptno FROM emp;

ALTER TABLE t1 ADD CONSTRAINT t1_pk PRIMARY KEY (deptno);
ALTER TABLE t2 ADD CONSTRAINT t2_pk PRIMARY KEY (empno);
ALTER TABLE t2 ADD CONSTRAINT t2_f1 FOREIGN KEY (deptno) REFERENCES t1 (deptno);

--
SELECT * FROM t1;

--
UPDATE t1 SET sal = 10000, comm = 1000 WHERE deptno = 40;

--
SELECT * FROM t1;

--
UPDATE t1 a
   SET (a.sal, a.comm) = (SELECT SUM (x.sal), SUM (x.comm) FROM t2 x WHERE x.deptno = a.deptno);

--
SELECT * FROM t1;

--
UPDATE t1 a
   SET (a.sal, a.comm) =
       (SELECT SUM (x.sal), SUM (x.comm) FROM t2 x WHERE x.deptno = a.deptno)
 WHERE EXISTS (SELECT 1 FROM t2 x WHERE x.deptno = a.deptno);

--
UPDATE (SELECT a.sal, a.comm, b.sal AS sal_n, b.comm AS comm_n
          FROM t1 a
             , (SELECT deptno, SUM (sal) AS sal, SUM (comm) AS comm FROM t2 GROUP BY deptno) b
         WHERE b.deptno = a.deptno)
   SET sal = sal_n, comm = comm_n;

--
MERGE
 INTO t1 t
USING (SELECT deptno, SUM (sal) AS sal, SUM (comm) AS comm FROM t2 GROUP BY deptno) s
   ON (t.deptno = s.deptno)
 WHEN MATCHED THEN
      UPDATE
         SET t.sal = s.sal, t.comm = s.comm;

--
UPDATE (SELECT a.sal, a.comm, b.sal AS sal_n, b.comm AS comm_n
          FROM t1 a, t2 b
         WHERE b.deptno = a.deptno)
   SET sal = sal_n, comm = comm_n;

--
UPDATE (SELECT a.sal, a.comm, b.sal AS sal_n, b.comm AS comm_n
          FROM t2 a, t1 b
         WHERE b.deptno = a.deptno)
   SET sal = sal_n, comm = comm_n;

--
ALTER TABLE t1 DROP CONSTRAINT t1_pk CASCADE;

--
UPDATE (SELECT a.sal, a.comm, b.sal AS sal_n, b.comm AS comm_n
          FROM t2 a, t1 b
         WHERE b.deptno = a.deptno)
   SET sal = sal_n, comm = comm_n;

--
UPDATE (SELECT a.*, b.dname AS dname_n
          FROM t1 a, dept b
         WHERE b.deptno = a.deptno)
   SET dname = dname_n;
