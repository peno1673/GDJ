--
SELECT * FROM dept;

--
DESC dept

--
SELECT dname, deptno FROM dept;

--
SELECT dept.dname, dept.deptno FROM dept;

--
SELECT *, deptno FROM dept;

--
SELECT dept.*, deptno FROM dept;

--
oerr ora 923

--
SELECT deptno dept_no, dname AS dept_nm, loc AS "Location" FROM dept;

--
SELECT deptno FROM emp;

SELECT DISTINCT deptno FROM emp;
