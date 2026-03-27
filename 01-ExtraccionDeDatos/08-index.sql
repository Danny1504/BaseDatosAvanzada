USE SalesDB;

--crear una tabla como copia de coustumers


SELECT*
INTO Sales.DBCustomers
From Sales.Customers;




SELECT*
FROM Sales.DBCustomers
Where CustomerID=1;


--crear a clustered index on sales.dbcustomers usando customers id

CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers(CustomerID);