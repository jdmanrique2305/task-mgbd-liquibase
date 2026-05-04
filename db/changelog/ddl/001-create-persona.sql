-- liquibase formatted sql

-- changeset juan:001-create-persona
CREATE TABLE persona (
    id_persona  SERIAL       PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    apellido    VARCHAR(100) NOT NULL,
    email       VARCHAR(150) NOT NULL UNIQUE,
    telefono    VARCHAR(20)
);
-- rollback DROP TABLE persona;
