--
EXEC DBMS_APPLICATION_INFO.SET_MODULE ('M1', 'A1')

--
EXEC DBMS_APPLICATION_INFO.SET_ACTION ('A2')

--
EXEC DBMS_APPLICATION_INFO.SET_CLIENT_INFO ('C1')

--
SELECT module, action, client_info FROM v$session WHERE SID = SYS_CONTEXT ('USERENV', 'SID');
