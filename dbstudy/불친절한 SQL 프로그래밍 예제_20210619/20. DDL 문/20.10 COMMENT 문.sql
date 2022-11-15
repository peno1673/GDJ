--
DROP TABLE t1 PURGE;
CREATE TABLE t1 (c1 NUMBER, c2 NUMBER);

--
COMMENT ON TABLE t1 IS 'T1 Table';

--
COMMENT ON COLUMN t1.c1 IS 'C1 Column';

--
SELECT table_type, comments FROM user_tab_comments WHERE table_name = 'T1';

--
SELECT column_name, comments FROM user_col_comments WHERE table_name = 'T1';

--
COMMENT ON TABLE t1 IS '';
COMMENT ON COLUMN t1.c1 IS '';
