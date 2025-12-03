/**
1. Create a trigger for table customer, which does not allow 
the user to delete the record who stays in Bangalore, 
Chennai, delhi 
**/

create trigger tr_del_record on customers
after delete
as
if exists (select * from deleted where caddress in ('Bangalore','Chennai','Delhi'))
begin
print 'You can not delete record'
rollback transaction
end

delete from customers where caddress in ('Bangalore','Chennai','Delhi');

/**
2. Create a triggers for orders which allows the user to insert 
only books, cd, mobile  
**/

select * from Orders;

create trigger tr_insert on Orders
for insert
as
if not exists(select * from inserted where product in('books','cd','mobile'))
begin
print 'you can not insert other product. insert only books,cd,mobile'
rollback transaction
end

insert into Orders values(14,1008,'2023-12-01','books',345,2);

insert into Orders values(14,1008,'2023-12-01','notebook',345,2);

/**
3. Create a trigger for customer table whenever an item is 
delete from this table. The corresponding item should be 
added in customerhistory table. 
**/

select * from custhistory;
select * from customers;


create trigger tr_insertintocusthistoy on customers
for delete
as
begin
insert into custhistory
select * from deleted
end

delete from customers where custid=15;

/**
4. Create update trigger for stock. Display old values and new 
values
**/

create trigger tr_update on customers
for update
as
begin
select c.custid ,c.custname,c.age,c.caddress,c.cphone,
i.custid as newid,i.custname as newname,i.age as newage,i.caddress as newaddress,c.cphone
from customers as c
join inserted as i on c.custid=i.custid
end

select * from customers;

update customers 
set caddress ='chennai'
where custid=3;

/**
5. Create Instead Of Insert Trigger for Joined View (the user 
should able to insert record for 2 table using single insert 
command) Use following table 
 
**/
create table a 
( 
custid int, 
custname varchar(12) 
) 
 
create table b 
( 
custid int, 
product varchar(12) 
) 

create view testview 
as 
select a.* , b.product from a inner join b on a.custid = 
b.custid 
 
select * from testview


create trigger testview_insert on testview
instead of insert
as 
begin
insert into a(custid,custname)
select i.custid,i.custname from inserted as i
where not exists(select * from a where a.custid=i.custid)

insert into b(custid,product)
select i.custid,i.product from inserted as i
end

---- execute query

insert into testview (custid,custname,product)
values(1,'Pooja','Keyboard')

-- check all tables values inserted

select * from testview;
select * from a;
select * from b;