--
USE customer_purchase_behaviour;

SELECT*
FROM
`customer purchase behaviour`;
RENAME TABLE `customer purchase behaviour` TO purchase_behaviour;

SELECT * 
FROM purchase_behaviour;

SELECT COUNT(*) AS total_records
FROM purchase_behaviour ;


ALTER TABLE purchase_behaviour
CHANGE `Purchase Amount` purchase_amount DOUBLE;


ALTER TABLE purchase_behaviour
CHANGE `Purchase Date` purchase_date text;

ALTER TABLE purchase_behaviour
CHANGE `Product Category` product_category text;

SELECT 
    MIN(YEAR(purchase_date)) AS min_year,
    MAX(YEAR(purchase_date)) AS max_year
FROM purchase_behaviour;

SELECT DISTINCT(product_category)
FROM purchase_behaviour;



DELETE FROM purchase_behaviour
WHERE purchase_date = '';

DELETE FROM purchase_date
WHERE product_category = '';

SELECT DISTINCT (product_category)
FROM purchase_behaviour;

SELECT purchase_date,
str_to_date(purchase_date, '%Y-%m-%d')
FROM purchase_behaviour;

UPDATE purchase_behaviour
SET purchase_date = str_to_date(purchase_date, '%Y-%m-%d');

ALTER TABLE purchase_behaviour
MODIFY COLUMN purchase_date DATE;




-- DEMOGRAPHIC SEGMENTATION (AGE AND GENDER)
SELECT
    CASE
        WHEN Age BETWEEN 18 AND 24 THEN '18-24'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        WHEN Age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS age_group,
    Gender,
    ROUND(SUM(purchase_amount), 2) AS total_spending
FROM
    purchase_behaviour
GROUP BY
    age_group, Gender
ORDER BY
    age_group, Gender;
    
    
    
    
    -- SPENDING PATTERNS
  SELECT
    Gender,
    ROUND(AVG(purchase_amount), 2) AS average_purchase_amount,
    COUNT(*) AS total_transactions
FROM
    purchase_behaviour
GROUP BY
    Gender;
    
    
    
    
-- Seasonality and Trends

SELECT
    MONTH(purchase_date) AS purchase_month,
    ROUND(SUM(purchase_amount), 2) AS total_sales
FROM
    purchase_behaviour
GROUP BY
    purchase_month
ORDER BY
    purchase_month;
    
    
    -- Category Popularity by Demographics



SELECT
    product_category,
    Gender,
    COUNT(*) AS total_purchases,
    ROUND(SUM(purchase_amount), 2) AS total_spending
FROM
    purchase_behaviour
GROUP BY
    product_category, Gender
ORDER BY
    total_spending DESC;
    


--  PEAK MONTH ACROSS THE YEARS

SELECT
    YEAR(purchase_date) AS purchase_year,
    MONTH(purchase_date) AS purchase_month,
    MONTHNAME(purchase_date) AS month_name,
    COUNT(*) AS total_purchases,
    ROUND(SUM(purchase_amount), 2) AS total_spending
FROM
    purchase_behaviour
GROUP BY
    purchase_year, purchase_month, month_name
ORDER BY
    purchase_year, purchase_month, month_name;



SELECT
    purchase_year,
    purchase_month,
    month_name,
    total_purchases,
    ROUND(total_spending, 2) AS total_spending,
    spending_rank
FROM (
    SELECT
        YEAR(purchase_date) AS purchase_year,
        MONTH(purchase_date) AS purchase_month,
        MONTHNAME(purchase_date) AS month_name,
        COUNT(*) AS total_purchases,
        SUM(purchase_amount) AS total_spending,
        RANK() OVER (PARTITION BY YEAR(purchase_date) ORDER BY SUM(purchase_amount) DESC) AS spending_rank
    FROM
        purchase_behaviour
    GROUP BY
        purchase_year, purchase_month, month_name
) AS ranked_months
WHERE spending_rank <= 1
ORDER BY purchase_year;



SELECT country, gender, ROUND(SUM(purchase_amount), 2) AS total_spent
FROM purchase_behaviour
GROUP BY country, gender
ORDER BY country, gender;









    
    









