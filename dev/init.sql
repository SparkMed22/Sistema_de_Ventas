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


EXEC dbo.usp_crearProducto @descripcion = 'Neumático 185/60 R14 82H T005', @es_servicio = 0, @tipo_producto_id = 1, @precio = 68000.00, @compra = 42000.00, @pagaIVA = 1, @porcentaje_iva = 21.00, @marca_id = 5;
EXEC dbo.usp_crearProducto @descripcion = 'Neumático 215/60 R16 99H Turanza', @es_servicio = 0, @tipo_producto_id = 1, @precio = 78000.00, @compra = 48000.00, @pagaIVA = 1, @porcentaje_iva = 21.00, @marca_id = 2;
EXEC dbo.usp_crearProducto @descripcion = 'Neumático 235/35 R19 106Y XL', @es_servicio = 0, @tipo_producto_id = 1, @precio = 125000.00, @compra = 80000.00, @pagaIVA = 1, @porcentaje_iva = 21.00, @marca_id = 3;
EXEC dbo.usp_crearProducto @descripcion = 'Neumático 165/70 R13 79T Hakka', @es_servicio = 0, @tipo_producto_id = 1, @precio = 55000.00, @compra = 33000.00, @pagaIVA = 1, @porcentaje_iva = 21.00, @marca_id = 6;
EXEC dbo.usp_crearProducto @descripcion = 'Neumático 235/35 R13 79T Hakka', @es_servicio = 0, @tipo_producto_id = 1, @precio = 55000.00, @compra = 33000.00, @pagaIVA = 1, @porcentaje_iva = 21.00, @marca_id = 6;
EXEC dbo.usp_crearProducto @descripcion = 'Aceite 5W-30 Sintético 1L Castrol Edge', @es_servicio = 0, @tipo_producto_id = 5, @precio = 8500.00, @compra = 5200.00, @pagaIVA = 1, @porcentaje_iva = 21.00, @marca_id = 9;
EXEC dbo.usp_crearProducto @descripcion = 'Aceite 10W-40 Semi-Sintético 4L Castrol Magnatec', @es_servicio = 0, @tipo_producto_id = 5, @precio = 28000.00, @compra = 17500.00, @pagaIVA = 1, @porcentaje_iva = 21.00, @marca_id = 9;
EXEC dbo.usp_crearProducto @descripcion = 'Aceite 0W-20 Sintético 1L Mobil 1', @es_servicio = 0, @tipo_producto_id = 5, @precio = 9200.00, @compra = 5800.00, @pagaIVA = 1, @porcentaje_iva = 21.00, @marca_id = 10;
EXEC dbo.usp_crearProducto @descripcion = 'Aceite 5W-30 Sintético 4L Shell Helix', @es_servicio = 0, @tipo_producto_id = 5, @precio = 32000.00, @compra = 20000.00, @pagaIVA = 1, @porcentaje_iva = 21.00, @marca_id = 11;
EXEC dbo.usp_crearProducto @descripcion = 'Aceite 15W-40 Mineral 20L Mobil Delux', @es_servicio = 0, @tipo_producto_id = 5, @precio = 45000.00, @compra = 28000.00, @pagaIVA = 1, @porcentaje_iva = 21.00, @marca_id = 10;
EXEC dbo.usp_crearProducto @descripcion = 'Aceite 10W-30 Semi-Sintético 1L Valvoline', @es_servicio = 0, @tipo_producto_id = 5, @precio = 7500.00, @compra = 4500.00, @pagaIVA = 1, @porcentaje_iva = 21.00, @marca_id = 12;
EXEC dbo.usp_crearProducto @descripcion = 'Filtro de Aceite W0414 Bosch', @es_servicio = 0, @tipo_producto_id = 2, @precio = 4500.00, @compra = 2200.00, @pagaIVA = 1, @porcentaje_iva = 21.00, @marca_id = 7;
EXEC dbo.usp_crearProducto @descripcion = 'Filtro de Aceite H 13/100 Mann', @es_servicio = 0, @tipo_producto_id = 2, @precio = 3800.00, @compra = 1900.00, @pagaIVA = 1, @porcentaje_iva = 21.00, @marca_id = 8;
EXEC dbo.usp_crearProducto @descripcion = 'Filtro de Aire A 31 Si Mann', @es_servicio = 0, @tipo_producto_id = 3, @precio = 5200.00, @compra = 2600.00, @pagaIVA = 1, @porcentaje_iva = 21.00, @marca_id = 8;
EXEC dbo.usp_crearProducto @descripcion = 'Filtro de Combustible W 940/1 Bosch', @es_servicio = 0, @tipo_producto_id = 4, @precio = 3500.00, @compra = 1700.00, @pagaIVA = 1, @porcentaje_iva = 21.00, @marca_id = 7;
EXEC dbo.usp_crearProducto @descripcion = 'Pastillas de Freno Delanteras Bosch', @es_servicio = 0, @tipo_producto_id = 6, @precio = 18000.00, @compra = 11000.00, @pagaIVA = 1, @porcentaje_iva = 21.00, @marca_id = 7;
EXEC dbo.usp_crearProducto @descripcion = 'Batería 60Ah Bosch S4', @es_servicio = 0, @tipo_producto_id = 7, @precio = 42000.00, @compra = 26000.00, @pagaIVA = 1, @porcentaje_iva = 21.00, @marca_id = 7;
EXEC dbo.usp_crearProducto @descripcion = 'Amortiguador Delantero Bilstein B4', @es_servicio = 0, @tipo_producto_id = 8, @precio = 35000.00, @compra = 22000.00, @pagaIVA = 1, @porcentaje_iva = 21.00, @marca_id = NULL;
EXEC dbo.usp_crearProducto @descripcion = 'Bujía Iridium NGK', @es_servicio = 0, @tipo_producto_id = 9, @precio = 3200.00, @compra = 1500.00, @pagaIVA = 1, @porcentaje_iva = 21.00, @marca_id = NULL;
EXEC dbo.usp_crearProducto @descripcion = 'Cambio de Aceite y Filtro', @es_servicio = 1, @tipo_producto_id = 11,@precio = 15000.00, @compra = 5000.00, @pagaIVA = 0, @porcentaje_iva = 0.00, @marca_id = NULL;
EXEC dbo.usp_crearProducto @descripcion = 'Balanceo y Alineación', @es_servicio = 1, @tipo_producto_id = 11, @precio = 12000.00, @compra = 4000.00, @pagaIVA = 0, @porcentaje_iva = 0.00, @marca_id = NULL;
EXEC dbo.usp_crearProducto @descripcion = 'Cambio de Neumático (x4)', @es_servicio = 1, @tipo_producto_id = 11, @precio = 20000.00, @compra = 8000.00, @pagaIVA = 0, @porcentaje_iva = 0.00, @marca_id = NULL;
EXEC dbo.usp_crearProducto @descripcion = 'Revisión de Frenos', @es_servicio = 1, @tipo_producto_id = 11, @precio = 8000.00, @compra = 3000.00, @pagaIVA = 0, @porcentaje_iva = 0.00, @marca_id = NULL;
EXEC dbo.usp_crearProducto @descripcion = 'Carga de A/C', @es_servicio = 1, @tipo_producto_id = 11, @precio = 25000.00, @compra = 10000.00, @pagaIVA = 0, @porcentaje_iva = 0.00, @marca_id = NULL;
EXEC dbo.usp_crearProducto @descripcion = 'Diagnóstico por Computadora', @es_servicio = 1, @tipo_producto_id = 11, @precio = 10000.00, @compra = 3000.00, @pagaIVA = 0, @porcentaje_iva = 0.00, @marca_id = NULL;
EXEC dbo.usp_crearProducto @descripcion = 'Cambio de Batería (mano de obra)', @es_servicio = 1, @tipo_producto_id = 11, @precio = 5000.00, @compra = 1500.00, @pagaIVA = 0, @porcentaje_iva = 0.00, @marca_id = NULL;


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
INSERT INTO Deposito (nombre, estado, idTipoDeposito, direccion) VALUES('Bodega Norte', 1, 1, 'Ruta 5, Km 10');

EXEC dbo.ups_desactivarDeposito 1;
EXEC dbo.ups_activarDeposito 1;
EXEC dbo.ups_borrarDeposito 3;

EXEC dbo.usp_actualizarDeposito 
    @id = 1,                              
    @nombre = 'Depósito Central Actualizado', 
    @direccion = 'Nueva Av. Principal 123', 
    @idTipoDeposito = 2,                 
    @estado = 1;                          

-- ====================================
-- ?            INVENTARIO
-- ====================================

DROP TABLE Inventario;
DROP TABLE Deposito;

--dbo.usp_agregarInventario @deposito_id INT, @producto_id INT, @stock INT  
EXEC dbo.usp_agregarInventario 3,2,8;
EXEC dbo.usp_agregarInventario 3,3,10;

EXEC dbo.usp_restarInventario 3,3,19;


SELECT * FROM Inventario;

SELECT * FROM Producto WHERE id=2;

SELECT * FROM Bitacora WHERE tabla='Inventario';











--INSERT INTO TransferenciaCabecera (fechaHora, id_dep_origen, id_dep_destino, id_usuario_encargado, id_usuario_autorizo, obs_operacion, estado) VALUES 
--(GETDATE(), 1, 2, 3, 2, 'Reposición de stock de zapatillas y camisetas', 1),
--(GETDATE(), 1, 2, 3, 2, 'Llegada de electrónicos nuevos', 1);




-- ! FALTAN LOS Triggers para el maejo de Inventario/STOCK
--INSERT INTO CondicionVenta(condicon) VALUES('CONTADO'),('CREDITO');