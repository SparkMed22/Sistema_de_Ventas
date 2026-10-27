-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- PROPÓSITO   : Vistas de Movimieotos entre Depositos
-- AUTOR       : Francisco David Medina Lourenzo 
-- FECHA CREACION  : 2026-10-24


DROP VIEW dbo.vw_transferenciasDeposito;


CREATE OR ALTER VIEW dbo.vw_transferenciasDeposito AS
SELECT 
    tc.id AS [IDENTIFICADOR],
    CONCAT(ue.nombre, ' ', ue.apellido) AS [ENCARGADO],
    CONCAT(ua.nombre, ' ', ua.apellido) AS [AUTORIZADO],
    depO.nombre AS [DEPOSITO ORIGEN],
    depD.nombre AS [DEPOSITO DESTINO],    
    tc.fechaHora AS [FECHA DE OPERACION],
    (
        SELECT 
            td.id_producto AS [id_producto],
            td.cantidad AS [cantidad]
        FROM TransferenciaDetalleDesposito td
        WHERE td.id_TransferenciaCabeceraDesposito = tc.id
        FOR JSON PATH
    ) AS [DETALLES_JSON]
FROM TransferenciaCabeceraDesposito tc
INNER JOIN Usuarios ue ON ue.id = tc.id_usuario_encargado
INNER JOIN Usuarios ua ON ua.id = tc.id_usuario_autorizo
INNER JOIN Deposito depO ON depO.id = tc.id_dep_origen
INNER JOIN Deposito depD ON depD.id = tc.id_dep_destino;
GO
