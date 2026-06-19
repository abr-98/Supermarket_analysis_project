## Setup and Commands

### Snowflake Setup

1. CREATE WAREHOUSE OLIST_WH
WITH
WAREHOUSE_SIZE = 'XSMALL'
AUTO_SUSPEND = 60
AUTO_RESUME = TRUE;

2. USE WAREHOUSE OLIST_WH;

3. CREATE DATABASE OLIST;

4. USE DATABASE OLIST;

5. CREATE SCHEMA BRONZE;
CREATE SCHEMA SILVER;
CREATE SCHEMA GOLD;

6. Set up connections

### DBT Setup

pip install dbt-snowflake

dbt init olist_project
-> snowflake

Check and update: nano ~/.dbt/profiles.yml

#### Run

dbt run

#### UI:

dbt docs generate
dbt docs serve

#### Test

dbt test

