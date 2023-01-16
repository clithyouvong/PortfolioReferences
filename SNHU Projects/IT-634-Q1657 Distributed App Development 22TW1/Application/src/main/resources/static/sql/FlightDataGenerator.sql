
/*
LOGIC:

FOR EVERY AIRPORT
LOOP THROUGH AND 
	FOR EACH AIRPORT NOT THIS AIRPORT
		LOOP 10 TIMES
			INSERT INTO FLIGHT TIMES WITH DIFFERENT PRICES

RESULT:
CREATE A TESTABLE FLIGHT TABLE WITH DIFFERENT AIRPORT COMBINATIONS AND FLIGHT OPTIONS
ABOUT 24,500 RECORDS
*/





--------------------------------------------------
-- CURSOR 1
--------------------------------------------------
Declare @Cursor1_Code varchar(10);
Declare @Cursor1_NumberRecords int;
Declare @Cursor1_RowCount int;

-- Insert the resultset we want to loop through
-- into the temporary table
Declare @Cursor1_Table table (
	 RowID int identity(1, 1), 
	 Code varchar(10)
);
Insert into @Cursor1_Table (Code)
Select	c.Code
From	dbo.Airport c

-- Get the number of records in the temporary table
Select @Cursor1_NumberRecords = @@ROWCOUNT;
Select @Cursor1_RowCount = 1;

-- loop through all records in the temporary table
-- using the WHILE loop construct
While @Cursor1_RowCount <= @Cursor1_NumberRecords
Begin
	Select  @Cursor1_Code = Code
	From	@Cursor1_Table
	Where	RowID = @Cursor1_RowCount;

    --------------------------------------------------
    -- CURSOR 2
    --------------------------------------------------
    Declare @Cursor2_Code varchar(10);
    Declare @Cursor2_NumberRecords int;
    Declare @Cursor2_RowCount int;

    -- Insert the resultset we want to loop through
    -- into the temporary table
    Declare @Cursor2_Table table (
        RowID int identity(1, 1), 
        Code varchar(10)
    );
    Insert into @Cursor2_Table (Code)
    Select	Code
    From	dbo.Airport c
    Where	c.Code <> @Cursor1_Code;

    -- Get the number of records in the temporary table
    Select @Cursor2_NumberRecords = @@ROWCOUNT;
    Select @Cursor2_RowCount = 1;

    -- loop through all records in the temporary table
    -- using the WHILE loop construct
    While @Cursor2_RowCount <= @Cursor2_NumberRecords
    Begin
        Select  @Cursor2_Code = Code
        From	@Cursor2_Table
        Where	RowID = @Cursor2_RowCount;

        --------------------------------------------------
        -- CURSOR 3
        --------------------------------------------------
        Declare @Cursor3_Index int;
        Declare @Cursor3_NumberRecords int;
        Declare @Cursor3_RowCount int;

        -- Insert the resultset we want to loop through
        -- into the temporary table
        Declare @Cursor3_Table table (
            RowID int identity(1, 1), 
            [Index] int
        );
        Insert into @Cursor3_Table ([Index])
        Values (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

        -- Get the number of records in the temporary table
        Select @Cursor3_NumberRecords = @@ROWCOUNT;
        Select @Cursor3_RowCount = 1;

        -- loop through all records in the temporary table
        -- using the WHILE loop construct
        While @Cursor3_RowCount <= @Cursor3_NumberRecords
        Begin
            Select  @Cursor3_Index = [Index]
            From	@Cursor3_Table
            Where	RowID = @Cursor3_RowCount;

            Declare @DepartureTime varchar(10);
            Declare @Arrivaltime varchar(10);
            Declare @EconomyPrice Decimal(5,2);
            Declare @PremiumEconomyPrice Decimal(10,2);
            Declare @BusinessClassPrice Decimal(10,2);

            SET @DepartureTime = convert(varchar, FLOOR(RAND()*(14-1+1)+1)) + 'h' + RIGHT('00'+ISNULL(convert(varchar, FLOOR(RAND()*(59+0))),''),2);
            SET @Arrivaltime = convert(varchar, FLOOR(RAND()*(23-14+1)+14)) + 'h' + RIGHT('00'+ISNULL(convert(varchar, FLOOR(RAND()*(59+0))),''),2);
            SET @EconomyPrice = (RAND() * 1000);
            SET @PremiumEconomyPrice = @EconomyPrice + (RAND() * 1000);
            SET @BusinessClassPrice = @PremiumEconomyPrice + (RAND() * 1500);

            Insert into dbo.Flight (
                OriginAirportCode, 
                DestinationAirportCode, 
                DepartureTime, 
                ArrivalTime, 
                EconomyPrice, 
                PremiumEconomyPrice, 
                BusinessClassPrice
            )
            Values (
                @Cursor1_Code,
                @Cursor2_Code,
                @DepartureTime,
                @Arrivaltime,
                @EconomyPrice,
                @PremiumEconomyPrice,
                @BusinessClassPrice
            );

            Select @Cursor3_RowCount = @Cursor3_RowCount + 1;
        End

        Select @Cursor2_RowCount = @Cursor2_RowCount + 1;
    End

	Select @Cursor1_RowCount = @Cursor1_RowCount + 1;
END