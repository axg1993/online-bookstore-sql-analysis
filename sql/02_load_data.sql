-- Use with psql from the repository root:
-- psql -v ON_ERROR_STOP=1 -d bookstore_db -f sql/02_load_data.sql
-- \copy reads CSV files from your own computer (not from the server).
\copy books(book_id, title, author, genre, published_year, price, stock) FROM 'data/books.csv' WITH (FORMAT csv, HEADER true)
\copy customers(customer_id, name, email, phone, city, country) FROM 'data/customers.csv' WITH (FORMAT csv, HEADER true)
\copy orders(order_id, customer_id, book_id, order_date, quantity, total_amount) FROM 'data/orders.csv' WITH (FORMAT csv, HEADER true)
