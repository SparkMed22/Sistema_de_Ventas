-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- MÓDULO      : Facturas
-- OBJETO      : TABLAS CondicionVenta , Factura, FacturaDetalle
-- AUTOR       : Francisco David Medina Lourenzo 
-- FECHA CREA  : 2026-10-24


CREATE TABLE CondicionVenta(
    id INT IDENTITY(1,1) CONSTRAINT PK_CondicionVenta PRIMARY KEY,
    condicon NVARCHAR(20) NOT NULL UNIQUE
);

-- ? total : CUENTA TOTAL
-- ? pendiente : FALTA PAGAR (A CREDITO),  EMITIDO (FACTURA CREADA)

CREATE TABLE Factura (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    numero_factura NVARCHAR(20) NOT NULL UNIQUE,
    id_usuario INT NOT NULL,
    id_cliente INT NOT NULL,
    id_deposito INT NOT NULL,
    id_condicionVenta INT NOT NULL,
    total DECIMAL(18,2) NOT NULL CONSTRAINT DF_Factura_Total DEFAULT 0,
    pendiente DECIMAL(18,2) NOT NULL CONSTRAINT DF_Factura_Pendiente DEFAULT 0,
    fechaVencimiento DATE NULL,
    fecha_venta DATETIME2 NOT NULL CONSTRAINT DF_Factura_FechaVenta DEFAULT SYSDATETIME(),
    estado NVARCHAR(20) NOT NULL CONSTRAINT DF_Factura_Estado DEFAULT N'EMITIDA',

    CONSTRAINT FK_Factura_Usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id),
    CONSTRAINT FK_Factura_Clientes FOREIGN KEY (id_cliente) REFERENCES Clientes(id),
    CONSTRAINT FK_Factura_Deposito FOREIGN KEY (id_deposito) REFERENCES Deposito(id),
    CONSTRAINT FK_Factura_CondicionVenta FOREIGN KEY (id_condicionVenta) REFERENCES CondicionVenta(id),
    CONSTRAINT CK_Factura_Total CHECK (total >= 0),
    CONSTRAINT CK_Factura_Pendiente CHECK (pendiente >= 0 AND pendiente <= total),
    CONSTRAINT CK_Factura_Estado CHECK (estado IN (N'EMITIDA', N'ANULADA', N'PENDIENTE'))
);



CREATE TABLE FacturaDetalle(
    id INT IDENTITY(1,1) CONSTRAINT PK_FacturaDetalle PRIMARY KEY,
    id_factura INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CONSTRAINT DF_Cantidad DEFAULT 1,
    porsentaje_descuento DECIMAL(18,2) DEFAULT 0.00,
    porcentaje_iva DECIMAL(18,2) NOT NULL DEFAULT 0.00,

    precio_unitario DECIMAL(18,2) DEFAULT 0.00,
    precio_venta DECIMAL(18,2) DEFAULT 0.00,

    CONSTRAINT FK_FacturaDetalle_Venta FOREIGN KEY (id_factura) REFERENCES Factura(id),
    CONSTRAINT FK_FacturaDetalle_Producto FOREIGN KEY (id_producto) REFERENCES Producto(id),
    CONSTRAINT CK_FacturaDetalle_Cantidad CHECK (cantidad > 0),
    CONSTRAINT CK_FacturaDetalle_Precio CHECK (precio_unitario >= 0),
    CONSTRAINT CK_FacturaDetalle_Venta CHECK (precio_venta >= 0)
);


CREATE NONCLUSTERED INDEX IX_Venta_fecha ON Factura(fecha_venta);
CREATE NONCLUSTERED INDEX IX_FacturaDetalle_venta ON FacturaDetalle(id_factura);
CREATE NONCLUSTERED INDEX IX_FacturaDetalle_producto ON FacturaDetalle(id_producto);

