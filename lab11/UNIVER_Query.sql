USE UNIVER;
GO


-- ������� �1
DECLARE
	@PulpitSubjects	varchar(300) = '',
	@PulpitSubject char(10)
;
DECLARE ISITSubjects CURSOR FOR
	SELECT SUBJECT.SUBJECT
	FROM SUBJECT INNER JOIN PULPIT ON PULPIT.PULPIT = SUBJECT.PULPIT
	WHERE PULPIT.PULPIT = '����'
;
OPEN ISITSubjects;
FETCH ISITSubjects INTO @PulpitSubject;
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @PulpitSubjects = RTRIM(@PulpitSubject) + ', ' + @PulpitSubjects;
	FETCH ISITSubjects INTO @PulpitSubject;
END
CLOSE ISITSubjects;
DEALLOCATE ISITSubjects;
PRINT '�������� �� ������� ����';
PRINT @PulpitSubjects;
GO


-- ������� �2
-- ���������
DECLARE LCursor CURSOR LOCAL FOR
	SELECT AUDITORIUM.AUDITORIUM_NAME, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
	FROM AUDITORIUM INNER JOIN AUDITORIUM_TYPE ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE 
;
DECLARE 
	@AuditoriumName varchar(10),
	@AuditoriumType varchar(10)
;
OPEN LCursor;
FETCH LCursor INTO @AuditoriumName, @AuditoriumType;
print @AuditoriumName + ' ' + @AuditoriumType;
GO
DECLARE 
	@AuditoriumName varchar(10),
	@AuditoriumType varchar(10)
;
FETCH LCursor INTO @AuditoriumName, @AuditoriumType;
print @AuditoriumName + ' ' + @AuditoriumType;
GO

-- ����������
DECLARE LCursor CURSOR FOR
	SELECT AUDITORIUM.AUDITORIUM_NAME, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
	FROM AUDITORIUM INNER JOIN AUDITORIUM_TYPE ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE 
;
DECLARE 
	@AuditoriumName varchar(10),
	@AuditoriumType varchar(10)
;
OPEN LCursor;
FETCH LCursor INTO @AuditoriumName, @AuditoriumType;
print @AuditoriumName + ' ' + @AuditoriumType;
GO
DECLARE 
	@AuditoriumName varchar(10),
	@AuditoriumType varchar(10)
;
FETCH LCursor INTO @AuditoriumName, @AuditoriumType;
PRINT @AuditoriumName + ' ' + @AuditoriumType;
GO
CLOSE LCursor;
DEALLOCATE LCursor;
GO


-- ������� �3
-- �����������
DECLARE 
	@Auditorium varchar(7)
;
DECLARE LCursor CURSOR LOCAL STATIC FOR
	SELECT AUDITORIUM FROM AUDITORIUM
;
OPEN LCursor;
INSERT INTO AUDITORIUM VALUES ('200-3a', '��-�', 200, '200-3a');
FETCH LCursor INTO @Auditorium;
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @Auditorium;
	FETCH LCursor INTO @Auditorium;
END
DELETE FROM AUDITORIUM WHERE AUDITORIUM = '200-3a';
GO

-- �����������
DECLARE 
	@Auditorium varchar(7)
;
DECLARE LCursor CURSOR LOCAL DYNAMIC FOR
	SELECT AUDITORIUM FROM AUDITORIUM
;
OPEN LCursor;
INSERT INTO AUDITORIUM VALUES ('200-3a', '��-�', 200, '200-3a');
FETCH LCursor INTO @Auditorium;
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @Auditorium;
	FETCH LCursor INTO @Auditorium;
END
DELETE FROM AUDITORIUM WHERE AUDITORIUM = '200-3a';
GO


-- ������� �4
DECLARE @StudentName nvarchar(50);
DECLARE StudentCursor CURSOR LOCAL STATIC SCROLL FOR
	SELECT NAME FROM STUDENT
;
OPEN StudentCursor;
FETCH FIRST FROM StudentCursor INTO @StudentName;
PRINT '������ �������: ' + @StudentName;
FETCH NEXT FROM StudentCursor INTO @StudentName;
PRINT '��������� �������: ' + @StudentName;
FETCH ABSOLUTE 5 FROM StudentCursor INTO @StudentName;
PRINT '����� �������: ' + @StudentName;
FETCH PRIOR FROM StudentCursor INTO @StudentName;
PRINT '���������� �������: ' + @StudentName;
FETCH RELATIVE 5 FROM StudentCursor INTO @StudentName;
PRINT '+5 �������: ' + @StudentName;
FETCH ABSOLUTE -2 FROM StudentCursor INTO @StudentName;
PRINT '������������� �������: ' + @StudentName;
FETCH RELATIVE -2 FROM StudentCursor INTO @StudentName;
PRINT '-2 �������: ' + @StudentName;
FETCH LAST FROM StudentCursor INTO @StudentName;
PRINT '��������� �������: ' + @StudentName;
GO


-- ������� �5
DECLARE
	@Type nvarchar(10),
	@TypeName nvarchar(30)
;
DECLARE TypeCursor CURSOR LOCAL DYNAMIC FOR
	SELECT AUDITORIUM_TYPE, AUDITORIUM_TYPENAME FROM AUDITORIUM_TYPE
FOR UPDATE
;
INSERT INTO AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
VALUES ('��-1', '�������� ���������');

OPEN TypeCursor;
FETCH TypeCursor INTO @Type, @Typename;
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @Type = '��-1' BREAK
	FETCH TypeCursor INTO @Type, @Typename;
END
PRINT @Type

SELECT * FROM AUDITORIUM_TYPE;

UPDATE AUDITORIUM_TYPE 
SET AUDITORIUM_TYPENAME = '����� ��������'
WHERE CURRENT OF TypeCursor

SELECT * FROM AUDITORIUM_TYPE;

DELETE FROM AUDITORIUM_TYPE 
WHERE CURRENT OF TypeCursor;

SELECT * FROM AUDITORIUM_TYPE;
GO


-- ������� �6.1
INSERT INTO PROGRESS(SUBJECT, IDSTUDENT, PDATE, NOTE)
VALUES 
	('���', 1005, GETDATE(), 2),
	('��', 1010, GETDATE(), 3),
	('���', 1020, GETDATE(), 2),
	('��', 1013, GETDATE(), 3),
	('���', 1002, GETDATE(), 2),
	('��', 1017, GETDATE(), 3),
	('���', 1007, GETDATE(), 2),
	('��', 1021, GETDATE(), 3)
;

DECLARE ProgressCursor CURSOR LOCAL DYNAMIC FOR
	SELECT STUDENT.NAME, GROUPS.IDGROUP, PROGRESS.NOTE
	FROM PROGRESS
	INNER JOIN STUDENT ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
	INNER JOIN GROUPS ON STUDENT.IDGROUP = GROUPS.IDGROUP
	WHERE PROGRESS.NOTE < 4
FOR UPDATE
;
DECLARE
	@Student nvarchar(30),
	@Group int,
	@Note int
;

SELECT * FROM PROGRESS;

OPEN ProgressCursor;
FETCH ProgressCursor INTO @Student, @Group, @Note;
WHILE @@FETCH_STATUS = 0
BEGIN
	DELETE FROM PROGRESS WHERE CURRENT OF ProgressCursor;
	FETCH ProgressCursor INTO @Student, @Group, @Note;
END

SELECT * FROM PROGRESS;
GO


-- ������� �6.2
INSERT INTO PROGRESS(SUBJECT, IDSTUDENT, PDATE, NOTE)
VALUES ('���', 1006, GETDATE(), 3);

DECLARE ProgressCursor CURSOR LOCAL DYNAMIC FOR
	SELECT IDSTUDENT, NOTE FROM PROGRESS
FOR UPDATE
;
DECLARE
	@StudentId int,
	@Note int
;

SELECT * FROM PROGRESS;

OPEN ProgressCursor;
FETCH ProgressCursor INTO @StudentId, @Note;
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @StudentId = 1006 BREAK;
	FETCH ProgressCursor INTO @StudentId, @Note;
END

UPDATE PROGRESS
SET Note = Note + 1
WHERE CURRENT OF ProgressCursor
;

SELECT * FROM PROGRESS;

DELETE FROM PROGRESS WHERE IDSTUDENT = 1006;
GO


-- ������� �8*
DECLARE ReportCursor CURSOR LOCAL STATIC FOR
	SELECT
		f.FACULTY AS '���������',
		p.PULPIT AS '�������',
		(
			SELECT COUNT(*) 
			FROM TEACHER t 
			WHERE t.PULPIT = p.PULPIT
		) AS '���������� ��������������',
		(
			SELECT STRING_AGG(LTRIM(RTRIM(s.SUBJECT)), ', ') 
			FROM SUBJECT s 
			WHERE s.PULPIT = p.PULPIT
		) AS '��������'
	FROM
		FACULTY f
		INNER JOIN PULPIT p ON p.FACULTY = f.FACULTY
	GROUP BY
		f.FACULTY,
		p.PULPIT
;
DECLARE
	@PrevFaculty nvarchar(7) = '',
	@Faculty nvarchar(7),
	@Pulpit nvarchar(7),
	@TeacherCount int,
	@Subjects nvarchar(150)
;
OPEN ReportCursor;

FETCH ReportCursor INTO @Faculty, @Pulpit, @TeacherCount, @Subjects;
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @Faculty <> @PrevFaculty
	BEGIN
		PRINT '���������: ' + @Faculty;
		SET @PrevFaculty = @Faculty;
	END
	PRINT '	�������: ' + @Pulpit;
	PRINT '		���������� ��������������: ' + cast(@TeacherCount as nvarchar(5));
	PRINT '		����������: ' + ISNULL(@Subjects, '���') + '.';
	FETCH ReportCursor INTO @Faculty, @Pulpit, @TeacherCount, @Subjects;
END
GO
