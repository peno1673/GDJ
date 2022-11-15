--
SELECT deptno FROM dept;
SELECT deptno FROM scott.dept;
SELECT dept.deptno FROM dept;
SELECT dept.deptno FROM scott.dept;

SELECT scott.dept.deptno FROM scott.dept;

--
SELECT a.deptno FROM dept a;

--
SELECT dept.deptno FROM dept a;

--
SELECT * FROM dept, emp WHERE deptno = deptno;

--
SELECT * FROM dept, emp WHERE emp.deptno = dept.deptno;

--
SELECT * FROM dept a, emp b WHERE b.deptno = a.deptno;

--
SELECT * FROM dept SAMPLE (30);
