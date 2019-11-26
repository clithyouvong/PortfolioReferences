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


Create Table TimeCard.[Card] (
	CardId int Primary Key identity (1,1) not null,
	IndividualId int Foreign Key References dbo.Individual(IndividualId) not null,
	DateStart date not null,
	DateEnd date not null,
	[Status] nvarchar(50) not null default N'Pending',
	DateCreated datetimeoffset(0) null default SYSDATETIMEOFFSET(),
	DateCreatedBy int null Foreign Key References dbo.Individual(IndividualId),
	DateUpdated datetimeoffset(0) null default SYSDATETIMEOFFSET(),
	DateUpdatedBy int null Foreign Key References dbo.Individual(IndividualId),
	CardGuid uniqueidentifier null default newid(),
	SysDateStart datetime2(3) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
	SysDateEnd datetime2(3) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
	Period For System_Time (SysDateStart, SysDateEnd),
	Constraint [CK_Status]  Check ([Status] in ('Open', 'Submitted', 'Approved', 'Rejected', 'Paid')),
	Constraint [UK_IndividualId-DateStart-DateEnd] Unique (IndividualId, DateStart, DateEnd)
) with (System_Versioning = On (History_Table = TimeCard.[CardLog]));
go

Create Table TimeCard.[DetailType] (
	DetailTypeId int Primary Key identity (1,1) not null,
	[Type] nvarchar(200) not null,
	[Description] nvarchar(max) null default N'',
	ADPCode nvarchar(50) null default N'',
	AllowFull bit null default 0,
	AllowHalf bit null default 0,
	AllowHour bit null default 0, 
	DateCreated datetimeoffset(0) null default SYSDATETIMEOFFSET(),
	DateCreatedBy int null Foreign Key References dbo.Individual(IndividualId),
	DateUpdated datetimeoffset(0) null default SYSDATETIMEOFFSET(),
	DateUpdatedBy int null Foreign Key References dbo.Individual(IndividualId),
	SysDateStart datetime2(3) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
	SysDateEnd datetime2(3) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
	Period For System_Time (SysDateStart, SysDateEnd),
	Constraint [UK_Type] Unique ([Type])
) with (System_Versioning = On (History_Table = TimeCard.[DetailTypeLog]));
go

Create Table TimeCard.[Detail] (
	[DetailId] int Primary Key identity (1,1) not null,
	[DetailTypeId] int Foreign Key References TimeCard.DetailType(DetailTypeId) not null,
	[CardId] int Foreign Key References TimeCard.[Card](CardId),	
	[Date] date not null,
	[Hours] decimal(18,2) not null,
	[HoursType] nvarchar(10) not null default N'S',
	[HoursTypeSeq] int not null,
	AdjustmentNotes nvarchar(max) null default N'',
	DateSubmitted datetimeoffset(0) null,
	DateSubmittedBy int null Foreign Key References dbo.Individual(IndividualId),
	DateApproved datetimeoffset(0),
	DateApprovedBy int null Foreign Key References dbo.Individual(IndividualId),
	DatePaid datetimeoffset(0),
	DatePaidBy int null Foreign Key References dbo.Individual(IndividualId),
	DateCreated datetimeoffset(0) null default SYSDATETIMEOFFSET(),
	DateCreatedBy int null Foreign Key References dbo.Individual(IndividualId),
	DateUpdated datetimeoffset(0) null default SYSDATETIMEOFFSET(),
	DateUpdatedBy int null Foreign Key References dbo.Individual(IndividualId),
	SysDateStart datetime2(3) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
	SysDateEnd datetime2(3) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
	Period For System_Time (SysDateStart, SysDateEnd),
	Constraint [CK_HoursType] Check (HoursType in ('S','A')),
	Constraint [CK_HoursTypeSeq] Check (HoursTypeSeq > 0),
	Constraint [UK_CardId-DetailTypeId-Date-HoursType-HoursTypeSeq] Unique ([CardId], [DetailTypeId], [Date], [HoursType], [HoursTypeSeq])
) with (System_Versioning = On (History_Table = TimeCard.[DetailLog]));
go

Delete From TimeCard.Detail;
Delete From TimeCard.DetailType;
Delete From TimeCard.[Card];
go

DBCC CHECKIDENT ('TimeCard.[Card]', RESEED, 1)  
go
DBCC CHECKIDENT ('TimeCard.DetailType', RESEED, 1)  
go
DBCC CHECKIDENT ('TimeCard.[Detail]', RESEED, 1)  
go

Set Identity_Insert TimeCard.[DetailType] On;
Insert into TimeCard.DetailType (
	[DetailTypeId],
	[Type],
	[Description],
	ADPCode,
	AllowFull,
	AllowHalf,
	AllowHour,
	DateCreated,
	DateCreatedBy,
	DateUpdated,
	DateUpdatedBy
)
Select   t.TimeCardTypeId,
		 t.[Type],
		 t.[Description],
		 t.ADPCode,
		 t.AllowFull,
		 t.AllowHalf,
		 t.AllowHour,
		 SYSDATETIMEOFFSET(),
		 t.DateCreatedBy,
		 SYSDATETIMEOFFSET(),
		 t.DateUpdatedBy
From	 dbo.TimeCardType t
Order by t.TimeCardTypeId;
Set Identity_Insert TimeCard.[DetailType] Off;
go

Set Identity_Insert TimeCard.[Card] On;
Insert into TimeCard.[Card] (
	CardId,
	IndividualId,
	DateStart,
	DateEnd,
	[Status],
	DateCreated,
	DateCreatedBy,
	DateUpdated,
	DateUpdatedBy,
	CardGuid
)
Select   t.TimeCardId,
		 t.IndividualId,
		 t.DateStart,
		 t.DateEnd,
		 case 
			when t.[Status] = 'Pending' then 'Submitted'
			else t.[Status]
		 end,
		 t.DateCreated,
		 t.DateCreatedBy,
		 t.DateUpdated,
		 t.DateUpdatedBy,
		 t.TimeCardGuid
From	 dbo.TimeCard t
where	 t.TimeCardId not in (279, 763)
order by t.TimeCardId;
Set Identity_Insert TimeCard.[Card] Off;
go


Set Identity_Insert TimeCard.Detail On;
Insert into TimeCard.Detail (
    [DetailId],
	[DetailTypeId],
	[CardId],	
	[Date],
	[Hours],
	[HoursType],
	[HoursTypeSeq],
	AdjustmentNotes,
	DateSubmitted,
	DateSubmittedBy,
	DateApproved,
	DateApprovedBy,
	DatePaid,
	DatePaidBy,
	DateCreated,
	DateCreatedBy,
	DateUpdated,
	DateUpdatedBy
)
Select   t.TimeCardDetailId,
		 t.TimeCardTypeId,
		 t.TimeCardId,	
		 t.[Date],
		 convert(decimal(18,2), case 
			when t.TimeCardDetailId = 21864 then 11.8
			when t.TimeCardDetailId = 21851 then 8
			when t.TimeCardDetailId = 21852 then 8
			when t.TimeCardDetailId = 21853 then 8
			when t.TimeCardDetailId = 21875 then 8
			when t.TimeCardDetailId = 70230 then 14
			when t.TimeCardDetailId = 70231 then 35
			else t.[Hours]
		 end),
		 t.[HoursType],
		 case 
			when t.timecarddetailid in (95622, 95623)		
				then 2 
				else 1 
		 end,
		 t.AdjustmentNotes,
		 t.DateSubmitted,
		 t.DateSubmittedBy,
		 t.DateApproved,
		 t.DateApprovedBy,
		 t.DatePaid,
		 t.DatePaidBy,
		 t.DateCreated,
		 t.DateCreatedBy,
		 t.DateUpdated,
		 t.DateUpdatedBy
From	 dbo.TimeCardDetail t
where	 t.TimeCardId not in (279, 763) and 
		 t.TimeCardId in (
			Select t2.CardId
			From	TimeCard.Card t2
		 )
order by t.TimeCardDetailId;
Set Identity_Insert TimeCard.Detail Off;
go
