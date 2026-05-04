-- liquibase formatted sql

-- changeset juan:dml-002-update-stock-laptop
-- Ajuste de stock tras venta registrada en factura 1
UPDATE producto
   SET stock = stock - 1
 WHERE id_producto = 1;
-- rollback UPDATE producto SET stock = stock + 1 WHERE id_producto = 1;

-- changeset juan:dml-002-update-stock-mouse
UPDATE producto
   SET stock = stock - 5
 WHERE id_producto = 2;
-- rollback UPDATE producto SET stock = stock + 5 WHERE id_producto = 2;

-- changeset juan:dml-002-update-factura-pendiente
-- El cliente pagó la factura 3
UPDATE factura
   SET estado = 'pagada'
 WHERE id_factura = 3;
-- rollback UPDATE factura SET estado = 'pendiente' WHERE id_factura = 3;

-- changeset juan:dml-002-update-email-persona
-- Corrección de email del usuario 4
UPDATE persona
   SET email = 'valentina.diaz.nuevo@email.com'
 WHERE id_persona = 4;
-- rollback UPDATE persona SET email = 'valentina.diaz@email.com' WHERE id_persona = 4;
