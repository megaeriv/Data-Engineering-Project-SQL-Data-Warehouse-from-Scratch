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


## Understanding Data and Output


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
Using Notion, every Epic and task is documented and in order

<img width="951" height="922" alt="image" src="https://github.com/user-attachments/assets/800a3752-d0d8-4b7f-8842-9bd962b2edac" />


### Define Naming Convention
  This would placed as a stand alone document in this repository

### Create Database & Schema using SSMS
  Database and schemas are created and named 'init_database.sql'

### Building  Bronze Layer
First things first is to understand the source systems by analyzing before any coding so as to undertsand how to ingest the data, then validate while also dosumenting.

#### Analyzing
This analysis can include sitting with source ssytem and analyzing the business context and ownership of the data by asking such questions 
- Business Context & Ownership
  - Who owns the data
  - What business Proecess does it support e,g logistics of finance reporting
  - Systems & Data documentation
  - Data Model & Data Catalog

- Architecture & Technolgy Stack
  - How is data stored (SQL server, Oracle, AWS, Azure...)
  - What are the integration capabilities? (API, Kafka, File extract, Direct DB)
 
- Extract & Load
  - Incremenata v Full load
  - Data Scope & Historic needs
  - What is the expected size of the extracts
  - Are there any data volume limitations
  - How to avoid impacting the source system's perfomance
  - Autheneticationa and authorization (tokens, SSH keys, VPN, IP whitelisting)
  
#### Coding (Ingestion) & Validating (Data Completness & schema checks)
stored as 
  1. 'ddl_bronze.sql' in docs for Data Definition Language: it’s the part of SQL used to define, create, modify, or remove database structures.
  2. 'proc_load_bronze.sql' in docs for Proc = short for “Stored Procedure.” A stored procedure is a saved SQL script that can be executed by name, like a function in programming.

Going by what whas decided in our desing of architecture
  - fULL LOAD (Truncate and Insert)
  - No transformation
  - No data model 
   
#### Documentation (Data flow)

  
#### Commit

  
### Building  Silver Layer
First things first is to 

#### Analyzing

  
#### Coding (Data Cleaning)

  
#### Validating (Data Correctness)

  
#### Documentation

  
#### Commit



### Building  Gold Layer
First things first is to 

#### Analyzing

  
#### Coding (Data Integration)

  
#### Validating (Data Integration Checks)

  
#### Documentation (Data Modelling of star schema)

  
#### Documentation (Data Catalog)



