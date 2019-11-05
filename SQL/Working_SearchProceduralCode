/*
  This code is a working file used for everyday references.
  
  This code searches SQL to identify any Procedure, View, Trigger, or Function based on Text. 
  
  The following code demonstrates SQL interpretations used in SQL Azure 2016.
  
  This is not a copy of any current implementation of any company.
*/

SELECT DISTINCT
       o.name AS Object_Name,
       o.type_desc
FROM   sys.sql_modules m
       INNER JOIN sys.objects o ON m.object_id = o.object_id
WHERE  m.definition Like '%[something]%' ESCAPE '\'
