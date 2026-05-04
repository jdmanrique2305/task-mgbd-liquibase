# Investigación: Liquibase y control de cambios en bases de datos

**Asignatura:** Modelado y Gestión de Base de Datos  
**Grupo:** 8  
**Fecha:** Mayo 2025

---

## 1. ¿Qué es Liquibase?

Liquibase es una herramienta de código abierto para el **versionamiento y migración de esquemas de bases de datos**. Permite gestionar los cambios estructurales (DDL) y de datos (DML) de una base de datos de la misma forma en que Git gestiona el código fuente: con un historial rastreable, reproducible y reversible.

Fue creada en 2006 por Nathan Voxland y actualmente es mantenida por Liquibase Inc. bajo licencia Apache 2.0. Es compatible con más de 50 motores de base de datos, incluyendo PostgreSQL, MySQL, Oracle, SQL Server y H2.

---

## 2. Conceptos clave

### Changelog

El **changelog** es el archivo maestro que actúa como índice de todos los cambios que deben aplicarse a la base de datos. Puede estar escrito en formato YAML, XML, JSON o SQL. En este proyecto se usa YAML (`db.changelog-master.yaml`) y referencia todos los changesets de las carpetas `ddl/` y `dml/`.

### Changeset

Un **changeset** es la unidad mínima de cambio en Liquibase. Cada changeset tiene un identificador único compuesto por `author:id` y contiene una o más instrucciones SQL. Una vez ejecutado, Liquibase lo registra en su tabla interna `databasechangelog` y **nunca lo vuelve a ejecutar**, a menos que sea modificado (lo cual genera un error de checksum).

Ejemplo de changeset en SQL formateado:

```sql
-- liquibase formatted sql

-- changeset juan:001-create-persona
CREATE TABLE persona (
    id_persona SERIAL PRIMARY KEY,
    nombre     VARCHAR(100) NOT NULL
);
-- rollback DROP TABLE persona;
```

### Rollback

El **rollback** es la capacidad de deshacer un changeset ya aplicado. Liquibase lo permite de dos formas: automáticamente (para instrucciones sencillas como `CREATE TABLE`) o mediante una cláusula `-- rollback` definida explícitamente por el desarrollador. En este proyecto todos los changesets incluyen su instrucción de rollback.

### databasechangelog

Es la tabla que Liquibase crea automáticamente en la base de datos para llevar el registro de qué changesets ya fueron ejecutados. Almacena el `id`, el `author`, el archivo de origen, la fecha de ejecución y un **checksum MD5** del contenido. Si el archivo cambia después de haberse ejecutado, Liquibase lanzará un error de integridad.

---

## 3. Separación DDL y DML

En este proyecto los changesets están organizados en dos carpetas separadas:

| Carpeta | Tipo | Contenido |
|---|---|---|
| `changelog/ddl/` | DDL — Data Definition Language | `CREATE TABLE` para las seis tablas autorizadas |
| `changelog/dml/` | DML — Data Manipulation Language | `INSERT`, `UPDATE`, `DELETE` con datos de prueba |

Esta separación es una buena práctica porque permite aplicar solo la estructura sin datos (útil en entornos de producción) o aplicar ambas capas en conjunto (útil en entornos de desarrollo y pruebas). El changelog master referencia primero el directorio DDL y luego el DML, garantizando el orden correcto.

---

## 4. Control de versiones de base de datos

Históricamente, los cambios en bases de datos se aplicaban de forma manual y sin registro, lo que generaba problemas como:

- Inconsistencias entre ambientes (desarrollo, pruebas, producción).
- Pérdida de cambios al actualizar el servidor.
- Imposibilidad de saber qué se cambió y cuándo.

Liquibase soluciona esto aplicando los mismos principios del control de versiones de código a la base de datos:

**Rastreabilidad:** cada cambio tiene autor, fecha y descripción.  
**Reproducibilidad:** el mismo `docker compose up` produce exactamente la misma base de datos en cualquier máquina.  
**Reversibilidad:** con `rollbackCount N` se pueden deshacer los últimos N changesets.  
**Auditabilidad:** la tabla `databasechangelog` es el log permanente de toda la historia de cambios.

---

## 5. Comparación con otras herramientas

| Característica | Liquibase | Flyway | Alembic (Python) |
|---|---|---|---|
| Formatos de changelog | SQL, YAML, XML, JSON | Solo SQL | Python scripts |
| Rollback explícito | Sí | No (versión gratuita) | Sí |
| Compatibilidad BD | +50 motores | +20 motores | SQLAlchemy compatible |
| Integración Docker | Imagen oficial | Imagen oficial | Manual |
| Licencia base | Apache 2.0 | Apache 2.0 | MIT |

Liquibase se diferencia principalmente por su soporte de **rollback explícito** y la flexibilidad de formatos, lo que lo hace más adecuado para proyectos que requieren trazabilidad completa de cambios.

---

## 6. Integración con Docker

En este proyecto Liquibase se ejecuta como un servicio en Docker Compose. El servicio `liquibase` depende del servicio `postgres` mediante la condición `service_healthy`, lo que garantiza que la base de datos esté lista antes de intentar conectarse.

El volumen `./db:/liquibase/changelog` monta la carpeta local `db/` dentro del contenedor en la ruta `/liquibase/changelog`, permitiendo que Liquibase lea los archivos de migración desde el sistema de archivos del host sin necesidad de reconstruir la imagen.

---

## 7. Conclusiones

Liquibase representa una solución madura para uno de los problemas más comunes en el desarrollo de software: mantener la base de datos sincronizada entre diferentes ambientes y equipos de trabajo. Su integración con Docker permite que cualquier desarrollador levante un entorno idéntico con un solo comando, eliminando la frase "en mi máquina sí funciona". El uso de changesets versionados, combinado con la separación clara entre DDL y DML, produce una base de datos reproducible, auditable y fácil de mantener en el tiempo.

---

## Referencias

- Liquibase Documentation. (2024). *Getting Started with Liquibase*. https://docs.liquibase.com
- Redgate. (2023). *Database DevOps: versioning your database*. https://www.red-gate.com/hub/university/courses/liquibase
- Docker Inc. (2024). *Liquibase Official Docker Image*. https://hub.docker.com/r/liquibase/liquibase
- PostgreSQL Global Development Group. (2024). *PostgreSQL 15 Documentation*. https://www.postgresql.org/docs/15/
