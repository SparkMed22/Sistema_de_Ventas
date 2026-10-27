
CREATE FUNCTION dbo.CalcularPrecioConDescuento(@Precio DECIMAL(10,2),@porcentaje_descuento DECIMAL(10,2))
RETURNS DECIMAL(10, 2)
AS 
BEGIN
    RETURN( @Precio - (@Precio * (@porcentaje_descuento/100)) )
END

