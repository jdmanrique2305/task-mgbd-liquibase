-- liquibase formatted sql

-- changeset juan:006-create-detalle-factura
CREATE TABLE detalle_factura (
    id_detalle      SERIAL         PRIMARY KEY,
    id_factura      INT            NOT NULL,
    id_producto     INT            NOT NULL,
    cantidad        INT            NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(10, 2) NOT NULL CHECK (precio_unitario >= 0),
    subtotal        NUMERIC(12, 2) GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,
    CONSTRAINT fk_detalle_factura  FOREIGN KEY (id_factura)  REFERENCES factura(id_factura),
    CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);
-- rollback DROP TABLE detalle_factura;
