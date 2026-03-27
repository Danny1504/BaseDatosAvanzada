# subqueries (subcosnultas)

una subconsulta es una consulta anidada dentro de otra consulta que pertmite 
resolver problemas en varios niveles de informacion.

dependiendo de donde se coloque y retorne, cambia su comportamiento

**CLASIFICACION**

1. subconsultas escalares
2. sub consultas de in, any, all
3. subconsultas correlacionadas
4. subconsultas en select
5. subconsultas en from(tablas derivadas)

## ESCALARES 
Devuelve un unico valor, se pueden utilizar operadcores con =,>,<

ejemplo:
```sql
--consulta principal
select*from pedidos
where total= (SELECT 
MAX(total)
from pedidos);
```

orden de ejecucion:
1. se ejecuta la sub consulta
2. devuelve 1500
3. la consulta toma ese valor 


## SUBCONSULTAS DE UNA COLUMNA (IN, ANY, ALL)
 esta subconsulta devuelve varios valores pero una sola columna 


 ejemplo:
 1. clientes que han echo pedidos
 ```SQL
 select * from clientes
where id_cliente IN(
SELECT id_cliente
FROM pedidos);


--clientes que han echo pedidos 
--subconsulta 
SELECT id_cliente FROM pedidos;

select * from clientes
where id_cliente IN(
SELECT id_cliente
FROM pedidos);


select DISTINCT c.id_cliente,c.nombre,c.ciudad 
from clientes as c
INNER JOIN pedidos as p
ON c.id_cliente= p.id_cliente;

--selecionar cliemtes de cdmx que an echo pedido

SELECT id_cliente
FROM clientes;

SELECT*
FROM clientes
WHERE ciudad= 'CDMX' AND 
id_cliente IN (SELECT id_cliente
FROM clientes);

--seleccionar los pedidos de los clientes que viven en la cdmx
--subconsulta
SELECT id_cliente
FROM clientes
WHERE ciudad = 'CDMX'; 

--consulta principal
SELECT p.id_cliente,c.ciudad, p.fecha, c.nombre, p.total
FROM pedidos AS p
INNER JOIN clientes AS c 
ON p.id_cliente=c.id_cliente
WHERE p.id_cliente IN (SELECT id_cliente
FROM clientes
WHERE ciudad = 'CDMX');

--seleccionar todos aquellos clientes que no han echo pedidos 
SELECT id_cliente
FROM pedidos;


SELECT*
FROM clientes 
WHERE id_cliente NOT IN (
SELECT id_cliente
FROM pedidos
);

SELECT DISTINCT p.id_cliente, c.nombre,c.ciudad
FROM clientes c
INNER JOIN pedidos p
ON c.id_cliente=p.id_cliente;


SELECT DISTINCT c.id_cliente, c.nombre,c.ciudad
FROM clientes c
LEFT JOIN pedidos p
ON c.id_cliente=p.id_cliente
WHERE p.id_cliente IS NULL;
```
***INSTRUCCION ANY***
>compara un valor de una **lista**,la condicion se cumple
si almenos uno se cumple
```sql
valor> ANY(subcosnulta)
```
Es como decir:
"mayor que alguno de los valores"

