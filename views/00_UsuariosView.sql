-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- MÓDULO      : Usuarios
-- PROPÓSITO   : Vistas de Usuarios
-- AUTOR       : Francisco David Medina Lourenzo 
-- FECHA CREACION  : 2026-10-23


-- ? BORRAR LAS VIEWS
DROP VIEW dbo.vw_usuarios;
DROP VIEW dbo.vw_roles;



CREATE OR ALTER VIEW dbo.vw_usuarios AS
SELECT 
    u.id AS [IDENTIFICADOR],
    CONCAT(u.nombre,' ',u.apellido)  AS [NOMBRE COMPLETO],
    u.cedula AS [CEDULA],
    r.permiso AS [PERMISO],
    CASE u.estado
        WHEN 1 THEN 'Activo' 
        ELSE 'Inactivo' 
    END AS 'ESTADO'
    FROM Usuarios u
    INNER JOIN Roles r ON r.id = u.rol_id;


CREATE OR ALTER VIEW dbo.vw_roles AS 
SELECT id AS [IDENTIFICADOR],
    permiso AS [PERMISO],
    fecha_creacion AS [CREADO EN FECHA]FROM Roles;







