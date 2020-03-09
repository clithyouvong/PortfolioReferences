SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* ***************************************************************************************
	This function Left Zero Fills  an Integer variable @ID to a given size @Length.	
*/
CREATE FUNCTION [dbo].[SpaceFillInLeft] (@ID INT, @Length INT)

RETURNS VARCHAR(255)
AS 
BEGIN
	DECLARE @NewString VARCHAR(255)
	SET @NewString = REPLICATE('0', @Length - DATALENGTH(CONVERT(VARCHAR(255),@ID))) + CONVERT(VARCHAR(255),@ID)
	RETURN(@NewString)
END
GO