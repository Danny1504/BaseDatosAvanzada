CREATE DATABASE bd_ventasSp;
Go

USE bd_ventasSp;


SELECT 
ProductID,
ProductName,
UnitPrice,
UnitsInStock
INTO Producto
FROM NORTHWND.dbo.Products;

ALTER TABLE Producto
ADD CONSTRAINT pk_producto PRIMARY KEY (ProductID);
GO

SELECT
CustomerID,
CompanyName,
Country,
City
INTO Cliente
FROM NORTHWND.dbo.Customers;

ALTER TABLE Cliente
ADD CONSTRAINT pk_cliente PRIMARY KEY (CustomerID);
GO

CREATE TABLE Venta(
	idVenta INT IDENTITY(1,1) PRIMARY KEY,
	fechaVenta DATE NOT NULL,
	cliente_id NCHAR(5),

	CONSTRAINT fk_ventas_clientes
	FOREIGN KEY (cliente_id)
	REFERENCES Cliente(CustomerID)
);

CREATE TABLE DetalleVenta(
	idVenta INT NOT NULL,
	idProducto INT NOT NULL,
	PrecioVenta MONEY NOT NULL,
	Cantidad INT NOT NULL,

	CONSTRAINT pk_detalle PRIMARY KEY(idVenta, idProducto),

	CONSTRAINT fk_detalle_producto
	FOREIGN KEY (idProducto)
	REFERENCES Producto(ProductID),

	CONSTRAINT fk_detalle_venta
	FOREIGN KEY (idVenta)
	REFERENCES Venta(idVenta)
);
GO

CREATE OR ALTER PROC usp_registrarVenta
    @clienteId NCHAR(5),
    @productoId INT,
    @cantidadVendida INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ventaId INT;
        DECLARE @existencias INT;
        DECLARE @precioActual MONEY;

        -- Validar la existencia de cliente
        IF NOT EXISTS (SELECT 1 FROM Cliente WHERE CustomerID = @clienteId)
        BEGIN
            THROW 50001, 'El cliente no existe', 1;
        END

        -- Insertar la venta
        INSERT INTO Venta(fechaVenta, cliente_id)
        VALUES (GETDATE(), @clienteId);

        SET @ventaId = SCOPE_IDENTITY();

        -- Validar existencia del producto
        IF NOT EXISTS (SELECT 1 FROM Producto WHERE ProductID = @productoId)
        BEGIN
            THROW 50002, 'El producto no existe', 1;
        END

        -- Obtener datos del producto
        SELECT  
            @precioActual = UnitPrice,
            @existencias = UnitsInStock
        FROM Producto
        WHERE ProductID = @productoId;

        -- Validar lo que hay en stock
        IF @existencias < @cantidadVendida
        BEGIN
            THROW 50003, 'No hay suficiente stock', 1;
        END

        -- Insertar el detalle de la venta
        INSERT INTO DetalleVenta(idVenta, idProducto, PrecioVenta, Cantidad)
        VALUES (@ventaId, @productoId, @precioActual, @cantidadVendida);

        -- Actualizar el inventario
        UPDATE Producto
        SET UnitsInStock = UnitsInStock - @cantidadVendida
        WHERE ProductID = @productoId;

        COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @mensaje NVARCHAR(4000);
        SET @mensaje = ERROR_MESSAGE();

        PRINT 'Error en el proceso: ' + @mensaje;
    END CATCH
END;
GO


use bd_ventasSp;
EXEC usp_registrarVenta 
    @clienteId = 'ALFKI',   
    @productoId = 1,       
    @cantidadVendida = 3;   
    GO

CREATE TRIGGER trg_evitar_cambios_detalle_venta
ON DetalleVenta
AFTER UPDATE
AS
BEGIN
    IF UPDATE(PrecioVenta)
    BEGIN
        THROW 50010, 'No está permitido modificar el precio en DetalleVenta', 1;
    END
END;
GO



    --cambiar no usar raissor error con las transacciones solo trows
    --y no usar rollback en cada if 