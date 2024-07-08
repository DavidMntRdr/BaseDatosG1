create database etl_empresa;
use etl_empresa;
create table cliente(
    clienteid int not null IDENTITY(1,1),
    clientebk NCHAR(5) not null,
    empresa nvarchar(40) not null,
    ciudad NVARCHAR(15) not null,
    region NVARCHAR(15) not NULL,
    pais NVARCHAR(15) not null,
    constraint pk_cliente
    PRIMARY key (clienteid)
);

create table Producto(
    productoid int not null IDENTITY(1,1),
    productobk NCHAR(5) not null,
    nombreProducto nvarchar(40) not null,
    categoria int not null,
    precio money not NULL,
    existecia smallint not null,
	descontinuado bit not null,
    constraint pk_producto
    PRIMARY key (productoid)
);

create table empleado(
    empleadoid int not null IDENTITY(1,1),
    empleadobk NCHAR(5) not null,
    NombreCompleto nvarchar(40) not null,
    ciudad NVARCHAR(15) not null,
    region NVARCHAR(15) not NULL,
    pais NVARCHAR(15) not null,
    constraint pk_empleado
    PRIMARY key (empleadoid)
);

create table proveedor(
    proveedorid int not null IDENTITY(1,1),
    proveedorbk NCHAR(5) not null,
    empresa nvarchar(40) not null,
    ciudad NVARCHAR(15) not null,
    region NVARCHAR(15) not NULL,
    pais NVARCHAR(15) not null,
	HomePage ntext not null,
    constraint pk_proveedor
    PRIMARY key (proveedorid)
);

create table ventas(
	ventaid int not null Identity(1,1),
    clienteid int not null,
	productoid int not null,
	empleadoid int not null,
	proveedorid int not null,
	cantidad smallint not null,
	precio money not null,
    constraint pk_ventas
    PRIMARY key (ventaid)
);


Select * from cliente

insert into etl_empresa.dbo.cliente
select CustomerID, UPPER(CompanyName) AS 'Empresa', UPPER(City) as 'Ciudad', 
UPPER (ISNULL(nc.Region, 'SIN REGION')) AS Region, UPPER(Country) as 'País'
from NORTHWND.dbo.Customers as nc
left join etl_empresa.dbo.cliente etl
on nc.CustomerID = etl.clientebk
where etl.clientebk is null; 
go 


CREATE or alter PROC sp_etl_carga_cliente
AS
begin
    insert into etl_empresa.dbo.cliente
    select CustomerID, UPPER(CompanyName) AS 'Empresa', UPPER(city) as Ciudad,
    upper(ISNULL(nc.region, 'SIN REGION')) AS Region, UPPER(country) as 'pais'
    from NORTHWND.dbo.Customers as nc
    left join etl_empresa.dbo.cliente etle
    on nc.CustomerID = etle.clientebk
    where etle.clientebk is NULL

        update cl
    set
    cl.empresa = UPPER(c.CompanyName),
    cl.ciudad = UPPER(c.City),
    cl.pais = UPPER(c.Country),
    cl.region = UPPER(isnull(c.Region, 'Sin Region'))
    from NORTHWND.dbo.Customers as c
    inner join etl_empresa.dbo.cliente as cl
    on c.CustomerID =cl.clientebk;
end



truncate table prueba_etl_empresa.dbo.cliente





select * from NORTHWND.dbo.Customers as nc
left join etl_empresa.dbo.cliente etl
on nc.CustomerID = etl.clientebk;


select * from
NORTHWND.dbo.Suppliers;

select* from
Producto;


Select * from Producto


INSERT INTO etl_empresa.dbo.Producto
SELECT ProductID as 'productoid', UPPER(ProductName) AS 'nombreProducto', CategoryID AS 'categoria', 
    UnitPrice AS 'precio', UnitsInStock AS 'existencia', Discontinued AS 'descontinuado'
FROM NORTHWND.dbo.Products AS nc
LEFT JOIN etl_empresa.dbo.Producto etl
ON nc.ProductID = etl.productobk
WHERE etl.productobk IS NULL;
GO

CREATE OR ALTER PROC sp_etl_carga_producto
AS
BEGIN
    INSERT INTO etl_empresa.dbo.Producto
    SELECT 
        ProductID as 'productoid', UPPER(ProductName) AS 'nombreProducto', 
        CategoryID AS 'categoria', UnitPrice AS 'precio', 
        UnitsInStock AS 'existencia', Discontinued AS 'descontinuado'
    FROM NORTHWND.dbo.Products AS np
    LEFT JOIN etl_empresa.dbo.Producto etl
    ON np.ProductID = etl.productobk
    WHERE etl.productobk IS NULL

    UPDATE prod
    SET
        prod.nombreProducto = UPPER(np.ProductName),
        prod.categoria = np.CategoryID,
        prod.precio = np.UnitPrice,
        prod.existencia = np.UnitsInStock,
        prod.descontinuado = np.Discontinued
    FROM NORTHWND.dbo.Products AS np
    INNER JOIN etl_empresa.dbo.Producto AS prod
    ON np.ProductID = prod.productobk;
END


INSERT INTO etl_empresa.dbo.empleado
SELECT EmployeeID as 'empleadoid', UPPER(FIRSTNAME + ' ' + LASTNAME) AS 'NombreCompleto', 
    UPPER(City) AS 'ciudad', UPPER(ISNULL(ne.Region, 'SIN REGION')) AS 'region', 
    UPPER(Country) AS 'pais'
FROM NORTHWND.dbo.Employees AS ne
LEFT JOIN etl_empresa.dbo.empleado ee
ON ne.EmployeeID = ee.empleadobk
WHERE ee.empleadobk IS NULL;
GO

CREATE OR ALTER PROC sp_etl_carga_empleado
AS
BEGIN
    INSERT INTO etl_empresa.dbo.empleado
    SELECT EmployeeID as 'empleadoid', UPPER(FIRSTNAME + ' ' + LASTNAME) AS 'NombreCompleto', 
        UPPER(City) AS 'ciudad', UPPER(ISNULL(ne.Region, 'SIN REGION')) AS 'region', 
        UPPER(Country) AS 'pais'
    FROM NORTHWND.dbo.Employees AS ne
    LEFT JOIN etl_empresa.dbo.empleado ee
    ON ne.EmployeeID = ee.empleadobk
    WHERE ee.empleadobk IS NULL;

    UPDATE ee
    SET
        ee.NombreCompleto = UPPER(ne.FIRSTNAME + ' ' + ne.LASTNAME),
        ee.ciudad = UPPER(ne.City),
        ee.region = UPPER(ISNULL(ne.Region, 'SIN REGION')),
        ee.pais = UPPER(ne.Country)
    FROM NORTHWND.dbo.Employees AS ne
    INNER JOIN etl_empresa.dbo.empleado AS ee
    ON ne.EmployeeID = ee.empleadobk;
END

select *from proveedor;
INSERT INTO etl_empresa.dbo.proveedor
SELECT SupplierID as 'proveedorid', UPPER(CompanyName) AS 'empresa', UPPER(City) AS 'ciudad', 
    UPPER(ISNULL(ns.Region, 'SIN REGION')) AS 'region', UPPER(Country) AS 'pais', ns.HomePage AS 'HomePage'
FROM NORTHWND.dbo.Suppliers AS ns
LEFT JOIN etl_empresa.dbo.proveedor etl
ON ns.SupplierID = etl.proveedorbk
WHERE etl.proveedorbk IS NULL;
GO

CREATE OR ALTER PROC sp_etl_carga_proveedor
AS
BEGIN
    INSERT INTO etl_empresa.dbo.proveedor
    SELECT SupplierID as 'proveedorid', UPPER(CompanyName) AS 'empresa', UPPER(City) AS 'ciudad', 
        UPPER(ISNULL(ns.Region, 'SIN REGION')) AS 'region', UPPER(Country) AS 'pais', ns.HomePage AS 'HomePage'
    FROM NORTHWND.dbo.Suppliers AS ns
    LEFT JOIN etl_empresa.dbo.proveedor ep
    ON ns.SupplierID = ep.proveedorbk
    WHERE ep.proveedorbk IS NULL;

    UPDATE ep
    SET
        ep.empresa = UPPER(ns.CompanyName),
        ep.ciudad = UPPER(ns.City),
        ep.region = UPPER(ISNULL(ns.Region, 'SIN REGION')),
        ep.pais = UPPER(ns.Country),
        ep.HomePage = ns.HomePage
    FROM NORTHWND.dbo.Suppliers AS ns
    INNER JOIN etl_empresa.dbo.proveedor AS ep
    ON ns.SupplierID = ep.proveedorbk;
END


select * from NORTHWND.dbo.Orders;
select * from NORTHWND.dbo.[Order Details];


INSERT INTO etl_empresa.dbo.ventas (clienteid, productoid, empleadoid, proveedorid, cantidad, precio)
SELECT o.CustomerID as 'clienteid', od.ProductID as 'productoid', o.EmployeeID as 'empleadoid',
    p.SupplierID as 'proveedorid', od.Quantity as 'cantidad', od.UnitPrice as 'precio'
FROM NORTHWND.dbo.Orders AS o
Inner JOIN NORTHWND.dbo.[Order Details] AS od ON o.OrderID = od.OrderID
Inner JOIN NORTHWND.dbo.Products AS p ON od.ProductID = p.ProductID
inner JOIN NORTHWND.dbo.Suppliers AS s ON p.SupplierID = s.SupplierID
LEFT JOIN etl_empresa.dbo.ventas v ON o.OrderID = v.ventaid
WHERE v.ventaid IS NULL;
GO

