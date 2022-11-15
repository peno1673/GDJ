--
SELECT ename, sal FROM emp WHERE deptno = 30 ORDER BY sal;

--
SELECT ename, sal, empno FROM emp WHERE deptno = 30 ORDER BY sal, empno;

--
SELECT ename, sal FROM emp WHERE deptno = 30 ORDER BY sal DESC;

--
SELECT ename, sal, comm FROM emp WHERE deptno = 30 ORDER BY sal DESC, comm;

--
SELECT ename, sal, comm FROM emp WHERE deptno = 30 ORDER BY 2 DESC, 3;

--
SELECT ename, sal, comm FROM emp WHERE deptno = 30 ORDER BY 2 DESC, comm;

--
SELECT   ename, TO_CHAR (hiredate, 'YYYY') AS hireyear, sal
    FROM emp
   WHERE deptno = 20
ORDER BY 2, sal;

--
SELECT   ename, TO_CHAR (hiredate, 'YYYY') AS hireyear, sal
    FROM emp
   WHERE deptno = 20
ORDER BY TO_CHAR (hiredate, 'YYYY'), sal;

--
SELECT   ename, TO_CHAR (sal, 'FM999,999') AS sal
    FROM emp
   WHERE deptno = 20
ORDER BY sal;

--
SELECT   ename, TO_CHAR (sal, 'FM999,999') AS sal
    FROM emp
   WHERE deptno = 20
ORDER BY emp.sal;

--
SELECT ename, comm FROM emp WHERE deptno = 30 ORDER BY comm;

--
SELECT ename, comm FROM emp WHERE deptno = 30 ORDER BY comm NULLS FIRST;

--
SELECT ename, comm FROM emp WHERE deptno = 30 ORDER BY comm DESC;

--
SELECT ename, comm FROM emp WHERE deptno = 30 ORDER BY comm DESC NULLS LAST;

--
SELECT ename, deptno, 'A' AS c1 FROM emp WHERE deptno = 10 ORDER BY deptno, c1, ename;

--
SELECT ename, deptno, 'A' AS c1 FROM emp WHERE deptno = 10 ORDER BY ename;
