-- Using csv datasets data/Sakila.zip
-- Documentation on Sakila can be found here: https://dev.mysql.com/doc/sakila/en/
-- All of the questions will involve querying only one table except for the last question (16.) which does involve joining.
-- You can use SQL, MySQL, SAS's proc sql, postgreSQL, or pseudo code to answer all of the following questions.
-- Please return your answers only (no results) as a .sql or .txt file (and include any comments to explain your reasoning) within
--  -- 24 hours of receipt.


-- 1. List all movies that are either PG OR PG-13 using IN operator
Select *
From film
Where title IN (Select title
From film
Where rating = 'PG' OR 'PG-13');


-- 2. List all staff members (first name, last name, email) with missing passwords
Select first_name, last_name, email
From staff
Where password IS NULL;

-- 3. Select all films that have title names that contain the word ZOO and rental duration greater than or equal to 4
Select *
From film
Where title LIKE '%Zoo%' OR rental_duration >= 4;

-- 4. List customers and payment amounts, with payments greater than the total (global) average payment amount
Select payment.amount, customer.first_name, customer.last_name
From customer
INNER JOIN payment ON payment.customer_id = customer.customer_id
Where payment.amount > AVG(payment.amount);

-- 5. List customers who have rented movies at least once using the IN operator
Select customer.*
From customer
INNER JOIN payment ON payment.customer_id = customer.customer_id
Where customer_id IN (Select customer_id
From customer
Where rental_id IS NOT NULL;

-- 6. List the top 10 newest customers across all stores
Select *
From customer
Where difference = DATEDIFF(day,SUBSTRING(create_date, 1, 10), GETDATE())
ORDER BY difference ASC LIMIT 10;

-- 7. Find the top 2 movies with movie length strictly greater than (>) 50mins,
-- which has commentaries as a special features, and with the highest replacement cost
Select *
From film
Where length>50 and special_features LIKE '%Commentaries%'
ORDER BY replacement_cost DESC LIMIT 2;

-- 8. What are the minimum amount, maximum amount, and average payment received across all transactions?
Select MIN(amount), MAX(amount), AVG(amount)
From payment;

-- 9. What is the total amount spent by customers for movies in the year 2005?
Select SUM(amount)
From payment
Where SUBSTRING(payment_date, 1,4) = 2005;

-- 10. Extract the street number ( characters 1 through 4 ) from customer addressLine1
Select SUBSTRING(address, 1,4)
From address
INNER JOIN customer ON address.address_id = customer.address_id;

-- 11. Find out actors whose last name starts with character A, B or C.
Select *
From actor
Where LEFT(last_name, 1) = 'A' or LEFT(last_name, 1) = 'B' or LEFT(last_name, 1) = 'C' ;

-- 12. Format a payment_date using the following format e.g "22/1/2016"
Select CONVERT(varchar, payment_date, 1)
From payment;

-- 13. Find the number of days between two date values rental_date & return_date
Select DATEDIFF(days,rental_date, return_date)
From rental;

-- 14. Count of movies that are either G/NC-17/PG-13/PG/R grouped by rating.
Select count(film_id)
From film
GROUP BY rating;

-- 15. How many films involve a “Crocodile” and a “Shark” based on film description?
-- NOTE: Use a CASE WHEN statement to set up two new fields and count them.
Select film_id
CASE
	WHEN description LIKE '%Crocodile%' THEN count(film_id)
	WHEN description LIKE '%Shark%' THEN count(film_id)
	ELSE "This movie has no Crocodiles or Sharks"
From film;

-- 16. List the actors (firstName, lastName) who acted in strictly more than (>) 25 movies.
-- NOTE: Also show the count of movies against each actor
Select actor.first_name, actor.last_name, count(film_id)
From actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id;
Where COUNT(UNIQUE film_actor.actor_id) > 25

-- 17.a. Merge together the customer table and the address table, including any other supplementary lookup tables.
-- 		 Then recast all fields with dates as DateTime
-- 17.b. Are there any customers whose last_update field differs from the address last_update?
A.
Select cast(create_date as DATETIME) AS create_date_time,cast(last_update as DATETIME) AS lase_update_time
From address

Select *
From address
INNER JOIN customer ON address.address_id = customer.address_id AND cast(create_date as DATETIME) AND cast(last_update as DATETIME);
