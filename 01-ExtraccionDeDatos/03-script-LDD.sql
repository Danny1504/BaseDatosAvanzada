-- restricciones de sql server
CREATE DATABASE restricciones;
GO

USE restricciones;
GO

CREATE TABLE clientes(
cliente_id int not null primary key, --primary key
nombre nvarchar(50) not null,
apellido_paterno nvarchar(20) not null,
apellido_materno nvarchar(20)

)
GO
INSERT INTO clientes
VALUES (1, 'PANFILO PANCRACIO', 'BAD BUNNY', 'GOOD BUNNY');

INSERT INTO clientes
VALUES (2, 'ARCADIA', 'LORENZA', '');
GO
INSERT INTO clientes
(apellido_paterno, nombre, cliente_id, apellido_materno)
VALUES ('Aguilar', 'Dulce',3 ,'Alcantara');
GO
INSERT INTO clientes
VALUES(4,'MONICO', 'BUENA VISTA', 'DEL OJO'),
(5, 'RICHARD', 'PEREJI', 'PAREDES'),
(6, 'ANGEL GUADALUPE', 'GUERRERO', 'HERNANDEZ'),
(7, 'JOSE ANGEL ETHAN', 'DANIELO', 'LINUXCEN')

GO
SELECT*FROM clientes;
GO

CREATE TABLE clientes_2(
cliente_id int not null identity(1,1),
nombre nvarchar (50) not null,
edad int not null
CONSTRAINT pk_clientes_2
PRIMARY KEY(cliente_id)
);
GO

CREATE TABLE pedidos(
pedidos_id int not null identity (1,1),
fecha_pedido date not null,
cliente_id int,
CONSTRAINT pk_pedidos
PRIMARY KEY (pedidos_id),
CONSTRAINT fk_clientes_2
FOREIGN KEY (cliente_id)
REFERENCES clientes_2(cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION 
);

drop table pedidos;
drop table pedidos

INSERT INTO clientes_2
Values
('chicharrones pork',34);

select*from clientes_2

select getdate()

INSERT INTO pedidos
values(getdate(),1),
('2026-01-19',1),
('2026-04-06',4),
('2026-12-12', NULL);

SELECT*FROM clientes_2;

select*from pedidos;


GO
--eliminacion DELETE NO ACTION 

--eliminar a los hijos 
DELETE pedidos 
where pedidos_id=6;
--eliminar al padre
DELETE FROM clientes_2 where cliente_id=4;


--update no action 
CREATE TABLE pedidos(
pedidos_id int not null,
fecha_pedido date not null,
cliente_id int,
CONSTRAINT pk_pedidos
PRIMARY KEY (pedidos_id),
CONSTRAINT fk_clientes_2
FOREIGN KEY (cliente_id)
REFERENCES clientes_2(cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION 
);


INSERT INTO pedidos
values(1,getdate(),1),
(2,'2026-01-19',1),
(3,'2026-04-06',2),
(4,'2026-12-12', 2);


UPDATE clientes_2
SET cliente_id=3
WHERE cliente_id=2;




--delete y update set null 

CREATE TABLE proveedor(
proveedor_id int not null,
nombre nvarchar (60)not null,
tipo nchar(1)not null,
limite_credito money not null,
CONSTRAINT pk_proveedor
PRIMARY KEY (proveedor_id),
CONSTRAINT unique_nombre
UNIQUE(nombre),
CONSTRAINT chk_tipo
CHECK (tipo in('g','s','b')),
CONSTRAINT chk_limite_credito
CHECK(limite_credito between 0 and 30000)
);
GO

CREATE TABLE productos(
producto_id int not null identity(1,1),
nombre nvarchar (50)not null,
precio money not null,
stock_maximo int not null,
stock_minimo int not null,
cantidad int not null,
proveedor_id int,
CONSTRAINT pk_productos
PRIMARY KEY (producto_id),
CONSTRAINT unique_nombre_pr
UNIQUE (nombre),
CONSTRAINT chk_stock_maximo
CHECK(stock_maximo>=5 and stock_maximo<=400),
CONSTRAINT chk_stock_minimo
CHECK (stock_minimo >=1 and stock_minimo < stock_maximo),
CONSTRAINT chk_cantidad_pr
CHECK(cantidad >0),
CONSTRAINT fk_productos_proveedor
FOREIGN KEY (proveedor_id)
REFERENCES proveedor(proveedor_id)
ON DELETE SET NULL
ON UPDATE SET NULL
);
GO


--delete y update set default 


--delete y update cascade

-- restriccion chekc

--restriccion unique 


