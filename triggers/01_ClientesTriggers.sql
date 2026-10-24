-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- PROPÓSITO       : REGISTRAR LOS MOVIMIENTOS PARA GENERAR UNA BITACORA 
-- AUTOR           : Francisco David Medina Lourenzo 
-- FECHA CREACION  : 2026-10-13

DROP TRIGGER trg_BitacoraClientes_ai;
DROP TRIGGER trg_BitacoraClientes_ad;
DROP TRIGGER trg_BitacoraClientes_au;

CREATE OR ALTER TRIGGER trg_BitacoraClientes_ai ON Clientes
AFTER INSERT AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @id INT, @json NVARCHAR(MAX);    
    SELECT @id = id, @json = (SELECT * FROM inserted FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) 
    FROM inserted;
    EXEC dbo.usp_RegistrarBitacora @id, 'INSERT', 'Clientes', NULL, @json;
END;

GO


CREATE OR ALTER TRIGGER trg_BitacoraClientes_ad ON Clientes
AFTER DELETE AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Bitacora(id_dato, db_usuario, app_usuario, accion,tabla, datos_antes, datos_despues)
    SELECT 
        d.id,
        SYSTEM_USER,
        'Directo en BD',
        'DELETE',
        'Clientes',
        (SELECT d.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
        NULL
    FROM deleted d;
END;


CREATE OR ALTER TRIGGER trg_BitacoraClientes_au ON Clientes
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Bitacora(id_dato, db_usuario, app_usuario, accion, tabla, datos_antes, datos_despues)
    SELECT 
        i.id,
        SYSTEM_USER,
        ISNULL(CAST(SESSION_CONTEXT(N'UsuarioApp') AS NVARCHAR(100)), 'Directo en BD'),
        'UPDATE',
        'Clientes',
        (SELECT d.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
        (SELECT i.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
    FROM inserted i
    INNER JOIN deleted d ON i.id = d.id;
END;