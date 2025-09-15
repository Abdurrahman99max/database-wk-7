/* =========================================================
   Assignment: Database Design and Normalization
   ========================================================= */
   
   ------------------------------------------------------------
-- Q1: Achieving 1NF
-- Original "ProductDetail" violated 1NF because Products contained multiple values
-- We normalize by ensuring one product per row
------------------------------------------------------------

-- Create ProductDetail_1NF table
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(50)
);

-- Insert normalized rows (one product per row)
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');

------------------------------------------------------------
-- Q2: Achieving 2NF
-- In 1NF OrderDetails, CustomerName depends only on OrderID 
-- (partial dependency), so we split into Orders_2NF + OrderItems
------------------------------------------------------------

-- Create Orders_2NF table (customer info only)
CREATE TABLE Orders_2NF (
    orderNumber INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Insert unique orders
INSERT INTO Orders_2NF (orderNumber, CustomerName)
VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

-- Create OrderItems table (products linked to orders)
CREATE TABLE OrderItems (
    orderNumber INT,
    Product VARCHAR(50),
    Quantity INT,
    FOREIGN KEY (orderNumber) REFERENCES Orders_2NF(orderNumber)
);

-- Insert product details
INSERT INTO OrderItems (orderNumber, Product, Quantity)
VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);

------------------------------------------------------------
-- ✅ Verification Queries
------------------------------------------------------------

-- Show ProductDetail_1NF (Q1 result)
SELECT * FROM ProductDetail_1NF;

-- Show OrderItems (Q2 - normalized order-product details)
SELECT * FROM OrderItems;

-- Join Orders_2NF + OrderItems to reconstruct original view
SELECT o.orderNumber, o.CustomerName, i.Product, i.Quantity
FROM Orders_2NF o
JOIN OrderItems i ON o.orderNumber = i.orderNumber;

