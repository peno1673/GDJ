--
DROP VIEW emp_v;
CREATE OR REPLACE VIEW v_emp AS SELECT * FROM emp;

RENAME v_emp TO emp_v;
