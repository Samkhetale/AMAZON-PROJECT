create database Amazon;
use amazon;
select* from amazon;

ALTER TABLE amazon
RENAME COLUMN `Customer type` TO `Customer_type`;

ALTER TABLE amazon
RENAME COLUMN `Total` TO `TOTAL_SALE`;

ALTER TABLE amazon
RENAME COLUMN `product_category` TO `product_line`;

ALTER TABLE amazon
RENAME COLUMN `Unit price` TO `Unit_price`;

ALTER TABLE amazon
RENAME COLUMN `Tax_5%` TO `Tax`;

ALTER TABLE amazon
RENAME COLUMN `COST%` TO `COST`;

ALTER TABLE amazon
RENAME COLUMN `Gross margin percentage` TO `Gross_margin_%`;

ALTER TABLE amazon
RENAME COLUMN `Gross income` TO `Gross_income`;

-- add a new column timeofday
ALTER TABLE amazon ADD COLUMN Timeofday varchar(10);

set sql_safe_updates=0;

UPDATE AMAZON
SET TIMEOFDAY = CASE
    WHEN HOUR(TIME) BETWEEN 5 AND 12 THEN 'Morning'
    WHEN HOUR(TIME) BETWEEN 12 AND 16 THEN 'Afternoon'
    ELSE 'Evening'
END
WHERE TIME IS NOT NULL; 
-- add a new column monthname
 ALTER TABLE AMAZON ADD monthname VARCHAR(20);

UPDATE AMAZON
SET monthname = MONTHNAME(date);
UPDATE AMAZON
SET date = STR_TO_DATE(date, '%d-%m-%Y');

SELECT COUNT(*)
FROM AMAZON 
WHERE Quantity is null;

UPDATE AMAZON
SET dayname = DAYNAME(date);

-- EXPLORATORY DATA ANALYSIS(EDA) 

-- Q.1 WHAT IS THE COUNT OF DISTINCT CITIES IN THE DATASET
SELECT COUNT(DISTINCT CITY)AS CITY  FROM AMAZON;

-- Q.2 FOR EACH BRANCH WHAT IS THE CORRESPONDING CITY

SELECT BRANCH,CITY  FROM amazon GROUP BY BRANCH,CITY;

-- Q.3 WHAT IS THE COUNT OF DISTINCT PORDUCT LINES IN THE DATASET

SELECT  COUNT(DISTINCT product_line) AS DISTINCT_product_line FROM AMAZON;
SHOW COLUMNS FROM AMAZON;

-- Q 4 WHICH PAYMENT METHOD OCCURS MOST FEQUENTLY

SELECT PAYMENT,COUNT(*) AS FEQUENTLY
FROM AMAZON
GROUP BY PAYMENT
LIMIT 1;

-- Q 5 WHICH PRODUCT LINE HAS THE HIGHEST SALE
SELECT PRODUCT_line, COUNT(TOTAL_SALE)as highest_sale
from amazon
group by product_line
order by highest_sale desc;

-- Q 6 HOW MUCH REVENUE IS GENETRED EACH MONTH
SELECT monthname,SUM(TOTAL_SALE) AS EACH_MONTH_REVENUE
FROM AMAZON
GROUP BY monthname
ORDER BY monthname DESC;

-- Q 7  IN WHICH  MONTH DID COST OF  GOODS SOLD REACH ITS PEAK
SELECT  monthname,round(SUM(COST),2) as MONTH_COST 
FROM  AMAZON 
GROUP BY monthname
ORDER BY MONTH_COST DESC
;

-- 8 WHICH PRODUCT LINE INCURRED THE HIGHEST REVENUE

SELECT PRODUCT_line,round( SUM(total_sale),2) AS highest_revenue
FROM amazon
GROUP BY PRODUCT_line
ORDER BY highest_revenue DESC
;

 
 -- Q 9  which city was  the highest revenue recored 
 SELECT city, ROUND(SUM(total_sale), 2) AS HIGHEST_REVENUE_RECORDED
FROM AMAZON
GROUP BY city
ORDER BY HIGHEST_REVENUE_RECORDED DESC;


 
 --  Q.10 WHICH PRODUCT LINE  INCURRED THE HIGHEST VALUE ADDED TAX
	 SELECT PRODUCT_LINE,ROUND(sum(TAX),2)AS HIGHEST_VALUE_ADDED_TAX
	 FROM AMAZON 
	 GROUP BY PRODUCT_LINE
	 ORDER BY  HIGHEST_VALUE_ADDED_TAX DESC
     ;
   
   -- Q 11  FOR EACH PRODUCT  LINE  ADD A COLUMN INDICCATING "GOOD" IF ITS SALES ARE  ABOVE 
   -- AVERAGE, OTHERWISE "BAD 
   SELECT
    Product_Line,
    total_sale,
    CASE
        WHEN Total_Sale > (SELECT AVG(Total_Sale) FROM  amazon) THEN 'GOOD'
        ELSE 'BAD'
    END AS SalesCategory
FROM amazon;   

--  Q 12 identify  the branch  that exceeded the  average  number of products sold

select branch, city,avg(quantity) as total_products_sold 
from amazon
group by branch,city
order by total_products_sold  desc;

 -- Q 13  WHICH PRODUCT  LINE IS MOST FREQUENTLY ASSSOCIATED WITH  EACH GENDER
SELECT Gender,product_line, count(*) as frequency  
from amazon
group by gender,product_line 
order by gender,frequency desc;

with  rankdproductlines as (
select gender,product_line,count(*) as frequency,
row_number()over (partition  by gender order by  count(*) desc) as rn
 from amazon 
 group by gender,product_line)
 select gender,product_line,frequency
 from   rankdproductlines
 where rn= 1;
 -- Q 15 COUNT THE SALES OCCURRENCES  FOR EACH TIME OF DAY ON EVERY WEEK  DAY
 SELECT DAYNAME,TIMEOFDAY,COUNT(*) AS SALES_OCCURRENCES 
 FROM AMAZON 
 GROUP BY DAYNAME,TIMEOFDAY
 ORDER BY DAYNAME, SALES_OCCURRENCES desc;
 
 WITH  SALESOCCURRENCES AS (
 SELECT DAYNAME, TIMEOFDAY,COUNT(total_sale) AS OCCURRENCES 
 FROM AMAZON 
 GROUP BY DAYNAME , TIMEOFDAY
 )
 SELECT DAYNAME,TIMEOFDAY,COUNT(total_sale) AS OCCURRENCES
 FROM AMAZON 
 group by dayname,timeofday
 ORDER BY DAYNAME,OCCURRENCES DESC;
 
 --  16 IDENTITY  THE  CUSTOMER TYPE CONTRIBUTING THE  HIGHEST REVENUE 
 SELECT CUSTOMER_TYPE, COUNT(TOTAL_SALE) AS  HIGEST_REVENUE FROM AMAZON 
 GROUP BY CUSTOMER_TYPE
 ORDER BY HIGEST_REVENUE  DESC;
 
 --  Q 17 DETERMINNE  THE CITY  WITH THE HIGHEST VAT PERCNTAGE
 
 SELECT CITY ,AVG(TAX) AS AVG_VAT 
 FROM AMAZON 
 GROUP BY CITY 
 ORDER BY AVG_VAT DESC;
 
 -- Q 18 IDENTIFY THE CUSTOMER TYPE WITH THE  HIGHEST VAT  PAYMENTS.
 SELECT CUSTOMER_TYPE , AVG( TAX)AS VAT 
 FROM AMAZON 
 GROUP BY CUSTOMER_TYPE
 ORDER BY VAT 
 LIMIT 1;
 
 -- Q 19 WHAT IS THE COUNT OF DISTINCT CUSTOMER TYPES IN THE  DATASET
 
 SELECT   COUNT(DISTINCT CUSTOMER_TYPE)AS DISTINCT_CUSTOMMER_TYPE
 FROM AMAZON;
 
 -- Q 20 WHAT IS THE  COUNT OF DISTINCT PAYMENT METHODS  IN  THE DATASET
 SELECT COUNT(DISTINCT PAYMENT) AS PAYMENT_METHOD
 FROM AMAZON;
 
 -- Q 21 WHICH CUSTOMER  TYPE OCCURS  MOST FREQUENTLY 
 SELECT CUSTOMER_TYPE,COUNT(*) AS  MOST_FREQUENTLY_CUSTMOER
 FROM AMAZON 
 GROUP BY CUSTOMER_TYPE
 ORDER BY MOST_FREQUENTLY_CUSTMOER  DESC
 LIMIT 1;
 
 -- Q 22 IDENTIFY THE CUSTOMER TYPE WITH THE HIGEST  PURCHASE FREQUENCY
 SELECT CUSTOMER_TYPE,  round(sum(total_sale),2)AS HIGEST_PURCHASE_FREQUENCY
 FROM AMAZON
 GROUP BY CUSTOMER_TYPE 
 ORDER BY HIGEST_PURCHASE_FREQUENCY DESC 
 ; 
 
 -- Q 23 DETERMINE THE PREDOMINANT GENDER  AMONG  CUSTOMERS 
 SELECT GENDER,COUNT(*) AS FREQUENCY
 FROM AMAZON
 GROUP BY GENDER
 ORDER BY FREQUENCY DESC
 LIMIT 1;
 
 -- Q 24  EXAMMINE THE DISTRIBUTION OF GENDERS WITHIN EACH BRANCH
 SELECT GENDER,CITY, BRANCH, COUNT(*) AS BRANCH_DISTRIBUTION
 FROM AMAZON 
 GROUP BY GENDER,CITY, BRANCH
 ORDER BY  BRANCH,BRANCH_DISTRIBUTION DESC;
 
 

 SELECT CITY, BRANCH,
       SUM(CASE WHEN GENDER = 'Male' THEN 1 ELSE 0 END) AS Male_Count,
       SUM(CASE WHEN GENDER = 'Female' THEN 1 ELSE 0 END) AS Female_Count
FROM AMAZON
GROUP BY CITY, BRANCH
ORDER BY BRANCH, CITY;

-- 25 IDENTITY THE TIME OF DAY WHEN  CUSTOMERS PROVIDE THE  MOST RATIING FOR EACH

SELECT CUSTOMER_TYPE, Timeofday, COUNT(Rating) AS Most_Rating
FROM AMAZON
GROUP BY CUSTOMER_TYPE, Timeofday
ORDER BY CUSTOMER_TYPE, Most_Rating DESC;

-- Q 26 DETERMINE THE TIME OF DAY WITH THE HIGHEST CUSTOMER RATINGS FOR EACH BRANCH
SELECT BRANCH,TIMEOFDAY, AVG(RATING) AS EACH_BRANCH_RATINGS
FROM AMAZON 
GROUP BY BRANCH,TIMEOFDAY
ORDER BY BRANCH,EACH_BRANCh_RATINGS DESC;

-- Q 27 IDENTIFY THE DAY OF THE WEEK WITH THE HIGHEST AVERAGE RATINGS
SELECT DAYNAME,AVG(RATING) AS HIGHEST_RATINGS 
FROM AMAZON 
GROUP BY DAYNAME 
ORDER BY HIGHEST_RATINGS DESC LIMIT 1 ;

 -- Q  28 DETERMINE THE DAY  OF THE HIGHEST AVERAGE EATING  FOR EACH BRANCH
 SELECT DAYNAME,BRANCH,AVG(RATING) AS EACH_BRANCH_RATINGS
 FROM AMAZON 
 GROUP BY DAYNAME,BRANCH
 ORDER BY BRANCH,EACH_BRANCH_RATINGS DESC;



 
 


     
     
 































