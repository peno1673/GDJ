--
WITH w1 AS (SELECT deptno, SUM (sal) AS sal FROM emp GROUP BY deptno)
SELECT a.deptno, b.dname, a.sal
  FROM w1 a, dept b
 WHERE b.deptno = a.deptno;

--
SELECT a.deptno, b.dname, a.sal
  FROM (SELECT deptno, SUM (sal) AS sal FROM emp GROUP BY deptno) a
     , dept b
 WHERE b.deptno = a.deptno;

--
WITH w1 AS (SELECT deptno, SUM (sal) AS sal FROM emp GROUP BY deptno)
   , w2 AS (SELECT SUM (sal) AS sal FROM w1)
SELECT a.deptno, a.dname, b.sal, (b.sal / c.sal) * 100 AS rt
  FROM dept a, w1 b, w2 c
 WHERE b.deptno = a.deptno;

--
WITH w1 AS (SELECT * FROM DUAL) SELECT * FROM DUAL;

--
WITH
    FUNCTION f1 (i_val IN VARCHAR2) RETURN NUMBER IS
        l_val NUMBER;
    BEGIN
        EXECUTE IMMEDIATE 'SELECT ' || i_val || ' FROM DUAL' INTO l_val;
        RETURN l_val;
    END;
SELECT f1 ('((1 + 2) * 3) / 4') AS c1 FROM DUAL;
/
