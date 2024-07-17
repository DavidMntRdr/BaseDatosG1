--ejercicio2: Insertar una venta 


create or alter proc spu_agregar_venta
		@CustomerID nchar(5),
		@EmployeeID int,
		@OrderDate datetime,
		@RequiredDate datetime,
		@ShippedDate datetime,
		@ShipVia int,
		@Freight money =Null,
		@ShipName nvarchar(40) = null,
		@ShipAddress nvarchar(60) =null,
		@ShipCity nvarchar(15) = null,
		@ShipRegion nvarchar(15)= null,
		@ShipPostalCode nvarchar(10) = null,
		@ShipCountry nvarchar(15),
		@ProductID int,
		@Quantity smallint,
		@Discount real = 0

	AS
	Begin
		BEGIN TRANSACTION;
			BEGIN TRY
				INSERT INTO [dbo].[Orders]
					   ([CustomerID]
					   ,[EmployeeID]
					   ,[OrderDate]
					   ,[RequiredDate]
					   ,[ShippedDate]
					   ,[ShipVia]
					   ,[Freight]
					   ,[ShipName]
					   ,[ShipAddress]
					   ,[ShipCity]
					   ,[ShipRegion]
					   ,[ShipPostalCode]
					   ,[ShipCountry])
				 VALUES
					   (@CustomerID,
						@EmployeeID,
						@OrderDate,
						@RequiredDate,
						@ShippedDate,
						@ShipVia,
						@Freight,
						@ShipName,
						@ShipAddress,
						@ShipCity,
						@ShipRegion,
						@ShipPostalCode,
						@ShipCountry);
						
						--Obtener el ID insertado en orders
						Declare @OrderID int;
						set @OrderID = SCOPE_IDENTITY();

						--Obtener el precio del producto:
						Declare @PrecioVenta money
						select @PrecioVenta = UnitPrice from Products
						where ProductID = @ProductID;

						--Insertar en order details
						INSERT INTO [dbo].[Order Details]
							   ([OrderID]
							   ,[ProductID]
							   ,[UnitPrice]
							   ,[Quantity]
							   ,[Discount])
						 VALUES
							   (@OrderID,
							   @ProductID,
							   @PrecioVenta,
							   @Quantity,
							   @Discount)

							   ---Actualizar la tabla products en el campo unitsInStock
					Update Products
					set UnitsInStock = UnitsInStock - @Quantity
					where ProductID = @ProductID;

					Commit transaction;
			END TRY
			BEGIN CATCH 
				Rollback Transaction;
				DECLARE @MensajeError nvarchar(4000);
				set @MensajeError = ERROR_MESSAGE();
				Print @MensajeError;
			END CATCH; 
	end;
	GO


