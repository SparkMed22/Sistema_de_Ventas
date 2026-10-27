-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- PROPÓSITO       : Procedimientos Almacenado para gestionar Movimientos Deposito
-- AUTOR           : Francisco David Medina Lourenzo 
-- FECHA CREACION  : 2026-10-24


-- ====================================
-- ?            MOVIMOENTO DEPOSITO
-- ====================================

-- ! CODIGO DE ERRORES
-- ERROR 50120 = El deposito de Origen no es valido
-- ERROR 50121 = El deposito de Destino no es valido
-- ERROR 50122 = EL Usuario encargado no es Valido
-- ERROR 50123 = EL Usuario autorizado no es Valido



DROP PROCEDURE dbo.usp_crearTransferenciaDeposito;

CREATE OR ALTER PROCEDURE dbo.usp_crearTransferenciaDeposito
    @id_dep_origen INT,
    @id_dep_destino INT,
    @id_usuario_encargado INT,
    @id_usuario_autorizo INT,
    @obs_operacion NVARCHAR(255) = NULL,
    @id_transferencia_generado INT OUTPUT 
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF dbo.fn_DepositoActivoExiste(@id_dep_origen) = 0 THROW 50120, 'El deposito de Origen no es valido', 1;
        IF dbo.fn_DepositoActivoExiste(@id_dep_destino) = 0 THROW 50121, 'El deposito de Destino no es valido', 1;
        IF dbo.fn_UsuarioExiste(@id_usuario_encargado) = 0 THROW 50122, 'EL Usuario encargado no es Valido', 1;
        IF dbo.fn_UsuarioExiste(@id_usuario_autorizo) = 0 THROW 50123, 'EL Usuario autorizado no es Valido', 1;
        
        BEGIN TRANSACTION;
            INSERT INTO TransferenciaCabeceraDesposito (id_dep_origen, id_dep_destino, id_usuario_encargado, id_usuario_autorizo, obs_operacion)
            VALUES (@id_dep_origen, @id_dep_destino, @id_usuario_encargado, @id_usuario_autorizo, @obs_operacion);
            SET @id_transferencia_generado = SCOPE_IDENTITY();
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH 
END;
GO

-- ======================================================
-- ?            MOVIMOENTO DEPOSITO DETALLES
-- ======================================================

-- ! CODIGO DE ERRORES
-- ERROR 50126 = Cabecera Transferencia Invalida
-- ERROR 50126 = 
-- ERROR 50128 = La transferencia se encuentra anulada o inactiva

DROP PROCEDURE dbo.usp_crearTransferenciaDepositoDetalle;

CREATE OR ALTER PROCEDURE dbo.usp_crearTransferenciaDepositoDetalle
    @id_TransferenciaCabeceraDesposito INT,
    @id_producto INT,
    @cantidad INT AS

BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        DECLARE @id_dep_origen INT, @id_dep_destino INT, @estadoTransferencia BIT;

        SELECT
            @id_dep_origen = id_dep_origen,
            @id_dep_destino = id_dep_destino,
            @estadoTransferencia = estado
        FROM dbo.TransferenciaCabeceraDesposito
        WHERE id = @id_TransferenciaCabeceraDesposito;

        IF @@ROWCOUNT = 0
            THROW 50126, 'Cabecera Transferencia Invalida', 1;

        IF ISNULL(@estadoTransferencia, 0) = 0
            THROW 50128, 'La transferencia se encuentra anulada o inactiva', 1;

        BEGIN TRANSACTION;

            EXEC dbo.usp_restarInventario
                @deposito_id = @id_dep_origen,
                @producto_id = @id_producto,
                @stock = @cantidad;

            EXEC dbo.usp_agregarInventario
                @deposito_id = @id_dep_destino,
                @producto_id = @id_producto,
                @stock = @cantidad;
            INSERT INTO dbo.TransferenciaDetalleDesposito(id_TransferenciaCabeceraDesposito,id_producto,cantidad)
            VALUES(@id_TransferenciaCabeceraDesposito,@id_producto,@cantidad);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
