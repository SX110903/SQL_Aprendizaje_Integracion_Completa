
--Bloque uno: Ejercicios de joins   
--Consulta 1.1: Listar todos los clientes junto con su representante de ventas asignado
--Consulta 1.2: Mostrar los pedidos con los detalles del cliente que los realizó
--Consulta 1.3: Obtener los productos con su información de gama correspondiente
--Consulta 1.4: Listar los detalles de pedidos con información completa del producto



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


--Mas ejercicios de joins los pondre en el archivo repaso-join.sql y semiconsultas-semiuniones-antiuniones.sql