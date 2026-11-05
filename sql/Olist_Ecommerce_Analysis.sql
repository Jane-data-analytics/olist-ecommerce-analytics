
-- BRAZILIAN E-COMMERCE DATA ANALYSIS PROJECT

CREATE DATABASE IF NOT EXISTS ecommerce_analysis;
USE ecommerce_analysis;

-- 01. TABLE STRUCTURE

DESCRIBE olist_orders;

-- 02. NULL VALUE CHECK

-- Customers
SELECT COUNT(*) AS total_rows,
       SUM(customer_id IS NULL) AS customer_id_null,
       SUM(customer_unique_id IS NULL) AS unique_id_null,
       SUM(customer_zip_code_prefix IS NULL) AS zip_null,
       SUM(customer_city IS NULL) AS city_null,
       SUM(customer_state IS NULL) AS state_null
FROM olist_customers;

-- Geolocation
SELECT COUNT(*) AS total_rows,
       SUM(geolocation_zip_code_prefix IS NULL) AS zip_null,
       SUM(geolocation_lat IS NULL) AS lat_null,
       SUM(geolocation_lng IS NULL) AS lng_null,
       SUM(geolocation_city IS NULL) AS city_null,
       SUM(geolocation_state IS NULL) AS state_null
FROM olist_geolocation;

-- Order Items
SELECT COUNT(*) AS total_rows,
       SUM(order_id IS NULL) AS order_id_null,
       SUM(order_item_id IS NULL) AS item_id_null,
       SUM(product_id IS NULL) AS product_id_null,
       SUM(seller_id IS NULL) AS seller_id_null,
       SUM(shipping_limit_date IS NULL) AS date_null,
       SUM(price IS NULL) AS price_null,
       SUM(freight_value IS NULL) AS freight_null
FROM olist_order_items;

-- Order Payments
SELECT COUNT(*) AS total_rows,
       SUM(order_id IS NULL) AS order_id_null,
       SUM(payment_sequential IS NULL) AS sequence_null,
       SUM(payment_type IS NULL) AS type_null,
       SUM(payment_installments IS NULL) AS installments_null,
       SUM(payment_value IS NULL) AS value_null
FROM olist_order_payments;

-- Order Reviews
SELECT COUNT(*) AS total_rows,
       SUM(review_id IS NULL) AS review_id_null,
       SUM(order_id IS NULL) AS order_id_null,
       SUM(review_score IS NULL) AS score_null,
       SUM(review_comment_title IS NULL) AS title_null,
       SUM(review_comment_message IS NULL) AS message_null,
       SUM(review_creation_date IS NULL) AS date_null,
       SUM(review_answer_timestamp IS NULL) AS timestamp_null
FROM olist_order_reviews;

-- Orders
SELECT COUNT(*) AS total_rows,
       SUM(order_id IS NULL) AS order_id_null,
       SUM(customer_id IS NULL) AS customer_id_null,
       SUM(order_status IS NULL) AS status_null,
       SUM(order_purchase_timestamp IS NULL) AS purchase_null,
       SUM(order_approved_at IS NULL) AS approved_null,
       SUM(order_delivered_carrier_date IS NULL) AS carrier_date_null,
       SUM(order_delivered_customer_date IS NULL) AS customer_date_null,
       SUM(order_estimated_delivery_date IS NULL) AS estimated_date_null
FROM olist_orders;

-- Products
SELECT COUNT(*) AS total_rows,
       SUM(product_id IS NULL) AS product_id_null,
       SUM(product_category_name IS NULL) AS category_null,
       SUM(product_name_lenght IS NULL) AS name_length_null,
       SUM(product_description_lenght IS NULL) AS description_length_null,
       SUM(product_photos_qty IS NULL) AS photos_null,
       SUM(product_weight_g IS NULL) AS weight_null,
       SUM(product_length_cm IS NULL) AS length_null,
       SUM(product_height_cm IS NULL) AS height_null,
       SUM(product_width_cm IS NULL) AS width_null
FROM olist_products;

-- Sellers
SELECT COUNT(*) AS total_rows,
       SUM(seller_id IS NULL) AS seller_id_null,
       SUM(seller_zip_code_prefix IS NULL) AS zip_null,
       SUM(seller_city IS NULL) AS city_null,
       SUM(seller_state IS NULL) AS state_null
FROM olist_sellers;

-- Product Category Translation
SELECT COUNT(*) AS total_rows,
       SUM(product_category_name IS NULL) AS category_null,
       SUM(product_category_name_english IS NULL) AS english_name_null
FROM product_category_translation;


-- 03. DUPLICATE VALUE CHECK

-- Customers
SELECT customer_id, COUNT(*) AS duplicate_count
FROM olist_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Geolocation 
SELECT geolocation_zip_code_prefix,
       geolocation_lat,
       geolocation_lng,
       geolocation_city,
       geolocation_state,
       COUNT(*) AS duplicate_count
FROM olist_geolocation
GROUP BY geolocation_zip_code_prefix,
         geolocation_lat,
         geolocation_lng,
         geolocation_city,
         geolocation_state
HAVING COUNT(*) > 1;

-- Order Items
SELECT order_id, order_item_id,
       COUNT(*) AS duplicate_count
FROM olist_order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

-- Order Payments
SELECT order_id, payment_sequential,
       COUNT(*) AS duplicate_count
FROM olist_order_payments
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;

-- Orders
SELECT order_id, COUNT(*) AS duplicate_count
FROM olist_orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Products
SELECT product_id, COUNT(*) AS duplicate_count
FROM olist_products
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Sellers
SELECT seller_id, COUNT(*) AS duplicate_count
FROM olist_sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;

-- Product Category Translation
SELECT product_category_name,
       COUNT(*) AS duplicate_count
FROM product_category_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1;


-- 04. GELOCATION DATA CLEANING


CREATE TABLE olist_geolocation_clean AS
SELECT DISTINCT *
FROM olist_geolocation;

-- Compare original and clean row counts
SELECT 'Original' AS table_name,
       COUNT(*) AS total_rows
FROM olist_geolocation

UNION ALL

SELECT 'Clean' AS table_name,
       COUNT(*) AS total_rows
FROM olist_geolocation_clean;


-- 06. DATE FORMAT VALIDATION

SELECT order_purchase_timestamp,
       order_approved_at,
       order_delivered_carrier_date,
       order_delivered_customer_date,
       order_estimated_delivery_date
FROM olist_orders
LIMIT 5;

-- 07. BUSINESS KPI ANALYSIS

-- Total Orders
SELECT COUNT(*) AS total_orders
FROM olist_orders;

-- Total Customers
SELECT COUNT(*) AS total_customers
FROM olist_customers;

-- Total Sellers
SELECT COUNT(*) AS total_sellers
FROM olist_sellers;

-- Total Products
SELECT COUNT(*) AS total_products
FROM olist_products;

-- Total Revenue (Payment Value)
SELECT ROUND(SUM(payment_value), 2) AS total_revenue
FROM olist_order_payments;

-- Average Order Value
SELECT ROUND(
    SUM(payment_value) / COUNT(DISTINCT order_id), 2
) AS average_order_value
FROM olist_order_payments;

-- Total Order Items
SELECT COUNT(*) AS total_order_items
FROM olist_order_items;

-- Average Review Score
SELECT ROUND(AVG(review_score), 2) AS average_review_score
FROM olist_order_reviews;

-- 08. PAYMENT ANALYSIS

SELECT payment_type,
       COUNT(*) AS total_transactions
FROM olist_order_payments
GROUP BY payment_type
ORDER BY total_transactions DESC;

-- 09. ORDER STATUS ANALYSIS

SELECT order_status,
       COUNT(*) AS total_orders
FROM olist_orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- 10. TOP 10 PRODUCT CATEGORIES

SELECT t.product_category_name_english AS category,
       COUNT(*) AS total_items
FROM olist_order_items oi
JOIN olist_products p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english
ORDER BY total_items DESC
LIMIT 10;


-- 11. MONTHLY ORDER TREND

SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
       COUNT(*) AS total_orders
FROM olist_orders
GROUP BY month
ORDER BY month;

-- 12. TOP 10 STATES BY ORDERS

SELECT c.customer_state,
       COUNT(o.order_id) AS total_orders
FROM olist_orders o
JOIN olist_customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC
LIMIT 10;

-- 13. MONTHLY REVENUE ANALYSIS

SELECT DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
       ROUND(SUM(p.payment_value), 2) AS monthly_revenue
FROM olist_orders o
JOIN olist_order_payments p
    ON o.order_id = p.order_id
GROUP BY month
ORDER BY month;

-- 14. TOP 10 SELLERS BY REVENUE

SELECT oi.seller_id,
       ROUND(SUM(oi.price), 2) AS total_revenue
FROM olist_order_items oi
GROUP BY oi.seller_id
ORDER BY total_revenue DESC
LIMIT 10;

-- 15. AVERAGE DELIVERY TIME

SELECT ROUND(
    AVG(TIMESTAMPDIFF(
        DAY,
        order_purchase_timestamp,
        order_delivered_customer_date
    )), 2
) AS average_delivery_days
FROM olist_orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;


-- 16. TOP 10 PRODUCTS BY REVENUE

SELECT p.product_id,
       t.product_category_name_english AS category,
       ROUND(SUM(oi.price), 2) AS total_revenue
FROM olist_order_items oi
JOIN olist_products p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY p.product_id,
         t.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 10;
