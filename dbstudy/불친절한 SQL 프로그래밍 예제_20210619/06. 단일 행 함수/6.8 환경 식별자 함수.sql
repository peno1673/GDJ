--
SELECT USER AS c1 FROM DUAL;

--
SELECT UID AS c1 FROM DUAL;

--
SELECT username, user_id FROM user_users;

--
SELECT SYS_GUID () AS c1 FROM DUAL;

--
SELECT USERENV ('ISDBA')    AS c1, USERENV ('CLIENT_INFO') AS c2
     , USERENV ('TERMINAL') AS c3, USERENV ('LANG')        AS c4
     , USERENV ('LANGUAGE') AS c5
  FROM DUAL;

--
SELECT SYS_CONTEXT ('USERENV', 'SERVER_HOST') AS c1
     , SYS_CONTEXT ('USERENV', 'IP_ADDRESS')  AS c2
  FROM DUAL;

--
SELECT SYS_CONTEXT ('USERENV', 'DB_UNIQUE_NAME') AS c1
     , SYS_CONTEXT ('USERENV', 'DB_NAME')        AS c2
     , SYS_CONTEXT ('USERENV', 'DB_DOMAIN')      AS c3
     , SYS_CONTEXT ('USERENV', 'INSTANCE')       AS c4
     , SYS_CONTEXT ('USERENV', 'INSTANCE_NAME')  AS c5
  FROM DUAL;

--
SELECT SYS_CONTEXT ('USERENV', 'HOST')                AS c1
     , SYS_CONTEXT ('USERENV', 'OS_USER')             AS c2
     , SYS_CONTEXT ('USERENV', 'TERMINAL')            AS c3
     , SYS_CONTEXT ('USERENV', 'CLIENT_PROGRAM_NAME') AS c4
  FROM DUAL;

--
SELECT SYS_CONTEXT ('USERENV', 'SID')            AS c1
     , SYS_CONTEXT ('USERENV', 'SESSION_USER')   AS c2
     , SYS_CONTEXT ('USERENV', 'CURRENT_USER')   AS c3
     , SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA') AS c4
  FROM DUAL;

--
SELECT SYS_CONTEXT ('USERENV', 'LANG')              AS c1
     , SYS_CONTEXT ('USERENV', 'LANGUAGE')          AS c2
     , SYS_CONTEXT ('USERENV', 'NLS_CALENDAR')      AS c3
     , SYS_CONTEXT ('USERENV', 'NLS_CURRENCY')      AS c4
     , SYS_CONTEXT ('USERENV', 'NLS_DATE_FORMAT')   AS c5
     , SYS_CONTEXT ('USERENV', 'NLS_DATE_LANGUAGE') AS c6
     , SYS_CONTEXT ('USERENV', 'NLS_SORT')          AS c7
     , SYS_CONTEXT ('USERENV', 'NLS_TERRITORY')     AS c8
  FROM DUAL;

--
SELECT SYS_CONTEXT ('USERENV', 'SERVICE_NAME')      AS c1
     , SYS_CONTEXT ('USERENV', 'MODULE')            AS c2
     , SYS_CONTEXT ('USERENV', 'ACTION')            AS c3
     , SYS_CONTEXT ('USERENV', 'CLIENT_INFO')       AS c4
     , SYS_CONTEXT ('USERENV', 'CLIENT_IDENTIFIER') AS c5
  FROM DUAL;

--
SELECT func_id, name, minargs, maxargs, datatype, version FROM v$sqlfn_metadata;

--
SELECT func_id, argnum, datatype FROM v$sqlfn_arg_metadata;
