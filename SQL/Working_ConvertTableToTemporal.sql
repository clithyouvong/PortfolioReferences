/*
  This code is a working file used for everyday references.
  
  This code demonstrates how to convert an existing Table to SQL Server Temporal
  
  The following code demonstrates SQL interpretations used in SQL Azure 2016.
  
  This is not a copy of any current implementation of any company.
*/


-- Step 1 Create the Columns
alter table dbo.Customer add SysDateStart datetime2(3) NULL;
alter table dbo.Customer add SysDateEnd datetime2(3) Null;

-- Step 2 Fill in the Values
UPDATE dbo.Customer SET SysDateStart = '19000101 00:00:00.0000000', SysDateEnd = '99991231 23:59:59.9999999'

-- Step 3 Make the columns not null
alter table dbo.Customer alter column SysDateStart datetime2(3) Not NULL;
alter table dbo.Customer alter column SysDateEnd datetime2(3) Not Null;

-- Step 4 Add the Period for System_Time
alter table dbo.Customer add Period for System_Time (SysDateStart, SysDateEnd)

-- Step 5 add the System Versioning
alter table dbo.Customer set(System_Versioning = On (History_Table = dbo.CustomerLog))

-- Step 6 Add the Hidden option
alter table dbo.Customer alter column SysDateStart add Hidden;
alter table dbo.Customer alter column SysDateEnd add Hidden;
