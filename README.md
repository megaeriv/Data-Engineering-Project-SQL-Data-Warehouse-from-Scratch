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

Project plan includes:

1.  Define Naming Convention
  This would placed as a stand alone document in this repository

2. Create Database & Schema using SSMS
  Database and schemas are created and named 'init_database.sql'

## Building Layers 🥉 Bronze -----> Silver 🥈
First things first is to understand the source systems by analyzing before any coding so as to undertsand how to ingest the data, then validate while also dosumenting.

#### Analyzing
This analysis can include sitting with source systems to analyze the business context and ownership of the data by asking the following questions
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


#### Coding 
- Ingestions, Transfromations, Validations and Loads (Data Completness & schema checks)
- To develop effective data cleaning transformations and stored procedures for the bronze and silver layers, it’s essential to first understand the data flow and the relationships between datasets.


##### Data Flow
<img width="917" height="527" alt="Data Flow" src="https://github.com/user-attachments/assets/8398abfb-bbd4-416f-98c9-2d7c5f9f56df" />


##### Silver Integration Layer
<img width="1055" height="652" alt="Silver Integration Model" src="https://github.com/user-attachments/assets/15471251-0fb9-437d-b8c2-1bc15702c8bf" />


Scripts used are stored as below in scripts folders for the Bronze and Silver Layer
  1. 'ddl_______.sql' in layer folder for Data Definition Language: it’s the part of SQL used to define, create, modify database structures.
  2. 'Data Cleaning run through.sql' in layer folder showing step by step data cleaning involved in building each layer 
  3. 'proc_______.sql' in layer folder for Proc = short for “Stored Procedure.” The stored procedure for loading data into the bronze or silver layer. A stored procedure is a saved SQL script that can be executed by name, like a function in programming.
  4. 'quality_checks______.sql' store in 'Tests' folder for running quality checks on data stored in particular layer


### Gold Layer
For the Gold layer, the work mainly done is Data Integration, this involve the following:
- #### Buiding Buisness objects and determing type (Dimension or Fact)

- #### Rename Columns to help business stakeholders understand and use effectively

- #### Build Data Model
  - **Taking Raw Data, Organizing and structuring in eaay to understand format while describing relationship**
  -  **3 stages of Data Model**
      - A. Conceptual Data Model: Here the focus is on the enetities and relationships between them, no details like attributes or               columns.
      - B. Logical Data Model: Here different columns are specified alongside primary keys and relationships between tables
      - C. Physical Data Model: All techinical details are specified like data taypes, database tecqniques etc. This prepares for               implementation in database
      - Focus for this project was to develop Logical Data Model
   
        ##### Exploring Business Object
        <img width="1257" height="750" alt="image" src="https://github.com/user-attachments/assets/d7e58441-b6f8-4a41-8791-ca497a893028" />


  - **Data model Types**
      - Star Schema (Preference)
      - Defining Relationship bewteen entities
        - *(One mandatory to Many optional)* relationship between Dimension Customers and Dimension Product to Fact Sales as 1                 customer/product can record numerous amount of sales. Following this rules
          - A. Customers/Product with no placed orders/sales
          - B. Customers/Product with one (1) placed order/sale
          - C. Customers/Product with multiple placed orders/sales
 
        ##### Star Schema
        <img width="905" height="702" alt="image" src="https://github.com/user-attachments/assets/afe36ed5-b310-4bf4-9c54-beb3fe309bf0" />

- Build Data dictionary
  Stored as 'data_catalog.md'. A data dictionary to help busines users understand data product for variosu projects has been  created.



