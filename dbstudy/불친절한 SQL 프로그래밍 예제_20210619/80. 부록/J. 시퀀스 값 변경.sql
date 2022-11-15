--
DROP SEQUENCE s1;
CREATE SEQUENCE s1;

--
CREATE OR REPLACE PROCEDURE prc_chg_seq (
    i_owner IN VARCHAR2
  , i_name  IN VARCHAR2
  , i_val   IN NUMBER
)
IS
    v_seq VARCHAR2 (100) := i_owner || '.' || i_name;
    v_ibc NUMBER;
    v_ibn NUMBER;
    v_nv  NUMBER;
BEGIN
    EXECUTE IMMEDIATE 'SELECT ' || i_val || ' - ' || v_seq || '.NEXTVAL - 1 FROM DUAL'
                 INTO v_ibn;

    IF v_ibn != 0 THEN
        SELECT increment_by
          INTO v_ibc
          FROM alv_sequences
         WHERE sequence_owner = i_owner
           AND sequence_name = i_name;

        EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || v_seq || ' INCREMENT BY '
                       || v_ibn || CASE i_val WHEN 1 THEN ' MINVALUE 0' END;
        EXECUTE IMMEDIATE 'SELECT ' || v_seq || '.NEXTVAL FROM DUAL' INTO v_nv;
        EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || v_seq || ' INCREMENT BY ' || v_ibc;
    END IF;
END;
/

--
SELECT s1.NEXTVAL AS s1 FROM DUAL;

--
EXEC prc_chg_seq ('SCOTT', 'S1', 100)

SELECT s1.NEXTVAL AS s1 FROM DUAL;

--
EXEC prc_chg_seq ('SCOTT', 'S1', 200)

SELECT s1.NEXTVAL AS s1 FROM DUAL;

--
EXEC prc_chg_seq ('SCOTT', 'S1', 100)

SELECT s1.NEXTVAL AS s1 FROM DUAL;

--
EXEC prc_chg_seq ('SCOTT', 'S1', 1)

SELECT s1.NEXTVAL AS s1 FROM DUAL;

--
SELECT min_value
  FROM all_sequences
 WHERE sequence_owner = 'SCOTT'
   AND sequence_name = 'S1';
