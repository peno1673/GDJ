--
DROP TABLE sales_view PURGE;

CREATE TABLE sales_view AS
SELECT   e.country_name AS country, b.prod_name AS product, d.calendar_year AS year
       , SUM (a.amount_sold) AS sales, COUNT (a.amount_sold) AS cnt
       , MAX (d.calendar_year) KEEP (DENSE_RANK FIRST ORDER BY SUM (a.amount_sold) DESC) OVER (PARTITION BY e.country_name, b.prod_name) AS best_year
       , MAX (d.calendar_year) KEEP (DENSE_RANK LAST  ORDER BY SUM (a.amount_sold) DESC) OVER (PARTITION BY e.country_name, b.prod_name) AS worst_year
    FROM sh.sales a, sh.products b, sh.customers c, sh.times d, sh.countries e
   WHERE b.prod_id = a.prod_id
     AND c.cust_id = a.cust_id
     AND d.time_id = a.time_id
     AND e.country_id = c.country_id
GROUP BY e.country_name, b.prod_name, d.calendar_year;

--
DESC sales_view

--
select * from sales_view;

--
SELECT   country, product, year, sales  -- (1)
    FROM sales_view
   WHERE country IN ('Italy', 'Japan')
     AND product IN ('Bounce', 'Y Box')
     AND year IN (2000, 2001)
   MODEL PARTITION BY (country)         -- (2)
         DIMENSION BY (product, year)   -- (3)
         MEASURES (sales)               -- (4)
         RULES (                        -- (5)
             sales['Bounce', 2002] = sales['Bounce', 2001] + sales['Bounce', 2000]
           , sales['Y Box' , 2002] = sales['Y Box' , 2001] + sales['Bounce', 2000])
ORDER BY country, product, year         -- (6)
;

--
SELECT product, year, sales
  FROM sales_view
 WHERE country = 'Poland'
   AND product = 'Bounce'
 MODEL IGNORE NAV
       DIMENSION BY (product, year)
       MEASURES (sales sales)
       RULES (sales['Bounce', 2003] = sales['Bounce', 2002] + sales['Bounce', 2001]);

--
SELECT country, product, sales FROM sales_view WHERE country = 'France' AND product= 'Bounce';

--
SELECT country, product, sales
  FROM sales_view
 WHERE country = 'France'
   AND product= 'Bounce'
 MODEL UNIQUE DIMENSION
       PARTITION BY (country)
       DIMENSION BY (product)
       MEASURES (sales)
       RULES (sales['Bounce'] = MAX (sales)['Bounce'] * 1.24);

--
SELECT country, product, sales
  FROM sales_view
 WHERE country = 'France'
   AND product= 'Bounce'
 MODEL UNIQUE SINGLE REFERENCE
       PARTITION BY (country)
       DIMENSION BY (product)
       MEASURES (sales)
       RULES (sales['Bounce'] = MAX (sales)['Bounce'] * 1.24);

--
SELECT country, product, sales
  FROM sales_view
 WHERE country = 'France'
   AND product= 'Bounce'
 MODEL UNIQUE SINGLE REFERENCE
       PARTITION BY (country)
       DIMENSION BY (product)
       MEASURES (sales)
       RULES (sales['Bounce'] = sales[CV ()] * 1.24);

--
SELECT   country, product, year, sales
    FROM sales_view
   WHERE country IN ('Italy', 'Japan')
     AND product IN ('Bounce', 'Y Box')
     AND year IN (2000, 2001)
   MODEL RETURN UPDATED ROWS
         PARTITION BY (country)
         DIMENSION BY (product, year)
         MEASURES (sales)
         RULES (sales['Bounce', 2002] = sales['Bounce', 2001] + sales['Bounce', 2000]
              , sales['Y Box' , 2002] = sales['Y Box' , 2001] + sales['Bounce', 2000])
ORDER BY 1, 2, 3;

--
DROP TABLE dollar_conv_tbl PURGE;
CREATE TABLE dollar_conv_tbl(country VARCHAR2(30), exchange_rate NUMBER);

INSERT INTO dollar_conv_tbl VALUES ('Poland', 0.25);
INSERT INTO dollar_conv_tbl VALUES ('France', 0.14);
COMMIT;

--
SELECT   country, year, sales, dollar_sales
    FROM sales_view
   WHERE country IN ('France', 'Poland')
GROUP BY country, year
   MODEL KEEP NAV   -- 셀 참조 옵션 (전역)
   REFERENCE conv_ref
         ON (SELECT country, exchange_rate FROM dollar_conv_tbl)
         DIMENSION BY (country)
         MEASURES (exchange_rate)
         IGNORE NAV -- 셀 참조 옵션 (지역)
   MAIN conversion
         DIMENSION BY (country, year)
         MEASURES (SUM(sales) AS sales, SUM(sales) AS dollar_sales)
         RULES (
             dollar_sales['France', 2001] = sales[CV (country), 2000] * 1.02 * conv_ref.exchange_rate['France']
           , dollar_sales['Poland', 2001] = sales['Poland', 2000] * 1.05 * exchange_rate['Poland']);

--
DROP TABLE growth_rate_tbl PURGE;
CREATE TABLE growth_rate_tbl (country VARCHAR2(30), year NUMBER, growth_rate NUMBER);

INSERT INTO growth_rate_tbl VALUES('Poland', 2002, 2.5);
INSERT INTO growth_rate_tbl VALUES('Poland', 2003, 5);
INSERT INTO growth_rate_tbl VALUES('France', 2002, 3);
INSERT INTO growth_rate_tbl VALUES('France', 2003, 2.5);
COMMIT;

--
SELECT   country, year, sales, dollar_sales
    FROM sales_view
   WHERE country = 'France'
GROUP BY country, year
   MODEL RETURN UPDATED ROWS
   REFERENCE conv_ref
         ON (SELECT country, exchange_rate FROM dollar_conv_tbl)
         DIMENSION BY (country AS c)
         MEASURES (exchange_rate)
   REFERENCE growth_ref
         ON (SELECT country, year, growth_rate FROM growth_rate_tbl)
         DIMENSION BY (country AS c, year AS y)
         MEASURES (growth_rate)
   MAIN projection
         DIMENSION BY (country, year)
         MEASURES (SUM(sales) AS sales, 0 AS dollar_sales)
         RULES (dollar_sales[ANY, 2001] = sales[CV (country), 2000] * growth_rate[CV (country), CV (year)] * exchange_rate[CV (country)]);

--
DROP TABLE year_2_seq PURGE;

CREATE TABLE year_2_seq (i, year) AS
SELECT ROW_NUMBER() OVER (ORDER BY calendar_year) AS i, calendar_year AS year
  FROM (SELECT DISTINCT calendar_year FROM sh.times);

--
SELECT * FROM year_2_seq;

--
SELECT   country, product, year, sales, prior_period
    FROM sales_view
   WHERE country = 'France'
     AND product = 'Bounce'
   MODEL
   REFERENCE y2i ON (SELECT year, i FROM year_2_seq)
         DIMENSION BY (year AS y)
         MEASURES (i)
   REFERENCE i2y ON (SELECT year, i FROM year_2_seq)
         DIMENSION BY (i)
         MEASURES (year AS y)
   MAIN projection2
         PARTITION BY (country)
         DIMENSION BY (product, year)
         MEASURES (sales, CAST(NULL AS NUMBER) AS prior_period)
         RULES (prior_period[ANY, ANY] = sales[CV (product), i2y.y[y2i.i[CV (year)] - 1]])
ORDER BY 1, 2, 3;
