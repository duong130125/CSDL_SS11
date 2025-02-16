-- 2
CREATE VIEW view_long_action_movies AS
SELECT f.film_id, f.title, f.length, c.name AS category_name
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action' AND f.length > 100;

-- 3
CREATE VIEW view_texas_customers AS
SELECT c.customer_id, c.first_name, c.last_name, ci.city
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
WHERE ci.city = 'Texas'
GROUP BY c.customer_id, c.first_name, c.last_name, ci.city;

-- 4
CREATE VIEW view_high_value_staff AS
SELECT s.staff_id, s.first_name, s.last_name, SUM(p.amount) AS total_payment
FROM staff s
JOIN payment p ON s.staff_id = p.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name
HAVING total_payment > 100;

-- 5
CREATE FULLTEXT INDEX idx_film_title_description
ON film(title, description);

-- 6
CREATE INDEX idx_rental_inventory_id
ON rental(inventory_id) USING HASH;

-- 7
SELECT *
FROM view_long_action_movies
WHERE MATCH(title, description) AGAINST ('War' IN NATURAL LANGUAGE MODE);

-- 8
DELIMITER //
CREATE PROCEDURE GetRentalByInventory(IN inventory_id INT)
BEGIN
    SELECT * FROM rental
    WHERE inventory_id = inventory_id;
END;
// DELIMITER ;

-- 9
DROP VIEW IF EXISTS view_long_action_movies;
DROP VIEW IF EXISTS view_texas_customers;
DROP VIEW IF EXISTS view_high_value_staff;
DROP INDEX idx_film_title_description ON film;
DROP INDEX idx_rental_inventory_id ON rental;
DROP PROCEDURE IF EXISTS GetRentalByInventory;