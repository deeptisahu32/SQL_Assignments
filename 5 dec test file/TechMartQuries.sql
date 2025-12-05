create database TeckmartDB;

--1. Customers 

create table Customers( 
    CustID INT PRIMARY KEY, 
    CustName VARCHAR(100), 
    Email VARCHAR(200), 
    City VARCHAR(100) 
)

INSERT INTO Customers (CustID, CustName, Email, City) VALUES
(1, 'Amit Sharma', 'amit.sharma@gmail.com', 'Mumbai'),
(2, 'Ravi Kumar', 'ravi.kumar@yahoo.com', 'Delhi'),
(3, 'Priya Singh', 'priya.singh@gmail.com', 'Pune'),
(4, 'John Mathew', 'john.mathew@hotmail.com', 'Bangalore'),
(5, 'Sara Thomas', 'sara.thomas@gmail.com', 'Kochi'),
(6, 'Nidhi Jain', 'nidhi.jain@gmail.com', NULL);

select * from customers;
 
--2. Products 
create table Products( 
    ProductID INT PRIMARY KEY, 
    ProductName VARCHAR(100), 
    Price DECIMAL(10,2), 
    Stock INT CHECK(Stock >= 0) 
)

INSERT INTO Products (ProductID, ProductName, Price, Stock) VALUES
(101, 'Laptop Pro 14', 75000, 15),
(102, 'Laptop Air 13', 55000, 8),
(103, 'Wireless Mouse', 800, 50),
(104, 'Mechanical Keyboard', 3000, 20),
(105, 'USB-C Charger', 1200, 5),
(106, '27-inch Monitor', 18000, 10),
(107, 'Pen Drive 64GB', 600, 80);

select * from Products;

--3. Orders 

create table Orders( 
    OrderID INT PRIMARY KEY, 
    CustID INT FOREIGN KEY REFERENCES Customers(CustID), 
    OrderDate DATE, 
    Status VARCHAR(20) 
)

INSERT INTO Orders (OrderID, CustID, OrderDate, Status) VALUES
(5001, 1, '2025-01-05', 'Pending'),
(5002, 2, '2025-01-10', 'Completed'),
(5003, 1, '2025-01-20', 'Completed'),
(5004, 3, '2025-02-01', 'Pending'),
(5005, 4, '2025-02-15', 'Completed'),
(5006, 5, '2025-02-18', 'Pending');
 
 select * from Orders;

 -- 4. OrderDetails 

create table OrderDetails( 
    DetailID INT PRIMARY KEY, 
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID), 
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID), 
    Qty INT CHECK(Qty > 0) 
)

INSERT INTO OrderDetails (DetailID, OrderID, ProductID, Qty) VALUES
(9001, 5001, 101, 1),
(9002, 5001, 103, 2),
 
(9003, 5002, 104, 1),
(9004, 5002, 103, 1),
 
(9005, 5003, 102, 1),
(9006, 5003, 105, 1),
(9007, 5003, 103, 3),
 
(9008, 5004, 106, 1),
 
(9009, 5005, 107, 4),
(9010, 5005, 104, 1),
 
(9011, 5006, 101, 1),
(9012, 5006, 107, 2);

select * from OrderDetails;

-- 5. Payments 
create table Payments( 
    PaymentID INT PRIMARY KEY, 
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID), 
    Amount DECIMAL(10,2), 
    PaymentDate DATE 
)

INSERT INTO Payments (PaymentID, OrderID, Amount, PaymentDate) VALUES
(7001, 5002, 3300, '2025-01-11'),
(7002, 5003, 62000, '2025-01-22'),
(7003, 5005, 4500, '2025-02-16');

select * from payments;


----------------------------------------------------------------------------------------------------------------

select * from Customers;
select * from Orders;
select * from OrderDetails;
select * from Payments;
select * from Products;

----------------------------------------------------------------------------------------------------------------

---------------------------------- SQL QURIES----------------------------------------------

/**
Q1. List customers who placed an order in the last 30 days. 
(Use joins) 
**/

select * from customers;
select * from orders;

select c.* from customers as c
join Orders as o
on
c.custid=o.CustID
where o.orderdate >= dateadd(day,-30,getdate());

/**
Q2. Display top 3 products that generated the highest total sales amount. 
(Use aggregate + joins)
**/

select * from products;
select * from OrderDetails;

select top 3 p.productid,p.productname,sum(od.qty*p.price) as total_sales from OrderDetails as od
join Products as p
on od.ProductID=p.ProductID
group by p.ProductID,p.ProductName
order by total_sales desc;

/*
Q3. For each city, show number of customers and total order count. 
*/

select * from Customers;
select * from Orders;

select c.city,count(distinct c.custid) as customer_count,count(distinct o.orderid) as order_count from customers as c
left join Orders as o
on
c.CustID=o.CustID
group by c.city;

/**
Q4. Retrieve orders that contain more than 2 different products.
**/

select * from OrderDetails;

select orderid,count(distinct productid) as unqproduct from OrderDetails
group by orderid
having count(distinct ProductID)>2

/**
Q5. Show orders where total payable amount is greater than 10,000. 
(Hint: SUM(Qty * Price))
**/

select * from OrderDetails;
select * from Products;

select od.orderid,sum(od.qty*p.price) as total_Amount from OrderDetails as od
join Products as p
on
od.productid=p.productid
group by od.orderid
having sum(od.qty*p.price)>10000

/**
Q6. List customers who ordered the same product more than once. 
**/

select * from Customers;
select * from Orders;
select * from OrderDetails;
select * from Payments;
select * from Products;

select c.custid,c.CustName,count(distinct o.orderid) as ord,p.productid,p.productname from customers as c
join Orders as o
on c.custid=o.custid
join OrderDetails as od
on o.orderid=od.orderid
join products as p
on od.ProductID=p.ProductID
group by c.custid,c.custname,p.productid,p.productname
having count(distinct o.orderid)>1

/**
Q7. Display employee-wise order processing details 
(Assume Orders table has EmployeeID column)
**/


select * from Orders;


select o.employeeid,count(*) as totalorders,
sum(case when o.status ='completed' then 1 else 0 end) as orderdone,
sum(case when o.status = 'pending' then 1 else 0 end) as orderpending
from Orders as o
group by o.employeeid;

----------------------------------------------- view ------------------------------------------

/**
Views 
1. Create a view vw_LowStockProducts 
Show only products with stock < 5. 
View should be WITH SCHEMABINDING and Encrypted
**/

select * from products;

create view vw_LowStockProducts
with encryption,schemabinding
as
select productid,productname,price,stock from dbo.products
where stock<5

select * from vw_LowStockProducts;

/**
Functions 
1. Create a table-valued function: fn_GetCustomerOrderHistory(@CustID) 
Return: OrderID, OrderDate, TotalAmount. 
2. Create a function fn_GetCustomerLevel(@CustID) 
Logic: 
• Total purchase > 1,00,000 → "Platinum" 
• 50,000–1,00,000 → "Gold" 
• Else → "Silver" 
**/

select * from Orders;
select * from OrderDetails;
select * from Products;

---------
create function fn_GetCustomerOrderHistory(@CustID int) 
returns table
as
return
(
select o.orderid,o.orderdate,sum(od.qty*p.price) as total from orders as o
join OrderDetails as od
on o.OrderID=od.OrderID
join Products as p
on od.ProductID=p.ProductID
where o.CustID=@custid
group by o.OrderID,o.orderdate
)

select * from dbo.fn_GetCustomerOrderHistory(1)

--------
alter function fn_GetCustomerLevel(@CustID int) 
returns nvarchar(20)
as
begin
declare @total decimal(20,2)
select  @total=sum(od.qty*p.price) from Orders as o
join OrderDetails as od
on o.OrderID=od.OrderID
join Products as p
on od.ProductID=p.ProductID
where o.CustID=@CustID
return
(
case 
when @total>100000 then 'Platinum'
when @total between 50000 and 100000 then 'Gold'
else 'Silver'
end
)
end;


select  c.custid,c.custname, dbo.fn_GetCustomerLevel(1) as level from customers as c;

----------------------------------------- procedures-----------------------------------------------------

/**
1. Create a stored procedure to update product price 
Rules: 
• Old price must be logged in a PriceHistory table 
• New price must be > 0 
• If invalid, throw custom error. 
**/

create table pricehistory
(
historyid int identity(1,1) primary key,
productid int,
oldprice decimal(10,2),
newprice decimal(10,2),
changedate date default getdate()
)

create procedure pr_update_price
@cproductid int,
@cnewprice decimal(10,2)
as 
begin
declare @coldprice decimal(10,2)

if @cnewprice is null or @cnewprice<=0
throw 50002 , 'price must be greater than zero ',1

select @coldprice=p.price
from Products as p
where p.ProductID=@cproductid

insert into pricehistory values (@cproductid,@coldprice,@cnewprice,getdate())

update products 
set price =@cnewprice
where ProductID=@cproductid

end;


select * from Products  where ProductID=101;

select * from pricehistory;

exec pr_update_price 101,12000;

/**
2. Create a procedure sp_SearchOrders 
Search orders by: 
• Customer Name 
• City 
• Product Name 
• Date range 
(Any parameter can be NULL → Dynamic WHERE)
**/


create procedure sp_SearchOrders
@customername varchar(20)=null,
@city varchar(20)=null,
@productname varchar(20)=null,
@startdate date=null,
@enddate date=null
as
begin
select o.orderid,o.orderdate,o.status,c.custname,c.city,p.productname,od.qty from orders as o
join Customers as c
on c.CustID=o.CustID
join OrderDetails as od
on od.OrderID=o.OrderID
join Products as p
on od.ProductID=p.ProductID
where(@customername is null or c.custname like '%' + @customername +'%')
and (@city is null or c.city like'%' +city + '%')
and(@productname is null or p.ProductName like '%'+@productname+'%')
and(@startdate is null or o.OrderDate>=@startdate)
and(@startdate is null or o.OrderDate<=@enddate)
end;


exec sp_searchorders @customername = 'amit';
exec sp_searchorders @city = 'mumbai', @startdate = '2025-01-01', @enddate = '2025-02-01';
exec sp_searchorders @productname = 'laptop';
exec sp_searchorders;  

-----------------------------------------trigger------------------------------------------

/**
1. Create a trigger on Products 
Prevent deletion of a product if it is part of any OrderDetails.
**/

create trigger tr_deletion on products
instead of delete
as 
begin
if exists(
select * from deleted as d 
join OrderDetails as od
on od.ProductID=d.ProductID
)
begin
throw 50003,'can not delete product becuase it part of orderdetails table ',1
return
end
delete p from Products as p
join deleted as d
on p.ProductID=d.ProductID
end

-- test

delete from products  where ProductID=101;

/*
2. Create an AFTER UPDATE trigger on Payments 
Log old and new payment values into a PaymentAudit table. 
*/

create trigger tr_after_update on payments
for update
as
begin
insert into paymentaudit(paymentid,amount_old,amount_new,changedat)
select d.paymentid,d.amount,i.amount,getdate() from deleted as d
join inserted as i  on d.PaymentID=i.PaymentID
end

----- test 

update Payments
set amount =amount+1000
where PaymentID=7002;

select * from paymentaudit;

/**
3. Create an INSTEAD OF DELETE trigger on Customers 
Logic: 
• If customer has orders → mark status as “Inactive” instead of deleting 
• If no orders → allow deletion
**/


create trigger tr_cust
on customers
instead of delete
as
begin
update Orders
set o.status='Inactive'
from Orders as o
join deleted as d
on o.CustID=d.CustID

delete Customers
from customers as c
join deleted as d
on c.CustID=d.CustID
where not exists 
(
select * from Orders as o where o.CustID=d.CustID
)
end;

delete from customers
where custid in(1,6);

select * from customers;










