/*
  This is the Standard Operating Procedures (SOP) System used to simulate a centralized repository for procedures using SQL as the backend controlling versioning.
  
  The following code demonstrates SQL interpretations used in SQL Azure 2016.
  
  This is not a copy of any current implementation of any company but rather a demonstration of how things 
  were initially scaffolded during the design phrase.
  
  Schema: dbo
  Architecture / Structure:
    - SOPProcedure - represents the procedure
    - SOPCategory - defines the procedure's characteristics
    - SOPDocument - defines any files associated to a specific procedure
  
  Implementation:
    - N/A
    
  Dependencies:
    - N/A
*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Table [dbo].[SOPProcedure]  (
	[ProcedureId] int Not Null Primary Key Identity(1,1),
	[Procedure] nvarchar(528) Not Null,
	[Status] nvarchar(50) Not Null Default N'Active',
	[Description] nvarchar(max) Null Default N'',
	[Body01] nvarchar(max) Null Default N'',
	[Body02] nvarchar(max) Null Default N'',
	[Body03] nvarchar(max) Null Default N'',
	[Body04] nvarchar(max) Null Default N'',
	[Body05] nvarchar(max) Null Default N'',
	[Body06] nvarchar(max) Null Default N'',
	[Body07] nvarchar(max) Null Default N'',
	[Body08] nvarchar(max) Null Default N'',
	[Body09] nvarchar(max) Null Default N'',
	[Body10] nvarchar(max) Null Default N'',
	[Body11] nvarchar(max) Null Default N'',
	[Body12] nvarchar(max) Null Default N'',
	[Body13] nvarchar(max) Null Default N'',
	[Body14] nvarchar(max) Null Default N'',
	[Body15] nvarchar(max) Null Default N'',
	[Body16] nvarchar(max) Null Default N'',
	[Body17] nvarchar(max) Null Default N'',
	[Body18] nvarchar(max) Null Default N'',
	[Body19] nvarchar(max) Null Default N'',
	[Body20] nvarchar(max) Null Default N'',
	[DateCreated] datetime Null Default GETDATE(),
	[DateCreatedBy] int Null Default -1,
	[DateUpdated] datetime Null Default GETDATE(),
	[DateUpdatedBy] int Null Default -1
)
GO

	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO

	Create Table [dbo].[SOPProcedureLog]  (
		[ProcedureLogId] int Not Null Primary Key Identity(1,1),
		[ProcedureId] int Null,
		[Procedure] nvarchar(528) Null,
		[Status] nvarchar(50) Null,
		[Description] nvarchar(max) Null,
		[Body01] nvarchar(max) Null,
		[Body02] nvarchar(max) Null,
		[Body03] nvarchar(max) Null,
		[Body04] nvarchar(max) Null,
		[Body05] nvarchar(max) Null,
		[Body06] nvarchar(max) Null,
		[Body07] nvarchar(max) Null,
		[Body08] nvarchar(max) Null,
		[Body09] nvarchar(max) Null,
		[Body10] nvarchar(max) Null,
		[Body11] nvarchar(max) Null,
		[Body12] nvarchar(max) Null,
		[Body13] nvarchar(max) Null,
		[Body14] nvarchar(max) Null,
		[Body15] nvarchar(max) Null,
		[Body16] nvarchar(max) Null,
		[Body17] nvarchar(max) Null,
		[Body18] nvarchar(max) Null,
		[Body19] nvarchar(max) Null,
		[Body20] nvarchar(max) Null,
		[DateCreated] datetime Null,
		[DateCreatedBy] int Null,
		[DateUpdated] datetime Null,
		[DateUpdatedBy] int Null,
		[DateLogged] datetime NULL Default GETDATE(),
		[LoggedEvent] nvarchar(50) Null
	)
	GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Table [dbo].[SOPCategory] (
	[CategoryId] int Not Null Primary Key Identity(1,1),
	[ProcedureId] int Not Null Foreign Key References [dbo].[SOPProcedure]([ProcedureId]),
	[ParentId] int Null Foreign Key References [dbo].[SOPCategory]([CategoryId]),
	[Category] nvarchar(528) Not Null,
	[Status] nvarchar(50) Not Null Default N'Active',
	[DateCreated] datetime Null Default GETDATE(),
	[DateCreatedBy] int Null Default -1,
	[DateUpdated] datetime Null Default GETDATE(),
	[DateUpdatedBy] int Null Default -1
)
GO

	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	Create Table [dbo].[SOPCategoryLog] (
		[CategoryLogId] int Not Null Primary Key Identity(1,1),
		[CategoryId] int Null,
		[ProcedureId] int Null,
		[ParentId] int Null,
		[Category] nvarchar(528) Null,
		[Status] nvarchar(50) Null,
		[DateCreated] datetime null,
		[DateCreatedBy] int Null,
		[DateUpdated] datetime Null,
		[DateUpdatedBy] int Null,
		[DateLogged] datetime NULL Default GETDATE(),
		[LoggedEvent] nvarchar(50) Null
	)
	GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Table [dbo].[SOPDocument] (
	[DocumentId] int Not Null Primary Key Identity(1,1),
	[ProcedureId] int Not Null Foreign Key References [dbo].[SOPProcedure]([ProcedureId]),
	[Document] nvarchar(528) Not Null,
	[DocumentMode] nvarchar(50) Not Null,
	[DocumentAddress] nvarchar(128) Not Null,
	[DocumentFileName] nvarchar(128) Not Null,
	[Status] nvarchar(50) Not Null Default N'Active',
	[DateCreated] datetime Null Default GETDATE(),
	[DateCreatedBy] int Null Default -1,
	[DateUpdated] datetime Null Default GETDATE(),
	[DateUpdatedBy] int Null Default -1
)
GO

	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	Create Table [dbo].[SOPDocumentLog] (
		[DocumentLogId] int Not Null Primary Key Identity(1,1),
		[DocumentId] int Null,
		[ProcedureId] int Null,
		[Document] nvarchar(528) Null,
		[DocumentMode] nvarchar(50) Null,
		[DocumentAddress] nvarchar(128) Null,
		[DocumentFileName] nvarchar(128) Null,
		[Status] nvarchar(50) Null,
		[DateCreated] datetime Null,
		[DateCreatedBy] int Null,
		[DateUpdated] datetime Null,
		[DateUpdatedBy] int Null,
		[DateLogged] datetime NULL Default GETDATE(),
		[LoggedEvent] nvarchar(50) Null
	)
	GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Colby Lithyouvong
-- Create date: 2018 Sept
-- =============================================
CREATE TRIGGER [dbo].[SOPProcedure_Log] on [dbo].[SOPProcedure] for insert,update,delete 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @LoggedType nvarchar(50) = ''

	Select @LoggedType = 
		(CASE 
			WHEN EXISTS(SELECT * FROM INSERTED) AND EXISTS(SELECT * FROM DELETED)
				THEN 'Updated'  -- Set Action to Updated.
            WHEN EXISTS(SELECT * FROM INSERTED)
				THEN 'Inserted'  -- Set Action to Insert.
            WHEN EXISTS(SELECT * FROM DELETED)
				THEN 'Deleted'  -- Set Action to Deleted.
            ELSE NULL -- Skip. It may have been a "failed delete".   
        END)

	if(exists(select * from inserted))
	BEGIN		
		INSERT INTO [dbo].[SOPProcedureLog](
			--[ProcedureLogId],
			[ProcedureId],
			[Procedure],
			[Status],
			[Description],
			[Body01],
			[Body02],
			[Body03],
			[Body04],
			[Body05],
			[Body06],
			[Body07],
			[Body08],
			[Body09],
			[Body10],
			[Body11],
			[Body12],
			[Body13],
			[Body14],
			[Body15],
			[Body16],
			[Body17],
			[Body18],
			[Body19],
			[Body20],
			[DateCreated],
			[DateCreatedBy],
			[DateUpdated],
			[DateUpdatedBy],
			[DateLogged],
			[LoggedEvent]
		   )
		SELECT 
            --[ProcedureLogId],
			[ProcedureId],
			[Procedure],
			[Status],
			[Description],
			[Body01],
			[Body02],
			[Body03],
			[Body04],
			[Body05],
			[Body06],
			[Body07],
			[Body08],
			[Body09],
			[Body10],
			[Body11],
			[Body12],
			[Body13],
			[Body14],
			[Body15],
			[Body16],
			[Body17],
			[Body18],
			[Body19],
			[Body20],
			[DateCreated],
			[DateCreatedBy],
			[DateUpdated],
			[DateUpdatedBy],
            GETDATE(),
            @LoggedType
		from	inserted i
	end
	else if(exists(select * from deleted))
	begin
		INSERT INTO [dbo].[SOPProcedureLog](
			--[ProcedureLogId],
			[ProcedureId],
			[Procedure],
			[Status],
			[Description],
			[Body01],
			[Body02],
			[Body03],
			[Body04],
			[Body05],
			[Body06],
			[Body07],
			[Body08],
			[Body09],
			[Body10],
			[Body11],
			[Body12],
			[Body13],
			[Body14],
			[Body15],
			[Body16],
			[Body17],
			[Body18],
			[Body19],
			[Body20],
			[DateCreated],
			[DateCreatedBy],
			[DateUpdated],
			[DateUpdatedBy],
			[DateLogged],
			[LoggedEvent]
		   )
		SELECT 
            --[ProcedureLogId],
			[ProcedureId],
			[Procedure],
			[Status],
			[Description],
			[Body01],
			[Body02],
			[Body03],
			[Body04],
			[Body05],
			[Body06],
			[Body07],
			[Body08],
			[Body09],
			[Body10],
			[Body11],
			[Body12],
			[Body13],
			[Body14],
			[Body15],
			[Body16],
			[Body17],
			[Body18],
			[Body19],
			[Body20],
			[DateCreated],
			[DateCreatedBy],
			[DateUpdated],
			[DateUpdatedBy],
            GETDATE(),
            @LoggedType
		   from	deleted d
	end	
END
Go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Colby Lithyouvong
-- Create date: 2018 Sept
-- =============================================
CREATE TRIGGER [dbo].[SOPCategory_Log] on [dbo].[SOPCategory] for insert,update,delete 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @LoggedType nvarchar(50) = ''

	Select @LoggedType = 
		(CASE 
			WHEN EXISTS(SELECT * FROM INSERTED) AND EXISTS(SELECT * FROM DELETED)
				THEN 'Updated'  -- Set Action to Updated.
            WHEN EXISTS(SELECT * FROM INSERTED)
				THEN 'Inserted'  -- Set Action to Insert.
            WHEN EXISTS(SELECT * FROM DELETED)
				THEN 'Deleted'  -- Set Action to Deleted.
            ELSE NULL -- Skip. It may have been a "failed delete".   
        END)

	if(exists(select * from inserted))
	BEGIN		
		INSERT INTO [dbo].[SOPCategoryLog](
			--[CategoryLogId],
			[CategoryId],
			[ProcedureId],
			[ParentId],
			[Category],
			[Status],
			[DateCreated],
			[DateCreatedBy],
			[DateUpdated],
			[DateUpdatedBy],
			[DateLogged],
			[LoggedEvent]
		)
		SELECT 
			--[CategoryLogId],
			[CategoryId],
			[ProcedureId],
			[ParentId],
			[Category],
			[Status],
			[DateCreated],
			[DateCreatedBy],
			[DateUpdated],
			[DateUpdatedBy],
            GETDATE(),
            @LoggedType
		from	inserted i
	end
	else if(exists(select * from deleted))
	begin
		INSERT INTO [dbo].[SOPCategoryLog](
			--[CategoryLogId],
			[CategoryId],
			[ProcedureId],
			[ParentId],
			[Category],
			[Status],
			[DateCreated],
			[DateCreatedBy],
			[DateUpdated],
			[DateUpdatedBy],
			[DateLogged],
			[LoggedEvent]
		)
		SELECT 
			--[CategoryLogId],
			[CategoryId],
			[ProcedureId],
			[ParentId],
			[Category],
			[Status],
			[DateCreated],
			[DateCreatedBy],
			[DateUpdated],
			[DateUpdatedBy],
            GETDATE(),
            @LoggedType
		   from	deleted d
	end	
END
Go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Colby Lithyouvong
-- Create date: 2018 Sept
-- =============================================
CREATE TRIGGER [dbo].[SOPDocument_Log] on [dbo].[SOPDocument] for insert,update,delete 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @LoggedType nvarchar(50) = ''

	Select @LoggedType = 
		(CASE 
			WHEN EXISTS(SELECT * FROM INSERTED) AND EXISTS(SELECT * FROM DELETED)
				THEN 'Updated'  -- Set Action to Updated.
            WHEN EXISTS(SELECT * FROM INSERTED)
				THEN 'Inserted'  -- Set Action to Insert.
            WHEN EXISTS(SELECT * FROM DELETED)
				THEN 'Deleted'  -- Set Action to Deleted.
            ELSE NULL -- Skip. It may have been a "failed delete".   
        END)

	if(exists(select * from inserted))
	BEGIN		
		INSERT INTO [dbo].[SOPDocumentLog](
			--[DocumentLogId],
			[DocumentId],
			[ProcedureId],
			[Document],
			[DocumentMode],
			[DocumentAddress],
			[DocumentFileName],
			[Status],
			[DateCreated],
			[DateCreatedBy],
			[DateUpdated],
			[DateUpdatedBy],
			[DateLogged],
			[LoggedEvent]
		)
		SELECT 
			--[DocumentLogId],
			[DocumentId],
			[ProcedureId],
			[Document],
			[DocumentMode],
			[DocumentAddress],
			[DocumentFileName],
			[Status],
			[DateCreated],
			[DateCreatedBy],
			[DateUpdated],
			[DateUpdatedBy],
            GETDATE(),
            @LoggedType
		from	inserted i
	end
	else if(exists(select * from deleted))
	begin
		INSERT INTO [dbo].[SOPDocumentLog](
			--[DocumentLogId],
			[DocumentId],
			[ProcedureId],
			[Document],
			[DocumentMode],
			[DocumentAddress],
			[DocumentFileName],
			[Status],
			[DateCreated],
			[DateCreatedBy],
			[DateUpdated],
			[DateUpdatedBy],
			[DateLogged],
			[LoggedEvent]
		)
		SELECT 
			--[DocumentLogId],
			[DocumentId],
			[ProcedureId],
			[Document],
			[DocumentMode],
			[DocumentAddress],
			[DocumentFileName],
			[Status],
			[DateCreated],
			[DateCreatedBy],
			[DateUpdated],
			[DateUpdatedBy],
            GETDATE(),
            @LoggedType
		   from	deleted d
	end	
END
Go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Colby Lithyouvong
-- Create Date: 2018 Sept
-- =============================================
CREATE PROCEDURE [dbo].[SOPProcedure_Modify]
(
	@Mode nvarchar(50) null,
	@PassportIndividualId int null,

	@ProcedureId int = null,
	@Procedure nvarchar(max) = null,
	@Status nvarchar(max) = null,
	@Description nvarchar(max) = null,
	@Body01 nvarchar(max) = null,
	@Body02 nvarchar(max) = null,
	@Body03 nvarchar(max) = null,
	@Body04 nvarchar(max) = null,
	@Body05 nvarchar(max) = null,
	@Body06 nvarchar(max) = null,
	@Body07 nvarchar(max) = null,
	@Body08 nvarchar(max) = null,
	@Body09 nvarchar(max) = null,
	@Body10 nvarchar(max) = null,
	@Body11 nvarchar(max) = null,
	@Body12 nvarchar(max) = null,
	@Body13 nvarchar(max) = null,
	@Body14 nvarchar(max) = null,
	@Body15 nvarchar(max) = null,
	@Body16 nvarchar(max) = null,
	@Body17 nvarchar(max) = null,
	@Body18 nvarchar(max) = null,
	@Body19 nvarchar(max) = null,
	@Body20 nvarchar(max) = null
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	------------------------------
	-- @Mode Procedure_Insert
	------------------------------
	If (@Mode = 'Procedure_Insert')
	Begin
		Insert Into [dbo].[SOPProcedure] (
			--[ProcedureId],
			[Procedure],
			[Status],
			[Description],
			[Body01],
			[Body02],
			[Body03],
			[Body04],
			[Body05],
			[Body06],
			[Body07],
			[Body08],
			[Body09],
			[Body10],
			[Body11],
			[Body12],
			[Body13],
			[Body14],
			[Body15],
			[Body16],
			[Body17],
			[Body18],
			[Body19],
			[Body20],
			[DateCreated],
			[DateCreatedBy],
			[DateUpdated],
			[DateUpdatedBy]
		)
		Values (
			--@ProcedureId,
			@Procedure,
			@Status,
			@Description,
			@Body01,
			@Body02,
			@Body03,
			@Body04,
			@Body05,
			@Body06,
			@Body07,
			@Body08,
			@Body09,
			@Body10,
			@Body11,
			@Body12,
			@Body13,
			@Body14,
			@Body15,
			@Body16,
			@Body17,
			@Body18,
			@Body19,
			@Body20,
			GETDATE(),
			@PassportIndividualId,
			GETDATE(),
			@PassportIndividualId
		)
	End

	
	------------------------------
	-- @Mode Procedure_Update
	------------------------------
	If (@Mode = 'Procedure_Update')
	Begin
		Update [dbo].[SOPProcedure]
		Set
				[SOPProcedure].[Procedure] = @Procedure,
				[SOPProcedure].[Status] = @Status,
				[SOPProcedure].[Description] = @Description,
				[SOPProcedure].[Body01] = @Body01,
				[SOPProcedure].[Body02] = @Body02,
				[SOPProcedure].[Body03] = @Body03,
				[SOPProcedure].[Body04] = @Body04,
				[SOPProcedure].[Body05] = @Body05,
				[SOPProcedure].[Body06] = @Body06,
				[SOPProcedure].[Body07] = @Body07,
				[SOPProcedure].[Body08] = @Body08,
				[SOPProcedure].[Body09] = @Body09,
				[SOPProcedure].[Body10] = @Body10,
				[SOPProcedure].[Body11] = @Body11,
				[SOPProcedure].[Body12] = @Body12,
				[SOPProcedure].[Body13] = @Body13,
				[SOPProcedure].[Body14] = @Body14,
				[SOPProcedure].[Body15] = @Body15,
				[SOPProcedure].[Body16] = @Body16,
				[SOPProcedure].[Body17] = @Body17,
				[SOPProcedure].[Body18] = @Body18,
				[SOPProcedure].[Body19] = @Body19,
				[SOPProcedure].[Body20] = @Body20,
				[SOPProcedure].[DateUpdated] = GETDATE(),
				[SOPProcedure].[DateUpdatedBy] = @PassportIndividualId
		Where	[SOPProcedure].[ProcedureId] = @ProcedureId
	End

	
	------------------------------
	-- @Mode Procedure_Delete
	------------------------------
	If (@Mode = 'Procedure_Delete')
	Begin
		Delete  From [dbo].[SOPProcedure]
		Where	[SOPProcedure].[ProcedureId] = @ProcedureId
	End
END
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Colby Lithyouvong
-- Create Date: 2018 Sept
-- =============================================
CREATE PROCEDURE [dbo].[SOPCategory_Modify]
(
	@Mode nvarchar(50) null,
	@PassportIndividualId int null,

	@CategoryId int = null,
	@ProcedureId int = null,
	@ParentId int = null,
	@Category nvarchar(max) = null,
	@Status nvarchar(max) = null
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	------------------------------
	-- @Mode Category_Insert
	------------------------------
	If (@Mode = 'Category_Insert')
	Begin
		Insert Into [dbo].[SOPCategory] (
			--[CategoryId],
			[ProcedureId],
			[ParentId],
			[Category],
			[Status],
			[DateCreated],
			[DateCreatedBy],
			[DateUpdated],
			[DateUpdatedBy]
		)
		Values (
			--@CategoryId,
			@ProcedureId,
			@ParentId,
			@Category,
			@Status,
			GETDATE(),
			@PassportIndividualId,
			GETDATE(),
			@PassportIndividualId
		)
	End

	
	------------------------------
	-- @Mode Category_Update
	------------------------------
	If (@Mode = 'Category_Update')
	Begin
		Update [dbo].[SOPCategory]
		Set
				[SOPCategory].[ProcedureId] = @ProcedureId,
				[SOPCategory].[ParentId] = @ParentId,
				[SOPCategory].[Category] = @Category,
				[SOPCategory].[Status] = @Status,
				[SOPCategory].[DateUpdated] = GETDATE(),
				[SOPCategory].[DateUpdatedBy] = @PassportIndividualId
		Where	[SOPCategory].[CategoryId] = @CategoryId
	End

	
	------------------------------
	-- @Mode Category_Delete
	------------------------------
	If (@Mode = 'Category_Delete')
	Begin
		Delete  From [dbo].[SOPCategory]
		Where	[SOPCategory].[CategoryId] = @CategoryId
	End
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Colby Lithyouvong
-- Create Date: 2018 Sept
-- =============================================
CREATE PROCEDURE [dbo].[SOPDocument_Modify]
(
	@Mode nvarchar(50) null,
	@PassportIndividualId int null,

	@DocumentId int = null,
	@ProcedureId int = null,
	@Document nvarchar(max) = null,
	@DocumentMode nvarchar(max) = null,
	@DocumentAddress nvarchar(max) = null,
	@DocumentFileName nvarchar(max) = null,
	@Status nvarchar(max) = null
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	------------------------------
	-- @Mode Document_Insert
	------------------------------
	If (@Mode = 'Document_Insert')
	Begin
		Insert Into [dbo].[SOPDocument] (
			--[DocumentId]
			[ProcedureId],
			[Document],
			[DocumentMode],
			[DocumentAddress],
			[DocumentFileName],
			[Status],
			[DateCreated],
			[DateCreatedBy],
			[DateUpdated],
			[DateUpdatedBy]
		)
		Values (
			--@DocumentId,
			@ProcedureId,
			@Document,
			@DocumentMode,
			@DocumentAddress,
			@DocumentFileName,
			@Status,
			GETDATE(),
			@PassportIndividualId,
			GETDATE(),
			@PassportIndividualId
		)
	End

	
	------------------------------
	-- @Mode Document_Update
	------------------------------
	If (@Mode = 'Document_Update')
	Begin
		Update [dbo].[SOPDocument]
		Set
				[SOPDocument].[ProcedureId] = @ProcedureId,
				[SOPDocument].[Document] = @Document,
				[SOPDocument].[DocumentMode] = @DocumentMode,
				[SOPDocument].[DocumentAddress] = @DocumentAddress,
				[SOPDocument].[DocumentFileName] = @DocumentFileName,
				[SOPDocument].[Status] = @Status,
				[SOPDocument].[DateUpdated] = GETDATE(),
				[SOPDocument].[DateUpdatedBy] = @PassportIndividualId
		Where	[SOPDocument].[DocumentId] = @DocumentId
	End

	
	------------------------------
	-- @Mode Document_Delete
	------------------------------
	If (@Mode = 'Document_Delete')
	Begin
		Delete  From [dbo].[SOPDocument]
		Where	[SOPDocument].[DocumentId] = @DocumentId
	End
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Colby Lithyouvong
-- Create Date: 2018 Sept
-- =============================================
CREATE PROCEDURE [dbo].[SOP_Editor]
(
	@Mode nvarchar(50) null,
	@PassportIndividualId int null,

	@ProcedureId int = null,
	@CategoryId int = null,
	@Status nvarchar(max) = null,
	@Description nvarchar(max) = null
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON


	
	------------------------------
	-- @Mode Editor_Oninit
	------------------------------
	If (@Mode = 'Editor_Oninit')
	Begin
		-- [0] Procedure
		Select	P.[ProcedureId],
				P.[Procedure],
				P.[Status]
		From	SOPProcedure P
		Order by P.[Procedure]

		-- [1] Category 
		Select	C.[CategoryId],
				C.[Category],
				C.[Status]
		From	SOPCategory C
		Order by C.Category
	End

	
	------------------------------
	-- @Mode Editor_Form
	------------------------------
	If (@Mode = 'Editor_Form')
	Begin
		-- [0] Form
		Select	P.ProcedureId,
				P.[Procedure],
				P.[Description],
				(	
					ISNULL(P.Body01,'') + ISNULL(P.Body02,'') + ISNULL(P.Body03,'') + ISNULL(P.Body04,'') + ISNULL(P.Body05,'') + 
					ISNULL(P.Body06,'') + ISNULL(P.Body07,'') + ISNULL(P.Body08,'') + ISNULL(P.Body09,'') + ISNULL(P.Body10,'') + 
					ISNULL(P.Body11,'') + ISNULL(P.Body12,'') + ISNULL(P.Body13,'') + ISNULL(P.Body14,'') + ISNULL(P.Body15,'') + 
					ISNULL(P.Body16,'') + ISNULL(P.Body17,'') + ISNULL(P.Body18,'') + ISNULL(P.Body19,'') + ISNULL(P.Body20,'')
				) as 'Body',
				C.CategoryId,
				C.Category,
				C.ParentId,
				(
					Select	C2.Category
					From	SOPCategory C2
					Where	C2.CategoryId = C.ParentId
				) as ParentCategory
		From	SOPProcedure P
				Inner Join SOPCategory C on C.ProcedureId = P.ProcedureId				
		Where	((@CategoryId IS NULL) or (C.CategoryId = @CategoryId)) and
				((@ProcedureId IS NULL) or (P.ProcedureId = @ProcedureId)) and 		
				(
				  (@Status IS NULL) OR (P.[Status] = @Status and C.[Status] = @Status)
				) And 
				( 
				  (@Description IS NULL) OR 
				  (@Description = '') or
				  (P.[Description] like '%' + @Description + '%') or
				  (
					(	
					   ISNULL(P.Body01,'') + ISNULL(P.Body02,'') + ISNULL(P.Body03,'') + ISNULL(P.Body04,'') + ISNULL(P.Body05,'') + 
					   ISNULL(P.Body06,'') + ISNULL(P.Body07,'') + ISNULL(P.Body08,'') + ISNULL(P.Body09,'') + ISNULL(P.Body10,'') + 
					   ISNULL(P.Body11,'') + ISNULL(P.Body12,'') + ISNULL(P.Body13,'') + ISNULL(P.Body14,'') + ISNULL(P.Body15,'') + 
					   ISNULL(P.Body16,'') + ISNULL(P.Body17,'') + ISNULL(P.Body18,'') + ISNULL(P.Body19,'') + ISNULL(P.Body20,'')
					) like '%' + @Description + '%'
			      ) or 
				  (C.Category like '%' + @Description + '%')
				)
		Order by [ParentCategory], C.Category, P.[Procedure]

		-- [1] Documents
		SELECT  D.Document,
				D.DocumentMode ,
				D.DocumentFileName,
				D.DocumentAddress,
				D.DocumentId,
				D.ProcedureId
		From    SOPDocument D
		Where	((@CategoryId IS NULL) or (
					Select	Top 1 C2.CategoryId 
					From	SOPCategory C2 
					Where	C2.ProcedureId = D.ProcedureId
				) = @CategoryId) and
				((@ProcedureId IS NULL) or (D.ProcedureId = @ProcedureId)) and 
				((@Status is null) or (D.[Status] = @Status)) and 
				(
					(@Description IS NULL) OR 
					(@Description = '') or
					(D.Document like '%' + @Description + '%') or 
					(D.DocumentAddress like '%' + @Description + '%') or
					(D.DocumentFileName like '%' + @Description + '%')
				)
		Order by D.Document
	End
END
GO
