DECLARE @MinDate DATE = '20140101',
        @MaxDate DATE = '20140106';

SELECT  TOP (DATEDIFF(DAY, @MinDate, @MaxDate) + 1)
        Date = DATEADD(DAY, ROW_NUMBER() OVER(ORDER BY a.object_id) - 1, @MinDate)
FROM    sys.all_objects a
        CROSS JOIN sys.all_objects b;
