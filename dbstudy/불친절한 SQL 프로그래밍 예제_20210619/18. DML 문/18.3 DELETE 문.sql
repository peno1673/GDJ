--
DELETE FROM t1 WHERE deptno = 10;

--
SELECT * FROM t1;

--
DELETE
  FROM t1 a
 WHERE NOT EXISTS (SELECT 1 FROM emp x WHERE x.deptno = a.deptno);

--
DELETE FROM t1;

--
SELECT a.*
     , (SELECT SUM (x.comm)
          FROM emp x
         WHERE x.deptno = a.deptno)
  FROM t1 a
 WHERE EXISTS
       (SELECT 1
          FROM emp x
         WHERE x.deptno = a.deptno);

UPDATE t1 a
   SET a.sal =
       (SELECT SUM (x.sal)
          FROM emp x
         WHERE x.deptno = a.deptno)
 WHERE EXISTS
       (SELECT 1
          FROM emp x
         WHERE x.deptno = a.deptno);

--
SELECT a.*
  FROM t1 a
 WHERE NOT EXISTS
       (SELECT 1
          FROM emp x
         WHERE x.deptno = a.deptno);

DELETE
  FROM t1 a
 WHERE NOT EXISTS
       (SELECT 1
          FROM emp x
         WHERE x.deptno = a.deptno);
