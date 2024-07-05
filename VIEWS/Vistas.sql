use NORTHWND;


create or alter view vista_ventas
as
select c.CustomerID as 'ClaveCliente',
c.CompanyName as 'Cliente',
CONCAT(e.FirstName, ' ', e.LastName) as 'Nombre',
o.OrderDate as 'FechaOrden', DATEPART(YEAR, o.OrderDate) as 'AñoCompra',

DATEPART (mm, o.OrderDate) as 'MesCompra',
DATEPART (QUARTER, o.OrderDate) as 'Trimestre',
UPPER(p.ProductName)as 'NombreDelProducto',
od.Quantity as 'CantidadVendida',
od.UnitPrice as 'PrecioDeVenta', p.SupplierID as 'ProveedorID'
from ORDERS as o 
inner Join Customers as c
on o.CustomerID = c.CustomerID
INNER JOIN Employees as e 
on e.EmployeeID = o.EmployeeID
inner join [Order Details] as od 
on od.OrderID = o.OrderID
INNER JOIN Products as p 
on p.ProductID = od.ProductID;

select 
ClaveCliente, Nombre, NombreDelProducto, Fecha, 
(CantidadVendida*PrecioDeVenta) as Importe
 from vista_ventas
 where NombreDelProducto = "CHAI"
 AND (CantidadVendida * PrecioDeVenta) > 600
 AND DATEPART (year, FechaOrden) = 1996
 ;

 select * from 
 vista_ventas as vv
 Inner Join Suppliers as s 
 on s.SupplierID = vv.ProveedorID;

select 
ProductName, unitprice, unitsinstock, discontinued,
Disponibilidad = CASE Discontinued
when 0 then 'No disponible'
when 1 then 'Disponible'
ELSE 'No existente'
END
 from products;



 select ProductNAme, UnitsInStock, UnitPrice,
 CASE 
 when unitPrice >=1 and UnitPrice <=18
 then 'Producto Barato'
 when unitPrice >=18 and UnitPrice <=200
 then 'Producto medio barato'
 when UnitPrice BETWEEN 51 and 100
 then 'Producto caro'
 else 'Carísimo'
 END as 'Categoría de precios'
 from Products;



use AdventureWorks2019;

select BusinessEntityID, SalariedFlag 
from HumanResources.Employee
Order by 
    CASE SalariedFlag
    when 1 then BusinessEntityID
    END desc,
CASE when SalariedFlag = 0 then BusinessEntityID
end asc; 


SELECT BusinessEntityID
    LastName,
    TerritoryName,
    CountryRegionName
from Sales.vSalesPerson
where TerritoryName IS NOT NULL
ORDER BY 
    CASE CountryRegionName 
    when 'United States' then TerritoryName
    else CountryRegionName
    END DESC
;

--IS NULL

Select v.AccountNumber,
        v.Name,
        v.PurchasingWebServiceURL as 'PurchasingWebServiceURL'
 FROM
    [Purchasing].[Vendor] as v;


    
Select v.AccountNumber,
        v.Name,
        ISNULL(v.PurchasingWebServiceURL, 'NO URL') 
        as'PurchasingWebServiceURL'
 FROM
    [Purchasing].[Vendor] as v;


    
Select v.AccountNumber,
        v.Name,
        case 
        when v.PurchasingWebServiceURL IS NULL then 'No URL' 
        END
 FROM
    [Purchasing].[Vendor] as v;


use AdventureWorks2019;

--Funicon IIF
select iif (1=1, 'verdadero', 'falso') as 'RESULTADO'

select e.LoginID, e.JobTitle, e.Gender, 
IIF(e.Gender = 'F', 'Mujer', 'Hombre') as 'SEXO' from 
HumanResources.Employee as e;

create view vista_genero
as
select e.LoginID, e.JobTitle, e.Gender, 
IIF(e.Gender = 'F', 'Mujer', 'Hombre') as 'SEXO' from 
HumanResources.Employee as e;


select UPPER(JobTitle) as 'Título', SEXO from vista_genero
where SEXO = 'Mujer';


--Merge
select OBJECT_ID(N'tempdb..#StudentsC1')

IF OBJECT_ID (N'tempdb..#StudentsC1') is not NULL
begin
    drop table #StudentsC1;
end

CREATE TABLE #StudentsC1(
    StudentID       INT
    ,StudentName    VARCHAR(50)
    ,StudentStatus  BIT
);

INSERT INTO #StudentsC1(StudentID, StudentName, StudentStatus) VALUES(1,'Axel Romero',1)
INSERT INTO #StudentsC1(StudentID, StudentName, StudentStatus) VALUES(2,'Sofía Mora',1)
INSERT INTO #StudentsC1(StudentID, StudentName, StudentStatus) VALUES(3,'Rogelio Rojas',0)
INSERT INTO #StudentsC1(StudentID, StudentName, StudentStatus) VALUES(4,'Mariana Rosas',1)
INSERT INTO #StudentsC1(StudentID, StudentName, StudentStatus) VALUES(5,'Roman Zavaleta',1)




IF OBJECT_ID(N'tempdb..#StudentsC2') is not NULL
begin
drop table #StudentsC2
END


CREATE TABLE #StudentsC2(
    StudentID       INT
    ,StudentName    VARCHAR(50)
    ,StudentStatus  BIT
);


INSERT INTO #StudentsC2(StudentID, StudentName, StudentStatus) VALUES(1,'Axel Romero Rendón',1)
INSERT INTO #StudentsC2(StudentID, StudentName, StudentStatus) VALUES(2,'Sofía Mora Ríos',0)
INSERT INTO #StudentsC2(StudentID, StudentName, StudentStatus) VALUES(6,'Mario Gonzalez Pae',1)
INSERT INTO #StudentsC2(StudentID, StudentName, StudentStatus) VALUES(7,'Alberto García Morales',1)



select * from #StudentsC1; 
select * from #StudentsC2;



select * from #StudentsC1 as s1
inner join #StudentsC2 as s2
on s1.StudentID = s2.StudentID;

insert into #StudentsC2 (StudentID, StudentName, StudentStatus)
select s1.StudentID, s1.StudentName, s1.StudentStatus from #StudentsC1 as s1
LEFT join #StudentsC2 as s2
on s1.StudentID = s2.StudentID
where s2.StudentID is null;


update s2
set s2.studentName = s1.studentName,
    s2.StudentStatus = s1.StudentStatus
from #StudentsC1 as s1
inner join #StudentsC2 as s2
on s1.StudentID = s2.StudentID;


