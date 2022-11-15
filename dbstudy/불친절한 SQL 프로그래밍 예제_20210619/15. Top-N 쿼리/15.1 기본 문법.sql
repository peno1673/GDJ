--
SELECT empno, sal, ROWNUM AS rn FROM emp;

--
SELECT empno, sal, ROWNUM AS rn FROM emp WHERE ROWNUM = 2;

--
SELECT empno, sal, ROWNUM AS rn FROM emp WHERE ROWNUM <= 2;

--
SELECT empno, sal, ROWNUM AS rn FROM emp WHERE ROWNUM <= 5 ORDER BY sal;

--
SELECT empno, sal, ROWNUM AS rn
  FROM (SELECT empno, sal FROM emp ORDER BY sal, empno)
 WHERE ROWNUM <= 5;

--
VAR b_pr NUMBER = 5
VAR b_pn NUMBER = 2

SELECT empno, sal, rn
  FROM (SELECT empno, sal, ROWNUM AS rn
          FROM (SELECT empno, sal FROM emp ORDER BY sal, empno)
         WHERE ROWNUM <= :b_pr * :b_pn)
 WHERE rn >= (:b_pr * (:b_pn - 1)) + 1;

--
SELECT empno, sal, rn
  FROM (SELECT empno, sal, ROWNUM AS rn
          FROM (SELECT empno, sal FROM emp ORDER BY sal, empno))
 WHERE rn BETWEEN (:b_pr * (:b_pn - 1)) + 1 AND :b_pr * :b_pn;

--
SELECT empno, sal
  FROM (SELECT empno, sal FROM emp ORDER BY DBMS_RANDOM.VALUE)
 WHERE ROWNUM <= 3;

--
SELECT empno, sal
  FROM (SELECT   empno, sal
            FROM emp -- SAMPLE BLOCK (1)
        ORDER BY ORA_HASH (empno, TO_CHAR (SYSTIMESTAMP, 'FF9')
                                , TO_CHAR (SYSTIMESTAMP, 'FF9')))
 WHERE ROWNUM <= 3;

--
SELECT NVL (MAX ('Y'), 'N') AS c1 FROM emp WHERE sal >= 3000 AND ROWNUM <= 1;

--
SELECT a.*
  FROM dept a
 WHERE EXISTS (SELECT 1
                 FROM emp x
                WHERE x.deptno = a.deptno
                  AND ROWNUM <= 1);

SELECT a.*
  FROM dept a
 WHERE EXISTS (SELECT 1
                 FROM emp x
                WHERE x.deptno = a.deptno);

--
SELECT a.deptno
     , (SELECT   x.empno
            FROM emp x
           WHERE x.deptno = a.deptno
             AND ROWNUM <= 1
        ORDER BY x.empno DESC) AS empno
  FROM dept a;

SELECT a.deptno
     , (SELECT MAX (x.empno)
          FROM emp x
         WHERE x.deptno = a.deptno) AS empno
  FROM dept a;

--
SELECT a.deptno
     , (SELECT MAX (x.empno) KEEP (DENSE_RANK FIRST ORDER BY sal DESC)
          FROM emp x
         WHERE x.deptno = a.deptno) AS empno
  FROM dept a;

--
SELECT a.deptno
     , (SELECT x.empno
          FROM (SELECT   empno, deptno
                    FROM emp
                ORDER BY sal DESC
                       , empno DESC) x
         WHERE x.deptno = a.deptno
           AND ROWNUM <= 1) AS empno
  FROM dept a;

SELECT a.deptno
     , (SELECT empno
          FROM (SELECT   x.empno, x.deptno
                    FROM emp x
                   WHERE x.deptno = a.deptno
                ORDER BY x.sal DESC
                       , x.empno DESC) x
         WHERE ROWNUM <= 1) AS empno
  FROM dept a;

--
SELECT   empno, sal, rn
    FROM (SELECT empno, sal
               , ROW_NUMBER () OVER (ORDER BY sal, empno) AS rn
            FROM emp)
   WHERE rn <= 5
ORDER BY 2, 1;

--
SELECT   empno, sal, rn
    FROM (SELECT empno, sal
               , ROW_NUMBER () OVER (ORDER BY sal, empno) AS rn
            FROM emp)
   WHERE rn BETWEEN (:b_pr * (:b_pn - 1)) + 1 AND :b_pr * :b_pn
ORDER BY 2, 1;

--
SELECT   empno, sal, rn, cn
    FROM (SELECT empno, sal
               , COUNT (*) OVER () AS cn
               , ROW_NUMBER () OVER (ORDER BY sal, empno) AS rn
            FROM emp)
   WHERE CEIL (rn / :b_pr) = :b_pn
ORDER BY 2, 1;

--
SELECT   empno, sal, pr
    FROM (SELECT empno, sal
               , PERCENT_RANK () OVER (ORDER BY sal, empno) AS pr
            FROM emp)
   WHERE pr <= 0.25
ORDER BY 2, 1;

--
SELECT   empno, sal, rk
    FROM (SELECT empno, sal
               , RANK () OVER (ORDER BY sal) AS rk
            FROM emp)
   WHERE rk <= 6
ORDER BY 2;

SELECT   empno, sal, dr
    FROM (SELECT empno, sal
               , DENSE_RANK () OVER (ORDER BY sal) AS dr
              FROM emp)
   WHERE dr <= 6
ORDER BY 2;

--
SELECT empno, sal FROM emp ORDER BY sal, empno FETCH FIRST 5 ROWS ONLY;

--
SELECT   empno, sal
    FROM emp
ORDER BY sal, empno
  OFFSET :b_pr * (:b_pn - 1) ROWS FETCH NEXT :b_pr ROWS ONLY;

--
SELECT empno, sal FROM emp ORDER BY sal, empno OFFSET 5 ROWS;

--
SELECT empno, sal FROM emp ORDER BY sal, empno FETCH FIRST 25 PERCENT ROWS ONLY;

--
SELECT empno, sal FROM emp ORDER BY sal FETCH FIRST 6 ROWS WITH TIES;
