USE UNIVER;
GO


-- Задание №4.4
SELECT 
	SUBJECT AS 'Предмет',
	PDATE AS 'Дата',
	DATENAME(weekday, PDATE) AS 'День недели'
FROM PROGRESS
WHERE SUBJECT = 'СУБД'
;
