-------------------------------------------------------------------------------------
-- AVANCE 3 - RESOLUCIÓN DE CONSULTAS AVANZADAS (EMPLEANDO FUNCIONES DE AGREGACIÓN)--
-------------------------------------------------------------------------------------

-- 1) Total de ventas globales --
-- Pregunta: ¿Cuál es el total de ventas (total_compra) a nivel global? --

SELECT SUM (total_compra) AS total_ventas_global -- Suma total de todas las compras
FROM ordenes -- Desde la tabla ordenes

-- 2) Promedio de precios de productos por categoría --
-- Pregunta: ¿Cuál es el precio promedio de los productos dentro de cada categoría? --

SELECT id_categoria, AVG (precio) AS promedio_precio_categoria -- Promedio del precio por categoría
FROM productos -- Desde la tabla productos
GROUP BY id_categoria -- Agrupado por id_categoria
ORDER BY promedio_precio_categoria DESC; -- Ordenado de mayor a menor

-- 3) Orden mínima y máxima por sucursal --
-- Pregunta: ¿Cuál es el valor de la orden mínima y máxima por cada sucursal? --

SELECT id_sucursal, MAX (total_compra) AS máximo, MIN (total_compra) AS mínimo -- Máximo y mínimo de total_compra
FROM ordenes -- Desde la tabla ordenes
GROUP BY id_sucursal -- Agrupado por id_sucursal

-- 4) Mayor número de kilómetros recorridos para entrega --
-- Pregunta: ¿Cuál es el mayor número de kilómetros recorridos para una entrega? --

SELECT MAX (kilometros_recorrer) AS mayor_recorrido -- Mayor número de kilómetros recorridos
FROM ordenes; -- Desde la tabla ordenes

-- 5) Promedio de cantidad de productos por orden --
-- Pregunta: ¿Cuál es la cantidad promedio de productos por orden? --

SELECT id_orden, AVG (cantidad) AS promedio_productos_por_orden -- Promedio de cantidad por orden
FROM detalle_ordenes -- Desde la tabla detalle_ordenes
GROUP BY id_orden -- Agrupado por id_orden

-- 6) Total de ventas por tipo de pago --
-- Pregunta: ¿Cómo se distribuye la Facturación Total del Negocio de acuerdo a los métodos de pago? --

SELECT id_tipo_pago, SUM (total_compra) AS ventas_por_tipo_pago -- Suma total por tipo de pago
FROM ordenes -- Desde la tabla ordenes
GROUP BY id_tipo_pago -- Agrupado por id_tipo_pago
ORDER BY ventas_por_tipo_pago DESC; -- Ordenado de mayor a menor

-- 7) Sucursal con la venta promedio más alta --
-- Pregunta: ¿Cuál Sucursal tiene el ingreso promedio más alto? --

SELECT TOP 1 id_sucursal, AVG (total_compra) AS ventas_promedio -- Sucursal con el ingreso promedio más alto
FROM ordenes -- Desde la tabla ordenes
GROUP BY id_sucursal -- Agrupado por id_sucursal
ORDER BY ventas_promedio DESC -- Ordenado de mayor a menor

-- 8) Sucursal con la mayor cantidad de ventas por encima de un umbral --
-- Pregunta: ¿Cuáles son las sucursales que han generado ventas totales por encima de $ 1000? --

SELECT id_sucursal, SUM (total_compra) AS ventas_totales -- Suma total de ventas
FROM ordenes -- Desde la tabla ordenes
GROUP BY id_sucursal -- Agrupado por id_sucursal
HAVING SUM (total_compra) > 1000.00 -- Solo incluye sucursales con ventas mayores a 1000
ORDER BY ventas_totales DESC; -- Ordenado de mayor a menor

-- 9) Comparación de ventas promedio antes y después de una fecha específica --
-- Pregunta: ¿Cómo se comparan las ventas promedio antes y después del 1 de julio de 2023? --

SELECT AVG (total_compra) AS promedio_antes_julio -- Promedio de compras antes de julio
FROM ordenes -- Desde la tabla ordenes
WHERE fecha_orden_tomada < '2023-07-01'; -- Filtra por fecha

SELECT AVG (total_compra) AS promedio_despues_julio -- Promedio de compras después de julio
FROM ordenes -- Desde la tabla ordenes
WHERE fecha_orden_tomada > '2023-07-01'; -- Filtra por fecha

-- 10) Análisis de actividad de ventas por horario --
-- Pregunta: ¿Durante qué horario del día (mañana, tarde, noche) se registra la mayor cantidad de ventas, cuál es el ingreso promedio de estas ventas, y cuál ha sido el importe máximo alcanzado por una orden en dicha jornada? --

SELECT horario_venta, -- Horario de venta
    COUNT (id_orden) AS cantidad_ventas, -- Conteo de órdenes por horario
    AVG (total_compra) AS ingreso_promedio, -- Promedio de total_compra por horario
    MAX (total_compra) AS venta_maxima -- Máximo de total_compra por horario
FROM ordenes -- Desde la tabla ordenes
GROUP BY horario_venta -- Agrupado por horario_venta
ORDER BY ingreso_promedio DESC; -- Ordenado de mayor a menor

-------------------------------------------------------------------------------------
-- AVANCE 3 - RESOLUCIÓN DE CONSULTAS AVANZADAS (EMPLEANDO FUNCIONES DE AGREGACIÓN)--
-------------------------------------------------------------------------------------