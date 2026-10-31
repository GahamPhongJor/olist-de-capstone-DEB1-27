--	1. Revenue (SUM of price) by customer_state for delivered orders. Top 10 states.
-- tables: customers (customer_id,customer_state), orders (order_id,customer_id,order_status), order_items(order_id, price)
select customer_state, sum(price) as revenue from orders o
inner join customers c on o.customer_id = c.customer_id
inner join order_items oi on o.order_id = oi.order_id
where order_status = 'delivered'
group by customer_state 
order by revenue desc
limit 10;


--	2. How many orders have no review at all? (anti-join)
-- tables: orders, order_reviews
select count(*) without_review 
from orders o
left join order_reviews r on o.order_id = r.order_id 
where r.order_id is null --29,698

--	3. Top 10 product categories in English by items sold. Why LEFT JOIN to the translation?
-- tables: order_items (product_id, price), products (product_id, product_category_name),category_translation (product_category_name_english) 
select p.product_category_name, count(*) as item_sold
from order_items oi
left join products p on oi.product_id = p.product_id
inner join category_translation ct on p.product_category_name = ct.product_category_name_english 
group by p.product_category_name
order by item_sold desc
limit 10;


--	4. What share of order items were sold by a seller in the same state as the customer?
-- tables: order_items(main), sellers (seller_id, seller_state), orders(order_id, customer_id), customers(customer_id,customer_state)
select count (*) as total_items, 
	sum(case when s.seller_state = c.customer_state then 1 else 0 end) as same_state,
	round(
			sum(case when s.seller_state = c.customer_state then 1 else 0 end) *1.0 
			/count (*),2) 
	as share
from order_items oi 
left join orders o on oi.order_id = o.order_id
left join customers c on o.customer_id = c.customer_id
left join sellers s on oi.seller_id = s.seller_id -- 40,736/112,650

   
--	5. For 5 orders, show item revenue and payment total side by side — without fan-out.
select oi.order_id, 
	sum(oi.price+oi.freight_value) as revenue,
	sum(op.payment_value) as payment_amount
from order_items oi 
left join order_payments op on oi.order_id = op.order_id 
group by oi.order_id
limit 5;


--	6. Find orders where payments differ from price + freight by more than 1.00.
select i.order_id,	i.revenue,	p.total_payment,
	p.total_payment - i.revenue as difference
from (select 
		order_id,
		sum(price+freight_value) as revenue
	from order_items
	group by order_id) i
left join 
	(	select 
		order_id,
		sum(payment_value) as total_payment
	from order_payments 
	group by order_id) p
on 
		i.order_id = p.order_id
	where 
		p.total_payment - i.revenue > 1.00
	order by difference
	






