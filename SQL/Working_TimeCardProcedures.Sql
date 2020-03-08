
/*
  This code is a working file used for everyday references.
  
  This code demonstrates a typical CRUD SQL stored procedure architecture. 
  Results may vary based on company implementation.
  
  The following code demonstrates SQL interpretations used in SQL Azure 2016.
  
  This is not a copy of any current implementation of any company.
*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Colby Lithyouvong
-- Create Date: 2019 Nov
-- =============================================
CREATE or Alter PROCEDURE [TimeCard].[Card_Delete]
(
	@CardId int
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
	SET XACT_ABORT ON;
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;


	Begin Transaction;
	BEGIN TRY  
    
	Delete From TimeCard.[Detail] Where CardId = @CardId;
	Delete From TimeCard.[Card] Where CardId = @CardId;

    Commit Transaction; 
	END TRY  
	BEGIN CATCH  
		Declare @SaveChangesWarning nvarchar(max) = 
		(
		  SELECT  'Error has occurred during this transaction. Please contact Support at support@domain.org or by phone at (000) 000 - 0000. Error: ' +  
				  'ERROR_NUMBER:' + convert(nvarchar, ERROR_NUMBER()) + '; ' +   
				  'ERROR_SEVERITY:' + convert(nvarchar, ERROR_SEVERITY()) + '; '  + 
				  'ERROR_STATE:' + convert(nvarchar, ERROR_STATE()) + '; ' +  
				  'ERROR_PROCEDURE:' + convert(nvarchar, ERROR_PROCEDURE()) + '; ' + 
				  'ERROR_LINE:' + convert(nvarchar, ERROR_LINE()) + '; ' +   
				  'ERROR_MESSAGE:' + convert(nvarchar, ERROR_MESSAGE())  
		);
            
		/* Process work */

		IF ( @@TRANCOUNT > 0 )
		Begin
		  Rollback Transaction;
				Throw 51000, @SaveChangesWarning, 1; 
		End 
                                      
		Return;
	END CATCH
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Colby Lithyouvong
-- Create Date: 2019 Nov
-- =============================================
CREATE or Alter PROCEDURE [TimeCard].[Card_Modify]
(
	@CardId int = 0,
	@DateStart date,
	@DateEnd date,
	@Status nvarchar(50),
	@Id int,
	@Struct [TimeCard].[TimecardStruct] READONLY
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
	SET XACT_ABORT ON;
	SET TRANSACTION ISOLATION LEVEL Serializable;

	Begin Transaction;
	BEGIN TRY  
    
	Declare @CardId2 int;	
	Declare @DateModified datetimeoffset(0) = dbo.GetDateTimeOffSet(SYSDATETIMEOFFSET(), @Id);

	
	-- [0] Insert into Card or Update Card
	If(@CardId = 0)
	Begin
		Insert into TimeCard.[Card] (
			[Id],
			[DateStart],
			[DateEnd],
			[Status],
			DateCreated,
			DateCreatedBy,
			DateUpdated,
			DateUpdatedBy,
			CardGuid
		)
		Values (
			@Id,
			@DateStart,
			@DateEnd,
			@Status,
			@DateModified,
			@Id,
			@DateModified,
			@Id,
			NEWID()
		);
	
		Select @CardId = SCOPE_IDENTITY(),
			   @CardId2 = 0;
	End
	Else 
	Begin
		Update TimeCard.[Card] 
		Set	   DateUpdated = @DateModified,
			   DateUpdatedBy = @Id,
			   DateStart = @DateStart,
			   DateEnd = @DateEnd,
			   [Status] = @Status
		Where  CardId = @CardId;

		Select @CardId2 = @CardId;
	End


	

	-- [1] Insert into Detail or Update Detail
	If(@CardId2 = 0)
	Begin
		Insert into Timecard.Detail (
			[DetailTypeId],
			[CardId],
			[Date],
			[Hours],
			HoursType,
			HoursTypeSeq,
			DateSubmitted,
			DateSubmittedBy,
			DateCreated,
			DateCreatedBy,
			DateUpdated,
			DateUpdatedBy
		)
		Select	S.DetailTypeId,
				@CardId,
				S.[Date],
				S.[Hours],
				N'S',
				1,
				Case When @Status = 'Submitted' Then @DateModified Else null End,
				Case When @Status = 'Submitted' Then @Id Else null End,
				@DateModified,
				@Id,
				@DateModified,
				@Id
		From	@Struct S;
	End
	Else
	Begin
		Declare @Cursor_DetailId int;
		
		DECLARE @Cursor_NumberRecords int, @Cursor_RowCount int;
		Declare @Cursor_Table Table (
			 RowID int IDENTITY(1, 1), 
			 DetailId int
		)
		Insert into @Cursor_Table (DetailId)
		Select  S.DetailId
		From	@Struct S

		-- Get the number of records in the temporary table
		Select @Cursor_NumberRecords = @@ROWCOUNT;
		Select @Cursor_RowCount = 1;
	
		WHILE @Cursor_RowCount <= @Cursor_NumberRecords
		Begin
			--[0] Reassign the ExamId	
			SELECT  @Cursor_DetailId = DetailId
			FROM	@Cursor_Table
			WHERE	RowID = @Cursor_RowCount;

			Update  TimeCard.Detail 
			Set		DetailTypeId = S.DetailTypeId,
					[Date] = S.[Date],
					[Hours] = S.[Hours],
					DateSubmitted = Case When @Status = 'Submitted' Then @DateModified Else DateSubmitted End,
					DateSubmittedBy = Case When @Status = 'Submitted' Then @Id Else DateSubmittedBy End,
					DateApproved = 
						Case 
							When @Status = 'Approved' Then @DateModified 
							When @Status = 'Rejected' Then null
							Else DateApproved 
						End,
					DateApprovedBy = 
						Case 
							When @Status = 'Approved' Then @Id 
							When @Status = 'Rejected' Then null
							Else DateApprovedBy 
						End,
					DateUpdated = @DateModified,
					DateUpdatedBy = @Id
			From	@Struct S
			Where	S.DetailId = @Cursor_DetailId and 
					TimeCard.Detail.DetailId = @Cursor_DetailId;
		
			Select @Cursor_RowCount = @Cursor_RowCount + 1;
		END 
	End

		Commit Transaction; 
	END TRY  
	BEGIN CATCH  

		Declare @SaveChangesWarning nvarchar(max) = 
		(
		  SELECT  'Error has occurred during this transaction. Please contact Support at support@domain.org or by phone at (000) 000 - 0000. Error: ' +  
				  'ERROR_NUMBER:' + convert(nvarchar, ERROR_NUMBER()) + '; ' +   
				  'ERROR_SEVERITY:' + convert(nvarchar, ERROR_SEVERITY()) + '; '  + 
				  'ERROR_STATE:' + convert(nvarchar, ERROR_STATE()) + '; ' +  
				  'ERROR_PROCEDURE:' + convert(nvarchar, ERROR_PROCEDURE()) + '; ' + 
				  'ERROR_LINE:' + convert(nvarchar, ERROR_LINE()) + '; ' +   
				  'ERROR_MESSAGE:' + convert(nvarchar, ERROR_MESSAGE())  
		);
            
		IF ( @@TRANCOUNT > 0 )
		Begin
			Rollback Transaction;
			Throw 51000, @SaveChangesWarning, 1; 
		End                                                             

		Return;
	END CATCH

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Colby Lithyouvong
-- Create Date: 2019 Nov
-- =============================================
CREATE or ALTER PROCEDURE [TimeCard].[Report_Select]
(
	@Status nvarchar(50) = null,
	@DateStart datetime = null,
	@DateEnd datetime = null
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	Declare @Temp table (
		[CardId] int,
		[IdName] nvarchar(150),
		[IdGuid] uniqueidentifier,
		[DateStart] date,
		[DateEnd] date,
		[Status] nvarchar(50),
		[DateSubmitted] datetimeoffset,
		[DateSubmittedBy] nvarchar(150),
		[DateSubmittedBy_IdGuid] uniqueidentifier,
		[DateApproved] datetimeoffset,
		[DateApprovedBy] nvarchar(150),
		[DateApprovedBy_IdGuid] uniqueidentifier,
		[DatePaid] datetimeoffset,
		[DatePaidBy] nvarchar(150),
		[DatePaidBy_IdGuid] uniqueidentifier
	)
	Insert into @Temp (
		[CardId],
		[IdName],
		[IdGuid],
		[DateStart],
		[DateEnd],
		[Status],
		[DateSubmitted],
		[DateSubmittedBy],
		[DateSubmittedBy_IdGuid],
		[DateApproved],
		[DateApprovedBy],
		[DateApprovedBy_IdGuid],
		[DatePaid],
		[DatePaidBy],
		[DatePaidBy_IdGuid]
	)
	Select	C.CardId,
			I.IdNameWithID,
			I.IdGuid,
			C.DateStart,
			C.DateEnd,
			C.[Status],
			P.[DateSubmitted],
			P.[DateSubmittedBy],
			P.[DateSubmittedBy_IdGuid],
			P.[DateApproved],
			P.[DateApprovedBy],
			P.[DateApprovedBy_IdGuid],			
			Q.[DatePaid],
			Q.[DatePaidBy],
			Q.[DatePaidBy_IdGuid]
	From	TimeCard.[Card] C 
			Inner Join dbo.Id I on I.Id = C.Id
			Outer Apply (
				Select   Top 1 D2.DateSubmitted,
						 S2.IdNameWithID as DateSubmittedBy,
						 S2.IdGuid as DateSubmittedBy_IdGuid,
						 D2.DateApproved,
						 A2.IdNameWithID as DateApprovedBy,
						 A2.IdGuid as DateApprovedBy_IdGuid
				From	 TimeCard.Detail D2
						 Left Outer Join dbo.Id S2 on S2.Id = D2.DateSubmittedBy
						 Left Outer Join dbo.Id A2 on A2.Id = D2.DateApprovedBy
				Where	 D2.CardId = C.CardId
			) as P
			Outer Apply (
				Select   Top 1 
						 D2.DatePaid,
						 P2.IdNameWithID as DatePaidBy,
						 P2.IdGuid as DatePaidBy_IdGuid
				From	 TimeCard.Detail D2
						 Inner Join dbo.Id P2 on P2.Id = D2.DatePaidBy
				Where	 D2.CardId = C.CardId and 
						 D2.HoursType = 'S'
				Order by D2.DateUpdated desc
			) as Q
	Where	((@Status is Null) or (C.[Status] = @Status)) and 
			(C.DateStart >= @DateStart) and 
			(C.DateEnd <= @DateEnd) 
	Order by C.DateStart, I.LastName

			
	-- [0] For Report Output
	SELECT * FROM @Temp AS RT

	-- [1] For Excel Output
	SELECT	convert(NVARCHAR, CONVERT(DATE, RT.[DateStart])) AS 'Started', 
			convert(NVARCHAR, CONVERT(DATE, RT.[DateEnd])) AS 'Ended', 
			RT.[Status],
			RT.[IndividualName] AS 'Individual',
			ISNULL(convert(NVARCHAR, CONVERT(DATE, RT.[DateSubmitted])),'') AS 'Submitted', 
			RT.[DateSubmittedBy] AS 'Submitter', 
			ISNULL(convert(NVARCHAR, CONVERT(DATE, RT.[DateApproved])),'') AS 'Approved', 
			RT.[DateApprovedBy] AS 'Approver', 
			ISNULL(convert(NVARCHAR, CONVERT(DATE, RT.[DatePaid])),'') AS 'Paid', 
			RT.[DatePaidBy] AS 'Payor'
	FROM	@Temp AS RT
END
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Colby Lithyouvong
-- Create Date: 2019 Nov
-- =============================================
CREATE or ALTER PROCEDURE [TimeCard].[Report_Oninit]
	@FieldId int = null
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	-- [0] SomeTable
	SELECT	T.Field1,
			T.Field2,
			T.Field3
	FROM	dbo.SomeTable T

	-- [1] Some Other Table
	SELECT	T.Field1,
			T.Field2,
			T.Field3
	From	dbo.SomeOtherTable T
	Where	((@FieldId is null) or (T.FieldId = @FieldId))
END
GO
