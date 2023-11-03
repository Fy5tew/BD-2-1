USE UNIVER;
GO


-- ������� �2
DECLARE 
	@GeneralAuditoriumCapacity	int,
	@AllAuditoriumCount			int,
	@AvgAuditoriumCapacity		int,
	@SmallAuditoriumCount		int,
	@SmallAuditoriumPercent		numeric(5, 2)
;

SET @GeneralAuditoriumCapacity = (
	SELECT SUM(AUDITORIUM.AUDITORIUM_CAPACITY) FROM AUDITORIUM
);

IF @GeneralAuditoriumCapacity < 200 
	PRINT '����� ����������� ���������: ' + CAST(@GeneralAuditoriumCapacity AS varchar(5));
ELSE
BEGIN
	SELECT 
		@AllAuditoriumCount = COUNT(*),
		@AvgAuditoriumCapacity = AVG(AUDITORIUM.AUDITORIUM_CAPACITY)
	FROM AUDITORIUM
	;

	SELECT
		@SmallAuditoriumCount = COUNT(*) 
	FROM AUDITORIUM
	WHERE AUDITORIUM.AUDITORIUM_CAPACITY < @AvgAuditoriumCapacity
	;

	SET @SmallAuditoriumPercent = CAST(@SmallAuditoriumCount AS numeric(5, 2)) / CAST(@AllAuditoriumCount AS numeric(5, 2)) * 100;
	
	SELECT
		@AllAuditoriumCount AS '���������� ���������',
		@AvgAuditoriumCapacity AS '������� �����������',
		@SmallAuditoriumCount AS '���������� ��������� � ������� ������������',
		@SmallAuditoriumPercent AS '������� ��������� � ������� ������������'
	;
END
GO