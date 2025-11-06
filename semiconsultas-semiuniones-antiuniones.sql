--Veremos que son las semiuniones y antiuniones en SQL 

SELECT country, continent, president 
FROM presidents
WHERE column IN (
    SELECT name 
    FROM states 
    WHERE independent < 1800
);
--Nos devuelve los presidentes de los paises que tienen estados independientes antes de 1800


SELECT product_id, product_name, product_price
FROM products
WHERE product_price > (
    SELECT AVG(product_price)
    FROM products
    WHERE category = 'Electronics'
);
--Nos devuelve los productos de la categoria electronica que tienen un precio mayor al precio promedio de todos los productos de esa categoria.

SELECT employee_id, employee_name, department
FROM employees
WHERE department IN (
    SELECT department_name
    FROM departments
    WHERE location = 'New York'
);
--Nos devuelve los empleados que trabajan en departamentos ubicados en Nueva York

--Ahora veremos las antiuniones es lo mismo que las semiuniones pero con NOT IN o NOT EXISTS

SELECT country, continent, president
FROM presidents
WHERE country NOT IN (
    SELECT name 
    FROM states 
    WHERE independent < 1800
);
--Nos devuelve los presidentes de los paises que NO tienen estados independientes antes de 1800

SELECT product_id, product_name, product_price
FROM products
WHERE product_id NOT IN (
    SELECT product_id 
    FROM products 
    WHERE category = 'Electronics'
);
