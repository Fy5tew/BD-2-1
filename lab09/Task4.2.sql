USE UNIVER;
GO


-- Задание №4.2
-- 4.2
DROP FUNCTION dbo.ShortenFIO;
GO

CREATE FUNCTION dbo.ShortenFIO(@FullFIO varchar(100))
RETURNS varchar(50)
AS
BEGIN
	DECLARE
		@SplittedFIO TABLE (
			Row int,
			Value varchar(25)
		)
	;
	DECLARE
		@LastName		varchar(25),
		@FirstName		varchar(25),
		@Surname		varchar(25),
		@ShortenedFIO	varchar(50)
	;

	INSERT INTO @SplittedFIO (Row, Value)
	SELECT 
		ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Row, 
		value AS Value
	FROM string_split(@FullFIO, ' ')
	;

	SET @LastName = (SELECT TOP(1) Value FROM @SplittedFIO WHERE Row = 1);
	SET @FirstName = (SELECT TOP(1) Value FROM @SplittedFIO WHERE Row = 2);
	SET @Surname = (SELECT TOP(1) Value FROM @SplittedFIO WHERE Row = 3);

	SET @ShortenedFIO = @LastName + ' ' + SUBSTRING(@FirstName, 0, 2) + '. ' + SUBSTRING(@Surname, 0, 2) + '.'; 

	RETURN @ShortenedFIO;
END
GO

DECLARE @FIO varchar(100) = 'Турчинович Никита Александрович';
SELECT 
	@FIO AS 'До сокращения',
	dbo.ShortenFIO(@FIO) AS 'После сокращения'
;
GO
