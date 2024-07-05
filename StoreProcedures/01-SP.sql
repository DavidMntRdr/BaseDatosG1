use NORTHWND;

--Declaración y uso de variables en transact-sql

--Declaración de una variable.
declare @numeroCal int 
declare @calif DECIMAL (10,2)

--Asignación de variables 
set @numeroCal = 10
If @numeroCal <= 0 
begin set @numeroCal = 1
end 
declare @i = 1
while (@i<=@numeroCal)
begin 
 set @calif = @calif + 10
 set @i = @i +1
 end 
set @calif = @calif/@numeroCal
print ('El resultado es: ' + @calif)