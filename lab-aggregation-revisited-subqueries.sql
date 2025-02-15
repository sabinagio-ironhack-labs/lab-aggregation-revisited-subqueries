USE sakila;

-- Select the first name, last name, and email address of all the customers who have rented a movie.
SELECT 
    first_name, last_name, email
FROM
    customer
		RIGHT JOIN
    rental USING (customer_id)
GROUP BY first_name , last_name , email;

-- What is the average payment made by each customer (display the customer id, customer name (concatenated), 
-- and the average payment made).
SELECT 
    customer_id,
    CONCAT(first_name, ' ', last_name) AS customer_name,
    ROUND(AVG(amount), 2) AS average_payment
FROM
    customer
        JOIN
    payment USING (customer_id)
GROUP BY customer_id;


-- Select the name and email address of all the customers who have rented the "Action" movies.

-- Write the query using multiple join statements
SELECT 
    CONCAT(first_name, ' ', last_name) AS customer_name, email
FROM
    customer
        JOIN
    rental USING (customer_id)
        JOIN
    inventory USING (inventory_id)
        JOIN
    film_category USING (film_id)
        JOIN
    category USING (category_id)
WHERE
    category.name = 'Action'
GROUP BY customer_id
ORDER BY customer_name ASC;

-- Write the query using sub queries with multiple WHERE clause and IN condition
SELECT 
    CONCAT(first_name, ' ', last_name) AS customer_name, email
FROM
    customer
WHERE
    customer_id IN (SELECT 
						customer_id
					FROM
						rental
					WHERE
						inventory_id IN (SELECT 
											inventory_id
										 FROM
											inventory
										 WHERE
											film_id IN (SELECT 
															film_id
														FROM
															film_category
														WHERE
															category_id IN (SELECT 
																				category_id
																			FROM
																				category
																			WHERE
																				category.name = 'Action'))))
ORDER BY customer_name ASC;
                                    
SELECT 
    *
FROM
    film_category
WHERE
    category_id IN (SELECT 
            category_id
        FROM
            category
        WHERE
            name = 'Action');

-- Verify if the above two queries produce the same results or not
-- Yes, the queries produce the same results.

-- Use the case statement to create a new column classifying existing columns as 
-- either or high value transactions based on the amount of payment. 
-- If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, 
-- the label should be medium, and if it is more than 4, then it should be high.

SELECT 
    payment_id,
    amount,
    (CASE
        WHEN amount >= 0 AND amount <= 2 THEN 'Low'
        WHEN amount > 2 AND amount <= 4 THEN 'Medium'
        WHEN amount > 4 THEN 'High'
    END) AS transaction_value
FROM
    payment;

