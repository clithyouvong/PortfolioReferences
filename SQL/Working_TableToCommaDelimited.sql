/*
  This code is a working file used for everyday references.
  
  This code demonstrates how to create a comma delimited scalar nvarchar without the use of STRING_AGG in SQL 
  
  The following code demonstrates SQL interpretations used in SQL Azure 2016.
  
  This is not a copy of any current implementation of any company.
*/

Declare @Guid uniqueidentifier;

Select RTRIM(
          LTRIM(
              STUFF(
                (
                  SELECT  ', ' + R.Reference 
                  From    dbo.Reference R 
                  Where   R.ReferenceParentGuid=@Guid 
                          AND R.ReferenceSubParentGuid=R.ReferenceGuid
                          AND R.[Application] = 'SomeApplication'
                  Order by T.Tag
                  FOR XML PATH(''), TYPE
                ).value('.[1]','nvarchar(max)'),
                1,1,''
              )
           )
        )  AS ReferenceList
