/**
1. Basic Transaction — Commit / Rollback 
Create a table BankAccount with sample records. 
Write a transaction that transfers money from one account to another. 
If the source account balance becomes negative, roll back the transaction; otherwise 
commit.
**/

create table BankAccount(
userid int identity(1,1) primary key,
username varchar(20),
Balance Decimal(12,2) 
)
insert into Bankaccount values
('Shyam',120000),
('Rishi',130000)

select * from BankAccount;



Declare @amountforsend decimal(12,2)=30000
declare @SourceAccountid int=1
declare @TargetAccountid int=2
begin transaction
update BankAccount
set Balance= Balance-@amountforsend
where Userid=@SourceAccountid
update BankAccount
set Balance=Balance+@amountforsend
where Userid=@TargetAccountid

if(select Balance from BankAccount where userid=@SourceAccountid)<0
begin
print 'Insufficiant Balance'
Rollback Transaction
end
else
begin
print 'Transaction success'
commit transaction
end


/**
2. Using SAVEPOINT 
Insert three new records into a table Orders. 
Create a SAVEPOINT after each insert. 
Rollback only the second insert using the SAVEPOINT, then commit the remaining inserts.
**/

select * from Orders;

begin transaction
insert into Orders values(18,1012,'2022-11-02','books',120,3)
save transaction sp1
insert into Orders values(19,1013,'2022-12-02','mobile',10000,1)
save transaction sp2
insert into Orders values(20,1014,'2022-11-03','books',2300,2)
save transaction sp3

rollback transaction sp1
insert into Orders values(20,1014,'2022-11-03','books',2300,2)
save transaction sp
commit transaction;

/**
3. Handling Errors with TRY…CATCH 
Write a transaction that updates prices in a Products table. 
Introduce a division-by-zero error inside the transaction. 
Use TRY…CATCH to rollback the transaction and log the error message in a separate 
ErrorLog table
**/

select * from errorlog;

select * from purchase;

begin try
begin transaction
update purchase
set price =2000 where productid=1
declare @x int =1/0
commit transaction
end try
begin catch
rollback transaction
insert into errorlog(errordate,errormessage)
values(getdate(),error_message())
print 'Error occured rollback transaction.. insert error msg in error log table'
end catch;

/**
4. Nested Transactions 
Create nested transactions: 
• Outer transaction inserts a customer 
• Inner transaction inserts an order for the customer 
• Force an error in the inner transaction 
Practice observing whether the outer transaction is committed or rolled back.
**/

select * from customers1;
select * from Orders1;

begin transaction
insert into customers1 (customername)values('Ram')
declare  @customerid int = scope_identity()
  begin transaction
  begin try
  insert into Orders1(customerid,OrderAmount)values(@customerid,2300)

  declare @y int =1/0

  commit transaction
commit transaction
end try

begin catch
rollback transaction
print 'Rolled back the entire transaction due to inner error: ' + ERROR_MESSAGE();
end catch

/**
5.Isolation Level – Dirty Read 
Use two sessions: 
• Session 1: Open a transaction, update a row, but don’t commit 
• Session 2: Use SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED and read 
the same row 
Check whether dirty reads are allowed.
**/

create table test4 (cid int,cname varchar(20));
insert into test4 values(2,'ram')

select * from test4;

-- session 2

set transaction isolation level read uncommitted
select * from test4 where cid=2
waitfor delay '00:00:10'
select * from test4 where cid=2;



/**
6. Isolation Level – Non-repeatable Read 
Using two sessions: 
• Session 1 reads a row twice inside a transaction 
• Session 2 updates and commits the same row in between 
Observe changes and understand non-repeatable reads.
**/

-- session 1

set transaction isolation level read committed
select * from test4 where cid=2
waitfor delay '00:00:10'
select * from test4 where cid=2;


/**
7. Isolation Level – Phantom Read 
Create a table Sales. 
Using two sessions:
• Session 1 selects rows between a range inside a transaction 
• Session 2 inserts a new row within the range and commits 
See if the first session sees new rows depending on isolation level. 
**/


-- Create table and insert data
CREATE TABLE Sales2 (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    Customer NVARCHAR(50),
    Amount INT
);

INSERT INTO Sales2 (Customer, Amount) VALUES
('A', 100), ('B', 300), ('C', 600);


-- SESSION 1
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION;
-- First range read (expect A=100, B=300)
SELECT SaleID, Customer, Amount
FROM Sales2
WHERE Amount BETWEEN 100 AND 500
ORDER BY SaleID;
WAITFOR DELAY '00:00:10';

-- Second range read (after Session 2 commit, expect A, B, and D=200)
SELECT SaleID, Customer, Amount
FROM Sales2
WHERE Amount BETWEEN 100 AND 500
ORDER BY SaleID;
COMMIT TRANSACTION;

/**
8.Savepoint with Partial Rollback 
Inside a transaction: 
• Update 5 employee salaries 
• Create a savepoint after each update 
• Rollback to savepoint 3 
• Commit the rest 
Check which rows were updated finally.
**/


CREATE TABLE dbo.Employees1 (
    EmpID INT PRIMARY KEY,
    EmpName NVARCHAR(50),
    Salary INT
);

INSERT INTO dbo.Employees1 (EmpID, EmpName, Salary) VALUES
(1, 'Asha', 30000),
(2, 'Bala', 32000),
(3, 'Charan', 35000),
(4, 'Divya', 34000),
(5, 'Eshan', 36000);


-- Transaction with savepoints and partial rollback
BEGIN TRAN;

UPDATE dbo.Employees SET Salary = Salary + 1000 WHERE EmpID = 1;
SAVE TRAN sp1;

UPDATE dbo.Employees SET Salary = Salary + 1000 WHERE EmpID = 2;
SAVE TRAN sp2;

UPDATE dbo.Employees SET Salary = Salary + 1000 WHERE EmpID = 3;
SAVE TRAN sp3;

UPDATE dbo.Employees SET Salary = Salary + 1000 WHERE EmpID = 4;
SAVE TRAN sp4;

UPDATE dbo.Employees SET Salary = Salary + 1000 WHERE EmpID = 5;
SAVE TRAN sp5;

-- Roll back to savepoint 3 → undo changes AFTER sp3 
ROLLBACK TRAN sp3;

COMMIT;

-- Final check
SELECT EmpID, EmpName, Salary FROM dbo.Employees ORDER BY EmpID;

/**
9.Insert multiple product records using a single transaction. 
Force an error in one insert (duplicate key or null value). 
Ensure that no records are inserted into the table.
**/


CREATE TABLE Products1 (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL
);


BEGIN TRY
    BEGIN TRAN;

    INSERT INTO dbo.Products1 (ProductID, ProductName, Price)
    VALUES (1, 'Laptop', 75000.00);

    INSERT INTO dbo.Products1 (ProductID, ProductName, Price)
    VALUES (2, 'Phone', 35000.00);

    -- Force error: duplicate ProductID (PRIMARY KEY violation)
    INSERT INTO dbo.Products1 (ProductID, ProductName, Price)
    VALUES (1, 'Tablet', 25000.00);

COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK;
    -- Optional: show error details
    SELECT ERROR_NUMBER() AS ErrNo, ERROR_MESSAGE() AS ErrMsg;
END CATCH;

-- Verify: should be empty
SELECT * FROM dbo.Products;

/**
10.Savepoint in TRY…CATCH 
Inside a long transaction: 
• Insert 3 orders 
• Savepoint after each 
• Force an error before the third insert 
Use savepoint rollback to keep first 2 inserts.
**/


CREATE TABLE Orders2 (
    OrderID INT PRIMARY KEY,
    Customer NVARCHAR(50) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL
);

SELECT * FROM Orders2;


BEGIN TRY
    BEGIN TRAN;

    INSERT INTO Orders2 (OrderID, Customer, Amount)
    VALUES (101, 'Asha', 1500.00);
    SAVE TRANSACTION sp1;

    INSERT INTO Orders2 (OrderID, Customer, Amount)
    VALUES (102, 'Bala', 2750.00);
    SAVE TRANSACTION sp2;
   

    INSERT INTO Orders2 (OrderID, Customer, Amount)
    VALUES (103, NULL, 3200.00);  
COMMIT;  
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION sp2;  
        COMMIT;                   
    END
    SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
END CATCH;

SELECT * FROM Orders2 ORDER BY OrderID;






