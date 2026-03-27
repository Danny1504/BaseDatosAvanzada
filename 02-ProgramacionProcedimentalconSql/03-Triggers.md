# TRIGGER (Disparador)

## ¿Que es un trigger?

es un bloque de codigo que se ejecuta automaticamente cuanbdo ocurre un evento en una tabla 

😶‍🌫️-- Eventos principales 

- INSERT
- UPDATE 
- DELETE

🥶 No se ejecutan manualmente, se activan solos.
## 🤬 ¿PARA QUE SIRVEN?

- Validaciones
- Auditoria (guardar un historial de algo)
- Reglas de Negocio
- Automatizacion 


## 👹 TIPOS DE TRIGGERS EN SQL SERVER

- AFTER TRIGGER

Este se ejecuta despues del evento

-INSTEAD OF 

Reemplaza la operacion original

## 🐶 Sintaxis Basica 
```sql
CREATE TRIGGER nombre_trigger
On nombre_tabla
AFTER INSERT
AS
BEGIN
--Codigo 
END;
```


## TABLAS ESPECIALES🐶
|TABLA|CONTENIDO|
 |:---|:---|
 |INSERTED|NUEVOS DATOS|
 |DELETED|DATOS ANTERIORES|
 
 