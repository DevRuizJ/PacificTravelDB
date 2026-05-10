CREATE database PacificTravelDB;

Use PacificTravelDB;

/**
1. Diseño de la Base de Datos: 
o Crear una base de datos que incluya las siguientes tablas: 
Clientes, Hoteles, Reservas, y Pagos. 
o Definir las relaciones entre estas tablas mediante claves primarias 
y foráneas.
**/

-- Tabla de Usuarios
CREATE TABLE T_User (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    NumeroDocumento NVARCHAR(30) NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    ApellidoPaterno NVARCHAR(100) NOT NULL,
    ApellidoMaterno NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber NVARCHAR(20),
    Direccion NVARCHAR(255) NOT NULL,
    Password NVARCHAR(255) NOT NULL,
    FechaRegistro DATETIME DEFAULT GETDATE()
);
GO

SELECT * FROM T_User;

INSERT INTO T_User(NumeroDocumento, Nombre, ApellidoPaterno, ApellidoMaterno, Email, PhoneNumber, Direccion, Password)
VALUES ('73456781', 'Carmen', 'Luque', 'Toledo', 'cluque@email.com', '983457123', 'Ate Vitarte', 'mango765');

-- Tabla de Clientes
CREATE TABLE T_Customer (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    NumeroDocumento NVARCHAR(30) NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    ApellidoPaterno NVARCHAR(100) NOT NULL,
    ApellidoMaterno NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber NVARCHAR(20),
    Direccion NVARCHAR(255) NOT NULL,
    FechaRegistro DATETIME DEFAULT GETDATE()
);
GO

SELECT * FROM T_Customer;

-- Tabla de Hoteles
CREATE TABLE T_Hotel (
    HotelID INT IDENTITY(1,1) PRIMARY KEY,
    HotelRUC NVARCHAR (11),
    Nombre NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber NVARCHAR(20),
    Direccion NVARCHAR(255) NOT NULL,
    FechaRegistro DATETIME DEFAULT GETDATE()
);
GO

SELECT * FROM T_Hotel;

INSERT INTO T_Hotel (HotelRUC, Nombre, Email, PhoneNumber, Direccion)
VALUES('20874567891', 'Hotel Rengifo', 'rengifoHotel@email.com', '51 7652456', 'Urb Castilla 873 Calle Libertadores');

-- Tabla de Transacciones
CREATE TABLE T_Transaccion (
    TransaccionID INT IDENTITY(1,1) PRIMARY KEY,
    CodigoTransaccion NVARCHAR(10) NOT NULL,
    UserID INT FOREIGN KEY REFERENCES T_User(UserId),
    MontoTotal Decimal(19,4) NOT NULL,
    Descripcion NVARCHAR(MAX) NOT NULL,
    FechaTransaccion DATE NOT NULL,
    FechaRegistro DATETIME DEFAULT GETDATE()
);
GO

SELECT * FROM T_Transaccion;


INSERT INTO T_Transaccion (CodigoTransaccion, HotelID, UserID, MontoTotal, Descripcion, FechaTransaccion)
VALUES('B002-00002', 3, 4, 700.00, 'Reserva por aniversario', '2025-03-17');

-- Tabla de Reservas Cabecera
CREATE TABLE T_Reserva_Header (
    ReservaHeaderID INT IDENTITY(1,1) PRIMARY KEY,
    CodigoReserva NVARCHAR(10) NOT NULL,
    HotelID INT FOREIGN KEY REFERENCES T_Hotel(HotelID),
    TransaccionID INT FOREIGN KEY REFERENCES T_Transaccion(TransaccionID),
    UserID INT FOREIGN KEY REFERENCES T_User(UserID),--Usuario que realiza la reserva
    FechaReserva DATE NOT NULL,
    FechaRegistro DATETIME DEFAULT GETDATE()
);
GO

SELECT * FROM T_Reserva_Header;

INSERT INTO T_Reserva_Header (CodigoReserva, HotelID, TransaccionID, UserID, FechaReserva)
VALUES('RA34761', 2, 8, 2, '2025-03-01');


-- Tabla de Reservas Detalle
CREATE TABLE T_Reserva_Detail (
    ReservaDetailID INT IDENTITY(1,1) PRIMARY KEY,
    ReservaHeaderID INT FOREIGN KEY REFERENCES T_Reserva_Header(ReservaHeaderID),
    PosicionCustomer TINYINT NOT NULL,
    CustomerID INT FOREIGN KEY REFERENCES T_Customer(CustomerID),--Cliente incluido en el grupo de reserva
    IsConfirmed BIT DEFAULT 1,
    FechaRegistro DATETIME DEFAULT GETDATE()
);
GO

SELECT * FROM T_Reserva_Detail;

-- Tabla de Roles
CREATE TABLE T_Rol (
    RolID INT IDENTITY(1,1) PRIMARY KEY,
    CodigoRol NVARCHAR(10) NOT NULL,
    Nombre NVARCHAR(50) NOT NULL,
    FechaRegistro DATETIME DEFAULT GETDATE()
);
GO

-- Tabla de Permisos
CREATE TABLE T_Permiso (
    PermisoID INT IDENTITY(1,1) PRIMARY KEY,
    CodigoPermiso NVARCHAR(10) NOT NULL,
    Nombre NVARCHAR(100) NOT NULL UNIQUE,
    FechaRegistro DATETIME DEFAULT GETDATE()
);
GO

-- Tabla de Asignacion de Roles
CREATE TABLE T_UserRol (
	UserRolID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES T_User(UserID),
    RolID INT FOREIGN KEY REFERENCES T_Rol(RolID),
    FechaRegistro DATETIME DEFAULT GETDATE()
);
GO

-- Tabla de Asignacion de Permisos
CREATE TABLE T_PermisoRol (
	RolPermisoID INT IDENTITY(1,1) PRIMARY KEY,
    PermisoID INT FOREIGN KEY REFERENCES T_Permiso(PermisoID),
    RolID INT FOREIGN KEY REFERENCES T_Rol(RolID),
    FechaRegistro DATETIME DEFAULT GETDATE()
);
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
/**
 2. Consultas SQL: 
o Formular consultas que respondan a preguntas clave de la 
empresa, tales como: 

▪ ¿Cuántas reservas se realizaron en un mes específico? **/
SELECT COUNT(*) AS Total_Reservas_MES
FROM T_Hotel ho
INNER JOIN T_Transaccion tr 
	ON ho.HotelID = tr.HotelID
INNER JOIN T_Reserva_Header rh
	ON tr.TransaccionID = rh.TransaccionID 
WHERE MONTH(rh.FechaReserva) = '3';


/**
▪ ¿Cuáles son los cinco hoteles más reservados? **/
SELECT TOP 5 ho.HotelRUC,
		ho.Nombre,
		COUNT(rh.HotelID) AS Total_Reservas
FROM T_Hotel ho
INNER JOIN T_Transaccion tr 
	ON ho.HotelID = tr.HotelID
INNER JOIN T_Reserva_Header rh
	ON tr.TransaccionID = rh.TransaccionID
GROUP BY ho.HotelRUC, ho.Nombre
ORDER BY Total_Reservas DESC;
		

/**
▪ ¿Quién es el cliente que más ha gastado en reservas
durante el último año? **/
SELECT TOP 1  CONCAT(us.ApellidoPaterno, ' ', us.ApellidoMaterno, ', ', us.Nombre),
		SUM(tr.MontoTotal) AS Monto_Total_Pagado
FROM T_User us
INNER JOIN T_Transaccion tr 
    ON us.UserID = tr.UserID
GROUP BY 
    us.UserID,
    us.Nombre,
    us.ApellidoPaterno,
    us.ApellidoMaterno 
ORDER BY Monto_Total_Pagado DESC;

---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------

--CREAR USUARIO
CREATE PROCEDURE CreateUser
    @Nombre NVARCHAR(100),
    @Email NVARCHAR(100),
    @Contrase�a NVARCHAR(255)
AS
BEGIN
    INSERT INTO T_User (Nombre, Email, Password)
    VALUES (@Nombre, @Email, @Contrase�a);
END;
GO


--RESERVAR Hotel
CREATE PROCEDURE ReservarActividad
    @UsuarioID INT,
    @ActividadID INT
AS
BEGIN
    INSERT INTO Reservas (UsuarioID, ActividadID)
    VALUES (@UsuarioID, @ActividadID);
END;
GO


--GESTION DE ROLES Y PERMISOS
-- Asignar Rol a Usuario
CREATE PROCEDURE AsignarRolUsuario
    @UsuarioID INT,
    @RolID INT
AS
BEGIN
    INSERT INTO UserRol (UsuarioID, RolID)
    VALUES (@UsuarioID, @RolID);
END;
GO

-- Asignar Permiso a Rol
CREATE PROCEDURE AsignarPermisoRol
    @RolID INT,
    @PermisoID INT
AS
BEGIN
    INSERT INTO AsignacionPermisos (RolID, PermisoID)
    VALUES (@RolID, @PermisoID);
END;
GO

-- Crear Rol
CREATE PROCEDURE CrearRol
    @Nombre NVARCHAR(50)
AS
BEGIN
    INSERT INTO Roles (Nombre)
    VALUES (@Nombre);
END;
GO

-- Crear Permiso
CREATE PROCEDURE CrearPermiso
    @Nombre NVARCHAR(100)
AS
BEGIN
    INSERT INTO Permisos (Nombre)
    VALUES (@Nombre);
END;
GO

