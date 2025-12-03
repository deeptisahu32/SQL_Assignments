/**
1. Create a procedure which accepts input parameter and inserts the 
data in the customer table. 
**/

create table customer
(
custid int identity(1,1),
custname varchar(20),
custage int,
address varchar(20)
)

create procedure valueinsert(@cname varchar(20),@cage int,@caddress varchar(20))
as
insert into customer values(@cname,@cage,@caddress)
return scope_identity()

declare @values int
exec @values=valueinsert 'Deep',23,'Chennai'
exec @values=valueinsert 'Depali',22,'Kanpur'
print @values

select * from customer;

/**
2.  Create a procedure for orders table , which displays all the purchase 
made between  1-12-2005  and 2-12-2007 
(Accept date as parameter_)
**/

select * from Orders;

create procedure sp_orders(@a date, @b date)
as
select * from Orders
where orderdate between @a and @b

sp_Orders '2005-12-1','2007-12-2'


/**
3. create a procedure which reads custid as parameter  
and return qty and produtid as output parameter
**/

select * from Orders;
select * from Products;

alter procedure read_custid (@id int,@cqty int output,@cpid int output)
as
select @cqty=o.qty,@cpid=p.productid
from Orders as o
join Products as p
on o.custid=p.custid
where o.custid=@id

declare @qty int
declare @pid int
exec read_custid 1,@qty output,@pid output
print @qty
print @pid

/**
4. Write a batch that will check for the existence of the productname 
“books” if it exists, display the total stock of the book else print  
“productname books not found”.
**/

select * from Products;

alter procedure checkproduct(@book varchar(20))
as
begin
if exists (select product from Products where product=@book)
print 'yes'
else
print 'productname books not found'
end

checkproduct 'notebook'
checkproduct 'book'


/**
5.insert  data to customer table via return value of sp_getdata() 
procedure
**/

select * from customers;

select * into custnewtable from customers;

select * from custnewtable;

create procedure sp_getdata
as
select * from customers;

insert into custnewtable exec sp_getdata

select * from custnewtable;

/**
6. Create a procedure to display all customer details where rownumber 
between 2 to 5 (accept row number as a parameter)
**/

create procedure display_cust(@startrn int,@lastrn int)
as
with cte1 as (
select *,row_number()over(order by age desc) as rn from customers
)
select rn from cte1
where rn between @startrn and @lastrn

exec display_cust 2,5;

/**
7.Create a stored procedure to insert a new employee 
Create a table Employees and write a stored procedure: 
• Procedure name: spAddEmployee 
• Inputs: Name, Department, Salary 
• Insert the record into Employees table. 
• Return newly generated CustomerID using SCOPE_IDENTITY().
**/

create table Employee1
(
empid int identity(1,1),
Name varchar(20),
Department varchar(20),
Salary decimal(10,2)
)

create procedure spAddEmployee(@ename varchar(20),@cdepartment varchar(20),@cSalary decimal(10,2))
as
insert into Employee1 values(@ename,@cdepartment,@cSalary)
return scope_identity()

declare @result int
exec @result=spAddEmployee 'Deep','HR',23000
print @result

select * from employee1;


/**
8.Create a stored procedure with default parameter 
Create spGetProductsByCategory 
• Parameter: CategoryName (default should be ‘Electronics’) 
• Return all products of that category. 
• Create Procedure WITH ENCRYPTION
**/

alter procedure spGetProductsByCategory(@CategoryName varchar(20)='Electronics')
with encryption
as
begin
select * from Products
where product=@CategoryName
end

exec spGetProductsByCategory;

/**
9. Stored procedure using TRY…CATCH 
Create spSafeOrderInsert 
• Insert a new order 
• If any error occurs, insert error details into an ErrorLog table 
**/

select * from Orders;

create table errorlog (
    errorid int identity(1,1) primary key,
    errordate datetime not null,
    errormessage nvarchar(4000) not null
);
select * from errorlog;

alter procedure spSafeOrderInsert 
(@custid int,@orderid int,@orderdate date,@product varchar(20),@price float,@qty int)
as
begin
begin try
insert into Orders values(@custid,@orderid,@orderdate,@product,@price,@qty)
print 'values inserted in table'
end try
begin catch
insert into errorlog(errordate,errormessage)
values(getdate(),error_message())
print 'error occured . msg insert into log table'
end catch
end

exec spSafeOrderInsert 13,1007,'2025-12-01','keyboard',2

create table ErrorLog ( ErrorID int identity(1,1) primary key, ErrorMessage varchar(1000), ErrorNumber int, ErrorLine int, ErrorDate datetime default getdate() ) 
create procedure spSafeOrderInsert (@custid int,@orderid int,@orderdate date,@qty int,@prod_id int) as  
begin  
begin try  
insert into orders values(@custid,@orderid,@orderdate,@qty,@prod_id)  
end try  
begin catch  
insert into ErrorLog (ErrorMessage, ErrorNumber, ErrorLine) values (error_message(),error_number(),error_line())  
print 'error occured'  
end catch  
end 
EXEC spSafeOrderInsert 110, 1010, '2024-12-01', 5, 202;  
EXEC spSafeOrderInsert 110, 1010;  
select * from ErrorLog 

/**
10.Stored procedure with multiple operations 
Create spUpdateSalary 
• Inputs: EmpID, Percentage 
• Increase employee salary by given percentage 
• Return updated salary
**/

select * from Employees;

create procedure spUpdateSalary(@Empid int,@percentage int)
as
update Employees set Salary=Salary+Salary*@percentage/100
where EmpId=@Empid

exec spUpdateSalary 1,10;
