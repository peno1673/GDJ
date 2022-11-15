--
oerr

--
where oerr

--
oerr ora 1

--
DROP DIRECTORY dir_mesg;

CREATE OR REPLACE DIRECTORY dir_mesg AS 'C:\app\ora12cr2\product\12.2.0\dbhome_1\rdbms\mesg';

DROP TABLE ext_oraus PURGE;

CREATE TABLE ext_oraus (line NUMBER, text VARCHAR2(4000))
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY dir_mesg
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        NOBADFILE NOLOGFILE NODISCARDFILE
        FIELDS TERMINATED BY '!@#' (
            line    RECNUM,
            text    POSITION(1:4000))
    )
    LOCATION ('oraus.msg')
) REJECT LIMIT UNLIMITED;

--
CREATE OR REPLACE PACKAGE pkg_oerr
IS
    TYPE trd_oerr IS RECORD (code NUMBER, message VARCHAR2 (4000));
    TYPE tnt_oerr IS TABLE OF trd_oerr;
    TYPE trd_oerr_text IS RECORD (code NUMBER, line NUMBER, text VARCHAR2 (4000));
    TYPE tnt_oerr_text IS TABLE OF trd_oerr_text;
    FUNCTION fnc_oerr RETURN tnt_oerr PIPELINED;
    FUNCTION fnc_oerr_text RETURN tnt_oerr_text PIPELINED;
END;
/

CREATE OR REPLACE PACKAGE BODY pkg_oerr
IS
    FUNCTION fnc_oerr
        RETURN tnt_oerr PIPELINED
    IS
        v_oerr trd_oerr;
    BEGIN
        FOR c1 IN (SELECT TO_NUMBER (REGEXP_SUBSTR (text, '^[0-9]+')) AS code
                        , REGEXP_SUBSTR (text, '"(.+)"', 1, 1, 'i', 1) AS message
                     FROM ext_oraus
                    WHERE REGEXP_LIKE (text, '^[0-9].+'))
        LOOP
            v_oerr := c1;
            PIPE ROW (v_oerr);
        END LOOP;
    END;

    FUNCTION fnc_oerr_text
        RETURN tnt_oerr_text PIPELINED
    IS
        v_oerr_text trd_oerr_text;
    BEGIN
        FOR c1 IN (SELECT TO_NUMBER (REGEXP_SUBSTR (text, '^[0-9]+')) AS code
                        , SUBSTR (text, 4) AS text
                     FROM ext_oraus
                    WHERE REGEXP_LIKE (text, '^[0-9].+')
                       OR REGEXP_LIKE (text, '^//.+'))
        LOOP
            CASE
                WHEN c1.code IS NOT NULL
                THEN
                    v_oerr_text.code := c1.code;
                    v_oerr_text.line := 0;
                ELSE
                    v_oerr_text.line := v_oerr_text.line + 1;
                    v_oerr_text.text := c1.text;
                    PIPE ROW (v_oerr_text);
            END CASE;
        END LOOP;
    END;
END;
/

--
DROP TABLE t_oerr PURGE;
DROP TABLE t_oerr_text PURGE;

CREATE TABLE t_oerr AS SELECT * FROM TABLE (pkg_oerr.fnc_oerr);
CREATE TABLE t_oerr_text AS SELECT * FROM TABLE (pkg_oerr.fnc_oerr_text);

ALTER TABLE t_oerr ADD CONSTRAINT t_oerr_pk PRIMARY KEY (code);
ALTER TABLE t_oerr_text ADD CONSTRAINT t_oerr_text_pk PRIMARY KEY (code, line);

--
SELECT message FROM t_oerr WHERE code = 1;

--
SELECT text FROM t_oerr_text WHERE code = 1 ORDER BY line;
