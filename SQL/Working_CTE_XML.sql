
/*
  This code is a working file used for everyday references.
  
  This code demonstrates how to generate an XML file using CTEs
  
  The following code demonstrates SQL interpretations used in SQL Azure 2016.
  
  This is not a copy of any current implementation of any company.
*/


declare @SomeIdentifier nvarchar(40) = '173874fe-2efe-4b37-b934-c5158e1365a8';
declare @AnotherIdentifier nvarchar(200) = '9c22c2c80e58d079bb77848f866274920224e51e7891eb924cc72284189fb167';

With [File] As (
	Select	Distinct top 5 F.FileId,
			F.[Filename],
			F.FilePath,
			F.FileUrl
	From	dbo.[File] F
	Where	F.SomeIdentifier = @SomeIdentifier and 
			F.AnotherIdentifier = @AnotherIdentifier 
)
Select	[File].FileId,
		[File].[FileName],
		[File].FilePath,
		[File].FileUrl
From	[File] as [File]
For XML auto, root('Files');