-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- OBJETO         : Tabla Clientes
-- PROPÓSITO      : Procedimientos Almacenados para un C.U.D
-- AUTOR          : Francisco David Medina Lourenzo 
-- FECHA CREACION : 2026-10-13



-- ! CODIGO DE ERRORES

-- ERROR 50050 = La cedula ya pertenece a otro Cliente
-- Error 50051 = El Cliente no Exsite

DROP PROCEDURE dbo.usp_crearCliente;
DROP PROCEDURE dbo.usp_actualizarCliente; 
DROP PROCEDURE dbo.usp_borrarCliente;

CREATE PROCEDURE dbo.usp_crearCliente 
    @cedula NVARCHAR(20),
    @nombre NVARCHAR(50), 
    @direccion NVARCHAR(70), 
    @telefono VARCHAR(20), 
    @email VARCHAR(255), 
    @credito DECIMAL(19,4) 
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF dbo.fn_ClienteExiste(@cedula) = 1
        BEGIN
            THROW 50050 ,'La cedula ya pertenece a otro Cliente...', 1;
        END
        BEGIN TRANSACTION;
            PRINT 'Creando Cliente...';
            INSERT INTO Clientes (cedula, nombre, direccion, telefono, email, credito) 
            VALUES (@cedula, @nombre, @direccion, @telefono, @email, @credito);
            PRINT 'Cliente Creado...';
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END;

GO


CREATE PROCEDURE dbo.usp_actualizarCliente     
    @cedula NVARCHAR(20),
    @nombre NVARCHAR(50), 
    @direccion NVARCHAR(70), 
    @telefono VARCHAR(20), 
    @email VARCHAR(255), 
    @credito DECIMAL(19,4),
    @saldo DECIMAL(19,4) 
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
                email = @email,
                credito = @credito,
                saldo = @saldo
            WHERE cedula = @cedula;

        COMMIT TRANSACTION;
        PRINT 'Cliente actualizado con éxito.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END;

GO

CREATE PROCEDURE dbo.usp_borrarCliente @cedula NVARCHAR(20) AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF dbo.fn_ClienteExiste(@cedula) = 1
        BEGIN
            THROW 50051, 'El Cliente no Existe', 1;
        END

        BEGIN TRANSACTION;
            DELETE FROM Clientes WHERE cedula=@cedula;
        COMMIT TRANSACTION;
        PRINT 'Cliente eliminado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END