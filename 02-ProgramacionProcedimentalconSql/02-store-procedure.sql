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


--crear un store procedure con parametros de entrada y salida 
--para calcular el area de un triangulo 

CREATE OR ALTER PROC spu_operacion_area_triangulo
@a INT,
@b AS INT,
@resultado INT OUTPUT
AS 
BEGIN 
SET @resultado =(@a+@b)/2;
END;

--UTILIZAR LA VARIABLE DE SALIDA 
DECLARE @res INT;
EXEC spu_operacion_sumar 4,5, @res OUTPUT;
SELECT @res AS [SUMA];
GO


/*=========================LOGIA DENTRO DEL SP================*/
--crear un sp  que evalue la edad de una persona 
CREATE OR ALTER PROC sp_Persona_EvaluarEdad
@edad int 
AS
BEGIN 
IF @edad>=18 AND @edad<=45
BEGIN 
PRINT 'ERES UN ADULTO SIN PENSION';
END
ELSE 
BEGIN 
PRINT 'ERES MENOR DE EDAD';
END
END;
GO

EXEC sp_Persona_EvaluarEdad 22;
GO

GO
CREATE OR ALTER PROC usp_Valores_Imprimir
    @n AS INT 

AS
BEGIN

    IF @n<=0
    BEGIN
        PRINT ('ERROR: VALOR DE N NO VALIDO');
        RETURN;
    END
    DECLARE @i AS INT ;
    DECLARE @j int =1;
    SET @i=1;

    WHILE (@i<=@n)
    BEGIN
    WHILE(@j<=10)
    BEGIN
    PRINT CONCAT(@i, '*', @j, '=', @i*@j);
     SET  @j=@j+1;
        END
        PRINT(CHAR (13)+CHAR(10))
        SET @i=@i+1;
        SET @j =1;
        END
     
END;
GO

EXEC usp_Valores_Imprimir @n=6;
GO
/*====================CASE=====================*/
--Sirve para evaluar condiciones como un switch o if multiple
CREATE OR ALTER PROCEDURE usp_Calificacion_Evaluar
@calificacion AS INT
AS
BEGIN
    SELECT
    CASE
        WHEN @calificacion>=90 THEN 'EXELENTE'
        WHEN @calificacion >=70 THEN 'APROBADO'
        WHEN @calificacion>=60 THEN 'REGULAR'
        ELSE 'NO ACREDITADO'
    END AS RESULTADO
END;
GO

--EJECUTAR
EXEC usp_Calificacion_Evaluar 33;
EXEC usp_Calificacion_Evaluar 90;


go

use NORTHWND;
--EJEMPLO CON LA BASE DE DATOS NORTHWIND
SELECT ProductName,UnitPrice,
CASE
WHEN UnitPrice>=200 THEN 'caro'
WHEN UnitPrice>=100 Then 'medio'
else 'barato'
END AS [CATEGORIA]
FROM Products;
GO


CREATE OR ALTER PROC usp_comision_ventas
@idCliente NCHAR (10)
AS
BEGIN
    IF LEN(@idCliente)>5
    BEGIN
    PRINT 'EL TRAMA�O DEL ID DEL CLIENTE DEBE SER DE 5'
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

EXEC usp_comision_ventas '';

go


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
/*=============================DE ERRORES=======================*/
--SIN MANEJO DE ERRORES
SELECT 10/0;
--ESTO GENERA UN ERROR /EXCEPCION Y DETIENE LA EJECUCION 

BEGIN TRY 
    SELECT 10/0;
END TRY
BEGIN CATCH
PRINT 'OCRURRIO UN HORROR';
END CATCH
GO


BEGIN TRY
    SELECT 10/0;
END TRY
BEGIN CATCH
    PRINT 'MENSAJE '+ERROR_MESSAGE();
    PRINT 'NUMERO '+ CAST(ERROR_NUMBER() AS VARCHAR);
    PRINT 'LINEA '+ CAST(ERROR_LINE()AS VARCHAR);
END CATCH;
GO

CREATE TABLE Productos2(
id int PRIMARY KEY,
nombre VARCHAR (50),
precio DECIMAL (10,2)
);

--DROP Productos2
--USO CON INSERT
INSERT INTO Productos2
    VALUES(1,'PITUFO',359,9);
BEGIN TRY
    INSERT INTO Productos2
    VALUES(1,'PITUFO',359,9);
END TRY
BEGIN CATCH
    PRINT 'ERROR AL INSERTAR: '+ERROR_MESSAGE();
END CATCH ;
GO

/*================================== MANEJO DE ERRORES ===============================*/

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

/*===================================== Uso de transacciones =====================================*/

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