/*
--------------------------------------------------------------------------
Explore ---> CLean/Transform
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

----------------------------------------------------
-- Customer Object 
----------------------------------------------------
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
	ci.cst_gndr,
	ca.gen,
	CASE 
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master for gender info when available
		ELSE COALESCE(ca.gen, 'n/a')				-- Use ca.gen from ERP table when gender form CRM not available, and if that is also nulll print 'n/a'
	END new_gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
	ON ci.cst_key = la.cid
ORDER BY 1,2		
