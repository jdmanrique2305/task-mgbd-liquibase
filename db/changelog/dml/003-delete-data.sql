-- liquibase formatted sql

-- changeset juan:dml-003-delete-detalle-anulado
-- Eliminar detalles de la factura anulada (factura 5)
DELETE FROM detalle_factura
 WHERE id_factura = 5;
-- rollback INSERT INTO detalle_factura (id_factura, id_producto, cantidad, precio_unitario) VALUES (5, 5, 1, 230000);

-- changeset juan:dml-003-delete-producto-obsoleto
-- Eliminar producto sin stock ni movimientos futuros (ejemplo de baja)
-- Se usa un producto ficticio con id alto para no romper las FK existentes
INSERT INTO producto (nombre, descripcion, precio, stock)
VALUES ('Producto descontinuado', 'Solo para demo de DELETE', 0, 0);

DELETE FROM producto
 WHERE nombre = 'Producto descontinuado';
-- rollback SELECT 1; -- no requiere acción, el producto ya no existe
