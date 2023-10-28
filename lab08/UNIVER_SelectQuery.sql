USE UNIVER;
GO


-- ������� �1
DROP VIEW [�������������];
GO

CREATE VIEW [�������������]
AS SELECT
	TEACHER.TEACHER AS '���',
	TEACHER.TEACHER_NAME AS '���',
	TEACHER.GENDER AS '���',
	TEACHER.PULPIT AS '�������'
FROM 
	TEACHER
;
GO

SELECT * FROM [�������������];
GO


-- ������� �2
DROP VIEW [���������� ������];
GO

CREATE VIEW [���������� ������] 
AS SELECT
	FACULTY.FACULTY_NAME AS '���������',
	COUNT(*) AS '���������� ������'
FROM
	FACULTY
	INNER JOIN PULPIT ON PULPIT.FACULTY = FACULTY.FACULTY
GROUP BY
	FACULTY.FACULTY_NAME
;
GO

SELECT * FROM [���������� ������];
;


-- ������� �3
DROP VIEW [���������];
GO

CREATE VIEW [���������] 
AS SELECT
	AUDITORIUM.AUDITORIUM AS '���',
	AUDITORIUM.AUDITORIUM_NAME AS '������������',
	AUDITORIUM.AUDITORIUM_TYPE AS '���'
FROM
	AUDITORIUM
;
GO

INSERT [���������] VALUES('200-3a', '200-3a', '��-�');
GO

DELETE [���������] WHERE [���] = '200-3a';
GO

SELECT * FROM [���������];
GO

SELECT * FROM AUDITORIUM;
GO


-- ������� �4
DROP VIEW [���������� ���������];
GO

CREATE VIEW [���������� ���������]
AS SELECT
	AUDITORIUM.AUDITORIUM AS '���',
	AUDITORIUM.AUDITORIUM_NAME AS '������������',
	AUDITORIUM.AUDITORIUM_TYPE AS '���'
FROM
	AUDITORIUM
WHERE
	AUDITORIUM.AUDITORIUM_TYPE LIKE '��%'
	WITH CHECK OPTION
;

INSERT [���������� ���������] VALUES('102�-1', '102�-1', '��-�');
GO

DELETE AUDITORIUM WHERE AUDITORIUM = '102�-1';
GO

INSERT [���������� ���������] VALUES('200-3a', '200-3a', '��-�');
GO

DELETE [���������� ���������] WHERE [���] = '200-3a';
GO

SELECT * FROM [���������� ���������];
GO

SELECT * FROM AUDITORIUM;
GO


-- ������� �5
DROP VIEW [����������];
GO

CREATE VIEW [����������]
AS SELECT TOP (SELECT COUNT(*) FROM SUBJECT)
	SUBJECT.SUBJECT AS '���',
	SUBJECT.SUBJECT_NAME AS '������������',
	SUBJECT.PULPIT AS '��� �������'
FROM
	SUBJECT
ORDER BY
	SUBJECT.SUBJECT_NAME
;
GO

SELECT * FROM [����������];
GO

SELECT * FROM SUBJECT;
GO


-- ������� �6
ALTER VIEW [���������� ������] WITH SCHEMABINDING
AS SELECT
	f.FACULTY_NAME AS '���������',
	COUNT(*) AS '���������� ������'
FROM
	dbo.FACULTY AS f
	INNER JOIN dbo.PULPIT AS p ON p.FACULTY = f.FACULTY
GROUP BY
	f.FACULTY_NAME
;
GO


-- ������� �8
SELECT * FROM TIMETABLE;

DROP VIEW [����������];
GO

CREATE VIEW [����������]
AS SELECT
	[����� ������],
	[��], [��], [��], [��], [��], [��]
FROM
(
	SELECT
		TIMETABLE.DAY_NAME AS [����],
		TIMETABLE.IDGROUP AS [����� ������],
		TIMETABLE.SUBJECT AS [�������]
	FROM
		TIMETABLE
) AS SourceTable
PIVOT
(
	COUNT([�������])
	FOR [����] IN ([��], [��], [��], [��], [��], [��])
) AS PivotTable
;
GO

SELECT * FROM [����������];
GO