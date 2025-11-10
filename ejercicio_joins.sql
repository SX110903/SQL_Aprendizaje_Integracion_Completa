--=================================================================================
--Consultas BLOQUE 1
--Consulta 1.1: Listar todos los clientes junto con su representante de ventas asignado
--Consulta 1.2: Mostrar los pedidos con los detalles del cliente que los realizó
--Consulta 1.3: Obtener los productos con su información de gama correspondiente
--Consulta 1.4: Listar los detalles de pedidos con información completa del producto
--===================================================================================

--Al la relacion viene de clientes con empleados de representantes de ventas

SELECT 
    cliente.nombre_cliente AS nombre_cliente, 
    empleado.nombre AS representante_ventas
FROM cliente 
INNER JOIN empleado ON cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado;

----Consulta 1.2: Mostrar los pedidos con los detalles del cliente que los realizó

SELECT
    cliente.nombre_cliente AS nombre_cliente,
    pedido.codigo_pedido AS numero_pedido,
    cliente.telefono AS telefono_cliente,
    cliente.linea_direccion1 AS direccion_cliente_primaria,
    cliente.codigo_postal AS codigo_postal_cliente,
    cliente.region AS region_cliente,
    cliente.pais AS pais_cliente,
    cliente.fax AS fax_cliente
FROM cliente 
INNER JOIN pedido ON cliente.codigo_cliente = pedido.codigo_cliente;

--Consulta 1.3: Obtener los productos con su información de gama correspondiente
SELECT
    producto.nombre AS nombre_producto,
    producto.precio_venta AS precio_venta,
    producto.cantidad_en_stock AS cantidad_en_stock,
    gama_producto.gama AS gama_producto,
    gama_producto.descripcion_texto AS descripcion_gama_texto,
    gama_producto.descripcion_html AS descripcion_gama_html
FROM producto
INNER JOIN gama_producto ON producto.gama = gama_producto.gama;

--Consulta 1.4: Listar los detalles de pedidos con información completa del producto realmente tenemos dos tablas detalle_pedido y producto

SELECT
    detalle_pedido.codigo_pedido AS numero_pedido,
    detalle_pedido.codigo_producto AS codigo_producto,
    detalle_pedido.cantidad AS cantidad_pedida,
    detalle_pedido.precio_unidad AS precio_unidad,
    detalle_pedido.numero_linea AS numero_linea,
    producto.codigo_producto AS codigo_producto,
    producto.nombre AS nombre_producto,
    producto.precio_venta AS precio_venta
FROM detalle_pedido
INNER JOIN producto ON detalle_pedido.codigo_producto = producto.codigo_producto;


--=================================================================================
--Consultas BLOQUE 2 LEFT JOIN
--Consulta 2.1: Listar todos los clientes y sus pagos (incluyendo clientes sin pagos)
--Consulta 2.2: Mostrar todos los empleados y sus subordinados directos (si los tienen)
--Consulta 2.3: Listar todos los productos y sus ventas (incluyendo productos no vendidos)
--Consulta 2.4: Mostrar todas las oficinas y sus empleados (incluyendo oficinas sin empleados)

--La forma por lo que entiendo LEFT JOIN es que la tabla de la izquierda es la principal y la de la derecha es la secundaria
--La Izquierda es la que siempre va a aparecer y la derecha solo si tiene datos relacionados 
--La izquierda es la FROM y la derecha es el JOIN
--=================================================================================

--Consulta 2.1: Listar todos los clientes y sus pagos (incluyendo clientes sin pagos) Izquierda cliente derecha pagos
SELECT
    c.nombre_cliente AS nombre_cliente,
    p.fecha_pago AS fecha_pago,
    p.total AS monto_pago,
    p.forma_pago AS forma_pago
FROM cliente AS c
LEFT JOIN pago AS p ON c.codigo_cliente = p.codigo_cliente;

--Consulta 2.2 Mostrar todos los empleados y sus subordinados directos (si los tienen) Izquierda empleado derecha subordinados REALMENTE si director tiene trabajador esa es la relacion
--Para este caso haremos un SELF JOIN porque la tabla empleado se relaciona consigo misma y tiene una columna como codigo_jefe


SELECT
    e.nombre AS nombre_empleado,
    e.apellido1 AS primer_apellido,
    e.puesto AS puesto
FROM empleado AS e
LEFT JOIN empleado AS s ON e.codigo_empleado = s.codigo_jefe;


--Consulta 2.3: Listar todos los productos y sus ventas (incluyendo productos no vendidos) Izquierda productos derecha detalle_pedido
SELECT
    p.codigo_producto AS codigo_producto,
    p.nombre AS nombre_producto,
    p.precio_venta AS precio_venta,
    p.cantidad_en_stock AS cantidad_en_stock,
    dp.cantidad AS cantidad_vendida
FROM producto AS p
LEFT JOIN detalle_pedido AS dp ON p.codigo_producto = dp.codigo_producto;

--Consulta 2.4: Mostrar todas las oficinas y sus empleados (incluyendo oficinas sin empleados) Izquierda oficinas derecha empleados
SELECT
    o.codigo_oficina AS codigo_oficina,
    o.ciudad AS ciudad_oficina, 
    o.pais AS pais_oficina,
    e.nombre AS nombre_empleado,
    e.apellido1 AS primer_apellido,
    e.puesto AS puesto_empleado
FROM oficina AS o
LEFT JOIN empleado AS e ON o.codigo_oficina = e.codigo_oficina;

--MySQL no soporta FULL OUTER JOIN directamente, pero podemos simularlo combinando LEFT JOIN y RIGHT JOIN con UNION. Devuelve todos los registros de ambas tablas, mostrando coincidencias donde existan y NULL donde no haya correspondencia. Os invito a los curiosos a ver más en canales de divulgación por redes sociales o canales más académicos.
--Más adelante veremos cómo resolvemos la aplicación de FULL OUTER JOIN en otros servicios de DB y en Workbench.   No os preocupéis ;)

--=================================================================================
--Consultas BLOQUE 3 RIGHT JOIN
--Consulta 3.1: Mostrar todos los pagos y la información del cliente (incluyendo pagos sin cliente asociado)
--Consulta 3.2: Listar todos los pedidos y sus detalles (incluyendo pedidos sin detalles)
--Consulta 3.3: Mostrar todas las gamas de producto y los productos asociados (incluyendo gamas sin productos)
--Consulta 3.4: Listar todos los empleados como jefes y sus subordinados (incluyendo jefes sin subordinados)
--=================================================================================

--En RIGHT JOIN la tabla de la derecha es la principal y la de la izquierda es la secundaria es 
--BASICAMENTE DERECHA : JOIN y FROM  es la IZQUIERDA
--=================================================================================

--Consulta 3.1: Mostrar todos los pagos y la información del cliente (incluyendo pagos sin cliente asociado) Derecha pagos izquierda clientes
SELECT
    p.fecha_pago AS fecha_pago,
    p.total AS monto_pago,
    p.forma_pago AS forma_pago,
    c.nombre_cliente AS nombre_cliente
FROM pago AS p
RIGHT JOIN cliente AS c ON p.codigo_cliente = c.codigo_cliente;
--Consulta 3.2: Listar todos los pedidos y sus detalles (incluyendo pedidos sin detalles) Derecha pedidos izquierda detalle_pedido
SELECT 
    pe.codigo_pedido AS numero_pedido,
    pe.fecha_pedido AS fecha_pedido,
    pe.estado AS estado_pedido,
    dp.codigo_producto AS codigo_producto,
    dp.cantidad AS cantidad_pedida,
    dp.precio_unidad AS precio_unidad
FROM pedido AS pe
RIGHT JOIN detalle_pedido AS dp ON pe.codigo_pedido = dp.codigo_pedido;

--Consulta 3.3: Mostrar todas las gamas de producto y los productos asociados (incluyendo gamas sin productos) Derecha gama_producto izquierda producto
SELECT
    gp.gama AS gama_producto,
    gp.descripcion_texto AS descripcion_gama_texto,
    gp.descripcion_html AS descripcion_gama_html,
    p.nombre AS nombre_producto,
    p.precio_venta AS precio_venta
FROM gama_producto AS gp
RIGHT JOIN producto AS p ON gp.gama = p.gama;