-- Project assignment: 11 basic questions

-- Q1. Retrieve books in the Fiction genre.
SELECT * FROM books WHERE genre = 'Fiction';

-- Q2. Find books published after 1950.
SELECT title, author, published_year FROM books WHERE published_year > 1950;

-- Q3. List customers from Canada.
SELECT name, country FROM customers WHERE country = 'Canada';

-- Q4. Show orders placed in November 2023 (safe for timestamps too).
SELECT * FROM orders
WHERE order_date >= DATE '2023-11-01' AND order_date < DATE '2023-12-01';

-- Q5. Total book stock in the supplied dataset.
SELECT SUM(stock) AS total_stock FROM books;

-- Q6. Find the most expensive book; ties are broken by ID.
SELECT * FROM books ORDER BY price DESC, book_id LIMIT 1;

-- Q7. Find customers who ordered more than one copy in an order.
SELECT c.customer_id, c.name, o.order_id, o.book_id, o.quantity
FROM orders AS o
JOIN customers AS c ON o.customer_id = c.customer_id
WHERE o.quantity > 1
ORDER BY c.customer_id, o.order_id;

-- Q8. Retrieve orders exceeding $20.
SELECT * FROM orders WHERE total_amount > 20;

-- Q9. List available genres.
SELECT DISTINCT genre FROM books ORDER BY genre;

-- Q10. Find the book with the lowest stock.
SELECT * FROM books ORDER BY stock ASC, book_id LIMIT 1;

-- Q11. Calculate total recorded order revenue.
SELECT SUM(total_amount) AS total_revenue FROM orders;
