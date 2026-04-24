-- Project: House Price Analysis (SQL + Machine Learning)

-- Step 1: Understand Your Dataset

-- Typical columns in this dataset:

-- price (target)
-- bedrooms, bathrooms
-- sqft_living, sqft_lot
-- floors
-- condition, grade
-- yr_built
-- zipcode

-- 👉 This is a real estate pricing problem

-- Step 2: Create SQL Database
CREATE DATABASE house_price;
USE house_price;

-- Step 3: Import Dataset into MySQL
-- Method:
-- Right click database
-- Table Data Import Wizard
-- Select kc_house_data.csv
-- Finish

-- Step 4: Data Cleaning (SQL)
SELECT * FROM house_data WHERE price IS NULL;

-- Remove duplicates
SELECT id, COUNT(*)
FROM house_data
GROUP BY id
HAVING COUNT(*) > 1;

-- Step 5: Business Questions (SQL Analysis)

-- Q1. Average house price
SELECT AVG(price) AS avg_price
FROM house_data;

-- avg_price:
-- 540088.1418

-- Q2. Top 5 most expensive houses
SELECT price, bedrooms, sqft_living
FROM house_data
ORDER BY price DESC
LIMIT 5;
 
-- price  bedrooms sqft
-- 7700000	6	 12050
-- 7062500	5	 10040
-- 6885000	6	 9890
-- 5570000	5	 9200
-- 5350000	5	 8000

-- Q3. Price vs number of bedrooms
SELECT bedrooms, AVG(price) AS avg_price
FROM house_data
GROUP BY bedrooms
ORDER BY bedrooms;

-- bedrooms, avg_price
-- 0	409503.8462
-- 1	317642.8844
-- 2	401372.6819
-- 3	466232.0785
-- 4	635419.5042
-- 5	786599.8289
-- 6	825520.6360
-- 7	951184.6579
-- 8	1105076.9231
-- 9	893999.8333
-- 10	819333.3333
-- 11	520000.0000
-- 33	640000.0000

-- Q4. Which zipcode has highest average price
SELECT zipcode, AVG(price) AS avg_price
FROM house_data
GROUP BY zipcode
ORDER BY avg_price DESC
LIMIT 5;

-- zipcode  avg_price
-- 98039	2160606.6000
-- 98004	1355927.0820
-- 98040	1194230.0213
-- 98112	1095499.3420
-- 98102	901258.2667

-- Q5. Houses with waterfront (premium analysis)
SELECT waterfront, AVG(price) AS avg_price
FROM house_data
GROUP BY waterfront;

-- waterfront avg_price
-- 0	      531563.5998
-- 1	      1661876.0245

-- Q6. New vs old houses price
SELECT
	CASE
		WHEN yr_built > 2000 THEN 'New'
        ELSE 'Old'
	END AS house_type,
    AVG(price) AS avg_price
FROM house_data
GROUP BY house_type;

-- house_type avg_price
-- Old	      520078.4892
-- New	      615314.9176

-- Q7. Top locations by number of houses
SELECT zipcode, COUNT(*) AS total_houses
FROM house_data
GROUP BY zipcode
ORDER BY total_houses DESC
LIMIT 5;

-- zipcode total_houses       
-- 98103	602
-- 98038	590
-- 98115	583
-- 98052	574
-- 98117	553

-- Q8. Correlation idea (manual insight)
SELECT sqft_living, price
FROM house_data
ORDER BY sqft_living DESC
LIMIT 10;

-- sqft_living price
-- 13540	   2280000
-- 12050	   7700000
-- 10040	   7062500
-- 9890	       6885000
-- 9640	       4668000
-- 9200	       5570000
-- 8670	       2888000
-- 8020	       3300000
-- 8010	       5110800
-- 8000	       5350000

-- Q9. Houses above average price
SELECT * FROM house_data
WHERE price > (SELECT AVG(price) FROM house_data);

-- Q10. Rank houses by price
SELECT 
    id,
    price,
    RANK() OVER (ORDER BY price DESC) AS rank_
FROM house_data;

-- Q11. Compare houses in the same zipcode and show pairs of houses with different prices.
SELECT 
    h1.id AS house_1,
    h2.id AS house_2,
    h1.zipcode,
    h1.price AS price_1,
    h2.price AS price_2
FROM house_data h1
JOIN house_data h2 
    ON h1.zipcode = h2.zipcode 
    AND h1.id <> h2.id
LIMIT 10;

