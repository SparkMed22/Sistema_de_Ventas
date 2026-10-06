-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB

-- MÓDULO      : Productos e Inventario
-- OBJETO      : TABLA Prodcuto
-- PROPÓSITO   : Almacenar los datos de los productos
-- AUTOR       : Francisco David Medina Lourenzo 
-- FECHA CREA  : 2026-10-02


CREATE TABLE Marcas(
    id INT IDENTITY(1,1) CONSTRAINT PK_MARCAS PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE TiposProducto(
    id INT IDENTITY(1,1) CONSTRAINT PK_TiposProducto PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL UNIQUE
);

-- marca_id : Puede ser nulo al ser un servicio 
-- compra   : A cuanto fue comprado el producto por el dueño del local
-- venta    : Precio de venta al publico 
-- estado   : Borrar un producto pero sin sacar de la base de datos

CREATE TABLE Producto(
    id INT IDENTITY(1,1) CONSTRAINT PK_Productos PRIMARY KEY,
    descripcion NVARCHAR(255) NOT NULL,
    es_servicio BIT NOT NULL,
    marca_id INT NULL,  
    tipo_producto_id INT NOT NULL,
    precio DECIMAL(18, 2) NOT NULL DEFAULT 0.00,
    compra DECIMAL(18, 2) NOT NULL DEFAULT 0.00,
    pagaIVA BIT NOT NULL DEFAULT 1,
    porcentaje_iva DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    estado BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Marcas FOREIGN KEY (marca_id) REFERENCES Marcas(id),
    CONSTRAINT FK_TiposProducto FOREIGN KEY (tipo_producto_id) REFERENCES TiposProducto(id),
    CONSTRAINT CK_Producto_PorcentajeIVA CHECK (porcentaje_iva >= 0 AND porcentaje_iva <= 100)
);



CREATE TABLE TipoDeposito (
    id TINYINT IDENTITY(1,1) CONSTRAINT PK_TipoDeposito PRIMARY KEY,
    nombre NVARCHAR(20) NOT NULL UNIQUE
);

-- estado: El deposito sigue funcionando 
CREATE TABLE Deposito (
    id INT IDENTITY(1,1) CONSTRAINT PK_Deposito PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL UNIQUE,
    estado BIT NOT NULL DEFAULT 1,
    idTipoDeposito TINYINT NOT NULL,
    direccion NVARCHAR(50) NOT NULL,
    CONSTRAINT FK_Deposito_TipoDeposito FOREIGN KEY (idTipoDeposito) REFERENCES TipoDeposito(id)
);


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
