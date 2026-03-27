# INVESTIGACIÓN COMPLETA: TRANSACT-SQL EN SQL SERVER

## Introducción

Transact-SQL (T-SQL) es la extensión propietaria de SQL desarrollada por
Microsoft para SQL Server. Amplía el lenguaje SQL estándar incorporando
programación estructurada, control de flujo, manejo de errores,
transacciones y creación de objetos programables como procedimientos,
funciones y triggers.

------------------------------------------------------------------------

# 1. Variables en Transact-SQL

Las variables permiten almacenar datos temporalmente durante la
ejecución de un bloque de código. Son fundamentales cuando se necesita
realizar cálculos, almacenar resultados intermedios o controlar flujo
lógico.

## Declaración

Se declaran con la palabra clave DECLARE y deben iniciar con @.

``` sql
DECLARE @Edad INT;
DECLARE @Nombre NVARCHAR(50);
```

## Asignación

Se pueden asignar valores usando SET o SELECT.

``` sql
SET @Edad = 25;
SELECT @Nombre = 'Daniel';
```

-   SET asigna un solo valor.
-   SELECT puede asignar múltiples valores provenientes de una consulta.

## Alcance (Scope)

Las variables solo existen dentro del bloque donde fueron declaradas. No
pueden utilizarse fuera del procedimiento o bloque BEGIN...END donde
fueron creadas.

------------------------------------------------------------------------

# 2. Tipos de Datos en SQL Server

Los tipos de datos determinan qué tipo de información puede almacenarse
y cuánto espacio ocupa en memoria.

## 2.1 Tipos Numéricos

### INT

Almacena números enteros sin decimales. Rango: -2,147,483,648 a
2,147,483,647. Uso común: IDs, contadores, cantidades.

### BIGINT

Similar a INT pero permite números mucho más grandes.

### DECIMAL(p,s)

Almacena números exactos con precisión. - p = precisión total de
dígitos - s = cantidad de decimales Ideal para cálculos financieros
donde se requiere exactitud.

Ejemplo:

``` sql
DECLARE @Precio DECIMAL(10,2);
```

### FLOAT

Almacena números aproximados. Se usa en cálculos científicos donde
pequeños errores de precisión son aceptables.

### MONEY

Diseñado para almacenar valores monetarios. Internamente maneja cuatro
decimales.

------------------------------------------------------------------------

## 2.2 Tipos de Cadena

### CHAR(n)

Longitud fija. Siempre ocupa exactamente n caracteres. Si se almacenan
menos caracteres, se rellenan con espacios.

### VARCHAR(n)

Longitud variable. Solo ocupa el espacio necesario. Es más eficiente que
CHAR cuando los textos varían en tamaño.

### NVARCHAR(n)

Soporta Unicode. Permite almacenar caracteres especiales e idiomas
diferentes.

Ejemplo:

``` sql
DECLARE @Texto NVARCHAR(100);
```

------------------------------------------------------------------------

## 2.3 Tipos de Fecha y Hora

### DATE

Solo almacena fecha (año, mes, día).

### TIME

Solo almacena hora.

### DATETIME

Almacena fecha y hora con precisión de milisegundos.

### DATETIME2

Versión mejorada de DATETIME con mayor precisión y rango.

Ejemplo:

``` sql
DECLARE @Fecha DATETIME = GETDATE();
```

GETDATE() devuelve la fecha y hora actual del servidor.

------------------------------------------------------------------------

## 2.4 Tipo BIT

Representa valores booleanos. - 0 = Falso - 1 = Verdadero - NULL =
Desconocido

Se usa comúnmente en campos como Activo, Eliminado, etc.

------------------------------------------------------------------------

# 3. Operadores

Los operadores permiten realizar operaciones matemáticas y lógicas.

## 3.1 Operadores Aritméticos

-   Suma\
-   Resta\
-   Multiplicación\
    / División\
    % Módulo

Se usan en cálculos dentro de consultas y procedimientos.

------------------------------------------------------------------------

## 3.2 Operadores Relacionales

= Igual\
\<\> Diferente\
\> Mayor que\
\< Menor que\
\>= Mayor o igual\
\<= Menor o igual

Se utilizan en cláusulas WHERE para filtrar datos.

------------------------------------------------------------------------

## 3.3 Operadores Lógicos

AND Ambas condiciones deben cumplirse\
OR Al menos una condición debe cumplirse\
NOT Niega la condición\
BETWEEN Rango de valores\
IN Lista de valores\
LIKE Búsqueda por patrón\
IS NULL Verifica valores nulos

------------------------------------------------------------------------

# 4. Estructuras de Control

Permiten controlar la ejecución del código.

## IF...ELSE

Permite ejecutar código según una condición.

``` sql
IF @Edad >= 18
    PRINT 'Mayor de edad';
ELSE
    PRINT 'Menor de edad';
```

------------------------------------------------------------------------

## WHILE

Permite repetir un bloque mientras se cumpla una condición.

``` sql
DECLARE @Contador INT = 1;

WHILE @Contador <= 5
BEGIN
    PRINT @Contador;
    SET @Contador += 1;
END
```

------------------------------------------------------------------------

## BREAK y CONTINUE

BREAK finaliza el ciclo. CONTINUE salta a la siguiente iteración.

------------------------------------------------------------------------

# 5. Manejo de Excepciones

SQL Server utiliza TRY...CATCH para manejar errores en tiempo de
ejecución.

``` sql
BEGIN TRY
    SELECT 10/0;
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH
```

Funciones importantes:

ERROR_NUMBER() → Número del error\
ERROR_MESSAGE() → Descripción del error\
ERROR_LINE() → Línea donde ocurrió\
ERROR_PROCEDURE() → Procedimiento donde ocurrió

------------------------------------------------------------------------

# 6. Transacciones

Una transacción es un conjunto de instrucciones que se ejecutan como una
unidad indivisible.

Propiedades ACID:

Atomicidad → Todo o nada\
Consistencia → Mantiene reglas del sistema\
Aislamiento → No interfiere con otras transacciones\
Durabilidad → Cambios permanentes tras COMMIT

Ejemplo:

``` sql
BEGIN TRANSACTION;

UPDATE Cuentas
SET Saldo = Saldo - 100
WHERE Id = 1;

COMMIT;
```

Si ocurre error:

``` sql
ROLLBACK;
```

------------------------------------------------------------------------

# 7. Funciones Definidas por el Usuario

Permiten reutilizar lógica personalizada.

## Función Escalar

Devuelve un solo valor.

``` sql
CREATE FUNCTION dbo.CalcularIVA (@Precio DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Precio * 0.16;
END;
```

## Función Tipo Tabla

Devuelve un conjunto de resultados.

------------------------------------------------------------------------

# 8. Stored Procedures

Bloques de código almacenados en la base de datos que pueden recibir
parámetros.

Ventajas: - Mejor rendimiento - Seguridad - Reutilización

------------------------------------------------------------------------

# 9. Triggers

Se ejecutan automáticamente cuando ocurre un evento (INSERT, UPDATE,
DELETE).

Se utilizan para auditoría, validación o reglas automáticas.

------------------------------------------------------------------------

# 10. Funciones Integradas

## Funciones de Cadena

Manipulan texto: convertir mayúsculas, extraer partes, reemplazar
caracteres.

## Funciones de Fecha

Permiten sumar días, calcular diferencias entre fechas y extraer año o
mes.

## Funciones de Valores Nulos

ISNULL reemplaza NULL. COALESCE devuelve el primer valor no nulo. NULLIF
devuelve NULL si dos valores son iguales.

## FORMAT

Permite dar formato personalizado a fechas y números.

## CASE

Permite lógica condicional dentro de una consulta.

------------------------------------------------------------------------

# Conclusión

Transact-SQL amplía el SQL tradicional incorporando programación
estructurada, manejo de errores y control transaccional, lo que permite
desarrollar sistemas empresariales robustos, seguros y eficientes en SQL
Server.
