-- Consulta 2: Facturas con el nombre del usuario que las generó y su total
SELECT
    f.id_factura,
    p.nombre || ' ' || p.apellido AS cliente,
    f.fecha,
    f.estado,
    f.total
FROM factura f
JOIN usuario u ON u.id_usuario = f.id_usuario
JOIN persona p ON p.id_persona = u.id_persona
ORDER BY f.fecha DESC;
