# Data Engineering Project: SQL Data Warehouse from Scratch
This project is going to entail building a data warehouse from scatch unto reporting insights from the analysis of the data.
I would deleiver this project with the best of industry practice in mengineering and analytics,  using Notion for planning, draw,io for dessign of architecture and SSMS.


## Project Overview
This project involves:

1. Data Architecture: Designing a Modern Data Warehouse Using a chosen Architecture approach.
2. ETL Pipelines: Extracting, transforming, and loading data from source systems into the warehouse.
3. Data Modeling: Developing fact and dimension tables optimized for analytical queries.
4. Analytics & Reporting: Creating SQL-based reports and dashboards for actionable insights.

**Objective**

Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

**Specifications**

- Data Sources: Import data from two source systems (ERP and CRM) provided as CSV files.
- Data Quality: Cleanse and resolve data quality issues prior to analysis.
- Integration: Combine both sources into a single, user-friendly data model designed for analytical queries.
- Scope: Focus on the latest dataset only; historization of data is not required.
- Documentation: Provide clear documentation of the data model to support both business stakeholders and analytics teams.


### Understanding Data and Output


## Architecture
Firts thing to do is to understand the type of data storage being buitt which has already dbeen identified as a data warehouse.
Next thing is to understad determine what apprach would be used to buil this 
The medallion approach has been identified 
The medallion approach involves building Bronze(staging layer), Silver(Transformed layer), Gold(Serving layyer with Business logic) then Report


<img width="1754" height="656" alt="image" src="https://github.com/user-attachments/assets/f9f2a983-bc0d-43aa-96cb-0eaef28e0f80" />


### Layering

|  | 🥉 `Bronze Layer` | 🥈 `Silver Layer` | 🥇 `Gold Layer` |
|-------------|--------------|--------------|--------------|
| **Definition** | Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database. | This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis |Houses business-ready data modeled into a star schema required for reporting and analytics.|
| **Objective** | This layer is for tracebility and debugging| This is the layer where we do preparations to prepare data for analysis | Provide data to be consumed for reporting and Analytics|
| **Object Type** | Tables | Tables | Views |
| **Load Method** | Full Load<br>[Truncate & Insert] | Full Load<br>[Truncate & Insert] | None |
| **Data Transformation** | None(as-is) | - Data cleansing<br>- Data Standardisation<br>- Data Normalization<br>- Derived Column<br>- Data Enrichment |  - Data Integration<br>- Data Aggregation<br>- Businesss Logic & Rules |
| **Data Modelling** | None(as-is) | None(as-is) | - Star Schema<br>- Aggregated Objects<br>- Flat Tables |
| **Target Audience** | - Data Engineers | - Data Engineers<br>- Data Analysts | - Data Analysts<br>- Business Users |
| **Separation of Concerns** | **INGEST** | **CLEAN** | **BUSINESS** |

Separatin of concern - Making sure no layer does the job of another layer, this keeps the job very clean and organised.m Where no 2 layers do the same job.


### Design
<img width="1032" height="642" alt="image" src="https://github.com/user-attachments/assets/364e2e59-b5c4-4107-be55-ced70c03d941" />


## Project Plan 
- Define Naming Convention
  This would pkaced as a stand alone documenty in this rpository

# Defining Naming Conventions
Naming conventions are the set of guidelines for naming anything in the project
  - Database
  - Schema
  - Tables
  - Store Procedures
This helps to avoid inconcsistencies

## General Principles
  - **Naming Conventions**: Use snake case with all letters being lowercase and underscores(_) to sepretae words
  - **Language**: Use Engliesh for all names
  - **Avoid Reserved Words**: Do not use SQL reserved words as object names 

## Table Naming Coventions

### **Bronze Rules**
All names must start with the source system name and tablename mst match their origibal names without renaming
     - `<sourcesystem>_<entity>`
         + `<sourcesystem>`: Name of the source system (e.g `crm` or `erp`)
         + `<entity>`: Exact table name from the source system
         + Example : `crm_customer_info`- Customer Information from CRM system

### **Silver Rules**
All names must start with the source system name and tablename mst match their origibal names without renaming
     - '<sourcesystem>_<entity>'
         + `<sourcesystem>`: Name of the source system (e.g `crm` or `erp`)
         + `<entity>`: Exact table name from the source system
         + Example : `crm_customer_info`- Customer Information from CRM system
        
### **Gold Rules**
All names must use meaningful business alligned names for tables, starting with the category prefix
     - `<category>_<entity>`
         + `<category>`: Describes the role of the table such as `dim` (dimension) or `fact` (fact table)
         + `<entity>`: describes the name of the table aligned with the business domain
         + Example:
             * `dim_customer` - Dimension table for customer data
             * `fact_sales` = Fact Table constaining sales transactions
               

