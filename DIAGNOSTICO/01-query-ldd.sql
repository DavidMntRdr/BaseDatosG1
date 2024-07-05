-- Lenguaje de Definición de Datos (SQL-LDD)
-- Crear base de datos tiendadigital

create database tiendadigital;
go

-- Cambiar Base de datos
use tiendadigital;
go

-- Crear la tabla Proveedor
create table proveedor(
 proveedorid int not null identity (1,1),
 numcontrol varchar(30) not null,
 nombreempresa varchar(50) not null, 
 cp int not null,
 calle varchar(50) not null,
 colonia varchar(50) not null,
 numero int,
 estado varchar(20) not null,
 telefono varchar(20),
 paginaweb varchar (30)
 constraint pk_proveedor
 primary key(proveedorid),
 constraint unico_numcontrol
 unique(numcontrol),
 constraint unico_nombreempresa
 unique(nombreempresa)
);
go

--crear tabla
create table categoria(
 categoriaid int not null,
 descripcion varchar(100) not null,
 constraint pk_categoria
 primary key(categoriaid),
 constraint unico_descripcion
 unique(descripcion)
);
go

-- crear tabla producto
create table producto(
 productoid int not null identity(1,1),
 numerocontrol varchar(30) not null,
 descripcion varchar(100) not null,
 precio money not null,
 existencia int not null,
 [status] int not null,
 categoriaid int not null,
 constraint pk_producto
 primary key (productoid),
 constraint unico_numerocontrol
 unique(numerocontrol),
 constraint unico_descripcion_producto
 unique(descripcion),
 constraint chk_precio
 check (precio>0.0),
 constraint chk_existencia
 check (existencia between 1 and 2000),
 constraint chk_status
 --check([status] =0 or [status] =1)
 check([status] in (0,1)),
 constraint fk_producto_categoria
 foreign key(categoriaid)
 references categoria(categoriaid)
);
go

create table cliente(
  clienteid int not null identity (1,1),
  numerocontrol varchar(20) not null,
  nombreEmpresa varchar(50) not null default 'Mostrador',
  rfc varchar(20) not null,
  direccionfiscal varchar(100),
  limiteCredito money,
  constraint pk_cliente
  primary key (clienteid),
  constraint unico_numerocontrol_cliente
  unique(numerocontrol),
  constraint unico_rfc_cliente
  unique(rfc),
  constraint chk_limite_credito
  check (limiteCredito>=0 and limiteCredito>=100000)
);
go

create table empleado(
	empleadoid int not null identity (1,1),
	numeronomina int not null,
	nombrecomlpeto varchar(50) not null,
	apellido1 varchar(20) not null,
	apellido2 varchar(20),
	rfc varchar(20) not null,
	curp varchar(20) not null,
	salario money,
	constraint pk_empleado primary key(empleadoid),
	constraint unico_numeronomina
	unique(numeronomina),
	constraint unico_rfc_empleado
	unique(rfc),
	constraint unico_curp_empleado
	unique(curp),
	constraint chk_salario
	check (salario>0.0)
);
go

create table ordencompra(
	compraid int not null identity(1,1),
	fechaorden date not null,
	fechaentrega date not null,
	clienteid int not null,
	empleadoid int not null,
	constraint pk_ordencompra
	primary key(compraid),
	constraint fk_ordencompra_cliente
	foreign key(clienteid) 
	references cliente(clienteid),
	constraint fk_ordencompra_empleado
	foreign key(empleadoid) 
	references empleado(empleadoid)
);
go

create table detalleorden(
	ordenid int not null,
	productoid int not null,
	cantidad int not null,
	preciocompra money not null,
	constraint pk_detalleorden
	primary key (ordenid, productoid),
	constraint fk_detalleorden_orden
	foreign key(ordenid)
	references ordencompra(compraid),
	constraint fk_detalleorden_producto
	foreign key(productoid)
	references producto(productoid)
);
go

create table contactoproveedor(
	contactoid int not null, 
	proveedorid int not null,
	nombrecompleto varchar(50),
	apellido1 varchar(20) not null,
	apellido2 varchar(20),
	email varchar(20),
	constraint pk_contactoproveedor
	primary key (contactoid, proveedorid),
	constraint fk_contactoproveedor_proveedor
	foreign key (proveedorid)
	references proveedor(proveedorid),
);
go

create table telefonocontacto(
	telefonoid int not null,
	contactoid int not null,
	proveedorid int not null,
	numerotelefono varchar(20) not null,
);

alter table telefonocontacto
add constraint pk_telefonocontacto
primary key (telefonoid);

--eliminar un constraint 
/*alter table telefonocontacto 
drop constraint pk_telefonoid */

alter table telefonocontacto 
add constraint fk_telefonocontacto_contactoproveedor
foreign key (contactoid, proveedorid)
references contactoproveedor(contactoid, proveedorid)
 
alter table producto 
add proveedorid int not null

alter table producto
add constraint fk_producto_proveedor
foreign key (proveedorid)
references proveedor(proveedorid)