--
SELECT ename, comm FROM emp WHERE comm IS NULL;

--
SELECT ename, comm FROM emp WHERE comm IS NOT NULL;

--
SELECT ename, comm FROM emp WHERE (comm IS NULL OR comm = 0);

--
SELECT ename, comm FROM emp WHERE NVL (comm, 0) = 0;

--
SELECT ename, comm FROM emp WHERE NVL (comm, 0) > 0;

--
SELECT ename, comm FROM emp WHERE comm > 0;

--
SELECT ename, comm FROM emp WHERE LNNVL (comm != 0);

--
SELECT ename, comm FROM emp WHERE (comm IS NULL OR comm = 0);
