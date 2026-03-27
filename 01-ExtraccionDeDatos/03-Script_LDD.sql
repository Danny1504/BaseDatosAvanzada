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
CONSTRAINT fk_clientes
FOREIGN KEY (cliente_id)
REFERENCES clientes(cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION 
);