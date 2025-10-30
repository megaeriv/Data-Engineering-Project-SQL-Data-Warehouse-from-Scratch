/*
==============================================================
CREATE DATABASE and SCHEMAS
==============================================================
Script Purpose:
	Ths script creates a new database named 'Datawarehouse' after checking if it already exists,
	If the database exists, it is dropped and rercreated. 
	The scripts also creates 3 schemas within the databse : 'bronze', 'silver', 'gold'

WARNING:
	Running this script will drop the entire 'Datawarehouse' database if exists.
	All data in the database will be permannetly deleted. Proceed with caution
	Only run this script after you ensure you have proper backups of the data

*/

-- Create Database 'DataWrehouse'

USE MASTER;
GO

--Drop and Recreate the 'DataWarehouse' Database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE Datawarehouse SET SINGLE_USER WITH ROLLBACK IMEDIATE;
	DROP DATABASE DataWarehouse
END;
GO

-- Create the 'DataWarehouse' Database
CREATE DATABASE DataWarehouse;

USE DataWarehouse;
GO

-- Create Schema
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

-- Develop each layer (medallion schema) Idependently next
