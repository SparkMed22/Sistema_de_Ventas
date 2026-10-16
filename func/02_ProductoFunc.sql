-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- PROPÓSITO       : Funciones para gestionar Las tablas relacionasdas a Producto
-- AUTOR           : Francisco David Medina Lourenzo 
-- FECHA CREACION  : 2026-10-15


-- ====================================
-- ?            PRODUCTO
-- ====================================

DROP FUNCTION dbo.fn_ProductoExiste;
DROP FUNCTION dbo.fn_MarcaExiste;
DROP FUNCTION dbo.fn_TipoProductoExiste;
DROP FUNCTION dbo.fn_ProductoExisteParaActualizar;


CREATE FUNCTION dbo.fn_ProductoExiste(@descripcion VARCHAR(255), @marca_id INT)
RETURNS INT AS
BEGIN
    IF EXISTS (SELECT 1 FROM Producto WHERE descripcion = @descripcion 
          AND (marca_id = @marca_id OR (marca_id IS NULL AND @marca_id IS NULL)))  
    BEGIN
        RETURN 1;
    END
    RETURN 0;
END
GO


CREATE FUNCTION dbo.fn_MarcaExiste(@marca_id INT)
RETURNS INT AS
BEGIN
    IF @marca_id IS NULL RETURN 1;
    IF EXISTS (SELECT 1 FROM Marcas WHERE id=@marca_id) RETURN 1;
    RETURN 0;
END
GO

CREATE FUNCTION dbo.fn_TipoProductoExiste(@tipo_producto_id INT)
RETURNS INT AS
BEGIN
    IF EXISTS (SELECT 1 FROM TiposProducto WHERE id=@tipo_producto_id) RETURN 1;
    RETURN 0;
END


CREATE FUNCTION dbo.fn_ProductoExisteParaActualizar(
    @descripcion VARCHAR(255),
    @marca_id INT,
    @id INT)
RETURNS INT  AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM Producto 
        WHERE descripcion = @descripcion 
          AND (marca_id = @marca_id OR (marca_id IS NULL AND @marca_id IS NULL))
          AND id <> @id
    )  
    BEGIN
        RETURN 1;
    END

    RETURN 0;
END
GO

-- ====================================
-- ?            DEPOSITO
-- ====================================
