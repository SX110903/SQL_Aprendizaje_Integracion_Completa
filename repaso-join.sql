--NOS estamos adelantado pero veremos que es  EXCEPT 

SELECT name 
FROM cities 
EXCEPT
SELECT name
FROM countries 
WHERE region = 'Europe';

--Esto nos devuelve todas las ciudades que no son capitales de paises en Europa porque 
--la tabla de la izquierda (cities) tiene todas las ciudades y la de la derecha (countries) solo las capitales europeas.
--Entonces EXCEPT nos devuelve las filas de la primera consulta que no estan en la segunda consulta.

--PONDREMOS otro ejemplo más claro

