# FUNDAMENTOS PROGRAMABLES 
1. ¿Que es la parte programable de T-SQL?

Es todo lo que permite:

-usar variables
-Control de flujo
-Crear procedimientos almacenados( Store procedures)
-Manejar errores
-Crear funciones
-usar transacciones
-disparadores (Triggers)


Nota:
Es convertir SQL es un lenguaje casi como c, c++ o java pero dentro del egine 

2. Variables
Una variable almacena un valor temporal 
Permite ejecutar codigo segun una condicion

```sql
/*==================================VARIABLES=============================================**/
--variables 
DECLARE @Edad INT
SET @Edad =42

SELECT @Edad AS EdadActual
PRINT CONCAT ('La edad es: ', ' ',@Edad)
/*================================EJERCICIOS CON VARIABLES=================================================*/
/*1. declarar una variable llamad precio
2.- asignarle el valor de 150
3.- calcular el iva del 16%
4.- mostrar el total */ 

--Se le asigna un valor incial a la variable
DECLARE @Precio MONEY = 150
DECLARE @Total MONEY
SET @Total = @Precio *1.16

SELECT @Total AS PrecioTotal

```
3. IF/ELSE
```SQL
/*===================== EJERICIO DE IF/ELSE========================*/
/*
1. Crear una variable calificacion 
2. Evaluar si es mayor a 70 Imprimir "Aprobado", si no "Reprobado"
*/

DECLARE @Calificacion DECIMAL(10,2)
SET @Calificacion =9.8

IF @Calificacion>=7
BEGIN 
PRINT'APROBASTE'
PRINT 'FELICIDADES'
END
ELSE
BEGIN
PRINT'REPROBASTE'
PRINT'ECHALE MAS GANAS'
END


```

4. WHILE 
 ```sql
 /*===========================WHILE==================================*/

DECLARE @contador INT;
DECLARE @contador2 INT =1;
SET @contador= 1;
SET @contador2 =3;

WHILE @contador <=5
BEGIN 
     WHILE @contador2 <=5
     BEGIN 
     PRINT CONCAT(@contador, '-',@contador2);
     SET @contador2=@contador2 + 1;
     End;
SET @contador2 = 1;
SET @contador=@contador+1;
End;
GO


--imprime los numeros del 10 al 1
DECLARE @contador Int =1;
SET @contador=10;

WHILE @contador >=1
BEGIN
   PRINT @contador;
   SET @contador= @contador-1;
End;
GO

 ```

 ## Procedimientos almacendados (Store procedures)
 5. 👌😁¿Que es un store procedure?
 🥓Es un bloque de codigo guardado en una base de datos que se puede ejecutar cuando quieras 
 o cuando se necesite 

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
 ```sql
/*==============================STORES PROCEDURES===============================*/
CREATE OR ALTER PROCEDURE  usp_mensaje_saludar
AS
BEGIN 
PRINT'HOLA MUNDO';
END;



--ELIMINAR UN SP
--DROP PROC usp_mensaje_saludar;
--formna de ejecutar 
EXECUTE usp_mensaje_saludar;
GO

EXEC  usp_mensaje_saludar;
GO
--EJERCICIO
--crea un store procedure que imprima la fecha actual 
CREATE OR ALTER PROC usp_fecha_actual
AS
Begin
SELECT getdate() AS FECHA;
END
GO
EXEC usp_fecha_actual;
GO
--Crear un store procedure que muestre el nombre de la base de datos actual
CREATE OR ALTER PROCEDURE  usp_mostrar_databaseName
AS
BEGIN 
SELECT DB_NAME() AS [Nombre de la base de datos];
END;
GO
EXEC usp_mostrar_databaseName;
GO
 ```

