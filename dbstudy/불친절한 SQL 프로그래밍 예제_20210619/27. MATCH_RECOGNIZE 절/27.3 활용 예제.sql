--
SELECT * FROM ticker
MATCH_RECOGNIZE (
    PARTITION BY symbol
    ORDER BY tstamp
    MEASURES
        strt.tstamp        AS start_tstamp
      , LAST (down.tstamp) AS bottom_tstamp
      , LAST (up.tstamp)   AS end_tstamp
    ONE ROW PER MATCH
    AFTER MATCH SKIP TO LAST up
    PATTERN (strt down+ up+)
    DEFINE
        down AS down.price < PREV (down.price)
      , up   AS up.price   > PREV (up.price)) mr
ORDER BY mr.symbol, mr.start_tstamp;

--
SELECT * FROM ticker
MATCH_RECOGNIZE (
    PARTITION BY symbol
    ORDER BY tstamp
    MEASURES
        MATCH_NUMBER ()           AS match_num
      , CLASSIFIER ()             AS var_match
      , FINAL   COUNT (up.tstamp) AS up_days
      , FINAL   COUNT (tstamp)    AS total_days
      , RUNNING COUNT (tstamp)    AS cnt_days
      , price - strt.price        AS price_dif
    ALL ROWS PER MATCH
    AFTER MATCH SKIP TO LAST up
    PATTERN (strt down+ up+)
    DEFINE
        down AS down.price < PREV (down.price)
      , up   AS up.price   > PREV (up.price)) mr
ORDER BY mr.symbol, mr.match_num, mr.tstamp;

--
SELECT * FROM ticker
MATCH_RECOGNIZE (
    PARTITION BY symbol
    ORDER BY tstamp
    MEASURES
        MATCH_NUMBER ()        AS match_num
      , CLASSIFIER ()          AS var_match
      , strt.tstamp            AS start_tstamp
      , FINAL LAST (up.tstamp) AS end_tstamp
    ALL ROWS PER MATCH
    AFTER MATCH SKIP TO LAST up
    PATTERN (strt down+ up+ down+ up+)
    DEFINE
        down AS down.price < PREV (down.price)
      , up   AS up.price   > PREV (up.price)) mr
ORDER BY mr.symbol, mr.match_num, mr.tstamp;

--
SELECT * FROM ticker
MATCH_RECOGNIZE (
    PARTITION BY symbol
    ORDER BY tstamp
    MEASURES
        FIRST (strt.tstamp) AS strt_time
      , LAST (down.tstamp)  AS bottom
      , AVG (stdn.price)    AS stdn_avgprice
    ONE ROW PER MATCH
    AFTER MATCH SKIP TO LAST up
    PATTERN (strt down+ up+)
    SUBSET stdn = (strt, down)
    DEFINE
        up   AS up.price   > PREV (up.price)
      , down AS down.price < PREV (down.price));

--
SELECT m.symbol, m.tstamp, m.price, m.runningavg, m.finalavg FROM ticker
MATCH_RECOGNIZE (
    PARTITION BY symbol
    ORDER BY tstamp
    MEASURES
        RUNNING AVG (a.price) AS runningavg
      , FINAL   AVG (a.price) AS finalavg
    ALL ROWS PER MATCH
    PATTERN (a+)
    DEFINE a AS a.price >= AVG (a.price)) m;

--
SELECT m.symbol, m.tstamp, m.matchno, m.classfr, m.price, m.avgp FROM ticker
MATCH_RECOGNIZE (
    PARTITION BY symbol
    ORDER BY tstamp
    MEASURES
        FINAL AVG (s.price) AS avgp
      , CLASSIFIER ()       AS classfr
      , MATCH_NUMBER ()     AS matchno
    ALL ROWS PER MATCH
    AFTER MATCH SKIP TO LAST b
    PATTERN ({- a -} b+ {- c+ -})
    SUBSET s = (a, b)
    DEFINE
        a AS a.price >= 10
      , b AS b.price >  PREV (b.price)
      , c AS c.price <= PREV (c.price)) m;

--
DROP TABLE ticker3wave PURGE;
CREATE TABLE ticker3wave (symbol VARCHAR2(10), tstamp DATE, price NUMBER);

INSERT INTO ticker3wave VALUES ('ACME', DATE '2011-04-01', 1000);
INSERT INTO ticker3wave VALUES ('ACME', DATE '2011-04-02',  775);
INSERT INTO ticker3wave VALUES ('ACME', DATE '2011-04-03',  900);
INSERT INTO ticker3wave VALUES ('ACME', DATE '2011-04-04',  775);
INSERT INTO ticker3wave VALUES ('ACME', DATE '2011-04-05',  900);
INSERT INTO ticker3wave VALUES ('ACME', DATE '2011-04-06',  775);
INSERT INTO ticker3wave VALUES ('ACME', DATE '2011-04-07',  900);
INSERT INTO ticker3wave VALUES ('ACME', DATE '2011-04-08',  775);
INSERT INTO ticker3wave VALUES ('ACME', DATE '2011-04-09',  800);
INSERT INTO ticker3wave VALUES ('ACME', DATE '2011-04-10',  550);
INSERT INTO ticker3wave VALUES ('ACME', DATE '2011-04-11',  900);
INSERT INTO ticker3wave VALUES ('ACME', DATE '2011-04-12',  800);
INSERT INTO ticker3wave VALUES ('ACME', DATE '2011-04-13', 1100);
INSERT INTO ticker3wave VALUES ('ACME', DATE '2011-04-14',  800);
INSERT INTO ticker3wave VALUES ('ACME', DATE '2011-04-15',  550);
INSERT INTO ticker3wave VALUES ('ACME', DATE '2011-04-16',  800);
INSERT INTO ticker3wave VALUES ('ACME', DATE '2011-04-17',  875);
INSERT INTO ticker3wave VALUES ('ACME', DATE '2011-04-18',  950);
INSERT INTO ticker3wave VALUES ('ACME', DATE '2011-04-19',  600);
INSERT INTO ticker3wave VALUES ('ACME', DATE '2011-04-20',  300);
COMMIT;

--
SELECT * FROM ticker3wave
MATCH_RECOGNIZE (
    PARTITION BY symbol
    ORDER BY tstamp
    MEASURES
        b.tstamp                              AS timestamp
      , a.price                               AS aprice
      , b.price                               AS bprice
      , ((b.price - a.price) * 100) / a.price AS pctdrop
    ONE ROW PER MATCH
    AFTER MATCH SKIP TO b
    PATTERN (a b)
    DEFINE b AS (b.price - a.price) / a.price  < -0.24);

--
SELECT * FROM ticker3wave
MATCH_RECOGNIZE (
    PARTITION BY symbol
    ORDER BY tstamp
    MEASURES
        a.tstamp        AS start_timestamp
      , a.price         AS start_price
      , b.price         AS drop_price
      , count (c.*) + 1 AS cnt_days
      , d.tstamp        AS end_timestamp
      , d.price         AS end_price
    ONE ROW PER MATCH
    AFTER MATCH SKIP PAST LAST ROW
    PATTERN (a b c* d)
    DEFINE
        b AS (b.price - a.price) / a.price < -0.08
      , c AS c.price <  a.price
      , d AS d.price >= a.price);

--
DROP TABLE tickervu PURGE;
CREATE TABLE tickervu (symbol VARCHAR2(10), tstamp DATE, price NUMBER);

INSERT INTO tickervu values ('ACME', DATE '2011-04-01', 12);
INSERT INTO tickervu values ('ACME', DATE '2011-04-02', 17);
INSERT INTO tickervu values ('ACME', DATE '2011-04-03', 19);
INSERT INTO tickervu values ('ACME', DATE '2011-04-04', 21);
INSERT INTO tickervu values ('ACME', DATE '2011-04-05', 25);
INSERT INTO tickervu values ('ACME', DATE '2011-04-06', 12);
INSERT INTO tickervu values ('ACME', DATE '2011-04-07', 15);
INSERT INTO tickervu values ('ACME', DATE '2011-04-08', 20);
INSERT INTO tickervu values ('ACME', DATE '2011-04-09', 24);
INSERT INTO tickervu values ('ACME', DATE '2011-04-10', 25);
INSERT INTO tickervu values ('ACME', DATE '2011-04-11', 19);
INSERT INTO tickervu values ('ACME', DATE '2011-04-12', 15);
INSERT INTO tickervu values ('ACME', DATE '2011-04-13', 25);
INSERT INTO tickervu values ('ACME', DATE '2011-04-14', 25);
INSERT INTO tickervu values ('ACME', DATE '2011-04-15', 14);
INSERT INTO tickervu values ('ACME', DATE '2011-04-16', 12);
INSERT INTO tickervu values ('ACME', DATE '2011-04-17', 12);
INSERT INTO tickervu values ('ACME', DATE '2011-04-18', 24);
INSERT INTO tickervu values ('ACME', DATE '2011-04-19', 23);
INSERT INTO tickervu values ('ACME', DATE '2011-04-20', 22);
COMMIT;

--
SELECT * FROM tickervu
MATCH_RECOGNIZE (
    PARTITION BY symbol
    ORDER BY tstamp
    MEASURES
        strt.tstamp AS start_tstamp
      , down.tstamp AS bottom_tstamp
      , up.tstamp   AS end_tstamp
    ONE ROW PER MATCH
    AFTER MATCH SKIP TO LAST up
    PATTERN (strt down+ flat* up+)
    DEFINE
        down AS down.price < PREV (down.price)
      , flat AS flat.price = PREV (flat.price)
      , up   AS up.price   > PREV (up.price)) mr
ORDER BY mr.symbol, mr.start_tstamp;

--
SELECT mr_elliott.* FROM ticker3wave
MATCH_RECOGNIZE (
    PARTITION BY symbol
    ORDER BY tstamp
    MEASURES
        count(*)   AS cnt, count(p.*) AS p, count(q.*) AS q
      , count(r.*) AS r  , count(s.*) AS s, count(t.*) AS t
      , count(u.*) AS u  , count(v.*) AS v, count(w.*) AS w
      , count(x.*) AS x  , count(y.*) AS y, count(z.*) AS z
      , CLASSIFIER () AS cls, MATCH_NUMBER () AS mno
    ALL ROWS PER MATCH
    AFTER MATCH SKIP TO LAST z
    PATTERN (p q+ r+ s+ t+ u+ v+ w+ x+ y+ z+)
    DEFINE
        q AS q.price > PREV (q.price), r AS r.price < PREV (r.price)
      , s AS s.price > PREV (s.price), t AS t.price < PREV (t.price)
      , u AS u.price > PREV (u.price), v AS v.price < PREV (v.price)
      , w AS w.price > PREV (w.price), x AS x.price < PREV (x.price)
      , y AS y.price > PREV (y.price), z AS z.price < PREV (z.price)) mr_elliott
ORDER BY symbol, tstamp;

--
DROP TABLE tickerwavemulti PURGE;
CREATE TABLE tickerwavemulti (symbol VARCHAR2(10), tstamp DATE, price NUMBER);

INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-01', 36.25);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-02', 36.47);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-03', 36.36);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-04', 36.25);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-05', 36.36);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-06', 36.70);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-07', 36.50);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-08', 36.66);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-09', 36.98);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-10', 37.08);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-11', 37.43);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-12', 37.68);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-13', 37.66);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-14', 37.32);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-15', 37.16);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-16', 36.98);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-17', 37.19);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-18', 37.45);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-19', 37.79);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-20', 37.49);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-21', 37.30);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-22', 37.08);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-23', 37.34);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-24', 37.54);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-25', 37.69);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-26', 37.60);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-27', 37.93);
INSERT INTO tickerwavemulti VALUES ('ACME', DATE '2010-05-28', 38.17);
COMMIT;

--
SELECT mr_ew.* FROM tickerwavemulti
MATCH_RECOGNIZE (
    PARTITION by symbol
    ORDER by tstamp
    MEASURES
        v.tstamp AS start_t, z.tstamp AS end_t
      , COUNT (v.price) AS v, COUNT (w.price) AS w, COUNT (x.price) AS x
      , COUNT (y.price) AS y, COUNT (z.price) AS z
      , MATCH_NUMBER () AS mno
    ALL ROWS PER MATCH
    AFTER MATCH SKIP TO LAST z
    PATTERN (v w{3,4} x{3,4} y{3,4} z{3,4})
    DEFINE
        w AS w.price > PREV (w.price), x AS x.price < PREV (x.price)
      , y AS y.price > PREV (y.price), z AS z.price < PREV (z.price)) mr_ew
ORDER BY symbol, tstamp;

--
SELECT mr_w.* FROM ticker3wave
MATCH_RECOGNIZE (
    PARTITION BY symbol
    ORDER BY tstamp
    MEASURES
        MATCH_NUMBER () AS mno, p.tstamp AS start_t, t.tstamp AS end_t
      , MAX (p.price) AS p, MIN (q.price) AS q, MAX (r.price) AS r
      , MIN (s.price) AS s, MAX (t.price) AS t
    ALL ROWS PER MATCH
    AFTER MATCH SKIP TO LAST r
    PATTERN (p q+ r+ s+ t+)
    DEFINE
        q AS q.price < PREV (q.price), r AS r.price > PREV (r.price)
      , s AS s.price < PREV (s.price), t AS t.price > PREV (t.price)) mr_w
ORDER BY symbol, mno, tstamp;

--
DROP TABLE stockt04 PURGE;
CREATE TABLE stockt04 (symbol VARCHAR2(10), tstamp TIMESTAMP, price NUMBER, volume NUMBER);

INSERT INTO stockt04 VALUES ('ACME', TIMESTAMP '2010-01-01 12:00:00', 35, 35000);
INSERT INTO stockt04 VALUES ('ACME', TIMESTAMP '2010-01-01 12:05:00', 35, 15000);
INSERT INTO stockt04 VALUES ('ACME', TIMESTAMP '2010-01-01 12:10:00', 35,  5000);
INSERT INTO stockt04 VALUES ('ACME', TIMESTAMP '2010-01-01 12:11:00', 35, 42000);
INSERT INTO stockt04 VALUES ('ACME', TIMESTAMP '2010-01-01 12:16:00', 35,  7000);
INSERT INTO stockt04 VALUES ('ACME', TIMESTAMP '2010-01-01 12:19:00', 35,  5000);
INSERT INTO stockt04 VALUES ('ACME', TIMESTAMP '2010-01-01 12:20:00', 35,  5000);
INSERT INTO stockt04 VALUES ('ACME', TIMESTAMP '2010-01-01 12:33:00', 35, 55000);
INSERT INTO stockt04 VALUES ('ACME', TIMESTAMP '2010-01-01 12:36:00', 35, 15000);
INSERT INTO stockt04 VALUES ('ACME', TIMESTAMP '2010-01-01 12:48:00', 35, 15000);
INSERT INTO stockt04 VALUES ('ACME', TIMESTAMP '2010-01-01 12:59:00', 35, 15000);
INSERT INTO stockt04 VALUES ('ACME', TIMESTAMP '2010-01-01 01:09:00', 35, 55000);
INSERT INTO stockt04 VALUES ('ACME', TIMESTAMP '2010-01-01 01:19:00', 35, 55000);
INSERT INTO stockt04 VALUES ('ACME', TIMESTAMP '2010-01-01 01:29:00', 35, 15000);
COMMIT;

--
SELECT * FROM stockt04
MATCH_RECOGNIZE (
    PARTITION BY symbol
    ORDER BY tstamp
    MEASURES SUM (a.volume) AS sum_of_large_volumes
    ALL ROWS PER MATCH
    AFTER MATCH SKIP PAST LAST ROW
    PATTERN (a {- b* -} a {- b* -} a)
    DEFINE
        a AS (    a.volume >  30000
              AND a.tstamp - FIRST (a.tstamp) < INTERVAL '0 01:00:00.00' DAY TO SECOND)
      , b AS (    b.volume <= 30000
              AND b.tstamp - FIRST (a.tstamp) < INTERVAL '0 01:00:00.00' DAY TO SECOND));

--
DROP TABLE events PURGE;
CREATE TABLE events (time_stamp NUMBER, user_id VARCHAR2(10));

INSERT INTO events VALUES ( 1, 'Mary');
INSERT INTO events VALUES (11, 'Mary');
INSERT INTO events VALUES (23, 'Mary');
INSERT INTO events VALUES (34, 'Mary');
INSERT INTO events VALUES (44, 'Mary');
INSERT INTO events VALUES (53, 'Mary');
INSERT INTO events VALUES (63, 'Mary');
INSERT INTO events VALUES ( 3, 'Richard');
INSERT INTO events VALUES (13, 'Richard');
INSERT INTO events VALUES (23, 'Richard');
INSERT INTO events VALUES (33, 'Richard');
INSERT INTO events VALUES (43, 'Richard');
INSERT INTO events VALUES (54, 'Richard');
INSERT INTO events VALUES (63, 'Richard');
INSERT INTO events VALUES ( 2, 'Sam');
INSERT INTO events VALUES (12, 'Sam');
INSERT INTO events VALUES (22, 'Sam');
INSERT INTO events VALUES (32, 'Sam');
INSERT INTO events VALUES (43, 'Sam');
INSERT INTO events VALUES (47, 'Sam');
INSERT INTO events VALUES (48, 'Sam');
INSERT INTO events VALUES (59, 'Sam');
INSERT INTO events VALUES (60, 'Sam');
INSERT INTO events VALUES (68, 'Sam');
COMMIT;

--
SELECT time_stamp, user_id, session_id FROM events
MATCH_RECOGNIZE (
    PARTITION BY user_id
    ORDER BY time_stamp
    MEASURES MATCH_NUMBER () AS session_id
    ALL ROWS PER MATCH
    PATTERN (b s*)
    DEFINE s AS s.time_stamp - PREV (time_stamp) <= 10)
ORDER BY user_id, time_stamp;

--
SELECT session_id, user_id, start_time, no_of_events, duration FROM events
MATCH_RECOGNIZE (
    PARTITION BY user_id
    ORDER BY time_stamp
    MEASURES
        MATCH_NUMBER ()                        AS session_id
      , COUNT (*)                              AS no_of_events
      , FIRST (time_stamp)                     AS start_time
      , LAST (time_stamp) - FIRST (time_stamp) AS duration
    PATTERN (b s*)
    DEFINE s AS s.time_stamp - PREV (time_stamp) <= 10)
ORDER BY user_id, session_id;

--
DROP TABLE my_cdr PURGE;
CREATE TABLE my_cdr (caller NUMBER, callee NUMBER, start_time NUMBER, end_time NUMBER);

INSERT INTO my_cdr VALUES (1, 7,   1354,   1575);
INSERT INTO my_cdr VALUES (1, 7,   1603,   1829);
INSERT INTO my_cdr VALUES (1, 7,   1857,   2301);
INSERT INTO my_cdr VALUES (1, 7,   2320,   2819);
INSERT INTO my_cdr VALUES (1, 7,   2840,   2964);
INSERT INTO my_cdr VALUES (1, 7,  64342,  64457);
INSERT INTO my_cdr VALUES (1, 7,  85753,  85790);
INSERT INTO my_cdr VALUES (1, 7,  85808,  85985);
INSERT INTO my_cdr VALUES (1, 7,  86011,  86412);
INSERT INTO my_cdr VALUES (1, 7,  86437,  86546);
INSERT INTO my_cdr VALUES (1, 7, 163436, 163505);
INSERT INTO my_cdr VALUES (1, 7, 163534, 163967);
INSERT INTO my_cdr VALUES (1, 7, 163982, 164454);
INSERT INTO my_cdr VALUES (1, 7, 214677, 214764);
INSERT INTO my_cdr VALUES (1, 7, 214782, 215248);
INSERT INTO my_cdr VALUES (1, 7, 216056, 216271);
INSERT INTO my_cdr VALUES (1, 7, 216297, 216728);
INSERT INTO my_cdr VALUES (1, 7, 216747, 216853);
INSERT INTO my_cdr VALUES (1, 7, 261138, 261463);
INSERT INTO my_cdr VALUES (1, 7, 261493, 261864);
INSERT INTO my_cdr VALUES (1, 7, 261890, 262098);
INSERT INTO my_cdr VALUES (1, 7, 262115, 262655);
INSERT INTO my_cdr VALUES (1, 7, 301931, 302226);
INSERT INTO my_cdr VALUES (1, 7, 302248, 302779);
INSERT INTO my_cdr VALUES (1, 7, 302804, 302992);
INSERT INTO my_cdr VALUES (1, 7, 303015, 303258);
INSERT INTO my_cdr VALUES (1, 7, 303283, 303337);
INSERT INTO my_cdr VALUES (1, 7, 383019, 383378);
INSERT INTO my_cdr VALUES (1, 7, 383407, 383534);
INSERT INTO my_cdr VALUES (1, 7, 424800, 425096);
COMMIT;

--
SELECT  caller, callee, start_time, effective_call_duration
      , (end_time - start_time) - effective_call_duration AS total_interruption_duration
      , no_of_restarts, session_id
  FROM my_cdr
MATCH_RECOGNIZE (
    PARTITION BY caller, callee
    ORDER BY start_time
    MEASURES
        a.start_time                AS start_time
      , end_time                    AS end_time
      , SUM (end_time - start_time) AS effective_call_duration
      , COUNT (b.*)                 AS no_of_restarts
      , MATCH_NUMBER ()             AS session_id
    PATTERN (a b*)
    DEFINE b AS b.start_time - PREV (b.end_time) < 60);

--
DROP TABLE event_log PURGE;

CREATE TABLE event_log (
    time        DATE
  , userid      VARCHAR2(30)
  , amount      NUMBER(10)
  , event       VARCHAR2(10)
  , transfer_to VARCHAR2(10)
);

INSERT INTO event_log VALUES (DATE '2012-01-01', 'john', 1000000, 'deposit' ,  NULL);
INSERT INTO event_log VALUES (DATE '2012-01-05', 'john', 1200000, 'deposit' ,  NULL);
INSERT INTO event_log VALUES (DATE '2012-01-06', 'john',    1000, 'transfer', 'bob');
INSERT INTO event_log VALUES (DATE '2012-01-15', 'john',    1500, 'transfer', 'bob');
INSERT INTO event_log VALUES (DATE '2012-01-20', 'john',    1500, 'transfer', 'allen');
INSERT INTO event_log VALUES (DATE '2012-01-23', 'john',    1000, 'transfer', 'tim');
INSERT INTO event_log VALUES (DATE '2012-01-26', 'john', 1000000, 'transfer', 'tim');
INSERT INTO event_log VALUES (DATE '2012-01-27', 'john',  500000, 'deposit' ,  NULL);
COMMIT;

--
SELECT * FROM (SELECT * FROM event_log WHERE event = 'transfer')
MATCH_RECOGNIZE (
    PARTITION BY userid
    ORDER BY time
    ALL ROWS PER MATCH
    PATTERN (z x{2,} y)
    DEFINE z AS (    event = 'transfer'
                 AND amount <  2000),
           x AS (    event = 'transfer'
                 AND amount <= 2000
                 AND PREV (x.transfer_to) != x.transfer_to),
           y AS (    event = 'transfer'
                 AND amount >= 1000000
                 AND LAST (x.time) - z.time < 30
                 AND y.time - LAST (x.time) < 10
                 AND SUM (x.amount) + z.amount < 20000));
