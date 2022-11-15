--
CREATE OR REPLACE FUNCTION fnc_raw (i_typ IN VARCHAR2, i_val IN RAW)
    RETURN VARCHAR2
IS
    FUNCTION f1 (i_val IN RAW)
        RETURN DATE
    IS
        v_val DATE;
    BEGIN
        DBMS_STATS.CONVERT_RAW_VALUE (i_val, v_val);
        RETURN v_val;
    END;
BEGIN
    RETURN
        CASE
            WHEN i_val IS NULL           THEN NULL
            WHEN i_typ = 'CHAR'          THEN TO_CHAR (UTL_RAW.CAST_TO_VARCHAR2      (i_val))
            WHEN i_typ = 'VARCHAR2'      THEN TO_CHAR (UTL_RAW.CAST_TO_VARCHAR2      (i_val))
            WHEN i_typ = 'NVARCHAR2'     THEN TO_CHAR (UTL_RAW.CAST_TO_NVARCHAR2     (i_val))
            WHEN i_typ = 'NUMBER'        THEN TO_CHAR (UTL_RAW.CAST_TO_NUMBER        (i_val))
            WHEN i_typ = 'BINARY_FLOAT'  THEN TO_CHAR (UTL_RAW.CAST_TO_BINARY_FLOAT  (i_val))
            WHEN i_typ = 'BINARY_DOUBLE' THEN TO_CHAR (UTL_RAW.CAST_TO_BINARY_DOUBLE (i_val))
            WHEN i_typ = 'DATE'          THEN TO_CHAR (f1 (i_val), 'YYYY-MM-DD HH24:MI:SS')
            WHEN i_typ LIKE 'TIMESTAMP%' THEN TO_CHAR (f1 (i_val), 'YYYY-MM-DD HH24:MI:SS')
            ELSE NULL
        END;
END;
/

--
SELECT   column_name, data_type, low_value, fnc_raw (data_type, low_value) AS c1
    FROM user_tab_columns a
   WHERE table_name = 'EMP'
ORDER BY column_id;
