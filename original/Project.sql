DROP TABLE IF EXISTS Books;

-- Create Books Table
CREATE TABLE Books(
	Book_ID SERIAL PRIMARY KEY,	
	Title VARCHAR(100),  
	Author VARCHAR(50),
	Genre VARCHAR(50),
	Published_Year INT,
	Price NUMERIC(10,2),
	Stock INT
);

DROP TABLE IF EXISTS Customers;

-- Create Customers Table
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(50),
    Phone VARCHAR(20),
    City VARCHAR(50),
    Country VARCHAR(100)
);

DROP TABLE IF EXISTS Orders;

-- Create Orders Table
CREATE TABLE Orders(
	Order_ID SERIAL PRIMARY KEY, 
	Customer_ID INT REFERENCES Customers(Customer_ID), 
	Book_ID INT REFERENCES Books(Book_ID), 
	Order_Date DATE, 
	Quantity INT, 
	Total_Amount NUMERIC(10,2)
);

-- Display tables
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Import CSV data
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'D:\SQL_Resume_Project-main\Books.csv'
CSV HEADER;

COPY Customers(Customer_ID, Name, Email, Phone, City, Country)
FROM '‪D:\SQL_Resume_Project-main\Customers.csv'
CSV HEADER;

COPY Orders(Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
FROM '‪D:\SQL_Resume_Project-main\Orders.csv'
CSV HEADER;

-- Retrieve all books in "Fiction" genre

SELECT * 
FROM Books
WHERE Genre = 'Fiction';

-- Find books published after year 1950

SELECT Title, Author, Published_Year
FROM Books
WHERE Published_Year > 1950;

-- List all customers from Canada

SELECT Name, Country
FROM Customers
WHERE Country = 'Canada';

-- Show Orders placed in November 2023

SELECT *
FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- Show orders from all November months

SELECT *
FROM Orders
WHERE EXTRACT(MONTH FROM Order_Date) = 11;

-- Retrieve the total stock of books available

SELECT SUM(Stock) AS Total_Stock
FROM Books;

-- Find the details of the most expensive book

SELECT * 
FROM BOOKS 
ORDER BY Price DESC 
LIMIT 1;

-- Find the details of the second most expensive book

SELECT * 
FROM BOOKS 
ORDER BY Price DESC 
LIMIT 1
OFFSET 1;

-- Find the median price of books

SELECT
    PERCENTILE_CONT(0.5)
    WITHIN GROUP (ORDER BY Price) AS Median_Price
FROM Books;

-- Show customers who ordered more than one quantity of a book

SELECT c.Name,
		o.*
FROM Orders o
INNER JOIN Customers c
	ON o.Customer_ID = c.Customer_ID
WHERE Quantity > 1;

-- Retrieve all orders where total amount exceeds $20

SELECT * 
FROM ORDERS
WHERE Total_Amount > 20;

-- List all generes available in the book table

SELECT DISTINCT Genre FROM Books;

-- Find the book with the lowest stock

SELECT *
FROM Books
ORDER BY Stock
LIMIT 1;

-- Calculate total revenue generated from all orders

SELECT SUM(total_amount) AS Total_revenue
FROM Orders;

-- Retrieve the total number of books sold for each genre

SELECT b.Genre, SUM(o.Quantity) AS Total_books_sold 
FROM Orders o
JOIN Books b
ON o.Book_ID = b.Book_ID
GROUP BY b.Genre;


-- Find the average price of books in the fantasy genre

SELECT AVG(Price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';


-- List Customers who have placed at least two orders

SELECT c.Name, o.Customer_ID, COUNT(o.Order_ID) AS Orders_Placed
FROM Orders o
JOIN Customers c
ON c.Customer_ID = o.Customer_ID
GROUP BY o.Customer_ID, c.name
HAVING COUNT(o.Order_ID) >= 2;

-- Find the most frequently ordered book

SELECT b.Title, o.Book_ID, COUNT(o.Order_ID) AS Total_Orders 
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY o.Book_ID, b.Title
ORDER BY Total_Orders DESC LIMIT 7;

-- Show top 3 most expensive books of Fantasy genre

SELECT Title, Genre, Price 
FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC LIMIT 3;

-- Retrieve the total quantity of books sold by each author

SELECT b.Author, SUM(o.Quantity) AS Total_quantity_sold 
FROM Books b
JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Author;

-- List the cities where customers who spent over $30 are located

SELECT DISTINCT c.city, o.total_amount
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
WHERE o.total_amount > 30;

-- Find the customer who spent the most on orders

SELECT c.Name, SUM(Total_Amount) AS Total_Spent  
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Name
ORDER By Total_Spent DESC LIMIT 1;

-- Calculate the stock remaining after fulfilling all orders

SELECT b.Book_ID, b.Title, b.Stock, COALESCE(SUM(o.Quantity),0) AS Order_Quantity,
		b.Stock - COALESCE(SUM(o.Quantity),0) AS Remaining_Stock
FROM Books b
LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID;
