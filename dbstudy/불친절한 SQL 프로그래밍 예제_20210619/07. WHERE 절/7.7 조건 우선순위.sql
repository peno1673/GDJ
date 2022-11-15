--
SELECT ename, deptno, job
  FROM emp
 WHERE deptno = 10
    OR deptno = 20
   AND job = 'CLERK';

SELECT ename, deptno, job
  FROM emp
 WHERE deptno = 10
    OR (    deptno = 20
        AND job = 'CLERK');

--
SELECT ename, deptno, job
  FROM emp
 WHERE job = 'CLERK'
   AND deptno = 10
    OR deptno = 20;

SELECT ename, deptno, job
  FROM emp
 WHERE (    job = 'CLERK'
        AND deptno = 10)
    OR deptno = 20;

--
SELECT ename, deptno, job
  FROM emp
 WHERE job = 'CLERK'
   AND (   deptno = 10
        OR deptno = 20);

SELECT ename, deptno, job
  FROM emp
 WHERE job = 'CLERK'
   AND deptno IN (10, 20);

--
SELECT ename, deptno, job
  FROM emp
 WHERE job = 'CLERK'
   AND NOT deptno IN (10, 20);

SELECT ename, deptno, job
  FROM emp
 WHERE job = 'CLERK'
   AND deptno NOT IN (10, 20);
