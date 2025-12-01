select * from customers;
select * from Orders;

-- 1. display all the records from customers who made a purchase of books  

select * from customers 
where custid in (select custid from Orders where product='Notebook');

-- 2. display all the records from customer who made a purchase of books , toys, cd

select * from customers 
where custid in(select custid from Orders where product in('Notebook','mouse','Keyboard'));

-- 3. display the list of customers who never made any purchase

select * from customers
where custid not in(select custid from Orders);

-- 4. display the second highest age from customers (do not use top keyword)

select max(age) as seconhighestage from customers
where age<(select max(age) from customers);

-- 5. display the list from orders  where customers stays in bangalore 

select * from Orders
where custid in(select custid from customers where caddress='Bangalore');

-- 6. display list of customer who made lowest purchase (in terms of quantity) 

select * from customers where custid  in (select custid from Orders where qty in (select min(qty) from Orders));

/*
7. display the list of customer who's age is greater then  jayant's age ( but we 
dont know jayant's age) */

select * from customers where age >(select age from customers where custname='Jayant');

/*
8. update customer table where 
custid =10's age  =     custid=11's age
*/

update customers set age = (select age from customers where custid=11)
where custid =10;

select * from customers;

--9. Display those details who made orders in December of any year 

select * from customers where custid in(select custid from Orders
where month(orderdate) =12);

/*
10. Show all  orders made before first half of the month (before the 16th of the 
month who does not reside in bangalore).
*/

select * from Orders
where day(orderdate)<16 and custid in(select custid from customers where caddress <> 'Bangalore');

/*
11. Display list of customers  from delhi and Bangalore who made purchase of 
less than 3 product 
*/

select * from customers where caddress in ('delhi','Bangalore')  and custid in (select custid  from Orders where qty<3);

-- 12. Display list of orders where price is greater than average price

select * from Orders where price >(select avg(price) from Orders);

/*
13. update orders table increasing  price by 10%  for customers residing in 
Bangalore and who have purchased books. 
*/
select * from Orders;

update Orders set price =price+price*0.1 
where product ='pen set' and 
custid in (select custid from customers where caddress = 'bangalore');



/*
14.Display orderdetails in following format 
OrderID-Date Total(price*qty) 
100-1/1/2000 500
*/

select concat(orderid,'-',orderdate) as [OrderID-Date],sum(price*qty) as [Total(price*qty)] from Orders
group by orderid,orderdate;
