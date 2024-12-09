---------------------------------------
-- EXTRA CREDIT (EXPANSIÓN DE DATOS) --
---------------------------------------

-- Insertar nuevas categorías --

INSERT INTO categorias (id_categoria, nombre) VALUES
(11, 'Hot Dogs'),          
(12, 'Tacos y Burritos'),  
(13, 'Sándwiches de Pollo'), 
(14, 'Wraps'),            
(15, 'Alitas de Pollo'),   
(16, 'Nuggets'),           
(17, 'Comida Tex-Mex'),   
(18, 'Bocadillos'),        
(19, 'Acompañamientos'),   
(20, 'Salsas');            
GO

-- Insertar nuevos productos --

INSERT INTO productos (id_producto, nombre, id_categoria, precio) 
VALUES
(11, 'Hamburguesa Doble con Queso', 1, 10.99),  
(12, 'Nuggets de Pollo', 9, 4.99),              
(13, 'Hot Dog Clásico', 1, 3.99),               
(14, 'Hot Dog con Queso', 1, 4.49),             
(15, 'Tacos de Carne', 9, 6.99),                
(16, 'Burrito de Pollo', 9, 7.49),              
(17, 'Wrap de Vegetales', 8, 5.49),             
(18, 'Alitas BBQ', 9, 8.99),                    
(19, 'Sándwich de Pollo Empanizado', 1, 7.99),  
(20, 'Papas Fritas Grandes', 1, 2.49);          
GO

-- Insertar nuevas sucursales --

INSERT INTO sucursales (id_sucursal, nombre, direccion) 
VALUES
(11, 'Sucursal Aeropuerto', '2526 Airport Rd'),
(12, 'Sucursal Centro Comercial', '2728 Mall Ave'),
(13, 'Sucursal Parque Industrial', '2930 Industrial Park Rd'),
(14, 'Sucursal Autopista', '3132 Highway Blvd'),
(15, 'Sucursal Estación de Tren', '3334 Station St'),
(16, 'Sucursal Universidad', '3536 University Dr'),
(17, 'Sucursal Feria', '3738 Fairgrounds St'),
(18, 'Sucursal Mercado', '3940 Market St'),
(19, 'Sucursal Deportivo', '4142 Sports Complex Ave'),
(20, 'Sucursal Cineplex', '4344 Cinema Blvd');
GO

-- Insertar nuevos empleados --

INSERT INTO empleados (id_empleado, nombre, posicion, departamento, id_sucursal, rol) 
VALUES
(11, 'Mia Thompson', 'Cajero', 'Ventas', 2, 'Vendedor'),
(12, 'Liam Wilson', 'Chef', 'Cocina', 2, 'Vendedor'),
(13, 'Noah Anderson', 'Repartidor', 'Logística', 2, 'Mensajero'),
(14, 'Ava Martinez', 'Gerente', 'Administración', 2, 'Vendedor'),
(15, 'Isabella Clark', 'Subgerente', 'Ventas', 3, 'Vendedor'),
(16, 'Mason Lewis', 'Barista', 'Cafetería', 3, 'Vendedor'),
(17, 'James Hall', 'Atención al Cliente', 'Servicio', 4, 'Vendedor'),
(18, 'Benjamin Young', 'Chef', 'Cocina', 4, 'Vendedor'),
(19, 'Charlotte Walker', 'Repartidor', 'Logística', 4, 'Mensajero'),
(20, 'Lucas Lee', 'Gerente', 'Administración', 5, 'Vendedor');
GO

-- Insertar nuevos clientes --

INSERT INTO clientes (id_cliente, nombre, direccion) 
VALUES
(11, 'Cliente Once', '1010 K Street'),
(12, 'Cliente Doce', '1011 L Street'),
(13, 'Cliente Trece', '1012 M Street'),
(14, 'Cliente Catorce', '1013 N Street'),
(15, 'Cliente Quince', '1014 O Street'),
(16, 'Cliente Dieciséis', '1015 P Street'),
(17, 'Cliente Diecisiete', '1016 Q Street'),
(18, 'Cliente Dieciocho', '1017 R Street'),
(19, 'Cliente Diecinueve', '1018 S Street'),
(20, 'Cliente Veinte', '1019 T Street');
GO

-- Insertar nuevos mensajeros --

INSERT INTO mensajeros (id_mensajero, nombre, es_externo) VALUES
(11, 'Mensajero Once', 0), 
(12, 'Mensajero Doce', 1), 
(13, 'Mensajero Trece', 0), 
(14, 'Mensajero Catorce', 1), 
(15, 'Mensajero Quince', 0), 
(16, 'Mensajero Dieciséis', 1), 
(17, 'Mensajero Diecisiete', 0), 
(18, 'Mensajero Dieciocho', 1), 
(19, 'Mensajero Diecinueve', 0), 
(20, 'Mensajero Veinte', 1);
GO

---------------------------------------
-- EXTRA CREDIT (EXPANSIÓN DE DATOS) --
---------------------------------------
--------------------------------------------------
-- EXTRA CREDIT (NUEVAS CONSULTAS ESTRATÉGICAS) --
--------------------------------------------------

-- 1) Patrones de consumo estacional --
-- Esta consulta muestra las ventas totales por mes, lo que te permite identificar patrones estacionales en el consumo. --

SELECT MONTH (fecha_orden_tomada) AS mes, SUM (total_compra) AS total_ventas -- Extrae el mes de la fecha de la orden y lo nombra 'mes'. -- Suma las ventas totales y las nombra 'total_ventas'.
FROM ordenes -- Indica que se están seleccionando datos de la tabla 'ordenes'.
GROUP BY MONTH(fecha_orden_tomada) -- Agrupa los resultados por el mes extraído de la fecha de la orden.
ORDER BY mes; -- Ordena los resultados cronológicamente por mes.

-- 2) Análisis de tendencias a lo largo del tiempo --
-- Esta consulta muestra las tendencias de ventas a lo largo de los años, permitiendo ver si hay un crecimiento o declive. --

SELECT  YEAR(fecha_orden_tomada) AS año, SUM(total_compra) AS total_ventas -- Extrae el año de la fecha de la orden y lo nombra 'año'. -- Suma las ventas totales y las nombra 'total_ventas'.
FROM ordenes -- Indica que se están seleccionando datos de la tabla 'ordenes'.
GROUP BY YEAR(fecha_orden_tomada) -- Agrupa los resultados por el año extraído de la fecha de la orden.
ORDER BY año; -- Ordena los resultados cronológicamente por año.

--------------------------------------------------
-- EXTRA CREDIT (NUEVAS CONSULTAS ESTRATÉGICAS) --
--------------------------------------------------