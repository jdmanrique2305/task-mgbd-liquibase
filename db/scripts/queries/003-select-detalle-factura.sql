-- Consulta 3: Detalle completo de todas las facturas (productos, cantidades, subtotales)
SELECT
    f.id_factura,
    p.nombre || ' ' || p.apellido AS cliente,
    pr.nombre                     AS producto,
    df.cantidad,
    df.precio_unitario,
    df.subtotal
FROM detalle_factura df
JOIN factura  f  ON f.id_factura  = df.id_factura
JOIN usuario  u  ON u.id_usuario  = f.id_usuario
JOIN persona  p  ON p.id_persona  = u.id_persona
JOIN producto pr ON pr.id_producto = df.id_producto
ORDER BY f.id_factura, df.id_detalle;
