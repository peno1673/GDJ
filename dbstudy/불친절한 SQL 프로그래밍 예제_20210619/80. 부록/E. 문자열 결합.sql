--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 NUMBER);

INSERT INTO t1 VALUES (1, 1);
INSERT INTO t1 VALUES (2, 1);
INSERT INTO t1 VALUES (2, 2);
INSERT INTO t1 VALUES (3, 2);
INSERT INTO t1 VALUES (3, 1);
INSERT INTO t1 VALUES (3, 1);
COMMIT;

--
SELECT     c1, LTRIM (MAX (SYS_CONNECT_BY_PATH (c2, ',')), ',') AS c2
      FROM (SELECT c1, c2, ROW_NUMBER () OVER (PARTITION BY c1 ORDER BY c2) AS rn FROM t1)
START WITH rn = 1
CONNECT BY c1 = PRIOR c1
       AND rn - 1 = PRIOR rn
  GROUP BY c1
  ORDER BY c1;

--
SELECT   c1
       , LTRIM (XMLAGG (XMLELEMENT (x, ',', c2)
                        ORDER BY c2).EXTRACT ('//text()').GETSTRINGVAL (), ',') AS c2
       , LTRIM (XMLAGG (XMLELEMENT (x, ',', c2)
                        ORDER BY c2).EXTRACT ('//text()').GETCLOBVAL ()  , ',') AS c3
    FROM t1
GROUP BY c1;

--
SELECT   c1, LISTAGG (c2, ',') WITHIN GROUP (ORDER BY c2) AS c2
    FROM t1
GROUP BY c1;

--
SELECT   c1
       , REGEXP_REPLACE (JSON_ARRAYAGG (c2 ORDER BY c2 RETURNING VARCHAR2(4000))
                       , '\[|"|\]') AS c2
       , REGEXP_REPLACE (JSON_ARRAYAGG (c2 ORDER BY c2 RETURNING CLOB)
                       , '\[|"|\]') AS c3
    FROM t1
GROUP BY c1;

--
CREATE OR REPLACE TYPE t_stragg AS OBJECT (
    g_str VARCHAR2 (32767)
  , STATIC FUNCTION odciaggregateinitialize (sctx IN OUT t_stragg)
        RETURN NUMBER
  , MEMBER FUNCTION odciaggregateiterate (self IN OUT t_stragg, value IN VARCHAR2)
        RETURN NUMBER
  , MEMBER FUNCTION odciaggregateterminate (
        self IN t_stragg, returnvalue OUT VARCHAR2, flags IN NUMBER
    )
        RETURN NUMBER
  , MEMBER FUNCTION odciaggregatemerge (self IN OUT t_stragg, sctx2 IN t_stragg)
        RETURN NUMBER
);
/

--
CREATE OR REPLACE TYPE BODY t_stragg
IS
    STATIC FUNCTION odciaggregateinitialize (sctx IN OUT t_stragg)
        RETURN NUMBER
    IS
    BEGIN
        sctx := t_stragg (NULL);
        RETURN ODCICONST.SUCCESS;
    END;

    MEMBER FUNCTION odciaggregateiterate (self IN OUT t_stragg, value IN VARCHAR2)
        RETURN NUMBER
    IS
    BEGIN
        IF g_str IS NOT NULL THEN
            g_str := g_str || ',' || value;
        ELSE
            g_str := value;
        END IF;

        RETURN ODCICONST.SUCCESS;
    END;

    MEMBER FUNCTION odciaggregateterminate (
        self IN t_stragg, returnvalue OUT VARCHAR2, flags IN NUMBER)
        RETURN NUMBER
    IS
    BEGIN
        returnvalue := g_str;
        RETURN ODCICONST.SUCCESS;
    END;

    MEMBER FUNCTION odciaggregatemerge (self IN OUT t_stragg, sctx2 IN t_stragg)
        RETURN NUMBER
    IS
    BEGIN
        IF sctx2.g_str IS NOT NULL THEN
            self.g_str := self.g_str || ',' || sctx2.g_str;
        END IF;

        RETURN ODCICONST.SUCCESS;
    END;
END;
/

--
CREATE OR REPLACE FUNCTION stragg (i_value IN VARCHAR2) RETURN VARCHAR2
PARALLEL_ENABLE AGGREGATE USING t_stragg;
/

--
SELECT c1, stragg (c2) AS c2 FROM t1 GROUP BY c1;

--
SELECT c1, stragg (DISTINCT c2) AS c2 FROM t1 GROUP BY c1;

--
SELECT   c1
       , REGEXP_REPLACE (LISTAGG (c2, ',') WITHIN GROUP (ORDER BY c2), '([^,]+),\1', '\1') AS c2
    FROM t1
GROUP BY c1;

--
SELECT c1, stragg (c2) KEEP (DENSE_RANK FIRST ORDER BY c2) AS c2 FROM t1 GROUP BY c1;

--
SELECT c1, c2, stragg (c2) OVER (PARTITION BY c1 ORDER BY c2) AS c3 FROM t1;

--
SELECT c1, c2, LISTAGG (c2, ',') WITHIN GROUP (ORDER BY c2) OVER (PARTITION BY c1) AS c3
  FROM t1;

--
SELECT   c1, MAX (c2) AS c2
    FROM (SELECT c1, stragg (c2) OVER (PARTITION BY c1 ORDER BY c2) AS c2 FROM t1)
GROUP BY c1;

--
WITH w1 AS (SELECT 'X' AS c1 FROM DUAL CONNECT BY LEVEL <= 16385)
SELECT LENGTH (stragg (c1)) AS c1 FROM w1;

--
CREATE OR REPLACE TYPE t_clobagg AS OBJECT (
    g_clob CLOB
  , STATIC FUNCTION odciaggregateinitialize (sctx IN OUT t_clobagg)
        RETURN NUMBER
  , MEMBER FUNCTION odciaggregateiterate (self IN OUT t_clobagg, value IN CLOB)
        RETURN NUMBER
  , MEMBER FUNCTION odciaggregateterminate (
        self IN t_clobagg, returnvalue OUT CLOB, flags IN NUMBER)
        RETURN NUMBER
  , MEMBER FUNCTION odciaggregatemerge (self IN OUT t_clobagg, ctx2 IN t_clobagg)
        RETURN NUMBER
);
/

--
CREATE OR REPLACE TYPE BODY t_clobagg
IS
    STATIC FUNCTION odciaggregateinitialize (sctx IN OUT t_clobagg)
        RETURN NUMBER
    IS
        v_clob CLOB;
    BEGIN
        DBMS_LOB.CREATETEMPORARY (v_clob, TRUE, DBMS_LOB.CALL);
        sctx := t_clobagg (v_clob);
        RETURN ODCICONST.SUCCESS;
    END;

    MEMBER FUNCTION odciaggregateiterate (self IN OUT t_clobagg, value IN CLOB)
        RETURN NUMBER
    IS
    BEGIN
        IF DBMS_LOB.GETLENGTH (self.g_clob) > 0 THEN
            DBMS_LOB.APPEND (self.g_clob, ',');
        END IF;

        DBMS_LOB.APPEND (self.g_clob, value);
        RETURN ODCICONST.SUCCESS;
    END;

    MEMBER FUNCTION odciaggregateterminate (
        self IN t_clobagg, returnvalue OUT CLOB, flags IN NUMBER)
        RETURN NUMBER
    IS
    BEGIN
        returnvalue := self.g_clob;
        RETURN ODCICONST.SUCCESS;
    END;

    MEMBER FUNCTION odciaggregatemerge (self IN OUT t_clobagg, ctx2 IN t_clobagg)
        RETURN NUMBER
    IS
    BEGIN
        DBMS_LOB.APPEND (self.g_clob, ctx2.g_clob);
        RETURN ODCICONST.SUCCESS;
    END;
END;
/

--
CREATE OR REPLACE FUNCTION clobagg (i_value IN VARCHAR2) RETURN CLOB
PARALLEL_ENABLE AGGREGATE USING t_clobagg;
/

--
WITH w1 AS (SELECT 'X' AS c1 FROM DUAL CONNECT BY LEVEL <= 16385)
SELECT LENGTH (clobagg (c1)) AS c1 FROM w1;
