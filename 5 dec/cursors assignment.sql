/**
1.Basic Cursor – Print All Employee Names 
Create a cursor on an Employees table to print each employee’s name one by one.
**/

select * from Employees;

declare @cname varchar(20)

declare cursor_name cursor for
select empname from Employees

open cursor_name
fetch next from cursor_name into @cname
print @cname
fetch next from cursor_name into @cname
print @cname
fetch next from cursor_name into @cname
print @cname
fetch next from cursor_name into @cname
print @cname
fetch next from cursor_name into @cname
print @cname
close cursor_name
deallocate cursor_name

/**2. Cursor to Update Salary 
Create a cursor that increases each employee’s salary by 10%. 
Update the table inside the cursor loop.
**/

declare @cname varchar(20)
declare @sal decimal(10,2)

declare emp_cursor cursor forward_only for
select empname,salary from employees

open emp_cursor
fetch next from emp_cursor into @cname,@sal
while @@FETCH_STATUS=0
begin
update employees set salary=salary+(salary*10)/100
where current of emp_cursor
print @cname + ' ' +cast(@sal as varchar)
fetch next from emp_cursor into @cname,@sal
end
close emp_cursor
deallocate emp_cursor

/**
3.Cursor with Conditional Logic 
Fetch all orders. 
While looping: 
• If quantity > 10 → give 5% discount 
• If quantity <= 10 → give 2% discount 
Update each order accordingly.
**/

select * from Orders;

declare @corderid int
declare @prod varchar(20)
declare @qt int
declare @pr float

declare Order_cursor cursor forward_only for
select orderid,product,qty,price from Orders

open Order_cursor
fetch next from Order_cursor into @corderid,@prod,@qt,@pr
while @@FETCH_STATUS=0
begin
if @qt>10
begin
update Orders
set price = price-(price*5)/100
end
else if @qt<=10
begin
update Orders
set price =price-(price*2)/100
end
fetch next from Order_cursor into @corderid,@prod,@qt,@pr
end
close Order_cursor
deallocate Order_cursor

/**
4.Cursor to Copy Data From One Table to Another 
Read records from OldProducts table using a cursor and insert them into NewProducts.
**/

select * from Products;

select * from newproduct;

declare @prdid int
declare @cid int
declare @cproduct varchar(20)

declare product_cursor cursor forward_only for
select productid,custid,product from Products

open product_cursor
fetch next from product_cursor into @prdid,@cid,@cproduct
while @@FETCH_STATUS=0
begin
insert into newproduct(productid,custid,product) values(@prdid,@cid,@cproduct)
fetch next from product_cursor into @prdid,@cid,@cproduct
end
close product_cursor
deallocate product_cursor

/**
5. Cursor to Delete Specific Rows 
Create a cursor that loops through customers. 
Delete customers whose LastOrderDate is more than 2 years old.
**/

