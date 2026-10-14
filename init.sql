-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- MÓDULO      : CREACION DE LA BASE DE DATOS , ERRAMIENTAS (Vistas de la base de datos) y Bitacora
-- PROPÓSITO   : CREAR LA BASE DE DATOS
-- AUTOR       : Francisco David Medina Lourenzo 
-- FECHA CREACION  : 2026-10-03 

CREATE DATABASE ModuloVentasDB;


-- * BITACORA DEL EL SISTEMA 
-- ? ACCION = INSERT UPDATE DELETE
-- ? db_usuario = Usuario de la base de datos 
--? app_usuario = usuario generico para app
CREATE TABLE Bitacora(
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_dato INT,
    db_usuario NVARCHAR(50),
    app_usuario NVARCHAR(100),
    accion NVARCHAR(10) NOT NULL,
    tabla NVARCHAR(50) NOT NULL,
    datos_antes NVARCHAR(MAX),
    datos_despues NVARCHAR(MAX),
    fecha_cambio DATETIME DEFAULT GETDATE()
);


CREATE VIEW dbo.vw_tables
    AS SELECT name AS 'TABLAS' FROM SYS.TABLES; 

CREATE  VIEW dbo.vw_views
    AS SELECT name AS 'Vistas' FROM SYS.VIEWS;

CREATE VIEW dbo.vw_procedures  
    AS SELECT name AS 'Procedimientos' FROM sys.PROCEDURES;

CREATE VIEW dbo.vw_triggers
    AS SELECT name AS 'Triggers' FROM sys.Triggers;


CREATE VIEW dbo.vw_func 
    AS SELECT 
            schema_name(schema_id) AS [Esquema],
            name AS [Nombre_Funcion],
            type_desc AS [Tipo_Funcion],
            create_date AS [Fecha_Creacion]
        FROM sys.objects
        WHERE type IN ('FN', 'IF', 'TF', 'FS', 'FT')
          AND is_ms_shipped = 0;


-- ! USO RAPIDO DE CADA UNO 
SELECT * FROM  dbo.vw_tables;
SELECT * FROM dbo.vw_views;
SELECT * FROM dbo.vw_procedures;
SELECT * FROM dbo.vw_triggers;
SELECT * FROM dbo.vw_func;