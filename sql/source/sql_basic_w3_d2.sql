-- Q1.	NULL audit: count NULLs in product_category_name and product_weight_g.
SELECT
  COUNT(*) - COUNT(product_category_name)
      AS nulls_product_category_name,
  COUNT(*) - COUNT(product_weight_g)
      AS nulls_product_weight_g
FROM products; -- nulls_product_category_name: 610, nulls_product_weight_g: 2


-- Q2.	For each month of purchase, what is the average delivery time, and how many orders (and what percentage) were delivered within 30 days of purchase?
select
    date_trunc('month', order_purchase_timestamp) as purchase_month,
    avg(order_delivered_customer_date::date - order_purchase_timestamp::date) as avg_delivery_days,
    sum(case when order_delivered_customer_date::date - order_purchase_timestamp::date <= 30
             then 1 else 0 end) as delivered_within_30,
    round(
        sum(case when order_delivered_customer_date::date - order_purchase_timestamp::date <= 30
                 then 1 else 0 end) * 100.0
        / count(*), 2
    ) as pct_within_30
from orders
where order_delivered_customer_date is not null
group by date_trunc('month', order_purchase_timestamp)
order by purchase_month;


-- Q3. 	On which day of the week do customers place the most orders? Show each weekday’s name and number, and the total orders for that day, sorted from busiest to quietest.
select
    extract(isodow from order_purchase_timestamp) as weekday_num,
    to_char(order_purchase_timestamp, 'FMDay')    as weekday_name,
    count(*)                                      as total_orders
from orders
group by
    extract(isodow from order_purchase_timestamp),
    to_char(order_purchase_timestamp, 'FMDay')
order by total_orders desc;



-- Q4.	What is the total revenue for each product category, shown with its English name? If a category has no English translation, show the original Portuguese name instead. If the product has no category at all, show it as ‘unknown’.
select
    coalesce(t.product_category_name_english, p.product_category_name, 'unknown') as category,
    sum(oi.price) as total_revenue
from order_items oi
left join products p
    on oi.product_id = p.product_id
left join category_translation t
    on p.product_category_name = t.product_category_name
group by 1
order by total_revenue desc;



-- Q5.	Group delivered orders by delivery speed:
		-- • Fast: 7 days or less from purchase to delivery.
		-- • Normal: 8 to 14 days.
		-- • Slow: 15 to 30 days.
		-- • Very slow: more than 30 days.
		-- How many orders fall into each group, and what percentage of the total is each?
with delivered as (
    select
        order_id,
        order_delivered_customer_date::date - order_purchase_timestamp::date as days
    from orders
    where order_delivered_customer_date is not null
),
bucketed as (
    select
        order_id,
        days,
        case
            when days <= 7  then 'Fast'
            when days <= 14 then 'Normal'
            when days <= 30 then 'Slow'
            else 'Very slow'
        end as speed_group
    from delivered
)
select
    speed_group,
    count(*) as total_orders,
    round(count(*) * 100.0 / sum(count(*)) over (), 2) as pct_of_total
from bucketed
group by speed_group
order by min(days);