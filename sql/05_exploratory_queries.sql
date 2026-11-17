-- Additional analyses preserved from the author's original Project.sql.

-- All November orders, across all years.
SELECT * FROM orders WHERE EXTRACT(MONTH FROM order_date) = 11;

-- Second book in descending price order (including tie behavior).
SELECT * FROM books ORDER BY price DESC, book_id OFFSET 1 LIMIT 1;

-- Median book price.
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) AS median_price
FROM books;

-- The seven most frequently ordered books.
SELECT b.book_id, b.title, COUNT(o.order_id) AS times_ordered
FROM books AS b JOIN orders AS o ON b.book_id = o.book_id
GROUP BY b.book_id, b.title
ORDER BY times_ordered DESC, b.book_id
LIMIT 7;

-- Orders with more than $30 per transaction, including the customer's city.
SELECT DISTINCT c.city, o.total_amount
FROM orders AS o JOIN customers AS c ON o.customer_id = c.customer_id
WHERE o.total_amount > 30
ORDER BY c.city, o.total_amount;
