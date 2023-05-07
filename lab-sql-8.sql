USE sakila;

/* 1. Rank films by length (filter out the rows with nulls or zeros in length column). 
Select only columns title, length and rank in your output.*/ 
SELECT * FROM film;

SELECT title, length 
FROM  film
ORDER BY length DESC;

SELECT title, `length`, RANK() OVER (ORDER BY `length` DESC) AS `rank`
FROM film
WHERE `length` IS NOT NULL AND `length`<> 0;


/* 2. Rank films by length within the rating category (filter out the rows with nulls or zeros 
in length column). In your output, only select the columns title, length, rating and rank.*/
SELECT * FROM film;

SELECT title, rating, `length`, DENSE_RANK() OVER (PARTITION BY rating ORDER BY `length` DESC) AS `rank`
FROM film;

/* 3. How many films are there for each of the categories in the category table? 
Hint: Use appropriate join between the tables "category" and "film_category".*/ 
SELECT c.`name`, COUNT(f.film_id) AS number_of_films
FROM film_category AS f
LEFT JOIN category AS c
ON c.category_id = f.category_id
GROUP BY c.`name`
ORDER BY c.`name`;


/* 4. Which actor has appeared in the most films? 
Hint: You can create a join between the tables "actor" and "film actor" and count 
the number of times an actor appears.*/
SELECT CONCAT(a.first_name, ' ', a.last_name) AS actor, COUNT(f.actor_id) AS number_of_appearances
FROM actor AS a
RIGHT JOIN film_actor AS f
ON f.actor_id = a.actor_id
GROUP BY actor
ORDER BY 2 DESC
LIMIT 1;

/*En un LEFT JOIN, todas las filas de la tabla de la izquierda (primera tabla en la cláusula JOIN) 
se incluyen en el resultado, incluso si no hay coincidencias en la tabla de la derecha (segunda tabla 
en la cláusula JOIN).

En un RIGHT JOIN, todas las filas de la tabla de la derecha se incluyen en el resultado, incluso si no 
hay coincidencias en la tabla de la izquierda. En ese caso, las filas que no tienen coincidencias en la 
tabla de la izquierda tendrán valores NULL en las columnas de dicha tabla.*/


/* 5. Which is the most active customer (the customer that has rented the most number of films)? 
Hint: Use appropriate join between the tables "customer" and "rental" and count the rental_id 
for each customer.*/
SELECT CONCAT(c.first_name, ' ', c.last_name) AS `client`, COUNT(r.rental_id) AS number_of_rentals
FROM customer AS c
LEFT JOIN rental AS r
ON c.customer_id = r.customer_id
GROUP BY `client`
ORDER BY 2 DESC
LIMIT 1;

/*Bonus: Which is the most rented film? (The answer is Bucket Brotherhood).
This query might require using more than one join statement.
Hint: You can use join between three tables - "Film", "Inventory", and "Rental" 
and count the rental ids for each film.*/

SELECT * FROM film;  #film_id
SELECT * FROM inventory; #film_id store_id inventory_id
SELECT * FROM rental; #inventory_id

SELECT f.title, COUNT(r.rental_id) AS number_of_rentals
FROM film AS f
JOIN inventory AS i ON f.film_id = i.film_id
JOIN rental AS r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY 2 DESC
LIMIT 1;

/*ERRONEO

SELECT f.title, COUNT(r.rental_id) AS number_of_rentals
FROM film AS f
JOIN rental AS r ON i.inventory_id = r.inventory_id
JOIN inventory AS i ON f.film_id = i.film_id
GROUP BY f.title
ORDER BY 2 DESC
LIMIT 1;

Cuando se usan mútiples cláusulas JOIN, se debe cuidar el orden en que se unen las tablas. Ya que la
clásula JOIN toma dos tablas y crea una nueva tabla temporal que conbiba las filas de ambas tablas 
basándose en la condición de unión especificada. Luego, la siguiente cláusula JOIN se une a esta tabla
temporal, y así sucecivamente. 

Es importante tener en cuenta que la secuencia en que las tablas se unen afecta el resultado final de la
consulta. En general, la tabla que se une primero actúa como la tabla principal, y las tablas posteriores
se unen a ella.

Ejemplo: 
Si se busca información sobre clientes que han realizado pedidos y sus detalles de pedido, primero se debe 
unir la tabla de pedidos con la tabla de clientes, ya que la tabla de pedidos contiene la foreign key que 
se relaciona con la tabla de clientes. Si se hace lo contrario, es decir, unir primero la tabla de clientes 
con la tabla de pedidos, es posible que se pierdan algunos detalles de los pedidos, ya que la tabla de 
clientes no contiene información detallada de los pedidos.*/


