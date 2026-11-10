-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- MÓDULO      : UsuariosProcedure
-- OBJETO      : Tabla Usuarios
-- PROPÓSITO   : Procedimientos (CUD) para Gestionar la tabla Usuarios
-- AUTOR       : Francisco David Medina Lourenzo 
-- FECHA CREA  : 2026-10-13

CREATE OR ALTER PROCEDURE dbo.usp_crearUsuario @cedula NVARCHAR(20),@nombre NVARCHAR(50),@apellido NVARCHAR(50),@rol_id INT AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;            
            INSERT INTO Usuarios (cedula, nombre, apellido, rol_id)  
            VALUES (@cedula, @nombre, @apellido, @rol_id);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END

GO

CREATE OR ALTER PROCEDURE dbo.usp_borrarUsuario @cedula NVARCHAR(20) AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            DELETE FROM Usuarios WHERE cedula=@cedula;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END

GO

CREATE OR ALTER PROCEDURE dbo.usp_actualizarUsuario  @cedula NVARCHAR(20), @nombre NVARCHAR(50), @apellido NVARCHAR(50), @rol_id INT AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            UPDATE Usuarios
                SET nombre = @nombre,apellido = @apellido,rol_id = @rol_id
                WHERE cedula = @cedula;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END
GO