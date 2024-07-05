CREATE OR ALTER TRIGGER trg_UpdateDimEmpleado
ON pruebacargadinamica.dbo.empleado
AFTER INSERT, UPDATE
AS
BEGIN
    MERGE INTO pruebacargadinamica.dbo.dim_empleado AS target
    USING (
        SELECT 
            e.FirstName, e.LastName,
            e.[Address] AS Direccion,
            e.HomePhone AS Telefono
        FROM inserted e
    ) AS source ON target.FirstName = source.FirstName
    WHEN MATCHED THEN
        UPDATE SET
            [Address] = source.Direccion,
            HomePhone = source.Telefono
    WHEN NOT MATCHED THEN
        INSERT (FirstName, LastNAme, [Address], HomePhone, Country)
        VALUES (source.FirstName, source.LastNAme, source.Direccion, source.Telefono, 0);
END;

