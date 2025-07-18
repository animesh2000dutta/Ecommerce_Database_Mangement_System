-- Project E-Commerce Database --

create database ecommerce_db;
use ecommerce_db;

# Inserting Customers table

Create table Customers
(
	customer_id int primary key auto_increment,
    first_name varchar(70) not null,
    last_name varchar (70) not null,
    email varchar(100) unique not null,
    address varchar(399) not null,
    city varchar (100) not null,
    country varchar(100) not null,
    registration_date datetime default current_timestamp
    );

# Inserting Products Table

Create table Products
( 
		product_id int primary key auto_increment,
        product_name varchar(100) unique not null,
        description text,
        price decimal(10,2) not null check (price >= 0 ),
        stock_quantity int not null check (stock_quantity >=0 )
        
);

# Inserting orders Tables

Create table Orders
(
	
    order_id int primary key auto_increment,
    customer_id int not null,
    order_date datetime default current_timestamp,
    total_amount decimal(10,2) not null,
    status varchar(100) default "Pending",
    constraint fk_customer foreign key (customer_id) references Customers(customer_id) on delete restrict
    
);

# Inserting Orders_items Table

Create table Orders_items
(
	order_item_id int primary key auto_increment,
    order_id int not null,
    product_id int not null,
    quantity int not null check (quantity >= 0),
    unit_price decimal(10,2) not null check (unit_price >= 0),
    constraint fk_orders foreign key (order_id) references Orders(order_id) on delete restrict,
	constraint fk_product foreign key (product_id) references Products(product_id) on delete restrict

);

# Inserting data into columns

Insert into Customers (first_name,last_name,email,address,city,country) values
('John', 'Doe', 'john.doe@example.com', '123 Main St', 'Anytown', 'USA'),
('Jane', 'Smith', 'jane.s@example.com', '456 Oak Ave', 'Villagetown', 'Canada'),
('Peter', 'Jones', 'peter.j@example.com', '789 Pine Rd', 'Metropolis', 'USA'),
('Alice', 'Williams', 'alice.w@example.com', '101 Elm Blvd', 'Sydney', 'Australia'),
('Bob', 'Brown', 'bob.b@example.com', '202 Maple Dr', 'London', 'UK'),
('Carlos', 'Garcia', 'carlos.g@example.com', '303 Birch Ln', 'Mexico City', 'Mexico'),
('Maria', 'Lopez', 'maria.l@example.com', '404 Cedar St', 'Madrid', 'Spain');

Insert into Products (product_name,description,price,stock_quantity) values
('Laptop Pro X', 'High-performance laptop with 16GB RAM', 1200.00, 50),
('Mechanical Keyboard', 'RGB backlit gaming keyboard', 75.50, 120),
('Wireless Mouse', 'Ergonomic design with silent clicks', 25.00, 200),
('USB-C Hub', 'Multi-port adapter for modern laptops', 40.00, 80),
('External SSD 1TB', 'Fast and portable storage', 150.00, 30),
('Gaming Headset', 'Immersive audio with noise cancellation', 99.99, 70),
('Webcam 1080p', 'Full HD webcam for video calls', 55.00, 10), 
('Monitor 27-inch', '4K UHD display with HDR', 350.00, 40),
('Smart Speaker', 'Voice-controlled assistant', 60.00, 0), 
('Portable Charger', '10000mAh power bank', 30.00, 150);

Insert into Orders (customer_id,order_date,total_amount,status) values
(1, '2024-06-01 10:00:00', 1200.00, 'Delivered'),  
(2, '2024-06-05 14:30:00', 75.50, 'Shipped'),     
(1, '2024-06-07 11:15:00', 25.00, 'Delivered'),   
(3, '2024-06-10 09:00:00', 150.00, 'Pending'),    
(4, '2024-06-12 16:00:00', 1200.00, 'Delivered'),  
(5, '2024-06-15 13:00:00', 40.00, 'Shipped'),     
(1, '2024-06-18 10:30:00', 99.99, 'Pending'),    
(6, '2024-06-20 17:00:00', 350.00, 'Delivered'),  
(7, '2024-06-22 11:00:00', 30.00, 'Shipped'),     
(3, '2024-06-25 09:45:00', 25.00, 'Pending'),    
(1, '2024-07-01 12:00:00', 75.50, 'Pending'); 

insert into Orders_items (order_id,product_id,quantity,unit_price) values
(1, 1, 1, 1200.00), 
(2, 2, 1, 75.50),   
(3, 3, 1, 25.00),   
(4, 5, 1, 150.00),  
(5, 1, 1, 1200.00), 
(6, 4, 1, 40.00),   
(7, 6, 1, 99.99),   
(8, 8, 1, 350.00),  
(9, 10, 1, 30.00),  
(10, 3, 1, 25.00),  
(11, 2, 1, 75.50);  

# Adding some multi item orders
insert into Orders (customer_id,order_date,total_amount,status) values
(2,'2025-07-05 15:00:00',127.00,'Pending');

set @last_order_id = LAST_INSERT_ID();

insert into Orders_items (order_id,product_id,quantity,unit_price) values
(@last_order_id, 3,3,25.00),
(@last_order_id, 10,1,30.00);

insert into Orders (customer_id,order_date,total_amount,status)values
(3,'2025-07-10 11:00:00',1300.00,'Pending');

set @last_order_id = LAST_INSERT_ID();

insert into Orders_items(order_id,product_id,quantity,unit_price) values
(@last_order_id,1,1,1300.00),
(@last_order_id,4,2,35.00);

-- Task 1: Find all orders placed by a specific customer.
-- find orders for 'John Doe' (customer_id = 1)

select Orders.Order_id,Orders.order_date,Orders.status,Customers.first_name,Customers.last_name
	from orders
		join Customers on Orders.customer_id = Customers.customer_id
				where Customers.customer_id = 1
						order by Orders.order_date ;
                        
-- Task 2: List all products in a particular order.
-- list products for Order ID 1 (John Doe's laptop order)

select Orders_items.order_id,
	   Products.product_name,
		Products.price as Current_Product_Price,
        Orders_items.unit_price as Price_at_Order,
        Orders_items.quantity 
        from Orders_items
				join Products on Orders_items.product_id = Products.product_id
					where Products.product_name = 'Mechanical Keyboard' ;
                    
-- Task 3: Calculate the total revenue generated from all orders.

select sum(total_amount) as Total_Revenue
	from Orders;
    
-- Task 4: Find the top 5 best-selling products (by quantity sold)

Select Products.product_name, sum(Orders_items.quantity) as Total_Qunatity_sold
	from Products
		join Orders_items on Products.product_id = Orders_items.product_id
				group by Products.product_name
                order by Total_Qunatity_sold desc
                limit 5 ;
                
-- Task 5: Identify customers who have placed more than 2 orders.
        
	select Products.product_name, Orders_items.quantity
		from Products
        join Orders_items on Products.product_id = Orders_items.product_id
        where Orders_items.quantity = 2 ;


## Customers (customer_id)  -- Orders(customer_id) -- Orders_items(product_id) -- Products(product_id)

select Products.product_name,Products.product_id,
		sum(Orders_items.quantity) as Total_Quantity_sold
        from Products join Orders_items on Products.product_id = Orders_items.product_id
        group by Products.product_name ;
        
select
	Customers.customer_id,
    Customers.first_name,
    Customers.last_name,
    Count(Orders.order_id) as Number_of_Orders
    from
			Customers 
				join Orders on Customers.customer_id = Orders.customer_id
                group by Customers.customer_id, Customers.first_name,Customers.last_name
                having count(Orders.order_id) > 2
                Order by Number_of_Orders desc ;
                
-- Find products that are currently out of stock (`stock_quantity = 0`).

-- Orders_items(product_id) -- Products(product_id)

select
		product_id,
        product_name,
        stock_quantity as Stocks
        from Products where stock_quantity =0 ;
        
 -- Task 7: Calculate the average order value.
 
 select avg(total_amount) as Average_order_value From Orders;
        
-- Task 8: Find customers who have ordered a specific product.
-- find customers who ordered 'Wireless Mouse' (product_id = 3)

## Customers (customer_id)  -- Orders(customer_id) -- Orders_items(product_id) -- Products(product_id)
                            -- Orders(order_id).   -- Orders_items(order_id)
select
	Customers.customer_id,
    Customers.first_name,
    Customers.last_name
    from Customers
			join Orders on Customers.customer_id = Orders.customer_id
            join Orders_items on Orders.order_id = Orders_items.order_id
            where Orders_items.product_id = 3 ;
            
-- Task 9: Get the last order date for each customer.

## Customers (customer_id)  -- Orders(customer_id) -- Orders_items(product_id) -- Products(product_id)

SELECT
    Customers.customer_id,
    Customers.first_name,
    Customers.last_name,
    MAX(Orders.order_date) AS Last_Order_Date
FROM
    Customers 
JOIN
    Orders  ON Customers.customer_id = Orders.customer_id
GROUP BY
    Customers.customer_id, Customers.first_name, Customers.last_name
ORDER BY
     Last_Order_Date DESC;
     
-- Task 10: List all products that have never been ordered. (Using LEFT JOIN and IS NULL)

## Customers (customer_id)  -- Orders(customer_id) -- Orders_items(product_id) -- Products(product_id)

SELECT
    Products.product_name,
    Products.product_id
FROM
    Products 
LEFT JOIN
    Orders_Items  ON Products.product_id = Orders_items.product_id
WHERE
    Orders_items.product_id IS NULL;
    
-- Task 11: Calculate the total quantity of each product sold.

## Customers (customer_id)  -- Orders(customer_id) -- Orders_items(product_id) -- Products(product_id)

Select 
	Products.product_name,
    Products.product_id,
    sum(Orders_items.quantity) as Total_Qunatity_sold
    from Products
				join Orders_items on Products.product_id = Orders_items.product_id
							group by Products.product_name ;
                            
-- Task 12: Find orders that are still 'Pending' and were placed more than a week ago.
SELECT
    order_id,
    customer_id,
    order_date,
    status
FROM
    Orders
WHERE
    status = 'Pending'
AND
    order_date < NOW() - INTERVAL 7 DAY; 

-- Task 13: Get the customer details for the customer with the highest total order amount. (Using Subquery)
SELECT
    Customers.first_name,
    Customers.last_name,
    SUM(Orders.total_amount) AS total_spent
FROM
    Customers 
JOIN
    Orders  ON Customers.customer_id = Orders.customer_id
GROUP BY
    Customers.customer_id, Customers.first_name, Customers.last_name
ORDER BY
    total_spent DESC
LIMIT 1;






    

