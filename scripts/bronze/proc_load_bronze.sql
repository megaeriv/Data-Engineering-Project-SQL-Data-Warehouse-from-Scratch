/*

===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================

Bulk insert is used to load the data from csv file into our dataset
This is not insert of row by row but an all out onece insert into the database 
However we dont just want to bull insert cause it means running this query over and over would cause duplicate
Therefore we would make sure the table is empty before inserting (Truncate & Load)
This is how to do a FULL LOAD

This is the script used to load data which would be used often, therefore we need to creat a stored procedure for this load
Store procedure naming convention must be followed
	- load_<layer>
	- so load_bronze

With writing this ETL script, we also want to take care of our messaging when ran 

We would also tract ETL duration
*/

USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY -- to check for erros
		SET @batch_start_time = GETDATE();
		PRINT '======================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '======================================================';



		PRINT '------------------------------------------------------';
		PRINT ' Loading CRM Tables';
		PRINT '------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info'
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>> Inserting Data Into: bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\megae\Documents\Self learning\Data Engineering Project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv' -- where file is located on local drive 
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK -- to lock table when 
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds' -- Calculating speed of ETL
		PRINT '>>----------------------------------------------------------------------';



		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Inserting Data Into: bronze.crm_prd_info'
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\megae\Documents\Self learning\Data Engineering Project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv' -- where file is located on local drive 
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>----------------------------------------------------------------------';



		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Inserting Data Into: bronze.crm_sales_details'
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\megae\Documents\Self learning\Data Engineering Project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv' -- where file is located on local drive 
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>----------------------------------------------------------------------';



		PRINT '------------------------------------------------------';
		PRINT ' Loading ERP Tables';
		PRINT '------------------------------------------------------';
	


	SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12'
		TRUNCATE TABLE bronze.erp_cust_az12;
	
		PRINT '>> Inserting Data Into: bronze.erp_cust_az12'
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\megae\Documents\Self learning\Data Engineering Project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv' -- where file is located on local drive 
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>----------------------------------------------------------------------';



		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101'
		TRUNCATE TABLE bronze.erp_loc_a101;
	
		PRINT '>> Inserting Data Into: bronze.erp_loc_a101'
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\megae\Documents\Self learning\Data Engineering Project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv' -- where file is located on local drive 
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>----------------------------------------------------------------------';



		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2'
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
	
		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2'
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\megae\Documents\Self learning\Data Engineering Project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv' -- where file is located on local drive 
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>----------------------------------------------------------------------';

		SET @batch_end_time = GETDATE();
		PRINT '======================================================';
		PRINT 'Loading Bronze Layer is Complete';
		PRINT '		Total Load duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '======================================================';

	END TRY -- TRY...CATCH| SQL runs the rty block and if it fails, it runs the CATCH block to handle the error
	BEGIN CATCH -- If there is an error CATCH is run and now I tell SQL to do when running CATCH if there is an error
		PRINT '======================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER () AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE () AS NVARCHAR);
		PRINT '======================================================';
	END CATCH
	
END;

-- to execute (EXEC bronze.load_bronze;)
