-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- MÓDULO      : Usuarios
-- OBJETO      : TABLA Clientes
-- PROPÓSITO   : Usuarios con Acceso al sistema desde la App
-- AUTOR       : Francisco David Medina Lourenzo 
-- FECHA CREA  : 2026-10-02

CREATE TABLE Roles (
    id INT IDENTITY(1,1) PRIMARY KEY,
    permiso NVARCHAR(50) NOT NULL UNIQUE,
    fecha_creacion DATETIME DEFAULT GETDATE()
);

CREATE TABLE Usuarios (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    rol_id INT NOT NULL,
    estado BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Rol FOREIGN KEY (rol_id) REFERENCES Roles(id)
);

CREATE INDEX IX_Usuarios_RolID ON Usuarios(rol_id);