USE UNIVER;
GO


-- Задание №4.1

DROP FUNCTION dbo.Z;
GO

CREATE FUNCTION dbo.Z(@T int, @X int)
RETURNS int
AS
BEGIN
	DECLARE @Result int;
	IF @T > @X
		SET @Result = power(sin(@T), 2);
	ELSE IF @T < @X
		SET @Result = 4 * (@T + @X);
	ELSE
		SET @Result = 1 - exp(@X - 2);
	RETURN @Result;
END
GO

SELECT 
	dbo.Z(5, 5) AS 'Z(5, 5)',
	dbo.Z(9, 3) AS 'Z(9, 3)',
	dbo.Z(6, 11) AS 'Z(6, 11)'
;
GO
