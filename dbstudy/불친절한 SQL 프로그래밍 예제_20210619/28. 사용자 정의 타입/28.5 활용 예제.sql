--
CREATE OR REPLACE TYPE trc_emp1 AS OBJECT (sal NUMBER (7,2), comm NUMBER (7,2));
/

--
SELECT   a.deptno, a.dname, a.emp_rc.sal AS sal, a.emp_rc.comm AS comm
    FROM (SELECT a.*
               , (SELECT trc_emp1 (SUM (x.sal), SUM (x.comm))
                    FROM emp x
                   WHERE x.deptno = a.deptno) AS emp_rc
            FROM dept a) a
ORDER BY 1;

--
CREATE OR REPLACE TYPE trc_emp2 AS OBJECT (job VARCHAR2(9), sal NUMBER(7,2), comm NUMBER(7,2));
/

CREATE OR REPLACE TYPE tnt_emp2 IS TABLE OF trc_emp2;
/

--
SELECT   a.deptno, a.dname, b.job, b.sal, b.comm
    FROM (SELECT a.*
               , CAST (MULTISET (SELECT   x.job, SUM (x.sal), SUM (x.comm)
                                     FROM emp x
                                    WHERE x.deptno = a.deptno
                                 GROUP BY x.job) AS tnt_emp2) AS emp_nt
            FROM dept a) a
       , TABLE (a.emp_nt) b
ORDER BY 1, 3;
