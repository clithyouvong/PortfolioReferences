SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Colby Lithyouvong
-- Create date: 2014 APR
-- Description:	Takes in an NVARCHAR and removes nonalphabetical characters
-- =============================================
CREATE FUNCTION [dbo].[RemoveNonAlphabeticalChars]
(
	-- Add the parameters for the function here
	@Phrase NVARCHAR(1000)
)
RETURNS NVARCHAR(1000)
AS
BEGIN
	-- Created BY G Mastros Jan 16 2009 21:02
	-- http://stackoverflow.com/questions/1007697/how-to-strip-all-non-alphabetic-characters-from-string-in-sql-server

    Declare @KeepValues as varchar(50)
    Set @KeepValues = '%[^a-z]%'
    While PatIndex(@KeepValues, @Phrase) > 0
        Set @Phrase = Stuff(@Phrase, PatIndex(@KeepValues, @Phrase), 1, '')

    Return @Phrase

END
GO