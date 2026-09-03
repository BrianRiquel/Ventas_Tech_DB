-- PREENTREGA 5
-- CONSULTA 1: Vista base del proyecto (INNER JOIN)

SELECT
v.fecha_venta,
c.id_cliente,
c.nombre AS nombre_cliente,
c.ciudad,
p.nombre_producto,
cat.nombre_categoria,
v.cantidad,
v.precio_unitario,
(v.cantidad * v.precio_unitario) AS total_venta
FROM dbo.ventas AS v
INNER JOIN dbo.clientes AS c
ON v.id_cliente = c.id_cliente
INNER JOIN dbo.productos AS p
ON v.id_producto = p.id_producto
INNER JOIN dbo.categorias AS cat
ON p.id_categoria = cat.id_categoria;

-- CONSULTA 2: Clientes sin ventas (LEFT JOIN)

SELECT
c.nombre,
c.email,
c.fecha_registro
FROM dbo.clientes AS c
LEFT JOIN dbo.ventas AS v
ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- CONSULTA 3: Productos sin ventas (LEFT JOIN)

SELECT
p.nombre_producto,
cat.nombre_categoria,
p.precio
FROM dbo.productos AS p
INNER JOIN dbo.categorias AS cat
ON p.id_categoria = cat.id_categoria
LEFT JOIN dbo.ventas AS v
ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- CONSULTA 4: Consolidado por período (UNION ALL)

SELECT
canal,
SUM(total) AS total_por_canal
FROM (
SELECT
v.fecha_venta AS fecha,
(v.cantidad * v.precio_unitario) AS total,
'Periodo 1' AS canal
FROM dbo.ventas AS v
WHERE v.fecha_venta < '2024-03-10'
UNION ALL
SELECT
v.fecha_venta AS fecha,
(v.cantidad * v.precio_unitario) AS total,
'Periodo 2' AS canal
FROM dbo.ventas AS v
WHERE v.fecha_venta >= '2024-03-10'
) AS consolidado
GROUP BY canal;