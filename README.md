# 🧱 Data Engineering Project: SQL Data Warehouse from Scratch

This project entails building a data warehouse from scratch and delivering analytical insights from the data.  
I will deliver this project following **industry best practices** in **data engineering and analytics**, using **Notion** for planning, **draw.io** for architecture design, and **SSMS** for implementation.

---

## 🚀 Project Overview

This project involves:

1. **Data Architecture:** Designing a modern data warehouse using an appropriate architecture approach.  
2. **ETL Pipelines:** Extracting, transforming, and loading data from source systems into the warehouse.  
3. **Data Modeling:** Developing fact and dimension tables optimized for analytical queries.  
4. **Analytics & Reporting:** Creating SQL-based reports and dashboards for actionable insights.

### 🎯 Objective
Develop a modern **SQL Server Data Warehouse** to consolidate sales data, enabling analytical reporting and informed decision-making.

### 🧾 Specifications
- **Data Sources:** Import data from two systems (ERP and CRM) provided as CSV files.  
- **Data Quality:** Cleanse and resolve data quality issues prior to analysis.  
- **Integration:** Combine both sources into a single, user-friendly model designed for analytical queries.  
- **Scope:** Focus on the latest dataset only; historization is not required.  
- **Documentation:** Provide clear documentation of the data model for both business and analytics teams.

---

## 🏗️ Architecture

The first step is to understand the type of data storage being built — in this case, a **data warehouse**.  
Next, determine the **approach**: the **Medallion Architecture** was chosen.

This involves building three layers:
- 🥉 **Bronze** (staging layer)
- 🥈 **Silver** (transformation layer)
- 🥇 **Gold** (serving layer for business logic and analytics)

<img width="1754" height="656" alt="image" src="https://github.com/user-attachments/assets/f9f2a983-bc0d-43aa-96cb-0eaef28e0f80" />

---

### 🪶 Layering Overview

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

**Separation of Concerns:**  
Each layer performs a distinct role — no overlap between ingestion, cleaning, and business logic.  
This ensures a clean, organized, and maintainable data pipeline.

---

## 🧩 Design

<img width="1032" height="642" alt="Design Diagram" src="https://github.com/user-attachments/assets/364e2e59-b5c4-4107-be55-ced70c03d941" />

---

## 🗂️ Project Plan

All tasks and epics are managed in **Notion**, ensuring proper documentation and structure.

<img width="951" height="922" alt="Project Plan" src="https://github.com/user-attachments/assets/800a3752-d0d8-4b7f-8842-9bd962b2edac" />

### Project Plan Includes:
1. **Naming Conventions** — Documented as a standalone file in this repository.  
2. **Database & Schema Creation** — Implemented in SSMS and stored as `init_database.sql`.

---

## 🥉 Building Layers: Bronze → Silver 🥈

The first step is understanding the **source systems** by analyzing and validating their structure before ingestion.

### 🔍 Analyzing

Key questions to guide understanding:

#### Business Context & Ownership
- Who owns the data?  
- What business processes does it support (e.g., logistics, finance)?  
- What systems and documentation exist?  
- What does the current data model look like?

#### Architecture & Technology Stack
- Where is data stored? (SQL Server, Oracle, AWS, Azure...)  
- What are the integration capabilities? (API, Kafka, file extracts, direct DB)  

#### Extract & Load
- Incremental vs. full load  
- Data scope and historical needs  
- Expected data size and limitations  
- Minimizing performance impact on source systems  
- Authentication and authorization (tokens, SSH, VPN, IP whitelisting)

---

### 💻 Coding

Includes ingestion, transformation, validation, and completeness checks.

> To develop effective data-cleaning transformations and stored procedures for the Bronze and Silver layers, it’s essential to first understand data flow and inter-table relationships.

#### Data Flow
<img width="917" height="527" alt="Data Flow" src="https://github.com/user-attachments/assets/8398abfb-bbd4-416f-98c9-2d7c5f9f56df" />

#### Silver Integration Model
<img width="1055" height="652" alt="Silver Integration Model" src="https://github.com/user-attachments/assets/15471251-0fb9-437d-b8c2-1bc15702c8bf" />

**Script Organization**
1. `ddl_*.sql` → Defines database structures (DDL).  
2. `data_cleaning_*.sql` → Step-by-step cleaning transformations.  
3. `proc_*.sql` → Stored procedures for ETL loading.  
4. `quality_checks_*.sql` → Validation and quality assurance tests.

---

## 🥇 Gold Layer

The **Gold Layer** focuses on data integration, modeling, and presentation.

### Key Activities
- **Build Business Objects:** Identify and classify tables (Dimensions vs. Facts).  
- **Rename Columns:** Make names intuitive for business users.  
- **Design Data Models:** Organize and structure data clearly with defined relationships.

### 🧠 Data Modeling Stages
1. **Conceptual Model:** Defines entities and relationships (no attributes yet).  
2. **Logical Model:** Specifies columns, keys, and relationships.  
3. **Physical Model:** Adds data types, constraints, and database-specific design.  

> For this project, focus was placed on the **Logical Data Model**.

#### Exploring Business Objects
<img width="1257" height="750" alt="Business Object Model" src="https://github.com/user-attachments/assets/d7e58441-b6f8-4a41-8791-ca497a893028" />

---

### ⭐ Data Model Type: Star Schema

Relationships:
- **One-to-Many** between *Dimensions* (Customer, Product) and *Fact Sales*.  
- Each customer or product can have multiple sales.

Cases handled:
- Customers/Products with **no orders**  
- Customers/Products with **one order**  
- Customers/Products with **multiple orders**

#### Star Schema Diagram
<img width="905" height="702" alt="Star Schema" src="https://github.com/user-attachments/assets/afe36ed5-b310-4bf4-9c54-beb3fe309bf0" />

---

### 📚 Data Dictionary

Stored as `data_catalog.md`.  
Provides clear definitions of all data fields for business and analytics users to understand the data product.
