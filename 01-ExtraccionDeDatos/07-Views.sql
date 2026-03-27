


/*una vista (views), es una tabla virtual
basada en una consulta sirve para reutilizar logica 
simplificar consultas y controlar accesos 

Esisten dos tipos:
-vistas almacenadas
-vistas materializadas (SQL SERVER vistas idexadas)


sintaxis:


-CREATE OR ALTER  VIEW 
vw_"nombre de la vista" AS
Definicion de la vista

*/

--seleccionar todas las ventas por cliente 
--fecha de ventra y estado

--Buenas practicas :
--el nombre de las vistas porlo regular hay que colocar vw
--evitar el select * dentro de las vistas 
--si se necesita ordenar hazlo al cosultar la vista 


CREATE  or ALTER VIEW vw_ventas_totales 
AS 
SELECT
v.VentaId,
v.ClienteId,
v.FechaVenta,
v.Estado,
SUM(dv.Cantidad*dv.PrecioUnit*(1-dv.Descuento/100)) as [TOTAL]
FROM Ventas AS v
INNER JOIN DetalleVenta as dv
On v.VentaId = dv.VentaId
GROUP BY v.VentaId,
v.ClienteId,
v.FechaVenta,
v.Estado;


SELECT*FROM DetalleVenta;
SELECT* FROM Ventas;

--trabajar con la vista 
SELECT vt.VentaId,
vt.ClienteId,
c.Nombre,
total,
DATEPART(MONTH, FechaVenta) AS [Mes]
FROM vw_ventas_totales AS	vt
INNER JOIN Clientes AS c
ON vt.ClienteId= c.ClienteId
WHERE DATEPART(MONTH, FechaVenta) =1
AND TOTAL >=3130;


--realizar una vista que se llame vw_detalle_extendido que muestre
--la venta id el cliente (nombre ), producto, categoria(nombre categoria)
-- cantidad vendida, precio unitario de la venta, precio de la venta,
--descuento y el total de la linea (transaccion)

SELECT*
FROM Ventas AS v
INNER JOIN DetalleVenta as dv
ON v.ClienteId



--en la vista seleccionen 50 lineas ordenadas por la venta id de forma ascendente 
