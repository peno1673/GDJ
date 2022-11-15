--
DROP TABLE ticker PURGE;
CREATE TABLE ticker (symbol VARCHAR2 (10), tstamp DATE, price NUMBER);

INSERT INTO ticker VALUES ('ACME', DATE '2011-04-01', 12);
INSERT INTO ticker VALUES ('ACME', DATE '2011-04-02', 17);
INSERT INTO ticker VALUES ('ACME', DATE '2011-04-03', 19);
INSERT INTO ticker VALUES ('ACME', DATE '2011-04-04', 21);
INSERT INTO ticker VALUES ('ACME', DATE '2011-04-05', 25);
INSERT INTO ticker VALUES ('ACME', DATE '2011-04-06', 12);
INSERT INTO ticker VALUES ('ACME', DATE '2011-04-07', 15);
INSERT INTO ticker VALUES ('ACME', DATE '2011-04-08', 20);
INSERT INTO ticker VALUES ('ACME', DATE '2011-04-09', 24);
INSERT INTO ticker VALUES ('ACME', DATE '2011-04-10', 25);
INSERT INTO ticker VALUES ('ACME', DATE '2011-04-11', 19);
INSERT INTO ticker VALUES ('ACME', DATE '2011-04-12', 15);
INSERT INTO ticker VALUES ('ACME', DATE '2011-04-13', 25);
INSERT INTO ticker VALUES ('ACME', DATE '2011-04-14', 25);
INSERT INTO ticker VALUES ('ACME', DATE '2011-04-15', 14);
INSERT INTO ticker VALUES ('ACME', DATE '2011-04-16', 12);
INSERT INTO ticker VALUES ('ACME', DATE '2011-04-17', 14);
INSERT INTO ticker VALUES ('ACME', DATE '2011-04-18', 24);
INSERT INTO ticker VALUES ('ACME', DATE '2011-04-19', 23);
INSERT INTO ticker VALUES ('ACME', DATE '2011-04-20', 22);
COMMIT;

--
SELECT * FROM ticker                              -- (1)
MATCH_RECOGNIZE (
    PARTITION BY symbol                           -- (2)
    ORDER BY tstamp                               -- (3)
    MEASURES                                      -- (8)
        strt.tstamp              AS start_tstamp
      , FINAL LAST (down.tstamp) AS bottom_tstamp
      , FINAL LAST (up.tstamp)   AS end_tstamp
      , MATCH_NUMBER ()          AS match_num
      , CLASSIFIER ()            AS var_match
    ALL ROWS PER MATCH                            -- (7)
    AFTER MATCH SKIP TO LAST up                   -- (6) -> (5)
    PATTERN (strt down+ up+)                      -- (5)
    DEFINE                                        -- (4)
        down AS down.price < PREV (down.price)
      , up   AS up.price   > PREV (up.price)) mr
ORDER BY mr.symbol, mr.match_num, mr.tstamp       -- (9)
;
