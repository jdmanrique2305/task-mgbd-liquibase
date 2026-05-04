# task-mgbd-liquibase

Taller investigativo — Modelado y Gestión de Base de Datos  
Base de datos relacional con migraciones versionadas usando **Liquibase**, **Docker** y **PostgreSQL**.

---

## Requisitos previos

| Herramienta | Versión mínima | Verificar con |
|---|---|---|
| Docker Desktop | 24.x | `docker --version` |
| Docker Compose | 2.x (incluido en Docker Desktop) | `docker compose version` |

> No se requiere instalar PostgreSQL ni Liquibase localmente. Todo corre dentro de contenedores.

---

## Estructura del repositorio

```
task-mgbd-liquibase/
├── README.md
├── docker-compose.yml
├── liquibase.properties
└── db/
    ├── changelog/
    │   ├── db.changelog-master.yaml   ← punto de entrada de Liquibase
    │   ├── ddl/
    │   │   ├── 001-create-persona.sql
    │   │   ├── 002-create-rol.sql
    │   │   ├── 003-create-usuario.sql
    │   │   ├── 004-create-producto.sql
    │   │   ├── 005-create-factura.sql
    │   │   └── 006-create-detalle-factura.sql
    │   └── dml/
    │       ├── 001-insert-data.sql
    │       ├── 002-update-data.sql
    │       └── 003-delete-data.sql
    └── scripts/
        └── queries/
            ├── 001-select-personas.sql
            ├── 002-select-facturas.sql
            └── 003-select-detalle-factura.sql
```

---

## Pasos de ejecución

### 1. Clonar el repositorio

```bash
git clone https://github.com/<tu-usuario>/task-mgbd-liquibase.git
cd task-mgbd-liquibase
```

### 2. Levantar el contenedor de PostgreSQL y ejecutar migraciones

```bash
docker compose up
```

Este único comando:
1. Descarga las imágenes de PostgreSQL 15 y Liquibase 4.27 (solo la primera vez).
2. Crea el contenedor `mgbd_postgres` y espera a que esté listo (`healthcheck`).
3. Ejecuta el contenedor `mgbd_liquibase` que aplica automáticamente todas las migraciones DDL y DML en orden.

La salida esperada al finalizar es:

```
mgbd_liquibase  | Liquibase: Update has been successful. Rows affected: X
mgbd_liquibase exited with code 0
```

### 3. Verificar la base de datos

Abrir una sesión en el contenedor de PostgreSQL:

```bash
docker exec -it mgbd_postgres psql -U mgbd_user -d mgbd_db
```

Comandos útiles dentro de `psql`:

```sql
-- Ver todas las tablas creadas
\dt

-- Verificar datos de personas y usuarios
\i /dev/stdin
```

O ejecutar directamente desde fuera del contenedor:

```bash
# Listar tablas
docker exec mgbd_postgres psql -U mgbd_user -d mgbd_db -c "\dt"

# Ejecutar una consulta de validación
docker exec mgbd_postgres psql -U mgbd_user -d mgbd_db \
  -c "SELECT p.nombre, p.apellido, u.username, r.nombre_rol FROM persona p JOIN usuario u ON u.id_persona=p.id_persona JOIN rol r ON r.id_rol=u.id_rol;"
```

### 4. Ejecutar las consultas de validación

```bash
# Consulta 1: personas con usuario y rol
docker exec -i mgbd_postgres psql -U mgbd_user -d mgbd_db \
  < db/scripts/queries/001-select-personas.sql

# Consulta 2: facturas con cliente
docker exec -i mgbd_postgres psql -U mgbd_user -d mgbd_db \
  < db/scripts/queries/002-select-facturas.sql

# Consulta 3: detalle completo de facturas
docker exec -i mgbd_postgres psql -U mgbd_user -d mgbd_db \
  < db/scripts/queries/003-select-detalle-factura.sql
```

### 5. Detener y limpiar el entorno

```bash
# Solo detener (conserva los datos en el volumen)
docker compose down

# Detener y eliminar volúmenes (reinicia todo desde cero)
docker compose down -v
```

---

## Tablas de la base de datos

| Tabla | Descripción |
|---|---|
| `persona` | Datos personales de cada individuo |
| `rol` | Roles disponibles en el sistema |
| `usuario` | Cuenta de acceso asociada a una persona y un rol |
| `producto` | Catálogo de productos disponibles |
| `factura` | Cabecera de cada transacción de venta |
| `detalle_factura` | Líneas de productos dentro de cada factura |

---

## Orden de ejecución de Liquibase

1. Crear contenedor PostgreSQL y esperar healthcheck.
2. Liquibase valida la conexión.
3. Migraciones DDL (001 → 006): crean las seis tablas en orden respetando las llaves foráneas.
4. Migraciones DML (001 → 003): insertan, actualizan y eliminan datos de prueba.
5. Liquibase registra cada changeset en la tabla interna `databasechangelog`.

---

## Rollback

Liquibase permite revertir la última migración aplicada:

```bash
docker compose run --rm liquibase \
  --url=jdbc:postgresql://postgres:5432/mgbd_db \
  --username=mgbd_user \
  --password=mgbd_pass \
  --changeLogFile=changelog/db.changelog-master.yaml \
  rollbackCount 1
```
