--
SELECT     LEVEL AS lv, empno, LPAD (' ', LEVEL - 1, ' ') || ename AS ename, mgr
      FROM emp
START WITH mgr IS NULL
CONNECT BY mgr = PRIOR empno
       AND empno != 7698;

--
SELECT     LEVEL AS lv, empno, LPAD (' ', LEVEL - 1, ' ') || ename AS ename, mgr
      FROM emp
     WHERE empno != 7698
START WITH mgr IS NULL
CONNECT BY mgr = PRIOR empno;

--
SELECT     LEVEL AS lv, empno, LPAD (' ', LEVEL - 1, ' ') || ename AS ename, mgr
      FROM emp
START WITH job = 'MANAGER'
CONNECT BY mgr = PRIOR empno;

--
SELECT     LEVEL AS lv, a.empno, LPAD (' ', LEVEL - 1, ' ') || a.ename AS ename, a.mgr
      FROM emps a
START WITH a.deptno = 20
       AND NOT EXISTS (SELECT 1 FROM emp x WHERE x.mgr = a.empno)
CONNECT BY a.empno = PRIOR a.mgr;

--
DROP TABLE emp_c PURGE;

CREATE TABLE emp_c AS
SELECT 1 AS compno, a.*, 1 AS pcompno FROM emp a UNION ALL
SELECT 2 AS compno, a.*, 2 AS pcompno FROM emp a;

--
SELECT compno, empno, ename, mgr, pcompno FROM emp_c;

--
SELECT     LEVEL AS lv, compno, empno, LPAD (' ', LEVEL - 1, ' ') || ename AS ename
         , mgr, pcompno
      FROM emp_c
START WITH compno = 1
       AND mgr IS NULL
CONNECT BY pcompno = PRIOR compno
       AND mgr = PRIOR empno;

--
SELECT     LEVEL AS lv, compno, empno, LPAD (' ', LEVEL - 1, ' ') || ename AS ename
         , mgr, pcompno
      FROM emp_c
START WITH compno = 1
       AND mgr IS NULL
CONNECT BY mgr = PRIOR empno;

--
DROP TABLE emp_h PURGE;

CREATE TABLE emp_h AS
SELECT '205001' AS ym, a.* FROM emp a UNION ALL
SELECT '205002' AS ym, a.* FROM emp a;

--
SELECT ym, empno, ename, mgr FROM emp_h;

--
SELECT     LEVEL AS lv, ym, empno, LPAD (' ', LEVEL - 1, ' ') || ename AS ename, mgr
      FROM emp_h
START WITH ym = '205001'
       AND mgr IS NULL
CONNECT BY ym = '205001'
       AND mgr = PRIOR empno;

--
SELECT     LEVEL AS lv, ym, empno, LPAD (' ', LEVEL - 1, ' ') || ename AS ename, mgr
      FROM (SELECT * FROM emp_h WHERE ym = '205001')
START WITH mgr IS NULL
CONNECT BY mgr = PRIOR empno;

--
SELECT   a.lv, a.empno, a.ename, b.dname
    FROM (SELECT     LEVEL AS lv, empno, LPAD (' ', LEVEL - 1, ' ') || ename AS ename
                   , deptno, ROWNUM AS rn
                FROM emp
          START WITH mgr IS NULL
          CONNECT BY mgr = PRIOR empno) a
       , dept b
   WHERE b.deptno = a.deptno
ORDER BY a.rn;

--
SELECT     LEVEL AS lv, empno, LPAD (' ', LEVEL - 1, ' ') || ename AS ename
         , deptno, dname
      FROM (SELECT a.*, b.dname
              FROM emp a, dept b
             WHERE b.deptno = a.deptno
               AND b.loc = 'NEW YORK')
START WITH mgr IS NULL
CONNECT BY mgr = PRIOR empno;

--
SELECT     LEVEL AS lv, a.empno, LPAD (' ', LEVEL - 1, ' ') || a.ename AS ename
         , a.deptno, b.dname
      FROM emp a, dept b
     WHERE b.deptno = a.deptno
START WITH a.mgr IS NULL
CONNECT BY a.mgr = PRIOR a.empno;

--
SELECT     LEVEL AS lv, a.empno, LPAD (' ', LEVEL - 1, ' ') || a.ename AS ename
         , a.deptno, b.dname
      FROM emp a
      JOIN dept b
        ON b.deptno = a.deptno
START WITH a.mgr IS NULL
CONNECT BY a.mgr = PRIOR a.empno;

--
SELECT     LEVEL AS lv, a.empno, LPAD (' ', LEVEL - 1, ' ') || a.ename AS ename
         , a.deptno, b.dname
      FROM emp a, dept b
START WITH a.mgr IS NULL
       AND b.deptno = a.deptno
CONNECT BY a.mgr = PRIOR a.empno
       AND b.deptno = a.deptno
       AND b.loc = 'DALLAS';
