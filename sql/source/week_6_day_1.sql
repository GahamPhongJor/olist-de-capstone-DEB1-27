-- Tasks in Week 6, Day 1

CALL staging.run_etl()

SELECT 'customers'   AS tbl, (SELECT COUNT(*) FROM raw.customers)    AS raw_rows, (SELECT COUNT(*) FROM staging.customers)   AS staging_rows
UNION ALL SELECT 'sellers',     (SELECT COUNT(*) FROM raw.sellers),       (SELECT COUNT(*) FROM staging.sellers)
UNION ALL SELECT 'products',    (SELECT COUNT(*) FROM raw.products),      (SELECT COUNT(*) FROM staging.products)
UNION ALL SELECT 'orders',      (SELECT COUNT(*) FROM raw.orders),        (SELECT COUNT(*) FROM staging.orders)
UNION ALL SELECT 'order_items', (SELECT COUNT(*) FROM raw.order_items),   (SELECT COUNT(*) FROM staging.order_items)
UNION ALL SELECT 'reviewsss',     (SELECT COUNT(*) FROM raw.order_reviews), (SELECT COUNT(*) FROM staging.reviews);


-- Run 1: initial load (everything is new)
CALL staging.load_sellers();
CALL staging.load_sellers_scd2();

-- Update the data in raw data
UPDATE raw.sellers SET seller_city = 'RRR', seller_state = 'RJ'
WHERE seller_id = (SELECT seller_id FROM raw.sellers LIMIT 1);
-- check update in raw data
select * from raw.sellers --3442f8959a84dea7ee197c632cb2df15

-- ETL to staging full load
CALL staging.load_sellers();
-- check update in staging data
select * from staging.sellers

-- ETL to staging_scd2 with SCD
CALL staging.load_sellers_scd2();
-- check update in staging_scd2 data
select * from staging.sellers_scd2


-- Upsert On Conflict
select count(*) from staging.orders --99438

-- Run 2: simulate new + changed data 
-- Delete 3 records
DELETE FROM staging.orders WHERE order_id IN (SELECT order_id FROM staging.orders LIMIT 3);


-- Update 1 status
UPDATE raw.orders SET order_status = 'canceled'
WHERE order_id = (SELECT order_id FROM staging.orders LIMIT 1);

-- Run 1: nothing new -> 0 inserted, 0 updated
CALL staging.upsert_orders(); -- DO UPDATE
CALL staging.upsert_order_items(); -- DO NOTHING



select * from staging.etl_control