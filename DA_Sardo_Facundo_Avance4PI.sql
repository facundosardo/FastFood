----------------------------------------------------------------------------------------------------------
-- AVANCE 4 - UTILIZACIÓN DE MÚLTIPLES CONJUNTOS DE DATOS (EXTRAYENDO INFORMACIÓN DE DIFERENTES TABLAS) --
----------------------------------------------------------------------------------------------------------

-- 1 ) Listar todos los productos y sus categorías --
-- Pregunta: ¿Cómo puedo obtener una lista de todos los productos junto con sus categorías? --

SELECT productos.nombre AS [nombre_producto], categorias.nombre AS [nombre_categoría] -- Selecciona el nombre del producto y lo renombra como 'nombre_producto' -- Selecciona el nombre de la categoría y lo renombra como 'nombre_categoría'
FROM productos -- Desde la tabla productos
JOIN categorias -- Realiza una unión con la tabla categorias
ON productos.id_categoria = categorias.id_categoria; -- Donde el id_categoria de productos coincide con el id_categoria de categorias

-- 2) Obtener empleados y su sucursal asignada --
-- Pregunta: ¿Cómo puedo saber a qué sucursal está asignado cada empleado? --

SELECT empleados.nombre AS [nombre_empleado], sucursales.nombre [nombre_sucursal] -- Selecciona el nombre del empleado y lo renombra como 'nombre_empleado' -- Selecciona el nombre de la sucursal y lo renombra como 'nombre_sucursal'
FROM empleados -- Desde la tabla empleados
JOIN sucursales -- Realiza una unión con la tabla sucursales
ON empleados.id_sucursal = sucursales.id_sucursal; -- Donde el id_sucursal de empleados coincide con el id_sucursal de sucursales

-- 3) Identificar productos sin categoría asignada -- 
-- Pregunta: ¿Existen productos que no tienen una categoría asignada? --

SELECT productos.nombre AS  [nombre_producto], categorias.nombre AS [nombre_categoria] -- Selecciona el nombre del producto y lo renombra como 'nombre_producto' -- Selecciona el nombre de la categoría y lo renombra como 'nombre_categoria'
FROM productos -- Desde la tabla productos
FULL JOIN categorias -- Realiza una unión completa con la tabla categorias
ON productos.id_categoria = categorias.id_categoria; -- Donde el id_categoria de productos coincide con el id_categoria de categorias

-- 4) Detalle completo de órdenes --
-- Pregunta: ¿Cómo puedo obtener un detalle completo de las órdenes, incluyendo el Nombre del cliente, Nombre del empleado que tomó la orden, y Nombre del mensajero que la entregó? --

SELECT T1.*, T2.nombre AS [nombre_cliente], T3.nombre AS [nombre_empleado], T4.nombre AS [nombre_mensajero] -- Selecciona todas las columnas de la tabla T1 (ordenes) -- Selecciona el nombre del cliente y lo renombra como 'nombre_cliente' -- Selecciona el nombre del empleado y lo renombra como 'nombre_empleado' -- Selecciona el nombre del mensajero y lo renombra como 'nombre_mensajero'
FROM ordenes AS T1 -- Desde la tabla ordenes con alias T1
JOIN clientes AS T2 -- Realiza una unión con la tabla clientes con alias T2
ON T1.id_cliente = T2.id_cliente -- Donde el id_cliente de T1 coincide con el id_cliente de T2
JOIN empleados AS T3 -- Realiza una unión con la tabla empleados con alias T3
ON T1.id_empleado = T3.id_empleado -- Donde el id_empleado de T1 coincide con el id_empleado de T3
JOIN mensajeros AS T4 -- Realiza una unión con la tabla mensajeros con alias T4
ON T1.id_mensajero = T4.id_mensajero; -- Donde el id_mensajero de T1 coincide con el id_mensajero de T4

-- 5) Productos vendidos por sucursal --
-- Pregunta: ¿Cuántos artículos correspondientes a cada Categoría de Productos se han vendido en cada sucursal? --

SELECT T2.nombre AS [nombre_sucursal], T4.nombre AS [nombre_producto], T5.nombre AS [nombre_categoría], SUM(T3.cantidad) AS [total_vendido] -- Selecciona el nombre de la sucursal y lo renombra como 'nombre_sucursal' -- -- Selecciona el nombre del producto y lo renombra como 'nombre_producto' -- -- Selecciona el nombre de la categoría y lo renombra como 'nombre_categoría' -- -- Suma la cantidad vendida y lo renombra como 'total_vendido'
FROM ordenes AS T1 -- Desde la tabla ordenes con alias T1
INNER JOIN sucursales AS T2 ON T1.id_sucursal = T2.id_sucursal -- Une con sucursales donde id_sucursal coincide
INNER JOIN detalle_ordenes AS T3 ON T1.id_orden = T3.id_orden -- Une con detalle_ordenes donde id_orden coincide
INNER JOIN productos AS T4 ON T3.id_producto = T4.id_producto -- Une con productos donde id_producto coincide
INNER JOIN categorias AS T5 ON T5.id_categoria = T4.id_categoria -- Une con categorias donde id_categoria coincide
GROUP BY T2.nombre, T5.nombre, T4.nombre; -- Agrupa por nombre de sucursal -- Agrupa por nombre de categoría -- Agrupa por nombre de producto

----------------------------------------------------------------------------------------------------------
-- AVANCE 4 - UTILIZACIÓN DE MÚLTIPLES CONJUNTOS DE DATOS (EXTRAYENDO INFORMACIÓN DE DIFERENTES TABLAS) --
----------------------------------------------------------------------------------------------------------
-------------------------
-- CONSULTAS AVANZADAS --
-------------------------

-- 1) Eficiencia de los mensajeros --
-- ¿Cuál es el tiempo promedio desde el despacho hasta la entrega de los pedidos gestionados por todo el equipo de mensajería? -- 

SELECT AVG(DATEDIFF(MINUTE, fecha_despacho, fecha_entrega)) tiempo_promedio_minutos -- Calcula el tiempo promedio en minutos entre despacho y entrega
FROM ordenes -- Desde la tabla ordenes
WHERE fecha_entrega IS NOT NULL; -- Solo considera órdenes que ya han sido entregadas

-- 2) Análisis de ventas por origen de orden: ¿Qué canal de ventas genera más ingresos? --

SELECT T1.id_origen, SUM( T1.total_compra ) total_ingresos -- Selecciona el id de origen de la orden
FROM ordenes T1 -- Suma el total de compra y lo renombra como 'total_ingresos'
GROUP BY id_origen -- Agrupa los resultados por id_origen
ORDER BY total_ingresos DESC; -- Ordena los resultados de mayor a menor ingreso

-- 3) Productividad de los empleados: ¿Cuál es el nivel de ingreso generado por empleado? --

SELECT T1.nombre, T1.posicion, SUM(T2.total_compra) AS total_ingresos -- Selecciona el nombre del empleado -- Selecciona la posición del empleado -- Suma el total de compra y lo renombra como 'total_ingresos'
FROM Empleados T1 -- Desde la tabla empleados con alias T1
INNER JOIN ordenes T2 ON T1.id_empleado = T2.id_empleado -- Une con ordenes donde id_empleado coincide
GROUP BY T1.nombre, T1.posicion -- Agrupa por nombre de empleado -- Agrupa por posición de empleado
ORDER BY total_ingresos DESC; -- Ordena los resultados de mayor a menor ingreso

-- 4) Análisis de demanda por horario y día: ¿Cómo varía la demanda de productos a lo largo del día? --

SELECT DATEPART(HOUR, fecha_orden_tomada) AS hora, COUNT(*) cantidad_ordenes, SUM(total_compra) total_compra -- Extrae la hora de la orden y lo renombra como 'hora' -- Cuenta el número de órdenes y lo renombra como 'cantidad_ordenes' -- Suma el total de compra y lo renombra como 'total_compra'
FROM ordenes -- Desde la tabla ordenes
GROUP BY DATEPART( HOUR, fecha_orden_tomada) -- Agrupa por hora de la orden
ORDER BY Hora -- Ordena los resultados por hora de menor a mayor

-- 5) Comparación de ventas mensuales: ¿Cuál es la tendencia de los ingresos generados en cada periodo mensual? --

SELECT YEAR(fecha_orden_tomada) año, MONTH(fecha_orden_tomada) mes, SUM(total_compra) total_ingresos -- Extrae el año de la orden y lo renombra como 'año'-- Extrae el mes de la orden y lo renombra como 'mes' -- Suma el total de compra y lo renombra como 'total_ingresos'
FROM ordenes -- Desde la tabla ordenes
GROUP BY YEAR(fecha_orden_tomada), MONTH(fecha_orden_tomada ) -- Agrupa por año de la orden -- Agrupa por mes de la orden
ORDER BY YEAR(fecha_orden_tomada) DESC; -- Ordena los resultados por año de mayor a menor

-- 6) Análisis de fidelidad del cliente: ¿Qué porcentaje de clientes son recurrentes versus nuevos clientes cada mes? --

WITH ordenespormes AS ( -- Define una CTE (Common Table Expression) llamada 'ordenespormes'
SELECT id_cliente, YEAR(fecha_orden_lista) AS año, MONTH(fecha_orden_lista) AS mes, COUNT(*) AS num_ordenes -- Selecciona el id del cliente -- Extrae el año de la orden y lo renombra como 'año' -- Extrae el mes de la orden y lo renombra como 'mes' -- Cuenta el número de órdenes por cliente y lo renombra como 'num_ordenes'
FROM ordenes -- Desde la tabla ordenes
GROUP BY id_cliente, YEAR(fecha_orden_lista), MONTH(fecha_orden_lista)) -- Agrupa por id_cliente 
SELECT año, mes, -- Agrupa por año de la orden -- Agrupa por mes de la orden
COUNT(CASE WHEN num_ordenes > 1 THEN 1 END) AS clientes_recurrentes, -- Cuenta clientes con más de una orden y lo renombra como 'clientes_recurrentes'
COUNT(CASE WHEN num_ordenes = 1 THEN 1 END) AS clientes_nuevos, -- Cuenta clientes con una sola orden y lo renombra como 'clientes_nuevos'
FORMAT(ROUND(COUNT(CASE WHEN num_ordenes > 1 THEN 1 END) * 100.0 / COUNT(*), 2), 'P2') AS porcentaje_recurrentes -- Calcula el porcentaje de clientes recurrentes y lo renombra como 'porcentaje_recurrentes'
FROM ordenespormes -- Desde la CTE 'ordenespormes'
GROUP BY año, mes; -- Agrupa por año -- Agrupa por mes

-------------------------
-- CONSULTAS AVANZADAS --
-------------------------