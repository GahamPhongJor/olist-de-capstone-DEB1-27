--(1) How many customers are there in each state? Show the top 5 states.
-- checking data table
select * from customers;
select customer_state,
       count(*) as 	customers
from customers
group by customer_state
order by customers desc
limit 5;


--(2) How many distinct real customers (customer_unique_id) are there?
-- checking data table
select * from customers;
select count(distinct customer_id) from customers; -- 99441


--(3) Which payment_type is used most, and what is its total payment_value?
--check data table
select * from order_payments;
select payment_type,
		count(*) payment_count,
		sum(payment_value) total_amount
from order_payments
group by payment_type;


--(4) How many reviews are there for each review_score (1 to 5)? What is the overall average score?
-- check data table
select * from order_reviews;
-- How many reviews are there for each review_score (1 to 5)?
select review_score,
	count(*) review_count
from order_reviews
group by review_score;

--What is the overall average score?
select  avg(review_score) as overall_review_score
from order_reviews;


--(5) Sellers by state: which states have more than 50 sellers?
-- checking data
select * from sellers
-- group by seller_state count seller id
select seller_state,
		count(*) seller_count
from sellers
group by seller_state
having count(*) >= 50
order by seller_count desc;

--(6) Average price and freight per order item, rounded to 2 decimals.
-- checking data
select * from order_items;
-- group by order id, avg(price) avg(frieht)
select order_item_id,
		round(avg(price),2) avg_price,
		round(avg(freight_value),2) avg_freight
from order_items
group by order_item_id
order by order_item_id desc;

