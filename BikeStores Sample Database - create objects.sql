DROP DATABASE IF EXISTS bike_stores_schema;
CREATE DATABASE IF NOT EXISTS bike_stores_schema;
USE bike_stores_schema;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS stocks;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS brands;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS staffs;
DROP TABLE IF EXISTS stores;

-- Categories
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- Brands
CREATE TABLE brands (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- Products
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    model_year SMALLINT NOT NULL,
    list_price DECIMAL(10, 2) NOT NULL
) ENGINE=InnoDB;

-- Customers
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    phone VARCHAR(25),
    email VARCHAR(255) NOT NULL,
    street VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(25),
    zip_code VARCHAR(5)
) ENGINE=InnoDB;

-- Stores
CREATE TABLE stores (
    store_id INT AUTO_INCREMENT PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL,
    phone VARCHAR(25),
    email VARCHAR(255),
    street VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(10),
    zip_code VARCHAR(5)
) ENGINE=InnoDB;

-- Staffs
CREATE TABLE staffs (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(25),
    active TINYINT NOT NULL,
    store_id INT NOT NULL,
    manager_id INT DEFAULT NULL
) ENGINE=InnoDB;

-- Orders
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_status TINYINT NOT NULL,
    order_date DATE NOT NULL,
    required_date DATE NOT NULL,
    shipped_date DATE,
    store_id INT NOT NULL,
    staff_id INT DEFAULT NULL
) ENGINE=InnoDB;

-- Order Items
CREATE TABLE order_items (
    order_id INT,
    item_id INT,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    list_price DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(4, 2) NOT NULL DEFAULT 0,
    PRIMARY KEY (order_id, item_id)
) ENGINE=InnoDB;

-- Stocks
CREATE TABLE stocks (
    store_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (store_id, product_id)
) ENGINE=InnoDB;

-- Products
ALTER TABLE products
  ADD FOREIGN KEY (brand_id) REFERENCES brands(brand_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD FOREIGN KEY (category_id) REFERENCES categories(category_id)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Staffs
ALTER TABLE staffs
  ADD FOREIGN KEY (store_id) REFERENCES stores(store_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD FOREIGN KEY (manager_id) REFERENCES staffs(staff_id)
    ON DELETE SET NULL ON UPDATE CASCADE;

-- Orders
ALTER TABLE orders
  ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD FOREIGN KEY (store_id) REFERENCES stores(store_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD FOREIGN KEY (staff_id) REFERENCES staffs(staff_id)
    ON DELETE SET NULL ON UPDATE CASCADE;

-- Order Items
ALTER TABLE order_items
  ADD FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD FOREIGN KEY (product_id) REFERENCES products(product_id)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Stocks
ALTER TABLE stocks
  ADD FOREIGN KEY (store_id) REFERENCES stores(store_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD FOREIGN KEY (product_id) REFERENCES products(product_id)
    ON DELETE CASCADE ON UPDATE CASCADE;
