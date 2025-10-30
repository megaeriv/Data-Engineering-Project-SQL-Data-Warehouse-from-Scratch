# Defining Naming Conventions
Naming conventions are the set of guidelines for naming anything in the project
  - Database
  - Schema
  - Tables
  - Store Procedures
This helps to avoid inconcsistencies

## **Table of Contents**

1. [General Principles](#general-principles)
2. [Table Naming Conventions](#tabl-Naming-Coventions)
   - [Bronze Rules](#bronze-rules)
   - [Silver Rules](#silver-rules)
   - [Gold Rules](#gold-rules)
3. [Column Naming Conventions](#column-naming-conventions)
   - [Surrogate Keys](#surrogate-keys)
   - [Technical Columns](#technical-columns)
4. [Stored Procedure](#stored-procedure-naming-conventions)
---

## General Principles
  - **Naming Conventions**: Use snake case with all letters being lowercase and underscores(_) to sepretae words
  - **Language**: Use Engliesh for all names
  - **Avoid Reserved Words**: Do not use SQL reserved words as object names 

## Table Naming Coventions

### **Bronze Rules**
All names must start with the source system name and tablename mst match their origibal names without renaming
- `<sourcesystem>_<entity>`
  - `<sourcesystem>`: Name of the source system (e.g `crm` or `erp`)
  -  `<entity>`: Exact table name from the source system
  -  Example : `crm_customer_info`- Customer Information from CRM system

### **Silver Rules**
All names must start with the source system name and tablename mst match their origibal names without renaming
- `<sourcesystem>_<entity>`
  - `<sourcesystem>`: Name of the source system (e.g `crm` or `erp`)
  - `<entity>`: Exact table name from the source system
  - Example : `crm_customer_info`- Customer Information from CRM system
        
### **Gold Rules**
All names must use meaningful business alligned names for tables, starting with the category prefix
- `<category>_<entity>`
  - `<category>`: Describes the role of the table such as `dim` (dimension) or `fact` (fact table)
  - `<entity>`: describes the name of the table aligned with the business domain
  - Example:
    - `dim_customer` - Dimension table for customer data
    - `fact_sales` = Fact Table constaining sales transactions
   
#### Glossary of Category Patterns
| Pattern | Meaning| Example(s)|
|-------------|--------------|--------------|
|`dim_`|Dimension table|`dim_custoner`, `dim_product`|
|`fact_`|Fact table|`fact_sales`|
|`agg_`|Aggregated table|`agg_customers`, `agg_sales_monthly`|

## **Column Naming Conventions**

### **Surrogate Keys**  
- All primary keys in dimension tables must use the suffix `_key`.
- **`<table_name>_key`**  
  - `<table_name>`: Refers to the name of the table or entity the key belongs to.  
  - `_key`: A suffix indicating that this column is a surrogate key.  
  - Example: `customer_key` → Surrogate key in the `dim_customers` table.
  
### **Technical Columns**
- All technical columns must start with the prefix `dwh_`, followed by a descriptive name indicating the column's purpose.
- **`dwh_<column_name>`**  
  - `dwh`: Prefix exclusively for system-generated metadata.  
  - `<column_name>`: Descriptive name indicating the column's purpose.  
  - Example: `dwh_load_date` → System-generated column used to store the date when the record was loaded.
 
## **Stored Procedure Naming Conventions**

- All stored procedures used for loading data must follow the naming pattern:
- **`load_<layer>`**.
  
  - `<layer>`: Represents the layer being loaded, such as `bronze`, `silver`, or `gold`.
  - Example: 
    - `load_bronze` → Stored procedure for loading data into the Bronze layer.
    - `load_silver` → Stored procedure for loading data into the Silver layer.
