-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB

-- MÓDULO      : Productos e Inventario
-- OBJETO      : TABLA Prodcuto
-- PROPÓSITO   : Almacenar los datos de los productos
-- AUTOR       : Francisco David Medina Lourenzo 
-- FECHA CREA  : 2026-10-02


-- ====================================
-- ?            PRODUCTOS 
-- ====================================

CREATE TABLE Marcas(
    id INT IDENTITY(1,1) CONSTRAINT PK_MARCAS PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE TiposProducto(
    id INT IDENTITY(1,1) CONSTRAINT PK_TiposProducto PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL UNIQUE
);

-- ? es_servicio = 0: Es producto físico (neumático, filtro), 1: Es servicio/mano de obra
-- ? marca_id : Marca del producto (puede ser NULL en caso de ser un servicio)
-- ? precio_venta   : Precio o costo al que el dueño del local compró el producto
-- ? precio_compra   : Precio de venta final al público
-- ? estado   : Permite realizar un borrado lógico (0 = Inactivo/Descontinuado, 1 = Activo)
-- ? tipo_producto_id : tipo_producto_id = 1 es un servicio
CREATE TABLE Producto(
    id INT IDENTITY(1,1) CONSTRAINT PK_Productos PRIMARY KEY,
    descripcion NVARCHAR(255) NOT NULL,
    es_servicio BIT NOT NULL DEFAULT 0,
    marca_id INT NULL,
    tipo_producto_id INT NOT NULL,
    precio_venta DECIMAL(18, 2) NOT NULL DEFAULT 0.00,
    precio_compra DECIMAL(18, 2) NOT NULL DEFAULT 0.00, 
    pagaIVA BIT NOT NULL DEFAULT 1,
    porcentaje_iva DECIMAL(18,2) NOT NULL DEFAULT 10.00, 
    estado BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Marcas FOREIGN KEY (marca_id) REFERENCES Marcas(id),
    CONSTRAINT FK_TiposProducto FOREIGN KEY (tipo_producto_id) REFERENCES TiposProducto(id),
    CONSTRAINT CK_Producto_PreciosPositivos CHECK (precio_venta >= 0 AND precio_compra >= 0),
    CONSTRAINT CK_Producto_PorcentajeIVA CHECK (porcentaje_iva >= 0 AND porcentaje_iva <= 100),
    CONSTRAINT CK_Producto_IVA_Coherencia CHECK ((pagaIVA = 0 AND porcentaje_iva = 0) OR (pagaIVA = 1 AND porcentaje_iva > 0))
);
CREATE NONCLUSTERED INDEX IX_Producto_marca_id ON Producto(marca_id);
CREATE NONCLUSTERED INDEX IX_Producto_tipo_producto_id ON Producto(tipo_producto_id);
CREATE NONCLUSTERED INDEX IX_Producto_estado ON Producto(estado);





-- ====================================
-- ?            DEPOSITO
-- ====================================
CREATE TABLE TipoDeposito (
    id TINYINT IDENTITY(1,1) CONSTRAINT PK_TipoDeposito PRIMARY KEY,
    nombre NVARCHAR(20) NOT NULL UNIQUE
);


-- estado: El deposito sigue funcionando 
CREATE TABLE Deposito (
    id INT IDENTITY(1,1) CONSTRAINT PK_Deposito PRIMARY KEY,
    codigo_establecimiento NVARCHAR(3) NOT NULL UNIQUE,
    nombre NVARCHAR(50) NOT NULL UNIQUE,
    direccion NVARCHAR(150) NOT NULL, 
    idTipoDeposito TINYINT NOT NULL,
    estado BIT NOT NULL CONSTRAINT DF_Deposito_estado DEFAULT 1, 
    CONSTRAINT FK_Deposito_TipoDeposito FOREIGN KEY (idTipoDeposito) REFERENCES TipoDeposito(id)
);

CREATE NONCLUSTERED INDEX IX_Deposito_idTipoDeposito ON Deposito(idTipoDeposito);



-- ====================================
-- ?            INVENTARIO
-- ====================================
-- PK_StockDeposito: es la llave primaria
-- stock: numeros enteros por unidad
CREATE TABLE Inventario (
    id INT IDENTITY(1,1) CONSTRAINT PK_Inventario PRIMARY KEY,
    deposito_id INT NOT NULL,
    producto_id int NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    CONSTRAINT FK_Deposito FOREIGN KEY (deposito_id) REFERENCES Deposito(id),
    CONSTRAINT FK_Producto FOREIGN KEY (producto_id) REFERENCES Producto(id),    
    CONSTRAINT CK_Stock CHECK (stock >= 0)
);
