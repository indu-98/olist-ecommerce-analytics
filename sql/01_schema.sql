CREATE TABLE customers (
    customer_id VARCHAR PRIMARY KEY,
    customer_unique_id VARCHAR,
    customer_zip_code_prefix VARCHAR,
    customer_city VARCHAR,
    customer_state VARCHAR
);

CREATE TABLE sellers (
    seller_id VARCHAR PRIMARY KEY,
    seller_zip_code_prefix VARCHAR,
    seller_city VARCHAR,
    seller_state VARCHAR
);

CREATE TABLE category_translation (
    product_category_name VARCHAR PRIMARY KEY,
    product_category_name_english VARCHAR
);

CREATE TABLE products (
    product_id VARCHAR PRIMARY KEY,
    product_category_name VARCHAR,
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g NUMERIC,
    product_length_cm NUMERIC,
    product_height_cm NUMERIC,
    product_width_cm NUMERIC
);

CREATE TABLE orders (
    order_id VARCHAR PRIMARY KEY,
    customer_id VARCHAR REFERENCES customers(customer_id),
    order_status VARCHAR,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE order_items (
    order_id VARCHAR REFERENCES orders(order_id),
    order_item_id INT,
    product_id VARCHAR,
    seller_id VARCHAR,
    shipping_limit_date TIMESTAMP,
    price NUMERIC,
    freight_value NUMERIC
);

CREATE TABLE payments (
    order_id VARCHAR REFERENCES orders(order_id),OLIST_ECOMMERCE.PUBLIC.CUSTOMERSOLIST_ECOMMERCE.PUBLIC.CUSTOMERSOLIST_ECOMMERCE.PUBLIC.CUSTOMERSOLIST_ECOMMERCE.PUBLIC.CUSTOMERSOLIST_ECOMMERCE.PUBLIC.SELLERSCUSTOMER_ID, CUSTOMER_UNIQUE_ID, CUSTOMER_ZIP_CODE_PREFIX, CUSTOMER_CITY, CUSTOMER_STATE
    payment_sequential INT,
    payment_type VARCHAR,
    payment_installments INT,
    payment_value NUMERIC
);
