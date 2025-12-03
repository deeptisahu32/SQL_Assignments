--1. create a function to find the greatest of three numbers

alter function findgreatest(@a int,@b int,@c int)
returns int
as
begin 
declare @result int
if(@a>=@b and @a>=@c)
set @result=@a
else if(@b>=@a and @b>=@c)
set @result=@b
else
set @result=@c
return @result
end

select dbo.findgreatest(6,2,1) as greatestnum;

/**
2. create a function to calculate to discount of 10% on price on all 
the products
**/

select * from Orders;

alter function func_discount(@a int,@b int)
returns int
as
begin
declare @c int
set @c=@a-(@a*@b)/100
return @c
end

select custid,orderid,orderdate,product,price,qty,dbo.func_discount(price,10) as newprice from Orders

/**
3. create a function to calculate the discount on price as following 
if productname = 'books' then 10% 
if productname = toys then 15% 
else 
no discount
**/

alter function discountprice(@a decimal(10,2),@cproduct varchar(20))
returns decimal(10,2)
as
begin
declare @c int
if @cproduct = 'notebook'
set @c=@a-(@a*10)/100
else if @cproduct='toy'
set @c=@a-(@a*15)/100
else
set @c=@a
return @c
end

select * from Orders;

select custid,orderid,orderdate,product,price,dbo.discountprice(price,product) as discount_price from Orders;


/**
4. create inline function which accepts number and prints last n 
years of orders made from  now. 
(pass n as a parameter) 
**/
alter function fun_inline(@n int)
returns table
as
return
(
select * from Orders where orderdate>=Dateadd(year,-@n,getdate())
)

select * from fun_inline(1);