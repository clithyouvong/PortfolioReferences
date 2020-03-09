SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetWeekNumber]
(
	@SelectedDate	smalldatetime
)
RETURNS int
AS
	BEGIN
		DECLARE
			@Week AS int,
			@WeekStartDate AS smalldatetime,
			@WeekEndDate AS smalldatetime,
			@CurrentSeason AS int,
			@LaborDay AS smalldatetime,
			@Thanksgiving AS smalldatetime,
			@Christmas AS smalldatetime
		
		/* Current school year */
		SELECT @CurrentSeason = dbo.GetCurrentSeason(@SelectedDate)
		
		/* Find Labor Day (1st Monday in September): */
		SELECT @LaborDay = CAST('9/1/' + CAST(@CurrentSeason AS varchar) AS smalldatetime)
		WHILE DATEPART(Weekday, @LaborDay) <> 2
			BEGIN
				SELECT @LaborDay = DATEADD(Day,1,@LaborDay)
			END

		/* Find Thanksgiving (4th Thursday in November): */			
		SELECT @Thanksgiving = CAST('11/1/' + CAST(@CurrentSeason AS varchar) AS smalldatetime)
		WHILE DATEPART(Weekday, @Thanksgiving) <> 5
			BEGIN
				SELECT @Thanksgiving = DATEADD(Day,1,@Thanksgiving)
			END
		SELECT @Thanksgiving = DATEADD(Week,3,@Thanksgiving)

		/* Find Christmas: */
		SELECT @Christmas = CAST('12/25/' + CAST(@CurrentSeason AS varchar) AS smalldatetime)

		/* Initialize loop dates: */
		SELECT	@WeekStartDate = DATEADD(Day,-1,@LaborDay),
				@WeekEndDate = DATEADD(Day,5,@LaborDay),
				@Week = 1
				
		/* Find the current week for the selected date: */
		WHILE NOT @SelectedDate BETWEEN @WeekStartDate AND @WeekEndDate
			BEGIN
				SELECT	@WeekStartDate = DATEADD(Week,1,@WeekStartDate),
						@WeekEndDate = DATEADD(Week,1,@WeekEndDate)
						
				IF NOT(	@Thanksgiving				BETWEEN @WeekStartDate AND @WeekEndDate OR
						@Christmas					BETWEEN @WeekStartDate AND @WeekEndDate OR
						DATEADD(Week,1,@Christmas)	BETWEEN @WeekStartDate AND @WeekEndDate OR
						@Week > 35)
					SELECT @Week = @Week + 1
			END
		
	RETURN @Week
	END

GO