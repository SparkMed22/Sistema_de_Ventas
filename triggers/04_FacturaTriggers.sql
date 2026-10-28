

CREATE OR ALTER TRIGGER trg_BitacoraFactura
ON Factura
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
            'Factura',
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
            'Factura',
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
            'Factura',
            (SELECT d.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
            NULL
        FROM deleted d;
    END
END;