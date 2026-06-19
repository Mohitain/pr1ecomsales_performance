
select * from customers;
select * from products;
select * from order_items;
select * from orders;

with cte as (
select oi.order_id,sum(oi.quantity*p.price) as order_revenue
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
from cte;

select *
from orders o
join order_items oi
	on o.order_id = oi.order_id
join products p 
	on oi.product_id = p.product_id