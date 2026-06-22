8--How much revenue did we generate each month?

select extract(month from o.order_date) , sum(oi.quantity*p.price) as revenue_by_month
from orders o
join order_items oi
	on o.order_id = oi.order_id
join products p 
	on oi.product_id = p.product_id
group by extract(month from o.order_date)

9--Which city generates the most revenue?

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

10--How much money has each customer contributed to the company since becoming a customer?

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

11--What percentage of total revenue comes from each customer?

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


12--Rank customers based on their lifetime revenue contribution.

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

13--Find the highest revenue generating product in each category.

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

14--Find the Top 3 customers by lifetime revenue.

select * 
from(
select c.customer_id,
	sum(oi.quantity*p.price) ,
	rank() over(order by sum(oi.quantity*p.price) desc) rnk
from customers c
join orders o
	on c.customer_id = o.customer_id
join order_items oi
	on oi.order_id = o.order_id
join products p
	on p.product_id = oi.product_id
group by c.customer_id
)
where rnk<=3;

15--How much did revenue increase compared to the previous month?

with cte as (
select extract(month from o.order_date)as month,
	sum(oi.quantity*p.price) as revenue
from order_items oi
join orders o
	on oi.order_id = o.order_id
join products p 
	on oi.product_id = p.product_id
group by extract(month from o.order_date)
)
select month,
	   revenue,
	   lag(revenue) over(order by month) prev_month,
	   revenue-lag(revenue) over(order by month) growth,
	   round((revenue-lag(revenue) over(order by month))/lag(revenue) over(order by month)*100,2)
from cte;

16--Find the revenue contribution percentage of each product.

with contri as (
select p.product_name,
	sum(oi.quantity*p.price) product_rev,
	sum(sum(oi.quantity*p.price)) over() as total_revenue
from order_items oi
join products p
	on oi.product_id = p.product_id
group by p.product_id,p.product_name
order by p.product_id
)
select *,
		round(product_rev/total_revenue*100,2) as contri_per_product
from contri

17--Create customer segments:

--Revenue >= 50000      → High Value
--Revenue >= 10000      → Medium Value
--Else                  → Low Value

with cust_rev as (
select c.customer_id ,sum(oi.quantity*p.price) revenue
from customers c
join orders o
	on c.customer_id = o.customer_id
join order_items oi
	on oi.order_id = o.order_id
join products p
	on p.product_id = oi.product_id
group by c.customer_id
order by c.customer_id
)
select *,case when revenue>=50000 then 'High Value' 
	        when revenue>=10000 then 'Medium Value'
			else 'Low Value'
			end as category
from cust_rev

18--Find the highest revenue generating customer in each city.

select * 
from (
select c.customer_id,
	c.city,
	sum(oi.quantity*p.price) as revenue,
	rank() over(partition by c.city order by sum(oi.quantity*p.price) desc) rnk
from customers c
join orders o
	on c.customer_id = o.customer_id
join order_items oi
	on o.order_id = oi.order_id
join products p
	on oi.product_id = p.product_id
group by c.customer_id,c.city
) 
where rnk=1
order by revenue desc;

19--Find all customers whose lifetime revenue 
--is greater than the average customer lifetime revenue.

with cte as (
select c.customer_id,
	sum(oi.quantity*p.price) as revenue
from customers c
join orders o
	on c.customer_id = o.customer_id
join order_items oi
	on o.order_id = oi.order_id 
join products p
	on p.product_id = oi.product_id
group by c.customer_id
)
select *
from cte 
where revenue>(select avg(revenue)
				from cte )
order by customer_id;

--which customers buy frequently?

select c.customer_id ,count(c.customer_id) freq_customers
from customers c
join orders o
	on c.customer_id = o.customer_id
join order_items oi
	on oi.order_id = o.order_id
join products p
	on p.product_id = oi.product_id
group by c.customer_id
order by freq_customers desc;

--which customers have not purchased recently?
with cte as (
select c.customer_id,max(o.order_date) as last_order
from customers c
join orders o
	on c.customer_id = o.customer_id
group by c.customer_id
)
select customer_id, current_date-last_order
from cte 

20--Which products are performing better than the average product?

with product_revenue as (
select p.product_id ,
	sum(oi.quantity*p.price) as revenue,
	round(avg(sum(oi.quantity*p.price)) over(),2) as avg_rev
from orders o
join order_items oi
	on o.order_id = oi.order_id
join products p
	on p.product_id = oi.product_id
group by p.product_id
)
select *
from product_revenue
where revenue>avg_rev

21--How has total revenue accumulated over time?

with month_rev as (
select extract(month from o.order_date) as month,
	sum(oi.quantity*p.price) as revenue
from order_items oi
join orders o
	on oi.order_id = o.order_id
join products p
	on p.product_id = oi.product_id
group by extract(month from o.order_date)
)
select month,
	revenue,
	sum(revenue) over(order by month asc) as running_total
from month_rev

22--Which customers have generated more revenue than 
--the average customer in their city?

with cte as (
select c.customer_id,c.city,
	sum(oi.quantity*p.price) as revenue
from customers c
join orders o
	on c.customer_id = o.customer_id
join order_items oi
	on oi.order_id = o.order_id
join products p
	on oi.product_id = p.product_id
group by c.customer_id,c.city
)
select *
from cte 
where revenue>(select avg(revenue) 
				from cte c2
				where c2.city = cte.city
				)

23--Which products are gaining momentum and which are declining?

with cte as (
select p.product_id , 
	extract(month from o.order_date) as month,
	sum(oi.quantity*p.price) as revenue
from orders o
join order_items oi
	on o.order_id = oi.order_id
join products p
	on p.product_id = oi.product_id
group by p.product_id,extract(month from o.order_date)
order by p.product_id
)
select product_id,
	 month,
	revenue,
	lead(revenue) over(partition by product_id order by month) as next_month_rev
from cte



