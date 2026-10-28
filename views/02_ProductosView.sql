-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- PROPÓSITO   : Vistas de Productos
-- AUTOR       : Francisco David Medina Lourenzo 
-- FECHA CREACION  : 2026-10-23


-- ====================================
-- ?            PRODUCTO
-- ====================================

DROP VIEW dbo.vw_productos;

CREATE OR ALTER VIEW dbo.vw_productos AS
SELECT 
    p.id AS [IDENTIFICADOR DE PRODUCTO],
    p.descripcion AS [DESCRIPCION],
    ISNULL(m.nombre, 'Servicio') AS [MARCA],
    CASE p.es_servicio
        WHEN 1 THEN 'SI'
        ELSE 'NO'
    END AS [SERVICIO],
    p.precio_venta AS [PRECIO DE VENTA],
    p.precio_compra  AS [PRECIO DE COMPRA],
    CASE p.pagaIVA
        WHEN 1 THEN 'SI'
        ELSE 'NO' 
    END AS [PAGA IVA],
    p.porcentaje_iva AS [PORCENTAJE DE IVA],
    dbo.fn_CalcularPrecioConIVA(pagaIVA,porcentaje_iva,precio_venta) AS [VENTA],
    CASE p.estado
        WHEN 1 THEN 'SI'
        ELSE 'NO' 
    END AS [ACTIVO],
    tp.nombre AS [TIPO PRODUCTO]
FROM Producto p
LEFT JOIN Marcas m ON p.marca_id = m.id
INNER JOIN TiposProducto tp ON tp.id = p.tipo_producto_id;


-- ====================================
-- ?        DEPOSITO
-- ====================================
DROP VIEW dbo.vw_depositos;

CREATE OR ALTER VIEW dbo.vw_depositos AS
SELECT 
    d.id AS [IDENTIFICADOR DE PRODUCTO],
    d.nombre AS [SUCURSAL], 
    d.direccion AS [UBICACION], 
    t.nombre AS [TIPO], 
    CASE d.estado
        WHEN 1 THEN 'Activo'
        WHEN 0 THEN 'Inactivo'
        ELSE 'Desconocido'
    END AS [ESTADO]
FROM Deposito d
INNER JOIN TipoDeposito t
ON t.id= d.idTipoDeposito;

-- ====================================
-- ?            INVENTARIO
-- ====================================
DROP VIEW dbo.vw_inventario;

CREATE OR ALTER VIEW dbo.vw_inventario AS
    SELECT 
        i.id AS [IDENTIFICADOR],
        d.nombre AS [DEPOSITO],
        p.descripcion AS [PRODUCTO],
        i.stock AS [STOCK]
    FROM Inventario i
    INNER JOIN Deposito d ON d.id = i.deposito_id
    INNER JOIN Producto p ON p.id = i.producto_id;