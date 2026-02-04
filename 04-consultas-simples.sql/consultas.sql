--
use NORTHWND;

SELECT*
FROM Employees;
GO

SELECT*
FROM Customers;
GO

SELECT*
FROM Orders;
GO

SELECT*
FROM [Order Details];
GO

SELECT*
FROM Shippers;
GO

SELECT*
FROM Suppliers;
GO

SELECT*
FROM Products;
GO


--PRYECCION DE LA TABLA 
SELECT ProductName, UnitsInStock, UnitPrice
FROM Products;

--Alias de la columna 
SELECT ProductName AS NombreProducto,
UnitsInStock 'Unidades Medida',
UnitPrice AS [Precio Unitario]
FROM Products;

--campo calculado y alias de la tabla 
SELECT
OrderID AS [NUMERO DE ORDEN],
pr.ProductID AS [NUMERO DEL PRODUCTO], 
ProductName AS 'NOMBRE DEL PRODUCTO', 
Quantity AS CANTIDAD,
pr.UnitPrice As PRECIO,
(Quantity*od.UnitPrice) AS SUBTOTAL
FROM [Order Details] AS od
INNER JOIN 
Products pr
on pr.ProductID= od.ProductID;


--Operadores relacionales (<,>, <=, >=, =, != o <>)
-- mostrar todos los productos mayores a 20
SELECT ProductName as [nombre producto],
QuantityPerUnit as [descripcion],
UnitPrice as [precio]
FROM Products
Where UnitPrice >20;

--seleccionar todos los clientes que no sean de mexico 
SELECT*
FROM Customers
WHERE country <> 'Mexico';

--seleccionar todos aquellas ordenes realizadas en 1997
SELECT OrderID as [NUMERO DE ORDEN],
OrderDate AS [FECHA DE ORDEN],
YEAR (OrderDate) as[Año con year],
DATEPART (YEAR, OrderDate) as[Año con DATEPART]
FROM Orders
Where YEAR(OrderDate)= 1997;

set Language Spanish
SELECT OrderID as [NUMERO DE ORDEN],
OrderDate AS [FECHA DE ORDEN],
YEAR (OrderDate) as[Año con year],
DATEPART (YEAR, OrderDate) as[Año con DATEPART],
DATEPART(QUARTER, OrderDate) as Trimestre,
DATEPART(WEEKDAY, OrderDate) as[Dia semana],
DATEPART(WEEKDAY, OrderDate) as [Nombre dia Semana]
FROM Orders
Where YEAR(OrderDate)= 1997;


--operadores logicos (AND, OR, NOT)

--seleccionar los productos que un precio mayor a 20 y un stock mayor a 30 
SELECT 
ProductID AS [Numero Producto],
ProductName AS [Nombre del Producto],
UnitsInStock AS [Existencia],
UnitPrice AS [Precio],
(UnitPrice*UnitsInStock) as [Costo Inventario]
FROM Products
WHERE UnitPrice>20
AND UnitsInStock>30;

--seleccionar a los clientes de estados unidos o canada
SELECT
CustomerID,
CompanyName,
city,
Country
FROM Customers
Where Country = 'Canada'
OR Country='usa';



--seleccionar los clientes de brazil, rio de janeiro y que tengan region 

SELECT
CustomerID,
CompanyName,
City,
Region
FROM Customers
where Country='Brazil'
AND city='Rio de janeiro'
AND region IS NOT NULL;

--operador in 
--Seleccionar todos los clientes de estrados unidos, alemania y francia
SELECT*
FROM Customers
WHERE Country='usa' 
OR country='germany' 
Or country= 'france'
ORDER BY Country;

--operador in
SELECT*
FROM Customers
WHERE Country IN('usa','germany','france')
ORDER BY Country;

--orden desendente
SELECT*
FROM Customers
WHERE Country IN('usa','germany','france')
ORDER BY Country DESC;

--Seleccionar los nombres de 3 categorias especificas 
SELECT*
FROM Categories
WHERE CategoryName in('seafood','Condiments','beverages')
ORDER BY CategoryName;


--seleccionar los pedidos de 3 epleados en especifico 
SELECT * 
FROM Orders
Where EmployeeID = 2 
Or EmployeeID=5 
OR EmployeeID=11;


SELECT e.EmployeeID,
Concat(e.FirstName, e.LastName) as Fullname,
o.OrderDate
From Orders as o
INNER JOIN Employees e
ON o.EmployeeID=e.EmployeeID
Where o.EmployeeID IN(2,6,8)
ORDER BY 2 desc;

--Seleccionar todos los clientes que no sean de Alemania 
--mexico y argentina 
SELECT*
FROM Customers
WHERE country NOT IN ('Mexico', 'Germany', 'Argentina')
ORDER BY Country;


--OPERADOr BEETWEN 
--Seleccionar todos los productos que su precio este entre 10 y 30 
SELECT
ProductName,
UnitPrice
FROM Products
WHERE UnitPrice >=10 and UnitPrice<=30
ORDER BY 2 DESC;


SELECT 
ProductName,
UnitPrice
FROM Products
WHERE UnitPrice BETWEEN 10 and 30;


--seleccionar todas las ordenes de 1995 a 1997
SELECT
ShipCountry,
OrderID,
OrderDate
FROM Orders
WHERE DATEPART(YEAR, OrderDate) BETWEEN 1995 and 1997;


--operador like 
--wildcars (%, _,[], [^],)

--seleccionar todos los clientes donde su
--nombre comience con 'a'
SELECT*
FROM Customers
WHERE CompanyName LIKE 'a%'

SELECT*
FROM Customers
WHERE CompanyName LIKE 'an%';


-- Seleccionar todos los clientes de una ciudad 
-- que comienza comienza con l, seguido de culaquier caracter,
--despues nd y que teremine con dos caracteres cualquiera
SELECT*
FROM Customers
WHERE City LIKE 'L_nd__%';


--seleccionar todos los clientes que su nombre termine con 'a'
SELECT*
FROM Customers
WHERE CompanyName Like '%a';


--devolver todos los clientes que en la ciudad contenga la letra L
SELECT CustomerID, CompanyName,City
FROM Customers
WHERE City LIKE '%la%';


--devolver todos los clientes que comienzan con A o comienzan con B
SELECT CustomerID, CompanyName, City
FROM Customers
WHERE  CompanyName LIKE 'a%' 
OR CompanyName LIKE 'b%';
GO


--devolver todos los clientes que comienzan con B y termian con s 

SELECT CustomerID, CompanyName, City
FROM Customers
WHERE CompanyName LIKE 'b%';

SELECT CustomerID, CompanyName, City
FROM Customers
WHERE CompanyName LIKE 'b%'
AND CompanyName LIKE '%s';

--devolver todos los clientes que comienzan con a y tengan almenos 3 caracteres 
SELECT CustomerID, CompanyName, City
FROM Customers
WHERE CompanyName LIKE 'a__%';

--devolver todos los clientes que tienen 'r' en la segunda posicion
SELECT CustomerID, CompanyName, City
FROM Customers
WHERE CompanyName LIKE '_r%';

--devolver todos los clientes que contenagn a, b, c al inicio
SELECT CustomerID, CompanyName, City
FROM Customers
WHERE CompanyName LIKE '[abc]%';

--Todos los que no comiencen con a,b o c
SELECT CustomerID, CompanyName, City
FROM Customers
WHERE CompanyName LIKE '[^abc]%';

SELECT CustomerID, CompanyName, City
FROM Customers
WHERE CompanyName NOT LIKE '[abc]%';


SELECT CustomerID, CompanyName, City
FROM Customers
WHERE CompanyName LIKE '[a-f]%';


--seleccionar todos los clientes de usa, mostrando solo los 3
SELECT TOP 3*
FROM Customers
WHERE Country = 'usa';


--Seleccionar todos los clientes ordenados de forma ascendente por su numero de 
--cliente pero saltando las primeras 5 filas 
SELECT*
FROM Customers
ORDER BY CustomerID ASC
OFFSET 5 ROWS;

--Seleccionar todos los clientes ordenados de forma ascendente por su numero de 
--cliente pero saltando las primeras 5 filas y mostrar las siguientes 10 (offset y fetch)

SELECT*
FROM Customers
ORDER BY CustomerID ASC
OFFSET 5 ROWS
FETCH NEXT 10 ROWS ONLY;
