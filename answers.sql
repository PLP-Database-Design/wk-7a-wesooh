-- Question 1: Achieving 1NF
-- In 1NF, each row should have atomic values (no multiple values in a single column).
-- We will split the 'Products' column into individual rows for each product.

-- Create a new table to store the transformed data in 1NF
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);

-- Insert data into the new table by splitting the 'Products' column into individual rows
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT OrderID, CustomerName, TRIM(value) AS Product
FROM ProductDetail,
LATERAL STRING_TO_ARRAY(Products, ',') AS value;

-- Question 2: Achieving 2NF
-- In 2NF, we need to remove partial dependencies.
-- The 'CustomerName' column depends on 'OrderID', not the entire composite key (OrderID, Product).
-- We will split the table into two: one for 'Customers' and another for 'Products'.

-- Step 1: Create a new 'Customers' table to store 'OrderID' and 'CustomerName'
CREATE TABLE Customers (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Step 2: Insert data into the 'Customers' table by selecting distinct 'OrderID' and 'CustomerName'
INSERT INTO Customers (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Step 3: Create a new 'Products' table to store 'OrderID', 'Product', and 'Quantity'
CREATE TABLE Products (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product)
);

-- Step 4: Insert data into the 'Products' table, which no longer has partial dependencies
INSERT INTO Products (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
