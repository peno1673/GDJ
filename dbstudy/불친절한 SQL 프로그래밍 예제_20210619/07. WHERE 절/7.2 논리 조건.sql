--
SELECT ename, deptno, job FROM emp WHERE deptno = 30 AND job = 'CLERK';

--
SELECT ename, deptno, job FROM emp WHERE deptno = 30 OR job = 'CLERK';

--
SELECT ename, deptno, job FROM emp WHERE NOT (deptno = 30 OR job = 'CLERK');

--
SELECT ename, deptno, job FROM emp WHERE deptno != 30 AND job != 'CLERK';
