-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- MÓDULO      : Movimiento de Inventario y Bitacora
-- OBJETO      : TABLAS Producto , Deposito, INVENTARIO
-- PROPÓSITO   : Comprobantes de transferencia y movimientos generales en el deposito 
-- AUTOR       : Francisco David Medina Lourenzo 
-- FECHA CREACION  : 2026-10-05

CREATE TABLE TransferenciaCabeceraDesposito(
    id INT IDENTITY(1,1) CONSTRAINT PK_TransferenciaCabeceraDesposito PRIMARY KEY,
    fechaHora DATETIME NOT NULL DEFAULT GETDATE(),
    id_dep_origen INT NOT NULL,
    id_dep_destino INT NOT NULL,
    id_usuario_encargado INT NOT NULL,
    id_usuario_autorizo INT NOT NULL,
    obs_operacion NVARCHAR(255) NULL,
    estado BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Deposito_Origen FOREIGN KEY (id_dep_origen) REFERENCES Deposito(id),
    CONSTRAINT FK_Deposito_Destino FOREIGN KEY (id_dep_destino) REFERENCES Deposito(id),
    CONSTRAINT FK_Usuario_encargado FOREIGN KEY (id_usuario_encargado) REFERENCES Usuarios(id),
    CONSTRAINT FK_Usuario_autorizo FOREIGN KEY (id_usuario_autorizo) REFERENCES Usuarios(id),
    CONSTRAINT CK_Transferencia CHECK (id_dep_origen<>id_dep_destino)
);


CREATE TABLE TransferenciaDetalleDesposito(
    id INT IDENTITY(1,1) CONSTRAINT PK_TransferenciaDetalle PRIMARY KEY,
    id_TransferenciaCabeceraDesposito INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    CONSTRAINT FK_TransferenciaCabeceraDesposito FOREIGN KEY (id_TransferenciaCabeceraDesposito) REFERENCES TransferenciaCabeceraDesposito(id),
    CONSTRAINT FK_Productos FOREIGN KEY (id_producto) REFERENCES Producto(id),
    CONSTRAINT CK_TransferenciaDetalle CHECK(cantidad > 0)
);