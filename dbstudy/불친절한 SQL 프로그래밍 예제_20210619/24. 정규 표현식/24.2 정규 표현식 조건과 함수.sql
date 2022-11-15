--
SELECT first_name, last_name
  FROM hr.employees
 WHERE REGEXP_LIKE (first_name, '^Ste(v|ph)en$');

--
SELECT last_name FROM hr.employees WHERE REGEXP_LIKE (last_name, '([aeiou])\1', 'i');

--
DROP TABLE contacts PURGE;

CREATE TABLE contacts (
    l_name      VARCHAR2(30)
  , p_number    VARCHAR2(30)
  , CONSTRAINT c_contacts_pnf CHECK (REGEXP_LIKE (p_number, '^\(\d{3}\) \d{3}-\d{4}$'))
);

--
INSERT INTO contacts (p_number) VALUES ('(650) 555-0100');
INSERT INTO contacts (p_number) VALUES ('(215) 555-0100');
INSERT INTO contacts (p_number) VALUES ('650 555-0100');
INSERT INTO contacts (p_number) VALUES ('650 555 0100');
INSERT INTO contacts (p_number) VALUES ('650-555-0100');
INSERT INTO contacts (p_number) VALUES ('(650)555-0100');
INSERT INTO contacts (p_number) VALUES (' (650) 555-0100');

--
SELECT phone_number
     , REGEXP_REPLACE (phone_number
                     , '([[:digit:]]{3})\.([[:digit:]]{3})\.([[:digit:]]{4})'
                     , '(\1) \2-\3') AS c1
  FROM hr.employees
 WHERE employee_id IN (144, 145);

--
SELECT country_name, REGEXP_REPLACE (country_name, '(.)', '\1 ') AS c1
  FROM hr.countries
 WHERE country_id LIKE 'A%';

--
SELECT REGEXP_REPLACE ('500   Oracle     Parkway,    Redwood  Shores, CA', '( ){2,}', ' ') AS c1
  FROM DUAL;

--
DROP TABLE famous_people PURGE;
CREATE TABLE famous_people (names VARCHAR2(20));

INSERT INTO famous_people VALUES ('John Quincy Adams');
INSERT INTO famous_people VALUES ('Harry S. Truman');
INSERT INTO famous_people VALUES ('John Adams');
INSERT INTO famous_people VALUES (' John Quincy Adams');
INSERT INTO famous_people VALUES ('John_Quincy_Adams');
COMMIT;

--
SELECT names, REGEXP_REPLACE (names, '^(\S+)\s(\S+)\s(\S+)$', '\3, \1 \2') AS c1
  FROM famous_people;

--
SELECT REGEXP_SUBSTR ('500 Oracle Parkway, Redwood Shores, CA', ',[^,]+,') AS c1 FROM DUAL;

--
SELECT REGEXP_SUBSTR ('http://www.example.com/products', 'http://([[:alnum:]]+\.?){3,4}/?') AS c1
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('1234567890', '(123)(4(56)(78))', 1, 1, 'i', 1) AS c1
     , REGEXP_SUBSTR ('1234567890', '(123)(4(56)(78))', 1, 1, 'i', 4) AS c1
  FROM DUAL;

--
SELECT REGEXP_SUBSTR ('a'  || CHR (10) || 'd' , 'a.d', 1, 1, 'n') AS c1
     , REGEXP_SUBSTR ('ab' || CHR (10) || 'ac', '^a.', 1, 2, 'm') AS c2
     , REGEXP_SUBSTR ('abcd', 'a b c d'              , 1, 1, 'x') AS c3
  FROM DUAL;

--
--                             11111111112222222222333333333
--                    12345678901234567890123456789012345678
SELECT REGEXP_INSTR ('500 Oracle Parkway, Redwood Shores, CA', '[^ ]+' , 1, 6) AS c1
     , REGEXP_INSTR ('500 Oracle Parkway, Redwood Shores, CA'
                   , '[s|r|p][[:alpha:]]{6}', 3, 2, 1, 'i') AS c2
  FROM DUAL;

--
SELECT REGEXP_INSTR ('1234567890', '(123)(4(56)(78))', 1, 1, 0, 'i', 1) AS c1
     , REGEXP_INSTR ('1234567890', '(123)(4(56)(78))', 1, 1, 0, 'i', 2) AS c2
     , REGEXP_INSTR ('1234567890', '(123)(4(56)(78))', 1, 1, 0, 'i', 4) AS c3
  FROM DUAL;

--
SELECT REGEXP_COUNT ('123123123123123', '123', 1) AS c1
     , REGEXP_COUNT ('123123123123'   , '123', 3) AS c2
  FROM DUAL;

--
SELECT REGEXP_COUNT ('Albert Einstein', 'e', 1, 'i') AS c1
     , REGEXP_COUNT ('Albert Einstein', 'e', 1, 'c') AS c2
  FROM DUAL;
