-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- MÓDULO      : UsuariosProcedure
-- OBJETO      : Tabla Usuarios
-- PROPÓSITO   : Procedimientos (CUD) para Gestionar la tabla Usuarios
-- AUTOR       : Francisco David Medina Lourenzo 
-- FECHA CREA  : 2026-10-13

-- ! CODIGO DE ERRORES
-- Error 50001 = EL ROL NO ES VALIDO
-- ERROR 50002 = La cedula ya pertenece a otro Usuario
-- Error 50003 = El usuario no Exsite

-- ? Borrar los PROCEDURE
DROP PROCEDURE dbo.usp_deleteUsuario;
DROP PROCEDURE dbo.usp_crearUsuario;
DROP PROCEDURE dbo.usp_updateUsuario;


CREATE PROCEDURE dbo.usp_deleteUsuario @cedula NVARCHAR(20) AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE cedula=@cedula)
        BEGIN
            THROW 50003, 'El Usuario no existe...', 1;
        END

        BEGIN TRANSACTION;
            DELETE FROM Usuarios WHERE cedula=@cedula;
        COMMIT TRANSACTION;
        PRINT 'Usuario eliminado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END 
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END

GO


CREATE PROCEDURE dbo.usp_updateUsuario  @cedula NVARCHAR(20), @nombre NVARCHAR(50), @apellido NVARCHAR(50), @rol_id INT AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE cedula = @cedula)
        BEGIN
            THROW 50003, 'El Usuario no existe...', 1;
        END

        IF NOT EXISTS (SELECT 1 FROM Roles WHERE id = @rol_id)
        BEGIN
            THROW 50001, 'EL ROL NO ES VALIDO', 1;
        END

        BEGIN TRANSACTION;
            UPDATE Usuarios
            SET nombre = @nombre,
                apellido = @apellido,
                rol_id = @rol_id
            WHERE cedula = @cedula;
        COMMIT TRANSACTION;
        
        PRINT 'Usuario actualizado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END 
        ;THROW;
    END CATCH
END

GO

CREATE PROCEDURE dbo.usp_crearUsuario @cedula NVARCHAR(20),@nombre NVARCHAR(50),@apellido NVARCHAR(50),@rol_id INT AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM Roles WHERE id=@rol_id)
        BEGIN
            PRINT 'ERROR (50001): EL ROL NO ES VALIDO';
            THROW 50001, 'EL ROL NO ES VALIDO', 1;
        END

        IF EXISTS (SELECT 1 FROM Usuarios  WHERE cedula=@cedula)
        BEGIN
            PRINT 'ERROR (50002): La cedula ya pertenece a otro Usuario';
            THROW 50002, 'La cedula ya pertenece a otro Usuario', 1;
        END

        BEGIN TRANSACTION;
            PRINT 'CREAMOS AL USUARIO';
            INSERT INTO Usuarios (cedula,nombre, apellido, rol_id) 
            VALUES (@cedula,@nombre, @apellido, @rol_id)
            PRINT 'USUARIO CREADO CON EXCITO....';
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END 
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END

