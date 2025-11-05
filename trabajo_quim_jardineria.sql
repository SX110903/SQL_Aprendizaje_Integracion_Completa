--Seleccion completa recupera todas las columnas y todos los registros de la tabla empleados

SELECT * 
FROM empleado;

--Columnas especificas muestra unicamente el nombre_cliente, nombre contacto y telefono de la tabla clientes
SELECT nombre_cliente, nombre_contacto, telefono
FROM cliente;

--Orden ascendente lista todos los nombres y apellido 1 de la tabla empleados ordenados alfa beticamente por apellido1
SELECT nombre, apellido1 AS primer_apellido
FROM empleado
ORDER BY apellido1 ASC;

--Orden Descendente: Muestra el nombre y el precio_venta de la tabla producto, ordenados del precio más alto al más bajo.
SELECT nombre, precio_venta
FROM producto
ORDER BY precio_venta DESC;

--Combinación de Campos: Lista el nombre y la gama de los productos, ordenados primero por gama (ascendente) y luego por nombre (ascendente).
SELECT nombre, gama
FROM producto
ORDER BY gama ASC, nombre ASC;

--Igualdad Simple: Obtén el nombre, apellido1 y puesto de los empleados cuyo puesto sea exactamente 'Director General'.
SELECT nombre, apellido1 AS primer_apellido, puesto
FROM empleado
WHERE puesto = 'Director General';

--Filtrado Numérico: Muestra todos los datos de los clientes cuyo limite_credito sea igual a 0.
SELECT *
FROM cliente
WHERE limite_credito = 0;

--Filtrado por Texto: Lista el nombre y el pais de las oficinas que se encuentran en 'España'.
SELECT codigo_oficina, pais
FROM oficina
WHERE pais = 'España';

--Diferente de: Recupera el nombre_cliente y el pais de todos los clientes que no viven en 'USA'.
SELECT nombre_cliente, pais
FROM cliente
WHERE pais != 'USA';

--Doble Condición (AND): Muestra el nombre y apellido1 de los empleados cuyo puesto es 'Representante Ventas' y cuyo codigo_oficina es 'BCN-ES'.
SELECT nombre, apellido1 AS primer_apellido
FROM empleado
WHERE puesto = 'Representante Ventas' AND codigo_oficina = 'BCN-ES';

--Rango Numérico (BETWEEN): Lista el nombre y el precio_venta de los productos que tienen un precio de venta entre 10 y 20 (ambos inclusive).
SELECT nombre, precio_venta
FROM producto
WHERE precio_venta BETWEEN 10 AND 20;

--Rango de Stock (BETWEEN): Muestra el nombre y la cantidad_en_stock de los productos que tienen entre 500 y 1000 unidades en stock.
SELECT nombre, cantidad_en_stock
FROM producto
WHERE cantidad_en_stock BETWEEN 500 AND 1000;

--Múltiples Opciones (IN): Obtén el nombre_cliente y el pais de los clientes que residen en 'Francia', 'Alemania' o 'Italia'.
SELECT nombre_cliente, pais
FROM cliente
WHERE pais IN ('Francia', 'Alemania', 'Italia');

--Opción Negada (NOT IN): Muestra el nombre, apellido1 y puesto de los empleados que no tienen el puesto de 'Representante Ventas' o 'Director Oficina'.
SELECT nombre, apellido1 AS primer_apellido, puesto
FROM empleado
WHERE puesto NOT IN ('Representante Ventas', 'Director Oficina');

--Patrón al Inicio (LIKE): Lista el nombre_cliente y la ciudad de todos los clientes cuyo nombre comience con la letra 'G'.
SELECT 
    nombre_cliente, 
    ciudad
FROM cliente
WHERE nombre_cliente LIKE 'G%';

--MODIQUE El EJERCICIO PARA HACERLO MAS COMPLEJO CON JOIN CRUZADOS  EJERCICIO: mostrar todas las columnas de la tabla de productos junto con el gama producto que contenga la plabra planta en cualquier de las columnas mencionadas 


SELECT p.nombre, p.precio_venta, p.cantidad_en_stock, p.descripcion, p.gama
FROM producto p
JOIN gama_producto g ON p.gama = g.gama
WHERE 
    p.nombre LIKE '%planta%' 
    OR p.descripcion LIKE '%planta%' 
    OR p.gama LIKE '%planta%' 
    OR g.descripcion_texto LIKE '%planta%' 
    OR g.descripcion_html LIKE '%planta%';

--Patrón al Final (LIKE): Obtén la linea_direccion1 de las oficinas cuya dirección termine con la palabra 'street' (utiliza el comodín `%street').
SELECT linea_direccion1 
FROM oficina
WHERE linea_direccion1 LIKE '%street';

--Valores Únicos (DISTINCT): ¿Qué puestos diferentes existen en la tabla empleado? (Muestra la lista sin repeticiones).
SELECT DISTINCT puesto
FROM empleado;  

--Valores Únicos por Categoría (DISTINCT): ¿Qué gamas diferentes de productos existen en la tabla producto?
SELECT DISTINCT gama
FROM producto;  
--Combinación Avanzada: Lista el nombre_cliente y el limite_credito de los clientes cuyo nombre_cliente contenga la palabra 'S.L' (%S.L%) y ordénalos por limite_credito de forma descendente.
SELECT nombre_cliente, limite_credito
FROM cliente
WHERE nombre_cliente LIKE '%S.L%'
ORDER BY limite_credito DESC;
