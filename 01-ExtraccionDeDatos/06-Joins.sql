Use NORTHWND;

SELECT TOP 0 CategoryID, CategoryName
INTO categoriesnew
From Categories;

ALTER TABLE  categoriesnew
ADD CONSTRAINT pk_categories_new
PRIMARY KEY (Categoryid);


SELECT TOP 0 productid,ProductName,CategoryID
INTO productsnew
From Products;

ALTER TABLE  productsnew
ADD CONSTRAINT pk_products_new
PRIMARY KEY (productid);


ALTER TABLE productsnew
ADD CONSTRAINT fk_products_categories2
FOREIGN KEY (categoryid)
REFERENCES categoriesnew (categoryid)
ON DELETE CASCADE;

INSERT INTO categoriesnew
VALUES
('C1'),
('C2'),
('C3'),
('C4');

INSERT INTO productsnew
VALUES
('P1', 1),
('P2', 1),
('P3', 2),
('P4', 2),
('P5', 4),
('P6', NULL);





SELECT*FROM categoriesnew;

SELECT *FROM productsnew;


SELECT*
FROM categoriesnew as c
INNER JOIN 
productsnew  as p
ON p.CategoryID =c.CategoryID;


SELECT*
FROM categoriesnew as c
LEFT JOIN 
productsnew  as p
ON p.CategoryID =c.CategoryID;


SELECT*
FROM categoriesnew as c
LEFT JOIN 
productsnew  as p
ON p.CategoryID =c.CategoryID
WHERE ProductID is null;


SELECT*
FROM categoriesnew as c
RIGHT JOIN 
productsnew  as p
ON p.CategoryID =c.CategoryID;



SELECT*
FROM categoriesnew as c
RIGHT JOIN 
productsnew  as p
ON p.CategoryID =c.CategoryID
WHERE c.CategoryID is null;







SELECT
CategoryID AS[NUMERO],
CategoryName AS[NOMBRE],
[Description] as [descripcion]
FROM Categories;

SELECT  top 0 
CategoryID AS[NUMERO],
CategoryName AS[NOMBRE],
[Description] as [descripcion]
INTO categories_nuevas
From Categories;


ALTER TABLE categories_nuevas
ADD CONSTRAINT pk_categories_nuevas
PRIMARY KEY ([NUMERO]);

SELECT*
FROM Categories;


INSERT INTO Categories
VALUES ('Ropa', 'Ropa de paca',NUll),
('linea blanca', 'ropa de robin', null);


SELECT *
FROM Categories as c
LEFT JOIN categories_nuevas as cn
on c.CategoryID =cn.NUMERO;


Insert into categories_nuevas
SELECT c.CategoryName, c.Description
FROM Categories as c
LEFT JOIN categories_nuevas as cn
on c.CategoryID =cn.NUMERO
WHERE cn.NUMERO is null;


SElect * from categories_nuevas



SELECT c.CategoryName, c.Description
FROM Categories as c
LEFT JOIN categories_nuevas as cn
on c.CategoryID =cn.NUMERO
WHERE cn.NUMERO is null;


INSERT INTO Categories
VALUES ('BEBIDAs', 'bebidas corrientes',NUll),
('deports', 'balones', null);

DELETE FROM categories_nuevas;


Insert into categories_nuevas
SELECT 
UPPER(c.CategoryName) as [Categorias],
UPPER(CAST(c.Description AS Varchar)) as[Descripcion]
FROM Categories as c
LEFT JOIN categories_nuevas as cn
on c.CategoryID =cn.NUMERO
WHERE cn.NUMERO is null;

select* from categories_nuevas;



SELECT *
FROM Categories AS C
INNER JOIN categories_nuevas AS cn
on c.CategoryID= cn.NUMERO;


DELETE categories_nuevas;

--codigo para reiniciar los identitys (no se puede cuando las tablas tienen integridad referencial,
-- si no utilizar truncate) 
DBCC CHECKIDENT ('categories_nuevas', RESEED, 0);


--el truncate elimina los datos de la tabla igual que el delete
-- pero solamente funciona si no integridad referencial ,
--y ademas reinicia los identitys 
TRUNCATE TABLE categories_nueva;


--FULL JOIN 
SELECT*
FROM categoriesnew as c
FULL JOIN
productsnew as p
ON c.CategoryID=p.CategoryID;


--cross join
SELECT*
FROM categoriesnew as c
CROSS JOIN
productsnew as p;











