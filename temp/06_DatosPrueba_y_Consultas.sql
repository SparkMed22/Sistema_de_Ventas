-- MÓDULO      : Datos de prueba y consultas de reportes
-- BASE        : ModuloVentasDB (SQL Server)
-- REQUISITO   : haber ejecutado antes las tablas (00 a 03), los procedimientos y init_240027.sql
--               (Clientes 1-5, Depósitos 1-3, Productos 1-29)
-- CONTENIDO   : A) Tablas Venta / VentaDetalle / Cobro corregidas (T-SQL)
--               B) Datos de prueba (13 facturas, cobros totales y parciales)
--               C) Consulta 1: Ventas por fecha y depósito
--                  Consulta 2: Facturas de venta pendientes de pago
--                  Consulta 3: Productos que no se vendieron en un rango de fechas

USE ModuloVentasDB;
GO

-- ====================================
-- ?   A) TABLAS CORREGIDAS
-- ====================================
DROP TABLE IF EXISTS Cobro_factura;
DROP TABLE IF EXISTS Cobro_forma_pago;
DROP TABLE IF EXISTS Cobro;
DROP TABLE IF EXISTS Forma_pago;
DROP TABLE IF EXISTS VentaDetalle;
DROP TABLE IF EXISTS Venta;
GO

IF OBJECT_ID('dbo.CondicionVenta') IS NULL
    CREATE TABLE CondicionVenta(
        id INT IDENTITY(1,1) CONSTRAINT PK_CondicionVenta PRIMARY KEY,
        condicon NVARCHAR(20) NOT NULL UNIQUE
    );
GO

IF NOT EXISTS (SELECT 1 FROM CondicionVenta WHERE condicon = 'CONTADO')
    INSERT INTO CondicionVenta(condicon) VALUES ('CONTADO');
IF NOT EXISTS (SELECT 1 FROM CondicionVenta WHERE condicon = 'CREDITO')
    INSERT INTO CondicionVenta(condicon) VALUES ('CREDITO');
GO

-- Se agrega id_deposito: la consulta 1 necesita saber desde qué depósito se vendió
CREATE TABLE Venta(
    id INT IDENTITY(1,1) CONSTRAINT PK_Venta PRIMARY KEY,
    numero_factura NVARCHAR(20) NOT NULL UNIQUE,
    fecha_venta DATETIME NOT NULL DEFAULT GETDATE(),
    id_cliente INT NOT NULL,
    id_deposito INT NOT NULL,
    id_condicionVenta INT NOT NULL,
    fechaVencimiento DATE NULL,
    CONSTRAINT FK_Venta_Clientes FOREIGN KEY (id_cliente) REFERENCES Clientes(id),
    CONSTRAINT FK_Venta_Deposito FOREIGN KEY (id_deposito) REFERENCES Deposito(id),
    CONSTRAINT FK_Venta_CondicionVenta FOREIGN KEY (id_condicionVenta) REFERENCES CondicionVenta(id)
);

-- precio_unitario y porcentaje_iva se guardan en la venta (el precio del producto puede cambiar después)
-- precio_unitario es SIN IVA, igual que Producto.precio
CREATE TABLE VentaDetalle(
    id INT IDENTITY(1,1) CONSTRAINT PK_VentaDetalle PRIMARY KEY,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(18,2) NOT NULL,
    porcentaje_iva DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT FK_VentaDetalle_Venta FOREIGN KEY (id_venta) REFERENCES Venta(id),
    CONSTRAINT FK_VentaDetalle_Producto FOREIGN KEY (id_producto) REFERENCES Producto(id),
    CONSTRAINT CK_VentaDetalle_Cantidad CHECK (cantidad > 0),
    CONSTRAINT CK_VentaDetalle_Precio CHECK (precio_unitario >= 0)
);

CREATE NONCLUSTERED INDEX IX_Venta_fecha ON Venta(fecha_venta);
CREATE NONCLUSTERED INDEX IX_VentaDetalle_venta ON VentaDetalle(id_venta);
CREATE NONCLUSTERED INDEX IX_VentaDetalle_producto ON VentaDetalle(id_producto);

-- Cobros (el 05_Cobro.sql original estaba en sintaxis MySQL)
CREATE TABLE Forma_pago(
    id_forma_pago INT IDENTITY(1,1) CONSTRAINT PK_Forma_pago PRIMARY KEY,
    descripcion VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Cobro(
    id_cobro INT IDENTITY(1,1) CONSTRAINT PK_Cobro PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_pago DATE NOT NULL,
    CONSTRAINT FK_Cobro_Clientes FOREIGN KEY (id_cliente) REFERENCES Clientes(id)
);

CREATE TABLE Cobro_forma_pago(
    id_cobro INT NOT NULL,
    id_forma_pago INT NOT NULL,
    importe DECIMAL(18,2) NOT NULL,
    CONSTRAINT PK_Cobro_forma_pago PRIMARY KEY (id_cobro, id_forma_pago),
    CONSTRAINT FK_CobroFP_Cobro FOREIGN KEY (id_cobro) REFERENCES Cobro(id_cobro),
    CONSTRAINT FK_CobroFP_FormaPago FOREIGN KEY (id_forma_pago) REFERENCES Forma_pago(id_forma_pago)
);

-- importe_aplicado: parte del cobro que cancela esta factura (IVA incluido)
-- iva: porción de IVA contenida en importe_aplicado
CREATE TABLE Cobro_factura(
    id_cobro INT NOT NULL,
    id_venta INT NOT NULL,
    importe_aplicado DECIMAL(18,2) NOT NULL,
    iva DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT PK_Cobro_factura PRIMARY KEY (id_cobro, id_venta),
    CONSTRAINT FK_CobroFA_Cobro FOREIGN KEY (id_cobro) REFERENCES Cobro(id_cobro),
    CONSTRAINT FK_CobroFA_Venta FOREIGN KEY (id_venta) REFERENCES Venta(id),
    CONSTRAINT CK_CobroFA_Importe CHECK (importe_aplicado > 0)
);
GO

-- Vista auxiliar: subtotal, IVA y total de cada factura
CREATE OR ALTER VIEW dbo.vw_VentaTotal AS
SELECT
    vd.id_venta,
    CAST(SUM(vd.cantidad * vd.precio_unitario) AS DECIMAL(18,2)) AS subtotal,
    CAST(ROUND(SUM(vd.cantidad * vd.precio_unitario * vd.porcentaje_iva / 100.0), 2) AS DECIMAL(18,2)) AS iva,
    CAST(SUM(vd.cantidad * vd.precio_unitario)
         + ROUND(SUM(vd.cantidad * vd.precio_unitario * vd.porcentaje_iva / 100.0), 2) AS DECIMAL(18,2)) AS total
FROM VentaDetalle vd
GROUP BY vd.id_venta;
GO


-- ====================================
-- ?   B) DATOS DE PRUEBA
-- ====================================
INSERT INTO Forma_pago(descripcion) VALUES ('Efectivo'), ('Transferencia'), ('Tarjeta');

-- Cabeceras: (factura, fecha, cliente, depósito, condición 1=CONTADO 2=CREDITO, vencimiento)
INSERT INTO Venta(numero_factura, fecha_venta, id_cliente, id_deposito, id_condicionVenta, fechaVencimiento) VALUES
('001-001-0000001', '2026-09-02 09:30', 1, 2, 1, NULL),
('001-001-0000002', '2026-09-05 11:15', 2, 1, 2, '2026-10-05'),
('001-001-0000003', '2026-09-10 16:40', 3, 2, 1, NULL),
('001-001-0000004', '2026-09-18 10:05', 4, 1, 2, '2026-10-18'),
('001-001-0000005', '2026-09-25 17:20', 1, 2, 1, NULL),
('001-001-0000006', '2026-10-01 08:50', 5, 3, 2, '2026-11-01'),
('001-001-0000007', '2026-10-03 12:10', 2, 1, 1, NULL),
('001-001-0000008', '2026-10-08 15:35', 3, 2, 2, '2026-11-08'),
('001-001-0000009', '2026-10-12 09:00', 1, 1, 2, '2026-11-12'),
('001-001-0000010', '2026-10-15 13:25', 4, 2, 1, NULL),
('001-001-0000011', '2026-10-19 10:45', 3, 3, 2, '2026-11-19'),
('001-001-0000012', '2026-10-20 09:15', 2, 2, 1, NULL),
('001-001-0000013', '2026-10-20 18:00', 5, 2, 1, NULL);   -- misma fecha y depósito que la 12

-- Detalles: (factura, producto, cantidad); precio e IVA se toman del producto
CREATE TABLE #det(numero_factura NVARCHAR(20), id_producto INT, cantidad INT);
INSERT INTO #det VALUES
('001-001-0000001', 2, 4), ('001-001-0000001', 23, 1),
('001-001-0000002', 3, 4), ('001-001-0000002', 25, 1),
('001-001-0000003', 9, 6), ('001-001-0000003', 15, 1), ('001-001-0000003', 23, 1),
('001-001-0000004', 12, 2), ('001-001-0000004', 10, 1),
('001-001-0000005', 20, 1), ('001-001-0000005', 29, 1),
('001-001-0000006', 5, 4), ('001-001-0000006', 24, 1),
('001-001-0000007', 6, 2),
('001-001-0000008', 19, 2), ('001-001-0000008', 26, 1),
('001-001-0000009', 4, 4), ('001-001-0000009', 2, 2),
('001-001-0000010', 9, 3), ('001-001-0000010', 14, 2),
('001-001-0000011', 13, 1), ('001-001-0000011', 16, 2),
('001-001-0000012', 22, 4), ('001-001-0000012', 28, 1),
('001-001-0000013', 17, 1), ('001-001-0000013', 18, 1);

INSERT INTO VentaDetalle(id_venta, id_producto, cantidad, precio_unitario, porcentaje_iva)
SELECT v.id, p.id, d.cantidad, p.precio,
       CASE WHEN p.pagaIVA = 1 THEN p.porcentaje_iva ELSE 0 END
FROM #det d
INNER JOIN Venta v ON v.numero_factura = d.numero_factura
INNER JOIN Producto p ON p.id = d.id_producto;

DROP TABLE #det;
GO

-- Cobros: (factura, fecha, forma de pago, % de la factura que se cobra)
-- Contado = 100% el mismo día. Crédito: 002 pago parcial en 2 cuotas (queda 50%),
-- 006 parcial (queda 60%), 008 pagada completa, 004 / 009 / 011 sin pagos.
CREATE TABLE #pagos(numero_factura NVARCHAR(20), fecha_pago DATE, id_forma_pago INT, porcentaje DECIMAL(5,2));
INSERT INTO #pagos VALUES
('001-001-0000001', '2026-09-02', 1, 100),
('001-001-0000002', '2026-09-15', 2, 30),
('001-001-0000002', '2026-09-28', 2, 20),
('001-001-0000003', '2026-09-10', 3, 100),
('001-001-0000005', '2026-09-25', 1, 100),
('001-001-0000006', '2026-10-10', 2, 40),
('001-001-0000007', '2026-10-03', 1, 100),
('001-001-0000008', '2026-10-14', 2, 100),
('001-001-0000010', '2026-10-15', 3, 100),
('001-001-0000012', '2026-10-20', 1, 100),
('001-001-0000013', '2026-10-20', 1, 100);

DECLARE @fac NVARCHAR(20), @fecha DATE, @forma INT, @pct DECIMAL(5,2);
DECLARE @idVenta INT, @idCliente INT, @idCobro INT, @monto DECIMAL(18,2), @iva DECIMAL(18,2);

DECLARE c CURSOR LOCAL FAST_FORWARD FOR
    SELECT numero_factura, fecha_pago, id_forma_pago, porcentaje FROM #pagos ORDER BY fecha_pago;
OPEN c;
FETCH NEXT FROM c INTO @fac, @fecha, @forma, @pct;
WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @idVenta = v.id,
           @idCliente = v.id_cliente,
           @monto = ROUND(t.total * @pct / 100, 2),
           @iva = ROUND(t.iva * @pct / 100, 2)
    FROM Venta v
    INNER JOIN vw_VentaTotal t ON t.id_venta = v.id
    WHERE v.numero_factura = @fac;

    INSERT INTO Cobro(id_cliente, fecha_pago) VALUES (@idCliente, @fecha);
    SET @idCobro = SCOPE_IDENTITY();
    INSERT INTO Cobro_forma_pago(id_cobro, id_forma_pago, importe) VALUES (@idCobro, @forma, @monto);
    INSERT INTO Cobro_factura(id_cobro, id_venta, importe_aplicado, iva) VALUES (@idCobro, @idVenta, @monto, @iva);

    FETCH NEXT FROM c INTO @fac, @fecha, @forma, @pct;
END
CLOSE c;
DEALLOCATE c;
DROP TABLE #pagos;
GO


-- ====================================
-- ?   C) CONSULTAS
-- ====================================

-- ------------------------------------------------------------
-- CONSULTA 1: Importe total de ventas por fecha y depósito
-- Parámetros: rango de fechas (ambas incluidas)
-- ------------------------------------------------------------
DECLARE @desde DATE = '2026-09-01';
DECLARE @hasta DATE = '2026-10-31';

SELECT
    CAST(v.fecha_venta AS DATE)  AS Fecha,
    d.id                         AS Codigo_Deposito,
    d.nombre                     AS Deposito,
    SUM(t.total)                 AS Importe_Total_Ventas
FROM Venta v
INNER JOIN Deposito d       ON d.id = v.id_deposito
INNER JOIN vw_VentaTotal t  ON t.id_venta = v.id
WHERE v.fecha_venta >= @desde
  AND v.fecha_venta <  DATEADD(DAY, 1, @hasta)   -- incluye todo el día @hasta
GROUP BY CAST(v.fecha_venta AS DATE), d.id, d.nombre
ORDER BY Fecha, d.id;
GO

-- ------------------------------------------------------------
-- CONSULTA 2: Facturas de venta pendientes de pago
-- Saldo = total de la factura - suma de lo cobrado (Cobro_factura)
-- ------------------------------------------------------------
SELECT
    v.numero_factura                        AS Factura,
    CAST(v.fecha_venta AS DATE)             AS Fecha,
    c.id                                    AS Codigo_Cliente,
    c.nombre                                AS Cliente,
    t.total                                 AS Importe_Total_Factura,
    t.total - ISNULL(p.pagado, 0)           AS Saldo_Factura
FROM Venta v
INNER JOIN Clientes c       ON c.id = v.id_cliente
INNER JOIN vw_VentaTotal t  ON t.id_venta = v.id
LEFT JOIN (
    SELECT id_venta, SUM(importe_aplicado) AS pagado
    FROM Cobro_factura
    GROUP BY id_venta
) p ON p.id_venta = v.id
WHERE t.total - ISNULL(p.pagado, 0) > 0
ORDER BY v.fecha_venta;
GO

-- ------------------------------------------------------------
-- CONSULTA 3: Productos que NO se vendieron en un rango de fechas
-- La "última fecha de venta" es la última vez que se vendió en toda la historia
-- (NULL = nunca se vendió). Incluye servicios; agregar p.es_servicio = 0 para excluirlos.
-- ------------------------------------------------------------
DECLARE @desde DATE = '2026-10-01';
DECLARE @hasta DATE = '2026-10-31';

SELECT
    p.id            AS Producto,
    p.descripcion   AS Descripcion,
    p.compra        AS Precio_Compra,
    (SELECT MAX(v2.fecha_venta)
       FROM VentaDetalle vd2
       INNER JOIN Venta v2 ON v2.id = vd2.id_venta
      WHERE vd2.id_producto = p.id) AS Ultima_Fecha_Venta
FROM Producto p
WHERE p.estado = 1
  AND NOT EXISTS (
        SELECT 1
        FROM VentaDetalle vd
        INNER JOIN Venta v ON v.id = vd.id_venta
        WHERE vd.id_producto = p.id
          AND v.fecha_venta >= @desde
          AND v.fecha_venta <  DATEADD(DAY, 1, @hasta)
  )
ORDER BY Ultima_Fecha_Venta DESC, p.id;
GO
