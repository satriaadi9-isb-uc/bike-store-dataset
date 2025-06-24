USE bike_stores_schema;

-- Get all products that have a price higher than the average product price.
SELECT product_name, list_price
FROM products
WHERE list_price > (
    SELECT AVG(list_price) FROM products
)
ORDER BY list_price DESC;

-- Show all customers who have made at least one order
SELECT customer_id, first_name, last_name
FROM customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id FROM orders
);

-- Show product IDs where the total quantity is less than 15.
SELECT product_id, SUM(quantity) AS total_quantity
FROM stocks
GROUP BY product_id
HAVING SUM(quantity) < 15;

-- Show a list of email addresses from both customers and staffs (no duplicates).
SELECT email FROM customers
UNION
SELECT email FROM staffs;

-- Show products that generated over 200,000 in revenue, along with their name, brand, and total revenue 
SELECT 
    p.product_name,
    b.brand_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN brands b ON p.brand_id = b.brand_id
GROUP BY p.product_id
HAVING total_revenue > 200000;

-- Show customers who have ever purchased a product priced above the average list price, along with their name and email
SELECT DISTINCT c.first_name, c.last_name, c.email
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.list_price > (
    SELECT AVG(list_price) FROM products
);


-- Show each store with the number of completed orders (status 4) where the total order value was over 100,000, along with store name
SELECT 
    s.store_name,
    COUNT(DISTINCT o.order_id) AS high_value_orders
FROM orders o
JOIN stores s ON o.store_id = s.store_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 4
GROUP BY s.store_id
HAVING SUM(oi.quantity * oi.list_price * (1 - oi.discount)) > 100000
ORDER BY 2 DESC;

-- Get all unique names and email addresses from customers and staffs, labeled by user type.
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    email,
    'Customer' AS user_type
FROM customers
UNION
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    email,
    'Staff' AS user_type
FROM staffs;



