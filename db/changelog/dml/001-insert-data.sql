-- liquibase formatted sql

-- changeset juan:dml-001-insert-personas
INSERT INTO persona (nombre, apellido, email, telefono) VALUES
  ('Carlos',  'Ramírez',  'carlos.ramirez@email.com',  '3101234567'),
  ('Laura',   'Gómez',    'laura.gomez@email.com',     '3209876543'),
  ('Andrés',  'Torres',   'andres.torres@email.com',   '3154567890'),
  ('Valentina','Díaz',    'valentina.diaz@email.com',  '3006543210'),
  ('Miguel',  'Herrera',  'miguel.herrera@email.com',  '3187654321');
-- rollback DELETE FROM persona WHERE email IN ('carlos.ramirez@email.com','laura.gomez@email.com','andres.torres@email.com','valentina.diaz@email.com','miguel.herrera@email.com');

-- changeset juan:dml-001-insert-roles
INSERT INTO rol (nombre_rol, descripcion) VALUES
  ('administrador', 'Acceso total al sistema'),
  ('vendedor',      'Puede crear facturas y gestionar productos'),
  ('consultor',     'Solo lectura sobre reportes y facturas');
-- rollback DELETE FROM rol WHERE nombre_rol IN ('administrador','vendedor','consultor');

-- changeset juan:dml-001-insert-usuarios
INSERT INTO usuario (id_persona, id_rol, username, password_hash) VALUES
  (1, 1, 'carlos.admin',  md5('admin123')),
  (2, 2, 'laura.vende',   md5('venta456')),
  (3, 2, 'andres.vende',  md5('venta789')),
  (4, 3, 'valen.consul',  md5('consul321')),
  (5, 1, 'miguel.admin',  md5('admin654'));
-- rollback DELETE FROM usuario WHERE username IN ('carlos.admin','laura.vende','andres.vende','valen.consul','miguel.admin');

-- changeset juan:dml-001-insert-productos
INSERT INTO producto (nombre, descripcion, precio, stock) VALUES
  ('Laptop Lenovo IdeaPad', 'Procesador i5, 8GB RAM, 256GB SSD',     2350000, 15),
  ('Mouse Inalámbrico',     'Mouse ergonómico 2.4GHz, 3 botones',       45000, 80),
  ('Teclado Mecánico',      'Switches Blue, retroiluminado RGB',        180000, 40),
  ('Monitor 24" Full HD',   'Panel IPS, 75Hz, HDMI + VGA',             620000, 20),
  ('Audífonos Bluetooth',   'Cancelación de ruido, 30h batería',        230000, 55),
  ('Disco Duro Externo 1TB','USB 3.0, compatible Windows/Mac',          189000, 30);
-- rollback DELETE FROM producto WHERE nombre IN ('Laptop Lenovo IdeaPad','Mouse Inalámbrico','Teclado Mecánico','Monitor 24" Full HD','Audífonos Bluetooth','Disco Duro Externo 1TB');

-- changeset juan:dml-001-insert-facturas
INSERT INTO factura (id_usuario, fecha, total, estado) VALUES
  (2, '2025-04-01', 2575000, 'pagada'),
  (3, '2025-04-03', 400000,  'pagada'),
  (2, '2025-04-10', 620000,  'pendiente'),
  (4, '2025-04-15', 189000,  'pendiente'),
  (3, '2025-04-20', 230000,  'anulada');
-- rollback DELETE FROM factura WHERE id_usuario IN (2,3,4) AND fecha >= '2025-04-01';

-- changeset juan:dml-001-insert-detalles
INSERT INTO detalle_factura (id_factura, id_producto, cantidad, precio_unitario) VALUES
  (1, 1, 1, 2350000),
  (1, 2, 5,   45000),
  (2, 3, 2,  180000),
  (3, 4, 1,  620000),
  (4, 6, 1,  189000),
  (5, 5, 1,  230000);
-- rollback DELETE FROM detalle_factura WHERE id_factura IN (1,2,3,4,5);
