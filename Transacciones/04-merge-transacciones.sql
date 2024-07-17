--Sintaxis

--MERGE INTO <target table> AS TGT
--USING <SOURCE TABLE> AS SRC  
--  ON <merge predicate>
--WHEN MATCHED [AND <predicate>] -- two clauses allowed:  
--  THEN <action> -- one with UPDATE one with DELETE
--WHEN NOT MATCHED [BY TARGET] [AND <predicate>] -- one clause allowed:  
--  THEN INSERT... –- if indicated, action must be INSERT
--WHEN NOT MATCHED BY SOURCE [AND <predicate>] -- two clauses allowed:  
--  THEN <action>; -- one with UPDATE one with DELETE

Create database mergeEscuelita;
use mergeEscuelita;
go

CREATE TABLE StudentsC1(
    StudentID       INT
    ,StudentName    VARCHAR(50)
    ,StudentStatus  BIT
);
GO

INSERT INTO StudentsC1(StudentID, StudentName, StudentStatus) VALUES(1,'Axel Romero',1)
INSERT INTO StudentsC1(StudentID, StudentName, StudentStatus) VALUES(2,'Sofía Mora',1)
INSERT INTO StudentsC1(StudentID, StudentName, StudentStatus) VALUES(3,'Rogelio Rojas',0)
INSERT INTO StudentsC1(StudentID, StudentName, StudentStatus) VALUES(4,'Mariana Rosas',1)
INSERT INTO StudentsC1(StudentID, StudentName, StudentStatus) VALUES(5,'Roman Zavaleta',1)
GO

CREATE TABLE StudentsC2(
    StudentID       INT
    ,StudentName    VARCHAR(50)
    ,StudentStatus  BIT
);
GO

select * from StudentsC1;
select * from StudentsC2;

select * from StudentsC1 as c1
Inner join StudentsC2 as c2
on c1.StudentID = c2.StudentID


select * from StudentsC1 as c1
Left join StudentsC2 as c2
on c1.StudentID = c2.StudentID


select * from StudentsC1 as c1
Inner join StudentsC2 as c2
on c1.StudentID = c2.StudentID


select * from StudentsC1 as c1
Left join StudentsC2 as c2
on c1.StudentID = c2.StudentID
where c2.StudentID IS null;



insert into StudentsC2 
values (1, 'Axel Romero', 0)

go


select c1.StudentID, c1.StudentName, c1.StudentStatus from StudentsC1 as c1
Left join StudentsC2 as c2
on c1.StudentID = c2.StudentID
where c2.StudentID IS null;



select c1.StudentID, c1.StudentID, c1.StudentStatus from StudentsC1 as c1
Inner join StudentsC2 as c2
on c1.StudentID = c2.StudentID
GO

truncate table StudentsC2;
GO

-------------------------------------------Store Procedure --------------------------------------------

--Store procedure que agrega y actualiza los registros nuevos y registros modificados de la tabla 
--StudentC1 a StudentsC2, utilizando consultas con left join e inner join.

create or alter proc spu_carga_delta_s1_s2
--Parametros 
as
begin
	--Programación del SP
	BEGIN TRANSACTION 
		BEGIN TRY
			--Procedimiento a ejecutar de forma exitosa
			INSERT INTO StudentsC2 (StudentID, StudentName, StudentStatus)
			select c1.StudentID, c1.StudentName, c1.StudentStatus from StudentsC1 as c1
			Left join StudentsC2 as c2
			on c1.StudentID = c2.StudentID
			where c2.StudentID IS null;

			--Se actualizan los registros que han tenido algun cambio en la tabla source (StudentC1)
			--Se cambian en la tabla tarjet (StudentsC2).
			UPDATE c2 
			set c2.StudentName = c1.StudentName,
				c2.StudentStatus = c1.StudentStatus
			from StudentsC1 as c1
			Inner join StudentsC2 as c2
			on c1.StudentID = c2.StudentID;

			--Confirmar la transaccion
			commit transaction;
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			DECLARE @MensaJeError varchar(100);
			set @MensaJeError = ERROR_MESSAGE();
			print @MensaJeError;
			--Insertar nuevos registros de la tabla Student1 a Student2
		END CATCH;
end;
go

EXEC spu_carga_delta_s1_s2;

go


--------------------------------------------------------------------------------


select c1.StudentID, c1.StudentName, c1.StudentStatus from StudentsC1 as c1
Left join StudentsC2 as c2
on c1.StudentID = c2.StudentID
where c2.StudentID IS null;



select c1.StudentID, c1.StudentID, c1.StudentStatus from StudentsC1 as c1
Inner join StudentsC2 as c2
on c1.StudentID = c2.StudentID
GO

select * from StudentsC1
select * from StudentsC2


Update StudentsC1 
set StudentName = 'Axel Ramero'
where StudentID = 1;

go


Update StudentsC1 
set StudentStatus = '1'
where StudentID = 3;

Update StudentsC1 
set StudentStatus = 0
where StudentID in (1,4,5)

Update StudentsC1 
set StudentName = 'Mariana Rosas'
where StudentID = 4;

Update StudentsC1 
set StudentName = 'Roman Zavaleta'
where StudentID = 5;

insert into StudentsC1 values (6, 'Monico Hernandez', 0);



select @@VERSION;
go
---------------------------------------------------------- SP-------------------------------------

--Store procedure que agrega y actualiza los registros nuevos y registros modificados de la tabla 
--StudentC1 a StudentsC2, utilizando la funcion merge


create or alter proc spu_carga_delta_s1_s2_merge
--Parametros 
as
begin
	--Programación del SP
	BEGIN TRANSACTION 
		BEGIN TRY
			MERGE INTO StudentsC2 AS TGT
			USING (
				select StudentID, StudentName, StudentStatus 
				from StudentsC1
			)AS Src
			on (
				TGT.StudentID = Src.StudentID
			)
			--Para actualizar 
			When matched then
				update 
				set TGT.StudentName = Src.StudentName,
					TGT.StudentStatus = Src.StudentStatus
			
			--Para insertar 
			When not matched then 
			Insert (StudentID, StudentName, StudentStatus)
			values (Src.StudentID, Src.StudentName, Src.StudentStatus);

			--Confirmar la transaccion
			commit transaction;
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			DECLARE @MensaJeError varchar(100);
			set @MensaJeError = ERROR_MESSAGE();
			print @MensaJeError;
			--Insertar nuevos registros de la tabla Student1 a Student2
		END CATCH;
end;
go


truncate table StudentsC2;

select * from StudentsC1
Select * from StudentsC2

exec spu_carga_delta_s1_s2_merge;
go


update
StudentsC1 set StudentName = 'Juana de Arco'
where StudentID = 2;
go


create or alter proc spu_carga_delta_s1_s3
--Parametros 
as
begin
	--Programación del SP
	BEGIN TRANSACTION 
		BEGIN TRY
			--Hacer eliminaciones que se hicieron en el source y se afecten en el target
			delete from StudentsC2 
			select*
			from StudentsC1 as c1
			right join
			StudentsC2 as c2
			on c1.StudentID = c2.StudentID
			where c1.studentid is null
			
			--Confirmar la transaccion
			commit transaction;
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			DECLARE @MensaJeError varchar(100);
			set @MensaJeError = ERROR_MESSAGE();
			print @MensaJeError;
			--Insertar nuevos registros de la tabla Student1 a Student2
		END CATCH;
end;
go



create or alter proc spu_carga_delta_s1_s4_merge
--Parametros 
as
begin
	--Programación del SP
	BEGIN TRANSACTION 
		BEGIN TRY
			MERGE INTO StudentsC2 AS TGT
			USING (
				select StudentID, StudentName, StudentStatus 
				from StudentsC1
			)AS Src
			on (
				TGT.StudentID = Src.StudentID
			)
			--Confirmar la transaccion
			WHEN NOT MATCHED BY SOURCE THEN DELETE;
			commit transaction;
			
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			DECLARE @MensaJeError varchar(100);
			set @MensaJeError = ERROR_MESSAGE();
			print @MensaJeError;
			--Insertar nuevos registros de la tabla Student1 a Student2
		END CATCH;
end;
go


		
