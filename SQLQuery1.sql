use BDEJEMPLO2;
go

select * from Clientes;
select * from Oficinas;
select * from Pedidos;
select * from Productos;
select * from Representantes;



-- Obtener una lista de todos los pedidos con detalles del cliente y representante
SELECT 
    p.Num_Pedido, 
    p.Fecha_Pedido, 
    c.Empresa AS Cliente, 
    r.Nombre AS Representante, 
    p.Producto, 
    p.Cantidad, 
    p.Importe
FROM 
    Pedidos p
INNER JOIN 
    Clientes c ON p.Cliente = c.Num_Cli
INNER JOIN 
    Representantes r ON p.Rep = r.Num_Empl;
GO

-- Obtener una lista de todos los productos con detalles del fabricante
SELECT 
    p.Id_producto, 
    p.Descripcion, 
    p.Precio, 
    p.Stock, 
    p.Id_fab
FROM 
    Productos p
INNER JOIN 
    Pedidos pd ON p.Id_producto = pd.Producto;
GO

-- Ejemplos de LEFT JOIN

-- Obtener una lista de todos los clientes con su representante, incluyendo clientes sin representante asignado
SELECT 
    c.Num_Cli, 
    c.Empresa, 
    r.Nombre AS Representante
FROM 
    Clientes c
LEFT JOIN 
    Representantes r ON c.Rep_Cli = r.Num_Empl;
GO

-- Obtener una lista de todos los representantes con detalles de la oficina, incluyendo representantes sin oficina asignada
SELECT 
    r.Num_Empl, 
    r.Nombre, 
    r.Edad, 
    o.Ciudad AS Oficina_Ciudad
FROM 
    Representantes r
LEFT JOIN 
    Oficinas o ON r.Oficina_Rep = o.Oficina;
GO

-- Ejemplos de RIGHT JOIN

-- Obtener una lista de todas las oficinas con los representantes asignados, incluyendo oficinas sin representantes asignados
SELECT 
    o.Oficina, 
    o.Ciudad, 
    r.Nombre AS Representante
FROM 
    Oficinas o
RIGHT JOIN 
    Representantes r ON o.Oficina = r.Oficina_Rep;
GO

-- Obtener una lista de todos los productos y los pedidos asociados, incluyendo productos sin pedidos
SELECT 
    p.Id_producto, 
    p.Descripcion, 
    pd.Num_Pedido, 
    pd.Cantidad
FROM 
    Productos p
RIGHT JOIN 
    Pedidos pd ON p.Id_producto = pd.Producto;
GO

-- Ejemplos de INNER JOIN con fechas

-- Obtener una lista de todos los pedidos realizados en el último mes con detalles del cliente y representante
SELECT 
    p.Num_Pedido, 
    p.Fecha_Pedido, 
    c.Empresa AS Cliente, 
    r.Nombre AS Representante, 
    p.Producto, 
    p.Cantidad, 
    p.Importe
FROM 
    Pedidos p
INNER JOIN 
    Clientes c ON p.Cliente = c.Num_Cli
INNER JOIN 
    Representantes r ON p.Rep = r.Num_Empl
WHERE 
    p.Fecha_Pedido BETWEEN '1989-07-01' AND '1990-06-30';
GO


-- Ejemplos de LEFT JOIN con fechas

-- Obtener una lista de todos los clientes y sus pedidos en el último año, incluyendo clientes sin pedidos
SELECT 
    c.Num_Cli, 
    c.Empresa, 
    p.Num_Pedido, 
    p.Fecha_Pedido, 
    p.Producto, 
    p.Cantidad, 
    p.Importe
FROM 
    Clientes c
LEFT JOIN 
    Pedidos p ON c.Num_Cli = p.Cliente 
    AND p.Fecha_Pedido BETWEEN '1989-07-01' AND '1990-06-30';
GO

-- Ejemplos de RIGHT JOIN con fechas

-- Obtener una lista de todas las oficinas y los representantes asignados contratados en los últimos 5 años, incluyendo oficinas sin representantes asignados
SELECT 
    o.Oficina, 
    o.Ciudad, 
    r.Nombre AS Representante, 
    r.Fecha_Contrato
FROM 
    Oficinas o
RIGHT JOIN 
    Representantes r ON o.Oficina = r.Oficina_Rep
WHERE 
    r.Fecha_Contrato BETWEEN '1984-07-01' AND '1989-06-30';
GO



-- Procedimiento Almacenado para INNER JOIN con Fechas
CREATE PROCEDURE ObtenerPedidosPorRangoDeFechas
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SELECT 
        p.Num_Pedido, 
        p.Fecha_Pedido, 
        c.Empresa AS Cliente, 
        r.Nombre AS Representante, 
        p.Producto, 
        p.Cantidad, 
        p.Importe
    FROM 
        Pedidos p
    INNER JOIN 
        Clientes c ON p.Cliente = c.Num_Cli
    INNER JOIN 
        Representantes r ON p.Rep = r.Num_Empl
    WHERE 
        p.Fecha_Pedido BETWEEN @FechaInicio AND @FechaFin;
END
GO

-- Procedimiento Almacenado para LEFT JOIN con Fechas
CREATE PROCEDURE ObtenerClientesYPedidosPorRangoDeFechas
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SELECT 
        c.Num_Cli, 
        c.Empresa, 
        p.Num_Pedido, 
        p.Fecha_Pedido, 
        p.Producto, 
        p.Cantidad, 
        p.Importe
    FROM 
        Clientes c
    LEFT JOIN 
        Pedidos p ON c.Num_Cli = p.Cliente 
        AND p.Fecha_Pedido BETWEEN @FechaInicio AND @FechaFin;
END
GO
exec ObtenerClientesYPedidosPorRangoDeFechas '1986-07-01', '1990-01-01';
go

-- Procedimiento Almacenado para RIGHT JOIN con Fechas
CREATE PROCEDURE ObtenerOficinasYRepresentantesPorRangoDeFechas
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SELECT 
        o.Oficina, 
        o.Ciudad, 
        r.Nombre AS Representante, 
        r.Fecha_Contrato
    FROM 
        Oficinas o
    RIGHT JOIN 
        Representantes r ON o.Oficina = r.Oficina_Rep
    WHERE 
        r.Fecha_Contrato BETWEEN @FechaInicio AND @FechaFin;
END
GO


-- Crear Procedimientos Almacenados

-- Procedimientos para Clientes
CREATE PROCEDURE spCrearCliente
    @Empresa NVARCHAR(20),
    @Rep_Cli INT,
    @Limite_Credito MONEY
AS
BEGIN
    INSERT INTO Clientes (Empresa, Rep_Cli, Limite_Credito)
    VALUES (@Empresa, @Rep_Cli, @Limite_Credito);
END
GO

CREATE PROCEDURE spActualizarCliente
    @Num_Cli INT,
    @Empresa NVARCHAR(20),
    @Rep_Cli INT,
    @Limite_Credito MONEY
AS
BEGIN
    UPDATE Clientes
    SET Empresa = @Empresa, Rep_Cli = @Rep_Cli, Limite_Credito = @Limite_Credito
    WHERE Num_Cli = @Num_Cli;
END
GO

CREATE PROCEDURE spEliminarCliente
    @Num_Cli INT
AS
BEGIN
    DELETE FROM Clientes
    WHERE Num_Cli = @Num_Cli;
END
GO

CREATE PROCEDURE spObtenerClientePorID
    @Num_Cli INT
AS
BEGIN
    SELECT * FROM Clientes
    WHERE Num_Cli = @Num_Cli;
END
GO

-- Procedimientos para Representantes
CREATE PROCEDURE spCrearRepresentante
    @Nombre NVARCHAR(16),
    @Edad INT,
    @Oficina_Rep INT,
    @Puesto NVARCHAR(13),
    @Fecha_Contrato DATE,
    @Jefe INT,
    @Cuota MONEY,
    @Ventas MONEY
AS
BEGIN
    INSERT INTO Representantes (Nombre, Edad, Oficina_Rep, Puesto, Fecha_Contrato, Jefe, Cuota, Ventas)
    VALUES (@Nombre, @Edad, @Oficina_Rep, @Puesto, @Fecha_Contrato, @Jefe, @Cuota, @Ventas);
END
GO

CREATE PROCEDURE spActualizarRepresentante
    @Num_Empl INT,
    @Nombre NVARCHAR(16),
    @Edad INT,
    @Oficina_Rep INT,
    @Puesto NVARCHAR(13),
    @Fecha_Contrato DATE,
    @Jefe INT,
    @Cuota MONEY,
    @Ventas MONEY
AS
BEGIN
    UPDATE Representantes
    SET Nombre = @Nombre, Edad = @Edad, Oficina_Rep = @Oficina_Rep, Puesto = @Puesto, Fecha_Contrato = @Fecha_Contrato, Jefe = @Jefe, Cuota = @Cuota, Ventas = @Ventas
    WHERE Num_Empl = @Num_Empl;
END
GO

CREATE PROCEDURE spEliminarRepresentante
    @Num_Empl INT
AS
BEGIN
    DELETE FROM Representantes
    WHERE Num_Empl = @Num_Empl;
END
GO

CREATE PROCEDURE spObtenerRepresentantePorID
    @Num_Empl INT
AS
BEGIN
    SELECT * FROM Representantes
    WHERE Num_Empl = @Num_Empl;
END
GO

-- Procedimientos para Pedidos
CREATE PROCEDURE spCrearPedido
    @Fecha_Pedido DATE,
    @Cliente INT,
    @Rep INT,
    @Producto CHAR(5),
    @Cantidad INT,
    @Importe MONEY
AS
BEGIN
    INSERT INTO Pedidos (Fecha_Pedido, Cliente, Rep, Producto, Cantidad, Importe)
    VALUES (@Fecha_Pedido, @Cliente, @Rep, @Producto, @Cantidad, @Importe);
END
GO

CREATE PROCEDURE spActualizarPedido
    @Num_Pedido INT,
    @Fecha_Pedido DATE,
    @Cliente INT,
    @Rep INT,
    @Producto CHAR(5),
    @Cantidad INT,
    @Importe MONEY
AS
BEGIN
    UPDATE Pedidos
    SET Fecha_Pedido = @Fecha_Pedido, Cliente = @Cliente, Rep = @Rep, Producto = @Producto, Cantidad = @Cantidad, Importe = @Importe
    WHERE Num_Pedido = @Num_Pedido;
END
GO

CREATE PROCEDURE spEliminarPedido
    @Num_Pedido INT
AS
BEGIN
    DELETE FROM Pedidos
    WHERE Num_Pedido = @Num_Pedido;
END
GO

CREATE PROCEDURE spObtenerPedidoPorID
    @Num_Pedido INT
AS
BEGIN
    SELECT * FROM Pedidos
    WHERE Num_Pedido = @Num_Pedido;
END
GO

-- Procedimientos para Productos
CREATE PROCEDURE spCrearProducto
    @Id_fab CHAR(3),
    @Id_producto CHAR(5),
    @Descripcion NVARCHAR(20),
    @Precio MONEY,
    @Stock INT
AS
BEGIN
    INSERT INTO Productos (Id_fab, Id_producto, Descripcion, Precio, Stock)
    VALUES (@Id_fab, @Id_producto, @Descripcion, @Precio, @Stock);
END
GO

CREATE PROCEDURE spActualizarProducto
    @Id_fab CHAR(3),
    @Id_producto CHAR(5),
    @Descripcion NVARCHAR(20),
    @Precio MONEY,
    @Stock INT
AS
BEGIN
    UPDATE Productos
    SET Descripcion = @Descripcion, Precio = @Precio, Stock = @Stock
    WHERE Id_fab = @Id_fab AND Id_producto = @Id_producto;
END
GO

CREATE PROCEDURE spEliminarProducto
    @Id_fab CHAR(3),
    @Id_producto CHAR(5)
AS
BEGIN
    DELETE FROM Productos
    WHERE Id_fab = @Id_fab AND Id_producto = @Id_producto;
END
GO

CREATE PROCEDURE spObtenerProductoPorID
    @Id_fab CHAR(3),
    @Id_producto CHAR(5)
AS
BEGIN
    SELECT * FROM Productos
    WHERE Id_fab = @Id_fab AND Id_producto = @Id_producto;
END
GO

-- Procedimientos para Oficinas
CREATE PROCEDURE spCrearOficina
    @Oficina INT,
    @Ciudad NVARCHAR(20),
    @Region NVARCHAR(20),
    @Jef INT,
    @Objetivo MONEY,
    @Ventas MONEY
AS
BEGIN
    INSERT INTO Oficinas (Oficina, Ciudad, Region, Jef, Objetivo, Ventas)
    VALUES (@Oficina, @Ciudad, @Region, @Jef, @Objetivo, @Ventas);
END
GO

CREATE PROCEDURE spActualizarOficina
    @Oficina INT,
    @Ciudad NVARCHAR(20),
    @Region NVARCHAR(20),
    @Jef INT,
    @Objetivo MONEY,
    @Ventas MONEY
AS
BEGIN
    UPDATE Oficinas
    SET Ciudad = @Ciudad, Region = @Region, Jef = @Jef, Objetivo = @Objetivo, Ventas = @Ventas
    WHERE Oficina = @Oficina;
END
GO

CREATE PROCEDURE spEliminarOficina
    @Oficina INT
AS
BEGIN
    DELETE FROM Oficinas
    WHERE Oficina = @Oficina;
END
GO

CREATE PROCEDURE spObtenerOficinaPorID
    @Oficina INT
AS
BEGIN
    SELECT * FROM Oficinas
    WHERE Oficina = @Oficina;
END
GO


-- Obtener una lista de todos los clientes con su representante
CREATE PROCEDURE spClientesConRepresentante
AS
BEGIN
    SELECT c.Num_Cli, c.Empresa, r.Nombre AS Representante
    FROM Clientes c
    LEFT JOIN Representantes r ON c.Rep_Cli = r.Num_Empl;
END
GO

exec spClientesConRepresentante

-- Obtener una lista de todos los pedidos con detalles del cliente y representante
CREATE PROCEDURE spPedidosConDetalles
AS
BEGIN
    SELECT p.Num_Pedido, p.Fecha_Pedido, c.Empresa AS Cliente, r.Nombre AS Representante, p.Producto, p.Cantidad, p.Importe
    FROM Pedidos p
    INNER JOIN Clientes c ON p.Cliente = c.Num_Cli
    INNER JOIN Representantes r ON p.Rep = r.Num_Empl;
END
GO

-- Obtener una lista de todos los productos con detalles del fabricante
CREATE PROCEDURE spProductosConDetalles
AS
BEGIN
    SELECT p.Id_producto, p.Descripcion, p.Precio, p.Stock, p.Id_fab
    FROM Productos p;
END
GO

-- Vistas

-- Vista para listar clientes con su representante
CREATE VIEW vwClientesConRepresentante AS
SELECT c.Num_Cli, c.Empresa, r.Nombre AS Representante
FROM Clientes c
LEFT JOIN Representantes r ON c.Rep_Cli = r.Num_Empl;
GO

-- Vista para listar pedidos con detalles del cliente y representante
CREATE VIEW vwPedidosConDetalles AS
SELECT p.Num_Pedido, p.Fecha_Pedido, c.Empresa AS Cliente, r.Nombre AS Representante, p.Producto, p.Cantidad, p.Importe
FROM Pedidos p
INNER JOIN Clientes c ON p.Cliente = c.Num_Cli
INNER JOIN Representantes r ON p.Rep = r.Num_Empl;
GO
select * from vwPedidosConDetalles;
go

-- Vista para listar productos con detalles del fabricante
use BDEJEMPLO2;
CREATE VIEW vwProductosConDetalles AS
SELECT p.Id_producto, p.Descripcion, p.Precio, p.Stock, p.Id_fab
FROM Productos p;
GO

select * from vwProductosConDetalles;


CREATE OR ALTER PROCEDURE spu_carga_delta_c1_c2
-- Parámetros
AS
BEGIN
    -- Programación del SP
    BEGIN TRANSACTION 
        BEGIN TRY
            -- Hacer eliminaciones que se hicieron en el source y se afecten en el target
            DELETE FROM Clientes 
            WHERE Num_Cli NOT IN (SELECT Num_Cli FROM Clientes_Origen);

            -- Confirmar la transacción
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            DECLARE @MensajeError VARCHAR(100);
            SET @MensajeError = ERROR_MESSAGE();
            PRINT @MensajeError;
        END CATCH;
END;
GO


CREATE OR ALTER PROCEDURE spu_carga_delta_c1_c2_merge
-- Parámetros
AS
BEGIN
    -- Programación del SP
    BEGIN TRANSACTION 
        BEGIN TRY
            MERGE INTO Clientes AS TGT
            USING (
                SELECT Num_Cli, Empresa, Rep_Cli, Limite_Credito 
                FROM Clientes_Origen
            ) AS Src
            ON (
                TGT.Num_Cli = Src.Num_Cli
            )
            WHEN MATCHED AND (
                TGT.Empresa <> Src.Empresa OR 
                TGT.Rep_Cli <> Src.Rep_Cli OR 
                TGT.Limite_Credito <> Src.Limite_Credito
            )
            THEN
                UPDATE SET 
                    TGT.Empresa = Src.Empresa,
                    TGT.Rep_Cli = Src.Rep_Cli,
                    TGT.Limite_Credito = Src.Limite_Credito
            WHEN NOT MATCHED BY SOURCE THEN DELETE
            WHEN NOT MATCHED BY TARGET THEN
                INSERT (Num_Cli, Empresa, Rep_Cli, Limite_Credito)
                VALUES (Src.Num_Cli, Src.Empresa, Src.Rep_Cli, Src.Limite_Credito);

            -- Confirmar la transacción
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            DECLARE @MensajeError VARCHAR(100);
            SET @MensajeError = ERROR_MESSAGE();
            PRINT @MensajeError;
        END CATCH;
END;
GO


CREATE OR ALTER PROCEDURE spu_carga_delta_c1_c2_merge
AS
BEGIN
    -- Programación del SP
    BEGIN TRANSACTION 
        BEGIN TRY
            MERGE INTO Clientes AS TGT
            USING (
                SELECT Num_Cli, Empresa, Rep_Cli, Limite_Credito 
                FROM Clientes_Origen
            ) AS Src
            ON (
                TGT.Num_Cli = Src.Num_Cli
            )
            -- Para actualizar 
            WHEN MATCHED THEN
                UPDATE 
                SET TGT.Empresa = Src.Empresa,
                    TGT.Rep_Cli = Src.Rep_Cli,
                    TGT.Limite_Credito = Src.Limite_Credito
            
            -- Para insertar 
            WHEN NOT MATCHED BY TARGET THEN 
                INSERT (Num_Cli, Empresa, Rep_Cli, Limite_Credito)
                VALUES (Src.Num_Cli, Src.Empresa, Src.Rep_Cli, Src.Limite_Credito);

            -- Confirmar la transacción
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            DECLARE @MensajeError VARCHAR(100);
            SET @MensajeError = ERROR_MESSAGE();
            PRINT @MensajeError;
        END CATCH;
END;
GO


CREATE OR ALTER PROCEDURE spu_carga_delta_c1_c2
AS
BEGIN
    -- Programación del SP
    BEGIN TRANSACTION 
        BEGIN TRY
            -- Insertar nuevos registros de la tabla Clientes_Origen a Clientes
            INSERT INTO Clientes (Num_Cli, Empresa, Rep_Cli, Limite_Credito)
            SELECT c1.Num_Cli, c1.Empresa, c1.Rep_Cli, c1.Limite_Credito 
            FROM Clientes_Origen AS c1
            LEFT JOIN Clientes AS c2 ON c1.Num_Cli = c2.Num_Cli
            WHERE c2.Num_Cli IS NULL;

            -- Actualizar los registros que han tenido algún cambio en la tabla Clientes_Origen
            -- Se cambian en la tabla Clientes
            UPDATE c2 
            SET c2.Empresa = c1.Empresa,
                c2.Rep_Cli = c1.Rep_Cli,
                c2.Limite_Credito = c1.Limite_Credito
            FROM Clientes_Origen AS c1
            INNER JOIN Clientes AS c2 ON c1.Num_Cli = c2.Num_Cli;

            -- Confirmar la transacción
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            DECLARE @MensajeError VARCHAR(100);
            SET @MensajeError = ERROR_MESSAGE();
            PRINT @MensajeError;
        END CATCH;
END;
GO


create table PreciosHistoricos(
	ID int not null IDENTITY(1,1),
	ProductoID char(5),
	PrecioAnterior money,
	PrecioNuevo money,
	FechaModificacion date default getdate()
	);
	go


CREATE OR ALTER PROCEDURE actualizar_precios 
@id_producto char(5),
@nuevoPrecio MONEY
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @precioAnterior MONEY;

        -- Obtener el precio anterior del producto
        SELECT @precioAnterior = Precio 
        FROM Productos 
        WHERE Id_producto = @id_producto;

        -- Insertar el registro en la tabla de precios históricos
        INSERT INTO PreciosHistoricos (ProductoID, PrecioAnterior, PrecioNuevo)
        VALUES (@id_producto, @precioAnterior, @nuevoPrecio);

        -- Actualizar el precio del producto
        UPDATE Productos
        SET Precio = @nuevoPrecio
        WHERE Id_producto = @id_producto;

        -- Confirmar la transacción
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        DECLARE @MensajeError NVARCHAR(4000);
        SET @MensajeError = ERROR_MESSAGE();
        PRINT @MensajeError;
    END CATCH;
END;
GO



select * from PreciosHistoricos;
select * from Productos;

exec actualizar_precios 7, 666;


-- Crear un procedimiento almacenado para actualizar el límite de crédito de un cliente

CREATE PROCEDURE spActualizarLimiteCreditoCliente
    @Num_Cli INT,
    @Nuevo_Limite_Credito MONEY
AS
BEGIN
    UPDATE Clientes
    SET Limite_Credito = @Nuevo_Limite_Credito
    WHERE Num_Cli = @Num_Cli;
END
GO






CREATE PROCEDURE spActualizarOInsertarCliente
    @Num_Cli INT,
    @Empresa NVARCHAR(20),
    @Rep_Cli INT,
    @Limite_Credito MONEY
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Clientes WHERE Num_Cli = @Num_Cli)
    BEGIN
        -- Actualizar cliente existente
        UPDATE Clientes
        SET Empresa = @Empresa, Rep_Cli = @Rep_Cli, Limite_Credito = @Limite_Credito
        WHERE Num_Cli = @Num_Cli;
    END
    ELSE
    BEGIN
        -- Insertar nuevo cliente
        INSERT INTO Clientes (Num_Cli, Empresa, Rep_Cli, Limite_Credito)
        VALUES (@Num_Cli, @Empresa, @Rep_Cli, @Limite_Credito);
    END
END
GO


CREATE PROCEDURE spEliminarClienteSiNoTienePedidos
    @Num_Cli INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Pedidos WHERE Cliente = @Num_Cli)
    BEGIN
        DELETE FROM Clientes
        WHERE Num_Cli = @Num_Cli;
    END
    ELSE
    BEGIN
        PRINT 'El cliente tiene pedidos asociados y no puede ser eliminado.';
    END
END
GO


CREATE PROCEDURE spActualizarLimiteCreditoSiVentasSuperanUmbral
    @Num_Cli INT,
    @Nuevo_Limite_Credito MONEY,
    @UmbralVentas MONEY
AS
BEGIN
    DECLARE @TotalVentas MONEY;

    -- Obtener las ventas totales del cliente
    SELECT @TotalVentas = SUM(Importe)
    FROM Pedidos
    WHERE Cliente = @Num_Cli;

    -- Verificar si las ventas superan el umbral
    IF @TotalVentas > @UmbralVentas
    BEGIN
        -- Actualizar el límite de crédito
        UPDATE Clientes
        SET Limite_Credito = @Nuevo_Limite_Credito
        WHERE Num_Cli = @Num_Cli;
    END
    ELSE
    BEGIN
        PRINT 'Las ventas del cliente no superan el umbral especificado.';
    END
END
GO



CREATE PROCEDURE spCrearOActualizarProducto
    @Id_producto CHAR(5),
    @Descripcion NVARCHAR(20),
    @Precio MONEY,
    @Stock INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Productos WHERE Id_producto = @Id_producto)
    BEGIN
        -- Actualizar producto existente
        UPDATE Productos
        SET Descripcion = @Descripcion, Precio = @Precio, Stock = @Stock
        WHERE Id_producto = @Id_producto;
    END
    ELSE
    BEGIN
        -- Insertar nuevo producto
        INSERT INTO Productos (Id_producto, Descripcion, Precio, Stock)
        VALUES (@Id_producto, @Descripcion, @Precio, @Stock);
    END
END
GO



--Este procedimiento aumenta el límite de crédito de un cliente si el representante asociado tiene más de 5 años trabajando en la empresa.

CREATE PROCEDURE spAumentarLimiteCreditoPorAntiguedadRep
    @Num_Cli INT,
    @Incremento MONEY
AS
BEGIN
    DECLARE @FechaContrato DATE;
    DECLARE @Num_Empl INT;

    -- Obtener el representante del cliente
    SELECT @Num_Empl = Rep_Cli FROM Clientes WHERE Num_Cli = @Num_Cli;

    -- Obtener la fecha de contrato del representante
    SELECT @FechaContrato = Fecha_Contrato FROM Representantes WHERE Num_Empl = @Num_Empl;

    -- Verificar la antigüedad del representante
    IF DATEDIFF(YEAR, @FechaContrato, GETDATE()) >= 5
    BEGIN
        -- Aumentar el límite de crédito
        UPDATE Clientes
        SET Limite_Credito = Limite_Credito + @Incremento
        WHERE Num_Cli = @Num_Cli;
    END
    ELSE
    BEGIN
        PRINT 'El representante no tiene la antigüedad suficiente para aumentar el límite de crédito.';
    END
END
GO



--Este procedimiento actualiza el límite de crédito de un cliente si la edad de su representante es mayor a 30 años.

CREATE OR ALTER PROCEDURE spActualizarLimiteCreditoPorEdadRepresentante
    @Num_Cli INT,
    @Nuevo_Limite_Credito MONEY,
    @Mensaje NVARCHAR(50) OUTPUT
AS
BEGIN
    DECLARE @Edad INT;
    
    SELECT @Edad = r.Edad
    FROM Clientes c
    INNER JOIN Representantes r ON c.Rep_Cli = r.Num_Empl
    WHERE c.Num_Cli = @Num_Cli;

    IF @Edad > 30
    BEGIN
        UPDATE Clientes
        SET Limite_Credito = @Nuevo_Limite_Credito
        WHERE Num_Cli = @Num_Cli;
        
        SET @Mensaje = 'Límite de crédito actualizado correctamente';
    END
    ELSE
    BEGIN
        SET @Mensaje = 'No se puede actualizar el límite de crédito. La edad del representante es 30 o menor.';
    END
END
GO


--Este procedimiento verifica si el límite de crédito del cliente permite realizar el pedido antes de insertarlo.
CREATE OR ALTER PROCEDURE spVerificarLimiteCreditoYCrearPedido
    @Num_Cli INT,
    @NumeroPed INT,
    @Fecha DATE,
    @Repre INT,
    @Fab CHAR(3),
    @Prod CHAR(5),
    @Cantidad INT,
    @Mensaje NVARCHAR(50) OUTPUT
AS
BEGIN
    DECLARE @LimiteCredito MONEY;
    DECLARE @ImportePedido MONEY;
    DECLARE @TotalPedidos MONEY;

    SELECT @LimiteCredito = Limite_Credito
    FROM Clientes
    WHERE Num_Cli = @Num_Cli;

    SELECT @ImportePedido = @Cantidad * p.Precio
    FROM Productos p
    WHERE p.Id_fab = @Fab AND p.Id_producto = @Prod;

    SELECT @TotalPedidos = SUM(pe.Importe)
    FROM Pedidos pe
    WHERE pe.Cliente = @Num_Cli;

    IF (@TotalPedidos + @ImportePedido) <= @LimiteCredito
    BEGIN
        INSERT INTO Pedidos (Num_Pedido, Fecha_Pedido, Cliente, Rep, Producto, Cantidad, Importe)
        VALUES (@NumeroPed, @Fecha, @Num_Cli, @Repre, @Prod, @Cantidad, @ImportePedido);

        SET @Mensaje = 'Pedido creado correctamente';
    END
    ELSE
    BEGIN
        SET @Mensaje = 'Límite de crédito excedido. No se puede crear el pedido.';
    END
END
GO


--Este procedimiento actualiza la cuota y el puesto del representante si sus ventas superan un umbral específico.
CREATE OR ALTER PROCEDURE spActualizarRepresentantePorVentas
    @Num_Empl INT,
    @NuevaCuota MONEY,
    @NuevoPuesto NVARCHAR(20),
    @UmbralVentas MONEY,
    @Mensaje NVARCHAR(50) OUTPUT
AS
BEGIN
    DECLARE @VentasTotales MONEY;

    SELECT @VentasTotales = SUM(p.Importe)
    FROM Pedidos p
    WHERE p.Rep = @Num_Empl;

    IF @VentasTotales > @UmbralVentas
    BEGIN
        UPDATE Representantes
        SET Cuota = @NuevaCuota, Puesto = @NuevoPuesto
        WHERE Num_Empl = @Num_Empl;

        SET @Mensaje = 'Representante actualizado correctamente';
    END
    ELSE
    BEGIN
        SET @Mensaje = 'Las ventas del representante no superan el umbral especificado.';
    END
END
GO


--Este procedimiento elimina un cliente si no tiene pedidos pendientes.

CREATE OR ALTER PROCEDURE spEliminarClienteSiNoTienePedidosPendientes
    @Num_Cli INT,
    @Mensaje NVARCHAR(50) OUTPUT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Pedidos WHERE Cliente = @Num_Cli)
    BEGIN
        DELETE FROM Clientes
        WHERE Num_Cli = @Num_Cli;
        
        SET @Mensaje = 'Cliente eliminado correctamente';
    END
    ELSE
    BEGIN
        SET @Mensaje = 'El cliente tiene pedidos pendientes y no puede ser eliminado.';
    END
END
GO
