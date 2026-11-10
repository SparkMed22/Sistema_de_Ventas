-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- PROPÓSITO       : REGISTRAR LOS MOVIMIENTOS PARA GENERAR UNA BITACORA 
-- AUTOR           : Francisco David Medina Lourenzo 
-- FECHA CREACION  : 2026-10-13


-- ====================================
-- ?            CREAR USUARIO
-- ====================================
-- ! CODIGO DE ERRORES
-- Error 50001 = EL ROL NO ES VALIDO
-- ERROR 50002 = La cedula ya pertenece a otro Usuario
-- Error 50003 = El usuario no Exsite

CREATE OR ALTER TRIGGER trg_InsertUsuarios ON Usuarios 
INSTEAD OF INSERT AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM inserted i WHERE NOT EXISTS (SELECT 1 FROM Roles r WHERE r.id = i.rol_id))
            THROW 50001, 'EL ROL NO ES VALIDO', 1;
        IF EXISTS (SELECT 1 FROM inserted i INNER JOIN Usuarios u ON i.cedula = u.cedula)
            THROW 50002, 'La cedula ya pertenece a otro Usuario', 1;
        INSERT INTO Usuarios (cedula, nombre, apellido, rol_id) SELECT cedula, nombre, apellido, rol_id FROM inserted;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END

GO

-- ====================================
-- ?            BORRAR USUARIO
-- ====================================

CREATE OR ALTER TRIGGER trg_BorrarUsuarios ON Usuarios 
INSTEAD OF DELETE AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM Usuarios WHERE id IN (SELECT id FROM deleted);
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END
GO

-- ====================================
-- ?            ACTUALIZAR USUARIO
-- ====================================
CREATE OR ALTER TRIGGER trg_UpdateUsuarios ON Usuarios 
INSTEAD OF UPDATE AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM deleted d WHERE NOT EXISTS (SELECT 1 FROM Usuarios u WHERE u.cedula = d.cedula))
            THROW 50003, 'El Usuario no existe...', 1;

        IF EXISTS (SELECT 1 FROM inserted i WHERE NOT EXISTS (SELECT 1 FROM Roles r WHERE r.id = i.rol_id))
            THROW 50001, 'EL ROL NO ES VALIDO', 1;

        UPDATE u
        SET u.nombre = i.nombre, u.apellido = i.apellido, u.rol_id = i.rol_id
            FROM Usuarios u INNER JOIN inserted i ON u.cedula = i.cedula;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        ;THROW;
    END CATCH
END
GO


-- ====================================
-- ?            BITACORA
-- ====================================
CREATE OR ALTER TRIGGER trg_BitacoraUsuarios
ON Usuarios
AFTER INSERT, UPDATE, DELETE AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO Bitacora(id_dato, db_usuario, app_usuario, accion, tabla, datos_antes, datos_despues)
        SELECT 
            i.id,
            SYSTEM_USER,
            ISNULL(CAST(SESSION_CONTEXT(N'UsuarioApp') AS NVARCHAR(100)), 'Directo en BD'),
            'UPDATE',
            'Usuarios',
            (SELECT d.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
            (SELECT i.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        FROM inserted i
        INNER JOIN deleted d ON i.id = d.id;
    END

    ELSE IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO Bitacora(id_dato, db_usuario, app_usuario, accion, tabla, datos_antes, datos_despues)
        SELECT 
            i.id,
            SYSTEM_USER,
            ISNULL(CAST(SESSION_CONTEXT(N'UsuarioApp') AS NVARCHAR(100)), 'Directo en BD'),
            'INSERT',
            'Usuarios',
            NULL,
            (SELECT i.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        FROM inserted i;
    END

    ELSE IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO Bitacora(id_dato, db_usuario, app_usuario, accion, tabla, datos_antes, datos_despues)
        SELECT 
            d.id,
            SYSTEM_USER,
            ISNULL(CAST(SESSION_CONTEXT(N'UsuarioApp') AS NVARCHAR(100)), 'Directo en BD'),
            'DELETE',
            'Usuarios',
            (SELECT d.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
            NULL
        FROM deleted d;
    END
END;

