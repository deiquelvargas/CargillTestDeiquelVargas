/*
Cargill test
Prescreening Tasks for Data Engineer Positions
DQ 
For this test SQL Server  was the technology used

*/


-------------------------------------------------------------------------------------------
--Part A - time Taken 30 min
--@ tables were created with the columns names specified in the doc by Cargill

-------------------------------------------------------------------------------------------


--DROP TABLE IF EXISTS Sales
CREATE TABLE Sales
(
    salesOrderID INT NOT NULL,
    salesOrderItem INT NOT NULL,
    customerID INT NOT NULL,
    [date] DATETIME NOT NULL,
    transactionValue FLOAT NOT NULL,
    --Part b. a discountValue needs to be added 
    discountValue FLOAT NOT NULL
);

--We will use the same sale order ID for this test
INSERT INTO Sales
VALUES
(1, 2, 10, GETDATE(), 100, 100),
(1, 3, 10, GETDATE(), 200, 200),
(1, 4, 10, GETDATE(), 300, 300);

/*
select * 
FROM dbo.Sales
*/
--DROP TABLE IF EXISTS Discounts
CREATE TABLE Discounts
(
    salesOrderID INT NOT NULL,
    customerID INT NOT NULL,
    Discountvalue FLOAT NOT NULL
        PRIMARY KEY (
                        salesOrderID,
                        customerID
                    )
);

INSERT INTO Discounts
VALUES
(1, 10, 0.5);
--(2, 20, 0.10), for new clients&Discounts
--(3, 30, 0.20)
/*
SELECT *
FROM dbo.Discounts
*/

-------------------------------------------------------------------------------------------
--Part B --Time taken 40 min
--Calculated the discount using this formula (transactionValue * Discountvalue)
--then I created a temp table to store this value and then display with a simple join
-------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS #temp;
SELECT s.salesOrderID,
       s.transactionValue,
       s.customerID,
       s.salesOrderItem,
       (s.transactionValue * d.Discountvalue) discount
INTO #temp
FROM Sales s
    JOIN Discounts d
        ON s.salesOrderID = d.salesOrderID;
/*
SELECT * 
FROM #temp
*/


UPDATE s
SET s.discountValue = t.discount
FROM dbo.Sales s
    JOIN #temp t
        ON t.salesOrderID = s.salesOrderID
WHERE t.salesOrderID = s.salesOrderID
      AND t.customerID = s.customerID
      AND t.salesOrderItem = s.salesOrderItem;

--Final Select
SELECT *
FROM dbo.Sales;


-------------------------------------------------------------------------------------------
--Part C
-------------------------------------------------------------------------------------------

--DROP TABLE IF EXISTS SalesC

CREATE TABLE SalesC
(
    salesOrderID INT NOT NULL,
    customerID INT NOT NULL,
    [date] DATETIME NOT NULL,
    PRIMARY KEY (salesOrderID)
);

--We will use the same sale order ID for this test
INSERT INTO SalesC
VALUES
(1, 10, GETDATE());


/*
select * 
FROM dbo.Sales
*/
--DROP TABLE IF EXISTS Detail
CREATE TABLE Detail
(
    salesOrderID INT NOT NULL,
    salesOrderItem INT NOT NULL,
    transactionValue FLOAT NOT NULL,
    itemQuantity INT NOT NULL,
    discountvalue FLOAT NOT NULL,
    FinalPrice FLOAT NOT NULL,
    PRIMARY KEY (
                    salesOrderID,
                    salesOrderItem
                )
);
INSERT INTO Detail
VALUES
(1, 2, 100, 5, 0.05, 100),
(1, 3, 200, 20, 0.1, 200),
(1, 4, 300, 30, 0.15, 300);

/*
select * from dbo.SalesC
image

select * from dbo.Detail
*/

UPDATE a
SET FinalPrice = (transactionValue - (transactionValue * discountvalue)) * itemQuantity
FROM dbo.Detail a;


SELECT * FROM dbo.Detail