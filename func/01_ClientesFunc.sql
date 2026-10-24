-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- MÓDULO          : FUNCIONES
-- OBJETO          : Clientes
-- PROPÓSITO       : funciones correspondientes a la tabla Clientes
-- AUTOR           : Francisco David Medina Lourenzo 
-- FECHA CREACION  : 2026-10-13

CREATE OR ALTER FUNCTION dbo.fn_ClienteExiste(@cedula NVARCHAR(20))
RETURNS BIT AS
BEGIN
    IF EXISTS (SELECT 1 FROM Clientes WHERE cedula=@cedula) RETURN 1; 
    RETURN 0;
END
