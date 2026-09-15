Vamos a documentar de esta menera los archivo SQL 

-- MÓDULO      : Ventas
-- OBJETO      : TABLA Clientes
-- PROPÓSITO   : Almacenar los datos de los clientes del sistema.
-- AUTOR       : Francisco David Medina Lourenzo 
-- FECHA CREA  : 2026-09-15


Y los commits (ejemplo)

# Formato: <tipo>(<módulo>): <descripción corta>
git commit -m "feat(ventas): crear tabla Clientes con validacion de email"
git commit -m "fix(ventas): corregir longitud del campo telefono en Clientes"
git commit -m "refactor(ventas): migrar email de NVARCHAR a VARCHAR"


## Estándar de Contribución
1. Crear una rama por cambio: `git checkout -b feature/tabla-clientes`.
2. Seguir las convenciones de nombres en SQL (`PK_`, `CK_`, `UQ_`).
3. Ejecutar los scripts en orden numérico al desplegar.


Encabezado Simplificado para Archivos SQL (01_Clientes.sql)