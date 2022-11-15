--
SELECT ename FROM emp WHERE ename LIKE 'A%';

--
SELECT ename FROM emp WHERE ename LIKE 'A%S';

--
SELECT ename FROM emp WHERE ename LIKE '%ON%';

--
SELECT ename FROM emp WHERE ename LIKE '__M__';

--
SELECT ename FROM emp WHERE ename NOT LIKE '%A%';

--
WITH w1 AS (SELECT 'ABC' AS c1 FROM DUAL UNION ALL
            SELECT 'A%C' AS c1 FROM DUAL)
SELECT c1 FROM w1 WHERE c1 LIKE '_\%_' ESCAPE '\';

--
SELECT ename FROM emp WHERE 'AGENT SMITH' LIKE '%' || ename || '%';

--
SELECT ename FROM emp WHERE INSTR ('AGENT SMITH', ename) > 0;

--
SELECT ename, hiredate FROM emp WHERE hiredate LIKE '1980%';

--
ALTER SESSION SET NLS_DATE_FORMAT = 'MM-DD-YYYY';

--
SELECT ename, hiredate FROM emp WHERE hiredate LIKE '1980%';

--
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
