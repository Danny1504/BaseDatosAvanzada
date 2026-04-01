
CREATE OR ALTER PROC usp_registrarVenta
@idCliente NCHAR(5),
@productos TiposProductoTypes READONLY
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN;

		DECLARE @idVenta INT;

		--Validar al cliente
		IF NOT EXISTS (
			SELECT 1 
			FROM Cliente 
			WHERE CustomerID = @idCliente
		)
		BEGIN
			PRINT 'Cliente no encontrado';
			ROLLBACK;
			RETURN;
		END

		--Crear una venta
		INSERT INTO Venta(fechaVenta, cliente_id)
		VALUES (GETDATE(), @idCliente);

		SET @idVenta = SCOPE_IDENTITY();

		--Validar los productos que no existen
		IF EXISTS (
			SELECT p.idProducto
			FROM @productos p
			LEFT JOIN Producto pr ON p.idProducto = pr.ProductID
			WHERE pr.ProductID IS NULL
		)
		BEGIN
			PRINT 'Uno o más productos no existen';
			ROLLBACK;
			RETURN;
		END

		--Validar el stock
		IF EXISTS (
			SELECT 1
			FROM @productos p
			JOIN Producto pr ON p.idProducto = pr.ProductID
			WHERE p.cantidad > pr.UnitsInStock
		)
		BEGIN
			PRINT 'Stock insuficiente';
			ROLLBACK;
			RETURN;
		END

		-- Insertar el detalle de venta
		INSERT INTO DetalleVenta(idVenta, idProducto, PrecioVenta, Cantidad)
		SELECT 
			@idVenta,
			pr.ProductID,
			pr.UnitPrice,
			p.cantidad
		FROM @productos p
		JOIN Producto pr ON p.idProducto = pr.ProductID;

		--Actualizar el stock
		UPDATE pr
		SET pr.UnitsInStock = pr.UnitsInStock - p.cantidad
		FROM Producto pr
		JOIN @productos p ON pr.ProductID = p.idProducto;

		COMMIT;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK;

		PRINT 'Error: ' + ERROR_MESSAGE();
	END CATCH
END;
GO

CREATE TYPE TiposProductoTypes AS TABLE(
	idProducto INT,
	cantidad INT
);
GO

select top 10* from Producto;

DECLARE @productos TiposProductoTypes;

INSERT INTO @productos (idProducto, cantidad)
VALUES 
(10, 2),
(15, 4),
(20, 1);

EXEC usp_registrarVenta 
	@idCliente = 'BLAUS',
	@productos = @productos;

	SELECT * FROM Venta ORDER BY idVenta DESC;
SELECT * FROM DetalleVenta ORDER BY idVenta DESC;


SELECT 
    v.idVenta,
    v.fechaVenta,
    v.cliente_id,
    dv.idProducto,
    p.ProductName,
    dv.Cantidad,
    dv.PrecioVenta,
    (dv.Cantidad * dv.PrecioVenta) AS Total
FROM Venta v
INNER JOIN DetalleVenta dv ON v.idVenta = dv.idVenta
INNER JOIN Producto p ON dv.idProducto = p.ProductID
ORDER BY v.idVenta DESC;
