-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- MÓDULO      : Movimiento de Inventario y Bitacora
-- OBJETO      : TABLAS VENTA , DETALLE VENTA
-- PROPÓSITO   :  
-- AUTOR       : Francisco David Medina Lourenzo 
-- FECHA CREA  : 2026-10-05


CREATE TABLE CondicionVenta(
    id INT IDENTITY(1,1) CONSTRAINT PK_CondicionVenta PRIMARY KEY,
    condicon NVARCHAR(20) NOT NULL UNIQUE
);

INSERT INTO CondicionVenta(condicon) VALUES('CONTADO'),('CREDITO');

CREATE TABLE Venta(
    id INT IDENTITY(1,1) CONSTRAINT PK_Venta PRIMARY KEY,
    numero_factura NVARCHAR(20) NOT NULL UNIQUE,
    fecha_venta DATETIME NOT NULL DEFAULT GETDate()

    id_cliente INT NOT NULL,
    id_condicionVenta INT NOT NULL, 
    fechaVencimiento DATE NULL,

    CONSTRAINT PK_Clientes FOREIGN KEY (id_cliente) REFERENCES Clientes(id),
    CONSTRAINT PK_CondicionVenta FOREIGN KEY (id_condicionVenta) REFERENCES CondicionVenta(id),
   

);