--
SELECT *
  FROM sales_view
 WHERE country = 'Poland'
 MODEL DIMENSION BY (product, year)
       MEASURES (sales)
       RULES UPSERT (sales['Bounce', 2003] = sales['Bounce', 2002] + (SELECT SUM (sales) FROM sales_view));

--
SELECT *
  FROM sales_view
 WHERE country = 'Poland'
 MODEL DIMENSION BY (product, year)
       MEASURES (sales, (SELECT SUM(sales) FROM sales_view) AS grand_total)
       RULES UPSERT (sales['Bounce', 2003] = sales['Bounce', 2002] + grand_total['Bounce', 2002]);

--
SELECT   country, product, year, s
    FROM sales_view
   MODEL RETURN UPDATED ROWS
         DIMENSION BY (country, product, year)
         MEASURES (sales AS s)
         RULES UPSERT (
             s[FOR (country, product, year) IN (SELECT DISTINCT 'new_country', product, YEAR FROM sales_view WHERE product = 'Bounce')] = s['France', CV (), CV ()])
ORDER BY 1, 2, 3;

--
SELECT x, s
  FROM DUAL
 MODEL DIMENSION BY (1 AS x)
       MEASURES (1024 AS s)
       RULES UPDATE ITERATE (4) (s[1] = s[1] / 2);

--
SELECT x, s, iterations
  FROM DUAL
 MODEL DIMENSION BY (1 AS x)
       MEASURES (1024 AS s, 0 AS iterations)
       RULES ITERATE (1000) UNTIL ABS (PREVIOUS (s[1]) - s[1]) < 1 (s[1] = s[1] / 2, iterations[1] = ITERATION_NUMBER);

--
SELECT   country, product, year, sales
    FROM sales_view
   WHERE country = 'France'
     AND product = 'Bounce'
   MODEL PARTITION BY (country)
         DIMENSION BY (product, year)
         MEASURES (sales)
         RULES ITERATE (3) (sales['Bounce', 2002 + ITERATION_NUMBER] = sales['Bounce', 1999 + ITERATION_NUMBER])
ORDER BY 1, 2, 3;

--
SELECT   country, product, year, sales
    FROM sales_view
   WHERE country = 'France'
   MODEL RETURN UPDATED ROWS
         PARTITION BY (country)
         DIMENSION BY (product, year)
         MEASURES (sales)
         RULES AUTOMATIC ORDER (
             sales['SUV', 2001] = 10000                                      -- (1) or (2)
           , sales['Standard Mouse', 2001]
           = sales['Finding Fido', 2001] * 0.10 + sales['Boat', 2001] * 0.50 -- (4)
           , sales['Boat', 2001]
           = sales['Finding Fido', 2001] * 0.25 + sales['SUV' , 2001] * 0.75 -- (3)
           , sales['Finding Fido', 2001] = 20000                             -- (2) or (1)
         )
ORDER BY 1, 2, 3;

--
SELECT   calendar_year AS t, SUM (amount_sold) AS s
    FROM sh.sales, sh.times
   WHERE sales.time_id = times.time_id
GROUP BY calendar_year;

--
SELECT   t, s
    FROM sh.sales, sh.times
   WHERE sales.time_id = times.time_id
GROUP BY calendar_year
   MODEL DIMENSION BY (calendar_year AS t)
         MEASURES (SUM (amount_sold) AS s)
         RULES SEQUENTIAL ORDER (s[ANY] = s[CV (t) - 1])
ORDER BY 1;

--
SELECT   t, s
    FROM sh.sales, sh.times
   WHERE sales.time_id = times.time_id
GROUP BY calendar_year
   MODEL DIMENSION BY (calendar_year AS t)
         MEASURES (SUM (amount_sold) AS s)
         RULES SEQUENTIAL ORDER (s[ANY] ORDER BY t DESC = s[CV (t) - 1])
ORDER BY 1;

--
SELECT   t, s
    FROM sh.sales, sh.times
   WHERE sales.time_id = times.time_id
GROUP BY calendar_year
   MODEL DIMENSION BY (calendar_year AS t)
         MEASURES (SUM (amount_sold) AS s)
         RULES AUTOMATIC ORDER (s[ANY] = s[CV (t) - 1])
ORDER BY 1;

--
SELECT   t, s
    FROM sh.sales, sh.times
   WHERE sales.time_id = times.time_id
GROUP BY calendar_year
   MODEL DIMENSION BY (calendar_year AS t)
         MEASURES (SUM (amount_sold) AS s)
         RULES AUTOMATIC ORDER (s[ANY] ORDER BY t DESC = s[CV (t) - 1])
ORDER BY 1;

--
DROP TABLE sales_rollup_time PURGE;

CREATE TABLE sales_rollup_time AS
SELECT   d.country_name AS country, c.calendar_year AS year
       , c.calendar_quarter_desc AS quarter
       , GROUPING_ID (c.calendar_year, c.calendar_quarter_desc) AS gid
       , SUM (a.amount_sold) AS sale, COUNT (a.amount_sold) AS cnt
    FROM sh.sales a, sh.customers b, sh.times c, sh.countries d
   WHERE b.cust_id = a.cust_id
     AND c.time_id = a.time_id
     AND d.country_id = b.country_id
GROUP BY d.country_name, c.calendar_year, ROLLUP (c.calendar_quarter_desc);

--
DESC sales_rollup_time

--
SELECT   country, year, quarter, sale, csum
    FROM sales_rollup_time
   WHERE country = 'United Kingdom'
   MODEL DIMENSION BY (country, year, quarter)
         MEASURES (sale, gid, 0 AS csum)
         RULES (csum[ANY, ANY, ANY] = SUM (sale) OVER (PARTITION BY country, DECODE (gid, 0, year, NULL) ORDER BY year, quarter ROWS UNBOUNDED PRECEDING))
ORDER BY 1, 2, 3;

--
WITH w1 AS (
SELECT country, product, year, s, rnk
  FROM sales_view
 WHERE country = 'France'
   AND product = 'Bounce'
 MODEL PARTITION BY (country)
       DIMENSION BY (product, year)
       MEASURES (sales AS s, year AS y, RANK () OVER (ORDER BY sales) AS rnk)
       RULES UPSERT (
           s['Bounce Increase 90-99', 2001] = REGR_SLOPE (s, y)['Bounce', year BETWEEN 1990 AND 2000]
         , s['Bounce', 2001] = s['Bounce', 2000] * (1 + s['Bounce Increase 90-99', 2001])))
SELECT   country, product, year, s, rnk
    FROM w1
   WHERE product != 'Bounce Increase 90-99'
ORDER BY 1, 2, 3, 5;
