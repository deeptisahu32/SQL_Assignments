

---- session 1  for 5th question
begin transaction
update test4 set cname='raj' where cid=2

---- session 2 for 6th question
begin transaction
update test4 set cname='raj' where cid=2
commit


-- SESSION 2
SELECT * FROM Sales2

BEGIN TRANSACTION
INSERT INTO Sales2 VALUES ('D', 200);   
COMMIT;
