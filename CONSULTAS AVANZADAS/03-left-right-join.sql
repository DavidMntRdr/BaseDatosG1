create database pruebajoins;

use pruebajoins;

create table proveedor(
    provid int not null IDENTITY(1,1),
    nombre varchar(50) not null,
    limite_credito money not NULL
    constraint pk_proveedor
    primary key (provid),
    constraint unico_nombre
    UNIQUE(nombre)
);

create table productos(
    productid int not null IDENTITY(1,1),
    nombre varchar(50) not NULL,
    precio money not NULL,
    existencia int not null,
    proveedor int,
    constraint pk_producto
    PRIMARY key(productid),
    constraint unico_nombre_proveedor
    UNIQUE (nombre),
    constraint fk_proveedor_producto
    FOREIGN key (proveedor)
    REFERENCES proveedor(provid)
);


--Agregar registros a las tablas proveedor y productos 

insert into proveedor (nombre, limite_credito)
VALUES ('proveedor1', 5000), 
('proveedor2', 5380),
('proveedor3', 7745),
('proveedor4', 6452),
('proveedor5', 5589);

select * from proveedor;

insert into productos (nombre, precio, existencia, proveedor)
values ('Producto1', 56, 34, 1),
('Producto2', 56.56, 12, 1),
('Producto3', 45.6, 33, 2),
('Producto4', 22.34, 666, 3);

select * from productos;

select * from 
proveedor as p
inner join productos as pr
on pr.proveedor = p.provid

select s.CompanyName, sum(od.UnitPrice * od.Quantity) as 'Total'    
from (select CompanyName, SupplierID from Suppliers) as s
INNER JOIN (
    select productid, SupplierID from products  
    ) as p
on s.SupplierID = p.SupplierID
INNER JOIN (
    select orderid, ProductID, unitprice, quantity from [Order Details] 
    ) as od
on od.ProductID = p.ProductID
INNER JOIN (
    select orderid, orderdate from Orders) as O
ON O.OrderID = od.OrderID
WHERE o.OrderDate BETWEEN '1996-09-01' AND '1996-12-31'
GROUP by s.CompanyName
ORDER By 'Total' desc;

use NORtwin

select c.categoryname, p.ProductName, p.unitsinstock, p.unitprice, p.discontinued
from (select categoryname, categoryid from categories) as c
inner JOIN (
    select ProductName, unitsinstock, categoryid, unitprice, discontinued from products
) as p
on c.categoryid = p.CategoryID;

--Left join 

select p.provid, p.nombre from proveedor as p 
left join productos as pr 
on pr.proveedor = p.provid
where pr.productid IS null;

use NORTHWND;
select * from Employees