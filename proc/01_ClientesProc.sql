-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- OBJETO         : Tabla Clientes
-- PROPÓSITO      : Procedimientos Almacenados para un C.U.D
-- AUTOR          : Francisco David Medina Lourenzo 
-- FECHA CREACION : 2026-10-13



-- ! CODIGO DE ERRORES
-- ERROR 50050 = La cedula ya pertenece a otro Cliente
-- Error 50051 = El Cliente no Exsite
-- Error 50052 = El saldo debe ser mayor o igual a cero.
-- ERROR 50053 = El saldo debe ser menor al credito disponible
-- ERROR 50054 = El pago debe ser mayor.'
-- ERROR 50055 = El limite para el credito debe de ser mayor a 0
-- ERROR 50110 

DROP PROCEDURE dbo.usp_crearCliente;
DROP PROCEDURE dbo.usp_actualizarCliente; 
DROP PROCEDURE dbo.usp_borrarCliente;

CREATE OR ALTER PROCEDURE dbo.usp_crearCliente 
    @cedula NVARCHAR(20),
    @nombre NVARCHAR(50), 
    @direccion NVARCHAR(70), 
    @telefono VARCHAR(20), 
    @email VARCHAR(255), 
    @limite_credito DECIMAL(19,4) 
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF dbo.fn_ClienteExiste(@cedula) = 1 THROW 50050 ,'La cedula ya pertenece a otro Cliente...', 1;
        BEGIN TRANSACTION;
            INSERT INTO Clientes (cedula, nombre, direccion, telefono, email, limite_credito) 
            VALUES (@cedula, @nombre, @direccion, @telefono, @email, @limite_credito);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END;

GO


CREATE OR ALTER PROCEDURE dbo.usp_actualizarCliente     
    @cedula NVARCHAR(20),
    @nombre NVARCHAR(50), 
    @direccion NVARCHAR(70), 
    @telefono VARCHAR(20), 
    @email VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY 
        IF dbo.fn_ClienteExiste(@cedula) = 1 THROW 50051, 'El Cliente no Existe', 1;
        BEGIN TRANSACTION;
            UPDATE Clientes
            SET nombre = @nombre,
                direccion = @direccion,
                telefono = @telefono,
                email = @email
            WHERE cedula = @cedula;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END;

GO

CREATE OR ALTER PROCEDURE dbo.usp_borrarCliente @cedula NVARCHAR(20) AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF dbo.fn_ClienteExiste(@cedula) = 0 THROW 50051, 'El Cliente no Existe', 1;
        BEGIN TRANSACTION;
            DELETE FROM Clientes WHERE cedula=@cedula;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END


GO

DROP PROCEDURE dbo.usp_incrementarSaldoCliente;
DROP PROCEDURE dbo.usp_decrementarSaldoCliente;




CREATE OR ALTER PROCEDURE dbo.usp_incrementarSaldoCliente
    @id_cliente INT,
    @saldo DECIMAL(19,4) AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @id_cliente IS NULL OR @id_cliente <= 0
            THROW 50050, 'El ID del cliente no es válido.', 1;

        IF @saldo IS NULL OR @saldo <= 0
            THROW 50052, 'El importe de la compra debe ser mayor que cero.', 1;

        BEGIN TRANSACTION;

            DECLARE
                @credito DECIMAL(19,4),
                @saldo_actual DECIMAL(19,4),
                @saldo_nuevo DECIMAL(19,4),
                @limite_credito DECIMAL(19,4);

            SELECT
                @credito = credito,
                @saldo_actual = saldo,
                @limite_credito = limite_credito
            FROM Clientes WITH (UPDLOCK, HOLDLOCK) WHERE id = @id_cliente;

            IF @@ROWCOUNT = 0
                THROW 50051, 'El cliente no existe.', 1;

            IF @credito IS NULL
                OR @saldo_actual IS NULL
                OR @limite_credito IS NULL
                THROW 50054, 'Los valores de crédito del cliente no están definidos.', 1;

            IF @credito < 0
                OR @saldo_actual < 0
                OR @limite_credito < 0
                THROW 50055, 'Los valores de crédito del cliente no son válidos.', 1;

            SET @saldo_nuevo = @saldo_actual + @saldo;

            IF @saldo_nuevo > @limite_credito
                THROW 50053, 'La compra supera el límite de crédito del cliente.', 1;

            UPDATE Clientes SET saldo = @saldo_nuevo, credito = @limite_credito - @saldo_nuevo WHERE id = @id_cliente;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;


GO

CREATE OR ALTER PROCEDURE dbo.usp_decrementarSaldoCliente
    @id_cliente INT,
    @credito DECIMAL(19,4) AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @id_cliente IS NULL OR @id_cliente <= 0
            THROW 50050, 'El ID del cliente no es válido.', 1;
        IF @credito IS NULL OR @credito <= 0
            THROW 50054, 'El pago debe ser mayor que cero.', 1;

        BEGIN TRANSACTION;

            DECLARE @credito_actual DECIMAL(19,4), @saldo_actual DECIMAL(19,4), @credito_nuevo DECIMAL(19,4), @saldo_nuevo DECIMAL(19,4);

            SELECT
                @credito_actual = credito,
                @saldo_actual = saldo
            FROM dbo.Clientes WITH (UPDLOCK, HOLDLOCK)
            WHERE id = @id_cliente;

            IF @@ROWCOUNT = 0
                THROW 50051, 'El cliente no existe.', 1;
    
            IF @credito_actual IS NULL OR @saldo_actual IS NULL
                THROW 50055, 'El crédito o saldo del cliente no está definido.', 1;

            IF @saldo_actual <= 0
                THROW 50056, 'El cliente no tiene una deuda pendiente.', 1;

            IF @credito > @saldo_actual
                THROW 50053, 'El pago no puede superar el saldo pendiente.', 1;

            SET @saldo_nuevo = @saldo_actual - @credito;
            SET @credito_nuevo = @credito_actual + @credito;

            UPDATE Clientes SET saldo = @saldo_nuevo, credito = @credito_nuevo WHERE id = @id_cliente;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;


GO

CREATE OR ALTER PROCEDURE dbo.usp_incrementarLimiteCreditoCliente
    @id_cliente INT,
    @limite_credito DECIMAL(19,4) AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @id_cliente IS NULL OR @id_cliente <= 0
            THROW 50050, 'El ID del cliente no es válido.', 1;
        IF @limite_credito IS NULL OR @limite_credito <= 0
            THROW 50055, 'El limite para el credito debe de ser mayor a 0', 1;

        BEGIN TRANSACTION;

            DECLARE @limite_credito_actual DECIMAL(19,4);
            SELECT
                @limite_credito_actual = limite_credito
            FROM Clientes WITH (UPDLOCK, HOLDLOCK)
            WHERE id = @id_cliente;

            IF @@ROWCOUNT = 0
                THROW 50051, 'El cliente no existe.', 1;

            UPDATE Clientes SET limite_credito= @limite_credito_actual+@limite_credito WHERE id = @id_cliente;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END