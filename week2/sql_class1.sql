-- Selecting everything from the customer table
SELECT *
FROM customer;

-- Using a where clause to filter rows based on a value
SELECT *
FROM customer
WHERE first_name = 'TERRY';

SELECT *
FROM customer
WHERE customer_id < 254;

SELECT *
FROM customer
WHERE customer_id < 254 and first_name = 'TERRY';

SELECT *
FROM customer
WHERE first_name LIKE 'MAR%';

SELECT *
FROM customer
WHERE first_name LIKE 'MAR%' and customer_id < 100;

-- Selecting a subset of columns from the customer table
SELECT customer.customer_id, customer.first_name, customer.last_name
FROM customer;

-- What if we want to concatenate the first_name and the last_name into a single full name field
SELECT customer.customer_id, CONCAT(customer.first_name, ' ' ,customer.last_name)
FROM customer;

-- Selecting everything from the payments table
SELECT *
FROM payment;

-- Joining the customer (left table) and the payment (right table) based on the customer_id
SELECT * 
FROM customer
LEFT JOIN payment
ON customer.customer_id = payment.customer_id;

-- Grouping the payments by customer to discover how many times each customer rented a film
SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(payment.amount)
FROM customer
LEFT JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.customer_id;

/* 
Grouping the payments by customer to discover how many times each customer rented a film
ordered by the number of rents
*/
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name, COUNT(payment.amount)
FROM customer
LEFT JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY COUNT(payment.amount);

/* 
Grouping the payments by customer to discover how many times each customer rented a film
ordered by the number of rents in descending order
*/
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name, COUNT(payment.amount)
FROM customer
LEFT JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY COUNT(payment.amount) DESC;

-- Grouping the payments by customer to discover how much money each customer spent
SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(payment.amount)
FROM customer
LEFT JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.customer_id;

/* 
Grouping the payments by customer to discover how much money each customer spent
on average in each time they rented something
*/
SELECT customer.customer_id, customer.first_name, customer.last_name, ROUND(AVG(payment.amount), 2)
FROM customer
LEFT JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.customer_id;

-- Retrieving all those informations in the same query
SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(payment.amount), SUM(payment.amount), ROUND(AVG(payment.amount), 2)
FROM customer
LEFT JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.customer_id;

-- Retrieving all those informations in the same query but ordering them by how much they've spent
SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(payment.amount), SUM(payment.amount), ROUND(AVG(payment.amount), 2)
FROM customer
LEFT JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY SUM(payment.amount) DESC;

-- Retrieving three tables together
SELECT *
FROM film
LEFT JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id;

-- Let's try to select how many times each movie title has been rented?
SELECT film.title, COUNT(*)
FROM film
LEFT JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.film_id
ORDER BY COUNT(*) DESC;