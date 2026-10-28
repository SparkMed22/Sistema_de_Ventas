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
CREATE OR ALTER PROCEDURE dbo.usp_crearProducto 
    @descripcion NVARCHAR(255),
    @es_servicio BIT,
    @tipo_producto_id INT,
    @precio_venta  DECIMAL(18, 2),
    @precio_compra DECIMAL(18, 2),
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
        INSERT INTO Producto(descripcion,es_servicio,tipo_producto_id,precio_venta,precio_compra,pagaIVA,porcentaje_iva,marca_id)
        VALUES (@descripcion,@es_servicio,@tipo_producto_id,@precio_venta,@precio_compra,@pagaIVA,@porcentaje_iva,@marca_id);
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END


CREATE OR ALTER PROCEDURE dbo.usp_borrarProducto @id INT AS
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


CREATE OR ALTER PROCEDURE dbo.usp_actualizarProducto 
    @id INT,
    @descripcion NVARCHAR(255),
    @es_servicio BIT, 
    @tipo_producto_id INT,
    @precio_venta DECIMAL(18, 2),
    @precio_compra DECIMAL(18, 2),
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
            precio_venta = @precio_venta,
            precio_compra = @precio_compra,
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
-- ERROR 50106 = El depósito especificado no existe o esta Inactivo
-- ERROR 50107 = El depósito especificado no existe
-- ERROR 50108 = El deposito esta en uso
DROP PROCEDURE dbo.usp_crearDeposito;
DROP PROCEDURE dbo.ups_desactivarDeposito;
DROP PROCEDURE dbo.ups_activarDeposito;
DROP PROCEDURE dbo.ups_borrarDeposito;
DROP PROCEDURE dbo.usp_actualizarDeposito;

CREATE OR ALTER PROCEDURE dbo.usp_crearDeposito
    @codigo_establecimiento NVARCHAR(3),
    @nombre NVARCHAR(50),
    @direccion NVARCHAR(150),
    @idTipoDeposito INT  AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF dbo.fn_TipoDepositoExiste(@idTipoDeposito) = 0 THROW 50105, 'Gerarquia de Deposito Invalida', 1;
        BEGIN TRANSACTION;
            INSERT INTO Deposito(codigo_establecimiento,nombre,direccion,idTipoDeposito)
            VALUES(@codigo_establecimiento,@nombre,@direccion,@idTipoDeposito);
        COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END

GO

CREATE OR ALTER PROCEDURE dbo.ups_desactivarDeposito @id INT AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF dbo.fn_DepositoActivoExiste(@id) = 0 THROW 50106, 'El depósito especificado no existe o esta Inactivo', 1;
        BEGIN TRANSACTION;
            UPDATE Deposito SET estado = 0 WHERE id=@id;
        COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END

GO

CREATE OR ALTER PROCEDURE dbo.ups_activarDeposito @id INT AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF dbo.fn_DepositoExiste(@id) = 0 THROW 50107,'El depósito especificado no existe', 1;
        BEGIN TRANSACTION;
            UPDATE Deposito SET estado = 1 WHERE id=@id;
        COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END

GO

CREATE OR ALTER PROCEDURE dbo.ups_borrarDeposito @id INT AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF dbo.fn_DepositoExiste(@id) = 0 THROW 50107,'El depósito especificado no existe', 1;
        IF EXISTS (SELECT 1 FROM Inventario WHERE deposito_id=@id AND stock>0) THROW 50108,'El deposito esta en uso',1;        
        BEGIN TRANSACTION;
            DELETE FROM Inventario WHERE deposito_id = @id;
            DELETE FROM Deposito  WHERE id = @id;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END

GO

CREATE OR ALTER PROCEDURE dbo.usp_actualizarDeposito 
    @id INT,
    @codigo_establecimiento NVARCHAR(3),
    @nombre NVARCHAR(50),
    @direccion NVARCHAR(150), 
    @idTipoDeposito TINYINT,
    @estado BIT = 1 AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
        IF dbo.fn_DepositoExiste(@id) = 0 THROW 50107,'El depósito especificado no existe', 1;
        IF dbo.fn_TipoDepositoExiste(@idTipoDeposito) = 0 THROW 50105, 'Gerarquia de Deposito Invalida', 1;

        UPDATE Deposito SET nombre = @nombre,
            codigo_establecimiento=@codigo_establecimiento,
            direccion = @direccion,
            idTipoDeposito = @idTipoDeposito,
            estado = @estado
        WHERE id = @id;
    COMMIT TRANSACTION;
    END TRY
        BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO



-- ====================================
-- ?            INVENTARIO
-- ====================================

-- ! CODIGO DE ERRORES
-- ERROR 50111 = El producto especificado no existe
-- ERROR 50112 = El stock debe ser mayor a cero
-- ERROR 50113 = El producto no se encuentra registrado en el inventario de este depósito.
-- ERROR 50114 = No hay suficiente stock en el depósito para realizar la operación.

-- (deposito_id, producto_id, stock)


DROP PROCEDURE dbo.usp_agregarInventario;
DROP PROCEDURE dbo.usp_restarInventario;



CREATE OR ALTER PROCEDURE dbo.usp_agregarInventario
    @deposito_id INT,
    @producto_id INT,
    @stock INT 
AS
BEGIN
    SET NOCOUNT ON; 
    BEGIN TRY
        IF dbo.fn_DepositoActivoExiste(@deposito_id) = 0 THROW 50106, 'El depósito especificado no existe o esta Inactivo', 1;
        IF NOT EXISTS (SELECT 1 FROM Producto WHERE id = @producto_id AND es_servicio = 0) THROW 50111, 'El producto especificado no existe', 1;
        IF @stock < 0 THROW 50112, 'El stock debe ser mayor a cero', 1;
    
        BEGIN TRANSACTION;
        IF EXISTS (SELECT 1 FROM Inventario WHERE deposito_id = @deposito_id AND producto_id = @producto_id)
        BEGIN
            UPDATE Inventario
            SET stock = stock + @stock
            WHERE deposito_id = @deposito_id AND producto_id = @producto_id;
        END
        ELSE 
        BEGIN
            INSERT INTO Inventario (deposito_id, producto_id, stock)
            VALUES (@deposito_id, @producto_id, @stock);
        END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;    
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_restarInventario
    @deposito_id INT,
    @producto_id INT,
    @stock INT  
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        IF dbo.fn_DepositoActivoExiste(@deposito_id) = 0 
            THROW 50106, 'El depósito especificado no existe o está inactivo.', 1;
            
        IF NOT EXISTS (SELECT 1 FROM Producto WHERE id = @producto_id AND es_servicio=0) 
            THROW 50104, 'El producto que intenta actualizar no existe.', 1;        
            
        IF @stock <= 0 
            THROW 50112, 'El stock debe ser mayor a cero.', 1;
        
        DECLARE @stockActual INT;
        SET @stockActual = dbo.fn_StockProducto(@producto_id, @deposito_id);
        
        IF NOT EXISTS (SELECT 1 FROM Inventario WHERE deposito_id = @deposito_id AND producto_id = @producto_id) 
            THROW 50113, 'El producto no se encuentra registrado en el inventario de este depósito.', 1;
        
        IF @stock > @stockActual  
            THROW 50114, 'No hay suficiente stock en el depósito para realizar la operación.', 1;

        BEGIN TRANSACTION;
            UPDATE Inventario 
            SET stock = stock - @stock
            WHERE deposito_id = @deposito_id 
              AND producto_id = @producto_id;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;    
        THROW;
    END CATCH
END;
GO

