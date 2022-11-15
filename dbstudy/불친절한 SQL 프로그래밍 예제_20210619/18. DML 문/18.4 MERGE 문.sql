--
DROP TABLE t1 PURGE;
DROP TABLE t2 PURGE;
DROP TABLE t3 PURGE;
DROP TABLE t4 PURGE;

CREATE TABLE t2 AS SELECT empno, ename, job, sal FROM emp WHERE deptno = 20;
CREATE TABLE t1 AS SELECT * FROM t2 WHERE empno IN (7369, 7566);
CREATE TABLE t3 AS SELECT * FROM t2 WHERE empno = 7369;
CREATE TABLE t4 AS SELECT '2050' AS yyyy, a.* FROM t2 a UNION ALL
                   SELECT '2051' AS yyyy, a.* FROM t2 a;

ALTER TABLE t1 ADD CONSTRAINT t1_pk PRIMARY KEY (empno);
ALTER TABLE t2 ADD CONSTRAINT t2_pk PRIMARY KEY (empno);
ALTER TABLE t3 ADD CONSTRAINT t3_pk PRIMARY KEY (empno);
ALTER TABLE t4 ADD CONSTRAINT t4_pk PRIMARY KEY (yyyy, empno);

--
SELECT * FROM t1;

SELECT * FROM t2;

--
MERGE
 INTO t1 t
USING t2 s
   ON (t.empno = s.empno)
 WHEN MATCHED THEN
      UPDATE
         SET t.sal = s.sal - 500
 WHEN NOT MATCHED THEN
      INSERT (t.empno, t.ename, t.job)
      VALUES (s.empno, s.ename, s.job);

--
SELECT * FROM t1;

--
ROLLBACK;

--
MERGE
 INTO t1 t
USING t2 s
   ON (t.empno = s.empno)
 WHEN MATCHED THEN
      UPDATE
         SET t.sal = s.sal - 500;

--
SELECT * FROM t1;

--
UPDATE (SELECT a.sal, b.sal AS sal_n FROM t1 a, t2 b WHERE b.empno = a.empno)
   SET sal = sal_n - 500;

--
MERGE
 INTO t1 t
USING t2 s
   ON (t.empno = s.empno)
 WHEN NOT MATCHED THEN
      INSERT (t.empno, t.ename, t.job)
      VALUES (s.empno, s.ename, s.job);

--
SELECT * FROM t1;

--
INSERT INTO t1 (empno, ename, job, sal)
SELECT empno, ename, job, sal
  FROM t2 a
 WHERE NOT EXISTS (SELECT 1 FROM t1 x WHERE x.empno = a.empno);

--
MERGE
 INTO t1 t
USING t2 s
   ON (t.empno = s.empno)
 WHEN MATCHED THEN
      UPDATE
         SET t.sal = s.sal - 500
       WHERE t.job = 'CLERK';

--
SELECT * FROM t1;

--
MERGE
 INTO (SELECT * FROM t1 WHERE job = 'CLERK') t
USING t2 s
   ON (t.empno = s.empno)
 WHEN MATCHED THEN
      UPDATE
         SET t.sal = s.sal - 500;

--
MERGE
 INTO t1 t
USING t2 s
   ON (t.empno = s.empno)
 WHEN MATCHED THEN
      UPDATE
         SET t.sal = s.sal - 500
       WHERE s.job = 'CLERK';

--
SELECT * FROM t1;

--
MERGE
 INTO t1 t
USING (SELECT * FROM t2 WHERE job = 'CLERK') s
   ON (t.empno = s.empno)
 WHEN MATCHED THEN
      UPDATE
         SET t.sal = s.sal - 500;

--
MERGE
 INTO t1 t
USING t2 s
   ON (t.empno = s.empno)
 WHEN MATCHED THEN
      UPDATE
         SET t.sal = s.sal - 500
       WHERE (   (t.job =  'CLERK' AND s.sal >= 1000)
              OR (t.job != 'CLERK'));

--
SELECT * FROM t1;

--
MERGE
 INTO t1 t
USING t2 s
   ON (t.empno = s.empno)
 WHEN NOT MATCHED THEN
      INSERT (t.empno, t.ename, t.job)
      VALUES (s.empno, s.ename, s.job)
       WHERE t.job = 'CLERK';

--
MERGE
 INTO (SELECT * FROM t1 WHERE job = 'CLERK') t
USING t2 s
   ON (t.empno = s.empno)
 WHEN NOT MATCHED THEN
      INSERT (t.empno, t.ename, t.job)
      VALUES (s.empno, s.ename, s.job);

--
MERGE
 INTO t1 t
USING t2 s
   ON (t.empno = s.empno)
 WHEN NOT MATCHED THEN
      INSERT (t.empno, t.ename, t.job)
      VALUES (s.empno, s.ename, s.job)
       WHERE s.job = 'CLERK';

--
SELECT * FROM t1;

--
MERGE
 INTO t1 t
USING (SELECT * FROM t2 WHERE job = 'CLERK') s
   ON (t.empno = s.empno)
 WHEN NOT MATCHED THEN
      INSERT (t.empno, t.ename, t.job)
      VALUES (s.empno, s.ename, s.job);

--
MERGE
 INTO t1 t
USING t2 s
   ON (t.empno = s.empno)
 WHEN MATCHED THEN
      UPDATE
         SET t.sal = s.sal - 500
       WHERE t.job = 'CLERK'
      DELETE
       WHERE t.sal < 3000;

--
SELECT * FROM t1;

--
MERGE
 INTO t1 t
USING t2 s
   ON (t.empno = s.empno)
 WHEN MATCHED THEN
      UPDATE
         SET t.sal = s.sal - 500
       WHERE t.job = 'CLERK'
      DELETE
       WHERE t.sal < 3000
 WHEN NOT MATCHED THEN
      INSERT (t.empno, t.ename, t.job)
      VALUES (s.empno, s.ename, s.job)
       WHERE s.job = 'CLERK';

--
SELECT * FROM t1;

--
MERGE
 INTO t1 t
USING t4 s
   ON (t.empno = s.empno)
 WHEN MATCHED THEN
      UPDATE
         SET t.sal = s.sal - 500;

--
MERGE
 INTO t1 t
USING (SELECT *
         FROM (SELECT a.*
                    , ROW_NUMBER () OVER (PARTITION BY a.empno ORDER BY a.yyyy DESC) AS rn
                 FROM t4 a)
        WHERE rn = 1) s
   ON (t.empno = s.empno)
 WHEN MATCHED THEN
      UPDATE
         SET t.sal = s.sal - 500;

--
MERGE
 INTO t1 t
USING (SELECT empno, empno + ROW_NUMBER () OVER (ORDER BY empno) AS empno_n
         FROM t1) s
   ON (t.empno = s.empno)
 WHEN MATCHED THEN
      UPDATE
         SET t.empno = s.empno_n;

--
MERGE
 INTO t1 t
USING (SELECT empno + ROW_NUMBER () OVER (ORDER BY empno) AS empno_n FROM t1) s
   ON (t.ROWID = s.ROWID)
 WHEN MATCHED THEN
      UPDATE
         SET t.empno = s.empno_n;

--
MERGE
 INTO t1 t
USING (SELECT a.empno_n, b.ROWID AS rid
         FROM (SELECT empno, empno + ROW_NUMBER () OVER (ORDER BY empno) AS empno_n FROM t3) a
            , t1 b
        WHERE b.empno = a.empno) s
   ON (t.ROWID = s.rid)
 WHEN MATCHED THEN
      UPDATE
         SET t.empno = s.empno_n;

--
UPDATE (SELECT a.empno, b.empno_n
          FROM t1 a
             , (SELECT empno, empno + ROW_NUMBER () OVER (ORDER BY empno) AS empno_n FROM t3) b
         WHERE b.empno = a.empno)
   SET empno = empno_n;

--
MERGE
 INTO t1 t
USING t2 s
   ON (t.job = 'CLERK' AND t.empno = s.empno)
 WHEN MATCHED THEN
      UPDATE
         SET t.sal = s.sal - 500;

--
SELECT * FROM t1;

--
MERGE
 INTO (SELECT * FROM t1 WHERE job = 'CLERK') t
USING t2 s
   ON (t.empno = s.empno)
 WHEN MATCHED THEN
      UPDATE
         SET t.sal = s.sal - 500;

--
MERGE
 INTO t1 t
USING t2 s
   ON (t.empno = s.empno AND s.job = 'CLERK')
 WHEN MATCHED THEN
      UPDATE
         SET t.sal = s.sal - 500;

--
MERGE
 INTO t1 t
USING (SELECT * FROM t2 WHERE job = 'CLERK') s
   ON (t.empno = s.empno)
 WHEN MATCHED THEN
      UPDATE
         SET t.sal = s.sal - 500;

--
MERGE
 INTO t1 t
USING t2 s
   ON (t.job = 'CLERK' AND t.empno = s.empno)
 WHEN NOT MATCHED THEN
      INSERT (t.empno, t.ename, t.sal)
      VALUES (s.empno, s.ename, s.sal);

--
MERGE
 INTO t1 t
USING t2 s
   ON (t.empno = s.empno AND s.job = 'CLERK')
 WHEN NOT MATCHED THEN
      INSERT (t.empno, t.ename, t.sal)
      VALUES (s.empno, s.ename, s.sal);

--
MERGE
 INTO t1 t
USING t3 s
   ON (t.empno = s.empno(+))
 WHEN MATCHED THEN
      UPDATE
         SET t.sal = NVL (s.sal - 500, 0);

--
SELECT * FROM t1;

--
UPDATE t1 a SET sal = NVL ((SELECT x.sal FROM t3 x WHERE x.empno = a.empno) - 500, 0);

--
UPDATE (SELECT a.sal, b.sal AS sal_n FROM t1 a, t3 b WHERE b.empno(+) = a.empno)
   SET sal = NVL (sal_n - 500, 0);
