-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- PROPÓSITO       : TRIGGER GENERICO
-- AUTOR           : Francisco David Medina Lourenzo 
-- FECHA CREACION  : 2026-10-13


DROP PROCEDURE dbo.usp_RegistrarBitacora;

CREATE PROCEDURE dbo.usp_RegistrarBitacora
    @id_dato INT,
    @accion NVARCHAR(10),
    @tabla NVARCHAR(50),
    @datos_antes NVARCHAR(MAX),
    @datos_despues NVARCHAR(MAX) AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Bitacora (id_dato, db_usuario, app_usuario, accion, tabla, datos_antes, datos_despues)
    VALUES (
        @id_dato,
        SYSTEM_USER,
        ISNULL(CAST(SESSION_CONTEXT(N'UsuarioApp') AS NVARCHAR(100)), 'Directo en BD'),
        @accion,
        @tabla,
        @datos_antes,
        @datos_despues
    );
END;