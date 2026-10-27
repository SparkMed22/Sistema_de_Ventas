-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- MÓDULO      : Movimiento de Inventario y Bitacora
-- OBJETO      : TABLAS VENTA , DETALLE VENTA
-- AUTOR       : Francisco David Medina Lourenzo 
-- FECHA CREA  : 2026-10-24


CREATE TABLE CondicionVenta(
    id INT IDENTITY(1,1) CONSTRAINT PK_CondicionVenta PRIMARY KEY,
    condicon NVARCHAR(20) NOT NULL UNIQUE
);


CREATE TABLE Venta (
    id INT IDENTITY(1,1) NOT NULL,
    numero_factura NVARCHAR(20) NOT NULL,
    fecha_venta DATETIME2 NOT NULL CONSTRAINT DF_Venta_FechaVenta DEFAULT SYSDATETIME(),
    id_cliente INT NOT NULL,
    total DECIMAL(18,2) NOT NULL CONSTRAINT DF_Venta_Total DEFAULT 0,
    pendiente DECIMAL(18,2) NOT NULL CONSTRAINT DF_Venta_Pendiente DEFAULT 0,
    id_condicionVenta INT NOT NULL,
    fechaVencimiento DATE NULL,
    CONSTRAINT PK_Venta PRIMARY KEY (id),
    CONSTRAINT UQ_Venta_NumeroFactura UNIQUE (numero_factura),
    CONSTRAINT FK_Venta_Clientes FOREIGN KEY (id_cliente) REFERENCES Clientes(id),
    CONSTRAINT FK_Venta_CondicionVenta FOREIGN KEY (id_condicionVenta) REFERENCES CondicionVenta(id),
    CONSTRAINT CK_Venta_Total CHECK (total >= 0),
    CONSTRAINT CK_Venta_Pendiente CHECK (pendiente >= 0 AND pendiente <= total)
);


CREATE TABLE VentaDetalle(
    id INT IDENTITY(1,1) CONSTRAINT PK_VentaDetalle PRIMARY KEY,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CONSTRAINT DF_Cantidad DEFAULT 1,
    precio_unitario DECIMAL(18,2) DEFAULT 0.00,
    porcentaje_iva DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT FK_VentaDetalle_Venta FOREIGN KEY (id_venta) REFERENCES Venta(id),
    CONSTRAINT FK_VentaDetalle_Producto FOREIGN KEY (id_producto) REFERENCES Producto(id),
    CONSTRAINT CK_VentaDetalle_Cantidad CHECK (cantidad > 0),
    CONSTRAINT CK_VentaDetalle_Precio CHECK (precio_unitario >= 0)
);


CREATE NONCLUSTERED INDEX IX_Venta_fecha ON Venta(fecha_venta);
CREATE NONCLUSTERED INDEX IX_VentaDetalle_venta ON VentaDetalle(id_venta);
CREATE NONCLUSTERED INDEX IX_VentaDetalle_producto ON VentaDetalle(id_producto);


DROP TABLE VentaDetalle;