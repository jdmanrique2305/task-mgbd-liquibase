-- liquibase formatted sql

-- changeset juan:002-create-rol
CREATE TABLE rol (
    id_rol       SERIAL       PRIMARY KEY,
    nombre_rol   VARCHAR(50)  NOT NULL UNIQUE,
    descripcion  TEXT
);
-- rollback DROP TABLE rol;
