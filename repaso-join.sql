--NOS estamos adelantado pero veremos que es  EXCEPT 

SELECT name 
FROM cities  --Tabla de izquierda (TODAS las ciudades)
EXCEPT
SELECT name
FROM countries   --Esta es la que excluye, solo las capitales (DERECHA) capitales
WHERE region = 'Europe';

--Esto nos devuelve todas las ciudades que no son capitales de paises en Europa porque 
--la tabla de la izquierda (cities) tiene todas las ciudades y la de la derecha (countries) solo las capitales europeas.
--Entonces EXCEPT nos devuelve las filas de la primera consulta que no estan en la segunda consulta.

--PONDREMOS otro ejemplo más claro

