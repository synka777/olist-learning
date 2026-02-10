/* --------------------------------------------------------------
   1. Tables  de lookup / références - à créer en premier
   -------------------------------------------------------------- */
-- Geoloc lookup (ZIP‑prefix → lat/lng)
CREATE TABLE geolocations (
    geolocation_zip_code_prefix TEXT PRIMARY KEY,
    geolocation_lat               REAL,
    geolocation_lng               REAL,
    geolocation_city              TEXT,
    geolocation_state             TEXT
);

-- Traduction de catégories Portugaises to English
CREATE TABLE product_category_translation (
    product_category_name          TEXT,
    product_category_name_english TEXT PRIMARY KEY
);


/* --------------------------------------------------------------
   2. Tables de dimension
   -------------------------------------------------------------- */
-- Customers
CREATE TABLE customers (
    customer_id           TEXT PRIMARY KEY,
    customer_unique_id    TEXT,
    customer_zip_code_prefix TEXT,
    customer_city         TEXT,
    customer_state        TEXT,
    FOREIGN KEY (customer_zip_code_prefix)
        REFERENCES geolocations (geolocation_zip_code_prefix)
);

-- Sellers
CREATE TABLE sellers (
    seller_id            TEXT PRIMARY KEY,
    seller_zip_code_prefix TEXT,
    seller_city          TEXT,
    seller_state         TEXT,
    FOREIGN KEY (seller_zip_code_prefix)
        REFERENCES geolocations (geolocation_zip_code_prefix)
);

-- Products
CREATE TABLE products (
    product_id                 TEXT PRIMARY KEY,
    product_category_name      TEXT,
    product_category_name_en   TEXT,
    product_name_length        INTEGER,
    product_description_length INTEGER,
    product_photos_qty         INTEGER,
    product_weight_g           INTEGER,
    product_length_cm          INTEGER,
    product_height_cm          INTEGER,
    product_width_cm           INTEGER,
    FOREIGN KEY (product_category_name)
        REFERENCES product_category_translation (product_category_name)
);


/* --------------------------------------------------------------
   3. Tables de fait/transaction
   -------------------------------------------------------------- */
-- Orders (order header)
CREATE TABLE orders (
    order_id                  TEXT PRIMARY KEY,
    customer_id              TEXT,
    order_status             TEXT,               -- you can enforce an enum via CHECK if desired
    order_purchase_timestamp TEXT,               -- stored as ISO‑8601 string
    order_approved_at        TEXT,
    order_delivered_carrier_date TEXT,
    order_delivered_customer_date TEXT,
    order_estimated_delivery_date TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

-- Order items (line items)
CREATE TABLE order_items (
    order_id       TEXT,
    order_item_id  INTEGER,
    product_id     TEXT,
    seller_id      TEXT,
    shipping_limit_date TEXT,
    price          REAL,
    freight_value  REAL,
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id)   REFERENCES orders (order_id),
    FOREIGN KEY (product_id) REFERENCES products (product_id),
    FOREIGN KEY (seller_id)  REFERENCES sellers (seller_id)
);

-- Payments (may have several installments per order)
CREATE TABLE order_payments (
    order_id            TEXT,
    payment_sequential  INTEGER,
    payment_type        TEXT,      -- e.g., 'credit_card', 'boleto', …
    payment_installments INTEGER,
    payment_value       REAL,
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES orders (order_id)
);

-- Reviews (optional – one per order in this sample)
CREATE TABLE order_reviews (
    review_id                TEXT PRIMARY KEY,
    order_id                 TEXT,
    review_score             INTEGER,   -- 1‑5
    review_comment_title     TEXT,
    review_comment_message   TEXT,
    review_creation_date     TEXT,
    review_answer_timestamp  TEXT,
    FOREIGN KEY (order_id) REFERENCES orders (order_id)
);