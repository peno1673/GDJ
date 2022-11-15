--
SELECT a.deptno
     , CURSOR (SELECT x.job, x.sal, x.comm
                 FROM emp x
                WHERE x.deptno = a.deptno) AS c1
  FROM dept a;

--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (seq NUMBER, val NUMBER, rat NUMBER);

INSERT INTO t1 VALUES (1, 2000, NULL);
INSERT INTO t1 VALUES (2, NULL, 0.1);
INSERT INTO t1 VALUES (3, 3000, NULL);
INSERT INTO t1 VALUES (4, NULL, 0.2);
COMMIT;

--
CREATE OR REPLACE FUNCTION f1 (i_val IN NUMBER, i_rc IN SYS_REFCURSOR)
    RETURN NUMBER
IS
    v_val NUMBER;
    v_rat NUMBER;
    v_rst NUMBER := i_val;
BEGIN
    LOOP
        FETCH i_rc INTO v_val, v_rat;
        EXIT WHEN i_rc%NOTFOUND;

        CASE
            WHEN v_val IS NOT NULL THEN v_rst := v_rst - v_val;
            WHEN v_rat IS NOT NULL THEN v_rst := v_rst - (v_rst * v_rat);
            ELSE NULL;
        END CASE;
    END LOOP;

    CLOSE i_rc;

    RETURN v_rst;
END;
/

--
SELECT f1 (20000, CURSOR (SELECT val, rat FROM t1 ORDER BY seq)) AS c1 FROM DUAL;
