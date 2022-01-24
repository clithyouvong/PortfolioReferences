CREATE FUNCTION dbo.TryConvertDate
(
  @value nvarchar(4000)
)
RETURNS date
AS
BEGIN
  RETURN (SELECT CONVERT(date, CASE 
    WHEN ISDATE(@value) = 1 THEN @value END)
  );
END
GO	

CREATE FUNCTION dbo.TryConvertInt
(
  @value nvarchar(4000)
)
RETURNS int
AS
BEGIN
  RETURN (SELECT CONVERT(int, 
    CASE WHEN LEN(@value) <= 11 THEN
      CASE WHEN @value NOT LIKE N'%[^-0-9]%' THEN
        CASE WHEN CONVERT(bigint, @value) BETWEEN -2147483648 AND 2147483647 
             THEN @value 
        END 
      END 
    END));
END
GO	

CREATE FUNCTION dbo.TryConvertUniqueidentifier
(
  @value nvarchar(4000)
)
RETURNS uniqueidentifier
AS
BEGIN
  RETURN (SELECT CONVERT(uniqueidentifier,
    CASE WHEN LEN(@value) = 36 THEN
    CASE WHEN @value LIKE
       '[A-F0-9][A-F0-9][A-F0-9][A-F0-9]'
    +  '[A-F0-9][A-F0-9][A-F0-9][A-F0-9]'
    + '-[A-F0-9][A-F0-9][A-F0-9][A-F0-9]'
    + '-[A-F0-9][A-F0-9][A-F0-9][A-F0-9]'
    + '-[A-F0-9][A-F0-9][A-F0-9][A-F0-9]'
    + '-[A-F0-9][A-F0-9][A-F0-9][A-F0-9]'
    +  '[A-F0-9][A-F0-9][A-F0-9][A-F0-9]'
    +  '[A-F0-9][A-F0-9][A-F0-9][A-F0-9]'
    THEN @value END
    END)
  );
END
GO
