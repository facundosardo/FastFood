------------------------------------------------------------------------------------------------------------------------------------
-- AVANCE 2 - RESOLUCIÓN DE CONSULTAS BÁSICAS (POBLACIÓN DE TABLAS MEDIANTE QUERYS Y RESOLVER CONSULTAS UTILIZANDO SENTENCIAS DML --
------------------------------------------------------------------------------------------------------------------------------------

EXEC sp_rename 'origenes', 'origenes_orden'; -- Cambiar el nombre de la tabla 'origenes' a 'origenes_orden'
GO

EXEC sp_rename 'detalle_orden', 'detalle_ordenes'; -- Cambiar el nombre de la tabla detalle_orden a detalle_ordenes
GO

-------------------------------------------------
-- Crear la tabla categorías
-------------------------------------------------

CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY NOT NULL, -- Identificador único de la categoría
    nombre VARCHAR(100) -- Nombre de la categoría
);
GO

-------------------------------------------
-- Insertar datos en la tabla categorías
-------------------------------------------

INSERT INTO categorias (id_categoria, nombre) VALUES
(1, 'Comida Rápida'), -- Categoría 1
(2, 'Postres'), -- Categoría 2
(3, 'Bebidas'), -- Categoría 3
(4, 'Ensaladas'), -- Categoría 4
(5, 'Desayunos'), -- Categoría 5
(6, 'Cafetería'), -- Categoría 6
(7, 'Helados'), -- Categoría 7
(8, 'Comida Vegana'), -- Categoría 8
(9, 'Carnes'), -- Categoría 9
(10, 'Pizzas'); -- Categoría 10
GO

--------------------------------------------
-- Modificar campos en la tabla productos
--------------------------------------------

-- Eliminar las columnas no deseadas de la tabla productos

ALTER TABLE productos
DROP COLUMN categoria; -- Eliminamos la columna categoría (atributo)

ALTER TABLE productos
DROP COLUMN descripcion; -- Eliminamos la columna descripción

ALTER TABLE productos
DROP COLUMN stock; -- Eliminamos la columna stock

-- Agregar la columna id_categoria a la tabla productos

ALTER TABLE productos
ADD id_categoria INT; -- Agregamos la columna id_categoria

-- Agregar la clave foránea que referencia a la tabla categorías

ALTER TABLE productos
ADD FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria); -- Relación con la tabla categorías

--------------------------------------------
-- Modificar campos en la tabla sucursales
--------------------------------------------

-- Eliminar la columna no deseada de la tabla sucursales

ALTER TABLE sucursales
DROP COLUMN telefono; -- Eliminamos la columna teléfono

-- Modificar el nombre de la columna nombre_sucursal a nombre

EXEC sp_rename 'sucursales.nombre_sucursal', 'nombre', 'COLUMN'; -- Renombramos la columna

--------------------------------------------
-- Modificar campos en la tabla empleados
--------------------------------------------

-- Eliminar las columnas no deseadas de la tabla empleados

ALTER TABLE empleados
DROP COLUMN apellido;  -- Eliminamos la columna apellido

ALTER TABLE empleados
DROP COLUMN fecha_nacimiento;  -- Eliminamos la columna fecha_nacimiento

ALTER TABLE empleados
DROP COLUMN fecha_contratacion;  -- Eliminamos la columna fecha_contratacion

ALTER TABLE empleados
DROP COLUMN salario;  -- Eliminamos la columna salario

-- Modificar el nombre de la columna puesto a posicion

EXEC sp_rename 'empleados.puesto', 'posicion', 'COLUMN'; -- Renombramos la columna

--------------------------------------------
-- Modificar campos en la tabla clientes
--------------------------------------------

-- Eliminar las columnas no deseadas de la tabla clientes

ALTER TABLE clientes
DROP COLUMN apellido;  -- Eliminamos la columna apellido

ALTER TABLE clientes
DROP COLUMN email;  -- Eliminamos la columna email

ALTER TABLE clientes
DROP COLUMN telefono;  -- Eliminamos la columna telefono

ALTER TABLE clientes
DROP COLUMN fecha_registro;  -- Eliminamos la columna fecha_registro

ALTER TABLE clientes
DROP COLUMN fecha_nacimiento;  -- Eliminamos la columna fecha_nacimiento

------------------------------------------------
-- Modificar campos en la tabla origenes_orden
------------------------------------------------

-- Cambiar el nombre de la columna nombre_origen a descripcion

EXEC sp_rename 'origenes_orden.nombre_origen', 'descripcion', 'COLUMN'; 

------------------------------------------------
-- Modificar campos en la tabla tipos_pago
------------------------------------------------

-- Cambiar el nombre de la columna tipo_pago a descripcion 

EXEC sp_rename 'tipos_pago.tipo_pago', 'descripcion', 'COLUMN';

------------------------------------------------
-- Modificar campos en la tabla mensajeros
------------------------------------------------

-- Eliminar la restricción de clave foránea

ALTER TABLE mensajeros
DROP CONSTRAINT FK__mensajero__id_em__0D7A0286; 

-- Eliminar las columnas no deseadas

ALTER TABLE mensajeros
DROP COLUMN apellido, id_empleado; 

ALTER TABLE mensajeros
DROP COLUMN tipo; 

-- Agregar la nueva columna es_externo

ALTER TABLE mensajeros
ADD es_externo VARCHAR(50); 
GO

-------------------------------------------
-- Modificar campos en la tabla ordenes
-------------------------------------------

-- Consulta para encontrar las claves foráneas en la tabla ordenes

SELECT 
    OBJECT_NAME(fk.parent_object_id) AS 'Tabla', 
    OBJECT_NAME(fk.referenced_object_id) AS 'Referencia',
    fk.name AS 'Nombre_Restriccion'
FROM 
    sys.foreign_keys AS fk
WHERE 
    fk.parent_object_id = OBJECT_ID('ordenes');

-- Eliminar restricciones de clave foránea

ALTER TABLE ordenes 
DROP CONSTRAINT FK__ordenes__id_mens__1332DBDC; -- Clave foránea de mensajeros

ALTER TABLE ordenes 
DROP CONSTRAINT FK__ordenes__id_orig__14270015; -- Clave foránea de orígenes

ALTER TABLE ordenes 
DROP CONSTRAINT FK__ordenes__id_tipo__151B244E; -- Clave foránea de tipos de pago

ALTER TABLE ordenes 
DROP CONSTRAINT FK__ordenes__id_sucu__160F4887; -- Clave foránea de sucursales

ALTER TABLE ordenes 
DROP CONSTRAINT FK__ordenes__id_empl__17036CC0; -- Clave foránea de empleados

ALTER TABLE ordenes
DROP CONSTRAINT FK__ordenes__id_clie__14022BB0; -- Clave foránea de clientes

-- Eliminar columnas no deseadas

ALTER TABLE ordenes 
DROP COLUMN 
    id_cliente, 
    id_mensajero, 
    id_origen, 
    id_tipo_pago, 
    id_sucursal, 
    id_empleado;

-- Agregar nuevas columnas a la tabla 'ordenes'

ALTER TABLE ordenes 
ADD 
    id_cliente INT NOT NULL, -- Identificador del cliente
    id_empleado INT NOT NULL, -- Identificador del empleado que realizó la orden
    id_sucursal INT NOT NULL, -- Identificador de la sucursal
    id_mensajero INT NOT NULL, -- Identificador del mensajero
    id_tipo_pago INT NOT NULL, -- Identificador del tipo de pago
    id_origen INT NOT NULL; -- Identificador del origen

-- Agregar claves foráneas a la tabla 'ordenes'

ALTER TABLE ordenes
ADD 
    CONSTRAINT FK_ordenes_clientes FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente), -- Relación con la tabla clientes
    CONSTRAINT FK_ordenes_empleados FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado), -- Relación con la tabla empleados
    CONSTRAINT FK_ordenes_sucursales FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal), -- Relación con la tabla sucursales
    CONSTRAINT FK_ordenes_mensajeros FOREIGN KEY (id_mensajero) REFERENCES mensajeros(id_mensajero), -- Relación con la tabla mensajeros
    CONSTRAINT FK_ordenes_tipos_pago FOREIGN KEY (id_tipo_pago) REFERENCES tipos_pago(id_tipo_pago), -- Relación con la tabla tipos de Pago
    CONSTRAINT FK_ordenes_origenes FOREIGN KEY (id_origen) REFERENCES origenes(id_origen); -- relación con la tabla Orígenes

-------------------------------------------------
-- Modificar campos en la tabla detalle_ordenes
-------------------------------------------------

-- Agregar la columna 'precio' a la tabla 'detalle_ordenes'

ALTER TABLE detalle_ordenes 
ADD 
    precio DECIMAL(10, 2); -- Precio del producto en la orden

 -- Agregar la columna id_detalle_orden

ALTER TABLE detalle_ordenes
ADD id_detalle_orden INT IDENTITY(1,1) NOT NULL; -- Agregar la columna id_detalle_orden
GO

-- Modificar la tabla para agregar la nueva llave primaria

ALTER TABLE detalle_ordenes
DROP CONSTRAINT [PK__detalle___12A8CEF332849BA3]; -- Eliminando la clave primaria existente

-- Agregar las nuevas llaves primarias

ALTER TABLE detalle_ordenes
ADD PRIMARY KEY (id_detalle_orden, id_orden, id_producto); -- Nueva clave primaria

---------------------------------------------
-- Insertar datos en la tabla productos
---------------------------------------------

INSERT INTO productos (id_producto, nombre, id_categoria, precio) 
VALUES
(1, 'Hamburguesa Deluxe', 1, 9.99),
(2, 'Cheeseburger', 1, 7.99),
(3, 'Pizza Margarita', 10, 11.99),
(4, 'Pizza Pepperoni', 10, 12.99),
(5, 'Helado de Chocolate', 7, 2.99),
(6, 'Helado de Vainilla', 7, 2.99),
(7, 'Ensalada César', 4, 5.99),
(8, 'Ensalada Griega', 4, 6.99),
(9, 'Pastel de Zanahoria', 2, 3.99),
(10, 'Brownie', 2, 2.99);

-------------------------------------------
-- Insertar datos en la tabla sucursales
-------------------------------------------

INSERT INTO sucursales (id_sucursal, nombre, direccion) 
VALUES
(1, 'Sucursal Central', '1234 Main St'),
(2, 'Sucursal Norte', '5678 North St'),
(3, 'Sucursal Este', '9101 East St'),
(4, 'Sucursal Oeste', '1121 West St'),
(5, 'Sucursal Sur', '3141 South St'),
(6, 'Sucursal Playa', '1516 Beach St'),
(7, 'Sucursal Montaña', '1718 Mountain St'),
(8, 'Sucursal Valle', '1920 Valley St'),
(9, 'Sucursal Lago', '2122 Lake St'),
(10, 'Sucursal Bosque', '2324 Forest St');

-------------------------------------------
-- Insertar datos en la tabla empleados
-------------------------------------------

INSERT INTO empleados (id_empleado, nombre, posicion, departamento, id_sucursal, rol) 
VALUES
(1, 'John Doe', 'Gerente', 'Administración', 1, 'Vendedor'),
(2, 'Jane Smith', 'Subgerente', 'Ventas', 1, 'Vendedor'),
(3, 'Bill Jones', 'Cajero', 'Ventas', 1, 'Vendedor'),
(4, 'Alice Johnson', 'Cocinero', 'Cocina', 1, 'Vendedor'),
(5, 'Tom Brown', 'Barista', 'Cafetería', 1, 'Vendedor'),
(6, 'Emma Davis', 'Repartidor', 'Logística', 1, 'Mensajero'),
(7, 'Lucas Miller', 'Atención al Cliente', 'Servicio', 1, 'Vendedor'),
(8, 'Olivia García', 'Encargado de Turno', 'Administración', 1, 'Vendedor'),
(9, 'Ethan Martinez', 'Mesero', 'Restaurante', 1, 'Vendedor'),
(10, 'Sophia Rodriguez', 'Auxiliar de Limpieza', 'Mantenimiento', 1, 'Vendedor');

----------------------------------
-- Insertar datos en la clientes 
----------------------------------

INSERT INTO clientes (id_cliente, nombre, direccion) 
VALUES
(1, 'Cliente Uno', '1000 A Street'),
(2, 'Cliente Dos', '1001 B Street'),
(3, 'Cliente Tres', '1002 C Street'),
(4, 'Cliente Cuatro', '1003 D Street'),
(5, 'Cliente Cinco', '1004 E Street'),
(6, 'Cliente Seis', '1005 F Street'),
(7, 'Cliente Siete', '1006 G Street'),
(8, 'Cliente Ocho', '1007 H Street'),
(9, 'Cliente Nueve', '1008 I Street'),
(10, 'Cliente Diez', '1009 J Street');

----------------------------------------
-- Insertar datos en la origenes_orden 
----------------------------------------

INSERT INTO origenes_orden (id_origen, descripcion) 
VALUES
(1, 'En línea'),
(2, 'Presencial'),
(3, 'Teléfono'),
(4, 'Drive Thru'),
(5, 'App Móvil'),
(6, 'Redes Sociales'),
(7, 'Correo Electrónico'),
(8, 'Publicidad'),
(9, 'Recomendación'),
(10, 'Evento');

-------------------------------------
-- Insertar datos en la tipos_pago
-------------------------------------

INSERT INTO tipos_pago (id_tipo_pago, descripcion) 
VALUES
(1, 'Efectivo'),
(2, 'Tarjeta de Crédito'),
(3, 'Tarjeta de Débito'),
(4, 'PayPal'),
(5, 'Transferencia Bancaria'),
(6, 'Criptomonedas'),
(7, 'Cheque'),
(8, 'Vale de Comida'),
(9, 'Cupón de Descuento'),
(10, 'Pago Móvil');

-------------------------------------
-- Insertar datos en la mensajeros
-------------------------------------

INSERT INTO mensajeros (id_mensajero, nombre, es_externo) VALUES
(1, 'Mensajero Uno', 0), 
(2, 'Mensajero Dos', 1), 
(3, 'Mensajero Tres', 0), 
(4, 'Mensajero Cuatro', 1), 
(5, 'Mensajero Cinco', 0),
(6, 'Mensajero Seis', 1), 
(7, 'Mensajero Siete', 0), 
(8, 'Mensajero Ocho', 1), 
(9, 'Mensajero Nueve', 0), 
(10, 'Mensajero Diez', 1);

-----------------------------------
-- Insertar datos en la ordenes
-----------------------------------

-- Eliminar la clave foránea que apunta a la tabla incorrecta

ALTER TABLE ordenes
DROP CONSTRAINT FK_ordenes_origenes; 

-- Agregamos la clave foránea que apunta a la tabla origenes_orden

ALTER TABLE ordenes
ADD CONSTRAINT FK_ordenes_origenes_orden
FOREIGN KEY (id_origen) REFERENCES origenes_orden(id_origen);

INSERT INTO ordenes (id_orden, id_cliente, id_empleado, id_sucursal, id_mensajero, id_tipo_pago, id_origen, horario_venta, total_compra, kilometros_recorrer, fecha_despacho, fecha_entrega, fecha_orden_tomada, fecha_orden_lista) VALUES
(1, 1, 1, 1, 1, 1, 1, 'Mañana', 1053.51, 5.5, '2023-01-10 08:30:00', '2023-01-10 09:00:00', '2023-01-10 08:00:00', '2023-01-10 08:15:00'),
(2, 2, 2, 2, 2, 2, 2, 'Tarde', 1075.00, 10.0, '2023-02-15 14:30:00', '2023-02-15 15:00:00', '2023-02-15 13:30:00', '2023-02-15 14:00:00'),
(3, 3, 3, 3, 3, 3, 3, 'Noche', 920.00, 2.0, '2023-03-20 19:30:00', '2023-03-20 20:00:00', '2023-03-20 19:00:00', '2023-03-20 19:15:00'),
(4, 4, 4, 4, 4, 4, 4, 'Mañana', 930.00, 0.5, '2023-04-25 09:30:00', '2023-04-25 10:00:00', '2023-04-25 09:00:00', '2023-04-25 09:15:00'),
(5, 5, 5, 5, 5, 5, 5, 'Tarde', 955.00, 8.0, '2023-05-30 15:30:00', '2023-05-30 16:00:00', '2023-05-30 15:00:00', '2023-05-30 15:15:00'),
(6, 6, 6, 6, 6, 1, 1, 'Noche', 945.00, 12.5, '2023-06-05 20:30:00', '2023-06-05 21:00:00', '2023-06-05 20:00:00', '2023-06-05 20:15:00'),
(7, 7, 7, 7, 7, 2, 2, 'Mañana', 1065.00, 7.5, '2023-07-10 08:30:00', '2023-07-10 09:00:00', '2023-07-10 08:00:00', '2023-07-10 08:15:00'),
(8, 8, 8, 8, 8, 3, 3, 'Tarde', 1085.00, 9.5, '2023-08-15 14:30:00', '2023-08-15 15:00:00', '2023-08-15 14:00:00', '2023-08-15 14:15:00'),
(9, 9, 9, 9, 9, 4, 4, 'Noche', 1095.00, 3.0, '2023-09-20 19:30:00', '2023-09-20 20:00:00', '2023-09-20 19:00:00', '2023-09-20 19:15:00'),
(10, 10, 10, 10, 10, 5, 5, 'Mañana', 900.00, 15.0, '2023-10-25 09:30:00', '2023-10-25 10:00:00', '2023-10-25 09:00:00', '2023-10-25 09:15:00');

-----------------------------------------
-- Insertar datos en la detalle_ordenes
-----------------------------------------

-- Insertar datos en detalle_ordenes

INSERT INTO detalle_ordenes (id_orden, id_producto, cantidad, precio) VALUES
(1, 1, 3, 23.44),  -- OrdenID 1, ProductoID 1, Cantidad 3, Precio 23.44
(1, 2, 5, 45.14),  -- OrdenID 1, ProductoID 2, Cantidad 5, Precio 45.14
(1, 3, 4, 46.37),  -- OrdenID 1, ProductoID 3, Cantidad 4, Precio 46.37
(1, 4, 4, 42.34),  -- OrdenID 1, ProductoID 4, Cantidad 4, Precio 42.34
(1, 5, 1, 18.25),  -- OrdenID 1, ProductoID 5, Cantidad 1, Precio 18.25
(1, 6, 4, 20.08),  -- OrdenID 1, ProductoID 6, Cantidad 4, Precio 20.08
(1, 7, 2, 13.31),  -- OrdenID 1, ProductoID 7, Cantidad 2, Precio 13.31
(1, 8, 2, 20.96),  -- OrdenID 1, ProductoID 8, Cantidad 2, Precio 20.96
(1, 9, 4, 30.13),  -- OrdenID 1, ProductoID 9, Cantidad 4, Precio 30.13
(1, 10, 3, 38.34); -- OrdenID 1, ProductoID 10, Cantidad 3, Precio 38.34

--------------------------------
-- ACTUALIZACIÓNES CON UPDATE --
--------------------------------
-- Aumentar el precio de todos los productos en la categoría 1

UPDATE Productos
SET precio = precio + 1
WHERE id_categoria = 1;

-- Cambiar la posición de todos los empleados del departamento 'Cocina' a 'Chef'

UPDATE Empleados
SET posicion = 'Chef' 
WHERE Departamento = 'Cocina'

-- Actualizar la dirección de una sucursal específica

UPDATE Sucursales
SET direccion = '1414 Top St'
WHERE nombre = 'Sucursal Central'

------------------------------
-- ELIMINACIONES CON DELETE --
------------------------------

-- Eliminar una orden específica, la orden con id_orden = 10.  

DELETE FROM ordenes
WHERE id_orden = 10;

-- Eliminar empleados de una sucursal que cerró, el id_sucursal = 10

DELETE FROM empleados
WHERE id_sucursal = 10;

------------------------------------------------------------------------------------------------------------------------------------
-- AVANCE 2 - RESOLUCIÓN DE CONSULTAS BÁSICAS (POBLACIÓN DE TABLAS MEDIANTE QUERYS Y RESOLVER CONSULTAS UTILIZANDO SENTENCIAS DML --
------------------------------------------------------------------------------------------------------------------------------------
---------------
-- CONSULTAS --
---------------
-- 1. Registros únicos

-- ¿Cuál es la cantidad total de registros únicos en la tabla de órdenes?

SELECT COUNT (id_orden) as cantidad_ordenes_unicas  -- Cuenta el número de órdenes únicas
FROM ordenes -- Desde la tabla ordenes

-- 2. Empleados por departamento

-- ¿Cuántos empleados existen en cada departamento?

SELECT departamento, COUNT(*) as empleados_por_departamento -- Selecciona el nombre del departamento -- Cuenta la cantidad de empleados por departamento
FROM empleados -- Desde la tabla empleados
GROUP BY departamento; -- Agrupado por departamento

-- 3. Productos por categoría

-- ¿Cuántos productos hay por código de categoría?

SELECT id_categoria, COUNT(*) as productos_por_categoria -- Selecciona el id de la categoría -- Cuenta la cantidad de productos por cada categoría
FROM productos -- Desde la tabla productos
GROUP BY id_categoria -- Agrupado por id_categoria

-- 4. Importación de clientes

-- ¿Cuántos clientes se han importado a la tabla de clientes?

SELECT COUNT (*) as cantidad_clientes -- Cuenta el número total de clientes
FROM clientes -- Desde la tabla clientes

-- 5. Análisis de desempeño de sucursales

/* Pregunta: ¿Cuáles son las sucursales con un promedio de Facturación/Ingresos superior a 1000.00
y que que minimizan sus costos en base al promedio de kilómetros recorridos de todas de sus entregas gestionadas?
Para un mejor relevamiento, ordene el listado por el Promedio Km Recorridos. */

SELECT id_sucursal, -- Selecciona el id de la sucursal
AVG(total_compra) AS promedio_facturacion, -- Calcula el promedio de facturación por sucursal
AVG(kilometros_recorrer) AS promedio_kilometros -- Calcula el promedio de kilómetros recorridos
FROM ordenes -- Desde la tabla ordenes
GROUP BY id_sucursal -- Agrupado por id_sucursal
HAVING AVG(total_compra) > 1000.00 -- Filtra por sucursales con promedio de facturación mayor a 1000
ORDER BY promedio_kilometros ASC; -- Ordenado por promedio de kilómetros recorridos, de menor a mayor

---------------
-- CONSULTAS --
---------------