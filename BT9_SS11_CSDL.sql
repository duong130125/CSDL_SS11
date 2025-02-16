-- 2
CREATE VIEW View_High_Value_Customers AS
SELECT 
    c.CustomerId, 
    CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
    c.Email,
    c.Country,
    SUM(i.Total) AS Total_Spending
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE i.InvoiceDate >= '2010-01-01'
AND c.Country <> 'Brazil'
GROUP BY c.CustomerId, FullName, c.Email, c.Country
HAVING Total_Spending > 200;


-- 3
CREATE VIEW View_Popular_Tracks AS
SELECT 
    t.TrackId, 
    t.Name AS Track_Name,
    SUM(il.Quantity) AS Total_Sales
FROM Track t
JOIN InvoiceLine il ON t.TrackId = il.TrackId
WHERE t.UnitPrice > 1.00
GROUP BY t.TrackId, t.Name
HAVING Total_Sales > 15;

-- 4
CREATE INDEX idx_Customer_Country ON Customer (Country) USING HASH;
EXPLAIN SELECT * FROM Customer WHERE Country = 'Canada';

-- 5
CREATE FULLTEXT INDEX idx_Track_Name_FT ON Track (Name);
EXPLAIN SELECT * FROM Track WHERE MATCH(Name) AGAINST('Love');

-- 6
EXPLAIN
SELECT v.*
FROM View_High_Value_Customers v
JOIN Customer c ON v.CustomerId = c.CustomerId
WHERE c.Country = 'Canada';

-- 7
SELECT v.*, t.UnitPrice
FROM View_Popular_Tracks v
JOIN Track t ON v.TrackId = t.TrackId
WHERE MATCH(t.Name) AGAINST('Love');

-- 8
DELIMITER //
CREATE PROCEDURE GetHighValueCustomersByCountry(IN p_Country VARCHAR(50))
BEGIN
    SELECT v.*
    FROM View_High_Value_Customers v
    JOIN Customer c ON v.CustomerId = c.CustomerId
    WHERE c.Country = p_Country;
END;
 // DELIMITER ;
CALL GetHighValueCustomersByCountry('Canada');

-- 9
DELIMITER //
CREATE PROCEDURE UpdateCustomerSpending(IN p_CustomerId INT, IN p_Amount DECIMAL(10,2))
BEGIN
    UPDATE Invoice
    SET Total = Total + p_Amount
    WHERE CustomerId = p_CustomerId
    ORDER BY InvoiceDate DESC;
END;
 // DELIMITER ;
CALL UpdateCustomerSpending(5, 50.00);
SELECT * FROM View_High_Value_Customers WHERE CustomerId = 5;

-- 10
DROP VIEW IF EXISTS View_High_Value_Customers;
DROP VIEW IF EXISTS View_Popular_Tracks;

DROP INDEX idx_Customer_Country ON Customer;
DROP INDEX idx_Track_Name_FT ON Track;

DROP PROCEDURE IF EXISTS GetHighValueCustomersByCountry;
DROP PROCEDURE IF EXISTS UpdateCustomerSpending;