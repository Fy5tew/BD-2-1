USE UNIVER;
GO


-- Задание №4.2
DROP FUNCTION dbo.ShortenFIO;
GO

CREATE FUNCTION dbo.ShortenFIO(@FullFIO varchar(100))
RETURNS nvarchar(50)
AS
BEGIN
	DECLARE
		@SplittedValues TABLE (
			Row int,
			Value nvarchar(25)
		)
	;
	DECLARE
		@ShortenedValues TABLE (
			Row int,
			Value nvarchar(1)
		)
	;

	INSERT INTO @SplittedValues (Row, Value)
	SELECT 
		ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Row, 
		value AS Value
	FROM string_split(@FullFIO, ' ')
	;

	INSERT INTO @ShortenedValues (Row, Value)
	SELECT
		Row AS Row,
		SUBSTRING(Value, 0, 2) AS Value
	FROM @SplittedValues
	;

	DECLARE @ShortenedFIO nvarchar(25) = (SELECT Value FROM @SplittedValues WHERE Row = 1);

	DECLARE 
		@Counter	int = 1,
		@Count		int = (SELECT COUNT(*) FROM @ShortenedValues)
	;

	WHILE @Counter < @Count
	BEGIN
		SET @Counter = @Counter + 1;
		DECLARE @Value nvarchar(1) = (SELECT Value FROM @ShortenedValues WHERE Row = @Counter);
		SET @ShortenedFIO = @ShortenedFIO + ' ' + @Value + '.';
	END

	RETURN @ShortenedFIO;
END
GO

DECLARE @FIO varchar(100) = 'Турчинович Никита Александрович';
SELECT 
	@FIO AS 'До сокращения',
	dbo.ShortenFIO(@FIO) AS 'После сокращения'
;
GO
