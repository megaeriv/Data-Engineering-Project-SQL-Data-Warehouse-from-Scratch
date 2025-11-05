/*
--------------------------------------------------------------------------
Data Integration run through for Gold layer 
--------------------------------------------------------------------------

							-->STAR SCHEMA<--

FACT (Quantitative)
- Events like transactions
- 3 important informations
	- Multiple IDs from multiole dimensions
	- Date information of when transactaion/event occured
	- Measures and numbers

DIMENESIONS (Qualitative )
- Descriptive information that gives context to data

In Gold layer
- Perspective worked with is Buisness context
- Here data from silver layer is broken down to meet business context
- Have clear Understanding of bUiness and its processes

Objectives
		 - Detect Business Objects
		 - Build data model
		 - Create views from Data transformations
*/

-----------------------------------------------------
-- CUSTOMER Object							DIMENSION
-----------------------------------------------------
SELECT
	ci.cst_id,
	ci.cst_key,
	ci.cst_firstname,
	ci.cst_lastname,
	ci.cst_marital_status,
	ci.cst_gndr,
	ci.cst_create_date,
	ca.bdate,
	ca.gen,
	la.cntry
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
	ON ci.cst_key = la.cid

-- Check if any duplicates were introduced by join logic using count or primary id having count(*) > 1
-- Integration of 2 gender columns, need to fix by firsy exploring
SELECT DISTINCT
	ci.cst_gndr,
	ca.gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
	ON ci.cst_key = la.cid
ORDER BY 1,2

-- Results show multiple instances where values in the column do not align
	-- Examples include 
		-- one table having a value and the other not
		-- A table having a customer and the other table not so a NULL appears (this is the case because of all certainity all NULLs hav ebeen handled on table seperately)
	-- First step in solving is undertsnading the master source of Customer Data: CRM or ERP
		-- it is CRM in this case
		-- So the value from the CRM customer table is the correct one in conflicting values situation
SELECT DISTINCT
	ci.cst_gndr ,
	ca.gen ,
	CASE 
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master for gender info when available
		ELSE COALESCE(ca.gen, 'n/a')				-- Use ca.gen from ERP table when gender form CRM not available, and if that is also nulll print 'n/a'
	END new_gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
	ON ci.cst_key = la.cid
ORDER BY 1,2;


-- Final Customer Data Object Transfromation
	-- Create View 
	-- Use Naming Convention to Rename columns for Business Context
	-- Order the columns business context manner
	-- Label table as Dimension (Descriptive, Qualitative)
	-- For Dimensions,generate Surrogate Keys (System generated unique identifier assigned to each record in a table)
		-- Use Window function to generate surrogate key
CREATE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name ,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE 
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master for gender info when available
		ELSE COALESCE(ca.gen, 'n/a')				-- Use ca.gen from ERP table when gender form CRM not available, and if that is also nulll print 'n/a'
	END AS gender,
	ca.bdate AS birth_date,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
	ON ci.cst_key = la.cid;


-----------------------------------------------------
-- PRODUCT Object							DIMENSION
-----------------------------------------------------
-- Create View 
	-- Use Naming Convention to Rename columns for Business Context
	-- Order the columns business context manner
	-- Label table as Dimension (Descriptive, Qualitative)
	-- For Dimensions,generate Surrogate Keys
		-- Use Window function to generate surrogate key
CREATE VIEW gold.dim_product AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY pr.prd_start_dt,pr.prd_key) AS product_key,
	pr.prd_id AS product_id,
	pr.prd_key AS product_number, -- renamed to product number to follow patter of naming convention as done for 'Customer Dimension'
	pr.prd_nm AS product_name,
	pr.cat_id AS category_id,
	px.cat AS category,
	px.subcat AS subcategory,
	px.maintenance AS maintenance,
	pr.prd_cost AS product_cost,
	pr.prd_line AS product_line,
	pr.prd_start_dt AS product_start_date
FROM silver.crm_prd_info pr
LEFT JOIN silver.erp_px_cat_g1v2 px
	ON pr.cat_id = px.id
WHERE pr.prd_end_dt IS NULL			-- Filter out historic data | as was calulated in transformation of silver layer


-----------------------------------------------------
-- SALES Object									FACT
-----------------------------------------------------
-- Create View 
	-- Use Naming Convention to Rename columns for Business Context
	-- Order the columns business context manner
	-- Label table as Fact (Multiple IDs, Measures and Numbers, Quantitative)
	-- Get surrogate key form dimensions in gold layer using JOINS
CREATE VIEW gold.fact_sales AS
SELECT 
sd.sls_ord_num AS order_number,
pr.product_key, -- Product Surrogate Key
cu.customer_key, -- Customer Dimension Surrogate Key
sd.sls_order_dt AS order_date,
sd.sls_ship_dt AS shipping_date,
sd.sls_due_dt AS due_date,
sd.sls_sales AS sales_amount,
sd.sls_quantity AS quantity,
sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_customers cu
	ON sd.sls_cust_id = cu.customer_number -- 'cst_key' renamed to customer number for gold layer dimension
LEFT JOIN gold.dim_product pr
	ON sd.sls_prd_key = pr.product_number; -- 'prd_key' renamed to product number for gold layer dimension
