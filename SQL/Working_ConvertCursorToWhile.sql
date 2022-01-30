/*
  This code is a working file used for everyday references.
  
  This code demonstrates how a Cursor could be implemented as a while loop.
  
  The following code demonstrates SQL interpretations used in SQL Azure 2016.
  
  This is not a copy of any current implementation of any company.
*/


Declare @Cursor_CustomerID int;
Declare @Cursor_FirstName nvarchar(30);
Declare @Cursor_LastName nvarchar(30);
Declare @Cursor_NumberRecords int;
Declare @Cursor_RowCount int;

-- Insert the resultset we want to loop through
-- into the temporary table
Declare @Cursor_Table table (
	 RowID int identity(1, 1), 
	 CustomerID int,
	 FirstName nvarchar(30),
	 LastName nvarchar(30)
);
Insert into @Cursor_Table (CustomerID, FirstName, LastName)
Select	CustomerID, 
		FirstName, 
		LastName
From	dbo.Customer
Where	Active = 1; 

-- Get the number of records in the temporary table
Select @Cursor_NumberRecords = @@ROWCOUNT;
Select @Cursor_RowCount = 1;

-- loop through all records in the temporary table
-- using the WHILE loop construct
While @Cursor_RowCount <= @Cursor_NumberRecords
Begin
	Select  @Cursor_CustomerID = CustomerID, 
			@Cursor_FirstName = FirstName, 
			@Cursor_LastName = LastName 
	From	@Cursor_Table
	Where	RowID = @Cursor_RowCount;

	/* Do Something */

	Select @Cursor_RowCount = @Cursor_RowCount + 1;
End
