## 🤖1. Objetivo del cambio

Inicialmente, el registro de ventas se realizaba mediante un Stored Procedure que recibía un solo producto por ejecución, lo cual limitaba el sistema a registrar ventas unitarias.

El stored procedure inicial estaba de esta forma:
```sql
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
```

## 🤤🥓Cambios ralizados al stored procedure🥓🤤
El cambio implementado consistió en:

Permitir registrar múltiples productos en una sola venta
Optimizar el proceso mediante el uso de un Table Type (tipo tabla)
Reducir múltiples llamadas al procedimiento almacenado

## 😧😧Primero se creo la tabla tipo type para realizar este cambio
Se creó un tipo de dato estructurado en SQL Server que permite enviar múltiples registros como parámetro:
```sql
CREATE TYPE TiposProductoTypes AS TABLE(
	idProducto INT,
	cantidad INT
);
```
describiendo un poco lo que se hace es crear una tabla "virtual" donde se identifican los productos y la cantidad solicitada de estos y ojo es de solo tipo lectura (READONLY)

## 😮‍💨😮‍💨Actualizacion del stored procedure con la tabla tipo type😮‍💨😮‍💨
```sql
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
```
los cambios importantes que se hacen en este stored son:
**Antes**🧐🤬
- solo recibia un producto
- inserciones individuales
- validacion por producto
**Ahora**😎🫨
- Recibe una tabla de productos (la del tipo type)
- inserciones con select
- validacion en conjunto

## 😈Funcionalidad😈
Iniciamos diciendo que toda la operacion sea un todo o nada
- tambien verifica que nuestro cliente exista  antes de hacer el registro de venta
- ahora tambien crea la venta y obtiene su id para poder relacionar con lo detalles 😧
- validamos tambien que los productos existan realmemnte dentro de la bd 😏
- se valida tambien que exista suficiente inventario🧐
- en la insercion de el detalle de venta hacemos el cambio "importante" en una sola operacion se insertan multiples productos, por ello hacemos uso de un "select" y no de un "insert into" 😧🥶🐶
- tambien se realiza la operacion de descuento en el stock despues de cada venta realizada 🥲
- ya si es que no hubo ningun error en toda la transaccion pues procede a realizar los cambios 😮‍💨
- pero si algo llega a fallar cae en el catch "rollback" y esto nos camncela toooda la operacion evitando que haya inconsistencia en los datos 🐶🤯🥶

## 😪😥Pruebas para ver funcionalidad 😥😪
Para checar que si funcionaba antes que todo estos procedimientos creamos una variable tipo tabla,
a la cual se le insertaron datos y posteriormente se ejecuto, queddando de la siguiente manera:
```sql

DECLARE @productos TiposProductoTypes;

INSERT INTO @productos (idProducto, cantidad)
VALUES 
(10, 2),
(15, 4),
(20, 1);

EXEC usp_registrarVenta 
	@idCliente = 'BLAUS',
	@productos = @productos;
```
La imagen del resultado de esta prueba se encontrara en la carpeta de imagenes

## 👹🥸Creacion del inner 🥸👹
- se creo un inner para que nos mostrara la informacion completa de la venta 
- calcular el total del producto y se le incluyo el nombre del producto

el inner fue el siguiente: 
```sql
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
```
este inner es para mera vista de que haya funcionado realmemnte despues de la implementacion en la parte de la interfaz grafica, se encontrara una captura de los resultados de este despues de la ejecucion en la parte de la interfaz en la carpeta de imagenes tambien 

## 🤕🥴CONCLUSION🥴🤕

todo lo que se realizo pues fue de mucha ayuda, de esa forma, ya no insertas de un articulo en articulo, puedes registrar varios de un solo golpe pero evitando duplicidad, en un entorno real esto seria mas factible a que solamente insertes de un solo producto en un solo producto, igual todo esto gracias al stored completo con la actualizacion de el parametro tipo tabla type ys u creacion claro.

