




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






--Crear un sp que solicite un Id de una categor�a y devuelva el promedio de los precios de sus productos.
use NORTHWND;
go

create or alter proc sp_solicitar_promedio_prod
@catego int --parametro de entrada
as
begin
select avg(UnitPrice) as 'Promedio de precios de los productos '
from Products
where CategoryID=@catego;
end
go

execute sp_solicitar_promedio_prod 2;

execute sp_solicitar_promedio_prod @catego=5;


execute sp_solicitar_promedio_prod @catego=4;


execute sp_solicitar_promedio_prod @catego=6;

--Crear un SP que reciba 2 fechas y devuelva una lista de empleados que fueron contratados dentro de ese rango de fechas

create or alter proc sp_fechas
@fecha1 datetime 
@fecha2 datetime
as
begin
select CONCAT(FirstName, ' ' , LastName )as 'Nombre completo', HireDate
from Employees
where HireDate between @fecha1 and @fecha2;
end



--Procedimiento almacenado para actualizar el precio de un producto y registrar el cambio 
--Proceso:
--1. Crear un procedimiento almacenado "actualizar_precio_prodcuto"
--2. Crear una tabla que se llame cambio de precios, los campos que va a tener serán not null:
-- cambioID int IDENTITY primary key
-- productoID int 
-- precioAnterior money
-- precioNuevo money
-- FechaCambio datetime
--para obtener la fecha en el transact es getDate()
--3.  El procedimiento almacenado debe aceptar dos parametros, el producto que va a cambiar (id) y el nuevo precio.
--4. Debe actualizar el precio del producto en la tabla products
--5. el procedimiento debe insertar un prodcuto en la tabla cambio_de_precios con los detalles del cambio
--(02_practica_sp)

create table cambio_de_precios(
	cambioID int IDENTITY primary key,
	productoID int NOT NULL, 
	precioAnterior money NOT NULL,
	precioNuevo money NOT NULL,
	FechaCambio datetime NOT NULL
);

create or alter proc actualizar_precio_producto


go



select * 
from Products



create procedure sp_prueba_g1
as 
begin
    print 'Hola mundo';
END


--Ejecutar un store procedure

exec sp_prueba_g1

--Declaracion de variables
Declare @n int  
declare @i int

set @n=5
set @i=1

print('El valor de n es: ' + cast(@n as varchar))


print('El valor de i es: ' + cast(@i as varchar))






create database prueba_sp



use prueba_sp;



create proc sp_1
as 
BEGIN
Declare @n int  
declare @i int

set @n=5
set @i=1

print('El valor de n es: ' + cast(@n as varchar))


print('El valor de i es: ' + cast(@i as varchar))

end;


--Ejecutar 10 veces sp_1 solamente si el sentinela es 1

create proc sp_2
as
BEGIN
Declare @n as int = 10, @i int = 1
 
 while @i <= @n 
 begin
    print(@i);
    set @i+=1
 END
 END


exec sp_1;


create procedure sp_3
@n int --parametro de entrada
as
BEGIN
Declare @i int = 1
 
IF @n>0
begin 
    while @i <= @n 
    begin
        print(@i);
        set @i+=1 --Set @i = @i + 1
    END

 END
 else 
 BEGIN
    print 'El valor de n debe ser mayor a 0'
 END

END


exec sp_3 10

exec sp_3 @n=20


create or ALTER PROC sp_4
    @n INT--parametro de entrada
as
BEGIN
    declare @i int=1, @r int=0
    if @n>0
   
BEGIN
        WHILE @i<=@n
 BEGIN
            SET @r=@r+@i

            SET @i+=1
        END
        PRINT('La suma de los numeros es '+ cast( @r as varchar))
    END
ELSE
BEGIN
        PRINT('El valor de n debe ser mayor a 0')
    END
END

exec sp_4 5



--seleccionar de la base de datos nortwind todas las ordenes de compra para un año determinado

use NORTHWND;
create or ALTER PROC sp_5
    @a INT--parametro de entrada
as
BEGIN
    select *
    from Orders
    where YEAR(OrderDate) = @a
END

exec sp_5 1996


--Crear un ps que muestre el total de ventas para cada cliente por un rango de años

create or ALTER PROC sp_6
    @a INT--parametro de entrada
as
BEGIN
    select sum(Quantity * od.UnitPrice) as 'Total' 
    from [Order Details] as od
    INNER JOIN Products as p
    on od.ProductID = p.ProductID
    where  ;
END

exec sp_5 1996


--Parametros de salida
create or alter procedure calcular_area
--Parametros de entrada
@radio float,
--Parametro de salida
@area float OUTPUT
as 
BEGIN
   SET @area = PI() * @radio * @radio 
END
GO

DECLARE @res float 
exec calcular_area @radio = 22.3, @area=@res output
print 'El área es: ' + cast(@res as varchar);

go

create or alter procedure sp_obtenerdatosempleado
    @numeroEmpleado int,
    @fullname nvarchar(35) output
AS
begin

    select @fullname=CONCAT(FirstName, '', LastName)
    from
        Employees
    where EmployeeID = @numeroEmpleado;
end; 
go

Declare @nombreCompleto nvarchar(35)
execute sp_obtenerdatosempleado @numeroEmpleado = 3, @fullname = @nombreCompleto output
print @nombreCompleto;
GO


create or alter procedure sp_obtenerdatosempleado2
    @numeroEmpleado int,
    @fullname nvarchar(35) output
AS
begin
    DECLARE @verificar INT
    set @verificar = (select COUNT(*) from Employees where EmployeeID = @numeroEmpleado)
    if @verificar > 0
BEGIN
      select @fullname=CONCAT(FirstName, '', LastName)
    from
        Employees
    where EmployeeID = @numeroEmpleado;      
    END 
    ELSE  BEGIN
    print 'No existe el numero de empleado'
    END
end; 
go

Declare @nombreCompleto nvarchar(35)
execute sp_obtenerdatosempleado2 @numeroEmpleado = 50, @fullname = @nombreCompleto output
print @nombreCompleto;
GO


create or alter procedure sp_obtenerdatosempleado3
    @numeroEmpleado int,
    @fullname nvarchar(35) output
AS
begin
      select @fullname=CONCAT(FirstName, '', LastName)
    from
        Employees
    where EmployeeID = @numeroEmpleado;  
    if @fullname is NULL
BEGIN    
    print 'No existe el numero de empleado'
    END 
end; 
go

Declare @nombreCompleto nvarchar(35)
execute sp_obtenerdatosempleado3 @numeroEmpleado = 8, @fullname = @nombreCompleto output
print @nombreCompleto;




select * from Customers



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


insert into prueba_etl_empresa.dbo.cliente
select CustomerID, UPPER(CompanyName) AS 'Empresa', UPPER(City) as 'Ciudad', 
UPPER (ISNULL(nc.Region, 'SIN REGION')) AS Region, UPPER(Country) as 'País'
from NORTHWND.dbo.Customers as nc
left join prueba_etl_empresa.dbo.cliente etl
on nc.CustomerID = etl.clientebk
where etl.clientebk is null; 


update cl 
set 
cl.empresa=upper(c.CompanyName),
cl.ciudad = upper(c.City),
cl.pais = upper(c.country),
cl.region = upper(isnull(c.Region 'Sin region')), 
select * from NORTHWND.dbo.Customers as c 
inner join prueba_etl_empresa.dbo.cliente as cl
on c.CustomerID = cl.clientebk 



truncate table prueba_etl_empresa.dbo.cliente





select * from NORTHWND.dbo.Customers as nc
left join prueba_etl_empresa.dbo.cliente etl
on nc.CustomerID = etl.clientebk; 
