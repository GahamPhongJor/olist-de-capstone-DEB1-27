-- check the first 10 rows of the order tables
select * from orders limit 10;

--see the first 10 rows after selecting two columns
select order_id, order_status as status
from orders limit 10;

-- distinct value of order_status
select distinct order_status from orders;

--choose columns and rename columns
select order_id,
	order_status as status,
	order_purchase_timestamp as purchased_at
from orders limit 10;

-- Filtering rows with WHERE
-- common operators
-- "="
select	order_id, 
		order_status as status
from orders 
where order_status = 'delivered';


-- "<>", not equal
select	order_id, 
		order_status as status
from orders 
where order_status <> 'delivered';

-- "IN ()"
select	order_id, 
		order_status as status
from orders 
where order_status in ('shipped','delivered');

--"IS NULL"
select order_id,customer_id
from orders 
where order_status is null;

--BETWEEN---AND
select order_id, product_id, price
from order_items
where price between 50 and 100; 


-- check the first 10 rows of the order tables
select * from geolocation limit 10;

-- LIKE 'sao%'
select geolocation_zip_code_prefix, geolocation_state, geolocation_city
from geolocation
where geolocation_city like 'sao%';


--C:\Users\BPL\AppData\Roaming\DBeaverData\workspace6\General\Scripts\Script-2.sql
