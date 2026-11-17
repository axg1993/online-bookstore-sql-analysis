-- Reproducible checks; on the supplied CSV files each count should equal 500.
SELECT 'books' AS table_name, COUNT(*) AS row_count FROM books
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'orders', COUNT(*) FROM orders;

-- Referential integrity is also enforced by foreign keys.
SELECT COUNT(*) AS orders_without_book
FROM orders o LEFT JOIN books b ON o.book_id = b.book_id
WHERE b.book_id IS NULL;
SELECT COUNT(*) AS orders_without_customer
FROM orders o LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Verify recorded transaction totals agree with unit price times quantity.
SELECT COUNT(*) AS price_mismatches
FROM orders o JOIN books b ON o.book_id = b.book_id
WHERE ABS(o.total_amount - b.price * o.quantity) > 0.01;

-- Inventory caveat: negative hypothetical balances do not necessarily mean bad data.
WITH stock_estimate AS (
  SELECT b.book_id, b.stock - COALESCE(SUM(o.quantity), 0) AS balance
  FROM books b LEFT JOIN orders o ON b.book_id = o.book_id
  GROUP BY b.book_id, b.stock
)
SELECT COUNT(*) AS negative_hypothetical_balances
FROM stock_estimate WHERE balance < 0;
