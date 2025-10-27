USE DATABASE dbt_db;
USE SCHEMA dbt_schema;

CREATE TABLE superstore (
    Row_ID INT NOT NULL,
    Order_ID VARCHAR(20) NOT NULL,
    Order_Date DATE NOT NULL,
    Ship_Date DATE NOT NULL,
    Ship_Mode VARCHAR(50),
    Customer_ID VARCHAR(20) NOT NULL,
    Customer_Name VARCHAR(100),
    Segment VARCHAR(50),
    Country VARCHAR(50),
    City VARCHAR(100),
    State VARCHAR(100),
    Postal_Code VARCHAR(20),
    Region VARCHAR(50),
    Product_ID VARCHAR(50) NOT NULL,
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Product_Name VARCHAR(255),
    Sales DECIMAL(18,2),
    Quantity INT,
    Discount DECIMAL(5,2),
    Profit DECIMAL(18,2),
    PRIMARY KEY (Row_ID)
);