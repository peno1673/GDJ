--
DROP SEQUENCE s1;
CREATE SEQUENCE s1 MINVALUE 1 MAXVALUE 999 SCALE EXTEND;

--
SELECT min_value, max_value, scale_flag, extend_flag
  FROM user_sequences
 WHERE sequence_name = 'S1';

--
SELECT SYS_CONTEXT ('USERENV', 'INSTANCE') AS inst, SYS_CONTEXT ('USERENV', 'SID') AS sid
  FROM DUAL;

--
SELECT s1.NEXTVAL AS c1 FROM DUAL;

SELECT s1.NEXTVAL AS c1 FROM DUAL;

--
DROP SEQUENCE s2;
CREATE SEQUENCE s2 MINVALUE 1 MAXVALUE 999 SCALE;

--
SELECT s2.NEXTVAL AS c1 FROM DUAL;

--
DROP SEQUENCE s3;
CREATE SEQUENCE s3 MINVALUE 1 MAXVALUE 9999999 SCALE;

--
SELECT s3.NEXTVAL AS c1 FROM DUAL;

SELECT s3.NEXTVAL AS c1 FROM DUAL;

--
SELECT s3.NEXTVAL AS c1 FROM DUAL;

--
DROP SEQUENCE s4;
CREATE SEQUENCE s4 MINVALUE 1 MAXVALUE 999;

--
CREATE OR REPLACE FUNCTION fn_ss (
    i_owner IN VARCHAR2                   -- ½ÃÄö½º ¼ÒÀ¯ÀÚ
  , i_name  IN VARCHAR2                   -- ½ÃÄö½º ¸í
  , i_val   IN VARCHAR2 DEFAULT 'NEXTVAL' -- ½ÃÄö½º ½´µµ Ä®·³(CURRVAL, NEXTVAL)
  , i_len   IN NUMBER   DEFAULT 1e28      -- ½ÃÄö½º ±æÀÌ
)
    RETURN NUMBER
IS
    v_max_val NUMBER;
    v_val     NUMBER;
BEGIN
    EXECUTE IMMEDIATE 'SELECT ' || i_owner || '.' || i_name || '.' || i_val || ' FROM DUAL'
                 INTO v_val;

    RETURN ((1e5
           + MOD (SYS_CONTEXT ('USERENV', 'INSTANCE'), 100) * 1e3
           + MOD (SYS_CONTEXT ('USERENV', 'SID'), 1000)) * i_len) + v_val;
END;
/

--
SELECT fnc_ss ('SCOTT', 'S4', 'NEXTVAL', 1e3) AS c1 FROM DUAL;
