Create database pruebatriggersG1;
GO
use pruebatriggersG1;
GO
create table empleado(
    idempleado int not null PRIMARY key,
    nombreEmpl varchar(30) not null,
    apellido1 varchar(15) not null,
    apellido2 varchar(15),
    salario money not NULL
);
GO 

create or alter TRIGGER tg_1
on empleado 
after insert
as 
begin
    print 'se ejecuto el trigger tg_1, en el evento insert'
END

select * from empleado;

insert into empleado
values(2, 'Rocío', 'Cruz', 'Cervantes', 20000);



drop TRIGGER tg_1;
GO

create or alter TRIGGER tg_2
on empleado
after insert 
as 
BEGIN
    select * from inserted;
    select * from deleted;
end;
go 

drop TRIGGER tg_1;
GO

create or alter TRIGGER tg_3
on empleado
after delete 
as 
BEGIN
    select * from inserted;
    select * from deleted;
end;
go 


delete empleado 
where idempleado = 2;


create or alter TRIGGER tg_4
on empleado
after update 
as 
BEGIN
    select * from inserted;
    select * from deleted;
end;
go 

select * from empleado;

update empleado 
set nombreEmpl= 'Pancracio',
    salario = 10000
where idempleado = 1;
go



create or alter TRIGGER tg_5
on empleado
after insert, delete 
as 
BEGIN
    if exists (select 1 from inserted)
    BEGIN
    PRINT 'Se realizo un insert'   
    end
    else if exists (select 1 from deleted) AND
    not exists (select 1 from inserted)
    begin 
        PRINT 'se realizo un delete'
        END
END;
go 

insert into empleado 
values (2, 'Leslie', 'Jimenez', 'Nery', 10000)

delete from empleado
where idempleado = 2;



Update empleado 
set salario = 75000,
nombreEmpl='Artemio'
where idempleado=1;
