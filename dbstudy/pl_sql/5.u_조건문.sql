------------------------------IF STATEMENTS--------------------------------
set serveroutput on;
declare
v_number number := 30;
begin
  if v_number < 10 then
    dbms_output.put_line('I am smaller than 10');
  elsif v_number < 20 then
    dbms_output.put_line('I am smaller than 20');
  elsif v_number < 30 then
    dbms_output.put_line('I am smaller than 30');
  else
    dbms_output.put_line('I am equal or greater than 30');
  end if;
end;
---------------------------------------------------------------------------
declare
v_number number := 35;
v_name varchar2(30) := 'Adam';
begin
  if v_number < 10 or v_name = 'Carol' then
    dbms_output.put_line('HI');
    dbms_output.put_line('I am smaller than 10');
  elsif v_number < 20 then
    dbms_output.put_line('I am smaller than 20');
  elsif v_number < 30 then
    dbms_output.put_line('I am smaller than 30');
  else
    if v_number is null then 
      dbms_output.put_line('The number is null..');
    else
      dbms_output.put_line('I am equal or greater than 30');
    end if;
  end if;
end;
---------------------------------------------------------------------------

----------------------------CASE EXPRESSIONS--------------------------------
declare
  v_job_code varchar2(10) := 'SA_MAN';
  v_salary_increase number;
begin
  v_salary_increase := case v_job_code 
    when 'SA_MAN' then 0.2
    when 'SA_REP' then 0.3
    else 0
  end;
  dbms_output.put_line('Your salary increase is : '|| v_salary_increase);
end;
-------------------------SEARCHED CASE EXPRESSION----------------------------
declare
  v_job_code varchar2(10) := 'IT_PROG';
  v_department varchar2(10) := 'IT';
  v_salary_increase number;
begin
  v_salary_increase := case  
    when v_job_code = 'SA_MAN' then 0.2
    when v_department = 'IT' and v_job_code = 'IT_PROG' then 0.3
    else 0
  end;
  dbms_output.put_line('Your salary increase is : '|| v_salary_increase);
end;
---------------------------CASE STATEMENTS------------------------------------
declare
  v_job_code varchar2(10) := 'IT_PROG';
  v_department varchar2(10) := 'IT';
  v_salary_increase number;
begin
  case  
    when v_job_code = 'SA_MAN' then 
      v_salary_increase := 0.2;
      dbms_output.put_line('The salary increase for a Sales Manager is : '|| v_salary_increase);
    when v_department = 'IT' and v_job_code = 'IT_PROG' then 
      v_salary_increase := 0.2;
      dbms_output.put_line('The salary increase for a Sales Manager is : '|| v_salary_increase);
    else 
      v_salary_increase := 0;
      dbms_output.put_line('The salary increase for this job code is : '|| v_salary_increase);
  end CASE;
end;
-------------------------------------------------------------------------------


-------------------------BASIC LOOPS--------------------------
declare
v_counter number(2) := 1;
begin
  loop
    dbms_output.put_line('My counter is : '|| v_counter);
    v_counter := v_counter + 1;
    --if v_counter = 10 then
    --  dbms_output.put_line('Now I reached : '|| v_counter);
    --  exit;
    --end if;
    exit when v_counter > 10;
  end loop;
end;
--------------------------------------------------------------

------------------------------WHILE LOOPS-------------------------------
declare
v_counter number(2) := 1;
begin
  while v_counter <= 10 loop
    dbms_output.put_line('My counter is : '|| v_counter);
    v_counter := v_counter + 1;
   -- exit when v_counter > 3;
  end loop;
end;
-------------------------------------------------------------------------

-----------------------------FOR LOOPS-----------------------------
begin
  for i in REVERSE 1..3 loop
    dbms_output.put_line('My counter is : '|| i);
  end loop;
end;
-------------------------------------------------------------------

-------------------------------NESTED LOOPS-----------------------------------
declare
 v_inner number := 1;
begin
 for v_outer in 1..5 loop
  dbms_output.put_line('My outer value is : ' || v_outer );
    v_inner := 1;
    loop
      v_inner := v_inner+1;
      dbms_output.put_line('  My inner value is : ' || v_inner );
      exit when v_inner*v_outer >= 15;
    end loop;
 end loop;
end;
-------------------------NESTED LOOPS WITH LABELS------------------------------
declare
 v_inner number := 1;
begin
<<outer_loop>>
 for v_outer in 1..5 loop
  dbms_output.put_line('My outer value is : ' || v_outer );
    v_inner := 1;
    <<inner_loop>>
    loop
      v_inner := v_inner+1;
      dbms_output.put_line('  My inner value is : ' || v_inner );
      exit outer_loop when v_inner*v_outer >= 16;
      exit when v_inner*v_outer >= 15;
    end loop inner_loop;
 end loop outer_loop;
end;
--------------------------------------------------------------------------------

----------------------------CONTINUE STATEMENT----------------------------------
declare
 v_inner number := 1;
begin
 for v_outer in 1..10 loop
  dbms_output.put_line('My outer value is : ' || v_outer );
    v_inner := 1;
    while v_inner*v_outer < 15 loop
      v_inner := v_inner+1;
      continue when mod(v_inner*v_outer,3) = 0;
      dbms_output.put_line('  My inner value is : ' || v_inner );
    end loop;
 end loop;
end;
---------------------------------------------------------------------------------
declare
 v_inner number := 1;
begin
<<outer_loop>>
 for v_outer in 1..10 loop
  dbms_output.put_line('My outer value is : ' || v_outer );
    v_inner := 1;
    <<inner_loop>>
    loop
      v_inner := v_inner+1;
      continue outer_loop when v_inner = 10;
      dbms_output.put_line('  My inner value is : ' || v_inner );
    end loop inner_loop;
 end loop outer_loop;
end;
----------------------------------------------------------------------------------


------------------------------GOTO STATEMENT----------------------------------
DECLARE
  v_searched_number NUMBER := 22;
  v_is_prime boolean := true;
BEGIN
  FOR x in 2..v_searched_number-1 LOOP
    IF v_searched_number MOD x = 0 THEN
      dbms_output.put_line(v_searched_number|| ' is not a prime number..');
      v_is_prime := false;
      GOTO end_point;
    END IF;
  END LOOP;
  if v_is_prime then
    dbms_output.put_line(v_searched_number|| ' is a prime number..');
  end if;
<<end_point>>
  dbms_output.put_line('Check complete..');
END;
-------------------------------------------------------------------------------
DECLARE
  v_searched_number NUMBER := 32457;
  v_is_prime boolean := true;
  x number := 2;
BEGIN
  <<start_point>>
    IF v_searched_number MOD x = 0 THEN
      dbms_output.put_line(v_searched_number|| ' is not a prime number..');
      v_is_prime := false;
      GOTO end_point;
    END IF;
  x := x+1;
  if x = v_searched_number then
   goto prime_point;
  end if;
  goto start_point;
  <<prime_point>>
  if v_is_prime then
    dbms_output.put_line(v_searched_number|| ' is a prime number..');
  end if;
<<end_point>>
  dbms_output.put_line('Check complete..');
END;
---------------------------------------------------------------------------------