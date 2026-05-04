-- liquibase formatted sql

-- changeset juan:005-create-factura
CREATE TABLE factura (
    id_factura  SERIAL         PRIMARY KEY,
    id_usuario  INT            NOT NULL,
    fecha       DATE           NOT NULL DEFAULT CURRENT_DATE,
    total       NUMERIC(12, 2) NOT NULL DEFAULT 0,
    estado      VARCHAR(20)    NOT NULL DEFAULT 'pendiente'
                               CHECK (estado IN ('pendiente', 'pagada', 'anulada')),
    CONSTRAINT fk_factura_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);
-- rollback DROP TABLE factura;
