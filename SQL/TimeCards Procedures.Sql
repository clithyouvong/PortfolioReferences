/*
  This is the timecard System used to simulate an online time tracking / management System.
  
  The following code demonstrates SQL interpretations used in SQL Azure 2016.
  
  The Time Card system is designed to record a person's timecard in any given week. 
    - The system will always create a Week worth of Data
    - Each Type will also be created per Day
  
  Schema: Timecard
  Architecture / Structure:
    - Card
        - Root object (Folder Like) Denoting the Start / End Date, the Final Status of the Time Card, and date Created / date Changed.
    - Detail
        - Hours Per Type Per Date with all the Date Flags of the Card Table
    - Type
        - The type of the Detail
  
  Possible Implementation:
    - Detail
        There is a possibility where instead of 'Date' Field in the Detail Table that there would be an Index to allow the data 
        to be more Normalized. 
    - Detail
        Per Requirement, a record will be created in the detail table for each Day and Type combination for that given Card Date Range. 
        There is a possible implementation where that doesn't need to happen. 
    
  Dependencies:
    - Individual. This system assumes there is a centralized Identification Table that stores user information and referened by ID.
*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Colby Lithyouvong
-- Create Date: 2019 Nov
-- =============================================
CREATE or Alter PROCEDURE [TimeCard].[NonExempt_Oninit]
	@IndividualId int
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON
			
	-- [0] Email Criteria
	Select	dbo.GetEmailAddress(I.IndividualId) as 'Email',
			reviewer.IndividualNameWithID as 'Reviewer_IndividualName',
			dbo.GetEmailAddress(reviewer.IndividualId) as 'Reviewer_Email'
	From	Individual I 			
			Inner Join dbo.Permissions LK on LK.IndividualGuid = I.IndividualGuid 
			Inner Join dbo.Individual reviewer on reviewer.IndividualId = LK.Level
	Where	I.IndividualId = @IndividualId and 
			LK.PermissionsGuid = '83FB1323-6DAE-46EE-867D-CA0E7F902E96'
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
CREATE or Alter PROCEDURE [TimeCard].[Management_Oninit]
	@IndividualId int
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON
			
	-- [0] Email Criteria
	Select	submitter.IndividualId,
			submitter.IndividualNameWithID as 'Submitter_IndividualName',
			dbo.GetEmailAddress(submitter.IndividualId) as 'Email',
			reviewer.IndividualNameWithID as 'Reviewer_IndividualName',
			dbo.GetEmailAddress(reviewer.IndividualId) as 'Reviewer_Email'
	From	dbo.Individual reviewer
			inner join dbo.Permissions LK on reviewer.IndividualId = LK.Level
			Inner Join dbo.Individual submitter on submitter.IndividualGuid = LK.IndividualGuid
	Where	reviewer.IndividualId = (
				Case 
					When (
						Select  k.Level
						From	dbo.Permissions k
								Join dbo.Individual I on I.IndividualGuid = k.IndividualGuid
						where	k.PermissionsGuid = '13ED8640-EAB2-4E88-B9A4-B999F61658BD' and 
								I.IndividualId = @IndividualId
					) = 0
						Then reviewer.IndividualId
						Else @IndividualId
				End
			)  and 
			LK.PermissionsGuid = '83FB1323-6DAE-46EE-867D-CA0E7F902E96'

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
CREATE or Alter PROCEDURE [TimeCard].[Report_Oninit]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON
			
	-- [0] Type
	Select	 D.[Type],
			 D.DetailTypeId
	From	 TimeCard.DetailType D
	Order by D.Sort
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
CREATE or Alter PROCEDURE [TimeCard].[NonExempt_Select]
(
	@IndividualId int
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON
		
	Select	T.CardId,
			Indv.IndividualNameWithID as 'Individual',		
			T.DateStart,
			T.DateEnd,
			T.[Status], 
			T.DateUpdated,
			Modifier.IndividualNameWithID as 'DateUpdatedBy'	
	From	TimeCard.[Card] T
			Inner Join dbo.Individual Indv on Indv.IndividualId = T.IndividualId
			Inner Join dbo.Individual Modifier on Modifier.IndividualId = T.DateUpdatedBy
	Where	T.IndividualId = @IndividualId
	order by T.DateStart desc

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
CREATE or Alter PROCEDURE [TimeCard].[Management_Select]
(
	@IndividualId int,

	@Status nvarchar(50) = N'',
	@DateStart date = null,
	@DateEnd date = null
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON
		
	Select	Distinct T.CardId,
			Indv.IndividualId,
			Indv.IndividualNameWithID as 'IndividualName',	
			Indv.IndividualGuid,
			T.DateStart,
			T.DateEnd,
			T.[Status], 
			T.DateUpdated,
			Modifier.IndividualNameWithID as 'DateUpdatedBy',
			Indv.LastName	
	From	TimeCard.[Card] T
			Inner Join dbo.Individual Indv on Indv.IndividualId = T.IndividualId
			Inner Join dbo.Individual Modifier on Modifier.IndividualId = T.DateUpdatedBy
			Inner Join dbo.Permissions LK on 
				LK.IndividualGuid = Indv.IndividualGuid and 
				LK.PermissionsGuid = '83FB1323-6DAE-46EE-867D-CA0E7F902E96' and
				Lk.Level = (
					Case 
						When (
							Select  k.Level
							From	dbo.LKPermissionsIndividual k
									Join dbo.Individual I on I.IndividualGuid = k.IndividualGuid
							where	k.PermissionsGuid = '13ED8640-EAB2-4E88-B9A4-B999F61658BD' and 
									I.IndividualId = @IndividualId
						) = 0
							Then Lk.Level
							Else @IndividualId
					End
				)
				--Lk.Level = @IndividualId and 
	Where	((@Status = N'') or (T.[Status] = @Status)) and 
			((@DateStart is null) or (T.DateStart >= @DateStart)) and 
			((@DateEnd is null) or (T.DateEnd <= @DateEnd))
	order by T.DateStart desc, Indv.LastName 


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
CREATE or Alter PROCEDURE [TimeCard].[Card_Detail]
(
	@CardId int
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	Select	 D.DetailId,
			 D.[Date],
			 D.[DetailTypeId],
			 (
			 	Select  Sum(D2.[Hours])
			 	From	TimeCard.Detail D2
			 	Where	D2.[Date] = D.[Date] and 
			 			D2.[CardId] = D.CardId and 
			 			D2.DetailTypeId = D.DetailTypeId
			 ) as 'Hours'
	From	 TimeCard.Detail D
	Where	 D.CardId = @CardId and 
			 D.HoursType = 'S' and 
			 D.HoursTypeSeq = 1
	Order by D.[Date],	
			 D.DetailTypeId
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
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;


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

/*
Drop Type [TimeCard].[timeCardStruct]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Type [TimeCard].[TimecardStruct] as Table (
	DetailId int,
	DetailTypeId int,
	CardId int,
	[Date] datetime,
	[Hours] decimal(18,2),
	HoursType nvarchar(10),
	HoursTypeSeq int	
);
go
*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Colby Lithyouvong
-- Create Date: 2019 Nov
-- Use Cases: 
--		1.	Non Exempt Insert 
--		2.	Non Exempt Submit
--		3.	Non Exempt Save
--		4.	Manager Insert
--		5.	Manager Submit
--		6.  Manager Save
-- =============================================
CREATE or Alter PROCEDURE [TimeCard].[Card_InsertUpdateSaveApproveReject]
(
	@IndividualId int,
	@CardId int = 0,
	@DateStart date,
	@DateEnd date,
	@Status nvarchar(50),
	@Passport_IndividualId int,
	@Struct [TimeCard].[TimecardStruct] READONLY
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
	SET XACT_ABORT ON;
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

	Begin Transaction;
	BEGIN TRY  
    
	Declare @CardId2 int;	
	Declare @DateModified datetimeoffset(0) = dbo.GetDateTimeOffSetAtLocal(SYSDATETIMEOFFSET(), @Passport_IndividualId);

	
	-- [0] Insert into Card or Update Card
	If(@CardId = 0)
	Begin
		Insert into TimeCard.[Card] (
			[IndividualId],
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
			@IndividualId,
			@DateStart,
			@DateEnd,
			@Status,
			@DateModified,
			@Passport_IndividualId,
			@DateModified,
			@Passport_IndividualId,
			NEWID()
		);
	
		Select @CardId = SCOPE_IDENTITY(),
			   @CardId2 = 0;
	End
	Else 
	Begin
		Update TimeCard.[Card] 
		Set	   DateUpdated = @DateModified,
			   DateUpdatedBy = @Passport_IndividualId,
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
				Case When @Status = 'Submitted' Then @Passport_IndividualId Else null End,
				@DateModified,
				@Passport_IndividualId,
				@DateModified,
				@Passport_IndividualId
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
					DateSubmittedBy = Case When @Status = 'Submitted' Then @Passport_IndividualId Else DateSubmittedBy End,
					DateApproved = 
						Case 
							When @Status = 'Approved' Then @DateModified 
							When @Status = 'Rejected' Then null
							Else DateApproved 
						End,
					DateApprovedBy = 
						Case 
							When @Status = 'Approved' Then @Passport_IndividualId 
							When @Status = 'Rejected' Then null
							Else DateApprovedBy 
						End,
					DateUpdated = @DateModified,
					DateUpdatedBy = @Passport_IndividualId
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
		[IndividualName] nvarchar(150),
		[IndividualGuid] uniqueidentifier,
		[DateStart] date,
		[DateEnd] date,
		[Status] nvarchar(50),
		[DateSubmitted] datetimeoffset,
		[DateSubmittedBy] nvarchar(150),
		[DateSubmittedBy_IndividualGuid] uniqueidentifier,
		[DateApproved] datetimeoffset,
		[DateApprovedBy] nvarchar(150),
		[DateApprovedBy_IndividualGuid] uniqueidentifier,
		[DatePaid] datetimeoffset,
		[DatePaidBy] nvarchar(150),
		[DatePaidBy_IndividualGuid] uniqueidentifier
	)
	Insert into @Temp (
		[CardId],
		[IndividualName],
		[IndividualGuid],
		[DateStart],
		[DateEnd],
		[Status],
		[DateSubmitted],
		[DateSubmittedBy],
		[DateSubmittedBy_IndividualGuid],
		[DateApproved],
		[DateApprovedBy],
		[DateApprovedBy_IndividualGuid],
		[DatePaid],
		[DatePaidBy],
		[DatePaidBy_IndividualGuid]
	)
	Select	C.CardId,
			I.IndividualNameWithID,
			I.IndividualGuid,
			C.DateStart,
			C.DateEnd,
			C.[Status],
			P.[DateSubmitted],
			P.[DateSubmittedBy],
			P.[DateSubmittedBy_IndividualGuid],
			P.[DateApproved],
			P.[DateApprovedBy],
			P.[DateApprovedBy_IndividualGuid],			
			Q.[DatePaid],
			Q.[DatePaidBy],
			Q.[DatePaidBy_IndividualGuid]
	From	TimeCard.[Card] C 
			Inner Join dbo.Individual I on I.IndividualId = C.IndividualId
			Outer Apply (
				Select   Top 1 D2.DateSubmitted,
						 S2.IndividualNameWithID as DateSubmittedBy,
						 S2.IndividualGuid as DateSubmittedBy_IndividualGuid,
						 D2.DateApproved,
						 A2.IndividualNameWithID as DateApprovedBy,
						 A2.IndividualGuid as DateApprovedBy_IndividualGuid
				From	 TimeCard.Detail D2
						 Left Outer Join dbo.Individual S2 on S2.IndividualId = D2.DateSubmittedBy
						 Left Outer Join dbo.Individual A2 on A2.IndividualId = D2.DateApprovedBy
				Where	 D2.CardId = C.CardId
			) as P
			Outer Apply (
				Select   Top 1 
						 D2.DatePaid,
						 P2.IndividualNameWithID as DatePaidBy,
						 P2.IndividualGuid as DatePaidBy_IndividualGuid
				From	 TimeCard.Detail D2
						 Inner Join dbo.Individual P2 on P2.IndividualId = D2.DatePaidBy
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
CREATE or ALTER PROCEDURE [TimeCard].[Report_Select_Detail]
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

	Select	convert(NVARCHAR, CONVERT(DATE, C.DateStart)) as 'Date Start',
			convert(NVARCHAR, CONVERT(DATE, C.DateEnd)) as 'Date End',
			I.IndividualNameWithID as 'Individual',
			T.[Type],
			(
				Select  Sum(D2.[Hours])
				From	TimeCard.Detail D2
				Where	D2.CardId = D.CardId and 
						D2.[Date] = D.[Date] and 
						D2.DetailTypeId = D.DetailTypeId
			) as [Hours],
			C.[Status],
			ISNULL(convert(NVARCHAR, CONVERT(DATE, D.[DateSubmitted])),'') as 'Submitted',
			S.IndividualNameWithID as 'Submitter',
			ISNULL(convert(NVARCHAR, CONVERT(DATE, D.[DateApproved])),'') as 'Approved',
			A.IndividualNameWithID as 'Approver',			
			ISNULL(convert(NVARCHAR, CONVERT(DATE, D.DatePaid)),'') as 'Paid',
			P.IndividualNameWithID as 'Payor'
	From	TimeCard.[Card] C 
			Inner Join TimeCard.Detail D on D.CardId = C.CardId
			Inner Join TimeCard.DetailType T on T.DetailTypeId = D.DetailTypeId
			Inner Join dbo.Individual I on I.IndividualId = C.IndividualId
			Left Outer Join dbo.Individual S on S.IndividualId = D.DateSubmittedBy
			Left Outer Join dbo.Individual A on A.IndividualId = D.DateApprovedBy
			Left Outer Join dbo.Individual P on P.IndividualId = D.DatePaidBy
	Where	D.[Hours] > 0 and 
			D.HoursType = 'S' and 
			D.HoursTypeSeq = 1 and 	
			((@Status is Null) or (C.[Status] = @Status)) and 
			(C.DateStart >= @DateStart) and 
			(C.DateEnd <= @DateEnd) 
	Order by C.DateStart, I.LastName, T.[Type]
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
CREATE or ALTER PROCEDURE [TimeCard].[Adjustment_Oninit]

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	
	Select	submitter.IndividualId,
			submitter.IndividualNameWithID as 'Submitter_IndividualName',
			dbo.GetEmailAddress(submitter.IndividualId) as 'Email',
			reviewer.IndividualNameWithID as 'Reviewer_IndividualName',
			dbo.GetEmailAddress(reviewer.IndividualId) as 'Reviewer_Email'
	From	dbo.Individual reviewer
			inner join dbo.Permissions LK on reviewer.IndividualId = LK.Level
			Inner Join dbo.Individual submitter on submitter.IndividualGuid = LK.IndividualGuid
	Where	LK.PermissionsGuid = '83FB1323-6DAE-46EE-867D-CA0E7F902E96';
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
CREATE or ALTER PROCEDURE [TimeCard].[Adjustment_Select]
(
	@IndividualId int = 0,
	@DetailTypeId int = 0,
	@DateStart datetime = null,
	@DateEnd datetime = null
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	Select	Top 1000 D.DetailId,
			D.[Date],
			I.IndividualNameWithID,
			I.IndividualGuid,
			C.[Status],
			T.[Type],
			(
				Select  Sum(D2.[Hours])
				From	TimeCard.Detail D2
				Where	D2.CardId = D.CardId and 
						D2.[Date] = D.[Date] and 
						D2.DetailTypeId = D.DetailTypeId
			) as [Hours],
			D.[DateSubmitted],
			S.IndividualNameWithID as 'DateSubmittedBy',
			D.[DateApproved],
			A.IndividualNameWithID as 'DateApprovedby',			
			D.DatePaid,
			P.IndividualNameWithID as 'DatePaidBy',
			D.AdjustmentNotes
	From	TimeCard.[Card] C 
			Inner Join TimeCard.Detail D on D.CardId = C.CardId
			Inner Join TimeCard.DetailType T on T.DetailTypeId = D.DetailTypeId
			Inner Join dbo.Individual I on I.IndividualId = C.IndividualId
			Left Outer Join dbo.Individual S on S.IndividualId = D.DateSubmittedBy
			Left Outer Join dbo.Individual A on A.IndividualId = D.DateApprovedBy
			Left Outer Join dbo.Individual P on P.IndividualId = D.DatePaidBy
	Where	D.HoursType = 'S' and 
			D.HoursTypeSeq = 1 and 	
			C.[Status] = 'Paid' and
			((@IndividualId = 0) or (C.IndividualId = @IndividualId)) and 
			((@DateStart is null) or (D.[Date] >= @DateStart)) and 
			((@DateEnd is null) or (D.[Date] <= @DateEnd)) and 
			((@DetailTypeId = 0) or (D.DetailTypeId = @DetailTypeId))
	Order by I.LastName, D.[Date], T.[Type];
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
CREATE or ALTER PROCEDURE [TimeCard].[Adjustment_Insert]
(
	@Passport_IndividualId int,
	@DetailId int,
	@AdjustmentHours nvarchar(10),
	@AdjustmentNotes nvarchar(max) = ''
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
	Set xact_abort On;
	Set Transaction Isolation Level Read Committed; 
	
	Begin Transaction;
	BEGIN TRY  
		Declare @DateModified datetimeoffset = (
			Select dbo.GetDateTimeOffSetAtLocal(SYSDATETIMEOFFSET(), @Passport_IndividualId)
		);

		Declare @CardId int;
		Declare @DetailTypeId int;
		Declare @Date date;
		Select  @CardId = d.CardId,
				@DetailTypeId = d.DetailTypeId,
				@Date = d.[Date] 
		From	TimeCard.Detail d
		Where   d.DetailId = @DetailId;
		

		Insert into TimeCard.Detail (
			[CardId],
			[Date],
			[DetailTypeId],
			[Hours],
			[HoursType],
			[HoursTypeSeq],
			[AdjustmentNotes],
			[DateCreated],
			[DateCreatedBy],
			[DateUpdated],
			[DateUpdatedBy],
			[DateSubmitted],
			[DateSubmittedBy],
			[DateApproved],
			[DateApprovedBy]
		)
		Select  D.CardId,
				D.[Date],
				D.DetailTypeId,
				@AdjustmentHours,
				'A',
				ISNULL((
					Select  max(D2.HoursTypeSeq)
					From	TimeCard.Detail D2
					Where	D2.CardId = D.CardId and 
							D2.[Date] = D.[Date] and 
							D2.DetailTypeId = D.DetailTypeId and 
							D2.HoursType = 'A'
				),1) + 1,
				@AdjustmentNotes,
				@DateModified,
				@Passport_IndividualId,
				@DateModified,
				@Passport_IndividualId,
				@DateModified,
				@Passport_IndividualId,
				@DateModified,
				@Passport_IndividualId
		From	TimeCard.Detail D
		Where	D.DetailId = @DetailId;

		-- [1] Update the Adjustment Notes for All entries
		-- of that card, date, & type
		Update TimeCard.Detail
		Set		AdjustmentNotes = @AdjustmentNotes
		Where	CardId = @CardId and 
				DetailTypeId = @DetailTypeId and 
				[Date] = @Date;
		

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
CREATE or ALTER PROCEDURE [TimeCard].[HoursReport_Update]
(
	@DetailGuid uniqueidentifier,
	@Passport_IndividualId int,
	@DatePaid date = null,
	@Paid bit = 0
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
	Set xact_abort On;
	Set Transaction Isolation Level Read Committed; 
	
	Begin Transaction;
	BEGIN TRY  
		Declare @CardId int = (
			Select	D.CardId
			From	TimeCard.Detail D
			Where	D.DetailGuid = @DetailGuid
		);

		Update  TimeCard.Detail 
		Set		DatePaid = Case When @Paid = 1 Then @DatePaid Else Null End,
				DatePaidBy = Case When @Paid = 1 Then @Passport_IndividualId Else Null End,
				DateUpdated = @DatePaid,
				DateUpdatedBy = @Passport_IndividualId
		Where	DetailGuid = @DetailGuid;

		Update  TimeCard.[Card]
		Set		[Status] = Case When @Paid = 1 Then 'Paid' Else 'Approved' End,
				DateUpdated = @DatePaid,
				DateUpdatedBy = @Passport_IndividualId
		Where	CardId = @CardId;
		

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
