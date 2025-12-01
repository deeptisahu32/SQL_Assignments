create database Custdb;

-- customers table ---

create table customers(
custid int,
custname varchar(20),
age tinyint,
caddress varchar(50),
cphone varchar(20)
);

insert into customers values
(1,'Ramesh',23,'kanpur','+91 7654326745'),
(2,'Pooja',34,'Chennai','+91 8456784365'),
(3,'Shayam',29,'Lucknow','+91 9876564543'),
(4,'Radhey',45,'Bijnaur','+91 8756498654'),
(5,'Seema',67,'kanpur,','+91 7654323454'),
(6,'Jayant',56,'Chennai','+91 87543221134');

insert into customers values
(7,'Ramesh',23,'Bangalore','+91 7654326745'),
(8,'Pooja',34,'Chennai','+91 8458984365'),
(9,'Rahul',34,'Bangalore','+91 8456984365');

insert into customers values
(10,'Aman',23,'Bangalore','+91 7654316745'),
(11,'Ashutosh',34,'Chennai','+91 8450984365'),
(12,'Rahul',34,'Bangalore','+91 8456004365');

-- second orders table create ---

create table Orders(
custid int,
orderid int,
orderdate date,
product varchar(20),
price float,
qty int,
);

insert into Orders values

(1, 1001, '2025-11-26', 'Notebook',999.00,  2),
(2, 1002, '2025-11-26', 'Pen Set', 1490.50, 3),
(3, 1003, '2025-11-26', 'USB Cable',790.99, 1),
(4, 1004, '2025-11-26', 'Mouse',  599.00, 1),
(5, 1005, '2025-11-26', 'Keyboard',899.00, 1),
(6,1006,'2025-12-23','Pen Set',1000.2,2);

insert into Orders values
(7, 1001, '2025-11-26', 'Notebook',999.00,  100),
(8, 1002, '2025-11-26', 'Pen Set', 1490.50, 150),
(9, 1003, '2025-11-26', 'USB Cable',790.99, 300),
(10, 1004, '2025-11-26', 'Mouse',  599.00, 1500),
(11, 1005, '2025-11-26', 'Keyboard',899.00, 1000),
(12,1006,'2025-12-23','Pen Set',1000.2,800);

select * from Orders;


--1. Display the list of customers who resides in Kanpur

select * from customers where caddress= 'Kanpur';

--2. Display the list of customers who does not resides in Bangalore or chennai 

select * from customers where caddress <> 'Bangalore' and caddress <> 'Chennai';

--3. Display the list of customers who’s age is greater then 50 and does not resides in Bangalore

select * from customers where age>50 and caddress<>'Bangalore';

--4. Display the list of customers who’s name starts with A

select * from customers where custname like 'A%';

-- 5. Display the list of customers who’s name contains a word Br

select * from customers where custname like '%Br%';

--6. Display the list of customer who’s name start between a to k 

select * from customers where custname like '[a-k]%'

--7. Display the list of customers who’s name is 5 character long

select * from customers where len(custname)=5;

/** 8. Display the list of customer who’s name  
a. Start with s 
b. Third character is c 
c. Ends with e **/

select * from customers where custname like 's_c%e';

--9. Display unique customer names from customers table

select distinct custname from customers;

--10. List orders details where qty falling in the range 100-200  and 700-1200 

select * from Orders where (qty between 100 and 200) or (qty between 700 and 1200);

--11.  List customer details where custname beginning with AL and ending with N 

select * from customers where custname like 'al%n';

/**12. Display what each  price would be if a 20% price increase were to take 
place. Show the custid , old price and new price ,using meaningful 
headings(use orders table) **/

select * from Orders;
select custid as customer_Id,price as Old_Price,
price + (price * 0.20) as new_Price
from Orders;

--13. Display top 3 highest qty from orders table 

select top 3 qty from Orders order by qty desc;

/**14. Display how many times customers have purchased a product (display 
count and customerid from orders table)**/

select * from Orders;

select custid,count(*) purchased_count from Orders
group by custid;

--15. Display the list of orders who’s orders made earlier then 5 years from now

select * from Orders
where year(GETDATE())-year(orderdate) >5;

--16.  Select * from customers where custname is null 

select * from customers where custname is null;

/** 
17.  Display orderdetails in following format 
OrderID-Date Total(price*qty) 
100-1/1/2000 500
**/

select concat((orderid),'-',(orderdate)) as [orderid-Date], 
sum(price*qty) as [Total(price*qty)] from Orders
group by orderid,orderdate;

-- 18.  Update orders table by decreasing price by 20% for qty > 50


update Orders set price=(price-(price*1.20))
where qty>50;
select * from Orders;

/**19. You want to retrieve data for all the orders who made order  '1-12-90' 
having price 4000 – 6000 and sort the column in descending order on 
price**/

select * from Orders
where orderdate ='1-12-90' and price between 4000 and 6000
order by price desc;

/**
20. Display order details in following format 
Custid Price (sum of price) Count (count of qty) 
1 5000 3 
2 4000 9 
3 6700 6
**/

select custid, sum(price) as [Price(sum of price)] ,count(qty) as [Count (count of qty)]  from Orders 
group by custid;

--21. Display above details only for price > 4000 

select custid, sum(price) as [Price(sum of price)] ,count(qty) as [Count (count of qty)]  from Orders
where price>4000
group by custid;

/**
22. Write a query to create duplicate table of customer , and name it as 
custhistory 
a. Delete all the records of custhistory 
b. Copy records of customers to custhistory where age > 30
**/

select *  into custhistory from customers;

truncate table custhistory;

select * from custhistory;

insert into custhistory select * from customers 
where age>30;

