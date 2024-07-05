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
