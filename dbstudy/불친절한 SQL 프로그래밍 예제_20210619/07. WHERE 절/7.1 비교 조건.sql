--
SELECT ename, job FROM emp WHERE job = 'ANALYST';

--
SELECT ename, sal FROM emp WHERE sal > 2500;

--
SELECT ename, hiredate FROM emp WHERE hiredate < DATE '1981-01-01';

--
SELECT ename, comm FROM emp WHERE comm = NULL;

--
SELECT ename, comm FROM emp WHERE comm != 0;

--
SELECT ename, sal FROM emp WHERE sal > ANY (1000, 2500);

--
SELECT ename, sal FROM emp WHERE sal > LEAST (1000, 2500);

--
SELECT ename, sal FROM emp WHERE sal > ALL (1000, 2500);

--
SELECT ename, sal FROM emp WHERE sal > GREATEST (1000, 2500);

--
SELECT * FROM emp WHERE empno = 'SMITH';

SELECT * FROM emp WHERE ename = 7369;
