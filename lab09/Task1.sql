USE UNIVER;
GO


-- Задание №1
DECLARE
	@CharValue		char(4)			= 'BSTU',
	@VarcharValue	varchar(4)		= 'БГТУ',
	@DatetimeValue	datetime				,
	@TimeValue		time					,
	@IntValue		int						,
	@SmallintValue	smallint				,
	@TinyintValue	tinyint					,
	@NumericValue	numeric(12, 5)			
;

SET @DatetimeValue = GETDATE();
SET @TimeValue = GETDATE();
SET @IntValue = 5;
SET @NumericValue = 146.6743;

SELECT
	@SmallintValue = T.Value,
	@TinyintValue = T.Value
FROM (
	SELECT @IntValue AS Value
) AS T
;

PRINT 'char: ' + @CharValue;
PRINT 'varchar: ' + @VarcharValue;
PRINT 'datetime: ' + CAST(@DatetimeValue AS varchar(30));
PRINT 'time: ' + CAST(@TimeValue AS varchar(15));

SELECT
	@IntValue AS 'int',
	@SmallintValue AS 'smallint',
	@TinyintValue AS 'tinyint',
	@NumericValue AS 'numeric'
;
GO