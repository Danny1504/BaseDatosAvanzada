/*
Funciones de agregado

COUNT*
COUNT(CAMPOS)
MAX()
MIN()
AVG() sirve para sacar promedio 
SUM()

NOTA: Estas funciones por si solas generan un resultado escalar
en pocas palabras un solo registro

GROUP BY 
HAVING


*/

SELECT * FROM Orders;

SELECT COUNT(*) AS [Numero de ordenes]
From Orders;



SELECT COUNT(ShipRegion) AS[Numero de regiones]
FROM Orders;




SELECT MAX(OrderDate) AS [Ultima fecha de compra]
FROM Orders;



SELECT MAX(UnitPrice) AS [Precio mas alto]
FROM Products;


SELECT MIN(UnitsInStock) AS [Stock minimo]
FROM Products;



--cual es el total de ventas realizadas 

SELECT*, (UnitPrice* Quantity -(1-Discount)) AS [importe]
FROM [Order Details];



SELECT 
Round (SUM (UnitPrice* Quantity -(1-Discount)),2) AS [Total]
FROM [Order Details];



--seleccionar el promedio de ventas
SELECT 
Round (AVG (UnitPrice* Quantity -(1-Discount)),2) AS [Promedio]
FROM [Order Details];

--seleccionar el numero de ordenes realizadas a alemania 
SELECT * 
FROM Orders;

SELECT*
FROM Orders
where ShipCountry='germany';

SELECT COUNT(*) AS[TOTAL DE ORDENES]
FROM Orders
where ShipCountry='germany'
AND CustomerID='LEHMS';


SELECT *
FROM Customers;


--SELECCIONAR LA SUMA DE LAS CANTIDADES VENDIDAS POR CADA ORDEN ID(AGRUPADAS POR ESTO)

SELECT OrderID, SUM(Quantity) AS [total de catidades]
FROM [Order Details]
GROUP BY orderid;


--SELECCIONAR EL NUMERO DE PRODUCTOS POR CATEGORIA
SELECT c.CategoryName AS [categoria], COUNT(*) AS [NUMERO DE PRODUCTOS]
FROM Products AS p
INNER JOIN Categories AS c
ON p.CategoryID= c.CategoryID
WHERE c.CategoryName IN('Beverages','Dairy Products')
GROUP BY c.CategoryName;

--Obtener el total de pedidos que a echo cada cliente 
--obtener el numero total de pedidos que a atendido cada empleado

SELECT e.FirstName, e.LastName as[Numero de empleado],
COUNT(*) AS [total de ordenes ]
FROM Orders AS o
INNER JOIN Employees AS e
ON o.EmployeeID= e.EmployeeID
GROUP by e.FirstName, e.LastName 
ORDER BY [Total de ordenes ] DESC;


SELECT
CONCAT(e.FirstName,' ', e.LastName) as[Numero de empleado],
COUNT(*) AS [total de ordenes ]
FROM Orders AS o
INNER JOIN Employees AS e
ON o.EmployeeID= e.EmployeeID
GROUP by e.FirstName, e.LastName 
ORDER BY [Total de ordenes ] DESC;

--ventas totales por producto 
SELECT od.ProductId, Round(SUM(od.Quantity *od.UnitPrice*(1-Discount)),2) AS[Ventas totales]
FROM [Order Details] as od
WHERE ProductID in (10,2,6)
GROUP BY od.ProductID;


SELECT p.ProductName, Round(SUM(od.Quantity *od.UnitPrice*(1-Discount)),2) AS[Ventas totales]
FROM [Order Details] as od
INNER JOIN Products as p
ON p.ProductID =od.ProductID
GROUP BY p.ProductName
Order by 2 desc;



--CALCULAR CUANTOS PEDIDOS SE REALIZARON POR AÑO
SELECT Count(*) AS [NUMERO DE PEDIDOS],
DATEPART(YY,OrderDate) AS [AÑO]
FROM Orders
GROUP BY DATEPART(YY,OrderDate);

--CUANTOS PRODUCTOS OFRECE CADA PROVEEDOR
SELECT s.CompanyName AS [proveedor], COUNT (*)as [NUmero de pedidos]
From Products as p
INNER JOIN Suppliers AS s
ON p.SupplierID =s.SupplierID
GROUP BY s.CompanyName
ORDER BY 2 DESC;

--seleccionar el numero de pedidos por cliente que hayan realizado
--mas de 10

SELECT c.CompanyName AS [Cliente], COUNT(*) AS [numero pedidos]
FROM Orders AS o
INNER JOIN Customers AS c
ON o.CustomerID = c.CustomerId
GROUP BY c.CompanyName
HAVING COUNT(*)>10;
--seleccionar los empleados que hayan gestionado pedidos por un total 
--superior a 10mil en ventas (mostrar el id del empleado y el nombre y el total de compras)

SELECT 
o.EmployeeID AS [Nombre Empleado],
CONCAT (e.FirstName, '', e.LastName) AS [Nombre Completo],
ROUND (SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS [Total Ventas]
FROM [Order Details] AS od
INNER JOIN Orders AS o
ON od.OrderID = o.OrderID
INNER JOIN Employees AS e
ON e.EmployeeID = o.EmployeeID
GROUP BY o.EmployeeID,e.FirstName, e.LastName;







SELECT orderid, sum(Quantity)
from[Order Details]
Where UnitPrice>18
Group by OrderID;




SELECT Orderid,SUM(Quantity)AS [RESULTADO]
From [Order Details]
Group by OrderID
having count(*)>=2;



SELECT ProductId,max(quantity)
FROM [Order Details]
Group by productid
Having sum(quantity)>40;