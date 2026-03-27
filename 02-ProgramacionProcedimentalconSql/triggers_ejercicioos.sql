CREATE DATABASE db_triggers;
go

use db_triggers;
go

 CREATE TABLE Productos(
 id INT PRIMARY KEY,
 nombre VARCHAR(50),
 precio DECIMAL(10,2)
 );
 GO
 CREATE TABLE Productos2(
 id INT PRIMARY KEY,
 nombre VARCHAR(50),
 precio DECIMAL(10,2)
 );
 go


 --EJERCICIO 1 EVENTO INSERT

 CREATE OR ALTER TRIGGER  trg_test_insert --se crea el trigger 
 ON Productos --tabla a la que se asocia el trigger
 AFTER INSERT--este es el evento que se va a disparar
 AS
 BEGIN 
	SELECT* FROM inserted;
	SELECT* FROM deleted;
	SELECT*FROM Productos;
 END;
 GO

 --EVALUAR EL TRIGGER 
 INSERT INTO Productos(id, nombre,precio)
 VALUES(1, 'wuacalao', 350.00)

 INSERT INTO Productos(id, nombre,precio)
 VALUES(2, 'azulino', 300.00)

 INSERT INTO Productos(id, nombre,precio)
 VALUES(3, 'Don Julio Rosado', 10000.00)

 INSERT INTO Productos(id, nombre,precio)
 VALUES(4, '30x30', 18.00),
 (5,'CHARANDA',5.50);

  INSERT INTO Productos(id, nombre,precio)
 VALUES(6, 'ESPINA AZUL', 67.00),
 (7,'PESIDENTE',180);

 SELECT* FROM Productos;
 go

 --EVENTO DELETED

 CREATE OR ALTER TRIGGER trg_test_delete
 ON Productos
 AFTER DELETE
 AS 
 BEGIN 
	SELECT* FROM deleted;
	SELECT * FROM inserted;
	SELECT * FROM Productos;
 END;
 GO

 DELETE FROM Productos WHERE id=1;
 GO
 --evento updte
 
 CREATE OR ALTER TRIGGER tgr_test_update
 ON Productos 
 AFTER UPDATE
 AS 
 BEGIN
	SELECT* FROM inserted;
	SELECT*FROM deleted;
 END;
 GO

 UPDATE Productos
 SET precio= 600
 WHERE id=2;
 GO

 --realizar un trigger que permita cancelar la operacion que se insertan mas de 1 registro
 --al mismo tiempo
 CREATE OR ALTER TRIGGER trg_un_solo_registro
 ON productos2
 AFTER INSERT
 AS
 BEGIN
	--CONATR EL NUMERO DE REGISTROS INSERTADOS 
	IF(SELECT COUNT(*) FROM inserted)>1
	BEGIN
		RAISERROR('SOLO SE PERMITE UN REGISTRO A LA VEZ',16,1);
		ROLLBACK TRANSACTION;
	END;
 END;
 GO

  INSERT INTO Productos2(id, nombre,precio)
 VALUES(1, '30x30', 18.00),
 (2,'CHARANDA',5.50);

 --REALIZAR UN TRIGGER QUE DETECTE UN CAMBIO EN EL PRECIO Y MANDE UN MENSAJE DE QUE ESTE SE CAMBIO
 GO

 CREATE OR ALTER TRIGGER trg_validar_cambio
 ON productos2
 AFTER UPDATE
 AS
 BEGIN 
	IF EXISTS(SELECT 1 FROM
	inserted AS ins
	INNER JOIN deleted as del
	ON ins.id=del.id
	WHERE ins.precio<>del.precio)
	BEGIN 
		PRINT('SE REALIZO UN CAMBIO EN EL PRECIO DEL PRODUCTO');
	END
 END;
 GO

 --REALIZAR UN TRIGGER QUE NO DEJE QUE CAMBIE EL PRECIO DE LA TABLA DETALLE DE VENTA 