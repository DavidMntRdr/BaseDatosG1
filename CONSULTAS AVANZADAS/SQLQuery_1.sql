use NORTHWND;

--Lenguaje SQL-LMD
--Seleccionar todos los productos
select * from Products;

--Seleccionar todas las categorías
select * from Categories;

--Seleccionar los proveedores
select * FROM Suppliers;

--Seleccionar los clientes
select * from Customers;

--Seleccionar los empleados
select*from Employees;

--Seleccionar todas las paqueterías
select*from Shippers;

--Seleccionar todas las órdenes de compra
select*from Orders;

--Seleccionar todos los detalles de órdenes
select * from [Order Details];

--Consultas simples 

--Proyección
select ProductID, ProductName, UnitsInStock, UnitPrice 
from Products

--Alias de columna 
select ProductID AS NumeroProducto, ProductName AS 'Nombre Producto', UnitsInStock AS Existencias, UnitPrice 'AS Precio'
from Products

--Alias de tablas
select Products.ProductID AS NumeroProducto, Products.ProductName AS 'Nombre Producto', Products.UnitsInStock AS Existencias, Products.UnitPrice 'AS Precio'
from Products

select * from Products, Categories
where Categories.CategoryID=Products.CategoryID

select * from
Products as p, Categories as c 
where p.CategoryID = c.CategoryID

--campo calculado
--Seleccionar todos los productos mostrando el id del producto,
--el nombre del producto, la existencia, el precio y el importe

select *, (UnitPrice * UnitsInStock) AS 'Importe' from Products;

select ProductID AS 'Numero Producto', 
ProductName AS 'Nombre Producto', 
UnitsInStock AS 'Existencias', 
UnitPrice AS 'Precio', 
(UnitPrice * UnitsInStock) AS 'Importe' 
from Products;

-- Seleccionar las primeras 10 órdenes
select top 10 *from Orders;

-- Seleccionar todos los clientes ordenados de forma ascendente por el país
select CustomerID as 'Numero de cliente',
CompanyName as 'Nombre del cliente', 
[Address] as 'Dirección', 
City as 'Ciudad', 
Country as 'País' 
from Customers
order by Country;

select CustomerID as 'Numero de cliente',
CompanyName as 'Nombre del cliente', 
[Address] as 'Dirección', 
City as 'Ciudad', 
Country as 'País' 
from Customers
order by Country ASC;

select CustomerID as 'Numero de cliente',
CompanyName as 'Nombre del cliente', 
[Address] as 'Dirección', 
City as 'Ciudad', 
Country as 'País' 
from Customers
order by 5 ASC;

select CustomerID as 'Numero de cliente',
CompanyName as 'Nombre del cliente', 
[Address] as 'Dirección', 
City as 'Ciudad', 
Country as 'País' 
from Customers
order by 'País' ASC;

-- Seleccionar todos los clientes ordenados de forma descendiente por el país

select CustomerID as 'Numero de cliente',
CompanyName as 'Nombre del cliente', 
[Address] as 'Dirección', 
City as 'Ciudad', 
Country as 'País' 
from Customers
order by Country DESC;

select CustomerID as 'Numero de cliente',
CompanyName as 'Nombre del cliente', 
[Address] as 'Dirección', 
City as 'Ciudad', 
Country as 'País' 
from Customers
order by 5 DESC;

select CustomerID as 'Numero de cliente',
CompanyName as 'Nombre del cliente', 
[Address] as 'Dirección', 
City as 'Ciudad', 
Country as 'País' 
from Customers
order by 'País' DESC;

--Seleccionar todos los clientes ordenando dos columnas 
--diferentes de forma ascendente, descendente o combinado.
select CustomerID, CompanyName, Country, City
from Customers
order by Country, City ASC;

select CustomerID, CompanyName, Country, City
from Customers
order by Country, City DESC;

select CustomerID, CompanyName, Country, City
from Customers
order by Country ASC, City ASC;

select *
from Customers
order by Country DESC, City ASC;

select *
from Customers
order by Country ASC, City DESC;

select *
from Customers
order by Country DESC, City DESC;

--Operadores relacionales
--(<,>, <=, >=, ==, <> ó !=)

--Seleccionar los países a los cuáles se les ha enviado las órdenes.
select distinct ShipCountry from Orders 
order by 1

--Seleccionar todas las órdenes enviadas a francia.
Select * from Orders
where ShipCountry = 'France';

--Seleccionar todas las órdenes realizadas a francia, mostrando 
--El número de orden, cliente al que se envió, empleado que la realizó,
--el país al que se envió, la ciudad a la que se envió.
select OrderID as 'Número de orden',
CustomerID as 'Ciente', 
EmployeeID 'Empleado', 
ShipCountry 'País de envío', 
ShipCity 'Ciudad de envío' 
from Orders
where ShipCountry = 'France';

--Seleccionar las órdenes en donde no se ha asignado una región de envío
select OrderID as 'Número de orden',
CustomerID as 'Ciente', 
EmployeeID 'Empleado', 
ShipCountry 'País de envío', 
ShipCity 'Ciudad de envío',
ShipRegion 'Región de envío'
from Orders
where ShipRegion IS null;

--Seleccionar ordenes en donde se ha asignado una región de envío
select OrderID as 'Número de orden',
CustomerID as 'Ciente', 
EmployeeID 'Empleado', 
ShipCountry 'País de envío', 
ShipCity 'Ciudad de envío',
ShipRegion 'Región de envío'
from Orders
where ShipRegion IS NOT null;

--Seleccionar los productos con un precio mayor a 50 dólares

select * from Products
where UnitPrice > 50

--Seleccionar los empleados contratados después del primero de enero 1990
select * from Employees
where HireDate > '1990-01-01'

select GETDATE()
--Seleccionar los clientes donde el país sea Alemania
select * from Customers
where Country > 'Germany'

--Mostrar los productos con una cantidad menor o igual a 100
select * from Products
where UnitsInStock <= 100.00

--Seleccionar todas las ordenes realizadas antes del primero de enero 1998
select * from Orders
where OrderDate < '1998-01-01'

--Seleccionar todas las órdenes realizadas por el empleado fuller
select * from Orders
where EmployeeID = '2'

--Seleccionar todas las órdenes mostrando el número de orden, el cliente
-- y la fecha de orden dividida en año, mes y día

select OrderID, CustomerID, OrderDate, 
Year(OrderDate) as 'Año',
MONTH(OrderDate) as 'Mes',
DAY(OrderDate) as 'Día'  from Orders

-- Operadores lógicos 
--And, or, not 

--Seleccionar los productos con un precio mayor a 50 y con una cantidad menor o igual a 100
select * from Products
where UnitPrice > 50 AND UnitsInStock <= 100;

--Seleccionar todas las ordenes para francia y alemania 
select * from Orders
where ShipCountry in ('France', 'Germany')

select * from Orders
where ShipCountry = 'France' OR ShipCountry= 'Germany'

--Seleccionar todas las ordenes para francia, méxico y alemania 
select * from Orders
where ShipCountry in ('France', 'Germany', 'Mexico')
order by ShipCountry Desc


--Seleccionar todas las órdenes que fueron emitidas por los 
--empleados Nancy Davolio, Annie Bodsworth y Andrew Filler

select * from Orders
where EmployeeID = 1
or EmployeeID = 9
or EmployeeID = 2;

select * from Orders
where EmployeeID in (1,9,2);

--seleccionar todas las órdenes dividiendo la fecha de órden en año, mes y día
select OrderDate as'Fecha de orden', 
YEAR (OrderDate) as 'Año',
MONTH(OrderDate) as 'Mes',
DAY(OrderDate) as 'Día'
from Orders
--Seleccionar todos los nombres de los empleados
select CONCAT(FirstName, ' ', LastName) as 'Nombre completo' from Employees;


--Seleccionar todos los productos donde la existencia sea mayor o igual a 40
--y el precio sea menor a 19

select ProductName as 'Nombre del producto',
UnitPrice as 'Precio',
UnitsInStock as 'Existencias' 
from Products
where UnitPrice < 19 AND UnitsInStock >= 40;

--seleccionar todas las órdenes realizadas de abril a agosto de 1996

select * from Orders
where OrderDate >='1996-04-01' and OrderDate<= '1996-08-31'

select OrderID, EmployeeID, OrderDate
from Orders 
where OrderDate BETWEEN '1996-04-01' and '1996-08-31'

--seleccionar todas las ordenes entre 1996 y 1998
select * from Orders
where year (OrderDate) BETWEEN '1996' and '1998'

--seleccionar todas las ordenes de 1996 y 1999
select * from 
Orders 
where year(OrderDate) in ('1996', '1999')

--seleccionar todos los productos que comiencen con c
select * FROM 
Products
where ProductName like 'c%';

--seleccionar todos los productos que terminen con s

select * FROM 
Products
where ProductName like 's%';

--seleccionar todos los productos que el nomrbe del producto que contenga la palabra NO.

select * 
FROM 
Products
where ProductName like '%no%';

--seleccionar todos los productos que contengan las letras a o n

select * FROM 
Products 
where ProductName like '$[AN]%';

select * FROM 
Products 
where ProductName like '$[AN]%'
or ProductName like '%N%';


--Seleccionar todos los productos que comiencen entre la letra A y la letra N

select * FROM 
Products 
where ProductName like '[A-N]%';



--Crear base de datos
create database pruebaxyz;
--utilizar base de datos
use pruebaxyz;

--crear una tabla a partir de una consulta con 0 registros
select top 0 * 
into pruebaxyz.dbo.products2
from NORTHWND.dbo.Products;

select* from products2;

--Agrega un constraint a la tabla products2.
alter table products2
add constraint pk_products2 
primary key(productid)

alter table products2
drop constraint pk_products2

--Llenar una tabla a partir de una consulta.
insert into pruebaxyz.dbo.products2(ProductName, SupplierID, CategoryID,
QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
select ProductName, SupplierID, CategoryID,
QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued
from NORTHWND.dbo.Products;


use NORTHWND

-- Ejercicio 1: Obtener el nombre del cliente y el nombre del empleado
-- del representante de ventas de cada pedido.
--Nombre del cliente (Customers) 
--Nombre del empleado (Employees)
--Representante de ventas (Orders)

select o.CustomerID, o.Employeeid, o.orderid 
from  
orders as o;

SELECT c.CompanyName as 'Nombre del cliente', 
concat (e.FirstName, e.LastName) as 'Nombre del empleado',
o.OrderID, o.OrderDate, (od.Quantity * od.UnitPrice) as 'Importe'
from Customers as c
INNER JOIN
Orders as o
ON o.CustomerID = c.CustomerID
INNER JOIN Employees as e
on o.EmployeeID = e.EmployeeID
INNER JOIN 
[Order DEtails] as od
On od.OrderID = o.OrderID
--where year(OrderDate) in ('1996', '1998')
where year (OrderDate) = '1996' OR
year (OrderDate) = '1998';


--Seleccionar cuantas ordenes se han realizado de 1996 y 1998
SELECT count(*) as 'TotalOrdenes'
from Customers as c
INNER JOIN
Orders as o
ON o.CustomerID = c.CustomerID
INNER JOIN Employees as e
on o.EmployeeID = e.EmployeeID
INNER JOIN 
[Order DEtails] as od
On od.OrderID = o.OrderID
--where year(OrderDate) in ('1996', '1998')
where year (OrderDate) = '1996' OR
year (OrderDate) = '1998';


--Ejercicio 2: Mostrar el nombre del producto, el nombre del proveedor 
--y el precio unitario de cada producto.
SELECT c.ProductName as 'Nombre del Producto', 
o.CompanyName as 'Nombre del proveedor',
c.UnitPrice as 'Precio'
from Products as c
INNER JOIN
Suppliers as o
ON c.SupplierID = o.SupplierID

--Ejercicio 3: Listar el nombre del cliente, el ID del pedido y 
--la fecha del pedido para cada pedido.
SELECT c.OrderID as 'ID del pedido', 
o.CompanyName as 'Nombre del cliente',
c.OrderDate as 'Fecha del pedido'
from Orders as c
INNER JOIN
Customers as o
ON c.CustomerID = o.CustomerID

--Ejercicio 4: Obtener el nombre del empleado, el título del cargo 
--y el departamento del empleado para cada empleado.


--Ejercicio 5: Mostrar el nombre del proveedor, el nombre del contacto y el teléfono del contacto para cada proveedor.
--Ejercicio 6: Listar el nombre del producto, la categoría del producto y el nombre del proveedor para cada producto.
--Ejercicio 7: Obtener el nombre del cliente, el ID del pedido, el nombre del producto y la cantidad del producto para cada detalle del pedido.
--Ejercicio 8: Obtener el nombre del empleado, el nombre del territorio y la región del territorio para cada empleado que tiene asignado un territorio.
--Ejercicio 9: Mostrar el nombre del cliente, el nombre del transportista y el nombre del país del transportista para cada pedido enviado por un transportista.
--Ejercicio 10: Obtener el nombre del prducto, el nombre de la categoría y la descripción de la categoría para cada producto que pertenece a una categoría.


--Ejercicio 11: Seleccionar el total de órdenes hechas por cada uno  de los proveedores
select c.CompanyName, COUNT(oo.OrderID) as 'Total de Ordenes'    
from Suppliers as c
INNER JOIN Products as p
on c.SupplierID = p.SupplierID
INNER JOIN [Order Details] as oo
on oo.ProductID = p.ProductID
GROUP by c.CompanyName
order by [Total de Ordenes] desc;

--Seleccionar el total de dinero que he vendido por porveedor del primer trimestre de 1996
select s.CompanyName, sum(od.UnitPrice * od.Quantity) as 'Total'    
from Suppliers as s
INNER JOIN Products as p
on s.SupplierID = p.SupplierID
INNER JOIN [Order Details] as od
on od.ProductID = p.ProductID
INNER JOIN Orders as O
ON O.OrderID = od.OrderID
WHERE o.OrderDate BETWEEN '1996-09-01' AND '1996-12-31'
GROUP by s.CompanyName
ORDER By 'Total' desc;


Select sum(unitprice * quantity) as 'Total de ventas'
from [Order Details];

--SEleccionar el total de dinero vendido por categoría
select c.CategoryName, sum(od.Quantity * od.UnitPrice) as 'Total de venta' 
from [Order Details] as od
INNER JOIN Products as p 
on od.ProductID = p.ProductID
INNER JOIN Categories as c 
on c.CategoryID = p.CategoryID
group by c.CategoryName
order by 2 desc;

--Seleccionar el total de dinero vendido por categoria y dentro por producto
select c.categoryname as 'Nombre de la categoría', 
p.ProductName as 'producto',
sum(od.Quantity * od.UnitPrice) as 'Total'
from [Order Details] as od
inner JOIN Products as p
on od.ProductID = p.ProductID
inner join Categories as c
on c.CategoryID = p.CategoryID
GROUP by c.CategoryName, p.ProductName
order by 1 asc;

--Seleccionar el total de dinero vendido por categoria dentro del producto 

