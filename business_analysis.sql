--How much revenue did we generate each month?

select extract(month from o.order_date) , sum(oi.quantity*p.price) as revenue_by_month
from orders o
join order_items oi
	on o.order_id = oi.order_id
join products p 
	on oi.product_id = p.product_id
group by extract(month from o.order_date)

--Which city generates the most revenue?

select c.city,sum(oi.quantity*p.price) as revenue_by_city
from customers c
join orders o
	on c.customer_id = o.customer_id
join order_items oi
	on o.order_id = oi.order_id 
join products p
	on p.product_id = oi.product_id
group by c.city
order by revenue_by_city desc
limit 1;

--How much money has each customer contributed to the company since becoming a customer?

select c.customer_id , sum(oi.quantity*p.price) as cust_contri
from customers c
join orders o 
	on c.customer_id = o.customer_id
join order_items oi
	on oi.order_id = o.order_id 
join products p
	on oi.product_id = p.product_id
group by c.customer_id
order by customer_id;

--What percentage of total revenue comes from each customer?

select c.customer_id , 
	sum(oi.quantity*p.price) as cust_contri,
	round(sum(oi.quantity*p.price)*100.00/sum(sum(oi.quantity*p.price)) over(),2) as total_revenue
from customers c
join orders o 
	on c.customer_id = o.customer_id
join order_items oi
	on oi.order_id = o.order_id 
join products p
	on oi.product_id = p.product_id
group by c.customer_id
order by customer_id;


--Rank customers based on their lifetime revenue contribution.

select c.customer_id,
	sum(oi.quantity*p.price) as revenue,
	rank() over(order by sum(oi.quantity*p.price) desc) cust_rank
from customers c
join orders o
	on c.customer_id = o.customer_id
join order_items oi
	on o.order_id = oi.order_id
join products p
	on oi.product_id = p.product_id
group by c.customer_id 

--Find the highest revenue generating product in each category.

select *
from (
select p.product_name ,p.category,sum(oi.quantity* p.price),
	row_number() over(partition by p.category order by sum(oi.quantity*p.price) desc) as rnk
from order_items oi
join products p
	 on oi.product_id = p.product_id
group by p.product_name,p.category
)
where rnk = 1;


