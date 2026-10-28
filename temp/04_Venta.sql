/*
============================================================
BASE DE DATOS : ModuloVentasDB
MODULO        : Ventas
PROPOSITO     : Gestionar ventas, detalles, cobros y pagos.
AUTOR         : Francisco David Medina Lourenzo
FECHA         : 05/10/2026
============================================================

IMPORTANTE:
- Se necesitan las tablas dbo.Clientes y dbo.Producto.
- Se supone que Clientes tiene la columna id.
- Se supone que Producto tiene la columna id.
- No se eliminan tablas ni registros existentes.
*/

USE Sistema_de_Ventas;
GO

/* =========================================================
   TABLA: CondicionVenta
   PROPOSITO: Guardar las condiciones de venta.
   ========================================================= */

IF OBJECT_ID('dbo.CondicionVenta', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CondicionVenta (
        id INT IDENTITY(1,1) NOT NULL,
        condicion NVARCHAR(20) NOT NULL,

        CONSTRAINT PK_CondicionVenta
            PRIMARY KEY (id),

        CONSTRAINT UQ_CondicionVenta_Condicion
            UNIQUE (condicion)
    );
END;
GO

-- Cargar las condiciones iniciales sin duplicarlas.

IF NOT EXISTS (
    SELECT 1
    FROM dbo.CondicionVenta
    WHERE condicion = N'CONTADO'
)
BEGIN
    INSERT INTO dbo.CondicionVenta (condicion)
    VALUES (N'CONTADO');
END;

IF NOT EXISTS (
    SELECT 1
    FROM dbo.CondicionVenta
    WHERE condicion = N'CREDITO'
)
BEGIN
    INSERT INTO dbo.CondicionVenta (condicion)
    VALUES (N'CREDITO');
END;
GO


/* =========================================================
   TABLA: FormaPago
   PROPOSITO: Registrar los medios de pago disponibles.
   ========================================================= */

IF OBJECT_ID('dbo.FormaPago', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.FormaPago (
        id INT IDENTITY(1,1) NOT NULL,
        id_forma_pago NVARCHAR(50) NOT NULL,
        descripcion NVARCHAR(150) NULL,

        activo BIT NOT NULL
            CONSTRAINT DF_FormaPago_Activo
            DEFAULT (1),

        CONSTRAINT PK_FormaPago
            PRIMARY KEY (id),

        CONSTRAINT UQ_FormaPago_Nombre
            UNIQUE (id_forma_pago)
    );
END;
GO

-- Cargar formas de pago sin repetir registros.

IF NOT EXISTS (
    SELECT 1 FROM dbo.FormaPago
    WHERE id_forma_pago = N'EFECTIVO'
)
BEGIN
    INSERT INTO dbo.FormaPago
        (id_forma_pago, descripcion)
    VALUES
        (N'EFECTIVO', N'Pago en efectivo');
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.FormaPago
    WHERE id_forma_pago = N'TARJETA'
)
BEGIN
    INSERT INTO dbo.FormaPago
        (id_forma_pago, descripcion)
    VALUES
        (N'TARJETA', N'Pago con tarjeta');
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.FormaPago
    WHERE id_forma_pago = N'TRANSFERENCIA'
)
BEGIN
    INSERT INTO dbo.FormaPago
        (id_forma_pago, descripcion)
    VALUES
        (N'TRANSFERENCIA', N'Transferencia bancaria');
END;

IF NOT EXISTS (
    SELECT 1 FROM dbo.FormaPago
    WHERE id_forma_pago = N'CHEQUE'
)
BEGIN
    INSERT INTO dbo.FormaPago
        (id_forma_pago, descripcion)
    VALUES
        (N'CHEQUE', N'Pago con cheque');
END;
GO


/* =========================================================
   TABLA: Venta
   PROPOSITO: Registrar las facturas de venta.
   RELACIONES: Clientes y CondicionVenta.
   ========================================================= */

IF OBJECT_ID('dbo.Venta', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Venta (
        id INT IDENTITY(1,1) NOT NULL,

        numero_factura NVARCHAR(20) NOT NULL,

        fecha_venta DATETIME2(0) NOT NULL
            CONSTRAINT DF_Venta_FechaVenta
            DEFAULT (SYSDATETIME()),

        id_cliente INT NOT NULL,
        id_condicionVenta INT NOT NULL,

        fechaVencimiento DATE NULL,

        estado NVARCHAR(20) NOT NULL
            CONSTRAINT DF_Venta_Estado
            DEFAULT (N'EMITIDA'),

        observacion NVARCHAR(300) NULL,

        CONSTRAINT PK_Venta
            PRIMARY KEY (id),

        CONSTRAINT UQ_Venta_NumeroFactura
            UNIQUE (numero_factura),

        CONSTRAINT FK_Venta_Clientes
            FOREIGN KEY (id_cliente)
            REFERENCES dbo.Clientes(id),

        CONSTRAINT FK_Venta_CondicionVenta
            FOREIGN KEY (id_condicionVenta)
            REFERENCES dbo.CondicionVenta(id),

        CONSTRAINT CK_Venta_Estado
            CHECK (
                estado IN (
                    N'EMITIDA',
                    N'ANULADA',
                    N'PAGADA',
                    N'PENDIENTE'
                )
            )
    );
END;
GO


/* =========================================================
   TABLA: DetalleVenta
   PROPOSITO: Registrar productos vendidos, cantidades,
   precios, descuentos e IVA.
   RELACIONES: Venta y Producto.
   ========================================================= */

IF OBJECT_ID('dbo.DetalleVenta', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.DetalleVenta (
        id INT IDENTITY(1,1) NOT NULL,

        id_venta INT NOT NULL,
        id_producto INT NOT NULL,

        cantidad DECIMAL(18,3) NOT NULL,
        precio_unitario DECIMAL(18,2) NOT NULL,

        descuento_pct DECIMAL(5,2) NOT NULL
            CONSTRAINT DF_DetalleVenta_Descuento
            DEFAULT (0),

        porcentaje_iva DECIMAL(5,2) NOT NULL
            CONSTRAINT DF_DetalleVenta_IVA
            DEFAULT (10),

        CONSTRAINT PK_DetalleVenta
            PRIMARY KEY (id),

        CONSTRAINT FK_DetalleVenta_Venta
            FOREIGN KEY (id_venta)
            REFERENCES dbo.Venta(id),

        CONSTRAINT FK_DetalleVenta_Producto
            FOREIGN KEY (id_producto)
            REFERENCES dbo.Producto(id),

        CONSTRAINT CK_DetalleVenta_Cantidad
            CHECK (cantidad > 0),

        CONSTRAINT CK_DetalleVenta_Precio
            CHECK (precio_unitario >= 0),

        CONSTRAINT CK_DetalleVenta_Descuento
            CHECK (descuento_pct BETWEEN 0 AND 100),

        CONSTRAINT CK_DetalleVenta_IVA
            CHECK (porcentaje_iva IN (0, 5, 10))
    );
END;
GO


/* =========================================================
   TABLA: Cobro
   PROPOSITO: Registrar los cobros recibidos de clientes.
   RELACION: Clientes.
   ========================================================= */

IF OBJECT_ID('dbo.Cobro', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Cobro (
        id_cobro INT IDENTITY(1,1) NOT NULL,

        id_cliente INT NOT NULL,

        fecha_pago DATETIME2(0) NOT NULL
            CONSTRAINT DF_Cobro_FechaPago
            DEFAULT (SYSDATETIME()),

        monto DECIMAL(18,2) NOT NULL,

        observacion NVARCHAR(300) NULL,

        CONSTRAINT PK_Cobro
            PRIMARY KEY (id_cobro),

        CONSTRAINT FK_Cobro_Cliente
            FOREIGN KEY (id_cliente)
            REFERENCES dbo.Clientes(id),

        CONSTRAINT CK_Cobro_Monto
            CHECK (monto > 0)
    );
END;
GO
ALTER TABLE dbo.Cobro
ADD monto DECIMAL(12,2) NULL,
    observacion NVARCHAR(255) NULL;
GO

/* =========================================================
   TABLA: CobroFactura
   PROPOSITO: Relacionar los cobros con las facturas.
   RELACIONES: Cobro y Venta.
   ========================================================= */

IF OBJECT_ID('dbo.CobroFactura', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CobroFactura (
        id_cobro INT NOT NULL,
        id_venta INT NOT NULL,

        importe_aplicado DECIMAL(18,2) NOT NULL,

        CONSTRAINT PK_CobroFactura
            PRIMARY KEY (id_cobro, id_venta),

        CONSTRAINT FK_CobroFactura_Cobro
            FOREIGN KEY (id_cobro)
            REFERENCES dbo.Cobro(id_cobro),

        CONSTRAINT FK_CobroFactura_Venta
            FOREIGN KEY (id_venta)
            REFERENCES dbo.Venta(id),

        CONSTRAINT CK_CobroFactura_Importe
            CHECK (importe_aplicado > 0)
    );
END;
GO


/* =========================================================
   TABLA: CobroFormaPago
   PROPOSITO: Detallar los medios utilizados en cada cobro.
   RELACIONES: Cobro y FormaPago.
   ========================================================= */

IF OBJECT_ID('dbo.CobroFormaPago', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CobroFormaPago (
        id_cobro INT NOT NULL,
        id_forma_pago INT NOT NULL,

        monto DECIMAL(18,2) NOT NULL,
        referencia NVARCHAR(100) NULL,

        CONSTRAINT PK_CobroFormaPago
            PRIMARY KEY (id_cobro, id_forma_pago),

        CONSTRAINT FK_CobroFormaPago_Cobro
            FOREIGN KEY (id_cobro)
            REFERENCES dbo.Cobro(id_cobro),

        CONSTRAINT FK_CobroFormaPago_FormaPago
            FOREIGN KEY (id_forma_pago)
            REFERENCES dbo.FormaPago(id),

        CONSTRAINT CK_CobroFormaPago_Monto
            CHECK (monto > 0)
    );
END;
GO