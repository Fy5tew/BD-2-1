USE UNIVER;
GO


-- ������� �1
DROP FUNCTION COUNT_STUDENTS;
GO

CREATE FUNCTION COUNT_STUDENTS(
	@faculty varchar(20)
) 
RETURNS int
AS BEGIN
	DECLARE @Count int = (
		SELECT
			COUNT(*)
		FROM
			STUDENT
			INNER JOIN GROUPS ON GROUPS.IDGROUP = STUDENT.IDGROUP
			INNER JOIN FACULTY ON FACULTY.FACULTY = GROUPS.FACULTY
		WHERE 
			FACULTY.FACULTY = @faculty
	);
	RETURN @Count;
END;
GO

DECLARE @Count int = dbo.COUNT_STUDENTS('��');
PRINT '���������� ��������� �� ����������: ' + cast(@Count AS varchar(10));
GO

ALTER FUNCTION COUNT_STUDENTS(
	@faculty varchar(20),
	@prof varchar(20) = NULL
) 
RETURNS int
AS BEGIN
	DECLARE @Count int = (
		SELECT
			COUNT(*)
		FROM
			STUDENT
			INNER JOIN GROUPS ON GROUPS.IDGROUP = STUDENT.IDGROUP
			INNER JOIN FACULTY ON FACULTY.FACULTY = GROUPS.FACULTY
		WHERE 
			FACULTY.FACULTY = @faculty
			AND (GROUPS.PROFESSION = @prof OR @prof IS NULL)
	);
	RETURN @Count;
END;
GO

DECLARE @Count int = dbo.COUNT_STUDENTS('��', default);
PRINT '���������� ��������� �� ����������: ' + cast(@Count AS varchar(10));
GO
DECLARE @Count int = dbo.COUNT_STUDENTS('��', '1-40 01 02');
PRINT '���������� ��������� �� ����������: ' + cast(@Count AS varchar(10));
GO


-- ������� �2
DROP FUNCTION FSUBJECTS;
GO

CREATE FUNCTION FSUBJECTS(
	@p varchar(20)
)
RETURNS varchar(300)
AS BEGIN
	DECLARE SubjectCursor CURSOR LOCAL STATIC FOR
		SELECT SUBJECT
		FROM SUBJECT 
		WHERE PULPIT = @p
	;
	DECLARE 
		@Subject char(10),
		@Subjects varchar(300) = ''
	;
	OPEN SubjectCursor;
	FETCH SubjectCursor INTO @Subject;
	WHILE @@FETCH_STATUS = 0 BEGIN
		SET @Subjects = @Subjects + RTRIM(LTRIM(@Subject)) + ', ';
		FETCH SubjectCursor INTO @Subject;
	END
	IF LEN(@Subjects) > 0
		SET @Subjects = SUBSTRING(@Subjects, 1, LEN(@Subjects) - 1);
	RETURN @Subjects;
END;
GO

SELECT
	PULPIT AS '�������',
	dbo.FSUBJECTS(PULPIT) AS '����������'
FROM PULPIT
;


-- ������� �3
DROP FUNCTION FFACPUL;
GO

CREATE FUNCTION FFACPUL(
	@faculty varchar(20),
	@pulpit varchar(20)
)
RETURNS TABLE
AS RETURN (
	SELECT
		FACULTY.FACULTY,
		PULPIT.PULPIT
	FROM
		FACULTY
		LEFT OUTER JOIN PULPIT ON PULPIT.FACULTY = FACULTY.FACULTY
	WHERE
		(LTRIM(RTRIM(FACULTY.FACULTY)) = @faculty OR @faculty IS NULL)
		AND (PULPIT.PULPIT = @pulpit OR @pulpit IS NULL)
);
GO

SELECT * FROM dbo.FFACPUL(NULL, NULL);
SELECT * FROM dbo.FFACPUL('���', NULL);
SELECT * FROM dbo.FFACPUL(NULL, '�����');
SELECT * FROM dbo.FFACPUL('����', '�����');
SELECT * FROM dbo.FFACPUL(NULL, '��');
GO


-- ������� �4
DROP FUNCTION FCTEACHER;
GO

CREATE FUNCTION FCTEACHER(
	@pulpit varchar(20)
)
RETURNS int
AS BEGIN
	DECLARE @TeacherCount int = (
		SELECT COUNT(*)
		FROM TEACHER
		WHERE PULPIT = @pulpit OR @pulpit IS NULL
	);
	RETURN @TeacherCount;
END;
GO

SELECT
	PULPIT AS '�������',
	dbo.FCTEACHER(PULPIT) AS '���������� ��������������'
FROM PULPIT
;
SELECT dbo.FCTEACHER(NULL) AS '����� ��������������';
GO


-- ������� �6
DROP FUNCTION COUNT_PULPITS;
DROP FUNCTION COUNT_GROUPS;
DROP FUNCTION COUNT_PROFESSIONS;
DROP FUNCTION FACULTY_REPORT;
GO

CREATE FUNCTION COUNT_PULPITS(
	@faculty varchar(20)
)
RETURNS int
AS BEGIN
	DECLARE @PulpitCount int = (
		SELECT COUNT(*) FROM PULPIT WHERE FACULTY = @faculty
	);
	RETURN @PulpitCount;
END;
GO

CREATE FUNCTION COUNT_GROUPS(
	@faculty varchar(20)
)
RETURNS int
AS BEGIN
	DECLARE @GroupCount int = (
		SELECT COUNT(*) FROM GROUPS WHERE FACULTY = @faculty
	);
	RETURN @GroupCount;
END;
GO

CREATE FUNCTION COUNT_PROFESSIONS(
	@faculty varchar(20)
)
RETURNS int
AS BEGIN
	DECLARE @ProfessionCount int = (
		SELECT COUNT(*) FROM PROFESSION WHERE FACULTY = @faculty
	);
	RETURN @ProfessionCount;
END;
GO

create function FACULTY_REPORT(
	@c int
)
returns @fr table(
	[���������] varchar(50),
	[���������� ������] int, 
	[���������� �����]  int,
	[���������� ���������] int, 
	[���������� ��������������] int 
)
as begin 
	declare cc CURSOR static for 
		select FACULTY from FACULTY 
        where dbo.COUNT_STUDENTS(FACULTY, default) > @c
	; 
	declare @f varchar(30);
	open cc;  
    fetch cc into @f;
	while @@fetch_status = 0
	begin
	    insert @fr values(
			@f,
			dbo.COUNT_PULPITS(@f),
			dbo.COUNT_GROUPS(@f),
			dbo.COUNT_STUDENTS(@f, default),
			dbo.COUNT_PROFESSIONS(@f)
		); 
	    fetch cc into @f;  
	end;   
    return; 
end;
GO

SELECT * FROM dbo.FACULTY_REPORT(10);
GO


-- ������� �7*
DROP PROCEDURE PRINT_REPORTX;
GO

CREATE PROCEDURE PRINT_REPORTX
	@f char(10) = NULL,
	@p char(10) = NULL
AS BEGIN
	IF (@f IS NULL) AND (@p IS NOT NULL) BEGIN
		SET @f = (SELECT FACULTY FROM PULPIT WHERE PULPIT = @p);
		IF (@f IS NULL) OR (LEN(@f) < 1) BEGIN
			;THROW 51000, '������ � ����������', 1;
			RETURN -1;
		END
	END
	DECLARE ReportCursor CURSOR LOCAL STATIC FOR
		SELECT
			FACULTY AS '���������',
			PULPIT AS '�������',
			dbo.FCTEACHER(PULPIT) AS '���������� ��������������',
			dbo.FSUBJECTS(PULPIT) AS '��������'
		FROM
			dbo.FFACPUL(@f, @p)
		GROUP BY
			FACULTY,
			PULPIT
	;
	DECLARE
		@PrevFaculty nvarchar(7) = '',
		@Faculty nvarchar(7),
		@Pulpit nvarchar(7),
		@TeacherCount int,
		@Subjects nvarchar(150),
		@PulpitCount int = 0
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
		SET @PulpitCount = @PulpitCount + 1;
		PRINT '	�������: ' + @Pulpit;
		PRINT '		���������� ��������������: ' + cast(@TeacherCount as nvarchar(5));
		PRINT '		����������: ' + COALESCE(NULLIF(@Subjects, ''), '���') + '.';
		FETCH ReportCursor INTO @Faculty, @Pulpit, @TeacherCount, @Subjects;
	END
	RETURN @PulpitCount;
END;
GO

DECLARE @Ret int;
EXEC @Ret = PRINT_REPORTX @f='��', @p='����';
PRINT '���������� ������ � ������: ' + cast(@Ret AS varchar(5));
EXEC @Ret = PRINT_REPORTX @f='���';
PRINT '���������� ������ � ������: ' + cast(@Ret AS varchar(5));
EXEC @Ret = PRINT_REPORTX @p='��';
PRINT '���������� ������ � ������: ' + cast(@Ret AS varchar(5));
EXEC @Ret = PRINT_REPORTX @p='��';
PRINT '���������� ������ � ������: ' + cast(@Ret AS varchar(5));
GO
