
/*
  This code is a working file used for everyday references.
  
  This code demonstrates how to generate a cursor
  
  The following code demonstrates SQL interpretations used in SQL Azure 2016.
  
  This is not a copy of any current implementation of any company.
*/

DECLARE @Id int
DECLARE @Guid uniqueidentifier


DECLARE db_cursor CURSOR FOR  

SELECT	I.Id,
		I.Guid
FROM	dbo.Demo I

OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @Id, @Guid  

WHILE @@FETCH_STATUS = 0   
BEGIN   
	-- Do something...


	FETCH NEXT FROM db_cursor INTO @Id, @Guid    
END   

CLOSE db_cursor   
DEALLOCATE db_cursor