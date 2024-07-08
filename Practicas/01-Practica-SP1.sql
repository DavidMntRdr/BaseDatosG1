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