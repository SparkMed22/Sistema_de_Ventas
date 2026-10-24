-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- PROPÓSITO       : Funciones para gestionar Las tablas relacionasdas a Producto
-- AUTOR           : Francisco David Medina Lourenzo 
-- FECHA CREACION  : 2026-10-15

-- ====================================
-- ?            MARCA
-- ====================================
DROP FUNCTION dbo.fn_MarcaExiste;
CREATE OR ALTER FUNCTION dbo.fn_MarcaExiste(@marca_id INT)
RETURNS INT AS
BEGIN
    IF @marca_id IS NULL RETURN 1;
    IF EXISTS (SELECT 1 FROM Marcas WHERE id=@marca_id) RETURN 1;
    RETURN 0;
END
GO

-- ====================================
-- ?            TipoProducto
-- ====================================

DROP FUNCTION dbo.fn_TipoProductoExiste;
CREATE OR ALTER FUNCTION dbo.fn_TipoProductoExiste(@tipo_producto_id INT)
RETURNS INT AS
BEGIN
    IF EXISTS (SELECT 1 FROM TiposProducto WHERE id=@tipo_producto_id) RETURN 1;
    RETURN 0;
END
GO

-- ====================================
-- ?            PRODUCTO
-- ====================================

DROP FUNCTION dbo.fn_ProductoExiste;
DROP FUNCTION dbo.fn_ProductoExisteParaActualizar;
DROP FUNCTION dbo.fn_CalcularPrecioConIVA;

CREATE OR ALTER FUNCTION dbo.fn_ProductoExiste(@descripcion VARCHAR(255), @marca_id INT)
RETURNS INT AS
BEGIN
    IF EXISTS (SELECT 1 FROM Producto WHERE descripcion = @descripcion 
          AND (marca_id = @marca_id OR (marca_id IS NULL AND @marca_id IS NULL)))   RETURN 1;
    RETURN 0;
END

GO

CREATE OR ALTER FUNCTION dbo.fn_ProductoExisteParaActualizar(
    @descripcion VARCHAR(255),
    @marca_id INT,
    @id INT)
RETURNS INT  AS
BEGIN
    IF EXISTS ( SELECT 1 FROM Producto WHERE descripcion = @descripcion 
        AND (marca_id = @marca_id OR (marca_id IS NULL AND @marca_id IS NULL))
        AND id <> @id)  RETURN 1;
    RETURN 0;
END

GO

CREATE OR ALTER FUNCTION dbo.fn_CalcularPrecioConIVA(@pagaIVA BIT ,@porcentaje_iva DECIMAL(10,2),@Precio DECIMAL(10,2))
RETURNS DECIMAL(10,2) AS
BEGIN
    RETURN(
        CASE
            WHEN @pagaIVA = 1 THEN @Precio + (@Precio * (@porcentaje_iva/100))
            ELSE 0.00
        END
    );
END;
GO

-- ====================================
-- ?            TIPODEPOSITO
-- ====================================
CREATE OR ALTER FUNCTION dbo.fn_TipoDepositoExiste(@id INT)
RETURNS INT AS
BEGIN
    IF EXISTS (SELECT 1 FROM TipoDeposito WHERE id=@id) RETURN 1;
    RETURN 0;
END

GO
-- ====================================
-- ?            DEPOSITO
-- ====================================

DROP FUNCTION dbo.fn_DepositoActivoExiste;
DROP FUNCTION dbo.fn_DepositoExiste;

CREATE OR ALTER FUNCTION dbo.fn_DepositoActivoExiste(@id INT)
RETURNS INT AS
BEGIN
    IF EXISTS (SELECT 1 FROM Deposito WHERE id=@id AND estado=1) RETURN 1;
    RETURN 0;
END

GO

CREATE OR ALTER FUNCTION dbo.fn_DepositoExiste(@id INT)
RETURNS INT AS
BEGIN
    IF EXISTS (SELECT 1 FROM Deposito WHERE id=@id) RETURN 1;
    RETURN 0;
END




-- ====================================
-- ?            INVENTARIO
-- ====================================

DROP FUNCTION dbo.fn_StockProducto;


CREATE OR ALTER FUNCTION dbo.fn_StockProducto (@producto_id INT, @deposito_id INT)
RETURNS INT 
AS
BEGIN
    DECLARE @stockActual INT;
    SELECT @stockActual = stock FROM Inventario 
        WHERE deposito_id = @deposito_id AND producto_id = @producto_id;
    IF @stockActual IS NULL SET @stockActual = 0;
    RETURN @stockActual;
END;
GO