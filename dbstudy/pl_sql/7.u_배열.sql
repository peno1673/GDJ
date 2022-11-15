--------------------------------------------------------------------------------------------------------------------
----------------------------------------------PL/SQL RECORDS--------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
declare
  r_emp employees%rowtype;
begin
  select * into r_emp from employees where employee_id = '101';
  --r_emp.salary := 2000;
  dbms_output.put_line(r_emp.first_name||' '||r_emp.last_name|| ' earns '||r_emp.salary||
                       ' and hired at :' || r_emp.hire_date);
end;
------------------------------
declare
  --r_emp employees%rowtype;
  type t_emp is record (first_name varchar2(50),
                        last_name employees.last_name%type,
                        salary employees.salary%type,
                        hire_date date);
  r_emp t_emp;
begin
  select first_name,last_name,salary,hire_date into r_emp 
        from employees where employee_id = '101';
 /* r_emp.first_name := 'Alex';
  r_emp.salary := 2000;
  r_emp.hire_date := '01-JAN-20'; */
  dbms_output.put_line(r_emp.first_name||' '||r_emp.last_name|| ' earns '||r_emp.salary||
                       ' and hired at :' || r_emp.hire_date);
end;
-------------------------------
declare
  type t_edu is record (primary_school varchar2(100),
                        high_school varchar2(100),
                        university varchar2(100),
                        uni_graduate_date date
                        );
  type t_emp is record (first_name varchar2(50),
                        last_name employees.last_name%type,
                        salary employees.salary%type  NOT NULL DEFAULT 1000,
                        hire_date date,
                        dept_id employees.department_id%type,
                        department departments%rowtype,
                        education t_edu
                        );
  r_emp t_emp;
begin
  select first_name,last_name,salary,hire_date,department_id 
        into r_emp.first_name,r_emp.last_name,r_emp.salary,r_emp.hire_date,r_emp.dept_id 
        from employees where employee_id = '146';
  select * into r_emp.department from departments where department_id = r_emp.dept_id;
  r_emp.education.high_school := 'Beverly Hills';
  r_emp.education.university := 'Oxford';
--  r_emp.education.uni_graduate_date := 01/JAN/13; 
  
  dbms_output.put_line(r_emp.first_name||' '||r_emp.last_name|| ' earns '||r_emp.salary||
                       ' and hired at :' || r_emp.hire_date);
  dbms_output.put_line('She graduated from '|| r_emp.education.university|| ' at '||  r_emp.education.uni_graduate_date);
  dbms_output.put_line('Her Department Name is : '|| r_emp.department.department_name);
end;

begin
    DBMS_OUTPUT.PUT_LINE(sysdate);
END;


--------------------------------------------------------------------------------------------------------------------
-----------------------------------------EASY DML WITH RECORDS------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
create table retired_employees as select * from employees where 1=2;
select * from retired_employees;
/
declare
    r_emp employees%rowtype;
begin
    select * into r_emp from employees where employee_id = 104;
 r_emp.salary := 0;
    r_emp.commission_pct := 0;
    insert into retired_employees values r_emp;
end;
-----------------------------------------
declare
    r_emp employees%rowtype;
begin
    select * into r_emp from employees where employee_id = 104;
    r_emp.salary := 10;
    r_emp.commission_pct := 0;
    --insert into retired_employees values r_emp;
    update retired_employees set row = r_emp where employee_id = 104;
end;
/
delete from retired_employees;




--------------------------------------------------------------------------------------------------------------------
---------------------------------------------------VARRAYS----------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
 
---------------A simple working example
Declare
  type e_list is varray(5) of varchar2(50);
      employees e_list;
begin
  employees := e_list('Alex','Bruce','John','Bob','Richard');
  for i in 1..5 loop
    dbms_output.put_line(employees(i));
  end loop;
end;
---------------limit exceeding error example
declare
  type e_list is varray(4) of varchar2(50);
  employees e_list;
begin
  employees := e_list('Alex','Bruce','John','Bob','Richard');
  for i in 1..5 loop
    dbms_output.put_line(employees(i));
  end loop;
end;
---------------Subscript beyond cound error example
declare
  type e_list is varray(5) of varchar2(50);
  employees e_list;
begin
  employees := e_list('Alex','Bruce','John','Bob');
  for i in 1..5 loop
    dbms_output.put_line(employees(i));
  end loop;
end;
---------------A working count() example
declare
  type e_list is varray(5) of varchar2(50);
  employees e_list;
begin
  employees := e_list('Alex','Bruce','John','Bob');
  for i in 1..employees.count() loop
    dbms_output.put_line(employees(i));
  end loop;
end;
---------------A working first() last() functions example
declare
  type e_list is varray(5) of varchar2(50);
  employees e_list;
begin
  employees := e_list('Alex','Bruce','John','Bob');
  for i in employees.first()..employees.last() loop
    dbms_output.put_line(employees(i));
  end loop;
end;
--------------- A working exists() function example
declare
  type e_list is varray(5) of varchar2(50);
  employees e_list;
begin
  employees := e_list('Alex','Bruce','John','Bob');
  for i in 1..5 loop
    if employees.exists(i) then
      dbms_output.put_line(employees(i));
    end if;
  end loop;
end;
---------------A working limit() function example
declare
  type e_list is varray(5) of varchar2(50);
  employees e_list;
begin
  employees := e_list('Alex','Bruce','John','Bob');
      dbms_output.put_line(employees.limit());
end;
--------------- A create-declare at the same time error example
declare
  type e_list is varray(5) of varchar2(50);
  employees e_list('Alex','Bruce','John','Bob');
begin
 -- employees := e_list('Alex','Bruce','John','Bob');
  for i in 1..5 loop
    if employees.exists(i) then
      dbms_output.put_line(employees(i));
    end if;
  end loop;
end;
--------------- A post insert varray example
declare
  type e_list is varray(15) of varchar2(50);
  employees e_list := e_list();
  idx number := 1;
begin
  for i in 100..110 loop
    employees.extend;
    select first_name into employees(idx) from employees where employee_id = i;
    idx := idx + 1;
  end loop;
  for x in 1..employees.count() loop
    dbms_output.put_line(employees(x));
  end loop;
end;
--------------- An example for the schema level varray types
create type e_list is varray(15) of varchar2(50);
/
create or replace type e_list as varray(20) of varchar2(100);
/
declare
  employees e_list := e_list();
  idx number := 1;
begin
  for i in 100..110 loop
    employees.extend;
    select first_name into employees(idx) from employees where employee_id = i;
    idx := idx + 1;
  end loop;
  for x in 1..employees.count() loop
    dbms_output.put_line(employees(x));
  end loop;
end;
/
DROP TYPE E_LIST;



--------------------------------------------------------------------------------------------------------------------
-------------------------------------------------NESTED TABLES------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
---------------The simple usage of nested tables
declare
  type e_list is table of varchar2(50);
  emps e_list;
begin
  emps := e_list('Alex','Bruce','John');
  for i in 1..emps.count() loop
    dbms_output.put_line(emps(i));
  end loop;
end;
---------------Adding a new value to a nested table after the initialization
declare
  type e_list is table of varchar2(50);
  emps e_list;
begin
  emps := e_list('Alex','Bruce','John');
  emps.extend;
  emps(4) := 'Bob';
  for i in 1..emps.count() loop
    dbms_output.put_line(emps(i));
  end loop;
end;
---------------Adding values from the tabledeclare
declare
  type e_list is table of employees.first_name%type;
  emps e_list := e_list();
  idx pls_integer := 1;
begin
  for x in 100 .. 110 loop
    emps.extend;
    select first_name into emps(idx) from employees where employee_id = x;
    idx := idx + 1;
  end loop;
  for i in 1..emps.count() loop
    dbms_output.put_line(emps(i));
  end loop;
end;

---------------delete example
declare
  type e_list is table of employees.first_name%type;
  emps e_list := e_list();
  idx pls_integer := 1;
begin
  for x in 100 .. 110 loop
    emps.extend;
    select first_name into emps(idx) from employees where employee_id = x;
    idx := idx + 1;
  end loop;
  emps.delete(3);  --삭제
  for i in 1..emps.count() loop
   if emps.exists(i) then 
    dbms_output.put_line(emps(i));
   end if;
  end loop;
end;




--------------------------------------------------------------------------------------------------------------------
----------------------------------------------ASSOCIATIVE ARRAYS----------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
---------------The first example
declare
  type e_list is table of employees.first_name%type index by pls_integer;
  emps e_list;
begin
  for x in 100 .. 110 loop
    select first_name into emps(x) from employees 
       where employee_id = x ;
  end loop;
  for i in emps.first()..emps.last() loop
    dbms_output.put_line(emps(i));
  end loop;
end;
---------------Error example for the select into clause

declare
  type e_list is table of employees.first_name%type index by pls_integer;
  emps e_list;
begin
  for x in 100 .. 110 loop
    select first_name into emps(x) from employees 
       where employee_id = x  and department_id = 60;  -- and로 디파트머트60 이안됨
  end loop;
  for i in emps.first()..emps.last() loop
    dbms_output.put_line(i);
  end loop;
end;
select * from employees;
---------------Error example about reaching the empty indexdeclare
-- 중간 건너뛰기 불가능
declare
  type e_list is table of employees.first_name%type index by pls_integer;
  emps e_list;
begin
  emps(100) := 'Bob';
  emps(120) := 'Sue';
  for i in emps.first()..emps.last() loop
    dbms_output.put_line(emps(i));
  end loop;
end;
---------------An example of iterating in associative arrays with while loops
declare
  type e_list is table of employees.first_name%type index by pls_integer;
  emps e_list;
  idx pls_integer;
begin
  emps(100) := 'Bob';
  emps(120) := 'Sue';
  idx := emps.first;
  while idx is not null  loop
    dbms_output.put_line(emps(idx));
    idx := emps.next(idx);
  end loop;
end;
---------------An example of using string based indexes with associative arrays
declare
  type e_list is table of employees.first_name%type index by employees.email%type;
  emps e_list;
  idx employees.email%type;
  v_email employees.email%type;
  v_first_name employees.first_name%type;
begin
    for x in 100 .. 110 loop
    select first_name,email into v_first_name,v_email from employees
       where employee_id = x;
    emps(v_email) := v_first_name;
  end loop;
  idx := emps.first;
  while idx is not null  loop
    dbms_output.put_line('The email of '|| emps(idx) ||' is : '|| idx);
    idx := emps.next(idx);
  end loop;
end;
---------------An example of using associative arrays with records
declare
  type e_list is table of employees%rowtype index by employees.email%type;
  emps e_list;
  idx employees.email%type;
begin
    for x in 100 .. 110 loop
    select * into emps(x) from employees
       where employee_id = x;
  end loop;
  idx := emps.first;
  while idx is not null  loop
    dbms_output.put_line('The email of '|| emps(idx).first_name 
          ||' '||emps(idx).last_name||' is : '|| emps(idx).email);
    idx := emps.next(idx);
  end loop;
end;
---------------An example of using associative arrays with record types
declare
  type e_type is record (first_name employees.first_name%type,
                         last_name employees.last_name%type,
                         email employees.email%type);
  type e_list is table of e_type index by employees.email%type;
  emps e_list;
  idx employees.email%type;
begin
    for x in 100 .. 110 loop
    select first_name,last_name,email into emps(x) from employees
       where employee_id = x;
  end loop;
  idx := emps.first;
  while idx is not null  loop
    dbms_output.put_line('The email of '|| emps(idx).first_name 
          ||' '||emps(idx).last_name||' is : '|| emps(idx).email);
    idx := emps.next(idx);
  end loop;
end;
---------------An example of printing from the last to the first
declare
  type e_type is record (first_name employees.first_name%type,
                         last_name employees.last_name%type,
                         email employees.email%type);
  type e_list is table of e_type index by employees.email%type;
  emps e_list;
  idx employees.email%type;
begin
    for x in 100 .. 110 loop
    select first_name,last_name,email into emps(x) from employees
       where employee_id = x;
  end loop;
  --emps.delete(100,104);
  idx := emps.last;
  while idx is not null  loop
    dbms_output.put_line('The email of '|| emps(idx).first_name 
          ||' '||emps(idx).last_name||' is : '|| emps(idx).email);
    idx := emps.prior(idx);
  end loop;
end;
---------------An example of inserting with associative arrays
create table employees_salary_history as select * from employees where 1=2;
alter table employees_salary_history add insert_date date;
select * from employees_salary_history;

/
declare
  type e_list is table of employees_salary_history%rowtype index by pls_integer;
  emps e_list;
  idx pls_integer;
begin
    for x in 100 .. 110 loop
    select e.*,'01/6/20' into emps(x) from employees e
       where employee_id = x;
  end loop;
  idx := emps.first;
  while idx is not null loop
    emps(idx).salary := emps(idx).salary + emps(idx).salary*0.2;
    insert into employees_salary_history values emps(idx);
    dbms_output.put_line('The employee '|| emps(idx).first_name 
                         ||' is inserted to the history table');
    idx := emps.next(idx);
  end loop;
end;
/
drop table employees_salary_history;




--------------------------------------------------------------------------------------------------------------------
---------------------------------------STORING COLLECTIONS IN TABLES------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
---------------Storing Varray Example
create or replace type t_phone_number as object (p_type varchar2(10), p_number varchar2(50));
/
create or replace type v_phone_numbers as varray(3) of t_phone_number;
/
create table emps_with_phones (employee_id number,
                               first_name varchar2(50),
                               last_name varchar2(50),
                               phone_number v_phone_numbers);
/
select * from emps_with_phones;
/
insert into emps_with_phones values (10,'Alex','Brown',v_phone_numbers(
                                                                t_phone_number('HOME','111.111.1111'),
                                                                t_phone_number('WORK','222.222.2222'),
                                                                t_phone_number('MOBILE','333.333.3333')
                                                                ));
insert into emps_with_phones values (11,'Bob','Green',v_phone_numbers(
                                                                t_phone_number('HOME','000.000.000'),
                                                                t_phone_number('WORK','444.444.4444')
                                                                ));                                                                
/
---------------Querying the varray example
select e.first_name,last_name,p.p_type,p.p_number from emps_with_phones e, table(e.phone_number) p;
---------------The codes for the storing nested table example
create or replace type n_phone_numbers as table of t_phone_number;
/
create table emps_with_phones2 (employee_id number,
                               first_name varchar2(50),
                               last_name varchar2(50),
                               phone_number n_phone_numbers)
                               NESTED TABLE phone_number STORE AS phone_numbers_table;
/
select * from emps_with_phones2;
/
insert into emps_with_phones2 values (10,'Alex','Brown',n_phone_numbers(
                                                                t_phone_number('HOME','111.111.1111'),
                                                                t_phone_number('WORK','222.222.2222'),
                                                                t_phone_number('MOBILE','333.333.3333')
                                                                ));
insert into emps_with_phones2 values (11,'Bob','Green',n_phone_numbers(
                                                                t_phone_number('HOME','000.000.000'),
                                                                t_phone_number('WORK','444.444.4444')
                                                                ));      
/
select e.first_name,last_name,p.p_type,p.p_number from emps_with_phones2 e, table(e.phone_number) p;
---------------new insert and update
insert into emps_with_phones2 values (11,'Bob','Green',n_phone_numbers(
                                                                t_phone_number('HOME','000.000.000'),
                                                                t_phone_number('WORK','444.444.4444'),
                                                                t_phone_number('WORK2','444.444.4444'),
                                                                t_phone_number('WORK3','444.444.4444'),
                                                                t_phone_number('WORK4','444.444.4444'),
                                                                t_phone_number('WORK5','444.444.4444')
                                                                ));    
select * from emps_with_phones2;
update emps_with_phones2 set phone_number = n_phone_numbers(
                                                                t_phone_number('HOME','000.000.000'),
                                                                t_phone_number('WORK','444.444.4444'),
                                                                t_phone_number('WORK2','444.444.4444'),
                                                                t_phone_number('WORK3','444.444.4444'),
                                                                t_phone_number('WORK4','444.444.4444'),
                                                                t_phone_number('WORK5','444.444.4444')
                                                                )
where employee_id = 11;
---------------Adding a new value into the nested table inside of a table
declare
  p_num n_phone_numbers;
begin
  select phone_number into p_num from emps_with_phones2 where employee_id = 10;
  p_num.extend;
  p_num(35) := t_phone_number('FAX','999.99.9999');
  UPDATE emps_with_phones2 set phone_number = p_num where employee_id = 10;
end;

SELECT * FROM emps_with_phones2 WHERE EMPLOYEE_ID = 10;