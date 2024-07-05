create database prueba_etl_empresa;
use prueba_etl_empresa;
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




insert into prueba_etl_empresa.dbo.cliente
select CustomerID, UPPER(CompanyName) AS 'Empresa', UPPER(City) as 'Ciudad', 
UPPER (ISNULL(nc.Region, 'SIN REGION')) AS Region, UPPER(Country) as 'País'
from NORTHWND.dbo.Customers as nc
left join prueba_etl_empresa.dbo.cliente etl
on nc.CustomerID = etl.clientebk
where etl.clientebk is null; 
go 

CREATE PROC sp_etl_carga_cliente
AS
begin
insert into etlempresa.dbo.cliente
select CustomerID, UPPER(CompanyName) AS 'Empresa',UPPER(city) as Ciudad,
upper(ISNULL(nc.region, 'SIN REGION')) AS Region, UPPER(country) as pais
from Northwind.dbo.Customers as nc
left join prueba_etlempresa.dbo.cliente etle
on nc.CustomerID = etle.clientebk
where etle.clientebk is null;


update cl
set
cl.empresa = UPPER(c.CompanyName),
cl.ciudad = UPPER(c.City),
cl.pais = UPPER(c.Country),
cl.region = UPPER(isnull(c.Region, 'Sin Region'))
from Northwind.dbo.Customers as c
inner join etlempresa.dbo.cliente as cl
on c.CustomerID =cl.clientebk;
end



truncate table prueba_etl_empresa.dbo.cliente





select * from NORTHWND.dbo.Customers as nc
left join prueba_etl_empresa.dbo.cliente etl
on nc.CustomerID = etl.clientebk;


select* from
NORTHWND.dbo.Customers;