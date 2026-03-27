# store procedure 

## Fundamentos 

1️⃣ ¿ Que es un stored procedure?
- Es un bloque de codigo sql guardado dentro de la base de datos (**es un objeto de la base de datos**)que puede ejecutarse 
cuando se necesite

Es similar a una funcion o metodo en programacion:

VENTAJAS.
1. Reutilizacion de codigo
2. Mejor rendimiento 
3. Mayor seguridad (evitar la Inyeccion SQL)
4. Centralizacion de la logica del Negocio
5. Menos trafico entre la aplicación y el servidor 

 ```SQL
 CREATE PROCEDURE  usp_objeto_accion
 [Parametros]
 AS
 BEGIN 
 --Body 
 END; 
 ```
--SEGUNDA FORMA
  ```SQL
 CREATE PROC  usp_objeto_accion
 [Parametros]
 AS
 BEGIN 
 --Body 
 END; 
 ```

 --TERCERA FORMA 
  ```SQL
 CREATE OR ALTER PROCEDURE  usp_objeto_accion
 [Parametros]
 AS
 BEGIN 
 --Body 
 END; 
 ```

 2️⃣ Parametros en stored Procedures

 Los parametros permiten enviar datos a los sp 
 ```sql
CREATE DATABASE bdStored;
GO
use bdStored;
Go



--Store Procedure 
CREATE OR ALTER PROC   spu_persona_saludar
--parametros de entrada
@nombre varchar(50) --PARAMETRO DE ENTRADA
AS 
BEGIN 
PRINT 'HOLA '+ @nombre;
END;

EXEC spu_persona_saludar 'Arcadio';
EXEC spu_persona_saludar 'Alas';
EXEC spu_persona_saludar 'Ramiro';
EXEC spu_persona_saludar 'Gonzalo';
GO

SELECT CustomerID, CompanyName, City, Country
INTO customers
FROM NORTHWND.dbo.Customers;
GO

--realizar un stored que reciba el parametro de un cliente en particular 
--y lo muestre 
CREATE OR ALTER PROC spu_cliente_consultar_porid
@Id CHAR(5)
AS
Begin 
SELECT CustomerID AS [Numero],
CompanyName AS [Cliente],
City AS [Ciudad],
Country AS [Pais]
FROM customers
WHERE CustomerID = RTrim(@Id);
END;

EXEC  spu_cliente_consultar_porid 'ANTONT';
GO


/*SELECT*FROM customers
WHERE EXISTS(SELECT 1 FROM customers
WHERE CustomerID='ANTONT');
GO

DECLARE @valor int

SET @valor = (SELECT 1 FROM customers
WHERE CustomerID='ANTONT')
IF @valor =1
BEGIN 
PRINT 'EXISTE'
END
ELSE 
BEGIN 
PRINT 'NO EXISTE'
END;
GO*/


CREATE OR ALTER PROC spu_cliente_consultar_porid2
@Id CHAR(10)
AS
BEGIN
IF LEN(@Id)>5
BEGIN 
RAISERROR('EL ID EXEDE EL VALOR DE CARACTERES, DEBE SER <= 5',16,2);
--THROW 5001, 'EL NUMER DEL CLIENTE DEBE SER MENOR O IGUAL A 5',1;
RETURN
END;
IF EXISTS (SELECT 1 FROM customers
WHERE CustomerID=@Id)
BEGIN 
SELECT
CustomerID AS [Numero],
CompanyName AS [Cliente],
City AS [Ciudad],
Country AS [Pais]
FROM customers
WHERE CustomerID = @Id;
END
RETURN
PRINT 'EL CLIENTE NO EXISTE'
END;
GO


EXEC spu_cliente_consultar_porid2 'Antont';
--segunda forma de como hacer la llamada
DECLARE @id2 AS CHAR(10)= (SELECT CustomerID FROM customers	WHERE CustomerID='ANTON');
EXEC spu_cliente_consultar_porid2 @id2;

go
 ```

 3️⃣PARAMETROS OUTPUT

 Los parametros OUTPUT devuelven valores al usuario 
 ```SQL
/*====================================PARAMETROS OUTPUT============================*/
CREATE OR ALTER PROC spu_operacion_sumar
@a INT,
@b AS INT,
@resultado INT OUTPUT
AS 
BEGIN 
SET @resultado =@a+@b;
END;

--UTILIZAR LA VARIABLE DE SALIDA 
DECLARE @res INT;
EXEC spu_operacion_sumar 4,5, @res OUTPUT;
SELECT @res AS [SUMA];
GO
 ```
 4️⃣Logica dentro del sp

 Puedes usar :
 -IF
 -IF ELSE 
 -WHILE
 -VARIABLES
 -CASE
 ```SQL
CREATE OR ALTER PROC usp_comision_ventas
@idCliente NCHAR (10)
AS
BEGIN
    IF LEN(@idCliente)>5
    BEGIN
    PRINT 'EL TRAMAÑO DEL ID DEL CLIENTE DEBE SER DE 5'
    RETURN;
    END
    IF NOT EXISTS(SELECT 1 FROM Customers WHERE CustomerID=@idCliente)
    BEGIN 
    PRINT 'CLIENTE NO EXISTENTE SO SORRY'
    RETURN;
    END 

    DECLARE @comision DECIMAL (10,2)
    DECLARE @total Money
    SET @total=(
    SELECT (UnitPrice*Quantity)
    FROM [Order Details] as od
    INNER JOIN Orders as o
    On o.OrderID=od.OrderID
    WHERE o.CustomerID=@idCliente)

    SET @comision=
        CASE 
            WHEN @total>=19000 Then 5000
            WHEN @total>=15000 THEN 2000
            WHEN @total>=10000 THEN 1000
            ELSE 500
            END;
        PRINT CONCAT('VENTA TOTAL: ',@total, char(13)+char(10), 'COMISION; ',@comision,
        'Ventas Mas comision: ',
        (@total+@comision));
    
END;
GO
 ```
 ## 5️⃣STORED PROCEDURES CON INSERTS, UPDATE AND DELETE

los sp para manejo de un crud 

 -create (insert)
 -read (select)
 -update (update)
 -delete (delete)
 ```sql
 /*===================================CRUD CON STOREDS=====================================*/
USe bdStored;

CREATE TABLE Productos(
id int IDENTITY,
nombre VARCHAR (50),
precio DECIMAL (10,2)
);
GO

CREATE OR ALTER PROC usp_insertarCliente
@nombre varchar (50),
@precio decimal(10,2)
AS
BEGIN
    INSERT INTO Productos(nombre,precio)
    VALUES (@nombre, @precio);

END;
GO
exec usp_insertarCliente tonyayan,5000;
go
--stored para un update 
CREATE OR ALTER PROC usp_ActualizarPrecio
@id INT,
@precio AS decimal(10,2)
AS
BEGIN 
    if EXISTS(SELECT 1 FROM Productos WHERE id=@id)
    BEGIN
         UPDATE Productos
         SET precio=@precio
         WHERE id=@id
    END
    PRINT 'EL ID DEL PRODUCTO NO EXISTE, NO SE REALIZO LA MODIFICACION';
END;
GO
select*from Productos;
EXEC usp_ActualizarPrecio 1,3500.00;
GO

--DELETE
--validar de tarea 
CREATE OR ALTER PROC ups_Eliminar_Producto
@id AS int
AS
BEGIN
    DELETE Productos
    WHERE id=@id;

END;
GO
 ```

 6️⃣ Manejo de errores 
 -se utiliza try catch
 SINTAXIS 
 ```
 BEGIN TRY

  END TRY
  BEGIN CATCH

  END CATCH
 ```
 Obtener informacion del error `Catch`, SQL tiene funciones especiales:
 Dentro del 
 |FUNCION|DESCRIPCION|
 |:---|:---|
 |ERROR_MESSAGE()|Mensaje del error|
 |ERROR_NUMBER()| Numero del error |
 |ERROR_LINE()|Linea donde ocurrio el error|
 |ERROR_PROCEDURE()|Procedimiento|
 |ERROR_SEVERITY()|Nivel de gravdedad|
 |ERROR_STATE()|Estado del Error|

 /================================== MANEJO DE ERRORES ===============================/

--Sin manejo de errores

SELECT 10/0;

--Esto genera un error o una excepción y detiene la ejecución

BEGIN TRY

    SELECT 10/0;

END TRY

BEGIN CATCH 

    PRINT 'Ocurrio el error'

END CATCH

GO

BEGIN TRY

    SELECT 10/0;

END TRY

BEGIN CATCH 

    PRINT 'Mensaje: ' + ERROR_MESSAGE();
    PRINT 'Número: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    PRINT 'Línea: ' + CAST(ERROR_LINE() AS VARCHAR);

END CATCH

GO

--USO CON INSERT 

CREATE TABLE productos2(
     id int primary key,
     nombre varchar(50),
     precio decimal)

GO
DROP TABLE productos2;

GO

INSERT INTO productos2
VALUES(1, 'Pepsi', 359.0)

GO

--EEjemplo de uso de transacción
USE bdstored;

BEGIN TRANSACTION;

INSERT INTO productos2
VALUES(2, 'Pitufina', 56.8);

SELECT * FROM productos2;

ROLLBACK; --Cancela la transaccion, permite que la bd no quede inconsistente
COMMIT; --Confirma la transaacion, por que todo fue atomico o se cumplio

/===================================== Uso de transacciones =====================================/

--EJERCICIO PARA VERIFICAR EN DONDE EL TRY CATCH SE VUELVE PODEROSO


BEGIN TRY

    BEGIN TRANSACTION;

    INSERT INTO productos2
    VALUES (3, 'Charro Negro', 123.0);

     INSERT INTO productos2
    VALUES (3, 'Pantera Rosa', 345.6);

        COMMIT;

END TRY

BEGIN CATCH

    ROLLBACK;
    PRINT 'Se hizo un ROLLBACK con error'
    PRINT 'ERROR: ' + ERROR_MESSAGE()

END CATCH;

--VALIDAR SI UNA TRANSACCIÓN ESTA ACTIVA 
BEGIN TRY

    BEGIN TRANSACTION;

    INSERT INTO productos2
    VALUES (3, 'Charro Negro', 123.0);

     INSERT INTO productos2
    VALUES (3, 'Pantera Rosa', 345.6);

        COMMIT;

END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0 --INVESTIGAR
ROLLBACK

    PRINT 'Se hizo un ROLLBACK con error'
    PRINT 'ERROR: ' + ERROR_MESSAGE()

END CATCH;



>NOTA: ERRORES QUE NO CAPTURA EL TRY - CATCH
    -ERRORES DE COMPILACIÓN (EJ. Tabla que no existe)
    -ERRORES DE SALIDA

 ```sql

BEGIN TRY

    SELECT * FROM Tblquenoexiste

END TRY

BEGIN CATCH
    PRINT 'No entra aquí'
END CATCH

```


 