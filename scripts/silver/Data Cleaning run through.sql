/*


--------------------------------------------------------------------------
Explore ---> CLean/Transform
--------------------------------------------------------------------------
First things first, we need to detect the quality issues in the bronze by 
exploring before writing any transformation scripts 

Exploration of Bronze layer to identify the issues needed to be cleaned up 

For all transfpormations, you explore fro erros and clean column by column 
but these explorations and transformations has been split into groups like 
below just to follow a form of format

CHECKS
    1. Check for Nulls or duplication in Primary Keys
    2. Checking for unwanted spaces in string values 
    3. Standardization and Consistency
*/


--------------------------------------------------------------------
-- Customer Information [crm_cust_info]
--------------------------------------------------------------------
-- 1. Checking for null or duplicate keys 
SELECT
cst_id,
COUNT(*)
from bronze.crm_cust_info
GROUP bY cst_id
HAVING COUNT(*) > 1 or cst_id IS NULL
-- Quite a few duplicated primary keys and null values.
-- Deep dive into those duplicated and null keys 

SELECT
*
FROM bronze.crm_cust_info
WHERE cst_id = 29466;
-- We could see that for that customer id, there were several records with the latest one the most complete
-- Ranking would be done and the most recent record for that customer would be chosen

SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC)as Flag_last
FROM bronze.crm_cust_info
WHERE cst_id = 29466;

-- TRANSFROMATION
-- Created query to only pick non duplicated primary keys and if duplicated, to pick most recent one plus no null primary keys
SELECT
	*
FROM (
	SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC)as Flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
)t
WHERE flag_last = 1

-- 2. Checking for Unwanted Spaces in String Values
SELECT cst_firstname
FROM bronze.crm_cust_info;
-- clear leading spaces were seen in first couple of records
-- Query created to pick out those records as seen below, by selecting those not the same as them after running TRIM 

SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname); --  issues found
-- also for last name and all string values
SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);-- issues found

SELECT cst_key
FROM bronze.crm_cust_info
WHERE cst_key != TRIM(cst_key); -- no issues

SELECT cst_gndr
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr); -- no issues

SELECT cst_marital_status
FROM bronze.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status); -- no issues


-- TRANSFORMATION
-- TRIM the 2 columns as such
SELECT
	cst_id,
    cst_key,
	TRIM(cst_firstname) cst_firstname,
	TRIM(cst_lastname) cst_lastname ,
	cst_marital_status,
	cst_gndr,
	cst_create_date
FROM bronze.crm_cust_info;

-- 3.Data Standardization & Consistency
-- Looking at some of the columns like: marital status and Gender column 
-- Needs to be checked to ensure consistency as this column allows for limited input variales
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info
-- Distinct values 'NULL', 'F' and 'M' are present but we would like to ensure we store meaniful values
-- We rather turn 'F' and 'M' to Female and Male so we store meaniful values and this would be a rule to be consistent by 
-- Replacing 'NULL' with default values as well

-- TRANSFROMATION
SELECT
	CASE 
		WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female' -- Ensuring nothing is left out, lowercase f or f with leading or trailing spaces
		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
		ELSE 'n/a' -- replaces null with n/a
	END cst_gndr -- replaces the original gendr column with this
FROM bronze.crm_cust_info;

-- same thing to be done for marital status which has only 3 possibilities of : 'S', 'NULL','M'
SELECT
	CASE 
		WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
		WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
		ELSE 'n/a' 
	END cst_marital_status
FROM bronze.crm_cust_info;


--VALIDATION
-- Now to Validate the data is clean, run all the checks previously done on the data in bronze to confirm no issues found using silver.

-- 1. Validate no Null or duplicate keys
SELECT
cst_id,
COUNT(*)
from silver.crm_cust_info
GROUP bY cst_id
HAVING COUNT(*) > 1 or cst_id IS NULL; -- No duplicate issues found

-- 2. Validate Removed Unwanted Spaces in String Values
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname); --  no trailing or leading spaces issue found

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);-- no trailing or leading spaces issue found

-- 3.Validate Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info; ---- No issues found, data is stored as meaingful records

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info; ---- No issues found, data is stored as meaingful records

SELECT * FROM silver.crm_cust_info;


--FULL TRANDFORMATIONS
-- Now bringing all the transformation all together to Insert this cleaned customer information data into silver layer tables
INSERT INTO silver.crm_cust_info (
	cst_id,
    cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date)

SELECT
cst_id,
cst_key,
TRIM(cst_firstname) cst_firstname,
TRIM(cst_lastname) cst_lastname ,
CASE 
	WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	ELSE 'n/a' 
END cst_marital_status,
CASE 
	WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	ELSE 'n/a' 
END cst_gndr,
cst_create_date
FROM (
	SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC)as Flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
)t
WHERE flag_last = 1;


--------------------------------------------------------------------
-- Product Information [crm_prd_info]
--------------------------------------------------------------------
-- 1. Checking for null, duplicate or error in Primary keys 
SELECT 
prd_id,
COUNT(*)
FROM bronze.crm_prd_info
group by prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL; ----- No Duplicates or null keys found 

--Now to look at the 2nd key colum (prd_key)
SELECT 
prd_key
FROM bronze.crm_prd_info;
--The key appear like 'CO-RF-FR-R92B-58', seeming like the combination of the id of product category table 'erp_px_cat_g1v2'
-- and sales_prd_key of 'crm_sales_details' table which would be explore

/*
It can be seen that the 
First 5 characters in the prd_key of table 'crm_prd_info'  = category id of table 'erp_px_cat_g1v2'
Example:(CO-RF)-FR-R92B-58 = (CO_RF) differentiated with '-' and '_' matchng table 'erp_px_cat_g1v2'
Example:CO-RF-(FR-R92B-58) being prd_key that can be mapped to sls_prd_key of table 'crm_sales_details'


TRANSFORMATION
Two(2) different columsn would be derived from prd_key
A.Category id part from the prd_key column using SUBSTRING
	and also replace '-' with '_' as state in the example above
	
B.Extracting the remaing part of prd_key to be the product key without the category key 
	attached that can be used to join sls_prd_key of 'crm-sales_details'
	However the second part of the string length is not defined so SUBSTRING and LEN would be used
*/

SELECT 
prd_key,
REPLACE(SUBSTRING(prd_key,1,5),'-','_') cat_id, -- Deriving category id 
SUBSTRING(prd_key,7,LEN(prd_key)) prd_key -- Deriving second string to be product key relatable 'sls_prd_key' of crm_sales_details table
FROM bronze.crm_prd_info;

-- To validate 
SELECT 
REPLACE(SUBSTRING(prd_key,1,5),'-','_') cat_id
FROM bronze.crm_prd_info
WHERE REPLACE(SUBSTRING(prd_key,1,5),'-','_') NOT IN 
	(SELECT distinct id FROM bronze.erp_px_cat_g1v2);
-- Cat_id 'CO_PE' not availavle in id column of table erp_px_cat_g1v2
-- It is probably correct as 

-- 2. Checking for Unwanted Spaces in String Values
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm); -- No trimming needed, no record where name not = to trimmed name(meaning the name = trimmed name so no trailling spaces)

-- 3. Checking for NULLS or Negative Numbers 
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost IS NULL 
	OR prd_cost < 0; --No Negative costs found, some NULLS found however and this affects calculation
-- TRANSFORMATION
-- Use ISNULL function to replace NULL values with '0'

-- 4. Data Standardization & Consistency
SELECT DISTINCT 
prd_line
FROM bronze.crm_prd_info; -- Values of NULL, M, R, S, T found
--TRANSFORMATION
--NULL values to be relplaced and to transfrom single inputs like 'M' to meanigful values like 'Mountain' as stated in naming convention

-- 5. Checking for errors in DATE COLUMS
-- Lookin at the table, we can see that the start date is after the end date, whch is clearly an issue
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;
/*
prd_id	prd_key			prd_nm					prd_cost	prd_line	prd_start_dt		prd_end_dt
212		AC-HE-HL-U509-R	Sport-100 Helmet- Red	12			S 			01/07/2011 00:00	28/12/2007 00:00 --- We can see that end date is younger that start date which is such a problem, has to be fixed.
213		AC-HE-HL-U509-R	Sport-100 Helmet- Red	14			S 			01/07/2012 00:00	27/12/2008 00:00
214		AC-HE-HL-U509-R	Sport-100 Helmet- Red	13			S 			01/07/2013 00:00	NULL
 
Looking for ways to solve this by extracting to excel and checking different solutions,
best solution was to not work with the 'prd_end_dt' but rather create new 'prd_end_dt' from 'prd_start_dt'

new 'prd_end_dt' = date of next start date - 1 ) day before the next start date) 

prd_id	prd_key			prd_nm					prd_cost	prd_line	prd_start_dt		prd_end_dt
212		AC-HE-HL-U509-R	Sport-100 Helmet- Red	12			S 			01/07/2011 00:00	30/06/2012 00:00     --- We can see that end date is younger that start date which is such a problem, has to be fixed.
213		AC-HE-HL-U509-R	Sport-100 Helmet- Red	14			S 			01/07/2012 00:00	30/06/2013 00:00
214		AC-HE-HL-U509-R	Sport-100 Helmet- Red	13			S 			01/07/2013 00:00	NULL

Also to convert date colun form DATETIME TO DATE as the time portion is not really recorded
*/
SElECT
CAST(prd_start_dt AS DATE),
CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt ASC) - 1 AS DATE) prd_end_dt_test -- This gets the start date as a day just befor the begining of a new start date to avoid overlapping -- SCD2
FROM bronze.crm_prd_info;


-- FULL TRANDFORMATIONS
-- Looking at the DDL for silver layer table, we can see new columns were derived and date formats changed and this has to be accounted for, to load/insert data into
-- We have to therefore go back and correct this in DDL
-- Bringing the full transformation all together for load 
INSERT INTO silver.crm_prd_info (
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)
SELECT
prd_id,
REPLACE(SUBSTRING(prd_key,1,5),'-','_') cat_id, -- Extract category id 
SUBSTRING(prd_key,7,LEN(prd_key)) prd_key,-- Extract product key so as to link to sls_prd_key
prd_nm,
ISNULL(prd_cost, 0) prd_cost, -- remove nulls from product cost
CASE 
	UPPER(TRIM(prd_line))
	WHEN 'M' THEN 'Mountain'
	WHEN 'R' THEN 'Rewards'
	WHEN 'S' THEN 'Other Sales'
	WHEN 'T' THEN 'Touring'
	ELSE 'n/a'
END AS prd_line, --Map product linecoes to descriptive meangiful values and also renames NULL values
CAST(prd_start_dt AS DATE) prd_start_dt,
CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt ASC) - 1 AS DATE) prd_end_dt--Calculate end date as one day befor ethe next start date
FROM bronze.crm_prd_info;


--------------------------------------------------------------------
-- Sales Details Information [crm_sales_details]
--------------------------------------------------------------------
SELECT
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details;

-- 1. Checking for null, duplicate or error in Primary keys 
-- we first check the integrity of the columns by checking if these keys are in the customer and product tables as we;;
SELECT
sls_prd_key,
sls_cust_id
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info) -- no issues, all sls_prd_key keys found in transformed layer of product information. i.e prd_key
	OR sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info)-- no issues, all keys found in transformed layer of cusomer information i.e cst_id

-- 2. Checking for Unwanted Spaces in String Values
SELECT
*
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num); -- no issues

-- 3. Checking for NULLS or Negative Numbers 
-- Here mostly looking at sales quantity columns
-- Business ules to follow
		-- Sales = Price * Quantity
		-- Sales cannot be Zeros, nulls oe negative
SELECT
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
	WHERE sls_sales != sls_quantity * sls_price 
		--OR sls_sales <= 0 
		--OR sls_sales IS NULL


-- 4. Data Standardization & Consistency
-- Date columns to be looked at -('sls_order_dt', 'sls_ship_dt', sls_due_dt')
-- The dates appear as integers, have to convert to dates
-- First things first is to check for invalid dates
SELECT
	NULLIF(sls_order_dt, 0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 -- issues found | some dates recorded as 0
	OR LEN(sls_order_dt) != 8 --issues found | Length of each number should be 8 (4 for year, 2 for month, 2 for day), not more or less
	OR sls_order_dt >  20500101 -- no issues found | date not exceeding boundary of company data
	OR sls_order_dt <  19000101; -- no issues found | date not exceeding boundary of company data

--Check to see right validity with the dates
SELECT
*
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt; -- no issues found 

--TRANSFORMATION
SELECT
CASE 
	WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
END sls_order_dt,
CASE 
	WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
END sls_ship_dt,
CASE 
	WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
END sls_due_dt
FROM bronze.crm_sales_details;

