CREATE DATABASE bdsubqueries;

USE bdsubqueries;

CREATE TABLE clientes(
id_cliente int identity(1,1) primary key not null,
nombre varchar(50)not null,
ciudad varchar (50) not null
);
GO

CREATE TABLE pedidos(
id_pedido int identity (1,1) primary key not null,
id_cliente int not null,
total money not null,
fecha date not null,
constraint fk_pedidos_clientes
FOREIGN KEY (id_cliente) REFERENCES 
clientes(id_cliente)
ON DELETE CASCADE
);
GO


INSERT INTO clientes (nombre, ciudad) VALUES
('Ana', 'CDMX'),
('Luis', 'Guadalajara'),
('Marta', 'CDMX'),
('Pedro', 'Monterrey'),
('Sofia', 'Puebla'),
('Carlos', 'CDMX'), 
('Artemio', 'Pachuca'), 
('Roberto', 'Veracruz');

INSERT INTO pedidos (id_cliente, total, fecha) VALUES
(1, 1000.00, '2024-01-10'),
(1, 500.00,  '2024-02-10'),
(2, 300.00,  '2024-01-05'),
(3, 1500.00, '2024-03-01'),
(3, 700.00,  '2024-03-15'),
(1, 1200.00, '2024-04-01'),
(2, 800.00,  '2024-02-20'),
(3, 400.00,  '2024-04-10');

select * from clientes;
select *from pedidos;


--subconsulta
SELECT 
MAX(total)
from pedidos;

--consulta principal
select*from pedidos
where total= (SELECT 
MAX(total)
from pedidos);

--seleccionar el cliente que hixo el pedido mas caro
SELECT* FROM pedidos
ORDER BY total desc;
--sucbonsulta
SELECT id_cliente 
FROM pedidos
WHERE total =(SELECT MAX(total) FROM pedidos);
--consulta principal
SELECT top 1* FROM pedidos
where id_cliente=(SELECT id_cliente 
FROM pedidos
WHERE total =(SELECT MAX(total) FROM pedidos))
;


SELECT p.id_pedido,c.nombre,p.total 
from  pedidos as p
INNER JOIN 
clientes as c
ON p.id_cliente= c.id_cliente
where p.id_cliente =(SELECT id_cliente 
FROM pedidos
WHERE total =(SELECT MAX(total) FROM pedidos))
;


--selecionar los pedidos mayores al promedio

--subconsulta
SELECT AVG(total)
FROM pedidos;
--consulta
SELECT* FROM pedidos
where total>(SELECT AVG(total)
FROM pedidos);

--mostrar cliente con menor id

SELECT MIN(id_cliente) 
from pedidos;

SELECT p.fecha,p.id_cliente,p.id_pedido, p.total from  pedidos as p
INNER JOIN clientes as c
ON P.id_cliente= C.id_cliente
where p.id_cliente=(SELECT MIN(id_cliente) 
from pedidos);


--mostrar el utlimo pedido realizado
SELECt MAX(fecha)
from pedidos;

SELECT p.fecha,c.nombre,p.id_cliente,c.ciudad, p.total FROM pedidos as p
INNER JOIN clientes as c
ON p.id_cliente= c.id_cliente
where fecha =(SELECt MAX(fecha)
from pedidos)
;


--mostrar pedido con el total mas bajo
select min(total) from pedidos;

select *from pedidos
where total =(select min(total) from pedidos);

--seleccionar los peddios con el nombre del cliente cuyo total (freight)
--sea mayor al promedio de freight 

SELECT AVG(Freight)FROM orders;


SELECT o.orderid, c.companyName, o.Freight
FROM orders as o
INNER JOIN customers as c
ON o.customerid= c.customerId
where o.Freight >(SELECT AVG(Freight)FROM orders)
ORDER BY Freight DESC;


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


--INSTRUCCION ANY
--seleccionar todos los pedidos con un total mayor de algun pedido de luis 
SELECT total
FROM pedidos
WHERE id_cliente = 2 ;

select*from clientes


SELECT*
FROM pedidos 
where total> Any(SELECT total
FROM pedidos
WHERE id_cliente = 2);

--seleccionar todos los pedidos en donde el total sea mayor a algun pedido de ana 
SELECT total 
from pedidos
WHERE id_cliente=1;

SELECT*
FROM pedidos
WHERE total>ANY(SELECT total 
from pedidos
WHERE id_cliente=1);