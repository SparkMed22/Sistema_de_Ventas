CREATE TABLE Forma_pago(
    id_forma_pago INT NOT NULL AUTO_INCREMENT,
    descripcion VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_forma_pago)
);

CREATE TABLE Cobro (
    id_cobro INT NOT NULL AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    fecha_pago DATE NOT NULL,
    PRIMARY KEY (id_cobro),
    CONSTRAINT FK_COBRO_REFERENCE_CLIENTE
        FOREIGN KEY (id_cliente) REFERENCES (id_cliente)
);

CREATE TABLE Cobro_forma_pago(
    id_cobro INT NOT NULL,
    id_forma_pago INT NOT NULL,
    importe INT NOT NULL,
    PRIMARY KEY (id_cobro, id_forma_pago),
    CONSTRAINT FK_COBRO_FO_REFERENCE_COBRO
        FOREIGN KEY (id_cobro) REFERENCES Cobro (id_cobro),
    CONSTRAINT FK_COBRO_FO_REFERENCE_FORMA_PA
        FOREIGN KEY (id_forma_pago) REFERENCES Forma_pago (id_forma_pago)
);

CREATE TABLE Cobro_factura (
    id_cobro    INT NOT NULL,
    id_venta    INT NOT NULL,
    importe_aplicado INT NOT NULL,
    iva     INT NOT NULL,
    PRIMARY KEY (id_cobro, id_venta),
    CONSTRAINT FK_COBRO_FA_REFERENCE_COBRO
        FOREIGN KEY (id_cobro) REFERENCES Cobro (id_cobro),
    CONSTRAINT FK_COBRO_FA_REFERENCE_VENTA
        FOREIGN KEY(id_venta) REFERENCES Venta (id_venta)
);