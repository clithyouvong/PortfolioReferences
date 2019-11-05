/*
	Script to import the Questionnaire system into the Questionnaire v4 System.
*/
/*
Select 
	'NEW DATA',
	(select count(*) from Questionnaire.Course) as 'Courses',
	(select count(*) from Questionnaire.Section) as 'Sections',
	(select count(*) from Questionnaire.Question) as 'Questions',
	(select count(*) from Questionnaire.Answer) as 'Answers',
	(select count(*) from Questionnaire.Exam) as 'Exams',
	(select count(*) from Questionnaire.ExamAnswer) as 'ExamAnswers'


Select 
	'OLD DATA',
	(select count(*) from QuestionnaireCourse) as 'Courses',
	(select count(*) from QuestionnaireSection) as 'Sections',
	(select count(*) from QuestionnaireQuestion) as 'Questions',
	(select count(*) from QuestionnaireAnswer) as 'Answers',
	(select count(*) from QuestionnaireExam) as 'Exams',
	(select count(*) from QuestionnaireExamAnswer) as 'ExamAnswers'

-- Searches the DB for Temporal Tables with standard names that are no longer associated with their adjoining tables
select	t.name, 
		'drop table Questionnaire.' + t.name 
from	sys.tables t 
where	t.name like 'MSSQL_TemporalHistoryFor%' and 
		t.schema_id = 9 and 
		t.temporal_type_desc = 'NON_TEMPORAL_TABLE'



-- Searches the CourseRequirement for matches of Assignments
select	 cr.CourseReqId, cr.courseid, cr.coursetypeid, cr.reqtype, cr.reqname, cr.setid, cr.SystemMethodInfo1, cr.SystemMethodInfo2,
		 case ReqName
			when 'Khan Module 1' then 'Insert into Questionnaire.Assignment (SectionId, CourseReqId, DateCreatedBy, DateUpdatedBy) Values (72,'+convert(nvarchar, cr.coursereqid) + ',54306,54306);' 
			when 'Khan Module 2' then 'Insert into Questionnaire.Assignment (SectionId, CourseReqId, DateCreatedBy, DateUpdatedBy) Values (75,'+convert(nvarchar, cr.coursereqid) + ',54306,54306);' 
			when 'Khan Module 3' then 'Insert into Questionnaire.Assignment (SectionId, CourseReqId, DateCreatedBy, DateUpdatedBy) Values (82,'+convert(nvarchar, cr.coursereqid) + ',54306,54306);' 
			when 'Khan Module 4' then 'Insert into Questionnaire.Assignment (SectionId, CourseReqId, DateCreatedBy, DateUpdatedBy) Values (81,'+convert(nvarchar, cr.coursereqid) + ',54306,54306);' 
			when 'Khan Module 5' then 'Insert into Questionnaire.Assignment (SectionId, CourseReqId, DateCreatedBy, DateUpdatedBy) Values (84,'+convert(nvarchar, cr.coursereqid) + ',54306,54306);' 
			else
				 'Insert into Questionnaire.Assignment (SectionId, CourseReqId, DateCreatedBy, DateUpdatedBy) Values (' + convert(nvarchar,(
					select  --max(s2.sectionid)
							(
								Select	max(s3.sectionid)
								from	Questionnaire.Section S3
								Where	S3.Section = S2.Section
							)
					from	dbo.[QuestionnaireSection] S2
					Where	s2.ReqType = cr.reqtype and
							s2.ReqName = cr.reqname
				 )) + ',' +convert(nvarchar, cr.coursereqid) + ',54306,54306);' 
		 end
from	 CourseRequirements cr
where	 cr.courseid in (111,113) and 
		 cr.SystemMethod is not null and 
		 cr.SystemMethod = 'topic'
order by courseid, reqname
*/

-- -------------------------------------------------------------------------
-- [0a] NEIEP Help Page Part 1
-- -------------------------------------------------------------------------
update dbo.NEIEPHelpPage
set   SectionId = null
where QuestionnaireSectionId is not null;
go

-- -------------------------------------------------------------------------
-- [0b] Delete the Questionnaire Exam/Data System...
-- -------------------------------------------------------------------------
alter table Questionnaire.ExamAnswer SET (system_versioning = off)
go
alter table Questionnaire.Exam SET (System_versioning = off)
go

ALTER TABLE [Questionnaire].[ExamAnswer] DROP CONSTRAINT [FK_QuestionnaireExamAnswer_ExamId]
GO

Truncate Table Questionnaire.ExamAnswer
go
Truncate Table Questionnaire.Exam
go

alter table Questionnaire.ExamAnswer SET (system_versioning = on)
go
alter table Questionnaire.Exam SET (System_versioning = on)
go

ALTER TABLE [Questionnaire].[ExamAnswer]  WITH CHECK ADD  CONSTRAINT [FK_QuestionnaireExamAnswer_ExamId] FOREIGN KEY([ExamId])
REFERENCES [Questionnaire].[Exam] ([ExamId])
ON DELETE CASCADE
GO

ALTER TABLE [Questionnaire].[ExamAnswer] CHECK CONSTRAINT [FK_QuestionnaireExamAnswer_ExamId]
GO



-- -------------------------------------------------------------------------
-- [1] Delete the Assignments
-- -------------------------------------------------------------------------
Create table #Assignments (
	CourseReqId int,
	SectionId int
)
Insert into #Assignments (
	CourseReqId,
	SectionId
)
Select	CourseReqId,
		SectionId 
From	Questionnaire.Assignment;

Delete	From Questionnaire.Assignment
go

alter table Questionnaire.Assignment SET (system_versioning = off)
go
--truncate table Questionnaire.AssignmentLog 
go
alter table Questionnaire.Assignment SET (System_versioning = on)
go

		
-- -------------------------------------------------------------------------
-- [2] Delete the Questionnaire Answer/Question/Section/Course System...
-- -------------------------------------------------------------------------
Delete	From Questionnaire.Answer
go
				
Delete	From Questionnaire.Question
go

Delete  From Questionnaire.Section
go

Delete  From Questionnaire.Course
go


alter table Questionnaire.Answer SET (system_versioning = off)
go
--truncate table Questionnaire.AnswerLog 
go
alter table Questionnaire.Answer SET (System_versioning = on)
go

alter table Questionnaire.Question SET (system_versioning = off)
go
--truncate table Questionnaire.QuestionLog 
go
alter table Questionnaire.Question SET (System_versioning = on)
go

alter table Questionnaire.Section SET (system_versioning = off)
go
--truncate table Questionnaire.SectionLog 
go
alter table Questionnaire.Section SET (System_versioning = on)
go

alter table Questionnaire.Course SET (system_versioning = off)
go
--truncate table Questionnaire.CourseLog 
go
alter table Questionnaire.Course SET (System_versioning = on)
go


-- -------------------------------------------------------------------------
-- [1] Readd the Exam / ExamAnswer Testing data 
-- -------------------------------------------------------------------------
DBCC CHECKIDENT ('Questionnaire.Assignment', RESEED, 1)  
go
DBCC CHECKIDENT ('Questionnaire.Exam', RESEED, 1)  
go
DBCC CHECKIDENT ('Questionnaire.ExamAnswer', RESEED, 1)  
go
DBCC CHECKIDENT ('Questionnaire.Answer', RESEED, 1)  
go
DBCC CHECKIDENT ('Questionnaire.Question', RESEED, 1)  
go
DBCC CHECKIDENT ('Questionnaire.Section', RESEED, 1)  
go
DBCC CHECKIDENT ('Questionnaire.Course', RESEED, 1)  
go

SET IDENTITY_INSERT [Questionnaire].[Course] ON 
INSERT [Questionnaire].[Course] ([CourseId], [CourseTypeId], [Course], [Status], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy]) VALUES (1, 4, N'Penguins 101', 1, N'192.168.1.180', N'::1', N'Chrome74', N'Chrome', N'74.0', N'74', N'0', N'WinNT', CAST(N'2019-04-24T09:49:26.8392997-05:00' AS DateTimeOffset), 54306, CAST(N'2019-05-08T13:47:03.0229124-04:00' AS DateTimeOffset), 54306)
SET IDENTITY_INSERT [Questionnaire].[Course] OFF

SET IDENTITY_INSERT [Questionnaire].[Section] ON 
INSERT [Questionnaire].[Section] ([SectionId], [CourseId], [Section], [Status], [IsIntroductionVisible], [Introduction], [IntroductionAudioMode], [IntroductionAudioAddress], [IntroductionAudioUpload], [IntroductionImageMode], [IntroductionImageAddress], [IntroductionImageUpload], [IsConclusionVisible], [Conclusion], [ConclusionAudioMode], [ConclusionAudioAddress], [ConclusionAudioUpload], [ConclusionImageMode], [ConclusionImageAddress], [ConclusionImageUpload], [AllowRetake], [Threshold], [HeaderText], [IsQuestionsSkipable], [IsTableOfContentsVisible], [IsTemplate], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [IsArchived], [IsAnswersRandomized], [IsQuestionsRandomized], [AllowRetakeAboveThreshold], [ShowScore]) VALUES (1, 1, N'Emperor Penguins 1', 1, 1, N'<div style="margin: 0px 14.3906px 0px 28.7969px; padding: 0px; width: 436.797px; float: left; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px;"><p style="margin: 0px 0px 15px; padding: 0px; text-align: justify;"><strong style="margin: 0px; padding: 0px;">Lorem Ipsum</strong>&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry&#39;s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.</p><div>&nbsp;</div></div><div style="margin: 0px 28.7969px 0px 14.3906px; padding: 0px; width: 436.797px; float: right; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px;">&nbsp;</div>', N'Upload', N'', N'Introduction audio (1).mp3', N'Address', N'https://unsplash.it/600/600', N'tuxs.jpg', 1, N'<div style="margin: 0px 28.7969px 0px 14.3906px; padding: 0px; width: 436.797px; float: right; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px;"><h2 style="margin: 0px 0px 10px; padding: 0px; line-height: 24px; font-family: DauphinPlain; font-size: 24px;">Why do we use it?</h2><p style="margin: 0px 0px 15px; padding: 0px; text-align: justify;">It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using &#39;Content here, content here&#39;, making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for &#39;lorem ipsum&#39; will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).</p></div>&nbsp;<div style="margin: 0px 14.3906px 0px 28.7969px; padding: 0px; width: 436.797px; float: left; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px;"><h2 style="margin: 0px 0px 10px; padding: 0px; line-height: 24px; font-family: DauphinPlain; font-size: 24px;">Where does it come from?</h2><p style="margin: 0px 0px 15px; padding: 0px; text-align: justify;">Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of &quot;de Finibus Bonorum et Malorum&quot; (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, &quot;Lorem ipsum dolor sit amet..&quot;, comes from a line in section 1.10.32.</p><p style="margin: 0px 0px 15px; padding: 0px; text-align: justify;">The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from &quot;de Finibus Bonorum et Malorum&quot; by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.</p></div><div style="margin: 0px 28.7969px 0px 14.3906px; padding: 0px; width: 436.797px; float: right; color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px;"><h2 style="margin: 0px 0px 10px; padding: 0px; line-height: 24px; font-family: DauphinPlain; font-size: 24px;">Where can I get some?</h2><p style="margin: 0px 0px 15px; padding: 0px; text-align: justify;">There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don&#39;t look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn&#39;t anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.</p></div>', N'Upload', N'', N'SampleAudio_0.4mb.mp3', N'Upload', N'', N'penguin-150563__340.png', 1, 70, N'The Grand Penguin Test Exam 101', 1, 1, 0, N'192.168.1.180', N'::1', N'Chrome74', N'Chrome', N'74.0', N'74', N'0', N'WinNT', CAST(N'2019-04-24T10:49:53.6096023-04:00' AS DateTimeOffset), 54306, CAST(N'2019-05-08T13:48:08.5903338-04:00' AS DateTimeOffset), 54306, 0, 0, 0, 1, 1)
SET IDENTITY_INSERT [Questionnaire].[Section] OFF

SET IDENTITY_INSERT [Questionnaire].[Question] ON 
INSERT [Questionnaire].[Question] ([QuestionId], [QuestionTypeId], [Question], [SectionId], [Sort], [Status], [AudioMode], [AudioAddress], [AudioUpload], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [Note], [IsNoteShownOnNew], [IsNoteShownOnReview]) VALUES (1, 1, N'How Many E&#39;s are in NEIEP?&nbsp;', 1, 10, 1, N'', N'', N'', N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:50:13.9695421-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T09:50:13.9695421-05:00' AS DateTimeOffset), 54306, N'', 0, 0)
INSERT [Questionnaire].[Question] ([QuestionId], [QuestionTypeId], [Question], [SectionId], [Sort], [Status], [AudioMode], [AudioAddress], [AudioUpload], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [Note], [IsNoteShownOnNew], [IsNoteShownOnReview]) VALUES (2, 8, N'On a scale from strongly disagree to strongly agree, how would you rate this statement?<br /><br /><br />Game of thrones is the better than NCIS?&nbsp;<br />&nbsp;', 1, 20, 1, N'', N'', N'', N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:51:47.2084834-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T11:58:18.1027339-04:00' AS DateTimeOffset), 54306, N'The Game of thones season takes part in westeros and everything to do with the real life british Iles.&nbsp;<br /><br />NCIS is about bad guys doing bad things and somewhat good guys trying to stop bad guys from doing bad things.&nbsp;', 0, 1)
INSERT [Questionnaire].[Question] ([QuestionId], [QuestionTypeId], [Question], [SectionId], [Sort], [Status], [AudioMode], [AudioAddress], [AudioUpload], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [Note], [IsNoteShownOnNew], [IsNoteShownOnReview]) VALUES (3, 3, N'Name a synonym for a car.', 1, 30, 1, N'', N'', N'', N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:52:17.2976671-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T12:01:02.6236634-04:00' AS DateTimeOffset), 54306, N'All answers are not case sensitive. We found some issues with some members not understanding this question. Please refer to Chapter 2 on page 630 in the section &#39;Synonyms for Cars&#39; for more information.&nbsp;', 1, 0)
INSERT [Questionnaire].[Question] ([QuestionId], [QuestionTypeId], [Question], [SectionId], [Sort], [Status], [AudioMode], [AudioAddress], [AudioUpload], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [Note], [IsNoteShownOnNew], [IsNoteShownOnReview]) VALUES (4, 5, N'True or False,&nbsp;<br /><br />My Name is the Lord Honorable Penguin, The First of his name, Ruler of the Andelles of Men and Protector of the Ice Keep in the West.&nbsp;', 1, 40, 1, N'', N'', N'', N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:54:15.6122383-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T12:00:54.9425051-04:00' AS DateTimeOffset), 54306, N'', 0, 0)
INSERT [Questionnaire].[Question] ([QuestionId], [QuestionTypeId], [Question], [SectionId], [Sort], [Status], [AudioMode], [AudioAddress], [AudioUpload], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [Note], [IsNoteShownOnNew], [IsNoteShownOnReview]) VALUES (5, 4, N'Questions, Comments, or Concerns?&nbsp;', 1, 50, 1, N'', N'', N'', N'Upload', N'', N'istock-511366776.jpg', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:54:50.0018711-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T12:38:46.8632108-04:00' AS DateTimeOffset), 54306, N'', 0, 0)
INSERT [Questionnaire].[Question] ([QuestionId], [QuestionTypeId], [Question], [SectionId], [Sort], [Status], [AudioMode], [AudioAddress], [AudioUpload], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [Note], [IsNoteShownOnNew], [IsNoteShownOnReview]) VALUES (6, 2, N'Select all of the European cities listed below. Note, you must get all the answer correct to receive credit.&nbsp;', 1, 60, 1, N'Upload', N'', N'file_example_MP3_1MG.mp3', N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:55:50.6151832-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T12:40:35.2373257-04:00' AS DateTimeOffset), 54306, N'', 0, 0)
INSERT [Questionnaire].[Question] ([QuestionId], [QuestionTypeId], [Question], [SectionId], [Sort], [Status], [AudioMode], [AudioAddress], [AudioUpload], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [Note], [IsNoteShownOnNew], [IsNoteShownOnReview]) VALUES (7, 2, N'Select all of the American Cities. Note, you&#39;ll receive partial credit for every correct answer you provide.&nbsp;', 1, 70, 1, N'', N'', N'', N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T10:03:12.0073941-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T12:45:47.3733090-04:00' AS DateTimeOffset), 54306, N'', 0, 0)
INSERT [Questionnaire].[Question] ([QuestionId], [QuestionTypeId], [Question], [SectionId], [Sort], [Status], [AudioMode], [AudioAddress], [AudioUpload], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [Note], [IsNoteShownOnNew], [IsNoteShownOnReview]) VALUES (8, 15, N'Name the following musical instruments with the following Instrumental Families.<br /><br />You must answer all the question correctly to receive credit.&nbsp;', 1, 80, 1, N'', N'', N'', N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T10:22:04.3110319-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T12:49:29.8535084-04:00' AS DateTimeOffset), 54306, N'', 0, 0)
INSERT [Questionnaire].[Question] ([QuestionId], [QuestionTypeId], [Question], [SectionId], [Sort], [Status], [AudioMode], [AudioAddress], [AudioUpload], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [Note], [IsNoteShownOnNew], [IsNoteShownOnReview]) VALUES (9, 15, N'Match any of the corresponding musical instruments with the number of Reeds that are required to play,<br /><br />You&#39;ll receive partial credit for each correctly answered question.&nbsp;', 1, 90, 1, N'', N'', N'', N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T10:31:30.0456808-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T13:00:46.3498016-04:00' AS DateTimeOffset), 54306, N'', 0, 0)
SET IDENTITY_INSERT [Questionnaire].[Question] OFF

SET IDENTITY_INSERT [Questionnaire].[Answer] ON 
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (1, 1, N'1', 0, 10, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:50:20.1841024-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T09:50:20.1841024-05:00' AS DateTimeOffset), 54306,100, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (2, 1, N'5', 0, 20, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:50:23.4842335-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T09:50:23.4842335-05:00' AS DateTimeOffset), 54306,100, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (3, 1, N'2', 1, 30, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:50:27.5334728-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T09:50:27.5334728-05:00' AS DateTimeOffset), 54306,100, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (4, 1, N'4', 0, 40, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:50:30.4130143-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T09:50:30.4130143-05:00' AS DateTimeOffset), 54306,100, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (5, 2, N'Strongly Disagree', 1, 1, NULL, NULL, NULL, N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:51:47.2084834-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T09:51:47.2084834-05:00' AS DateTimeOffset), 54306,100, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (6, 2, N'Disagree', 1, 2, NULL, NULL, NULL, N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:51:47.2084834-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T09:51:47.2084834-05:00' AS DateTimeOffset), 54306,100, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (7, 2, N'Neither Disagree or Agree', 1, 3, NULL, NULL, NULL, N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:51:47.2084834-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T09:51:47.2084834-05:00' AS DateTimeOffset), 54306,100, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (8, 2, N'Agree', 1, 4, NULL, NULL, NULL, N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:51:47.2084834-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T09:51:47.2084834-05:00' AS DateTimeOffset), 54306,100, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (9, 2, N'Strongly Agree', 1, 5, NULL, NULL, NULL, N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:51:47.2084834-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T09:51:47.2084834-05:00' AS DateTimeOffset), 54306,100, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (10, 3, N'automobile', 1, 10, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:52:29.3698124-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T09:52:29.3698124-05:00' AS DateTimeOffset), 54306,100, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (11, 3, N'auto', 1, 20, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:52:34.1575138-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T09:52:34.1575138-05:00' AS DateTimeOffset), 54306,100, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (12, 3, N'buggy', 1, 30, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:52:45.5386463-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T09:52:45.5386463-05:00' AS DateTimeOffset), 54306,100, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (13, 3, N'cart', 1, 40, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:52:53.7126338-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T09:52:53.7126338-05:00' AS DateTimeOffset), 54306,100, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (14, 3, N'carriage', 1, 50, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:52:59.0886109-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T09:52:59.0886109-05:00' AS DateTimeOffset), 54306,100, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (15, 4, N'True', 1, 1, NULL, NULL, NULL, N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:54:15.6122383-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T09:54:15.6122383-05:00' AS DateTimeOffset), 54306,100, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (16, 4, N'False', 0, 2, NULL, NULL, NULL, N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:54:15.6122383-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T09:54:15.6122383-05:00' AS DateTimeOffset), 54306,100, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (17, 5, N'Long Answer', 1, 1, NULL, NULL, NULL, N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:54:50.0018711-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T09:54:50.0018711-05:00' AS DateTimeOffset), 54306,100, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (18, 6, N'Paris', 1, 10, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:55:57.2157043-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T09:55:57.2157043-05:00' AS DateTimeOffset), 54306,100, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (19, 6, N'Rome', 1, 20, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:56:01.6103502-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T10:56:17.9168763-04:00' AS DateTimeOffset), 54306,100, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (20, 6, N'New York', 0, 30, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:56:07.4991450-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T09:56:07.4991450-05:00' AS DateTimeOffset), 54306,100, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (21, 6, N'Chicago', 0, 40, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T09:56:12.6412238-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T09:56:12.6412238-05:00' AS DateTimeOffset), 54306, 100, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (22, 7, N'New York', 1, 10, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T10:03:33.8591460-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T10:03:33.8591460-05:00' AS DateTimeOffset), 54306, 25, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (23, 7, N'Seattle', 1, 20, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T10:03:48.6845765-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T10:03:48.6845765-05:00' AS DateTimeOffset), 54306, 25, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (24, 7, N'Bangkok', 0, 30, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T10:04:03.9405118-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T10:04:03.9405118-05:00' AS DateTimeOffset), 54306,  25, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (25, 7, N'Tokyo', 0, 40, N'Upload', N'', N'Alert_Yellow.png', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T10:04:56.9829367-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T10:04:56.9829367-05:00' AS DateTimeOffset), 54306, 25, N'')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (26, 8, N'Clarinet', 1, 10, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T10:22:28.3870174-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T10:22:28.3870174-05:00' AS DateTimeOffset), 54306,  100, N'Woodwind')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (27, 8, N'French Horn', 1, 20, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T10:22:49.4114174-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T11:23:37.9768161-04:00' AS DateTimeOffset), 54306,100, N'Brass')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (28, 8, N'Xylophone&nbsp;', 1, 30, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T10:23:06.3812343-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T10:23:06.3812343-05:00' AS DateTimeOffset), 54306,100, N'Percussion')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (29, 8, N'Violin', 1, 40, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T10:23:22.8190885-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T10:23:22.8190885-05:00' AS DateTimeOffset), 54306,100, N'String')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (30, 9, N'Clarinet', 1, 10, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T10:31:53.6100849-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T10:31:53.6100849-05:00' AS DateTimeOffset), 54306, 25, N'1 Reed')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (31, 9, N'Oboe', 1, 20, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T10:32:10.3252017-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T10:32:10.3252017-05:00' AS DateTimeOffset), 54306, 25, N'2 Reed')
INSERT [Questionnaire].[Answer] ([AnswerId], [QuestionId], [Answer], [IsCorrect], [Sort], [ImageMode], [ImageAddress], [ImageUpload], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateUpdated], [DateUpdatedBy], [ScaledWorthPercentage], [Answer2]) VALUES (32, 9, N'Bass Drum', 1, 30, N'', N'', N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T10:32:35.7810127-05:00' AS DateTimeOffset), 54306, CAST(N'2019-04-24T11:40:23.9475260-04:00' AS DateTimeOffset), 54306, 100, N'0 Reed')
SET IDENTITY_INSERT [Questionnaire].[Answer] OFF

SET IDENTITY_INSERT [Questionnaire].[Exam] ON 
INSERT [Questionnaire].[Exam] ([ExamId], [SectionId], [IndividualId], [SessionId], [Score], [Status], [Attempt], [DateStarted], [DateFinished], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateCreatedBy2], [DateUpdated], [DateUpdatedBy], [DateUpdatedBy2]) VALUES (1, 1, N'0', N'00000000-0000-0000-0000-000000000000', CAST(0.00 AS Decimal(18, 2)), N'Open', 1, CAST(N'2019-04-24T11:20:21.1219184-04:00' AS DateTimeOffset), NULL, N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T11:20:21.1219184-04:00' AS DateTimeOffset), NULL, N'0', CAST(N'2019-04-24T11:20:21.1219184-04:00' AS DateTimeOffset), NULL, N'0')
INSERT [Questionnaire].[Exam] ([ExamId], [SectionId], [IndividualId], [SessionId], [Score], [Status], [Attempt], [DateStarted], [DateFinished], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateCreatedBy2], [DateUpdated], [DateUpdatedBy], [DateUpdatedBy2]) VALUES (2, 1, N'54306', N'CA64DB1E-CFEA-48A9-8715-03E7ACAD3C91', CAST(40.78 AS Decimal(18, 2)), N'Failed', 2, CAST(N'2019-04-24T16:01:59.4196656-04:00' AS DateTimeOffset), CAST(N'2019-04-29T10:26:54.9754348-05:00' AS DateTimeOffset), N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-24T15:01:59.4196656-05:00' AS DateTimeOffset), 54306, N'54306', CAST(N'2019-04-29T10:26:54.9754348-05:00' AS DateTimeOffset), 54306, N'54306')
SET IDENTITY_INSERT [Questionnaire].[Exam] OFF

SET IDENTITY_INSERT [Questionnaire].[ExamAnswer] ON 
INSERT [Questionnaire].[ExamAnswer] ([ExamAnswerId], [ExamId], [QuestionId], [AnswerId], [Answer], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateCreatedBy2], [DateUpdated], [DateUpdatedBy], [DateUpdatedBy2]) VALUES (1, 2, 1, 3, N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-29T09:06:37.1271288-05:00' AS DateTimeOffset), 54306, N'54306', CAST(N'2019-04-29T09:06:37.1271288-05:00' AS DateTimeOffset), 54306, N'54306')
INSERT [Questionnaire].[ExamAnswer] ([ExamAnswerId], [ExamId], [QuestionId], [AnswerId], [Answer], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateCreatedBy2], [DateUpdated], [DateUpdatedBy], [DateUpdatedBy2]) VALUES (2, 2, 2, 6, N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-29T09:06:39.5809125-05:00' AS DateTimeOffset), 54306, N'54306', CAST(N'2019-04-29T09:06:39.5809125-05:00' AS DateTimeOffset), 54306, N'54306')
INSERT [Questionnaire].[ExamAnswer] ([ExamAnswerId], [ExamId], [QuestionId], [AnswerId], [Answer], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateCreatedBy2], [DateUpdated], [DateUpdatedBy], [DateUpdatedBy2]) VALUES (3, 2, 3, NULL, N'fdsaf', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-29T09:06:42.7511325-05:00' AS DateTimeOffset), 54306, N'54306', CAST(N'2019-04-29T09:06:42.7511325-05:00' AS DateTimeOffset), 54306, N'54306')
INSERT [Questionnaire].[ExamAnswer] ([ExamAnswerId], [ExamId], [QuestionId], [AnswerId], [Answer], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateCreatedBy2], [DateUpdated], [DateUpdatedBy], [DateUpdatedBy2]) VALUES (4, 2, 4, 16, N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-29T09:06:46.0482619-05:00' AS DateTimeOffset), 54306, N'54306', CAST(N'2019-04-29T09:06:46.0482619-05:00' AS DateTimeOffset), 54306, N'54306')
INSERT [Questionnaire].[ExamAnswer] ([ExamAnswerId], [ExamId], [QuestionId], [AnswerId], [Answer], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateCreatedBy2], [DateUpdated], [DateUpdatedBy], [DateUpdatedBy2]) VALUES (5, 2, 5, NULL, N'test', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-29T09:06:50.6119997-05:00' AS DateTimeOffset), 54306, N'54306', CAST(N'2019-04-29T09:06:50.6119997-05:00' AS DateTimeOffset), 54306, N'54306')
INSERT [Questionnaire].[ExamAnswer] ([ExamAnswerId], [ExamId], [QuestionId], [AnswerId], [Answer], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateCreatedBy2], [DateUpdated], [DateUpdatedBy], [DateUpdatedBy2]) VALUES (6, 2, 6, 18, N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-29T09:06:56.0909684-05:00' AS DateTimeOffset), 54306, N'54306', CAST(N'2019-04-29T09:06:56.0909684-05:00' AS DateTimeOffset), 54306, N'54306')
INSERT [Questionnaire].[ExamAnswer] ([ExamAnswerId], [ExamId], [QuestionId], [AnswerId], [Answer], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateCreatedBy2], [DateUpdated], [DateUpdatedBy], [DateUpdatedBy2]) VALUES (7, 2, 6, 20, N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-29T09:06:56.3025783-05:00' AS DateTimeOffset), 54306, N'54306', CAST(N'2019-04-29T09:06:56.3025783-05:00' AS DateTimeOffset), 54306, N'54306')
INSERT [Questionnaire].[ExamAnswer] ([ExamAnswerId], [ExamId], [QuestionId], [AnswerId], [Answer], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateCreatedBy2], [DateUpdated], [DateUpdatedBy], [DateUpdatedBy2]) VALUES (8, 2, 7, 23, N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-29T09:06:59.1774268-05:00' AS DateTimeOffset), 54306, N'54306', CAST(N'2019-04-29T09:06:59.1774268-05:00' AS DateTimeOffset), 54306, N'54306')
INSERT [Questionnaire].[ExamAnswer] ([ExamAnswerId], [ExamId], [QuestionId], [AnswerId], [Answer], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateCreatedBy2], [DateUpdated], [DateUpdatedBy], [DateUpdatedBy2]) VALUES (9, 2, 7, 24, N'', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-29T09:06:59.3935528-05:00' AS DateTimeOffset), 54306, N'54306', CAST(N'2019-04-29T09:06:59.3935528-05:00' AS DateTimeOffset), 54306, N'54306')
INSERT [Questionnaire].[ExamAnswer] ([ExamAnswerId], [ExamId], [QuestionId], [AnswerId], [Answer], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateCreatedBy2], [DateUpdated], [DateUpdatedBy], [DateUpdatedBy2]) VALUES (10, 2, 8, 26, N'Woodwind', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-29T09:07:07.2771078-05:00' AS DateTimeOffset), 54306, N'54306', CAST(N'2019-04-29T09:07:07.2771078-05:00' AS DateTimeOffset), 54306, N'54306')
INSERT [Questionnaire].[ExamAnswer] ([ExamAnswerId], [ExamId], [QuestionId], [AnswerId], [Answer], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateCreatedBy2], [DateUpdated], [DateUpdatedBy], [DateUpdatedBy2]) VALUES (11, 2, 8, 27, N'Percussion', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-29T09:07:07.4870831-05:00' AS DateTimeOffset), 54306, N'54306', CAST(N'2019-04-29T09:07:07.4870831-05:00' AS DateTimeOffset), 54306, N'54306')
INSERT [Questionnaire].[ExamAnswer] ([ExamAnswerId], [ExamId], [QuestionId], [AnswerId], [Answer], [BrowserIPv4], [BrowserIPv6], [BrowserType], [BrowserName], [BrowserVersion], [BrowserMajorVersion], [BrowserMinorVersion], [BrowserPlatform], [DateCreated], [DateCreatedBy], [DateCreatedBy2], [DateUpdated], [DateUpdatedBy], [DateUpdatedBy2]) VALUES (12, 2, 9, 31, N'2 Reed', N'192.168.1.180', N'::1', N'Chrome73', N'Chrome', N'73.0', N'73', N'0', N'WinNT', CAST(N'2019-04-29T09:07:27.9812380-05:00' AS DateTimeOffset), 54306, N'54306', CAST(N'2019-04-29T09:07:27.9812380-05:00' AS DateTimeOffset), 54306, N'54306')
SET IDENTITY_INSERT [Questionnaire].[ExamAnswer] OFF
go



-- -------------------------------------------------------------------------
-- [3] Declare everything....
-- -------------------------------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Begin
SET NOCOUNT ON;

--Declare @temp table (
--	CourseId int, 
--	NewCourseId int,
--	SectionId int,
--	NewSectionId int,
--	QuestionId int,
--	NewQuestionId int,
--	AnswerId int,
--	NewAnswerId int
--)
Declare @temp table (
	ID int,
	[NewId] int,
	[Type] nvarchar(1)
)


-- -------------------------------------------------------------------------
-- [4] Loop through every Cursor / Section / Question / Answer and add it manually
-- This process is IO intensive using Cursors because you need to preserve 
-- multiple table references. 
-- -------------------------------------------------------------------------
-- ---------------------
-- Cursor 1: Course
-- ---------------------
Declare @Cursor1_NumberRecords int, @Cursor1_RowCount int;
Declare @Cursor1_Table Table (
	RowID int IDENTITY(1, 1), 
	CourseId int
)
Insert into @Cursor1_Table(CourseId)
	Select	C.CourseId
	From	QuestionnaireCourse C;
	
Select @Cursor1_NumberRecords = (Select count(*) from @Cursor1_Table);
Select @Cursor1_RowCount = 1;

WHILE @Cursor1_RowCount <= @Cursor1_NumberRecords
BEGIN  	
	Declare @Cursor1_CourseId int
	Declare @Cursor1_NewCourseId int
	SELECT	@Cursor1_CourseId = CourseId
	FROM	@Cursor1_Table
	WHERE   RowID = @Cursor1_RowCount;
	
	print	'@Cursor1_NumberRecords: ' + convert(nvarchar, @Cursor1_NumberRecords) + ' ' +
			'@Cursor1_NumberRecords: ' + convert(nvarchar, @Cursor1_RowCount) + ' ' +
			'CourseId: ' + convert(nvarchar, @cursor1_CourseId);

	Insert into Questionnaire.Course (
		[Course],
		[CourseTypeId],
		[Status],
		[DateCreated],
		[DateCreatedBy],
		[DateUpdated],
		[DateUpdatedBy]
	)
	Select	C.Course,
			C.CourseTypeId,
			C.[Status],
			C.DateCreated,
			convert(int, C.DateCreatedBy),
			C.DateUpdated,
			convert(int, C.DateUpdatedBy)
	From	QuestionnaireCourse C
	Where	C.CourseId = @Cursor1_CourseId

	Select @Cursor1_NewCourseId = (
		Select	 Top 1 C.CourseId
		From	 Questionnaire.Course C
		Order by C.CourseId desc
	);

	If ((Select Count(*) From @temp Where [Type] = 'C' and [NewId] = @Cursor1_NewCourseId) <= 0)
	Begin
		Insert into @temp(ID, [NewId], [Type])
		Values (@Cursor1_CourseId, @Cursor1_NewCourseId, 'C');
	End

	Select @Cursor1_RowCount = @Cursor1_RowCount + 1
END 

	
-- ---------------------
-- Cursor 2: Section
-- ---------------------
Declare @Cursor2_NumberRecords int, @Cursor2_RowCount int;
Declare @Cursor2_Table Table (
	RowID int IDENTITY(1, 1), 
	NewCourseId int,
	SectionId int
)
Insert into @Cursor2_Table(NewCourseId, SectionId)
	Select	T.[NewId],
			S.SectionId
	From	QuestionnaireSection S
			Inner Join @temp T on T.ID = S.CourseId and T.[Type] = 'C'
		
Select @Cursor2_NumberRecords = (Select count(*) from @Cursor2_Table);
Select @Cursor2_RowCount = 1;
	
While @Cursor2_RowCount <= @Cursor2_NumberRecords
Begin		
	Declare @Cursor2_NewCourseId int, @Cursor2_SectionId int, @Cursor2_NewSectionId int;
	SELECT	@Cursor2_NewCourseId = NewCourseId,
			@Cursor2_Sectionid = SectionId
	FROM	@Cursor2_Table
	WHERE   RowID = @Cursor2_RowCount;

	print	'@Cursor2_NumberRecords: ' + convert(nvarchar, @Cursor2_NumberRecords) + ' ' +
			'@Cursor2_NumberRecords: ' + convert(nvarchar, @Cursor2_RowCount) + ' ' +
			'SectionId: ' + convert(nvarchar, @Cursor2_Sectionid);

	Insert into Questionnaire.Section (
		[CourseId]
		,[Section]
		,[Status]
		,[IsIntroductionVisible]
		,[Introduction]
		,[IntroductionAudioMode]
		,[IntroductionAudioAddress]
		,[IntroductionAudioUpload]
		,[IntroductionImageMode]
		,[IntroductionImageAddress]
		,[IntroductionImageUpload]
		,[IsConclusionVisible]
		,[Conclusion]
		,[ConclusionAudioMode]
		,[ConclusionAudioAddress]
		,[ConclusionAudioUpload]
		,[ConclusionImageMode]
		,[ConclusionImageAddress]
		,[ConclusionImageUpload]
		,[AllowRetake]
		,[AllowRetakeAboveThreshold]
		,[Threshold]
		,[HeaderText]
		,[IsQuestionsSkipable]
		,[IsTableOfContentsVisible]
		,[ShowScore]
		,[IsTemplate]
		,IsAnswersRandomized
		,IsQuestionsRandomized
		,[BrowserIPv4]
		,[BrowserIPv6]
		,[BrowserType]
		,[BrowserName]
		,[BrowserVersion]
		,[BrowserMajorVersion]
		,[BrowserMinorVersion]
		,[BrowserPlatform]
		,[DateCreated]
		,[DateCreatedBy]
		,[DateUpdated]
		,[DateUpdatedBy]
	)
	Select	@Cursor2_NewCourseId, -- [CourseId]
			S.Section, --  ,[Section]
			ISNULL(S.[Status],0), --  ,[Status]
			S.ShowDescription, --  ,[IsIntroductionVisible]
			S.[Description], --  ,[Introduction]
			Case When S.MediaAudioAddress <> '' Then 'Address' Else '' End, --  ,[IntroductionAudioMode]
			Case When S.MediaAudioAddress <> '' Then S.MediaAudioAddress Else '' End, --  ,[IntroductionAudioAddress]
			'', --  ,[IntroductionAudioUpload]
			'', --  ,[IntroductionImageMode]
			'', --  ,[IntroductionImageAddress]
			'', --  ,[IntroductionImageUpload]
			0, --  ,[IsConclusionVisible]
			'', --  ,[Conclusion]
			'', --  ,[ConclusionAudioMode]
			'', --  ,[ConclusionAudioAddress]
			'', --  ,[ConclusionAudioUpload]
			'', --  ,[ConclusionImageMode]
			'', --  ,[ConclusionImageAddress]
			'', --  ,[ConclusionImageUpload]
			0, --  ,[AllowRetake]
			S.AllowRetake, --  ,[AllowRetakeAboveThreshold]
			S.Threshold, --  ,[Threshold]
			'', --  ,[HeaderText]
			0, --  ,[IsQuestionsSkipable]
			S.ShowTableofContents, --  ,[IsTableOfContentsVisible]
			1, --  ,[ShowScore]
			ISNULL(S.IsTemplate,0), --  ,[IsTemplate]
			0,	--,IsAnswersRandomized
			0,	--,IsQuestionsRandomized
			null, --  ,[BrowserIPv4]
			null, --  ,[BrowserIPv6]
			null, --  ,[BrowserType]
			null, --  ,[BrowserName]
			null, --  ,[BrowserVersion]
			null, --  ,[BrowserMajorVersion]
			null, --  ,[BrowserMinorVersion]
			null, --  ,[BrowserPlatform]
			S.DateCreated, --  ,[DateCreated]
			CONVERT(INT, S.DateCreatedBy), --  ,[DateCreatedBy]
			S.DateUpdated, --  ,[DateUpdated]
			CONVERT(INT, S.DateUpdatedBy) --  ,[DateUpdatedBy]
	From	QuestionnaireSection S
	Where	S.SectionId = @Cursor2_SectionId
			
	Select @Cursor2_NewSectionId = (
		Select	 Top 1 S.SectionId
		From	 Questionnaire.Section S 
		Order By S.SectionId Desc
	);

		
	If ((Select Count(*) From @temp Where [Type] = 'S' and [NewId] = @Cursor2_NewSectionId) <= 0)
	Begin
		Insert into @temp(ID, [NewId], [Type])
		Values (@Cursor2_SectionId, @Cursor2_NewSectionId, 'S');
	End

	Select @Cursor2_RowCount = @Cursor2_RowCount + 1
End
			
-- ---------------------
-- Cursor 3: Question
-- ---------------------
Declare @Cursor3_NumberRecords int, @Cursor3_RowCount int;
Declare @Cursor3_Table Table (
	RowID int IDENTITY(1, 1), 
	NewSectionId int,
	QuestionId int
)
Insert into @Cursor3_Table(NewSectionId, QuestionId)
	Select	T.[NewId],
			Q.QuestionId
	From	QuestionnaireQuestion Q
			Inner Join @temp T on T.ID = Q.SectionId and T.[Type] = 'S';
			
Select @Cursor3_NumberRecords = (Select count(*) from @Cursor3_Table);
Select @Cursor3_RowCount = 1;
		
While @Cursor3_RowCount <= @Cursor3_NumberRecords
Begin			
	Declare @Cursor3_NewSectionId int, @Cursor3_QuestionId int, @Cursor3_NewQuestionId int
	SELECT	@Cursor3_NewSectionId = NewSectionId,
			@Cursor3_QuestionId = QuestionId
	FROM	@Cursor3_Table
	WHERE	RowID = @Cursor3_RowCount;

	print	'@Cursor3_NumberRecords: ' + convert(nvarchar, @Cursor3_NumberRecords) + ' ' +
			'@Cursor3_NumberRecords: ' + convert(nvarchar, @Cursor3_RowCount) + ' ' +
			'QuestionId: ' + convert(nvarchar, @Cursor3_QuestionId);

	INSERT INTO [Questionnaire].[Question] (
		[QuestionTypeId]
		,[Question]
		,[SectionId]
		,[Sort]
		,[Status]
		,[AudioMode]
		,[AudioAddress]
		,[AudioUpload]
		,[ImageMode]
		,[ImageAddress]
		,[ImageUpload]
		,[BrowserIPv4]
		,[BrowserIPv6]
		,[BrowserType]
		,[BrowserName]
		,[BrowserVersion]
		,[BrowserMajorVersion]
		,[BrowserMinorVersion]
		,[BrowserPlatform]
		,[DateCreated]
		,[DateCreatedBy]
		,[DateUpdated]
		,[DateUpdatedBy]
		,[Note]
		,[IsNoteShownOnNew]
		,[IsNoteShownOnReview]
	)
	Select	
		Case Q.QuestionType
			When 'multichoice' Then 1
			When 'boolean' Then 5
			When 'multianswer' Then 2
			When 'shortanswer' Then 3
			Else 1
		End,	--[QuestionTypeId]
		convert(nvarchar(4000),Q.Question),	--  ,[Question]
		@Cursor3_NewSectionId,	--  ,[SectionId]
		Q.Sort,	--  ,[Sort]
		1,	--  ,[Status]
		Case When Q.MediaAudioAddress <> '' Then 'Address' Else '' End, 	--  ,[AudioMode]
		Case When Q.MediaAudioAddress <> '' Then Q.MediaAudioAddress Else '' End,	--  ,[AudioAddress]
		'',	--  ,[AudioUpload]
		'',	--  ,[ImageMode]
		'',	--  ,[ImageAddress]
		'',	--  ,[ImageUpload]
		null,	--  ,[BrowserIPv4]
		null,	--  ,[BrowserIPv6]
		null,	--  ,[BrowserType]
		null,	--  ,[BrowserName]
		null,	--  ,[BrowserVersion]
		null,	--  ,[BrowserMajorVersion]
		null,	--  ,[BrowserMinorVersion]
		null,	--  ,[BrowserPlatform]
		Q.DateCreated,	--  ,[DateCreated]
		convert(int, Q.DateCreatedBy),	--  ,[DateCreatedBy]
		Q.DateUpdated,	--  ,[DateUpdated]
		convert(int, Q.DateUpdatedBy),	--  ,[DateUpdatedBy]
		'',	--  ,[Note]
		0,	--  ,[IsNoteShownOnNew]
		0	--  ,[IsNoteShownOnReview]
	From	QuestionnaireQuestion Q
	Where	Q.QuestionId = @Cursor3_QuestionId;

	Select @Cursor3_NewQuestionId = (
			Select   Top 1 Q.QuestionId
			From	 Questionnaire.Question Q
			Order by Q.QuestionId desc
		);
		
	If ((Select Count(*) From @temp Where [Type] = 'Q' and [NewId] = @Cursor3_NewQuestionId) <= 0)
	Begin
		Insert into @temp(ID, [NewId], [Type])
		Values (@Cursor3_QuestionId, @Cursor3_NewQuestionId, 'Q');
	End	

	Select @Cursor3_RowCount = @Cursor3_RowCount + 1
End

					
-- ---------------------
-- Cursor 4: Answer
-- ---------------------
Declare @Cursor4_Table Table (
	RowID int IDENTITY(1, 1), 
	NewQuestionId int,
	AnswerId int
)
Insert into @Cursor4_Table(NewQuestionId, AnswerId)
	Select	T.[NewId],
			A.AnswerId
	From	QuestionnaireAnswer A
			Inner Join @temp T on T.[ID] = A.QuestionId and T.[Type] = 'Q';
			
Declare @Cursor4_NumberRecords int = (Select count(*) from @Cursor4_Table);
Declare @Cursor4_RowCount int = 1;

While @Cursor4_RowCount <= @Cursor4_NumberRecords
Begin				
	Declare @Cursor4_NewQuestionId int, @Cursor4_AnswerId int, @Cursor4_NewAnswerId int
	SELECT	@Cursor4_NewQuestionId = NewQuestionId,
			@Cursor4_AnswerId = AnswerId
	FROM	@Cursor4_Table
	WHERE	RowID = @Cursor4_RowCount;

	print	'@Cursor4_NumberRecords: ' + convert(nvarchar, @Cursor4_NumberRecords) + ' ' +
			'@Cursor4_NumberRecords: ' + convert(nvarchar, @Cursor4_RowCount) + ' ' +
			'AnswerId: ' + convert(nvarchar, @Cursor4_AnswerId);

	Insert into Questionnaire.Answer (
		[QuestionId]
		,[Answer]
		,[Answer2]
		,[IsCorrect]
		,[ScaledWorthPercentage]
		,[Sort]
		,[ImageMode]
		,[ImageAddress]
		,[ImageUpload]
		,[BrowserIPv4]
		,[BrowserIPv6]
		,[BrowserType]
		,[BrowserName]
		,[BrowserVersion]
		,[BrowserMajorVersion]
		,[BrowserMinorVersion]
		,[BrowserPlatform]
		,[DateCreated]
		,[DateCreatedBy]
		,[DateUpdated]
		,[DateUpdatedBy]
	)
	Select	@Cursor4_NewQuestionId, --[QuestionId]
			A.Answer,   --,[Answer]
			'',   --,[Answer2]
			A.IsCorrect,   --,[IsCorrect]
			100,   --,[ScaledWorthPercentage]
			A.Sort,   --,[Sort]
			'',   --,[ImageMode]
			'',   --,[ImageAddress]
			'',   --,[ImageUpload]
			null,   --,[BrowserIPv4]
			null,   --,[BrowserIPv6]
			null,   --,[BrowserType]
			null,   --,[BrowserName]
			null,   --,[BrowserVersion]
			null,   --,[BrowserMajorVersion]
			null,   --,[BrowserMinorVersion]
			null,   --,[BrowserPlatform]
			A.DateCreated,	--  ,[DateCreated]
			convert(int, A.DateCreatedBy),	--  ,[DateCreatedBy]
			A.DateUpdated,	--  ,[DateUpdated]
			convert(int, A.DateUpdatedBy)	--  ,[DateUpdatedBy]
	From	QuestionnaireAnswer A
	Where	A.AnswerId = @Cursor4_AnswerId;

	Select @Cursor4_NewAnswerId = (
		Select   Top 1 A.AnswerId
		From	 Questionnaire.Answer A
		Order by A.AnswerId desc
	);
				
	If ((Select Count(*) From @temp Where [Type] = 'A' and [NewId] = @Cursor4_NewAnswerId) <= 0)
	Begin
		Insert into @temp(ID, [NewId], [Type])
		Values (@Cursor4_AnswerId, @Cursor4_NewAnswerId, 'A');
	End

					
	Select @Cursor4_RowCount = @Cursor4_RowCount + 1
End
			

			

			


	




-- -------------------------------------------------------------------------
-- [5] Migrate the Exams System
-- -------------------------------------------------------------------------
Declare @Cursor5_NumberRecords int, @Cursor5_RowCount int;
Declare @Cursor5_Table Table (
	RowID int IDENTITY(1, 1), 
	ExamId int,
	NewSectionId int
)
Insert into @Cursor5_Table(ExamId, NewSectionId)
	Select	E.ExamId,
			T.[NewId]
	From	QuestionnaireExam E
			Inner Join @temp T on T.[ID] = E.SectionId and T.[Type] = 'S'
			
Select @Cursor5_NumberRecords = (Select count(*) from @Cursor5_Table);
Select @Cursor5_RowCount = 1;

While @Cursor5_RowCount <= @Cursor5_NumberRecords
Begin
	Declare @Cursor5_ExamId int, @Cursor5_NewExamId int, @Cursor5_NewSectionId int
	SELECT	@Cursor5_ExamId = ExamId,
			@Cursor5_NewSectionId = NewSectionId
	FROM	@Cursor5_Table
	WHERE	RowID = @Cursor5_RowCount
	
	print	'@Cursor5_NumberRecords: ' + convert(nvarchar, @Cursor5_NumberRecords) + ' ' +
			'@Cursor5_NumberRecords: ' + convert(nvarchar, @Cursor5_RowCount) + ' ' +
			'ExamId: ' + convert(nvarchar, @Cursor5_ExamId);

	Insert into Questionnaire.Exam (
		[SectionId]
		,[IndividualId]
		,[SessionId]
		,[Score]
		,[Status]
		,[Attempt]
		,[DateStarted]
		,[DateFinished]
		,[BrowserIPv4]
		,[BrowserIPv6]
		,[BrowserType]
		,[BrowserName]
		,[BrowserVersion]
		,[BrowserMajorVersion]
		,[BrowserMinorVersion]
		,[BrowserPlatform]
		,[DateCreated]
		,[DateCreatedBy]
		,[DateCreatedBy2]
		,[DateUpdated]
		,[DateUpdatedBy]
		,[DateUpdatedBy2]			
	)
	Select  @Cursor5_NewSectionId,	--[SectionId]
			case when E.IndividualId = '-1' then '0' else E.IndividualId end, --,[IndividualId]
			E.SessionId, --,[SessionId]
			CONVERT(DECIMAL(18,2), ISNULL(E.Score, 0)), --,[Score]
			case E.[Result]
				When 'Passed' Then 'Passed'
				When 'Failed' Then 'Failed'
				Else 'Open'
			End, --,[Status]
			E.Attempt, --,[Attempt]
			E.DateCreated, --,[DateStarted]
			case 
				When E.Result is null Then null
				Else E.DateUpdated
			End, --,[DateFinished]
			null, --,[BrowserIPv4]
			null, --,[BrowserIPv6]
			null, --,[BrowserType]
			null, --,[BrowserName]
			null, --,[BrowserVersion]
			null, --,[BrowserMajorVersion]
			null, --,[BrowserMinorVersion]
			null, --,[BrowserPlatform]
			E.DateCreated, --,[DateCreated]
			case 
				when TRY_PARSE(DateCreatedBy as INT) is null then null 
				when DateCreatedBy = '-1' then null
				else TRY_PARSE(DateCreatedBy as INT) 
			end, --,[DateCreatedBy]
			case 
				when E.DateCreatedBy = '' then null
				when E.DateCreatedBy = '-1' then null
				else E.DateCreatedBy
			end, --,[DateCreatedBy2]
			E.DateUpdated, --,[DateUpdated]
			case 
				when TRY_PARSE(DateUpdatedBy as INT) is null then null  
				when DateUpdatedBy = '-1' then null
				else TRY_PARSE(DateUpdatedBy as INT) 
			end, --,[DateUpdatedBy]
			case 
				when E.DateUpdatedBy = '' then null
				when E.DateUpdatedBy = '-1' then null
				else E.DateUpdatedBy
			end --,[DateUpdatedBy2]
	From	QuestionnaireExam E
	Where	E.ExamId = @Cursor5_ExamId	

	Select @Cursor5_NewExamId = (
		Select	 Top 1 E.ExamId
		From	 Questionnaire.Exam E
		Order by E.ExamId desc
	);

			
	If ((Select Count(*) From @temp Where [Type] = 'E' and [NewId] = @Cursor5_NewExamId) <= 0)
	Begin
		Insert into @temp(ID, [NewId], [Type])
		Values (@Cursor5_ExamId, @Cursor5_NewExamId, 'E');
	End
			
	Select @Cursor5_RowCount = @Cursor5_RowCount + 1
END 


-- ---------------------
-- Cursor 6: ExamAnswer
-- ---------------------
print 'Starting ExamAnswer Insert...'

	Insert into Questionnaire.ExamAnswer (		
		ExamId,
		QuestionId,
		AnswerId,
		Answer,
		BrowserIPv4,
		BrowserIPv6,
		BrowserType,
		BrowserName,
		BrowserVersion,
		BrowserMajorVersion,
		BrowserMinorVersion,
		BrowserPlatform,
		DateCreated,
		DateCreatedBy,
		DateCreatedBy2,
		DateUpdated,
		DateUpdatedBy,
		DateUpdatedBy2
	)
	Select	(
				Select	T2.[NewId]
				From	@temp T2 
				Where	T2.[ID] = EA.ExamId and 
						T2.[Type] = 'E'
			), --ExamId,
			(
				Select	T2.[NewId]
				From	@temp T2 
				Where	T2.[ID] = EA.QuestionId and 
						T2.[Type] = 'Q'
			), --QuestionId,
			(
				Select	T2.[NewId]
				From	@temp T2 
				Where	T2.[ID] = EA.AnswerId and 
						T2.[Type] = 'A'
			), --AnswerId,
			ISNULL(EA.Answer, ''), --Answer,
			null,--BrowserIPv4,
			null,--BrowserIPv6,
			null,--BrowserType,
			null,--BrowserName,
			null,--BrowserVersion,
			null,--BrowserMajorVersion,
			null,--BrowserMinorVersion,
			null,--BrowserPlatform,
			EA.DateCreated, --,[DateCreated]
			case 
				when TRY_PARSE(DateCreatedBy as INT) is null then null 
				when DateCreatedBy = '-1' then null
				else TRY_PARSE(DateCreatedBy as INT) 
			end, --,[DateCreatedBy]
			case 
				when EA.DateCreatedBy = '' then null
				when EA.DateCreatedBy = '-1' then null
				else EA.DateCreatedBy
			end, --,[DateCreatedBy2]
			EA.DateUpdated, --,[DateUpdated]
			case 
				when TRY_PARSE(DateUpdatedBy as INT) is null then null 
				when DateUpdatedBy = '-1' then null
				else TRY_PARSE(DateUpdatedBy as INT) 
			end, --,[DateUpdatedBy]
			case 
				when EA.DateUpdatedBy = '' then null
				when EA.DateUpdatedBy = '-1' then null
				else EA.DateUpdatedBy
			end  --,[DateUpdatedBy2]
	From	QuestionnaireExamAnswer EA

/*
Declare @Cursor6_NumberRecords int, @Cursor6_RowCount int;
Declare @Cursor6_Table Table (
	RowID int IDENTITY(1, 1), 
	NewExamId int,
	ExamAnswerId int
)
Insert into @Cursor6_Table(NewExamId, ExamAnswerId)
	Select	E.[NewId],
			EA.ExamAnswerId
	From	QuestionnaireExamAnswer EA
			Inner Join @temp E on E.[ID] = EA.ExamId and E.[Type] = 'E'

Select @Cursor6_NumberRecords = (Select count(*) from @Cursor6_Table);
Select @Cursor6_RowCount = 1;
	
While @Cursor6_RowCount <= @Cursor6_NumberRecords
Begin				
	Declare @Cursor6_ExamAnswerId int, @Cursor6_NewExamId int, @Cursor6_NewAnswerId int, @Cursor6_NewQuestionId int
	SELECT	@Cursor6_ExamAnswerId = ExamAnswerId,
			@Cursor6_NewExamId = NewExamId
	FROM	@Cursor6_Table
	WHERE	RowID = @Cursor6_RowCount;

	Select	@Cursor6_NewQuestionId = (
				Select  T2.[NewId]
				From	@temp T2
				Where	T2.[ID] = EA.QuestionId and 
						T2.[Type] = 'Q'
			),
			@Cursor6_NewAnswerId = (
				Select  T2.[NewId]
				From	@temp T2
				Where	T2.[ID] = EA.AnswerId and 
						T2.[Type] = 'A'
			)
	From	QuestionnaireExamAnswer EA 
			--Inner Join @temp T on T.[ID] = EA.ExamId and T.[Type] = 'E'
	Where	EA.ExamAnswerId = @Cursor6_ExamAnswerId
				
	print	'@Cursor6_NumberRecords: ' + convert(nvarchar, @Cursor6_NumberRecords) + ' ' + 
			'@Cursor6_NumberRecords: ' + convert(nvarchar, @Cursor6_RowCount) + ' ' +
			'ExamAnswerId: ' + convert(nvarchar, @Cursor6_ExamAnswerId);

	Insert into Questionnaire.ExamAnswer (		
		ExamId,
		QuestionId,
		AnswerId,
		Answer,
		BrowserIPv4,
		BrowserIPv6,
		BrowserType,
		BrowserName,
		BrowserVersion,
		BrowserMajorVersion,
		BrowserMinorVersion,
		BrowserPlatform,
		DateCreated,
		DateCreatedBy,
		DateCreatedBy2,
		DateUpdated,
		DateUpdatedBy,
		DateUpdatedBy2
	)
	Select	@Cursor6_NewExamId, --ExamId,
			@Cursor6_NewQuestionId, --QuestionId,
			@Cursor6_NewAnswerId, --AnswerId,
			ISNULL(EA.Answer, ''), --Answer,
			null,--BrowserIPv4,
			null,--BrowserIPv6,
			null,--BrowserType,
			null,--BrowserName,
			null,--BrowserVersion,
			null,--BrowserMajorVersion,
			null,--BrowserMinorVersion,
			null,--BrowserPlatform,
			EA.DateCreated, --,[DateCreated]
			case 
				when TRY_PARSE(DateCreatedBy as INT) is null then null 
				when DateCreatedBy = '-1' then null
				else TRY_PARSE(DateCreatedBy as INT) 
			end, --,[DateCreatedBy]
			case 
				when EA.DateCreatedBy = '' then null
				when EA.DateCreatedBy = '-1' then null
				else EA.DateCreatedBy
			end, --,[DateCreatedBy2]
			EA.DateUpdated, --,[DateUpdated]
			case 
				when TRY_PARSE(DateUpdatedBy as INT) is null then null 
				when DateUpdatedBy = '-1' then null
				else TRY_PARSE(DateUpdatedBy as INT) 
			end, --,[DateUpdatedBy]
			case 
				when EA.DateUpdatedBy = '' then null
				when EA.DateUpdatedBy = '-1' then null
				else EA.DateUpdatedBy
			end  --,[DateUpdatedBy2]
	From	QuestionnaireExamAnswer EA
	Where	EA.ExamAnswerId = @Cursor6_ExamAnswerId;

	Select @Cursor6_RowCount = @Cursor6_RowCount + 1
End
*/
End

-- debuggy stuff
Select * From @Temp

-- -------------------------------------------------------------------------
-- [5b] Assignments
-- -------------------------------------------------------------------------
Insert into Questionnaire.Assignment(
	CourseReqId,
	SectionId,
	[DateCreatedBy],
	[DateUpdatedBy]
)
Select	CourseReqId,
		SectionId,
		54306,
		54306
From	#Assignments

-- -------------------------------------------------------------------------
-- [5c] NEIEP Help Page Part 2
-- -------------------------------------------------------------------------
update dbo.NEIEPHelpPage
set   SectionId = (
			Select  max(S.SectionId)
			From	Questionnaire.Section S
			Where	S.Section = (
						Select  top 1 S2.Section
						From	QuestionnaireSection S2
						Where	S2.SectionId = NEIEPHelpPage.QuestionnaireSectionId
					)
	  )
where QuestionnaireSectionId is not null;
go

-- -------------------------------------------------------------------------
-- [6] Rebuild all the indexes
-- -------------------------------------------------------------------------
alter index all on Questionnaire.ExamAnswer Rebuild
go
alter index all on Questionnaire.Exam Rebuild
go
alter index all on Questionnaire.Answer Rebuild
go
alter index all on Questionnaire.Question Rebuild
go 
alter index all on Questionnaire.Section Rebuild
go
alter index all on Questionnaire.Course Rebuild
go
alter index all on Questionnaire.Adjustment Rebuild
go
alter index all on dbo.NEIEPHelpPage Rebuild
go