-- STEP 2A: Create Database
CREATE DATABASE Ecommerce_SQL_Order_Customer_Analysis;
GO

USE Ecommerce_SQL_Order_Customer_Analysis;
GO
-- STEP 2B: Create Customers Table
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    City VARCHAR(50) NOT NULL,
    RegistrationDate DATE NOT NULL DEFAULT GETDATE()
);
GO
-- STEP 2C: Create Products Table
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    CreatedDate DATE NOT NULL DEFAULT GETDATE()
);
GO
-- STEP 2D: Create Orders Table
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL DEFAULT GETDATE(),
    OrderStatus VARCHAR(20) NOT NULL 
        CHECK (OrderStatus IN ('Placed', 'Shipped', 'Delivered', 'Cancelled')),
    
    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO
-- STEP 2E: Create Order_Items Table
CREATE TABLE Order_Items (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice > 0),

    CONSTRAINT FK_OrderItems_Orders
        FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),

    CONSTRAINT FK_OrderItems_Products
        FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

select name from sys.tables ;
use Ecommerce_SQL_Order_Customer_Analysis ; go 
-- inserting data into customers table 
INSERT INTO Customers (CustomerName, Email, City, RegistrationDate) VALUES
('Amit Sharma', 'amit.sharma@gmail.com', 'Delhi', '2023-01-15'),
('Priya Verma', 'priya.verma@gmail.com', 'Mumbai', '2023-03-20'),
('Rahul Singh', 'rahul.singh@gmail.com', 'Bangalore', '2023-06-10'),
('Sneha Das', 'sneha.das@gmail.com', 'Kolkata', '2023-08-05'),
('Ankit Gupta', 'ankit.gupta@gmail.com', 'Delhi', '2024-01-12'),
('Neha Roy', 'neha.roy@gmail.com', 'Pune', '2024-02-18'),
('Vikram Patel', 'vikram.patel@gmail.com', 'Ahmedabad', '2024-03-22'),
('Pooja Mehta', 'pooja.mehta@gmail.com', 'Mumbai', '2024-04-01'),
('Rohit Nair', 'rohit.nair@gmail.com', 'Chennai', '2024-05-15'),
('Kavita Joshi', 'kavita.joshi@gmail.com', 'Jaipur', '2024-06-05');
GO
-- inserting data into producr table 
INSERT INTO Products (ProductName, Category, Price, CreatedDate) VALUES
('Laptop', 'Electronics', 65000, '2023-01-10'),
('Smartphone', 'Electronics', 30000, '2023-02-15'),
('Headphones', 'Accessories', 2500, '2023-03-12'),
('Office Chair', 'Furniture', 12000, '2023-04-05'),
('Coffee Maker', 'Home Appliances', 5500, '2023-05-20'),
('Running Shoes', 'Fashion', 4500, '2023-06-18'),
('Backpack', 'Accessories', 1800, '2023-07-25'),
('Smart Watch', 'Electronics', 15000, '2024-01-08'),
('Table Lamp', 'Home Decor', 2200, '2024-02-14'),
('Wireless Mouse', 'Accessories', 1200, '2024-03-10');
GO
-- inserting data into orders table 
INSERT INTO Orders (CustomerID, OrderDate, OrderStatus) VALUES
(1, '2024-01-05', 'Delivered'),
(2, '2024-01-15', 'Delivered'),
(3, '2024-02-10', 'Shipped'),
(4, '2024-02-20', 'Delivered'),
(5, '2024-03-05', 'Placed'),
(6, '2024-03-18', 'Delivered'),
(7, '2024-04-02', 'Cancelled'),
(8, '2024-04-12', 'Delivered'),
(9, '2024-05-08', 'Shipped'),
(10,'2024-06-01', 'Placed');
GO
-- inserting data into order_items table 
INSERT INTO Order_Items (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 1, 65000),
(1, 3, 2, 2500),
(2, 2, 1, 30000),
(2, 10, 1, 1200),
(3, 4, 1, 12000),
(4, 5, 1, 5500),
(5, 6, 2, 4500),
(6, 8, 1, 15000),
(7, 7, 1, 1800),
(8, 9, 2, 2200),
(9, 3, 1, 2500),
(10, 10, 3, 1200);
GO
-- checking the tables data 
SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM Order_Items; 
-- Starting to solve Group A Queries 
/* =========================================================
   GROUP A — BASIC SQL (ANALYTICAL QUERIES)
   ========================================================= */
-- Q1. Display all customers with their city and registration date
SELECT CustomerName, City, RegistrationDate
FROM Customers;
GO
-- Q2. Show the total number of customers
SELECT COUNT(*) AS TotalCustomers
FROM Customers;
GO
-- Q3. List all products with their price and category
SELECT ProductName, Category, Price
FROM Products;
GO
-- Q4. Find the total number of orders placed
SELECT COUNT(*) AS TotalOrders
FROM Orders;
GO
-- Q5. Display all orders placed in the year 2024
SELECT *
FROM Orders
WHERE YEAR(OrderDate) = 2024;
GO
-- Q6. Show total quantity ordered for each product
SELECT 
    p.ProductName,
    SUM(oi.Quantity) AS TotalQuantityOrdered
FROM Order_Items oi
JOIN Products p ON oi.ProductID = p.ProductID
GROUP BY p.ProductName;
GO
-- Q7. Find the total sales amount for each order
SELECT 
    OrderID,
    SUM(Quantity * UnitPrice) AS TotalOrderAmount
FROM Order_Items
GROUP BY OrderID;
GO
-- Q8. List customers who registered after January 2023
SELECT *
FROM Customers
WHERE RegistrationDate > '2023-01-31';
GO
-- Q9. Display the top 5 most expensive products
SELECT TOP 5 ProductName, Price
FROM Products
ORDER BY Price DESC;
GO
-- Q10. Count the number of orders placed by each customer
SELECT 
    c.CustomerName,
    COUNT(o.OrderID) AS TotalOrders
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerName;
GO
-- Starting to solve Group B Queries 
/* =========================================================
   GROUP B — INTERMEDIATE SQL (ANALYTICAL QUERIES)
   ========================================================= */

-- Q1. Find total revenue generated by each product category
SELECT 
    p.Category,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue
FROM Order_Items oi
JOIN Products p ON oi.ProductID = p.ProductID
GROUP BY p.Category;
GO

-- Q2. Identify customers who have placed more than two orders
SELECT 
    c.CustomerName,
    COUNT(o.OrderID) AS TotalOrders
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerName
HAVING COUNT(o.OrderID) > 2;
GO

-- Q3. Calculate the average order value for each customer
SELECT 
    c.CustomerName,
    AVG(order_total.TotalAmount) AS AvgOrderValue
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN (
    SELECT 
        OrderID,
        SUM(Quantity * UnitPrice) AS TotalAmount
    FROM Order_Items
    GROUP BY OrderID
) order_total ON o.OrderID = order_total.OrderID
GROUP BY c.CustomerName;
GO

-- Q4. Find customers who have never placed an order
SELECT 
    c.CustomerName
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;
GO

-- Q5. Identify products that were never sold
SELECT 
    p.ProductName
FROM Products p
LEFT JOIN Order_Items oi ON p.ProductID = oi.ProductID
WHERE oi.ProductID IS NULL;
GO

-- Q6. Show monthly sales trend
SELECT 
    FORMAT(o.OrderDate, 'yyyy-MM') AS OrderMonth,
    SUM(oi.Quantity * oi.UnitPrice) AS MonthlySales
FROM Orders o
JOIN Order_Items oi ON o.OrderID = oi.OrderID
GROUP BY FORMAT(o.OrderDate, 'yyyy-MM')
ORDER BY OrderMonth;
GO

-- Q7. Classify orders as high value or low value based on total amount
SELECT 
    OrderID,
    TotalAmount,
    CASE 
        WHEN TotalAmount >= 20000 THEN 'High Value'
        ELSE 'Low Value'
    END AS OrderCategory
FROM (
    SELECT 
        OrderID,
        SUM(Quantity * UnitPrice) AS TotalAmount
    FROM Order_Items
    GROUP BY OrderID
) t;
GO

-- Q8. Find the top three best-selling products by quantity
SELECT TOP 3
    p.ProductName,
    SUM(oi.Quantity) AS TotalQuantitySold
FROM Order_Items oi
JOIN Products p ON oi.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalQuantitySold DESC;
GO

-- Q9. Display city-wise total revenue
SELECT 
    c.City,
    SUM(oi.Quantity * oi.UnitPrice) AS CityRevenue
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Order_Items oi ON o.OrderID = oi.OrderID
GROUP BY c.City;
GO

-- Q10. Identify repeat customers
SELECT 
    c.CustomerName,
    COUNT(o.OrderID) AS OrderCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerName
HAVING COUNT(o.OrderID) > 1;
GO
/* =========================================================
   GROUP C — ADVANCED SQL (CTE, WINDOW, VIEW, UDF, TRIGGER)
   ========================================================= */

-- Q1. Create a view to display customer lifetime value
CREATE OR ALTER VIEW vw_Customer_Lifetime_Value AS
SELECT 
    c.CustomerID,
    c.CustomerName,
    SUM(oi.Quantity * oi.UnitPrice) AS LifetimeValue
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Order_Items oi ON o.OrderID = oi.OrderID
GROUP BY c.CustomerID, c.CustomerName;
GO

-- Q2. Rank customers based on total spending
SELECT 
    CustomerName,
    LifetimeValue,
    RANK() OVER (ORDER BY LifetimeValue DESC) AS SpendingRank
FROM vw_Customer_Lifetime_Value;
GO

-- Q3. Find the top three customers by revenue in each city
WITH CityRevenue AS (
    SELECT 
        c.City,
        c.CustomerName,
        SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN Order_Items oi ON o.OrderID = oi.OrderID
    GROUP BY c.City, c.CustomerName
)
SELECT City, CustomerName, TotalRevenue
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY City ORDER BY TotalRevenue DESC) AS rn
    FROM CityRevenue
) t
WHERE rn <= 3;
GO

-- Q4. Calculate running total of monthly sales
SELECT
    DATENAME(MONTH, o.OrderDate) + '-' + CAST(YEAR(o.OrderDate) AS VARCHAR) AS OrderMonth,
    SUM(oi.Quantity * oi.UnitPrice) AS MonthlyTotal,
    SUM(SUM(oi.Quantity * oi.UnitPrice)) 
        OVER (ORDER BY DATEFROMPARTS(YEAR(o.OrderDate), MONTH(o.OrderDate), 1)) 
        AS RunningTotal
FROM Orders o
JOIN Order_Items oi 
    ON o.OrderID = oi.OrderID
GROUP BY 
    YEAR(o.OrderDate),
    MONTH(o.OrderDate),
    DATENAME(MONTH, o.OrderDate),
    DATEFROMPARTS(YEAR(o.OrderDate), MONTH(o.OrderDate), 1)
ORDER BY 
    DATEFROMPARTS(YEAR(o.OrderDate), MONTH(o.OrderDate), 1);

-- Q5. Identify the most recent order for each customer
SELECT CustomerName, OrderID, OrderDate
FROM (
    SELECT 
        c.CustomerName,
        o.OrderID,
        o.OrderDate,
        ROW_NUMBER() OVER (PARTITION BY c.CustomerID ORDER BY o.OrderDate DESC) AS rn
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
) t
WHERE rn = 1;
GO

-- Q6. Find the time gap between consecutive orders for each customer
SELECT 
    c.CustomerName,
    o.OrderDate,
    LAG(o.OrderDate) OVER (PARTITION BY c.CustomerID ORDER BY o.OrderDate) AS PreviousOrderDate,
    DATEDIFF(DAY,
        LAG(o.OrderDate) OVER (PARTITION BY c.CustomerID ORDER BY o.OrderDate),
        o.OrderDate
    ) AS DaysBetweenOrders
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;
GO

-- Q7. User-defined function to calculate discount based on order value
CREATE OR ALTER FUNCTION dbo.fn_Calculate_Discount (@OrderAmount DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN 
        CASE 
            WHEN @OrderAmount >= 50000 THEN @OrderAmount * 0.10
            WHEN @OrderAmount >= 20000 THEN @OrderAmount * 0.05
            ELSE 0
        END;
END;
GO

-- Q8. Example usage of discount function
SELECT 
    OrderID,
    SUM(Quantity * UnitPrice) AS OrderAmount,
    dbo.fn_Calculate_Discount(SUM(Quantity * UnitPrice)) AS DiscountAmount
FROM Order_Items
GROUP BY OrderID;
GO

-- Q9. Trigger to prevent inserting negative or zero quantity
CREATE OR ALTER TRIGGER trg_Prevent_Invalid_Quantity
ON Order_Items
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Quantity <= 0)
    BEGIN
        RAISERROR ('Quantity must be greater than zero', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Q10. Identify customers whose total spending is above the overall average
WITH CustomerSpend AS (
    SELECT 
        c.CustomerName,
        SUM(oi.Quantity * oi.UnitPrice) AS TotalSpend
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN Order_Items oi ON o.OrderID = oi.OrderID
    GROUP BY c.CustomerName
)
SELECT *
FROM CustomerSpend
WHERE TotalSpend > (SELECT AVG(TotalSpend) FROM CustomerSpend);
GO