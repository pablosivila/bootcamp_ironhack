-- Challenge 3: Which movie category has been rented the most?
-- CATEGORY -> RENTAL
-- 1. testar uma tabela inicial
SELECT category.name, film_category.film_id
FROM category
JOIN film_category
ON category.category_id=film_category.category_id
GROUP BY category.name,film_category.film_id

-- Funcionou? Coloque-a dentro de outra:
--Nessa etapa, além da categoria do filme,
--só é necessário o film_id, que será utilizado depois no inventory

SELECT film.film_id AS film, category
FROM (
	SELECT category.name AS category, film_category.film_id
	FROM category
	JOIN film_category
	ON category.category_id=film_category.category_id
) AS category_info
JOIN film
ON category_info.film_id=film.film_id
GROUP BY film, category

--Precisa-se do film_id para juntar com a tabela inventory, e do inventory_id 
--para juntar com a tabela rental:

SELECT inventory.inventory_id AS inventory, film, category
FROM(
	SELECT film.film_id AS film, category
	FROM (
		SELECT category.name AS category, film_category.film_id
		FROM category
		JOIN film_category
		ON category.category_id=film_category.category_id
	) AS category_info
	JOIN film
	ON category_info.film_id=film.film_id
) AS film_info
JOIN inventory
ON film=inventory.film_id
GROUP BY inventory, film, category

--Agora, com a tabela rental:
SELECT category, COUNT (*)
FROM(
	SELECT inventory.inventory_id AS inventory, film, category
	FROM(
		SELECT film.film_id AS film, category
		FROM (
			SELECT category.name AS category, film_category.film_id
			FROM category
			JOIN film_category
			ON category.category_id=film_category.category_id
		) AS category_info
		JOIN film
		ON category_info.film_id=film.film_id
	) AS film_info
	JOIN inventory
	ON film=inventory.film_id
) AS inventory_info
JOIN rental
ON inventory=rental.inventory_id
GROUP BY category
ORDER BY COUNT(*) DESC

--Por temp tables:
--1. Pegar a tabela do meio
--2. Testar
--3. Deu certo? Dê um nome
SELECT category.name AS category, film_category.film_id
FROM category
JOIN film_category
ON category.category_id=film_category.category_id;

SELECT category.name AS category, film_category.film_id
INTO TEMP TABLE category_info
FROM category
JOIN film_category
ON category.category_id=film_category.category_id;

SELECT *
FROM category_info

SELECT film.film_id AS film, category
INTO TEMP TABLE film_info
FROM category_info
JOIN film
ON category_info.film_id=film.film_id;

SELECT inventory.inventory_id AS inventory, film, category
INTO TEMP TABLE inventory_info
FROM film_info
JOIN inventory
ON film=inventory.film_id;

SELECT category, COUNT (*)
FROM inventory_info
JOIN rental
ON inventory=rental.inventory_id
GROUP BY category
ORDER BY COUNT(*) DESC;

DROP TABLE IF EXISTS category_info;
DROP TABLE IF EXISTS film_info;
DROP TABLE IF EXISTS inventory_info;