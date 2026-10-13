-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- PROPÓSITO       : REGISTRAR LOS MOVIMIENTOS PARA GENERAR UNA BITACORA 
-- AUTOR           : Francisco David Medina Lourenzo 
-- FECHA CREACION  : 2026-10-13


CREATE TRIGGER trg_BitacoraUsuarios_ai ON Usuarios
AFTER INSERT AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO Bitacora(id_dato, db_usuario, app_usuario, accion, tabla,datos_antes, datos_despues)
    SELECT 
        i.id,
        SYSTEM_USER,
        ISNULL(CAST(SESSION_CONTEXT(N'UsuarioApp') AS NVARCHAR(100)), 'Directo en BD'),
        'INSERT',
        'Usuarios',
        NULL,
        (SELECT i2.* FROM inserted i2 WHERE i2.id = i.id FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
    FROM inserted i;
END;


CREATE TRIGGER trg_BitacoraUsuarios_ad ON Usuarios
AFTER DELETE AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Bitacora(id_dato, db_usuario, app_usuario, accion,tabla, datos_antes, datos_despues)
    SELECT 
        d.id,
        SYSTEM_USER,
        'Directo en BD',
        'DELETE',
        'Usuarios',
        (SELECT d.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
        NULL
    FROM deleted d;
END;


CREATE OR ALTER TRIGGER trg_BitacoraUsuarios_au ON Usuarios
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
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
END;



DROP TRIGGER trg_BitacoraUsuarios_ai;
DROP TRIGGER trg_BitacoraUsuarios_ad;
DROP TRIGGER trg_BitacoraUsuarios_au;