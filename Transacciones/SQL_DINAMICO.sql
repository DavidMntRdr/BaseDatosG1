use NORTHWND;
Go

--Crear un store procedure que reciba como parametro de entrada el nombre de una tabla y visualice todos sus registros

create or alter proc spu_mostrar_datos_tabla
@tabla varchar(100)
as
begin
	--SQL dinámimco 
	Declare @sql nvarchar(max);
	set @sql = 'Select * from ' + @tabla;
	exec (@sql)
end;
go

exec spu_mostrar_datos_tabla Employees;
go

create or alter proc spu_mostrar_datos_tabla2
@tabla varchar(100)
as
begin
	--SQL dinámimco 
	Declare @sql nvarchar(max);
	set @sql = 'Select * from ' + @tabla;
	exec sp_executesql @sql;
end;
go