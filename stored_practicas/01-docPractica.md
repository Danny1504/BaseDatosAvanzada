Este documento describe paso a paso la creación de la base de datos **bd_ventasSp**, sus tablas principales, el procedimiento almacenado para registrar ventas y el trigger que protege la integridad de los precios en los detalles de venta.

---

## 1. Creación de la base de datos
```sql
CREATE DATABASE bd_ventasSp;
GO

USE bd_ventasSp;
```

🤐 **CREACION DE LA TABLA PRODUCTO**
```sql

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
```
- Se copia la información de productos desde la base NORTHWND.
- Se define la clave primaria en ProductID

😶‍🌫️ **CREACION DE LA TABLA CLIENTE** 
```SQL
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
```
- Se copia la información de clientes desde NORTHWND.
- Se define la clave primaria en CustomerID

🥶**CREACION DE LA TABLA VENTA** 
```SQL
CREATE TABLE Venta(
    idVenta INT IDENTITY(1,1) PRIMARY KEY,
    fechaVenta DATE NOT NULL,
    cliente_id NCHAR(5),

    CONSTRAINT fk_ventas_clientes
    FOREIGN KEY (cliente_id)
    REFERENCES Cliente(CustomerID)
);
```
- Tabla que almacena las ventas realizadas.
- Relacionada con la tabla Cliente.

👹 **CREACION DE LA TABLA DETALLE VENTA** 
```SQL
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
```
- Tabla que almacena los productos vendidos en cada venta.
- Relacionada con Venta y Producto.
- La clave primaria es compuesta (idVenta, idProducto).


🫠 **CREACION DEL STORED PROCEDURE**
```SQL
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

        -- Validar que el cliente si exista
        IF NOT EXISTS (SELECT 1 FROM Cliente WHERE CustomerID = @clienteId)
        BEGIN
            THROW 50001, 'El cliente no existe', 1;
        END

        -- Insertar una venta
        INSERT INTO Venta(fechaVenta, cliente_id)
        VALUES (GETDATE(), @clienteId);

        SET @ventaId = SCOPE_IDENTITY();

        -- Validar que el producto exista
        IF NOT EXISTS (SELECT 1 FROM Producto WHERE ProductID = @productoId)
        BEGIN
            THROW 50002, 'El producto no existe', 1;
        END

        -- Obtener los datos del producto
        SELECT  
            @precioActual = UnitPrice,
            @existencias = UnitsInStock
        FROM Producto
        WHERE ProductID = @productoId;

        -- Validar la cantidad del stock
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
```
## Funcionalidad resumida del stored procedure 
- Valida que el cliente exista.
- Inserta la venta con fecha actual.
- Valida que el producto exista.
- Obtiene precio y stock del producto.
- Verifica que haya suficiente stock.
- Inserta el detalle de la venta.
- Actualiza el inventario.
- Maneja errores con THROW y rollback

🧐 **CREACION DE TRIGGER PARA EVITAR CAMBIOS EN DETALLE VENTA**

```SQL
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
Funcionalidad:
- Se ejecuta automáticamente después de un UPDATE en la tabla DetalleVenta.
- Si se intenta modificar la columna PrecioVenta, lanza un error y bloquea la operación.
- Permite modificar otras columnas como Cantidad

🙃🫠**CONCLUSION**🙃🫠
- Se creó la base de datos y las tablas necesarias.
- Se implementó un procedimiento almacenado robusto con validaciones y manejo de transacciones.
- Se agregó un trigger para garantizar la integridad del precio en los detalles de venta.
- El sistema ahora cumple con las reglas de negocio planteadas en el diseño.


ultima actualizacion del formato