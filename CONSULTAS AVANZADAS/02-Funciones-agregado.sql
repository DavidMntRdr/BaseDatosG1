--Funciones de agregado y agrupación

--utilizar base de datos
use NORTHWND;

--Seleccionar el número total de órdenes de compra
--count(*)

select COUNT(*) as 'Número de órdenes' FROM Orders;

SELECT COUNT(*) from Customers;

--count(campo)

select COUNT(Region) from customers;

--Seleccionar el máximo número de productos pedidos 
SELECT MAX(Quantity) from [Order Details];

--Seleccionar el mínimo de productos pedidos.
SELECT MIN(Quantity) from [Order Details];

--seleccinar el total de las cantidades de los productos pedidos
select SUM(UnitPrice) from [Order Details]

--Seleccionar el total de dinero que he vendido.
select sum(Quantity * od.UnitPrice) as 'Total' 
from [Order Details] as od
INNER JOIN Products as p
on od.ProductID = p.ProductID
where p.ProductName = 'Aniseed Syrup';


--Seleccionar el promedio de las ventas del producto 3
select avg(Quantity * od.UnitPrice) as 'Promedio de ventas' 
from [Order Details] as od
INNER JOIN Products as p
on od.ProductID = p.ProductID
where p.ProductName = 'Aniseed Syrup';

--Seleccionar el número de productos por categoría
select sum(categoryid), COUNT(*) as 'Número de productos' 
from Products;

select CategoryID, COUNT(*) as 'Total de productos'
from Products
group by CategoryID;

--Seleccionar el número de productos por nombre de categoría 
select c.CategoryName, COUNT(*) as 'Total de Productos'    
from Categories as c
INNER JOIN Products as p
on c.CategoryID = p.CategoryID
where c.CategoryName in ('Beverages', 'Confections')
group by c.CategoryName