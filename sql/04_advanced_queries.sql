-- Project assignment: 9 advanced questions

-- Q1. Total books sold by genre (quantity, not number of orders).
SELECT b.genre, SUM(o.quantity) AS books_sold
FROM orders AS o
JOIN books AS b ON o.book_id = b.book_id
GROUP BY b.genre
ORDER BY books_sold DESC, b.genre;

-- Q2. Average price of Fantasy books.
SELECT ROUND(AVG(price), 2) AS average_fantasy_price
FROM books WHERE genre = 'Fantasy';

-- Q3. Customers with at least two orders.
SELECT c.customer_id, c.name, COUNT(o.order_id) AS orders_placed
FROM customers AS c
JOIN orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) >= 2
ORDER BY orders_placed DESC, c.customer_id;

-- Q4. Most frequently ordered book (by order frequency, not units sold).
SELECT b.book_id, b.title, COUNT(o.order_id) AS times_ordered
FROM books AS b
JOIN orders AS o ON b.book_id = o.book_id
GROUP BY b.book_id, b.title
ORDER BY times_ordered DESC, b.book_id
LIMIT 1;

-- Q5. Three most expensive Fantasy books.
SELECT book_id, title, genre, price
FROM books WHERE genre = 'Fantasy'
ORDER BY price DESC, book_id
LIMIT 3;

-- Q6. Quantity sold by author.
SELECT b.author, SUM(o.quantity) AS total_quantity_sold
FROM books AS b
JOIN orders AS o ON b.book_id = o.book_id
GROUP BY b.author
ORDER BY total_quantity_sold DESC, b.author;

-- Q7. Cities of customers who made an individual order above $30.
SELECT DISTINCT c.city
FROM customers AS c
JOIN orders AS o ON c.customer_id = o.customer_id
WHERE o.total_amount > 30
ORDER BY c.city;

-- Q8. Highest-spending customer (aggregate by customer ID to avoid name collisions).
SELECT c.customer_id, c.name, SUM(o.total_amount) AS total_spent
FROM customers AS c
JOIN orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC, c.customer_id
LIMIT 1;

-- Q9. Hypothetical stock remaining if stock represents inventory before these orders.
-- WARNING: The provided data have 30 books with negative computed balances,
-- so the initial-inventory interpretation is NOT validated.
SELECT b.book_id, b.title, b.stock AS supplied_stock,
       COALESCE(SUM(o.quantity), 0) AS ordered_quantity,
       b.stock - COALESCE(SUM(o.quantity), 0) AS hypothetical_remaining_stock
FROM books AS b
LEFT JOIN orders AS o ON b.book_id = o.book_id
GROUP BY b.book_id, b.title, b.stock
ORDER BY b.book_id;
