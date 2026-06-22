
select * from customers;
select * from products;
select * from order_items;
select * from orders;


1--total revenue generated

select sum(p.price*oi.quantity) as revenue
from products p 
join order_items oi
	on p.product_id = oi.product_id


2--Who is our most valuable customer by revenue?

select c.customer_id,
		c.customer_name,
	   sum(oi.quantity*p.price) as revenue
from customers c
join orders o
	on c.customer_id = o.customer_id
join order_items oi
	on o.order_id = oi.order_id
join products p 
	on oi.product_id = p.product_id
group by c.customer_id,c.customer_name
order by 3 desc
limit 1;


3--Which product generated the highest revenue?

select p.product_id,
		p.product_name,
	   sum(p.price*oi.quantity) as product_revenue
from products p
join order_items oi 
	on p.product_id = oi.product_id
group by p.product_id,p.product_name
order by product_revenue desc
limit 1;

4--Find all customers and the number of orders they placed.

select c.customer_id , count(*) as order_count
from customers c
join orders o 
	on c.customer_id = o.customer_id 
group by c.customer_id 
order by c.customer_id 

5--Which customers placed more than one order?

select c.customer_id , count(*) as total_orders
from customers c 
join orders o
	on c.customer_id = o.customer_id 
group by c.customer_id
having count(*) >1
order by c.customer_id;

6--Which category generates the most revenue?

select p.category,sum(p.price*oi.quantity) as total_revenue
from products p
join order_items oi 
	on p.product_id = oi.product_id
group by p.category
order by total_revenue desc
limit 1;

7--On average, how much money does a customer spend per order?

with cte as (
select oi.order_id,
	sum(oi.quantity*p.price) as order_revenue
from customers c
join orders o 
	on c.customer_id = o.customer_id
join order_items oi
	on o.order_id = oi.order_id
join products p
	on oi.product_id = p.product_id
group by oi.order_id
)
select round(avg(order_revenue),2) as avg_amount_per_order
from cte
