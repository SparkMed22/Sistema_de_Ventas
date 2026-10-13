-- * FUNCION DE BLOQUE 
-- ! Siempre deben retornar algo
-- ! Porque una función es solo para calcular o transformar datos, no para modificarlos. Es "de solo lectura".
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
-- ! Porque una función es solo para calcular o transformar datos, no para modificarlos. Es "de solo lectura".
-- ! (Son mas para modifocar la Base de datos)
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

DROP PROCEDURE dbo.usp_crearUsuario;



CREATE PROCEDURE dbo.usp_crearUsuario @cedula NVARCHAR(20), @nombre NVARCHAR(50), @apellido NVARCHAR(50), @rol_id INT 
AS
BEGIN
    SET NOCOUNT ON; -- ? EVITAR MANDAR NOTIFICACIONES

    BEGIN TRY  
        BEGIN TRANSACTION;
        IF NOT EXISTS (SELECT 1 FROM Roles WHERE id=@rol_id)
        BEGIN
            RAISERROR('El ID del Rol no EXISTE',16,1);
        END

        IF EXISTS (SELECT 1 FROM Usuarios WHERE cedula=@cedula)
        BEGIN
            RAISERROR('La cedula ya existe para un usuario.', 16, 1);
        END
        INSERT INTO Usuarios(cedula,nombre,apellido,rol_id)
        VALUES (@cedula, @nombre, @apellido, @rol_id);

        COMMIT TRANSACTION;
        PRINT 'Usuario creado con éxito...';
    END TRY
    BEGIN CATCH
        -- ! Deshaser los cambios
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END


EXEC dbo.usp_crearUsuario '5142326','Spark', 'Med', 1;

--('4569745','Ana', 'Martinez', 2),  
--('4806504','Jorge', 'Ruiz', 3);    


