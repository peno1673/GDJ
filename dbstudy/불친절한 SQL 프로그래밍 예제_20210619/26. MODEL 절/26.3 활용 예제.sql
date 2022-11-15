--
SELECT   product, country, sales
    FROM sales_view
   WHERE country IN ('Italy', 'Spain')
     AND product IN ('Bounce', 'Finding Fido')
GROUP BY product, country
   MODEL PARTITION BY (product)
         DIMENSION BY (country)
         MEASURES (SUM (sales) AS sales)
         RULES UPSERT (sales['DIFF ITALY-SPAIN'] = sales['Italy'] - sales['Spain']);

--
DROP TABLE sales_view2 PURGE;

CREATE TABLE sales_view2 AS
SELECT   e.country_name AS country, b.prod_name AS product
       , d.calendar_year AS year, d.calendar_month_name AS month
       , SUM (a.amount_sold) AS sale, COUNT (a.amount_sold) AS cnt
    FROM sh.sales a, sh.products b, sh.customers c, sh.times d, sh.countries e
   WHERE b.prod_id = a.prod_id
     AND c.cust_id = a.cust_id
     AND d.time_id = a.time_id
     AND e.country_id = c.country_id
GROUP BY e.country_name, b.prod_name, d.calendar_year, d.calendar_month_name;

--
DESC sales_view2

--
SELECT   country, SUM (sales) AS sales
    FROM (SELECT product, country, month, sales
            FROM sales_view2
           WHERE year = 2000
             AND month IN ('October', 'November')
           MODEL PARTITION BY (product, country)
                 DIMENSION BY (month)
                 MEASURES (sale AS sales)
                 RULES (sales['December'] = (sales['November'] / sales['October']) * sales['November']))
GROUP BY GROUPING SETS ((), (country));

--
DROP TABLE cash_flow PURGE;
CREATE TABLE cash_flow (year DATE, i NUMBER, prod VARCHAR2(3), amount NUMBER);

INSERT INTO cash_flow VALUES (TO_DATE ('1999', 'YYYY'), 0, 'vcr', -100.00);
INSERT INTO cash_flow VALUES (TO_DATE ('2000', 'YYYY'), 1, 'vcr',   12.00);
INSERT INTO cash_flow VALUES (TO_DATE ('2001', 'YYYY'), 2, 'vcr',   10.00);
INSERT INTO cash_flow VALUES (TO_DATE ('2002', 'YYYY'), 3, 'vcr',   20.00);
INSERT INTO cash_flow VALUES (TO_DATE ('1999', 'YYYY'), 0, 'dvd', -200.00);
INSERT INTO cash_flow VALUES (TO_DATE ('2000', 'YYYY'), 1, 'dvd',   22.00);
INSERT INTO cash_flow VALUES (TO_DATE ('2001', 'YYYY'), 2, 'dvd',   12.00);
INSERT INTO cash_flow VALUES (TO_DATE ('2002', 'YYYY'), 3, 'dvd',   14.00);
COMMIT;

--
SELECT year, i, prod, amount, npv
  FROM cash_flow
 MODEL PARTITION BY (prod)
       DIMENSION BY (i)
       MEASURES (amount, 0 AS npv, year)
       RULES (
           npv[0] = amount[0]
         , npv[i != 0] ORDER BY i = amount[CV ()] / POWER (1.14, CV (i)) + npv[CV (i) - 1]);

--
DROP TABLE ledger PURGE;
CREATE TABLE ledger (account VARCHAR2(20), balance NUMBER(10,2));

INSERT INTO ledger VALUES ('Salary',        100000);
INSERT INTO ledger VALUES ('Capital_gains',  15000);
INSERT INTO ledger VALUES ('Net',                0);
INSERT INTO ledger VALUES ('Tax',                0);
INSERT INTO ledger VALUES ('Interest',           0);
COMMIT;

--
SELECT account, s
  FROM ledger
  MODEL DIMENSION BY (account)
        MEASURES (balance s)
        RULES ITERATE (100) (
            s['Net'] =  s['Salary'] - s['Interest'] - s['Tax']
          , s['Tax'] = (s['Salary'] - s['Interest']) * 0.38 + s['Capital_gains'] * 0.28
          , s['Interest'] = s['Net'] * 0.30);

--
SELECT   *
    FROM (SELECT country, product, year, projected_sale, sales
            FROM sales_view
           WHERE country IN ('Italy', 'Japan')
             AND product IN ('Bounce')
           MODEL PARTITION BY (country)
                 DIMENSION BY (product, year)
                 MEASURES (sales sales, year y, CAST(NULL AS NUMBER) projected_sale)
                 RULES (projected_sale[FOR product IN ('Bounce'), 2001] = sales[CV (), 2000] + REGR_SLOPE (sales, y)[CV (), year BETWEEN 1998 AND 2000]))
ORDER BY 1, 2, 3;
