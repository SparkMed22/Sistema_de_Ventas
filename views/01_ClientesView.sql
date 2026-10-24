-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- PROPÓSITO   : Vistas de Clientes
-- AUTOR       : Francisco David Medina Lourenzo 
-- FECHA CREACION  : 2026-10-23


DROP VIEW dbo.vw_clientes;

CREATE OR ALTER VIEW dbo.vw_clientes AS
SELECT id AS [IDENTIFICADOR],
    cedula AS [CEDULA],
    nombre AS [NOMBRE DEL CLIENTE],
    telefono AS [CONTACTO],
    direccion AS [UBICACION],
    credito AS [CREDITO DISPONIBLE],
    SALDO AS [DEUDA] 
    FROM Clientes;