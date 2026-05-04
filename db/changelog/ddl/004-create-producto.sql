-- liquibase formatted sql

-- changeset juan:004-create-producto
CREATE TABLE producto (
    id_producto  SERIAL         PRIMARY KEY,
    nombre       VARCHAR(150)   NOT NULL,
    descripcion  TEXT,
    precio       NUMERIC(10, 2) NOT NULL CHECK (precio >= 0),
    stock        INT            NOT NULL DEFAULT 0 CHECK (stock >= 0)
);
-- rollback DROP TABLE producto;
