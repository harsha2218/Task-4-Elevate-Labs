DROP TABLE IF EXISTS customers ,orders ,products,reviews ;
-- Customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    gender VARCHAR(10),
    age INT,
    city VARCHAR(100),
    loyalty_score NUMERIC
);

-- Orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    product_category VARCHAR(50),
    order_value NUMERIC,
    payment_method VARCHAR(50),
    delivered BOOLEAN,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(50),
    price NUMERIC,
    stock INT
);

-- Reviews table
CREATE TABLE reviews (
    review_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    rating INT,
    review_text TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM reviews;
--Directly imported all table's data

--a. SELECT, WHERE, ORDER BY, GROUP BY
-- Total sales by product category
SELECT product_category , SUM(order_value) AS total_sales
FROM orders
GROUP BY product_category
ORDER BY total_sales DESC;


--b. JOINS (INNER, LEFT, RIGHT)
-- Join orders with customers to get customer details for each order
SELECT o.order_id, o.order_date, o.order_value, c.city, c.gender
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date;

-- LEFT JOIN to include customers who haven't placed any orders
SELECT c.customer_id, c.city, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;


--c. Subqueries
-- Customers who spent more than the average order value
SELECT customer_id, SUM(order_value) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(order_value) > (
    SELECT AVG(order_value) FROM orders
);


--d. Aggregate Functions (SUM, AVG)
-- Average order value and total revenue
SELECT AVG(order_value) AS avg_order_value, SUM(order_value) AS total_revenue
FROM orders;


--e. Create Views
-- Create a view for monthly sales
CREATE VIEW monthly_sales AS
SELECT DATE_TRUNC('month', order_date) AS month, SUM(order_value) AS total_sales
FROM orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;


--f. Optimize Queries with Indexes
-- Create index on orders table for faster filtering
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_order_date ON orders(order_date);

-- Create index on reviews for faster product lookup
CREATE INDEX idx_reviews_product_id ON reviews(product_id);
