USE UNIVER;
GO


-- Задание №7
DROP TABLE #TempTable;
GO

CREATE TABLE #TempTable (
	Id int,
	IntData int,
	VarcharData varchar(100)
);
GO

SET nocount on;
DECLARE @Counter int = 0;

WHILE (@Counter < 10)
BEGIN
	INSERT INTO #TempTable(Id, IntData, VarcharData)
	VALUES (@Counter, FLOOR(10000 * RAND()), REPLICATE('Data', 1 + FLOOR(RAND() * 10)))
	;
	SET @Counter = @Counter + 1;
END
GO

SELECT * FROM #TempTable;
