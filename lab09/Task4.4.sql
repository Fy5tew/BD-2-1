USE UNIVER;
GO


-- ������� �4.4
SELECT 
	SUBJECT AS '�������',
	PDATE AS '����',
	DATENAME(weekday, PDATE) AS '���� ������'
FROM PROGRESS
WHERE SUBJECT = '����'
;
