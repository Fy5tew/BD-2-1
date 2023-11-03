USE UNIVER;
GO


-- Задание №5
DECLARE @AuditoriumCount int = (
	SELECT COUNT(*) FROM AUDITORIUM
);

IF @AuditoriumCount > 5
	PRINT 'Количество аудиторий больше 5';
ELSE IF @AuditoriumCount < 5
	PRINT 'Количество аудиториий меньше 5';
ELSE
	PRINT 'Количество аудиторий равно 5'
PRINT 'Количество аудиторий: ' + CAST(@AuditoriumCount AS varchar(5));
GO
