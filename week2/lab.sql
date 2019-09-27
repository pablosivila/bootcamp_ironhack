-- Challenge 1
--1

SELECT customer.first_name, customer.last_name, COUNT(*)
FROM rental
LEFT JOIN customer
ON rental.customer_id=customer.customer_id
GROUP BY customer.first_name, customer.last_name
ORDER BY COUNT(*) DESC
LIMIT 5;

--2
SELECT customer.customer_id,customer.first_name, customer.last_name, SUM(payment.amount)
FROM payment
JOIN customer
ON payment.customer_id=customer.customer_id
GROUP BY customer.customer_id
ORDER BY SUM(payment.amount) DESC;

--3
SELECT customer.customer_id,customer.first_name, customer.last_name, ROUND(AVG(payment.amount),2)
FROM customer
JOIN payment
ON payment.customer_id=customer.customer_id
GROUP BY customer.customer_id
ORDER BY ROUND(AVG(payment.amount),2) DESC;

--4
SELECT customer.first_name, customer.last_name, COUNT(*), SUM(payment.amount), ROUND(AVG(payment.amount),2)
FROM customer
JOIN payment
ON payment.customer_id=customer.customer_id
GROUP BY customer.customer_id
ORDER BY COUNT(*) DESC;

-- Challenge 2
SELECT film.title, COUNT(*)
FROM film
LEFT JOIN inventory
ON film.film_id=inventory.film_id
LEFT JOIN rental
ON inventory.inventory_id=rental.inventory_id
GROUP BY film.title
ORDER BY COUNT(*) DESC
LIMIT 5;

-- Challenge 3
SELECT category.name, COUNT(*)
FROM category
LEFT JOIN film_category
ON category.category_id=film_category.category_id
LEFT JOIN film
ON film_category.film_id=film.film_id
LEFT JOIN inventory
ON film.film_id=inventory.film_id
LEFT JOIN rental
ON inventory.inventory_id=rental.inventory_id
GROUP BY category.name
ORDER BY COUNT(*) DESC

-- Challenge 4
SELECT category.name, customer.first_name, customer.last_name, COUNT(*)
FROM category
LEFT JOIN film_category
ON category.category_id=film_category.category_id
LEFT JOIN film
ON film_category.film_id=film.film_id
LEFT JOIN inventory
ON film.film_id=inventory.film_id
LEFT JOIN rental
ON inventory.inventory_id=rental.inventory_id
LEFT JOIN customer
ON rental.customer_id=customer.customer_id
WHERE first_name='ELEANOR' and last_name='HUNT'
GROUP BY category.name, customer.customer_id
ORDER BY COUNT(*) DESC;

--Para os demais, trocar o nome e sobrenome na linha WHERE 