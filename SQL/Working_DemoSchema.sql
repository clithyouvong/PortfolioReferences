
/*
  This code is a working file used for everyday references.
  
  This code demonstrates a creation of a CRUD system with the use of Temporalized Tables.
  Results may vary based on company implementation.
  
  The following code demonstrates SQL interpretations used in SQL Azure 2016.
  
  This is not a copy of any current implementation of any company.
*/


Create Table Demo.CourseType (
	CourseTypeId int Not Null Identity(1,1),
	CourseType nvarchar(100) Not Null,
	DateCreated datetimeoffset Null Default SYSDATETIMEOFFSET(),
	DateCreatedBy int Null ,
	DateUpdated datetimeoffset Null Default SYSDATETIMEOFFSET(),
	DateUpdatedBy int Null,
	SysDateStart datetime2(3) GENERATED ALWAYS AS ROW START HIDDEN Not Null,
	SysDateEnd datetime2(3) GENERATED ALWAYS AS ROW END HIDDEN Not Null,
	Period For System_Time(SysDateStart, SysDateEnd),
	Index [IX_DemoCourseType_CourseType] Nonclustered (CourseType),
	Constraint [PK_DemoCourseType_CourseTypeId] Primary Key (CourseTypeId),
	Constraint [UC_DemoCourseType_CourseType] Unique (CourseType),
	Constraint [FK_DemoCourseType_DateCreatedBy] Foreign Key (DateCreatedBy) References [dbo].[I](IId),
	Constraint [FK_DemoCourseType_DateUpdatedBy] Foreign Key (DateUpdatedBy) References [dbo].[I](IId)
)
With (System_Versioning = On (History_Table = Demo.CourseTypeLog))
Go

Create Table Demo.Course (
	CourseId int Not Null Identity(1,1),
	CourseTypeId int Not Null ,
	Course nvarchar(500) Not Null,
	[Status] bit Null Default 1,
	[BrowserIPv4] nvarchar(50) Null,
	[BrowserIPv6] nvarchar(50) Null,
	[BrowserType] nvarchar(255) Null,
	[BrowserName] nvarchar(255) Null,
	[BrowserVersion] nvarchar(255) Null,
	[BrowserMajorVersion] nvarchar(50) Null,
	[BrowserMinorVersion] nvarchar(50) Null,
	[BrowserPlatform] nvarchar(50) Null,
	DateCreated datetimeoffset Null Default SYSDATETIMEOFFSET(),
	DateCreatedBy int Null,
	DateUpdated datetimeoffset Null Default SYSDATETIMEOFFSET(),
	DateUpdatedBy int Null,
	SysDateStart datetime2(3) GENERATED ALWAYS AS ROW START HIDDEN Not Null,
	SysDateEnd datetime2(3) GENERATED ALWAYS AS ROW END HIDDEN Not Null,
	Period For System_Time(SysDateStart, SysDateEnd),
	Index [IX_DemoCourse_Course] NonClustered (Course),
	Index [IX_DemoCourse_CourseTypeId] Nonclustered (CourseTypeId),
	Constraint [PK_DemoCourse_CourseId] Primary Key (CourseId),
	Constraint [UC_DemoCourse_Course] Unique (CourseTypeId, Course), 
	Constraint [FK_DemoCourse_CourseTypeId] Foreign Key (CourseTypeId) References Demo.CourseType(CourseTypeId),
	Constraint [FK_DemoCourse_DateCreatedBy] Foreign Key (DateCreatedBy) References [dbo].[I](IId),
	Constraint [FK_DemoCourse_DateUpdatedBy] Foreign Key (DateUpdatedBy) References [dbo].[I](IId)
)
With (System_Versioning = On (History_Table = Demo.CourseLog))
Go


Create Table Demo.Section (
	SectionId int Not Null Identity(1,1),
	CourseId int Not Null ,
	Section nvarchar(500) Not Null ,
	[Status] bit Null Default 1,
	[IsIntroductionVisible] bit Null Default 0,
	[Introduction] nvarchar(max) Null Default N'',
	[IntroductionAudioMode] nvarchar(50) Null,
	[IntroductionAudioAddress] nvarchar(256) Null,
	[IntroductionAudioUpload] nvarchar(256) Null,
	[IntroductionImageMode] nvarchar(50) null,
	[IntroductionImageAddress] nvarchar(256) Null,
	[IntroductionImageUpload] nvarchar(256) Null,
	[IsConclusionVisible] bit Null Default 0,
	[Conclusion] nvarchar(max) Null Default N'',
	[ConclusionAudioMode] nvarchar(50) Null,
	[ConclusionAudioAddress] nvarchar(256) Null,
	[ConclusionAudioUpload] nvarchar(256) Null,
	[ConclusionImageMode] nvarchar(50) null,
	[ConclusionImageAddress] nvarchar(256) Null,
	[ConclusionImageUpload] nvarchar(256) Null,	
	[AllowRetake] bit Null Default 0,
	[Threshold] int Null Check ([Threshold] >= 0 and [Threshold] <= 100),
	[Version] date Null Default GETDATE(),
	[HeaderText] nvarchar(256) Null,
	[IsQuestionsSkipable] bit Null Default 0,
	[IsDuplicate] bit Null Default 0,
	[IsTableOfContentsVisible] bit Null Default 0,
	[IsTemplate] bit Null Default 0,
	[BrowserIPv4] nvarchar(50) Null,
	[BrowserIPv6] nvarchar(50) Null,
	[BrowserType] nvarchar(255) Null,
	[BrowserName] nvarchar(255) Null,
	[BrowserVersion] nvarchar(255) Null,
	[BrowserMajorVersion] nvarchar(50) Null,
	[BrowserMinorVersion] nvarchar(50) Null,
	[BrowserPlatform] nvarchar(50) Null,
	DateCreated datetimeoffset Null Default SYSDATETIMEOFFSET(),
	DateCreatedBy int Null ,
	DateUpdated datetimeoffset Null Default SYSDATETIMEOFFSET(),
	DateUpdatedBy int Null ,
	SysDateStart datetime2(3) GENERATED ALWAYS AS ROW START HIDDEN Not Null,
	SysDateEnd datetime2(3) GENERATED ALWAYS AS ROW END HIDDEN Not Null,
	Period For System_Time(SysDateStart, SysDateEnd),
	Index [IX_DemoSection_CourseId] Nonclustered (CourseId), 
	Index [IX_DemoSection_Section] NonClustered (Section),
	Constraint [PK_DemoSection_SectionId] Primary Key (SectionId),
	Constraint [FK_DemoSection_CourseId] Foreign Key (CourseId) References Demo.Course(CourseId),
	Constraint [FK_DemoSection_DateCreatedBy] Foreign Key (DateCreatedBy) References [dbo].[I](IId),
	Constraint [FK_DemoSection_DateUpdatedBy] Foreign Key (DateUpdatedBy) References [dbo].[I](IId)
)
With (System_Versioning = On (History_Table = Demo.SectionLog))
Go

Create Table Demo.QuestionType (
	QuestionTypeId int Not Null Identity(1,1),
	QuestionType nvarchar(50) Not Null,
	DateCreated datetimeoffset Null Default SYSDATETIMEOFFSET(),
	DateCreatedBy int Null ,
	DateUpdated datetimeoffset Null Default SYSDATETIMEOFFSET(),
	DateUpdatedBy int Null ,
	SysDateStart datetime2(3) GENERATED ALWAYS AS ROW START HIDDEN Not Null,
	SysDateEnd datetime2(3) GENERATED ALWAYS AS ROW END HIDDEN Not Null,
	Period For System_Time(SysDateStart, SysDateEnd),
	Index [IX_DemoQuestionType_QuestionType] NonClustered (QuestionType),
	Constraint [UC_DemoQuestionType_QuestionType] Unique (QuestionType),
	Constraint [PK_DemoQuestionType_QuestionTypeId] Primary Key (QuestionTypeId),
	Constraint [FK_DemoQuestionType_DateCreatedBy] Foreign Key (DateCreatedBy) References [dbo].[I](IId),
	Constraint [FK_DemoQuestionType_DateUpdatedBy] Foreign Key (DateUpdatedBy) References [dbo].[I](IId)
)
With (System_Versioning = On (History_Table = Demo.QuestionTypeLog))
Go

Create Table Demo.Question (
	QuestionId int Not Null Identity(1,1) Constraint [PK_DemoQuestion_QuestionId] Primary Key,
	QuestionTypeId int Not Null,
	Question nvarchar(max) Not Null ,
	SectionId int Not Null,
	Sort int Null Default 0,
	[Status] bit Null Default 1,
	AudioMode nvarchar(50) null,
	AudioAddress nvarchar(256) null,
	AudioUpload nvarchar(256) null,
	AudioAutoplay bit null,
	ImageMode nvarchar(50) null,
	ImageAddress nvarchar(256) null,
	ImageUpload nvarchar(256) null,	
	[BrowserIPv4] nvarchar(50) Null,
	[BrowserIPv6] nvarchar(50) Null,
	[BrowserType] nvarchar(255) Null,
	[BrowserName] nvarchar(255) Null,
	[BrowserVersion] nvarchar(255) Null,
	[BrowserMajorVersion] nvarchar(50) Null,
	[BrowserMinorVersion] nvarchar(50) Null,
	[BrowserPlatform] nvarchar(50) Null,
	DateCreated datetimeoffset Null Default SYSDATETIMEOFFSET(),
	DateCreatedBy int Null,
	DateUpdated datetimeoffset Null Default SYSDATETIMEOFFSET(),
	DateUpdatedBy int Null,
	SysDateStart datetime2(3) GENERATED ALWAYS AS ROW START HIDDEN Not Null,
	SysDateEnd datetime2(3) GENERATED ALWAYS AS ROW END HIDDEN Not Null,
	Period For System_Time(SysDateStart, SysDateEnd),
	Constraint [FK_DemoQuestion_QuestionTypeId] Foreign Key (QuestionTypeId) References Demo.QuestionType(QuestionTypeId),
	Constraint [FK_DemoQuestion_SectionId] Foreign Key (SectionId) References Demo.Section(SectionId),
	Constraint [FK_DemoQuestion_DateCreatedBy] Foreign Key (DateCreatedBy) References [dbo].[I](IId),
	Constraint [FK_DemoQuestion_DateUpdatedBy] Foreign Key (DateUpdatedBy) References [dbo].[I](IId)	
)
With (System_Versioning = On (History_Table = Demo.QuestionLog))
Go

Create Table Demo.Answer (
	AnswerId int Not Null Identity(1,1),
	QuestionId int Not Null,
	Answer nvarchar(max) Not Null,
	IsCorrect bit Not Null,
	Sort int Null Default 0,
	ImageMode nvarchar(50) null,
	ImageAddress nvarchar(256) null,
	ImageUpload nvarchar(256) null,
	[BrowserIPv4] nvarchar(50) Null,
	[BrowserIPv6] nvarchar(50) Null,
	[BrowserType] nvarchar(255) Null,
	[BrowserName] nvarchar(255) Null,
	[BrowserVersion] nvarchar(255) Null,
	[BrowserMajorVersion] nvarchar(50) Null,
	[BrowserMinorVersion] nvarchar(50) Null,
	[BrowserPlatform] nvarchar(50) Null,
	DateCreated datetimeoffset Null Default SYSDATETIMEOFFSET(),
	DateCreatedBy int Null,
	DateUpdated datetimeoffset Null Default SYSDATETIMEOFFSET(),
	DateUpdatedBy int Null,
	SysDateStart datetime2(3) GENERATED ALWAYS AS ROW START HIDDEN Not Null,
	SysDateEnd datetime2(3) GENERATED ALWAYS AS ROW END HIDDEN Not Null,
	Period For System_Time(SysDateStart, SysDateEnd),
	Index [IX_QuesitonnaireAnswer_QuestionId] Nonclustered (QuestionId),
	Constraint [PK_DemoAnswer_AnswerId] Primary Key (AnswerId),
	Constraint [FK_DemoAnswer_QuestionId] Foreign Key (QuestionId) References Demo.Question(QuestionId) ON DELETE CASCADE,
	Constraint [FK_DemoAnswer_DateCreatedBy] Foreign Key (DateCreatedBy) References [dbo].[I](IId),
	Constraint [FK_DemoAnswer_DateUpdatedBy] Foreign Key (DateUpdatedBy) References [dbo].[I](IId)
)
With (System_Versioning = On (History_Table = Demo.AnswerLog))
Go

Create Table Demo.Exam (
	ExamId int Not Null Identity(1,1),
	SectionId int Not Null,
	IId nvarchar(50) Not Null,
	SessionId nvarchar(250) Not Null,
	Score decimal(18,2) Null,
	[Status] nvarchar(50) Null Default N'Open' Check ([Status] IN ('Open','Complete')),
	Result nvarchar(50) Null Check (Result IS NULL or Result In ('Passed', 'Failed')),
	Attempt int Null Default 1 Check (Attempt >= 1),
	DateStarted datetimeoffset Null Default SysDateTimeOffSet(),
	DateFinished datetimeoffset Null,
	[BrowserIPv4] nvarchar(50) Null,
	[BrowserIPv6] nvarchar(50) Null,
	[BrowserType] nvarchar(255) Null,
	[BrowserName] nvarchar(255) Null,
	[BrowserVersion] nvarchar(255) Null,
	[BrowserMajorVersion] nvarchar(50) Null,
	[BrowserMinorVersion] nvarchar(50) Null,
	[BrowserPlatform] nvarchar(50) Null,
	DateCreated datetimeoffset Null Default SYSDATETIMEOFFSET(),
	DateCreatedBy int Null,
	DateCreatedBy2 nvarchar(50) Null,
	DateUpdated datetimeoffset Null Default SYSDATETIMEOFFSET(),
	DateUpdatedBy int Null,
	DateUpdatedBy2 nvarchar(50) Null,
	SysDateStart datetime2(3) GENERATED ALWAYS AS ROW START HIDDEN Not Null,
	SysDateEnd datetime2(3) GENERATED ALWAYS AS ROW END HIDDEN Not Null,
	Period For System_Time(SysDateStart, SysDateEnd),
	Index [IX_DemoExam_IId] Nonclustered (IId),
	Constraint [PK_DemoExam_ExamId] Primary Key (ExamId),
	Constraint [FK_DemoExam_SectionId] Foreign Key (SectionId) References Demo.Section(SectionId),
	Constraint [FK_DemoExam_DateCreatedBy] Foreign Key (DateCreatedBy) References [dbo].[I](IId),
	Constraint [FK_DemoExam_DateUpdatedBy] Foreign Key (DateUpdatedBy) References [dbo].[I](IId)
)
With (System_Versioning = On (History_Table = Demo.ExamLog))
Go

Create Table Demo.ExamAnswer (
	ExamAnswerId int Not Null Identity(1,1),
	ExamId int Not Null,
	QuestionId int Not Null,
	AnswerId int Null,
	Answer nvarchar(max) Null,
	[BrowserIPv4] nvarchar(50) Null,
	[BrowserIPv6] nvarchar(50) Null,
	[BrowserType] nvarchar(255) Null,
	[BrowserName] nvarchar(255) Null,
	[BrowserVersion] nvarchar(255) Null,
	[BrowserMajorVersion] nvarchar(50) Null,
	[BrowserMinorVersion] nvarchar(50) Null,
	[BrowserPlatform] nvarchar(50) Null,
	DateCreated datetimeoffset Null Default SYSDATETIMEOFFSET(),
	DateCreatedBy int Null,
	DateCreatedBy2 nvarchar(50) Null,
	DateUpdated datetimeoffset Null Default SYSDATETIMEOFFSET(),
	DateUpdatedBy int Null,
	DateUpdatedBy2 nvarchar(50) Null,
	SysDateStart datetime2(3) GENERATED ALWAYS AS ROW START HIDDEN Not Null,
	SysDateEnd datetime2(3) GENERATED ALWAYS AS ROW END HIDDEN Not Null,
	Period For System_Time(SysDateStart, SysDateEnd),
	Constraint [PK_DemoExamAnswer_ExamAnswerId] Primary Key (ExamAnswerId),
	Constraint [FK_DemoExamAnswer_ExamId] Foreign Key (ExamId) References Demo.Exam(ExamId) ON DELETE CASCADE,
	Constraint [FK_DemoExamAnswer_QuestionId] Foreign Key (QuestionId) References Demo.Question(QuestionId) ON DELETE CASCADE,
	Constraint [FK_DemoExamAnswer_AnswerId] Foreign Key (AnswerId) References Demo.Answer(AnswerId),
	Constraint [FK_DemoExamAnswer_DateCreatedBy] Foreign Key (DateCreatedBy) References [dbo].[I](IId),
	Constraint [FK_DemoExamAnswer_DateUpdatedBy] Foreign Key (DateUpdatedBy) References [dbo].[I](IId)
)
With (System_Versioning = On (History_Table = Demo.ExamAnswerLog))
Go
