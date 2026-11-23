-- Full load
CALL staging.run_etl();

-- watermark procedure
CALL staging.load_orders_incremental();

-- run etl control
select * from staging.etl_log;

select * from staging.rejected_rows rr 

select * FROM raw.orders

SELECT * FROM staging.mv_seller_scorecard ORDER BY revenue DESC LIMIT 10;