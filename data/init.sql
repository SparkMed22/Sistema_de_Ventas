-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB
-- PROPÓSITO   : Cargar datos por Defecto 
-- AUTOR       : Francisco David Medina Lourenzo 
-- FECHA CREA  : 2026-10-02

-- Roles
INSERT INTO Roles (permiso) 
VALUES 
    ('Administrador'),
    ('Usuario');

-- Usuarios
INSERT INTO Usuarios (nombre,apellido,rol_id) 
VALUES
    ('Spark','Med',1),
    ('María', 'Gómez', 2);


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
