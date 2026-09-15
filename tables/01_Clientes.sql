-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- MÓDULO      : Ventas
-- OBJETO      : TABLA Clientes
-- PROPÓSITO   : Almacenar los datos de los clientes del sistema.
-- AUTOR       : Francisco David Medina Lourenzo 
-- FECHA CREA  : 2026-09-15

CREATE TABLE Clientes (
    id INT IDENTITY(1,1) CONSTRAINT PK_Clientes PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL,
    direccion NVARCHAR(70) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL,

    -- RESTRICCIONES (CONSTRAINTS)
    CONSTRAINT UQ_Clientes_Email UNIQUE (email),
    CONSTRAINT CK_Clientes_EmailValido CHECK (
        email LIKE '%_@__%.__%'  
        AND email NOT LIKE '%[% #$%^&*()!~`+=/\\,<>?:]%'  
        AND email NOT LIKE '%@%@%'                       
        AND email NOT LIKE '%..%'
    )
);
GO