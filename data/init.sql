-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- PROPÓSITO   : Cargar datos por Defecto 
-- AUTOR       : Francisco David Medina Lourenzo 
-- FECHA CREA  : 2026-10-02

-- Roles
INSERT INTO Roles (permiso) 
VALUES 
    ('Administrador'),
    ('Gerente'),
    ('Operario');

SELECT * from Roles;

-- Usuarios
INSERT INTO Usuarios (nombre, apellido, rol_id) VALUES 
('Carlos', 'Lopez', 3),  
('Ana', 'Martinez', 2),  
('Jorge', 'Ruiz', 1);    


SELECT 
    CONCAT(u.nombre,' ',u.apellido)  AS 'Nombre completo', 
    CASE u.estado WHEN 1 THEN 'Activo' ELSE 'Inactivo' END AS 'Estado',
    r.permiso AS 'Permisos'  
    FROM Usuarios u INNER JOIN Roles r ON r.id = u.rol_id;





-- Insertar un lote de clientes con datos válidos
INSERT INTO Clientes (nombre, direccion, telefono, email, credito, saldo) 
VALUES 
    ('Carlos Gómez', 'Av. Mcal. López 1450', '+595 981 123456', 'carlos.gomez@email.com', 5000000.00, 1200000.00),
    ('María Lucía Benítez', 'Calle Palma 452', '(021) 445-890', 'mbenitez@empresa.com.py', 10000000.00, 0.00),
    ('Juan Pérez', 'Ruta 1 Km 12', '+595 971 654321', 'juan.perez+ventas@gmail.com', 0.00, 0.00),
    ('Elena Rostova', 'Av. España 890', '0982-111-222', 'elena.rostova@dominguez.org', 2500000.00, 450000.00),
    ('Esteban Quito', 'General Díaz 123', '+1 555 0192', 'equito@servicio-cliente.net', 1500000.00, 1500000.00);


SELECT nombre AS 'Nombre del Cliente' ,telefono AS 'Numero de celular' FROM Clientes;


SELECT name from sys.tables;


INSERT INTO TipoDeposito (nombre) 
VALUES 
    ('General'), 
    ('Ventas');
INSERT INTO TipoDeposito (nombre) VALUES ('Almacén Central'),('Devoluciones');


INSERT INTO Marcas (nombre) 
VALUES 
    ('Nike'),
    ('Adidas'),
    ('Samsung'),
    ('Apple'),
    ('Coca-Cola'),
    ('Pepsi'),
    ('Generic Brand');

-- Tipos de Producto
INSERT INTO TiposProducto (nombre) 
VALUES 
    ('Ropa'),
    ('Calzado'),
    ('Electrónica'),
    ('Bebidas'),
    ('Servicio'),
    ('Accesorios');

-- ==========================================
-- 2. Depósitos
-- ==========================================
-- Insertar datos en Deposito
-- Nota: idTipoDeposito corresponde al ID de la tabla TipoDeposito
-- 1 = General, 2 = Ventas, 3 = Almacén Central, 4 = Devoluciones

INSERT INTO Deposito (nombre, estado, idTipoDeposito, direccion) VALUES 
('Almacén Principal', 1, 1, 'Av. Industrial 101'),       -- Tipo General
('Tienda Centro', 1, 2, 'Calle Principal 55'),          -- Tipo Ventas
('Bodega Norte', 1, 3, 'Ruta 5, Km 10'),               -- Tipo Almacén Central
('Área de Devoluciones', 1, 4, 'Entrada de Servicio 2'), -- Tipo Devoluciones
('Tienda Online - Hub', 1, 2, 'Parque Empresarial 4'),   -- Tipo Ventas
('Depósito Temporal', 0, 1, 'Calle Secundaria 8');      -- Estado 0 = Inactivo



-- Insertar datos en Producto
-- Nota: 
-- es_servicio: 1 = Sí, 0 = No
-- pagaIVA: 1 = Sí, 0 = No
-- porcentaje_iva: debe estar entre 0 y 100

INSERT INTO Producto (descripcion, es_servicio, marca_id, tipo_producto_id, precio, compra, pagaIVA, porcentaje_iva, estado) 
VALUES 
('Smartphone Galaxy S23', 0, 3, 3, 800.00, 450.00, 1, 16.00, 1),
('Televisor 55 Pulgadas 4K', 0, 3, 3, 600.00, 300.00, 1, 16.00, 1),
('Zapatillas Running Nike Air', 0, 1, 2, 120.00, 50.00, 1, 16.00, 1),
('Camiseta Deportiva Adidas', 0, 2, 1, 45.00, 20.00, 1, 16.00, 1),
('Coca-Cola 2L', 0, 5, 4, 2.50, 1.20, 1, 16.00, 1),
('Agua Mineral Sin Gas 1L', 0, NULL, 4, 1.00, 0.40, 0, 0.00, 1),
('Servicio de Limpieza', 1, NULL, 5, 50.00, 10.00, 1, 16.00, 1),
('Asesoría Técnica', 1, NULL, 5, 100.00, 20.00, 1, 16.00, 1),
('Reparación de Celular', 1, NULL, 6, 80.00, 15.00, 1, 16.00, 1),
('Producto Descontinuado', 0, 1, 1, 30.00, 10.00, 1, 16.00, 0);



SELECT p.descripcion,p.es_servicio, m.nombre,p.precio, p.compra, p.pagaIVA, p.porcentaje_iva 
FROM Producto p
INNER JOIN Marcas m 
ON m.id = p.marca_id;




-- Insertar datos en Inventario
-- Nota: Solo productos físicos (es_servicio = 0) deben tener inventario.
-- Los servicios no se almacenan, por lo que no tienen filas aquí.

INSERT INTO Inventario (deposito_id, producto_id, stock) VALUES 
(1, 1, 50),   
(1, 2, 20),   
(2, 1, 5),    
(2, 2, 2),    
(1, 3, 100),  
(1, 4, 150),  
(2, 3, 10),   
(2, 4, 20),   
(1, 5, 200),  
(1, 6, 300),  
(1, 4, 0);    


SELECT p.descripcion,m.nombre,p.precio, p.compra, p.pagaIVA, p.porcentaje_iva, i.stock 
FROM Producto p
INNER JOIN Marcas m ON m.id = p.marca_id
INNER JOIN Inventario i ON p.id = i.producto_id;



INSERT INTO TransferenciaCabecera (fechaHora, id_dep_origen, id_dep_destino, id_usuario_encargado, id_usuario_autorizo, obs_operacion, estado) VALUES 
(GETDATE(), 1, 2, 3, 2, 'Reposición de stock de zapatillas y camisetas', 1),
(GETDATE(), 1, 2, 3, 2, 'Llegada de electrónicos nuevos', 1);


-- ! FALTAN LOS Triggers