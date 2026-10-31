-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- PROPÓSITO       : Procedimientos Almacenado para Venta
-- AUTOR           : Francisco David Medina Lourenzo 
-- FECHA CREACION  : 2026-10-28


-- ====================================
-- ?            VENTA
-- ====================================

-- ! CODIGO DE ERRORES
-- ERROR 50130 = La condicion de venta no es valida
-- ERROR 50131 = La fecha de vencimiento es obligatoria para este tipo de venta
-- ERROR 50132 = La fecha de vencimiento no puede ser anterior a la fecha de hoy
-- ERROR 50133 = La fecha de vencimiento excede el plazo máximo permitido (1 año)

DROP PROCEDURE dbo.usp_crearFactura;

-- ? Logica de Negocio hasta 12 meses (1 año)
CREATE OR ALTER PROCEDURE dbo.usp_crearFactura
    @id_usuario INT,
    @id_cliente INT,
    @id_deposito INT,
    @id_condicionVenta INT,
    @fechaVencimiento DATE,
    @id_factura_generada INT OUTPUT 
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF dbo.fn_UsuarioExiste(@id_usuario) = 0 THROW 50003, 'El Usuario no existe...', 1;
        IF dbo.fn_ClienteExisteID(@id_cliente) = 0 THROW 50051, 'El Cliente no Existe', 1;
        IF dbo.fn_DepositoActivoExiste(@id_deposito) = 0 THROW 50106, 'El depósito especificado no existe o está Inactivo', 1;
        IF @id_condicionVenta NOT IN (1, 2) THROW 50130, 'La condición de venta no es válida', 1;
        IF @fechaVencimiento IS NULL THROW 50131, 'La fecha de vencimiento es obligatoria para este tipo de venta', 1;
        IF @fechaVencimiento < CAST(GETDATE() AS DATE) THROW 50132, 'La fecha de vencimiento no puede ser anterior a la fecha de hoy', 1;
        IF @fechaVencimiento > DATEADD(YEAR, 1, CAST(GETDATE() AS DATE)) 
            THROW 50133, 'La fecha de vencimiento excede el plazo máximo permitido (1 año)', 1;

        DECLARE @codigo_establecimiento INT;
        DECLARE @numero_factura NVARCHAR(50);
        DECLARE @secuencial BIGINT;

        SELECT @codigo_establecimiento = codigo_establecimiento 
        FROM Deposito 
        WHERE id = @id_deposito;

        SET @secuencial = NEXT VALUE FOR dbo.SeqFactura;

        SET @numero_factura = CONCAT(
                @codigo_establecimiento, '-', 
                FORMAT(GETDATE(), 'yyyyMMdd'), '-', 
                RIGHT('000000' + CAST(@secuencial AS VARCHAR), 6)
        );
        BEGIN TRANSACTION;
            INSERT INTO Factura (numero_factura,id_usuario,id_cliente,id_deposito,id_condicionVenta,fechaVencimiento)
            VALUES (@numero_factura,@id_usuario,@id_cliente,@id_deposito,@id_condicionVenta,@fechaVencimiento);
            SET @id_factura_generada = SCOPE_IDENTITY();
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH 
END;
GO



-- ======================================================
-- ?            DETALLES DE VENTA
-- ======================================================

-- ! CODIGO DE ERRORES
-- ERROR 50134 = La Factura no es valida o ya esta pagada
-- ERROR 50135 = El cliente no cuenta con suficiente crédito disponible para realizar esta operación.
-- ERROR 50136 = La cantidad debe ser mayor que cero.
-- ERROR 50133 = No se encontró la factura o su cliente.
-- ERROR 50138 = No se pudo calcular el precio final UNITARIO.
-- ERROR 50139 = No se pudo determinar el crédito del cliente.
DROP PROCEDURE dbo.usp_crearDetalleFactura;



CREATE OR ALTER PROCEDURE dbo.usp_crearDetalleFactura
    @id_factura INT,
    @id_producto INT,
    @cantidad INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        IF @id_factura IS NULL OR @id_factura <= 0
            THROW 50134, 'El identificador de factura no es válido.', 1;

        IF @id_producto IS NULL OR @id_producto <= 0
            THROW 50111, 'El identificador de producto no es válido.', 1;

        IF @cantidad IS NULL OR @cantidad <= 0
            THROW 50136, 'La cantidad debe ser mayor que cero.', 1;

        BEGIN TRANSACTION;

            DECLARE
                @id_deposito INT,
                @id_condicionVenta INT,
                @id_cliente INT,
                @es_servicio BIT,
                @precio_venta_unitario DECIMAL(18,2),
                @pagaIVA BIT,
                @porcentaje_iva DECIMAL(18,2),
                @porsentaje_descuento DECIMAL(18,2),
                @precio_venta_final_unitario DECIMAL(18,2),
                @precio_venta_final DECIMAL(18,2);

            SELECT
                @id_deposito = id_deposito,
                @id_condicionVenta = id_condicionVenta,
                @id_cliente = id_cliente
            FROM dbo.Factura WITH (UPDLOCK, HOLDLOCK)
            WHERE id = @id_factura;

            IF @@ROWCOUNT = 0
                THROW 50134, 'La factura no existe.', 1;

            IF dbo.fn_ExisteFacturaValida(@id_factura) = 0
                THROW 50139, 'La factura no es válida o ya fue pagada.', 1;

            IF @id_cliente IS NULL
                THROW 50133, 'La factura no tiene un cliente válido.', 1;

            IF @id_deposito IS NULL OR @id_condicionVenta IS NULL
                THROW 50140, 'La factura no tiene configurados todos los datos necesarios.', 1;

            SELECT
                @es_servicio = p.es_servicio,
                @precio_venta_unitario = p.precio_venta,
                @pagaIVA = p.pagaIVA,
                @porcentaje_iva = p.porcentaje_iva
            FROM dbo.Producto AS p
            WHERE p.id = @id_producto;

            IF @@ROWCOUNT = 0
                THROW 50111, 'El producto no existe.', 1;

            IF @es_servicio IS NULL
                THROW 50136, 'El tipo de producto no está definido.', 1;

            IF @precio_venta_unitario IS NULL OR @precio_venta_unitario < 0
                THROW 50137, 'El precio de venta no es válido.', 1;

            IF @pagaIVA IS NULL OR @porcentaje_iva IS NULL
                THROW 50138, 'La configuración del IVA del producto no está definida.', 1;

            IF @es_servicio = 1
            BEGIN
                SET @precio_venta_final_unitario =
                    CASE @id_condicionVenta
                        WHEN 1 THEN dbo.fn_CalcularPrecioFactura(@pagaIVA, @porcentaje_iva, 10,@precio_venta_unitario)
                        WHEN 2 THEN dbo.fn_CalcularPrecioFactura(@pagaIVA, @porcentaje_iva, 5,@precio_venta_unitario)
                        ELSE @precio_venta_unitario
                    END;
                SET @porsentaje_descuento = 
                    CASE @id_condicionVenta 
                        WHEN 1 THEN 10
                        WHEN 2 THEN 5
                        ELSE 0
                    END;
            END
            ELSE
            BEGIN
                SET @precio_venta_final_unitario =
                    dbo.fn_CalcularPrecioFactura(@pagaIVA, @porcentaje_iva, 0,@precio_venta_unitario);
                SET @porsentaje_descuento = 0;
            END;

            IF @precio_venta_final_unitario IS NULL
                THROW 50141, 'No se pudo calcular el precio final unitario.', 1;

            IF @precio_venta_final_unitario < 0
                THROW 50142, 'El precio final calculado no puede ser negativo.', 1;

            SET @precio_venta_final =
            @precio_venta_final_unitario * @cantidad;
            
            IF @id_condicionVenta = 2
            BEGIN
                EXEC dbo.usp_incrementarSaldoCliente
                    @id_cliente = @id_cliente,
                    @saldo = @precio_venta_final;
            END;

            IF @es_servicio = 0
            BEGIN
                EXEC dbo.usp_restarInventario
                    @deposito_id = @id_deposito,
                    @producto_id = @id_producto,
                    @stock = @cantidad;
            END;
            INSERT INTO FacturaDetalle (id_factura,id_producto,cantidad,porsentaje_descuento,porcentaje_iva,precio_unitario,precio_venta)
            VALUES(@id_factura,@id_producto,@cantidad,@porsentaje_descuento,@porcentaje_iva,@precio_venta_final_unitario,@precio_venta_final);

            UPDATE Factura SET total = total + @precio_venta_final WHERE id = @id_factura;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;

