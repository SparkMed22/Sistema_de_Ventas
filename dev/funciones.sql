-- * FUNCION DE BLOQUE 
CREATE FUNCTION dbo.CalcularPrecioConIVA(@pagaIVA BIT ,@porcentaje_iva DECIMAL(10,2),@Precio DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN(
        CASE
            WHEN @pagaIVA = 1 THEN @Precio + (@Precio * (@porcentaje_iva/100))
            ELSE 0.00
        END
    );
END;

-- ! ELIMINAR Y COMO USAR
--DROP FUNCTION dbo.CalcularPrecioConIVA;
--SELECT dbo.CalcularPrecioConIVA(1,10,100) AS "IVA";

CREATE FUNCTION dbo.CalcularPrecioConDescuento(@Precio DECIMAL(10,2),@porcentaje_descuento DECIMAL(10,2))
RETURNS DECIMAL(10, 2)
AS 
BEGIN
    RETURN( @Precio - (@Precio * (@porcentaje_descuento/100)) )
END

-- ! ELIMINAR Y COMO USAR
-- DROP FUNCTION dbo.CalcularPrecioConDescuento;
-- SELECT dbo.CalcularPrecioConDescuento(1000,20) AS "DESCUENTO"


-- * Procedimientos Almacenado

CREATE PROCEDURE dbo.InsertarProducto
    @descripcion NVARCHAR(255),
    @es_servicio BIT,
    @marca_id INT,  
    @tipo_producto_id INT,
    @precio DECIMAL(18, 2),
    @compra DECIMAL(18, 2),
    @pagaIVA BIT,
    @porcentaje_iva DECIMAL(18,2)
AS 
BEGIN
    IF @precio < 0
    BEGIN
        PRINT 'EL PRECIO DEBE SER MAYOR A CERO';
        RETURN;
    END
    INSERT INTO Producto (descripcion, es_servicio, marca_id, tipo_producto_id, precio, compra, pagaIVA, porcentaje_iva) 
    VALUES (@descripcion,@es_servicio,@marca_id,  @tipo_producto_id,@precio,@compra,@pagaIVA,@porcentaje_iva); 
END;

-- ! ELIMINAR Y COMO USAR
--DROP PROCEDURE dbo.InsertarProducto;
--EXEC dbo.InsertarProducto 'Smartphone Galaxy S24', 0, 3, 3, 800.00, 450.00, 1, 16.00;