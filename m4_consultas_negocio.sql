SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

WITH facturacion_mensual AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM facturacion_mensual)
            THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM facturacion_mensual
ORDER BY mes;

-- Nota: con los datos cargados en M3 solo existe marzo de 2024.
-- Por eso, su facturación coincide con el promedio mensual general.
-- Como la consigna solicita únicamente las etiquetas 'Por encima' o 'Por debajo',
-- el CASE clasifica el valor igual al promedio dentro del ELSE ('Por debajo').

-- Hallazgos
-- 1. Marzo registra una facturación total de 6.444,00 en 10 pedidos,
--    con un ticket promedio de 644,40.
-- 2. El id_producto 1 lidera el ranking con 3 unidades vendidas
--    y una facturación de 3.600,00.
-- 3. Los cinco clientes cargados son recurrentes: cada id_cliente
--    realizó 2 pedidos en el período analizado.