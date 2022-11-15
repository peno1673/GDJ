--
SELECT ename, sal FROM emp WHERE sal BETWEEN 2500 AND 3000;

--
SELECT ename, sal FROM emp WHERE sal >= 2500 AND sal <= 3000;

--
SELECT ename, sal FROM emp WHERE sal NOT BETWEEN 2500 AND 3000;

--
SELECT * FROM salgrade WHERE 1500 BETWEEN losal AND hisal;

--
SELECT * FROM salgrade WHERE losal <= 1500 AND hisal >= 1500;
