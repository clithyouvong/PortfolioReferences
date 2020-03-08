
/*
  This code is a working file used for everyday references.
  
  This code demonstrates a creation of a CRUD system with the use of Temporalized Tables.
  Results may vary based on company implementation.
  
  The following code demonstrates SQL interpretations used in SQL Azure 2016.
  
  This is not a copy of any current implementation of any company.
*/


Create Table Questionnaire.CourseType (
	CourseTypeId int Not Null Identity(1,1),
	CourseType nvarchar(100) Not Null,
	DateCreated datetimeoffset Null Default SYSDATETIMEOFFSET(),
	DateCreatedBy int Null ,
	DateUpdated datetimeoffset Null Default SYSDATETIMEOFFSET(),
	DateUpdatedBy int Null,
	SysDateStart datetime2(3) GENERATED ALWAYS AS ROW START HIDDEN Not Null,
	SysDateEnd datetime2(3) GENERATED ALWAYS AS ROW END HIDDEN Not Null,
	Period For System_Time(SysDateStart, SysDateEnd),
	Index [IX_QuestionnaireCourseType_CourseType] Nonclustered (CourseType),
	Constraint [PK_QuestionnaireCourseType_CourseTypeId] Primary Key (CourseTypeId),
	Constraint [UC_QuestionnaireCourseType_CourseType] Unique (CourseType),
	Constraint [FK_QuestionnaireCourseType_DateCreatedBy] Foreign Key (DateCreatedBy) References [dbo].[I](IId),
	Constraint [FK_QuestionnaireCourseType_DateUpdatedBy] Foreign Key (DateUpdatedBy) References [dbo].[I](IId)
)
With (System_Versioning = On (History_Table = Questionnaire.CourseTypeLog))
Go

Create Table Questionnaire.Course (
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
	Index [IX_QuestionnaireCourse_Course] NonClustered (Course),
	Index [IX_QuestionnaireCourse_CourseTypeId] Nonclustered (CourseTypeId),
	Constraint [PK_QuestionnaireCourse_CourseId] Primary Key (CourseId),
	Constraint [UC_QuestionnaireCourse_Course] Unique (CourseTypeId, Course), 
	Constraint [FK_QuestionnaireCourse_CourseTypeId] Foreign Key (CourseTypeId) References Questionnaire.CourseType(CourseTypeId),
	Constraint [FK_QuestionnaireCourse_DateCreatedBy] Foreign Key (DateCreatedBy) References [dbo].[I](IId),
	Constraint [FK_QuestionnaireCourse_DateUpdatedBy] Foreign Key (DateUpdatedBy) References [dbo].[I](IId)
)
With (System_Versioning = On (History_Table = Questionnaire.CourseLog))
Go


Create Table Questionnaire.Section (
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
	Index [IX_QuestionnaireSection_CourseId] Nonclustered (CourseId), 
	Index [IX_QuestionnaireSection_Section] NonClustered (Section),
	Constraint [PK_QuestionnaireSection_SectionId] Primary Key (SectionId),
	Constraint [FK_QuestionnaireSection_CourseId] Foreign Key (CourseId) References Questionnaire.Course(CourseId),
	Constraint [FK_QuestionnaireSection_DateCreatedBy] Foreign Key (DateCreatedBy) References [dbo].[I](IId),
	Constraint [FK_QuestionnaireSection_DateUpdatedBy] Foreign Key (DateUpdatedBy) References [dbo].[I](IId)
)
With (System_Versioning = On (History_Table = Questionnaire.SectionLog))
Go

Create Table Questionnaire.QuestionType (
	QuestionTypeId int Not Null Identity(1,1),
	QuestionType nvarchar(50) Not Null,
	DateCreated datetimeoffset Null Default SYSDATETIMEOFFSET(),
	DateCreatedBy int Null ,
	DateUpdated datetimeoffset Null Default SYSDATETIMEOFFSET(),
	DateUpdatedBy int Null ,
	SysDateStart datetime2(3) GENERATED ALWAYS AS ROW START HIDDEN Not Null,
	SysDateEnd datetime2(3) GENERATED ALWAYS AS ROW END HIDDEN Not Null,
	Period For System_Time(SysDateStart, SysDateEnd),
	Index [IX_QuestionnaireQuestionType_QuestionType] NonClustered (QuestionType),
	Constraint [UC_QuestionnaireQuestionType_QuestionType] Unique (QuestionType),
	Constraint [PK_QuestionnaireQuestionType_QuestionTypeId] Primary Key (QuestionTypeId),
	Constraint [FK_QuestionnaireQuestionType_DateCreatedBy] Foreign Key (DateCreatedBy) References [dbo].[I](IId),
	Constraint [FK_QuestionnaireQuestionType_DateUpdatedBy] Foreign Key (DateUpdatedBy) References [dbo].[I](IId)
)
With (System_Versioning = On (History_Table = Questionnaire.QuestionTypeLog))
Go

Create Table Questionnaire.Question (
	QuestionId int Not Null Identity(1,1) Constraint [PK_QuestionnaireQuestion_QuestionId] Primary Key,
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
	Constraint [FK_QuestionnaireQuestion_QuestionTypeId] Foreign Key (QuestionTypeId) References Questionnaire.QuestionType(QuestionTypeId),
	Constraint [FK_QuestionnaireQuestion_SectionId] Foreign Key (SectionId) References Questionnaire.Section(SectionId),
	Constraint [FK_QuestionnaireQuestion_DateCreatedBy] Foreign Key (DateCreatedBy) References [dbo].[I](IId),
	Constraint [FK_QuestionnaireQuestion_DateUpdatedBy] Foreign Key (DateUpdatedBy) References [dbo].[I](IId)	
)
With (System_Versioning = On (History_Table = Questionnaire.QuestionLog))
Go

Create Table Questionnaire.Answer (
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
	Constraint [PK_QuestionnaireAnswer_AnswerId] Primary Key (AnswerId),
	Constraint [FK_QuestionnaireAnswer_QuestionId] Foreign Key (QuestionId) References Questionnaire.Question(QuestionId) ON DELETE CASCADE,
	Constraint [FK_QuestionnaireAnswer_DateCreatedBy] Foreign Key (DateCreatedBy) References [dbo].[I](IId),
	Constraint [FK_QuestionnaireAnswer_DateUpdatedBy] Foreign Key (DateUpdatedBy) References [dbo].[I](IId)
)
With (System_Versioning = On (History_Table = Questionnaire.AnswerLog))
Go

Create Table Questionnaire.Exam (
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
	Index [IX_QuestionnaireExam_IId] Nonclustered (IId),
	Constraint [PK_QuestionnaireExam_ExamId] Primary Key (ExamId),
	Constraint [FK_QuestionnaireExam_SectionId] Foreign Key (SectionId) References Questionnaire.Section(SectionId),
	Constraint [FK_QuestionnaireExam_DateCreatedBy] Foreign Key (DateCreatedBy) References [dbo].[I](IId),
	Constraint [FK_QuestionnaireExam_DateUpdatedBy] Foreign Key (DateUpdatedBy) References [dbo].[I](IId)
)
With (System_Versioning = On (History_Table = Questionnaire.ExamLog))
Go

Create Table Questionnaire.ExamAnswer (
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
	Constraint [PK_QuestionnaireExamAnswer_ExamAnswerId] Primary Key (ExamAnswerId),
	Constraint [FK_QuestionnaireExamAnswer_ExamId] Foreign Key (ExamId) References Questionnaire.Exam(ExamId) ON DELETE CASCADE,
	Constraint [FK_QuestionnaireExamAnswer_QuestionId] Foreign Key (QuestionId) References Questionnaire.Question(QuestionId) ON DELETE CASCADE,
	Constraint [FK_QuestionnaireExamAnswer_AnswerId] Foreign Key (AnswerId) References Questionnaire.Answer(AnswerId),
	Constraint [FK_QuestionnaireExamAnswer_DateCreatedBy] Foreign Key (DateCreatedBy) References [dbo].[I](IId),
	Constraint [FK_QuestionnaireExamAnswer_DateUpdatedBy] Foreign Key (DateUpdatedBy) References [dbo].[I](IId)
)
With (System_Versioning = On (History_Table = Questionnaire.ExamAnswerLog))
Go
