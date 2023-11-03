USE UNIVER;
GO


-- Задание №8
DECLARE
	@Counter	int = 0,
	@Value		int = 0
;

WHILE @Counter >= 0
BEGIN
	SET @Counter = @Counter + 1;
	SET @Value = @Value + (FLOOR(RAND() * 10));
	PRINT CAST(@Counter AS varchar(5)) + ': ' + CAST(@Value AS varchar(5));
	IF @Value > 100
	BEGIN
		PRINT 'Using RETURN...';
		RETURN;
	END
END
PRINT 'Loop is ended';

GO
