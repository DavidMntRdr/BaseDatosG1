USE [NORTHWND]
GO

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
           (<CustomerID, nchar(5),>
           ,<EmployeeID, int,>
           ,<OrderDate, datetime,>
           ,<RequiredDate, datetime,>
           ,<ShippedDate, datetime,>
           ,<ShipVia, int,>
           ,<Freight, money,>
           ,<ShipName, nvarchar(40),>
           ,<ShipAddress, nvarchar(60),>
           ,<ShipCity, nvarchar(15),>
           ,<ShipRegion, nvarchar(15),>
           ,<ShipPostalCode, nvarchar(10),>
           ,<ShipCountry, nvarchar(15),>)
GO

(<OrderID, int,>
           ,<ProductID, int,>
           ,<UnitPrice, money,>
           ,<Quantity, smallint,>
           ,<Discount, real,>)
