use NORTHWND;

--Transaccion: Las transacciones en sql seerver son fundamentales para asegurar 
--la consistencia y la integridad de los datos en una base de datos

--Una transaccion es una unidad de trabajo que se ejecuta de manera
--completamente exitosa o no se ejecuta en absoluto 

--Sigue el principio ACID: 
	--Atomicidad: Toda la transaccion se completa o no se realiza nada 
	--Consistencia: La transacción lleva la base de datos de un estado válido a otro 
	--Aislamiento: Las transacciones concurrentes no interfieren entre si 
	--Durabilidad: Una vez que una transacción se completa, los cambios son permanentes 

	--comandos a utilizar 
		--Begin transaction (inicia una nueva transaccion) 
		--Commit transaction (confirma todos los cambios realizados durante la transacción)
		--rollback transaction (revierte todos los cambios realizados durante la transacción)


select * from Categories;
go

--delete from categories 
--Where CategoryID in (10,12)

begin transaction;

insert into categories(CategoryName, Description)
values ('Los remediales', 'No estará muy bien');
go

rollback transaction;

commit transaction;
go

create database prueba_transacciones;
go
use prueba_transacciones;
go

create table empleado(
	emplid int not null,
	nombre varchar(30),
	salario money not null,
	constraint pk_empleado
	primary key (emplid),
	constraint chk_salario
	check (salario>0.0 and salario <=50000)
);
go

create or alter proc spu_agregar_empleado
--Parametros de entrada 
@emplid int,
@nombre varchar(30),
@salario money
as
	begin 
			begin try 
				begin transaction
				--Inserta en la tabla empleados
				insert into empleado (emplid, nombre, salario)
				values(@emplid, @nombre, @salario);

				--se confirma la transaccion si todo va bien
				commit transaction;
			end try 
			begin catch 
				rollback transaction;
				--Obtener el error
				declare @MensajeError Nvarchar(4000);
				set @MensajeError = ERROR_MESSAGE();
				PRINT @MensajeError;
			end catch;
	end;
GO

exec spu_agregar_empleado 1, 'Monico', 21000.0;
go

exec spu_agregar_empleado 2, 'Toribio', -60000.0;
go

Select * from empleado;