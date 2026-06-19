create table customers(
customer_id int primary key,
customer_name varchar(100),
city varchar(50),
signup_date date
);
create table products(
product_id int primary key,
product_name varchar(100),
category varchar(50),
price decimal(10,2)
);

create table orders(
order_id int primary key,
customer_id int,
order_date date,
foreign key(customer_id)
references customers(customer_id)
);

create table order_items(
order_item_id int primary key,
order_id int,
product_id int,
quantity int,

foreign key(order_id)
references orders(order_id),

foreign key(product_id)
references products(product_id)
);

INSERT INTO customers
VALUES
(1,'Mohit','Delhi','2024-01-15'),
(2,'Jane','Mumbai','2024-02-10'),
(3,'Bill','Delhi','2024-03-05'),
(4,'Zack','Bangalore','2024-03-20'),
(5,'Will','Chennai','2024-04-12');


INSERT INTO products
VALUES
(1,'Laptop','Electronics',50000),
(2,'Mouse','Electronics',500),
(3,'Keyboard','Electronics',1500),
(4,'Headphones','Electronics',3000),
(5,'Office Chair','Furniture',7000);

SELECT * FROM customers;
SELECT * FROM products;

INSERT INTO orders
VALUES
(101,1,'2024-05-01'),
(102,2,'2024-05-02'),
(103,1,'2024-05-10'),
(104,3,'2024-05-15'),
(105,4,'2024-06-01'),
(106,5,'2024-06-05'),
(107,2,'2024-06-10'),
(108,1,'2024-06-20');

INSERT INTO order_items
VALUES
(1,101,1,1),
(2,101,2,2),
(3,102,3,1),
(4,102,2,1),
(5,103,4,1),
(6,104,5,1),
(7,105,1,1),
(8,105,3,2),
(9,106,2,3),
(10,107,4,2),
(11,108,1,1),
(12,108,2,1),
(13,108,3,1);

select * from customers ;
select * from orders;
select * from products;
select * from order_items;
