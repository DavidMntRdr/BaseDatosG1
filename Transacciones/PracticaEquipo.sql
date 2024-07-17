--que actualice los precios de los productos y guarde esa actualización en una tabla de history

use NORTHWND;

create table PreciosHistoricos(
	ID int not null IDENTITY(1,1),
	ProductoID int,
	PrecioAnterior money,
	PrecioNuevo money,
	FechaModificacion date default getdate()
	);

	drop table PreciosHistoricos;


select * from Products as p
full join PreciosHistoricos as ph
on p.ProductID = ph.ProductoID;



select * from PreciosHistoricos;
go


create or alter proc actualizar_precios 
@productoID int,
@nuevoPrecio money
as
begin
	BEGIN try 
		BEGIN Transaction
			declare @precioAnterior money

			select @precioAnterior = unitPrice from Products 
			where ProductID = @productoID;

			INSERT INTO PreciosHistoricos (ProductoID, PrecioAnterior, PrecioNuevo)
			values (@productoID, @precioAnterior, @nuevoPrecio)
			

			UPDATE Products
			set UnitPrice = @nuevoPrecio
			where ProductID = @productoID 

			commit transaction;

		end try
		BEGIN CATCH
			ROLLBACK TRANSACTION
			DECLARE @MensaJeError varchar(100);
			set @MensaJeError = ERROR_MESSAGE();
			print @MensaJeError;
		END CATCH;
end;
go



EXEC actualizar_precios 6, 1000;

select ProductID, UnitPrice from Products;
select * from PreciosHistoricos;

go
