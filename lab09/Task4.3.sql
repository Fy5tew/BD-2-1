USE UNIVER;
GO


-- Задание №4.3
DROP FUNCTION dbo.CalcAge;
GO

CREATE FUNCTION dbo.CalcAge(@BirthDate date)
RETURNS int
AS
BEGIN
	DECLARE
		@CurrentDay		int = DAY(GETDATE()),
		@CurrentMonth	int = MONTH(GETDATE()),
		@CurrentYear	int = YEAR(GETDATE()),
		@BirthDay		int = DAY(@BirthDate),
		@BirthMonth		int = MONTH(@BirthDate),
		@BirthYear		int = YEAR(@BirthDate),
		@Age			int
	;
	SET @Age = @CurrentYear - @BirthYear;
	IF (
		@BirthMonth > @CurrentMonth 
		OR (@BirthMonth = @CurrentMonth AND @BirthDay > @CurrentDay)
	)
	BEGIN
		SET @Age = @Age - 1;
	END
	RETURN @Age;
END
GO


DECLARE @CurrentMonth int = MONTH(GETDATE());

SELECT
	IDSTUDENT AS 'Id', 
	NAME AS 'Name',
	BDAY AS 'BDate',
	dbo.CalcAge(BDAY) AS 'Age'
FROM 
	STUDENT
WHERE
	MONTH(BDAY) = (@CurrentMonth + 1)
;
GO
