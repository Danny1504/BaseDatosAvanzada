--Consultas obligatorias:
USE ERP_VentasInventario;
--1. Listado de ventas (fecha, cliente, empleado, total calculado) ordenado por fecha DESC (JOIN 3+
--tablas).
SELECT
    v.idVenta,
    v.fechaVenta,
    c.nombreCliente,
    e.puesto AS empleado,
    SUM(dv.subtotalCalculado) AS totalVenta
FROM Ventas v
JOIN Clientes c ON c.idCliente = v.idCliente
JOIN Empleados e ON e.idEmpleado = v.idEmpleado
JOIN DetalleVenta dv ON dv.idVenta = v.idVenta
GROUP BY v.idVenta, v.fechaVenta, c.nombreCliente, e.puesto
ORDER BY v.fechaVenta DESC;

--2. Detalle de una venta especifica: productos, cantidad, descuentos, subtotales (JOIN con
--DetalleVenta).
SELECT *
FROM vw_VentasDetalladas
WHERE idVenta = 1
ORDER BY [Nombre del Producto];


--3. Top 10 productos mas vendidos por cantidad y por ingreso (GROUP BY + SUM).

SELECT TOP 10
    p.nombreProducto,
    SUM(dv.cantidad) AS totalCantidad,
    SUM(dv.subtotalCalculado) AS totalIngreso
FROM DetalleVenta dv
JOIN Productos p ON p.idProducto = dv.idProducto
JOIN Ventas v ON v.idVenta = dv.idVenta
WHERE v.estatus <> 'Cancelada'
GROUP BY p.nombreProducto
ORDER BY totalIngreso DESC;

--4. Top 5 categorias por ingreso total (JOIN + GROUP BY).

SELECT TOP 5
    cat.nombreCategoria,
    SUM(dv.subtotalCalculado) AS ingresoCategoria
FROM DetalleVenta dv
JOIN Ventas v ON v.idVenta = dv.idVenta
JOIN Productos p ON p.idProducto = dv.idProducto
JOIN Categortias cat ON cat.idCategoria = p.idCategoria
WHERE v.estatus <> 'Cancelada'
GROUP BY cat.nombreCategoria
ORDER BY ingresoCategoria DESC;

--5. Clientes frecuentes: clientes con mas de 3 ventas y gasto total > X (GROUP BY + HAVING).

SELECT
    c.nombreCliente,
    COUNT(DISTINCT v.idVenta) AS numVentas,
    SUM(dv.subtotalCalculado) AS gastoTotal
FROM Clientes c
JOIN Ventas v ON v.idCliente = c.idCliente
JOIN DetalleVenta dv ON dv.idVenta = v.idVenta
WHERE v.estatus <> 'Cancelada'
GROUP BY c.nombreCliente
HAVING COUNT(DISTINCT v.idVenta) > 3
   AND SUM(dv.subtotalCalculado) > 20000
ORDER BY gastoTotal DESC;

--6. Empleados con ventas totales del mes > promedio del mes (subconsulta o CTE opcional) y HAVING.
SELECT 
e.idEmpleado,
e.puesto AS Empleado,
YEAR(v.fechaVenta) AS Anio,
MONTH(v.fechaVenta) AS Mes,
SUM(dv.subtotalCalculado) AS TotalVendido
FROM Ventas v
INNER JOIN Empleados e ON v.idEmpleado = e.idEmpleado
INNER JOIN DetalleVenta dv ON v.idVenta = dv.idVenta
WHERE v.estatus = 'Cancelada'
GROUP BY 
e.idEmpleado,
e.puesto,
YEAR(v.fechaVenta),
MONTH(v.fechaVenta)
HAVING SUM(dv.subtotalCalculado) >
(
SELECT AVG(TotalEmpleado)
FROM (
SELECT 
SUM(dv2.subtotalCalculado) AS TotalEmpleado
FROM Ventas v2
INNER JOIN DetalleVenta dv2 ON v2.idVenta = dv2.idVenta
WHERE v2.estatus <> 'Cancelada'
AND YEAR(v2.fechaVenta) = YEAR(v.fechaVenta)
AND MONTH(v2.fechaVenta) = MONTH(v.fechaVenta)
GROUP BY v2.idEmpleado
) AS Promedios
);




--7. Ventas canceladas por mes: numCanceladas y porcentaje (campos calculados).
SELECT 
YEAR(fechaVenta) AS Anio,
MONTH(fechaVenta) AS Mes,
COUNT(*) AS TotalVentas,
SUM(CASE WHEN estatus = 'Cancelada' THEN 1 ELSE 0 END) AS NumCanceladas,
CAST(
100.0 * SUM(CASE WHEN estatus = 'Cancelada' THEN 1 ELSE 0 END)
/ COUNT(*)
AS DECIMAL(5,2)) AS PorcentajeCanceladas
FROM Ventas
GROUP BY 
YEAR(fechaVenta),
MONTH(fechaVenta)
ORDER BY Anio, Mes;



--8. Saldo por venta: totalVenta - SUM(pagos) y mostrar solo ventas con saldo > 0 (GROUP BY +
--HAVING).
SELECT 
v.idVenta,
v.fechaVenta,
SUM(dv.subtotalCalculado) AS TotalVenta,
ISNULL(SUM(p.monto), 0) AS TotalPagado,
SUM(dv.subtotalCalculado) - ISNULL(SUM(p.monto), 0) AS SaldoPendiente
FROM Ventas AS v
INNER JOIN DetalleVenta AS dv ON v.idVenta = dv.idVenta
LEFT JOIN PagosVenta AS p ON v.idVenta = p.idVenta
WHERE v.estatus = 'Cancelada'
GROUP BY 
    v.idVenta,
    v.fechaVenta
HAVING 
    SUM(dv.subtotalCalculado) - ISNULL(SUM(p.monto), 0) > 0;



--9. Inventario critico por almacen: productos con stock <= stockMin (consulta o usando la vista).
SELECT a.nombreAlmacen As [Nombre del Almacen],
p.nombreProducto AS [Nombre del Producto],
i.stock,
i.stockMin
FROM Inventario AS i
INNER JOIN Almacenes AS a
ON i.idAlmacen=a.idAlmacen
INNER JOIN Productos AS p
ON i.idProdcuto = p.idProducto
WHERE i.stock<=i.stockMin
ORDER BY a.nombreAlmacen, p.nombreProducto;

--tambien se puede hacer utilizando la vista para no hacer el uso de tantos joins
SELECT
[Nombre del Almacen],
[Nombre del Producto],
[Stock],
[Stock Minimo]
FROM vw_AbastecerInventario
ORDER BY [Nombre del Almacen], [Nombre del Producto];

--10. Productos nunca vendidos (LEFT JOIN productos vs detalleVenta, WHERE detalleVenta.idProducto IS
--NULL).
--11. Consulta a vw_KPI_VentasMensual filtrando por anio.
--12. Consulta a vw_VentaDetallada en rango de fechas con filtro por empleado.