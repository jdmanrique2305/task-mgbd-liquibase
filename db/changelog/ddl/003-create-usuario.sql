-- liquibase formatted sql

-- changeset juan:003-create-usuario
CREATE TABLE usuario (
    id_usuario      SERIAL       PRIMARY KEY,
    id_persona      INT          NOT NULL UNIQUE,
    id_rol          INT          NOT NULL,
    username        VARCHAR(80)  NOT NULL UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,
    fecha_creacion  DATE         NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT fk_usuario_persona FOREIGN KEY (id_persona) REFERENCES persona(id_persona),
    CONSTRAINT fk_usuario_rol     FOREIGN KEY (id_rol)     REFERENCES rol(id_rol)
);
-- rollback DROP TABLE usuario;
