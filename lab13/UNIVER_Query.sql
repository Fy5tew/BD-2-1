USE UNIVER;
GO


-- ������� �1
DROP PROCEDURE PSUBJECT;
GO

CREATE PROCEDURE PSUBJECT
AS BEGIN
	DECLARE @LinesCount int = (SELECT COUNT(*) FROM SUBJECT);
	SELECT
		SUBJECT AS '���',
		SUBJECT_NAME AS '����������',
		PULPIT AS '�������'
	FROM SUBJECT
	;
	RETURN @LinesCount;
END;
GO

DECLARE @Count int;
EXEC @Count = PSUBJECT;
PRINT '���������� ���������: ' + cast(@Count AS char(5));


-- ������� �2
USE [UNIVER]
GO
/****** Object:  StoredProcedure [dbo].[PSUBJECT]    Script Date: 22.12.2023 0:10:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[PSUBJECT] 
	@p varchar(20) = NULL, 
	@c int output
AS BEGIN
	PRINT '������� ���������: @p=' + @p + ', @c=' + cast(@c AS varchar(5));
	DECLARE @LinesCount int = (SELECT COUNT(*) FROM SUBJECT);
	SELECT
		SUBJECT AS '���',
		SUBJECT_NAME AS '����������',
		PULPIT AS '�������'
	FROM SUBJECT
	WHERE PULPIT = @p
	;
	SET @c = @@ROWCOUNT;
	RETURN @LinesCount;
END;
Go

DECLARE @FullCount int, @Count int, @Pulpit varchar(20) = '����';
EXEC @FullCount = PSUBJECT @p = @Pulpit, @c = @Count output;
PRINT '���������� ���������: ' + cast(@FullCount AS varchar(5));
PRINT '���������� ��������� � �������������� ������: ' + cast(@Count AS varchar(5));
GO


-- ������� �3
DROP TABLE #SUBJECT;
GO

CREATE TABLE #SUBJECT (
	Code char(10),
	Name varchar(100),
	Pulpit char(20)
);
GO

ALTER PROCEDURE PSUBJECT 
	@p varchar(20)
AS BEGIN
	PRINT '������� ���������: @p=' + @p;
	DECLARE @LinesCount int = (SELECT COUNT(*) FROM SUBJECT);
	SELECT
		SUBJECT AS '���',
		SUBJECT_NAME AS '����������',
		PULPIT AS '�������'
	FROM SUBJECT
	WHERE PULPIT = @p
	;
	RETURN @LinesCount;
END;
GO

INSERT #SUBJECT EXEC PSUBJECT @p = '����';
INSERT #SUBJECT EXEC PSUBJECT @p = '�����';
GO

SELECT * FROM #SUBJECT;
GO


-- ������� �4
DROP PROCEDURE PAUDITORIUM_INSERT;
GO

CREATE PROCEDURE PAUDITORIUM_INSERT 
	@a char(20), 
	@n varchar(50), 
	@c int = 0, 
	@t char(10)
AS BEGIN
	BEGIN TRY
		INSERT INTO AUDITORIUM(AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE)
		VALUES (@a, @n, @c, @t);
		RETURN 1;
	END TRY
	BEGIN CATCH
		PRINT '��������� ������ #' + cast(ERROR_NUMBER() AS varchar(10)) + ' � ������� ����������� ' + cast(ERROR_SEVERITY() AS varchar(10)) + ': ' + ERROR_MESSAGE();
		RETURN -1;
	END CATCH
END;
GO

DECLARE @State int;
EXEC @State = PAUDITORIUM_INSERT @a='200-3a-test', @n='200-3a-test', @t=111;
PRINT '������������ ��������: ' + cast(@State AS varchar(5));
EXEC @State = PAUDITORIUM_INSERT @a='200-3a-test', @n='200-3a-test', @c=100, @t='��-�';
PRINT '������������ ��������: ' + cast(@State AS varchar(5));
GO

SELECT * FROM AUDITORIUM;
DELETE FROM AUDITORIUM WHERE AUDITORIUM LIKE '%-test';
GO


-- ������� �5
DROP PROCEDURE SUBJECT_REPORT;
GO

CREATE PROCEDURE SUBJECT_REPORT
	@p char(10)
AS BEGIN
	DECLARE @Pulpit varchar(20) = (SELECT PULPIT FROM PULPIT WHERE PULPIT = @p);
	IF (@Pulpit IS NULL) OR (LEN(@Pulpit) < 1) BEGIN
		;THROW 51000, '������ � ����������', 1;
		RETURN -1;
	END
	ELSE BEGIN
		DECLARE @RowCount int = (
			SELECT COUNT(*) 
			FROM SUBJECT 
			WHERE PULPIT = @Pulpit
		);
		DECLARE @Subjects varchar(200) = (
			SELECT STRING_AGG(LTRIM(RTRIM(SUBJECT)), ', ')
			FROM SUBJECT
			WHERE PULPIT = @Pulpit
		);
		PRINT '������ ��������� �� ������� ' + LTRIM(RTRIM(@Pulpit)) + ': ' + @Subjects;
		RETURN @RowCount;
	END
END;
GO

DECLARE @Count int;
EXEC @Count = SUBJECT_REPORT @p='����';
PRINT '���������� ��������� � ������: ' + cast(@Count AS varchar(5));
GO


-- ������� �6
DROP PROCEDURE PAUDITORIUM_INSERTX;
GO

CREATE PROCEDURE PAUDITORIUM_INSERTX
	@a char(20), 
	@n varchar(50), 
	@c int = 0, 
	@t char(10),
	@tn varchar(50)
AS BEGIN
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
		BEGIN TRAN;
		INSERT INTO AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
		VALUES (@t, @tn);
		DECLARE @Return int;
		EXEC @Return = PAUDITORIUM_INSERT @a, @n, @c, @t;
		IF @Return = -1
			ROLLBACK TRAN;
		ELSE
			COMMIT TRAN;
		RETURN @Return;
	END TRY
	BEGIN CATCH
		PRINT '����� ������  : ' + cast(error_number() as varchar(6));
		PRINT '���������     : ' + error_message();
		PRINT '�������       : ' + cast(error_severity()  as varchar(6));
		PRINT '�����         : ' + cast(error_state()   as varchar(8));
		PRINT '����� ������  : ' + cast(error_line()  as varchar(8));
		IF error_procedure() IS NOT NULL   
			PRINT '��� ��������� : ' + error_procedure();
		if @@trancount > 0 
			ROLLBACK TRAN; 
		RETURN -1;
	END CATCH
END;
GO

DECLARE @State int;
EXEC @State = PAUDITORIUM_INSERTX @a='200-3a-test', @n='200-3a-test', @t=111, @tn='Some type';
PRINT '������������ ��������: ' + cast(@State AS varchar(5));
EXEC @State = PAUDITORIUM_INSERTX @a='200-3a-test', @n='200-3a-test', @c=100, @t='t-test', @tn='Some type';
PRINT '������������ ��������: ' + cast(@State AS varchar(5));
EXEC @State = PAUDITORIUM_INSERTX @a='200-3a-test', @n='200-3a-test', @c=100, @t='��-�', @tn='Some type';
PRINT '������������ ��������: ' + cast(@State AS varchar(5));
GO

SELECT * FROM AUDITORIUM;
SELECT * FROM AUDITORIUM_TYPE;
DELETE FROM AUDITORIUM WHERE AUDITORIUM LIKE '%-test';
DELETE FROM AUDITORIUM_TYPE WHERE AUDITORIUM_TYPE LIKE '%-test';
GO


-- ������� �8*
DROP PROCEDURE PRINT_REPORT;
GO

CREATE PROCEDURE PRINT_REPORT
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
		WHERE
			(f.FACULTY LIKE @f OR @f IS NULL)
			AND (p.PULPIT LIKE @p OR @p IS NULL)
		GROUP BY
			f.FACULTY,
			p.PULPIT
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
		PRINT '		����������: ' + ISNULL(@Subjects, '���') + '.';
		FETCH ReportCursor INTO @Faculty, @Pulpit, @TeacherCount, @Subjects;
	END
	RETURN @PulpitCount;
END;
GO

DECLARE @Ret int;
EXEC @Ret = PRINT_REPORT @f='��', @p='����';
PRINT '���������� ������ � ������: ' + cast(@Ret AS varchar(5));
EXEC @Ret = PRINT_REPORT @f='���';
PRINT '���������� ������ � ������: ' + cast(@Ret AS varchar(5));
EXEC @Ret = PRINT_REPORT @p='��';
PRINT '���������� ������ � ������: ' + cast(@Ret AS varchar(5));
EXEC @Ret = PRINT_REPORT @p='��';
PRINT '���������� ������ � ������: ' + cast(@Ret AS varchar(5));
GO
