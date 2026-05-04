-- Consulta 1: Listar todas las personas con su usuario y rol asignado
SELECT
    p.id_persona,
    p.nombre || ' ' || p.apellido AS nombre_completo,
    p.email,
    u.username,
    r.nombre_rol,
    u.fecha_creacion
FROM persona p
JOIN usuario u ON u.id_persona = p.id_persona
JOIN rol     r ON r.id_rol     = u.id_rol
ORDER BY p.id_persona;
