-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- MÓDULO      : Ventas
-- OBJETO      : TABLA Clientes
-- PROPÓSITO   : Almacenar los datos de los clientes del sistema.
-- AUTOR       : Francisco David Medina Lourenzo 
-- FECHA CREA  : 2026-09-15



-- credito: Dinero disponible 
-- saldo  : Deuda del Cliente
CREATE TABLE Clientes (
    id INT IDENTITY(1,1) CONSTRAINT PK_Clientes PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL CONSTRAINT CK_Clientes_Nombre CHECK (LEN(TRIM(nombre)) >= 2),
    cedula NVARCHAR(20) NOT NULL CONSTRAINT CK_Clientes_Cedula CHECK (LEN(TRIM(cedula)) >= 6),
    direccion NVARCHAR(70) NOT NULL,
    telefono VARCHAR(20) NOT NULL 
        CONSTRAINT CK_Clientes_Telefono CHECK (LEN(telefono) >= 7 AND telefono NOT LIKE '%[^0-9 ()+-]%'),
    email VARCHAR(255) NOT NULL
        CONSTRAINT UQ_Clientes_Email UNIQUE,
        CONSTRAINT CK_Clientes_EmailValido CHECK (
            email LIKE '%_@__%.__%'          
            AND email NOT LIKE '%@%@%'       
            AND email NOT LIKE '%..%'        
            AND email NOT LIKE ' %'          
            AND email NOT LIKE '% '          
            AND PATINDEX('%[^a-zA-Z0-9._@+-]%', email) = 0),
    credito DECIMAL(19,4) DEFAULT 0.00 CONSTRAINT CK_Clientes_Credito CHECK (credito >= 0),
    saldo DECIMAL(19,4) DEFAULT 0.00 CONSTRAINT CK_Clientes_Saldo CHECK (saldo >= 0),
    fecha_creacion DATETIME DEFAULT GETDATE()
);
