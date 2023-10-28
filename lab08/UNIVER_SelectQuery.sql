USE UNIVER;
GO


-- Задание №1
DROP VIEW [Преподаватель];
GO

CREATE VIEW [Преподаватель]
AS SELECT
	TEACHER.TEACHER AS 'Код',
	TEACHER.TEACHER_NAME AS 'ФИО',
	TEACHER.GENDER AS 'Пол',
	TEACHER.PULPIT AS 'Кафедра'
FROM 
	TEACHER
;
GO

SELECT * FROM [Преподаватель];
GO


-- Задание №2
DROP VIEW [Количество кафедр];
GO

CREATE VIEW [Количество кафедр] 
AS SELECT
	FACULTY.FACULTY_NAME AS 'Факультет',
	COUNT(*) AS 'Количество кафедр'
FROM
	FACULTY
	INNER JOIN PULPIT ON PULPIT.FACULTY = FACULTY.FACULTY
GROUP BY
	FACULTY.FACULTY_NAME
;
GO

SELECT * FROM [Количество кафедр];
;


-- Задание №3
DROP VIEW [Аудитории];
GO

CREATE VIEW [Аудитории] 
AS SELECT
	AUDITORIUM.AUDITORIUM AS 'Код',
	AUDITORIUM.AUDITORIUM_NAME AS 'Наименование',
	AUDITORIUM.AUDITORIUM_TYPE AS 'Тип'
FROM
	AUDITORIUM
;
GO

INSERT [Аудитории] VALUES('200-3a', '200-3a', 'ЛК-К');
GO

DELETE [Аудитории] WHERE [Код] = '200-3a';
GO

SELECT * FROM [Аудитории];
GO

SELECT * FROM AUDITORIUM;
GO


-- Задание №4
DROP VIEW [Лекционные аудитории];
GO

CREATE VIEW [Лекционные аудитории]
AS SELECT
	AUDITORIUM.AUDITORIUM AS 'Код',
	AUDITORIUM.AUDITORIUM_NAME AS 'Наименование',
	AUDITORIUM.AUDITORIUM_TYPE AS 'Тип'
FROM
	AUDITORIUM
WHERE
	AUDITORIUM.AUDITORIUM_TYPE LIKE 'ЛК%'
	WITH CHECK OPTION
;

INSERT [Лекционные аудитории] VALUES('102б-1', '102б-1', 'ЛБ-К');
GO

DELETE AUDITORIUM WHERE AUDITORIUM = '102б-1';
GO

INSERT [Лекционные аудитории] VALUES('200-3a', '200-3a', 'ЛК-К');
GO

DELETE [Лекционные аудитории] WHERE [Код] = '200-3a';
GO

SELECT * FROM [Лекционные аудитории];
GO

SELECT * FROM AUDITORIUM;
GO


-- Задание №5
DROP VIEW [Дисциплины];
GO

CREATE VIEW [Дисциплины]
AS SELECT TOP (SELECT COUNT(*) FROM SUBJECT)
	SUBJECT.SUBJECT AS 'Код',
	SUBJECT.SUBJECT_NAME AS 'Наименование',
	SUBJECT.PULPIT AS 'Код кафедры'
FROM
	SUBJECT
ORDER BY
	SUBJECT.SUBJECT_NAME
;
GO

SELECT * FROM [Дисциплины];
GO

SELECT * FROM SUBJECT;
GO


-- Задание №6
ALTER VIEW [Количество кафедр] WITH SCHEMABINDING
AS SELECT
	f.FACULTY_NAME AS 'Факультет',
	COUNT(*) AS 'Количество кафедр'
FROM
	dbo.FACULTY AS f
	INNER JOIN dbo.PULPIT AS p ON p.FACULTY = f.FACULTY
GROUP BY
	f.FACULTY_NAME
;
GO


-- Задание №8
SELECT * FROM TIMETABLE;

DROP VIEW [Расписание];
GO

CREATE VIEW [Расписание]
AS SELECT
	[Номер группы],
	[пн], [вт], [ср], [чт], [пт], [сб]
FROM
(
	SELECT
		TIMETABLE.DAY_NAME AS [День],
		TIMETABLE.IDGROUP AS [Номер группы],
		TIMETABLE.SUBJECT AS [Предмет]
	FROM
		TIMETABLE
) AS SourceTable
PIVOT
(
	COUNT([Предмет])
	FOR [День] IN ([пн], [вт], [ср], [чт], [пт], [сб])
) AS PivotTable
;
GO

SELECT * FROM [Расписание];
GO