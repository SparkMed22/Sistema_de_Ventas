


-- ====================================
-- ?            VENTA
-- ====================================

DROP FUNCTION dbo.fn_ExisteFacturaValida;

CREATE OR ALTER FUNCTION dbo.fn_ExisteFacturaValida (@id_factura INT) 
RETURNS INT AS
BEGIN
    IF EXISTS (SELECT 1 FROM Factura WHERE id=@id_factura AND estado='EMITIDA') RETURN 1;
    RETURN 0;
END



GO 
-- ====================================
-- ?            DETALLE DE FACTURA
-- ====================================

DROP FUNCTION dbo.fn_CalcularPrecioFactura;

CREATE OR ALTER FUNCTION dbo.fn_CalcularPrecioFactura(
    @pagaIVA BIT,
    @porcentaje_iva DECIMAL(10,2),
    @porcentaje_descuento DECIMAL(10,2),
    @precio DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN ROUND(
        @precio 
        * (1.0 - ISNULL(@porcentaje_descuento, 0) / 100.0) 
        * CASE WHEN @pagaIVA = 1 THEN (1.0 + ISNULL(@porcentaje_iva, 0) / 100.0) ELSE 1.0 END, 
        2
    );
END;