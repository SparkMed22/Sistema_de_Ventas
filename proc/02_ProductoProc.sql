-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- PROPÓSITO       : Procedimientos Almacenado para gestionar Las tablas relacionasdas a Producto
-- AUTOR           : Francisco David Medina Lourenzo 
-- FECHA CREACION  : 2026-10-15


-- ! CODIGO DE ERRORES
-- ERROR 50100 = Ya existe un producto registrado con esa misma descripción para esta marca.
-- ERROR 50101 = El tipo de producto no existe 
-- Error 50102 = La marca especificada no existe
-- Error 50103 = El producto que intenta eliminar no existe.
-- ERROR 50104 = El producto que intenta actualizar no existe.


-- ====================================
-- ?            PRODUCTOS 
-- ====================================
DROP PROCEDURE dbo.usp_crearProducto;
DROP PROCEDURE dbo.usp_borrarProducto;
DROP PROCEDURE dbo.usp_actualizarProducto;

-- marca_id valor por defecto NULL
CREATE PROCEDURE dbo.usp_crearProducto 
    @descripcion NVARCHAR(255),
    @es_servicio BIT,
    @tipo_producto_id INT,
    @precio DECIMAL(18, 2),
    @compra DECIMAL(18, 2),
    @pagaIVA BIT,
    @porcentaje_iva DECIMAL(18,2),
    @marca_id INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF dbo.fn_ProductoExiste(@descripcion,@marca_id) = 1 THROW 50100, 'Ya existe un producto registrado con esa misma descripción para esta marca.', 1;
        IF dbo.fn_MarcaExiste(@marca_id) = 0 THROW 50102, 'La marca especificada no existe', 1;
        IF dbo.fn_TipoProductoExiste(@tipo_producto_id) = 0 THROW 50101, 'El tipo de producto no existe', 1;
        INSERT INTO Producto(descripcion,es_servicio,tipo_producto_id,precio,compra,pagaIVA,porcentaje_iva,marca_id)
        VALUES (@descripcion,@es_servicio,@tipo_producto_id,@precio,@compra,@pagaIVA,@porcentaje_iva,@marca_id);
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END


CREATE PROCEDURE dbo.usp_borrarProducto @id INT AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Producto WHERE id = @id) THROW 50103, 'El producto que intenta eliminar no existe.', 1;
        DELETE FROM Producto WHERE id = @id;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END
GO


CREATE PROCEDURE dbo.usp_actualizarProducto 
    @id INT,
    @descripcion NVARCHAR(255),
    @es_servicio BIT,
    @tipo_producto_id INT,
    @precio DECIMAL(18, 2),
    @compra DECIMAL(18, 2),
    @pagaIVA BIT,
    @porcentaje_iva DECIMAL(18,2),
    @marca_id INT = NULL,
    @estado BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM Producto WHERE id = @id) THROW 50104, 'El producto que intenta actualizar no existe.', 1;
        IF dbo.fn_ProductoExisteParaActualizar(@descripcion, @marca_id, @id) = 1 THROW 50100, 'Ya existe otro producto registrado con esa misma descripción para esta marca.', 1;
        IF dbo.fn_MarcaExiste(@marca_id) = 0 THROW 50102, 'La marca especificada no existe', 1;
        IF dbo.fn_TipoProductoExiste(@tipo_producto_id) = 0  THROW 50101, 'El tipo de producto no existe', 1;

        UPDATE Producto 
        SET descripcion = @descripcion,
            es_servicio = @es_servicio,
            tipo_producto_id = @tipo_producto_id,
            precio = @precio,
            compra = @compra,
            pagaIVA = pagaIVA,
            porcentaje_iva = @porcentaje_iva,
            marca_id = @marca_id,
            estado = @estado
        WHERE id = @id;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END

-- ====================================
-- ?            DEPOSITO
-- ====================================

-- ! CODIGO DE ERRORES
-- ERROR 50105 = Gerarquia de Deposito Invalida

DROP PROCEDURE dbo.usp_crearDeposito;

CREATE PROCEDURE dbo.usp_crearDeposito
    @nombre NVARCHAR(50),
    @direccion NVARCHAR(150),
    @idTipoDeposito INT  AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @idTipoDeposito NOT BETWEEN 1 AND 2 THROW 50105, 'Gerarquia de Deposito Invalida', 1;
        BEGIN TRANSACTION;
            INSERT INTO Deposito( nombre,direccion,idTipoDeposito)
            VALUES( @nombre,@direccion,@idTipoDeposito);
        COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END

EXEC dbo.usp_crearDeposito 'Almacén Principal','Av. Industrial 101',1;