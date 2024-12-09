---------------------------------------------------------------------------------------------------------------------------------------
-- AVANCE 1 - CREACIÓN DE LA BD (UTILIZACIÓN DE DDL PARA ELABORACIÓN DE TABLAS, DEFINICIÓN DE CAMPOS Y ESTABLECIMIENTO DE RELACIONES --
---------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------
-- Creación de base de datos fast_food
----------------------------------------

CREATE DATABASE fast_food;
GO

--------------------------------------------------------------------
-- Usar la base de datos fast_food para las siguientes operaciones
--------------------------------------------------------------------

USE fast_food;
GO

----------------------------
-- Crear la tabla clientes
----------------------------

CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY NOT NULL, -- Identificador único del cliente
    nombre VARCHAR(100), -- Nombre del cliente
    apellido VARCHAR(100), -- Apellido del cliente
    email VARCHAR(255), -- Email del cliente
    telefono VARCHAR(20), -- Teléfono del cliente
    direccion VARCHAR(255), -- Dirección del cliente
    fecha_registro DATETIME, -- Fecha en que se registró el cliente
    fecha_nacimiento DATETIME -- Fecha de nacimiento del cliente
); 
GO

-----------------------------
-- Crear la tabla sucursales
-----------------------------

CREATE TABLE sucursales (
    id_sucursal INT PRIMARY KEY NOT NULL, -- Identificador único de la sucursal
    nombre_sucursal VARCHAR(100), -- Nombre de la sucursal
    direccion VARCHAR(255), -- Dirección de la sucursal
    telefono VARCHAR(20) -- Teléfono de la sucursal
); 
GO

----------------------------
-- Crear la tabla origenes
----------------------------

CREATE TABLE origenes (
    id_origen INT PRIMARY KEY NOT NULL, -- Identificador único del origen
    nombre_origen VARCHAR(50) -- Nombre del origen (en línea, presencial, teléfono, Drive Thru)
); 
GO

--------------------------------
-- Crear la tabla tipos de pago
--------------------------------

CREATE TABLE tipos_pago (
    id_tipo_pago INT PRIMARY KEY NOT NULL, -- Identificador único del tipo de pago
    tipo_pago VARCHAR(50) -- Tipo de pago (efectivo, tarjeta de crédito, tarjeta de débito, transferencia)
); 
GO

----------------------------
-- Crear la tabla empleados
----------------------------

CREATE TABLE empleados (
    id_empleado INT PRIMARY KEY NOT NULL, -- Identificador único del empleado
    nombre VARCHAR(100), -- Nombre del empleado
    apellido VARCHAR(100), -- Apellido del empleado
    puesto VARCHAR(100), -- Puesto del empleado
    departamento VARCHAR(100), -- Departamento del empleado
    rol VARCHAR(100), -- Rol del empleado
    fecha_nacimiento DATETIME, -- Fecha de nacimiento del empleado
    fecha_contratacion DATETIME, -- Fecha en que se unió el empleado
    salario DECIMAL(10, 2), -- Salario del empleado
    id_sucursal INT NOT NULL, -- Identificador de la sucursal (FK)
    FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal) -- Relación con la tabla Sucursales
); 
GO

-----------------------------
-- Crear la tabla mensajeros
-----------------------------

CREATE TABLE mensajeros (
    id_mensajero INT PRIMARY KEY NOT NULL, -- Identificador único del mensajero
    nombre VARCHAR(100), -- Nombre del mensajero
    apellido VARCHAR(100), -- Apellido del mensajero
    tipo VARCHAR(50), -- Tipo de mensajero (empleado o externo)
    id_empleado INT NOT NULL, -- Identificador del empleado (FK, opcional)
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado) -- Relación con la tabla Empleados
); 
GO

-----------------------------
-- Crear la tabla productos
-----------------------------

CREATE TABLE productos (
    id_producto INT PRIMARY KEY NOT NULL, -- Identificador único del producto
    nombre VARCHAR(100), -- Nombre del producto
    precio DECIMAL(10, 2), -- Precio del producto
    categoria VARCHAR(100), -- Categoría del producto (atributo)
    descripcion VARCHAR(255), -- Descripción del producto
    stock INT -- Stock disponible del producto
); 
GO

---------------------------
-- Crear la tabla órdenes
---------------------------

CREATE TABLE ordenes (
    id_orden INT PRIMARY KEY NOT NULL, -- Identificador único de la orden
    id_cliente INT NOT NULL, -- Identificador del cliente (FK)
    id_mensajero INT NOT NULL, -- Identificador del mensajero (FK)
    id_origen INT NOT NULL, -- Identificador del origen (FK)
    id_tipo_pago INT NOT NULL, -- Identificador del tipo de pago (FK)
    id_sucursal INT NOT NULL, -- Identificador de la sucursal (FK)
    id_empleado INT NOT NULL, -- Identificador del empleado que realizó la orden (FK)
    horario_venta VARCHAR(20), -- Horario de la venta (mañana, tarde, noche)
    total_compra DECIMAL(10, 2), -- Total de la compra
    kilometros_recorrer DECIMAL(10, 2), -- Kilómetros a recorrer en caso de entrega a domicilio
    fecha_despacho DATETIME, -- Fecha y hora de despacho
    fecha_entrega DATETIME, -- Fecha y hora de entrega
    fecha_orden_tomada DATETIME, -- Fecha y hora en que se tomó la orden
    fecha_orden_lista DATETIME, -- Fecha y hora en que la orden estuvo lista
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente), -- Relación con la tabla Clientes
    FOREIGN KEY (id_mensajero) REFERENCES mensajeros(id_mensajero), -- Relación con la tabla Mensajeros
    FOREIGN KEY (id_origen) REFERENCES origenes(id_origen), -- Relación con la tabla Orígenes
    FOREIGN KEY (id_tipo_pago) REFERENCES tipos_pago(id_tipo_pago), -- Relación con la tabla Tipos de Pago
    FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal), -- Relación con la tabla Sucursales
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado) -- Relación con la tabla Empleados
); 
GO

-------------------------------------------------
-- Crear la tabla intermedia órdenes_productos
-------------------------------------------------

CREATE TABLE detalle_orden (
    id_orden INT NOT NULL, -- Identificador de la orden (FK)
    id_producto INT NOT NULL, -- Identificador del producto (FK)
    cantidad INT, -- Cantidad del producto en la orden
    PRIMARY KEY (id_orden, id_producto), -- Clave primaria compuesta
    FOREIGN KEY (id_orden) REFERENCES ordenes(id_orden), -- Relación con la tabla órdenes
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) -- Relación con la tabla Productos
); 
GO

---------------------------------------------------------------------------------------------------------------------------------------
-- AVANCE 1 - CREACIÓN DE LA BD (UTILIZACIÓN DE DDL PARA ELABORACIÓN DE TABLAS, DEFINICIÓN DE CAMPOS Y ESTABLECIMIENTO DE RELACIONES --
---------------------------------------------------------------------------------------------------------------------------------------