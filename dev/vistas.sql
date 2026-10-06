


-- * CREAR VISTAS 

CREATE VIEW dbo.VistaVerFunciones
AS
    SELECT name AS Nombre_FUNCIONES
    FROM sys.objects
    WHERE type IN ('FN', 'IF', 'TF'); 


SELECT * FROM dbo.VistaVerFunciones;


CREATE VIEW dbo.VistaProductos
AS
    SELECT 
        p.descripcion AS "Descripcion",
        m.nombre AS "Marca",
        p.precio AS "Precio del producto",
        dbo.CalcularPrecioConIVA(p.pagaIVA,p.porcentaje_iva,p.precio) AS "Precio con IVA"
        FROM Producto p
        INNER JOIN Marcas m ON m.id = p.marca_id; 

DROP VIEW dbo.VistaProductos;
SELECT * FROM dbo.VistaProductos;
