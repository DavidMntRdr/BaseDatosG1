--Consultas avanzadas
select C.CategoryName as 'Nombre de categoría', 
P.ProductName as 'Nombre de producto', 
P.UnitPrice as 'Precio', 
P.UnitsInStock as 'Existencias' from 
Categories as C
inner join Products as P  
on C.CategoryID = P.CategoryID
where C.CategoryName in ('Beverages', 'Produce');
