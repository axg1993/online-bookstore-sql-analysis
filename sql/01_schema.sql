-- Online Bookstore | PostgreSQL schema
-- Run against a dedicated database. This script resets the three project tables.
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS books;

CREATE TABLE books (
    book_id        INTEGER PRIMARY KEY,
    title          VARCHAR(100),
    author         VARCHAR(50),
    genre          VARCHAR(50),
    published_year INTEGER,
    price          NUMERIC(10, 2),
    stock          INTEGER
);

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    name        VARCHAR(50),
    email       VARCHAR(100),
    phone       VARCHAR(20),
    city        VARCHAR(50),
    country     VARCHAR(100)
);

CREATE TABLE orders (
    order_id     INTEGER PRIMARY KEY,
    customer_id  INTEGER REFERENCES customers(customer_id),
    book_id      INTEGER REFERENCES books(book_id),
    order_date   DATE,
    quantity     INTEGER,
    total_amount NUMERIC(10, 2)
);

CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_book_id ON orders(book_id);
CREATE INDEX idx_orders_order_date ON orders(order_date);
