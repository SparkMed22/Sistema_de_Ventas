# Módulo de Ventas - Base de Datos (`ModuloVentasDB`)

Este repositorio contiene los scripts DDL y DML para la gestión de la base de datos del **Módulo de Ventas** en SQL Server.

---

## 💻 Entorno de Desarrollo

Este proyecto requiere un servidor **SQL Server 2019 o superior**. 

> 💡 **¿No tienes un servidor SQL Server instalado?**  
> Si no cuentas con una instancia local de SQL Server, puedes desplegar un servidor en segundos mediante Docker utilizando este recurso auxiliar:  
> 🔗 **[Repositorio Servidor MSSQL (Docker)](https://github.com/SparkMed22/ServidorMSSQL.git)**

---

## 📐 Estándar de Documentación en SQL

Todos los scripts SQL del proyecto deben incluir obligatoriamente el siguiente encabezado estandarizado al inicio del archivo:

```sql
-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB

-- MÓDULO      : Ventas
-- OBJETO      : TABLA Clientes
-- PROPÓSITO   : Almacenar los datos de los clientes del sistema.
-- AUTOR       : Francisco David Medina Lourenzo 
-- FECHA CREA  : 2026-09-15
```

## 🔄 Estándar de Contribución y Git
1. Convención de Commits (Conventional Commits)
    Los mensajes de commit deben registrar los cambios siguiendo el formato:
    - <tipo>(<módulo>): <descripción corta>

Ejemplos:

```bash
    git commit -m "feat(ventas): crear tabla Clientes con validacion de email"
    git commit -m "fix(ventas): corregir longitud del campo telefono en Clientes"
    git commit -m "refactor(ventas): migrar email de NVARCHAR a VARCHAR"
```
- feat: Nuevos objetos en la BD (tablas, funciones, triggers).
- fix: Correcciones de errores o ajustes en constraints/columnas.
- refactor: Cambios de estructura sin alterar la lógica del negocio.


2. Flujo de Trabajo 
    Crear una rama por cambio/funcionalidad:

```bash
git checkout -b feature/tabla-clientes
```

Respetar los prefijos de restricciones en SQL:

- PK_: Clave Primaria (PK_Clientes)
- UQ_: Clave Única (UQ_Clientes_Email)
- CK_: Restricción Check (CK_Clientes_EmailValido)
- FK_: Clave Foránea (FK_Ventas_Clientes)

Ordenar la ejecución de scripts numéricamente al realizar despliegues (01_Clientes.sql, 02_Productos.sql).