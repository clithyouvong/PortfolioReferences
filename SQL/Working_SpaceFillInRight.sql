SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* ***************************************************************************************
	This function Right Space Fill a String variable @String to a given size @Length.
*/
CREATE FUNCTION [dbo].[SpaceFillInRight] (@String VARCHAR(255), @Length INT)

RETURNS VARCHAR(255)
AS 
BEGIN
	DECLARE @NewString VARCHAR(255)
	SET @NewString = ISNULL(@String,CHAR(20))
	SET @NewString = RTRIM(@String)
	SET @NewString = @NewString + SPACE(@Length -LEN(@NewString))
	RETURN(@NewString)
END
GO