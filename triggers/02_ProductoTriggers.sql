-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- PROPÓSITO       : REGISTRAR LOS MOVIMIENTOS PARA GENERAR UNA BITACORA 
-- AUTOR           : Francisco David Medina Lourenzo 
-- FECHA CREACION  : 2026-10-15


DROP TRIGGER trg_BitacoraProducto;


CREATE OR ALTER TRIGGER trg_BitacoraProducto
ON Producto
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
            'Producto',
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
            'Producto',
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
            'Producto',
            (SELECT d.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
            NULL
        FROM deleted d;
    END
END;
GO


CREATE OR ALTER TRIGGER trg_BitacoraDeposito
ON Deposito
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
            'Deposito',
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
            'Deposito',
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
            'Deposito',
            (SELECT d.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
            NULL
        FROM deleted d;
    END
END;