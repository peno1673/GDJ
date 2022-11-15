--
SELECT     LEVEL AS lv, empno, LPAD (' ', LEVEL - 1, ' ') || ename AS ename, mgr
         , PRIOR empno AS empno_p
      FROM emp
START WITH mgr IS NULL       -- mgr가 존재하지 않는 행
CONNECT BY mgr = PRIOR empno -- mgr가 부모 노드의 empno인 행
;

--
SELECT     LEVEL AS lv, empno, LPAD (' ', LEVEL - 1, ' ') || ename AS ename, mgr
         , CONNECT_BY_ROOT ename AS rt
         , CONNECT_BY_ISLEAF AS lf
         , SYS_CONNECT_BY_PATH (ename, ',') AS pt
      FROM emp
START WITH mgr IS NULL
CONNECT BY mgr = PRIOR empno;

--
SELECT 1 AS lv, empno, ename, mgr
  FROM emp
 WHERE mgr IS NULL -- START WITH mgr IS NULL
;

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 AS SELECT 1 AS lv, empno, ename, mgr FROM emp WHERE mgr IS NULL;

--
SELECT 2 AS lv, c.empno, c.ename, c.mgr
  FROM t1 p, emp c
 WHERE p.lv = 1
   AND c.mgr = p.empno -- CONNECT BY mgr = PRIOR empno
;

--
INSERT INTO t1
SELECT 2, c.empno, c.ename, c.mgr FROM t1 p, emp c WHERE p.lv = 1 AND c.mgr = p.empno;

--
SELECT 3 AS lv, c.empno, c.ename, c.mgr
  FROM t1 p, emp c
 WHERE p.lv = 2
   AND c.mgr = p.empno;

--
INSERT INTO t1
SELECT 3, c.empno, c.ename, c.mgr FROM t1 p, emp c WHERE p.lv = 2 AND c.mgr = p.empno;

--
SELECT 4 AS lv, c.empno, c.ename, c.mgr
  FROM t1 p, emp c
 WHERE p.lv = 3
   AND c.mgr = p.empno;

--
INSERT INTO t1
SELECT 4, c.empno, c.ename, c.mgr FROM t1 p, emp c WHERE p.lv = 3 AND c.mgr = p.empno;

--
SELECT 5 AS lv, c.empno, c.ename, c.mgr
  FROM t1 p, emp c
 WHERE p.lv = 4
   AND c.mgr = p.empno;

--
SELECT * FROM t1;

--
SELECT     LEVEL AS lv, empno, LPAD (' ', LEVEL - 1, ' ') || ename AS ename, mgr
      FROM emp
START WITH mgr IS NULL
CONNECT BY mgr = PRIOR empno;

--
SELECT     LEVEL AS lv, empno, LPAD (' ', LEVEL - 1, ' ') || ename AS ename, mgr
      FROM emp
START WITH ename = 'ADAMS'
CONNECT BY empno = PRIOR mgr;

--
SELECT     LEVEL AS lv, empno, LPAD (' ', LEVEL - 1, ' ') || ename AS ename, mgr, sal
      FROM emp
START WITH mgr IS NULL
CONNECT BY mgr = PRIOR empno
  ORDER BY sal;

--
SELECT     LEVEL AS lv, empno, LPAD (' ', LEVEL - 1, ' ') || ename AS ename, mgr, sal
      FROM emp
START WITH mgr IS NULL
CONNECT BY mgr = PRIOR empno
     ORDER SIBLINGS BY sal;

--
DROP TABLE emp_l PURGE;
CREATE TABLE emp_l AS SELECT empno, ename, NVL (mgr, 7788) AS mgr FROM emp;

--
SELECT empno, ename, mgr FROM emp_l;

--
SELECT     LEVEL AS lv, empno, LPAD (' ', LEVEL - 1, ' ') || ename AS ename, mgr
      FROM emp_l
START WITH empno = 7839
CONNECT BY mgr = PRIOR empno;

--
SELECT     LEVEL AS lv, empno, LPAD (' ', LEVEL - 1, ' ') || ename AS ename, mgr
         , CONNECT_BY_ISCYCLE AS ic
      FROM emp_l
START WITH empno = 7839
CONNECT BY NOCYCLE mgr = PRIOR empno;
