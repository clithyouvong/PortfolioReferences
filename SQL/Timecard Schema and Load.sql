
/*
  This code is a working file used for everyday references.
  
  This code demonstrates a creation of a temporalized table and a reload/migration of data from 
  an existing data structure. 
  Results may vary based on company implementation.
  
  The following code demonstrates SQL interpretations used in SQL Azure 2016.
  
  This is not a copy of any current implementation of any company.
*/


Create Table TimeCard.[Card] (
	CardId int Primary Key identity (1,1) not null,
	Id int Foreign Key References dbo.Id(Id) not null,
	DateStart date not null,
	DateEnd date not null,
	[Status] nvarchar(50) not null default N'Pending',
	DateCreated datetimeoffset(0) null default SYSDATETIMEOFFSET(),
	DateCreatedBy int null Foreign Key References dbo.Id(Id),
	DateUpdated datetimeoffset(0) null default SYSDATETIMEOFFSET(),
	DateUpdatedBy int null Foreign Key References dbo.Id(Id),
	CardGuid uniqueidentifier null default newid(),
	SysDateStart datetime2(3) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
	SysDateEnd datetime2(3) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
	Period For System_Time (SysDateStart, SysDateEnd),
	Constraint [CK_Status]  Check ([Status] in ('Open', 'Submitted', 'Approved', 'Rejected', 'Paid')),
	Constraint [UK_Id-DateStart-DateEnd] Unique (Id, DateStart, DateEnd)
) with (System_Versioning = On (History_Table = TimeCard.[CardLog]));
go

Create Table TimeCard.[DetailType] (
	DetailTypeId int Primary Key identity (1,1) not null,
	[Type] nvarchar(200) not null,
	[Description] nvarchar(max) null default N'',
	Code nvarchar(50) null default N'',
	AllowFull bit null default 0,
	AllowHalf bit null default 0,
	AllowHour bit null default 0, 
	DateCreated datetimeoffset(0) null default SYSDATETIMEOFFSET(),
	DateCreatedBy int null Foreign Key References dbo.Id(Id),
	DateUpdated datetimeoffset(0) null default SYSDATETIMEOFFSET(),
	DateUpdatedBy int null Foreign Key References dbo.Id(Id),
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
	DateSubmittedBy int null Foreign Key References dbo.Id(Id),
	DateApproved datetimeoffset(0),
	DateApprovedBy int null Foreign Key References dbo.Id(Id),
	DatePaid datetimeoffset(0),
	DatePaidBy int null Foreign Key References dbo.Id(Id),
	DateCreated datetimeoffset(0) null default SYSDATETIMEOFFSET(),
	DateCreatedBy int null Foreign Key References dbo.Id(Id),
	DateUpdated datetimeoffset(0) null default SYSDATETIMEOFFSET(),
	DateUpdatedBy int null Foreign Key References dbo.Id(Id),
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
	Id,
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
		 t.Id,
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
		 t.[Hours],
		 t.[HoursType],
		 t.timecarddetailid,
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
order by t.TimeCardDetailId;
Set Identity_Insert TimeCard.Detail Off;
go
