use NORTHWND;

select o.OrderID, o.OrderDate, c.CompanyName,
c.City, od.Quantity, od.UnitPrice
from Orders as o
inner join [Order Details] as od
on o.OrderID = od.OrderID
inner join customers as c
on c.CustomerID = o.CustomerID
where c.city in ('San Cristóbal', 'México D.F.');

------------------------------------------------------------------------------------
select c.CompanyName, count(o.OrderID) as [numero ordenes]
from Orders as o
inner join [Order Details] as od
on o.OrderID = od.OrderID
inner join customers as c
on c.CustomerID = o.CustomerID
where c.city in ('San Cristóbal', 'México D.F.')
group by c.CompanyName
having count(*) >18;


--Obtener los nombres de los productos y sus categorias donde el precio promedio de sus productos en la misma categoría sea mayor a 20
select * from Products;
select * from Categories;
select * from [Order Details];

select p.ProductName, 
		avg(p.UnitPrice) as 'Promedio de precios', c.CategoryName
from Products as p
left join Categories as c
on p.CategoryID = c.CategoryID
where p.CategoryID is not null
group by c.CategoryName, p.ProductName
having avg(p.UnitPrice) >20
order by CategoryName


--Domde el maximo del precio unitario sea mayor a 40

select p.ProductName, 
		avg(p.UnitPrice) as 'Promedio de precios', c.CategoryName
from Products as p
left join Categories as c
on p.CategoryID = c.CategoryID
where p.CategoryID is not null
group by c.CategoryName, p.ProductName
having max(p.UnitPrice) > 40
order by CategoryName








