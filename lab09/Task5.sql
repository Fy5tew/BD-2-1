USE UNIVER;
GO


-- ������� �5
DECLARE @AuditoriumCount int = (
	SELECT COUNT(*) FROM AUDITORIUM
);

IF @AuditoriumCount > 5
	PRINT '���������� ��������� ������ 5';
ELSE IF @AuditoriumCount < 5
	PRINT '���������� ���������� ������ 5';
ELSE
	PRINT '���������� ��������� ����� 5'
PRINT '���������� ���������: ' + CAST(@AuditoriumCount AS varchar(5));
GO
