-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- MÓDULO          : FUNCIONES
-- PROPÓSITO       : Funciones correspondientes a la tabla Usuarios
-- AUTOR           : Francisco David Medina Lourenzo 
-- FECHA CREACION  : 2026-10-24


DROP FUNCTION dbo.fn_UsuarioExiste;

CREATE OR ALTER FUNCTION dbo.fn_UsuarioExiste(@id INT)
RETURNS BIT AS
BEGIN
    IF EXISTS (SELECT 1 FROM Usuarios WHERE id=@id) RETURN 1; 
    RETURN 0;
END