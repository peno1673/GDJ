--
WITH w1 (empno, ename, mgr, lv) AS (
SELECT empno, ename, mgr, 1 AS lv
  FROM emp
 WHERE mgr IS NULL     -- START WITH 절
UNION ALL
SELECT c.empno, c.ename, c.mgr, p.lv + 1 AS lv
  FROM w1 p, emp c
 WHERE c.mgr = p.empno -- CONNECT BY 절
)
SELECT lv, empno, LPAD (' ', lv - 1, ' ') || ename AS ename, mgr FROM w1;

--
WITH w1 (empno, ename, mgr, lv) AS (
SELECT empno, ename, mgr, 1 AS lv
  FROM emp
 WHERE ename = 'ADAMS' -- START WITH 절
UNION ALL
SELECT c.empno, c.ename, c.mgr, p.lv + 1 AS lv
  FROM w1 p, emp c
 WHERE c.empno = p.mgr -- CONNECT BY 절
)
SELECT lv, empno, LPAD (' ', lv - 1, ' ') || ename AS ename, mgr FROM w1;

--
WITH w1 (empno, ename, mgr, lv, empno_p, rt, pt) AS (
SELECT empno, ename, mgr
     , 1 AS lv         -- LEVEL
     , NULL AS empno_p -- PRIOR
     , ename AS rt     -- CONNECT_BY_ROOT
     , ename AS pt     -- SYS_CONNECT_BY_PATH
  FROM emp
 WHERE mgr IS NULL
UNION ALL
SELECT c.empno, c.ename, c.mgr
     , p.lv + 1 AS lv               -- LEVEL
     , p.empno AS empno_p           -- PRIOR
     , p.rt                         -- CONNECT_BY_ROOT
     , p.pt || ',' || c.ename AS pt -- SYS_CONNECT_BY_PATH
  FROM w1 p, emp c
 WHERE c.mgr = p.empno)
SEARCH DEPTH FIRST BY empno SET so
SELECT   lv, empno, LPAD (' ', lv - 1, ' ') || ename AS ename, mgr, empno_p, rt, pt
       , CASE WHEN lv - LEAD (lv) OVER (ORDER BY so) < 0
              THEN 0
              ELSE 1
         END AS lf -- CONNECT_BY_ISLEAF
    FROM w1
ORDER BY so;

--
WITH w1 (empno, ename, mgr, lv) AS (
SELECT empno, ename, mgr, 1 AS lv FROM emp WHERE mgr IS NULL
UNION ALL
SELECT c.empno, c.ename, c.mgr, p.lv + 1 AS lv
  FROM w1 p, emp c
 WHERE c.mgr = p.empno)
SEARCH BREADTH FIRST BY empno SET so
SELECT   lv, empno, LPAD (' ', lv - 1, ' ') || ename AS ename, mgr, so
    FROM w1
ORDER BY so;

--
WITH w1 (empno, ename, mgr, lv) AS (
SELECT empno, ename, mgr, 1 AS lv FROM emp WHERE mgr IS NULL
UNION ALL
SELECT c.empno, c.ename, c.mgr, p.lv + 1 AS lv
  FROM w1 p, emp c
 WHERE c.mgr = p.empno)
SEARCH DEPTH FIRST BY empno SET so
SELECT   lv, empno, LPAD (' ', lv - 1, ' ') || ename AS ename, mgr, so
    FROM w1
ORDER BY so;

--
WITH w1 (empno, ename, mgr, lv) AS (
SELECT empno, ename, mgr, 1 AS lv FROM emp_l WHERE empno = 7839
UNION ALL
SELECT c.empno, c.ename, c.mgr, p.lv + 1 AS lv
  FROM w1 p, emp_l c
 WHERE c.mgr = p.empno)
SEARCH DEPTH FIRST BY empno SET so
 CYCLE empno SET ic TO '1' DEFAULT '0'
SELECT   lv, empno, LPAD (' ', lv - 1, ' ') || ename AS ename, mgr, ic
    FROM w1
ORDER BY so;

--
WITH w1 (empno, ename, mgr, deptno, lv) AS (
SELECT empno, ename, mgr, deptno, 1 AS lv FROM emp WHERE mgr IS NULL
UNION ALL
SELECT c.empno, c.ename, c.mgr, c.deptno, p.lv + 1 AS lv
  FROM w1 p, emp c
 WHERE c.mgr = p.empno)
SEARCH DEPTH FIRST BY empno SET so
 CYCLE deptno SET ic TO '1' DEFAULT '0'
SELECT   lv, empno, LPAD (' ', lv - 1, ' ') || ename AS ename, mgr, deptno, ic
    FROM w1
ORDER BY so;
