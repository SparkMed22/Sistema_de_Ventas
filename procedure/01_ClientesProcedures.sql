-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- OBJETO         : Tabla Clientes
-- PROPÓSITO      : Procedimientos Almacenados para un C.U.D
-- AUTOR          : Francisco David Medina Lourenzo 
-- FECHA CREACION : 2026-10-13



-- ! CODIGO DE ERRORES

-- ERROR 60001 = La cedula ya pertenece a otro Cliente
-- Error 60002 = El Cliente no Exsite

DROP PROCEDURE dbo.usp_crearCliente;
DROP PROCEDURE dbo.usp_updateCliente;
DROP PROCEDURE dbo.usp_deleteCliente;

CREATE PROCEDURE dbo.usp_creaRCliente 
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
            THROW 60001 ,'La cedula ya pertenece a otro Cliente...', 1;
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


CREATE PROCEDURE dbo.usp_updateCliente     
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
        IF dbo.fn_ClienteExiste(@cedula) = 1
        BEGIN
            THROW 60002, 'El Cliente no Existe', 1;
        END

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


CREATE PROCEDURE dbo.usp_deleteUsuario @cedula NVARCHAR(20) AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF dbo.fn_ClienteExiste(@cedula) = 1
        BEGIN
            THROW 60002, 'El Cliente no Existe', 1;
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