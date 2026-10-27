-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- PROPÓSITO   : Cargar datos por Defecto y TESTEAR
-- AUTOR       : Francisco David Medina Lourenzo 
-- FECHA CREA  : 2026-10-02


-- ====================================
-- ?        USUARIOS Y ROLES 
-- ====================================

INSERT INTO Roles (permiso) VALUES ('Administrador'),('Gerente'),('Operario');
SELECT * FROM dbo.vw_roles;


EXEC dbo.usp_crearUsuario '5142326','Spark', 'Med', 1;
INSERT INTO Usuarios (cedula,nombre, apellido, rol_id) VALUES ('4569745','Ana', 'Martinez', 2);
EXEC dbo.usp_crearUsuario '4806504','Jorge', 'Ruiz', 3;
EXEC dbo.usp_crearUsuario '4563785','Ana', 'Mareco', 1;
EXEC dbo.usp_borrarUsuario '4563785';
EXEC  dbo.usp_actualizarUsuario '5142326', 'Spark','Med',1;

SELECT * FROM dbo.vw_usuarios;
SELECT * FROM dbo.vw_roles;
SELECT * FROM Bitacora WHERE tabla='Usuarios';


-- ====================================
-- ?        CLIENTES
-- ====================================
EXEC dbo.usp_crearCliente '2475635','Carlos Gómez', 'Av. Mcal. López 1450', '+595 981 123456', 'carlos.gomez@email.com', 5000000.00;
EXEC dbo.usp_crearCliente '4215369','María Lucía Benítez', 'Calle Palma 452', '(021) 445-890', 'mbenitez@empresa.com.py', 10000000.00;
EXEC dbo.usp_crearCliente '4156325','Elena Rostova', 'Av. España 890', '0982-111-222', 'elena.rostova@dominguez.org', 2500000.00;
EXEC dbo.usp_crearCliente '4752369','Esteban Quito', 'General Díaz 123', '+1 555 0192', 'equito@servicio-cliente.net', 1500000.0;
EXEC dbo.usp_borrarCliente '4215369';
SELECT * FROM Bitacora WHERE tabla='Clientes';
SELECT * FROM dbo.vw_clientes;



-- ================================================
-- ?        Marcas, Marcas, PRODUCTOS 
-- ================================================

INSERT INTO Marcas (nombre) VALUES
    ('Michelin'),
    ('Bridgestone'),
    ('Goodyear'),
    ('Pirelli'),
    ('Continental'),
    ('Nokian'),
    ('Bosch'),
    ('Mann Filter'),
    ('Castrol'),
    ('Mobil'),
    ('Shell'),
    ('Valvoline');      


INSERT INTO TiposProducto (nombre) VALUES
    ('Servicio'),
    ('Neumático'),
    ('Filtro de Aceite'),
    ('Filtro de Aire'),
    ('Filtro de Combustible'),
    ('Aceite de Motor'),
    ('Pastillas de Freno'),
    ('Batería'),
    ('Amortiguador'),
    ('Bujía'),
    ('Correa de Distribución');




EXEC dbo.usp_crearProducto 
    @descripcion = 'Neumático 195/65 R15 91H Primacy 4', 
    @es_servicio = 0, 
    @tipo_producto_id = 2, 
    @precio = 85000.00, 
    @compra = 52000.00, 
    @pagaIVA = 1, 
    @porcentaje_iva = 21.00, 
    @marca_id = 2;


EXEC dbo.usp_crearProducto 
    @descripcion = 'Neumático 205/55 R16 94V Asymetric 6', 
    @es_servicio = 0, 
    @tipo_producto_id = 2, 
    @precio = 92000.00, 
    @compra = 58000.00, 
    @pagaIVA = 1, 
    @porcentaje_iva = 21.00, 
    @marca_id = 4;


EXEC dbo.usp_crearProducto 
    @descripcion = 'Neumático 225/45 R17 91Y Potenza', 
    @es_servicio = 0, 
    @tipo_producto_id = 2, 
    @precio = 110000.00, 
    @compra = 70000.00, 
    @pagaIVA = 1, 
    @porcentaje_iva = 21.00, 
    @marca_id = 4;


EXEC dbo.usp_crearProducto 
    @descripcion = 'Aceite 5W-30 Sintético 1L Castrol Edge', 
    @es_servicio = 0, 
    @tipo_producto_id = 7, 
    @precio = 8500.00, 
    @compra = 5200.00, 
    @pagaIVA = 1, 
    @porcentaje_iva = 21.00, 
    @marca_id = 9;
EXEC dbo.usp_crearProducto 
    @descripcion = 'Aceite 10W-40 Semi-Sintético 4L Castrol Magnatec', 
    @es_servicio = 0, 
    @tipo_producto_id = 7, 
    @precio = 28000.00, 
    @compra = 17500.00, 
    @pagaIVA = 1, 
    @porcentaje_iva = 21.00, 
    @marca_id = 9;
EXEC dbo.usp_crearProducto 
    @descripcion = 'Aceite 0W-20 Sintético 1L Mobil 1', 
    @es_servicio = 0, 
    @tipo_producto_id = 7, 
    @precio = 9200.00, 
    @compra = 5800.00, 
    @pagaIVA = 1, 
    @porcentaje_iva = 21.00, 
    @marca_id = 10;

EXEC dbo.usp_crearProducto 
    @descripcion = 'Filtro de Aceite W0414 Bosch', 
    @es_servicio = 0, 
    @tipo_producto_id = 4, 
    @precio = 4500.00, 
    @compra = 2200.00, 
    @pagaIVA = 1, 
    @porcentaje_iva = 21.00, 
    @marca_id = 7;
EXEC dbo.usp_crearProducto 
    @descripcion = 'Filtro de Aceite H 13/100 Mann', 
    @es_servicio = 0, 
    @tipo_producto_id = 4, 
    @precio = 3800.00, 
    @compra = 1900.00, 
    @pagaIVA = 1, 
    @porcentaje_iva = 21.00, 
    @marca_id = 8;
EXEC dbo.usp_crearProducto 
    @descripcion = 'Filtro de Aire A 31 Si Mann', 
    @es_servicio = 0, 
    @tipo_producto_id = 4, 
    @precio = 5200.00, 
    @compra = 2600.00, 
    @pagaIVA = 1, 
    @porcentaje_iva = 21.00, 
    @marca_id = 8;
EXEC dbo.usp_crearProducto 
    @descripcion = 'Filtro de Combustible W 940/1 Bosch', 
    @es_servicio = 0, 
    @tipo_producto_id = 4, 
    @precio = 3500.00, 
    @compra = 1700.00, 
    @pagaIVA = 1, 
    @porcentaje_iva = 21.00, 
    @marca_id = 7;




EXEC dbo.usp_crearProducto 
    @descripcion = 'Cambio de Aceite y Filtro', 
    @es_servicio = 1, 
    @tipo_producto_id = 1,
    @precio = 15000.00, 
    @compra = 5000.00, 
    @pagaIVA = 0, 
    @porcentaje_iva = 0.00, 
    @marca_id = NULL;
EXEC dbo.usp_crearProducto 
    @descripcion = 'Balanceo y Alineación', 
    @es_servicio = 1, 
    @tipo_producto_id = 1, 
    @precio = 12000.00, 
    @compra = 4000.00, 
    @pagaIVA = 0, 
    @porcentaje_iva = 0.00, 
    @marca_id = NULL;
EXEC dbo.usp_crearProducto 
    @descripcion = 'Cambio de Neumático (x4)', 
    @es_servicio = 1, 
    @tipo_producto_id = 1, 
    @precio = 20000.00, 
    @compra = 8000.00, 
    @pagaIVA = 0, 
    @porcentaje_iva = 0.00, 
    @marca_id = NULL;

EXEC dbo.usp_crearProducto 
    @descripcion = 'Revisión de Frenos', 
    @es_servicio = 1, 
    @tipo_producto_id = 1, 
    @precio = 8000.00, 
    @compra = 3000.00, 
    @pagaIVA = 0, 
    @porcentaje_iva = 0.00, 
    @marca_id = NULL;


EXEC dbo.usp_actualizarProducto 
    @id = 4,
    @descripcion = 'Neumático 185/60 R14 82H T005 (Actualizado)', 
    @es_servicio = 0, 
    @tipo_producto_id = 1, 
    @precio = 72000.00, 
    @compra = 45000.00, 
    @pagaIVA = 1, 
    @porcentaje_iva = 21.00, 
    @marca_id = 5,
    @estado = 1;



EXEC dbo.usp_actualizarProducto 
    @id = 1,
    @descripcion = 'Neumático 195/65 R15 91H Primacy 4', 
    @es_servicio = 0, 
    @tipo_producto_id = 2, 
    @precio = 85000.00, 
    @compra = 52000.00, 
    @pagaIVA = 1, 
    @porcentaje_iva = 21.00, 
    @marca_id = 2;

EXEC dbo.usp_actualizarProducto 
    @id = 2,
    @descripcion = 'Neumático 205/55 R16 94V Asymetric 6', 
    @es_servicio = 0, 
    @tipo_producto_id = 2, 
    @precio = 92000.00, 
    @compra = 58000.00, 
    @pagaIVA = 1, 
    @porcentaje_iva = 21.00, 
    @marca_id = 4;

EXEC  dbo.usp_borrarProducto 1;
SELECT * FROM Bitacora WHERE tabla='Producto';
SELECT * FROM dbo.vw_productos;


-- ====================================
-- ?            DEPOSITO
-- ====================================
INSERT INTO TipoDeposito (nombre) VALUES ('Depósito general'), ('Salón de ventas');
EXEC dbo.usp_crearDeposito 'Almacén Principal','Av. Industrial 101',1;
EXEC dbo.usp_crearDeposito 'Tienda Centro','Calle Principal 55',2;
EXEC dbo.usp_crearDeposito 'Bodega Norte','Ruta 5, Km 10',1;
EXEC dbo.usp_crearDeposito 'Bodega Norte S.A','Ruta 8, Km 10',1;
EXEC dbo.ups_desactivarDeposito 1;
EXEC dbo.ups_activarDeposito 1;
EXEC dbo.ups_borrarDeposito 4;

EXEC dbo.usp_actualizarDeposito 
    @id = 1,                              
    @nombre = 'Depósito Central Actualizado', 
    @direccion = 'Nueva Av. Principal 123', 
    @idTipoDeposito = 2,                 
    @estado = 1;                          

SELECT * FROM Bitacora WHERE tabla='Deposito';
SELECT * FROM dbo.vw_depositos;


-- ====================================
-- ?            INVENTARIO
-- ====================================

--dbo.usp_agregarInventario @deposito_id INT, @producto_id INT, @stock INT  
EXEC dbo.usp_agregarInventario 2,2,8;

-- ! TIRA ERROR ES UN SERVICIO NO PUEDE TENER INVENTARIO
EXEC dbo.usp_agregarInventario 2,11,10;

EXEC dbo.usp_agregarInventario 7,2,8;
EXEC dbo.usp_restarInventario 7,2,6;


SELECT * FROM Inventario;

SELECT * FROM Bitacora WHERE tabla='Inventario';

-- ? Stocks de productos. (1)
SELECT * FROM dbo.vw_inventario;


-- ====================================
-- ?            MOVIMOENTO DEPOSITO
-- ====================================

TRUNCATE TABLE TransferenciaCabeceraDesposito;
DROP TABLE TransferenciaCabeceraDesposito;

DECLARE @nuevoId INT;

EXEC dbo.usp_crearTransferenciaDeposito
    @id_dep_origen = 7,
    @id_dep_destino = 2,
    @id_usuario_encargado = 2,
    @id_usuario_autorizo = 6,
    @obs_operacion = 'Prueba de transferencia',
    @id_transferencia_generado = @nuevoId OUTPUT;

SELECT @nuevoId AS ID_Transferencia_Creado;

GO
SELECT * FROM TransferenciaCabeceraDesposito;
GO

EXEC dbo.usp_crearTransferenciaDepositoDetalle @id_TransferenciaCabeceraDesposito = 2, @id_producto = 2, @cantidad = 5;

SELECT * FROM Bitacora WHERE tabla='TransferenciaCabeceraDesposito';



-- ====================================
-- ?            VENTA 
-- ====================================

INSERT INTO CondicionVenta(condicon) VALUES('CONTADO'),('CREDITO');