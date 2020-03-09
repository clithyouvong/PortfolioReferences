
/****** Object:  UserDefinedTableType [dbo].[ExpansiveGuid]    Script Date: 11/14/2017 11:26:13 AM ******/
CREATE TYPE [dbo].[ExpansiveGuid] AS TABLE(
	[guid1] [uniqueidentifier] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ExpansiveInt]    Script Date: 11/14/2017 11:26:13 AM ******/
CREATE TYPE [dbo].[ExpansiveInt] AS TABLE(
	[int1] [int] NOT NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ExpansiveNvarchar]    Script Date: 11/14/2017 11:26:13 AM ******/
CREATE TYPE [dbo].[ExpansiveNvarchar] AS TABLE(
	[nvarchar1] [nvarchar](528) NOT NULL
)
GO