CREATE database PacificTravelDB;

Use PacificTravelDB;

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

-- Tabla de Transacciones
CREATE TABLE T_Transaccion (
    TransaccionID INT IDENTITY(1,1) PRIMARY KEY,
    CodigoTransaccion NVARCHAR(10) NOT NULL,
    HotelID INT FOREIGN KEY REFERENCES T_Hotel(HotelID),
    UserID INT FOREIGN KEY REFERENCES T_User(UserId),
    MontoTotal Decimal(19,4) NOT NULL,
    Descripcion NVARCHAR(MAX) NOT NULL,
    FechaTransaccion DATE NOT NULL,
    FechaRegistro DATETIME DEFAULT GETDATE()
);
GO

SELECT * FROM T_Transaccion;

-- Tabla de Reservas Cabecera
CREATE TABLE T_Reserva_Header (
    ReservaHeaderID INT IDENTITY(1,1) PRIMARY KEY,
    CodigoReserva NVARCHAR(10) NOT NULL,
    TransaccionID INT FOREIGN KEY REFERENCES T_Transaccion(TransaccionID),
    UserID INT FOREIGN KEY REFERENCES T_User(UserID),--Usuario que realiza la reserva
    FechaReserva DATE NOT NULL,
    FechaRegistro DATETIME DEFAULT GETDATE()
);
GO

SELECT * FROM T_Reserva_Header;


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

