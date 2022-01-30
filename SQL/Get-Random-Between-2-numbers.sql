
Declare @Min int = 0;
Declare @Max int = 100;

Select ABS(CHECKSUM(NEWID()) % (@Max - @Min - 1)) + @Min
