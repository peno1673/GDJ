-----------------------===================-----------------------
-----------------------DECLARING VARIABLES-----------------------
-----------------------===================-----------------------
SET SERVEROUTPUT ON;
DECLARE 
    v varchar2(20) := 2 + 25 * 3;
BEGIN
    dbms_output.put_line(v);
END;
-----------------------===================-----------------------
DECLARE 
    v_text varchar2(50) NOT NULL DEFAULT 'Hello';
    v_number1 number := 50;
    v_number2 number(2) := 50.42;
    v_number3 number(10,2) := 50.42;
    v_number4 PLS_INTEGER := 50;
    v_number5 BINARY_float := 50.42;
    v_DATE1 DATE := '22-NOV-18 12:01:32';
    v_DATE2 timestamp := systimestamp;
    v_DATE3 timestamp(9) WITH TIME ZONE := systimestamp;
    v_DATE4 interval day(4) to second (3) := '124 02:05:21.012 ';
    v_DATE5 interval year to month := '12-3';
BEGIN
    V_TEXT := 'PL/SQL' || 'Course';
    DBMS_OUTPUT.PUT_LINE(V_TEXT);
    DBMS_OUTPUT.PUT_LINE(v_number1);
    DBMS_OUTPUT.PUT_LINE(v_number2);
    DBMS_OUTPUT.PUT_LINE(v_number3);
    DBMS_OUTPUT.PUT_LINE(v_number4);
    DBMS_OUTPUT.PUT_LINE(v_number5);
    DBMS_OUTPUT.PUT_LINE(v_DATE1);
    DBMS_OUTPUT.PUT_LINE(v_DATE2);
    DBMS_OUTPUT.PUT_LINE(v_DATE3);
    DBMS_OUTPUT.PUT_LINE(v_DATE4);
    DBMS_OUTPUT.PUT_LINE(v_DATE5);
    END;
----------------==================================---------------
----------------USING BOOLEAN DATA TYPE in PL/SQL----------------
----------------==================================---------------
DECLARE
    v_boolean boolean := true;
BEGIN
    dbms_output.put_line(sys.diutil.bool_to_int(v_boolean));
END;
----------------==================================---------------


---------------------%TYPE ATTRIBUTE---------------------
desc employees;
declare
V_TYPE employees.JOB_ID%TYPE;
V_TYPE2 V_TYPE%TYPE;
V_TYPE3 employees.JOB_ID%TYPE ;
begin
v_type := 'IT_PROG';
v_type2 := 'SA_MAN';
v_type3 := NULL;
dbms_output.put_line(v_type);
dbms_output.put_line(v_type2);
dbms_output.put_line('HELLO' || v_type3);
end;
---------------------------------------------------------

------------------DELIMITERS AND COMMENTING------------------
DECLARE
V_TEXT VARCHAR2(10):= 'PL/SQL';
BEGIN
--This is a single line comment
/* This is a 
    multi line
    comment */
--DBMS_OUTPUT.PUT_LINE(V_TEXT || ' is a good language');
null;
END;
-------------------------------------------------------------


------------------------VARIABLE SCOPE--------------------------
begin <<outer>>
DECLARE
  --v_outer VARCHAR2(50) := 'Outer Variable!';
  v_text  VARCHAR2(20) := 'Out-text';
BEGIN 
  DECLARE
    v_text  VARCHAR2(20) := 'In-text';
    v_inner VARCHAR2(30) := 'Inner Variable';
  BEGIN
    --dbms_output.put_line('inside -> ' || v_outer);
    --dbms_output.put_line('inside -> ' || v_inner);
      dbms_output.put_line('inner -> ' || v_text);
      dbms_output.put_line('outer -> ' || outer.v_text);
  END;
  --dbms_output.put_line('inside -> ' || v_inner);
  --dbms_output.put_line(v_outer);
  dbms_output.put_line(v_text);
END;
END outer;
----------------------------------------------------------------

--------------------------BIND VARIABLES--------------------------
set serveroutput on;
set autoprint on;
/
variable var_text varchar2(30);
/
variable var_number NUMBER;
/
variable var_date DATE;
/
declare
v_text varchar2(30);
begin
:var_text := 'Hello SQL';
:var_number := 20;
v_text := :var_text;
--dbms_output.put_line(v_text);
--dbms_output.put_line(:var_text);
end;
/
print var_text;
/
variable var_sql number;
/
begin 
  :var_sql := 100;
end;
/
select * from employees where employee_id = :var_sql;
 
--NOTE: When you run a bind variable creation and select statement together, 
--SQL Developer may return an error. But when you execute them separately, there will be no problem