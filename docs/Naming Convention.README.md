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
