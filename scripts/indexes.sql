-- 1️.  Accès rapide aux clients depuis les commandes
CREATE INDEX idx_orders_customer_id
    ON orders(customer_id);

-- 2️.  Jointure entre order_items et products
CREATE INDEX idx_order_items_product_id
    ON order_items(product_id);

-- 3️.  Jointure entre order_items et sellers
CREATE INDEX idx_order_items_seller_id
    ON order_items(seller_id);

-- 4️.  Recherche rapide des paiements d’une commande
CREATE INDEX idx_order_payments_order_id
    ON order_payments(order_id);

-- 5️.  Filtrage fréquent sur le statut de la commande
CREATE INDEX idx_orders_status
    ON orders(order_status);

-- 6️.  Tri fréquent sur la date d’achat
CREATE INDEX idx_orders_purchase_ts
    ON orders(order_purchase_timestamp);

-- 7️.  Recherche de produits par catégorie (anglais ou portugais)
CREATE INDEX idx_products_category_pt
    ON products(product_category_name);
CREATE INDEX idx_products_category_en
    ON products(product_category_name_en);

-- 8. Filtrage par client et date d'achat
CREATE INDEX idx_orders_cust_date
    ON orders(customer_id, order_purchase_timestamp DESC);