Te lo corregí y organicé en Markdown limpio, listo para tu `README.md`. También ajusté algunos detalles técnicos: la convención de índices `IX_`, la nomenclatura de triggers para SQL Server y el formato de los encabezados SQL.

# Módulo de Ventas - Base de Datos (`ModuloVentasDB`)

Este repositorio contiene los scripts **DDL** (definición de estructuras) y **DML** (manipulación de datos) para la gestión de la base de datos del **Módulo de Ventas**, desarrollado en Microsoft SQL Server.

---

## 💻 Entorno de desarrollo

Este proyecto requiere **Microsoft SQL Server 2019 o superior**.

> [!TIP]\
> **¿No tienes SQL Server instalado?**
>
> Puedes desplegar una instancia de SQL Server mediante Docker utilizando el siguiente repositorio auxiliar:
>
> 🔗 [Servidor MSSQL (Docker)](https://github.com/SparkMed22/ServidorMSSQL.git)

---

## 📐 Estándar de documentación SQL

Todos los scripts SQL deben incluir un encabezado estandarizado al inicio del archivo, con información sobre el módulo, el objeto, su propósito, el autor y la fecha de creación.

### Ejemplo de encabezado

```
-- Active: 1786735858080@@127.0.0.1@1433@ModuloVentasDB

-- MÓDULO      : Ventas
-- OBJETO      : TABLA Clientes
-- PROPÓSITO   : Almacenar los datos de los clientes del sistema.
-- AUTOR       : Francisco David Medina Lourenzo
-- FECHA CREA  : 2026-09-15
```

### Descripción de los campos

| Campo        | Descripción                                                       |
| ------------ | ----------------------------------------------------------------- |
| `Active`     | Configuración de conexión utilizada por el entorno de desarrollo. |
| `MÓDULO`     | Módulo funcional al que pertenece el objeto.                      |
| `OBJETO`     | Nombre y tipo del objeto SQL que se documenta.                    |
| `PROPÓSITO`  | Descripción de la finalidad del objeto.                           |
| `AUTOR`      | Responsable de la creación del script.                            |
| `FECHA CREA` | Fecha de creación del objeto o script, en formato `YYYY-MM-DD`.   |

> **Nota:** La línea `Active` es opcional si el entorno de desarrollo no la utiliza. Si se conserva, debe ajustarse a la conexión correspondiente.

---

## 🔄 Estándar de contribución y Git

### 1. Convención de commits

Los mensajes de commit deben seguir el formato de **Conventional Commits**:

```
<tipo>(<módulo>): <descripción corta>
```

#### Ejemplos

```
git commit -m "feat(ventas): crear tabla Clientes con validación de email"
git commit -m "fix(ventas): corregir longitud del campo telefono en Clientes"
git commit -m "refactor(ventas): migrar email de NVARCHAR a VARCHAR"
```

#### Tipos de commit

| Tipo       | Uso                                                                 |
| ---------- | ------------------------------------------------------------------- |
| `feat`     | Incorporación de nuevas funcionalidades u objetos de base de datos. |
| `fix`      | Corrección de errores o ajustes en restricciones y columnas.        |
| `refactor` | Reestructuración sin alterar la lógica del negocio.                 |
| `docs`     | Cambios en la documentación.                                        |
| `test`     | Incorporación o modificación de pruebas.                            |
| `chore`    | Tareas de mantenimiento y configuración.                            |

### 2. Flujo de trabajo

Crear una rama por cada cambio o funcionalidad:

```
git checkout -b feature/tabla-clientes
```

Se recomienda utilizar nombres descriptivos para las ramas, por ejemplo:

- `feature/tabla-clientes`
- `feature/tabla-productos`
- `fix/validacion-email`
- `refactor/estructura-ventas`

### 3. Convención de nombres para objetos SQL

Todos los objetos deben seguir una nomenclatura consistente para facilitar el mantenimiento y la identificación de sus dependencias.

| Prefijo | Objeto                    | Ejemplo                     |
| ------- | ------------------------- | --------------------------- |
| `PK_`   | Clave primaria            | `PK_Clientes`               |
| `UQ_`   | Restricción de unicidad   | `UQ_Clientes_Email`         |
| `CK_`   | Restricción de validación | `CK_Clientes_EmailValido`   |
| `FK_`   | Clave foránea             | `FK_Ventas_Clientes`        |
| `IX_`   | Índice                    | `IX_Usuarios_RolID`         |
| `DF_`   | Valor predeterminado      | `DF_Clientes_FechaRegistro` |
| `TRG_`  | Trigger                   | `TRG_Clientes_AI`   |

### 4. Convención para triggers

Los triggers deben utilizar nombres descriptivos que permitan identificar la tabla asociada, el momento de ejecución y el evento correspondiente.

Formato recomendado:

```
TR_<Tabla>_<Momento><Evento>
```

#### Ejemplos

```
trg_Clientes_ai
trg_Clientes_au
trg_Clientes_ad
```


## ⚠️ Advertencias

> [!WARNING]\
> La carpeta `dev` contiene scripts de desarrollo y pruebas. Revisa su contenido antes de ejecutarlos, especialmente si apuntan a una base de datos compartida o de producción.

> [!IMPORTANT]\
> Antes de ejecutar scripts que modifiquen o eliminen estructuras o datos, verifica la conexión activa y asegúrate de disponer de un respaldo actualizado cuando corresponda.

---