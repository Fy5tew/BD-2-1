USE UNIVER;
GO

SET NOCOUNT ON;
GO


CREATE TABLE TR_AUDIT (
	ID int identity,	-- номер
	STMT varchar(20)	-- DML-оператор
		check (STMT in ('INS', 'DEL', 'UPD')),
	TRNAME varchar(50),	-- имя триггера
	CC varchar(300)		-- комментарий
);
GO


-- Задание №1
CREATE TRIGGER TR_TEACHER_INS
ON TEACHER AFTER INSERT
AS BEGIN
	DECLARE @Record varchar(300);
	DECLARE RecordCursor CURSOR LOCAL FOR
		SELECT RTRIM(LTRIM(TEACHER)) + ' ' + TEACHER_NAME + ' ' + GENDER + ' ' + RTRIM(LTRIM(PULPIT))
		FROM inserted;
	;
	OPEN RecordCursor;
	FETCH RecordCursor INTO @Record;
	WHILE @@FETCH_STATUS = 0 BEGIN
		INSERT INTO TR_AUDIT(STMT, TRNAME, CC)
		VALUES
			('INS', 'TR_TEACHER_INS', @Record)
		;
		FETCH RecordCursor INTO @Record;
	END
END;
GO

-- Задание №2
CREATE TRIGGER TR_TEACHER_DEL
ON TEACHER AFTER DELETE
AS BEGIN
	DECLARE @Record varchar(300);
	DECLARE RecordCursor CURSOR LOCAL FOR
		SELECT RTRIM(LTRIM(TEACHER)) + ' ' + TEACHER_NAME + ' ' + GENDER + ' ' + RTRIM(LTRIM(PULPIT))
		FROM deleted;
	;
	OPEN RecordCursor;
	FETCH RecordCursor INTO @Record;
	WHILE @@FETCH_STATUS = 0 BEGIN
		INSERT INTO TR_AUDIT(STMT, TRNAME, CC)
		VALUES
			('DEL', 'TR_TEACHER_DEL', @Record)
		;
		FETCH RecordCursor INTO @Record;
	END
END;
GO


-- Задание №3
CREATE TRIGGER TR_TEACHER_UPD
ON TEACHER AFTER UPDATE
AS BEGIN
	DECLARE @Record varchar(300);
	DECLARE RecordCursor CURSOR LOCAL FOR
		SELECT 
			RTRIM(LTRIM(del.TEACHER)) + ' ' + del.TEACHER_NAME + ' ' + del.GENDER + ' ' + RTRIM(LTRIM(del.PULPIT))
			+ ' => ' +
			RTRIM(LTRIM(ins.TEACHER)) + ' ' + ins.TEACHER_NAME + ' ' + ins.GENDER + ' ' + RTRIM(LTRIM(ins.PULPIT))
		FROM 
			deleted AS del
			INNER JOIN inserted AS ins ON ins.TEACHER = del.TEACHER
	;
	OPEN RecordCursor;
	FETCH RecordCursor INTO @Record;
	WHILE @@FETCH_STATUS = 0 BEGIN
		INSERT INTO TR_AUDIT(STMT, TRNAME, CC)
		VALUES
			('UPD', 'TR_TEACHER_UPD', @Record)
		;
		FETCH RecordCursor INTO @Record;
	END
END;
GO


-- Задание №4
CREATE TRIGGER TR_TEACHER
ON TEACHER AFTER INSERT, UPDATE, DELETE
AS BEGIN
	DECLARE
		@Record varchar(300),
		@EventType char(3),
		@InsCount int = (SELECT COUNT(*) FROM inserted),
		@DelCount int = (SELECT COUNT(*) FROM deleted)
	;

	IF @InsCount > 0 AND @DelCount = 0 BEGIN 
		SET @EventType = 'INS';
		DECLARE RecordCursor CURSOR LOCAL FOR
			SELECT RTRIM(LTRIM(TEACHER)) + ' ' + TEACHER_NAME + ' ' + GENDER + ' ' + RTRIM(LTRIM(PULPIT))
			FROM inserted;
		;
	END
	ELSE IF @InsCount = 0 AND @DelCount > 0 BEGIN
		SET @EventType = 'DEL';
		DECLARE RecordCursor CURSOR LOCAL FOR
			SELECT RTRIM(LTRIM(TEACHER)) + ' ' + TEACHER_NAME + ' ' + GENDER + ' ' + RTRIM(LTRIM(PULPIT))
			FROM deleted;
		;
	END
	ELSE BEGIN
		SET @EventType = 'UPD';
		DECLARE RecordCursor CURSOR LOCAL FOR
			SELECT 
				RTRIM(LTRIM(del.TEACHER)) + ' ' + del.TEACHER_NAME + ' ' + del.GENDER + ' ' + RTRIM(LTRIM(del.PULPIT))
				+ ' => ' +
				RTRIM(LTRIM(ins.TEACHER)) + ' ' + ins.TEACHER_NAME + ' ' + ins.GENDER + ' ' + RTRIM(LTRIM(ins.PULPIT))
			FROM 
				deleted AS del
				INNER JOIN inserted AS ins ON ins.TEACHER = del.TEACHER
		;
	END

	OPEN RecordCursor;
	FETCH RecordCursor INTO @Record;
	WHILE @@FETCH_STATUS = 0 BEGIN
		INSERT INTO TR_AUDIT(STMT, TRNAME, CC)
		VALUES
			(@EventType, 'TR_TEACHER', @Record)
		;
		FETCH RecordCursor INTO @Record;
	END
END;
GO


-- Задание №6
CREATE TRIGGER TR_TEACHER_DEL1
ON TEACHER AFTER DELETE
AS BEGIN
	DECLARE @Record varchar(300);
	DECLARE RecordCursor CURSOR LOCAL FOR
		SELECT RTRIM(LTRIM(TEACHER)) + ' ' + TEACHER_NAME + ' ' + GENDER + ' ' + RTRIM(LTRIM(PULPIT))
		FROM deleted;
	;
	OPEN RecordCursor;
	FETCH RecordCursor INTO @Record;
	WHILE @@FETCH_STATUS = 0 BEGIN
		INSERT INTO TR_AUDIT(STMT, TRNAME, CC)
		VALUES
			('DEL', 'TR_TEACHER_DEL1', @Record)
		;
		FETCH RecordCursor INTO @Record;
	END
END;
GO

CREATE TRIGGER TR_TEACHER_DEL2
ON TEACHER AFTER DELETE
AS BEGIN
	DECLARE @Record varchar(300);
	DECLARE RecordCursor CURSOR LOCAL FOR
		SELECT RTRIM(LTRIM(TEACHER)) + ' ' + TEACHER_NAME + ' ' + GENDER + ' ' + RTRIM(LTRIM(PULPIT))
		FROM deleted;
	;
	OPEN RecordCursor;
	FETCH RecordCursor INTO @Record;
	WHILE @@FETCH_STATUS = 0 BEGIN
		INSERT INTO TR_AUDIT(STMT, TRNAME, CC)
		VALUES
			('DEL', 'TR_TEACHER_DEL2', @Record)
		;
		FETCH RecordCursor INTO @Record;
	END
END;
GO

CREATE TRIGGER TR_TEACHER_DEL3
ON TEACHER AFTER DELETE
AS BEGIN
	DECLARE @Record varchar(300);
	DECLARE RecordCursor CURSOR LOCAL FOR
		SELECT RTRIM(LTRIM(TEACHER)) + ' ' + TEACHER_NAME + ' ' + GENDER + ' ' + RTRIM(LTRIM(PULPIT))
		FROM deleted;
	;
	OPEN RecordCursor;
	FETCH RecordCursor INTO @Record;
	WHILE @@FETCH_STATUS = 0 BEGIN
		INSERT INTO TR_AUDIT(STMT, TRNAME, CC)
		VALUES
			('DEL', 'TR_TEACHER_DEL3', @Record)
		;
		FETCH RecordCursor INTO @Record;
	END
END;
GO

SELECT
	t.name, e.type_desc
FROM
	sys.triggers t JOIN sys.trigger_events e
	ON t.object_id = e.object_id
WHERE
	OBJECT_NAME(t.parent_id) = 'TEACHER'
;

EXEC sp_settriggerorder @triggername='TR_TEACHER_DEL3', @order='First', @stmttype='DELETE';
EXEC sp_settriggerorder @triggername='TR_TEACHER_DEL2', @order='Last', @stmttype='DELETE';

SELECT
	t.name, e.type_desc
FROM
	sys.triggers t JOIN sys.trigger_events e
	ON t.object_id = e.object_id
WHERE
	OBJECT_NAME(t.parent_id) = 'TEACHER'
	AND e.type_desc = 'DELETE'
;
GO


-- Изменение таблицы TEACHER
INSERT INTO TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT)
VALUES 
	('TTT1', 'Test Test Test', 'м', 'ИСиТ'),
	('TTT2', 'Test Test Test', 'м', 'ИСиТ')
;

INSERT INTO TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT)
VALUES 
	('TTT3', 'Test Test Test', 'м', 'ИСиТ'),
	('TTT4', 'Test Test Test', 'м', 'ИСиТ')
;

UPDATE TEACHER
SET GENDER = 'ж'
WHERE TEACHER IN ('TTT1', 'TTT4')
;

BEGIN TRY -- Задание №5
	INSERT INTO TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT)
	VALUES ('TTT5', 'Test Test Test', 'т', 'ИСиТ');
END TRY
BEGIN CATCH
	PRINT 'INSERT ERROR';
	SELECT * FROM TR_AUDIT WHERE CC LIKE 'TTT5%';
END CATCH

BEGIN TRAN -- Задание №7
INSERT INTO TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT)
VALUES ('TTT6', 'Test Test Test', 'м', 'ИСиТ');
SELECT * FROM TR_AUDIT WHERE CC LIKE 'TTT6%';
ROLLBACK TRAN
SELECT * FROM TR_AUDIT WHERE CC LIKE 'TTT6%';

DELETE FROM TEACHER WHERE TEACHER LIKE 'TTT%';

SELECT * FROM TR_AUDIT;
GO


-- Задание №8
CREATE TRIGGER TR_FACULTY_NODEL
ON FACULTY INSTEAD OF DELETE
AS BEGIN
	raiserror('Удаление запрещено', 10, 1);
END;
GO

DELETE FROM FACULTY WHERE FACULTY = 'ИТ';
GO


-- Задание №9
CREATE TRIGGER DDL_UNIVER
ON DATABASE FOR DDL_DATABASE_LEVEL_EVENTS
AS BEGIN
	DECLARE 
		@EventType varchar(50) =  EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)'),
		@ObjectName varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)'),
		@ObjectType varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)')
	;
	IF @ObjectType = 'TABLE' AND @EventType IN ('CREATE_TABLE', 'DROP_TABLE') BEGIN
		PRINT 'Тип события: ' + @EventType;
		PRINT 'Имя объекта: ' + @ObjectName;
		PRINT 'Тип объекта: ' + @ObjectType;
		raiserror('Создание и удаление таблиц в БД запрещено', 16, 1);
		ROLLBACK;
	END
END;
GO

CREATE TABLE Test (
	ID int primary key
);
GO

DROP TABLE PROGRESS;
GO

DROP TRIGGER DDL_UNIVER ON DATABASE;


-- Задание №11*
CREATE TABLE WEATHER(
	ID int identity,
	City nvarchar(20),
	StartDate datetime,
	EndDate datetime,
	Temperature int
);
GO

CREATE TRIGGER TR_CHECK
ON WEATHER AFTER INSERT, UPDATE
AS BEGIN
	DECLARE
		@ID				int,
		@City			nvarchar(20),
		@StartDate		datetime,
		@EndDate		datetime,
		@Temperature	int
	;
	DECLARE InsertedCursor CURSOR LOCAL FOR
		SELECT * FROM inserted
	;
	OPEN InsertedCursor;
	FETCH InsertedCursor INTO @ID, @City, @StartDate, @EndDate, @Temperature;
	WHILE @@FETCH_STATUS = 0 BEGIN
		IF (@StartDate > @EndDate) BEGIN
			raiserror('Invalid date period', 10, 1);
			ROLLBACK;
			RETURN;
		END
		DECLARE @ConflictsCount int = (
			SELECT COUNT(*)
			FROM WEATHER
			WHERE ID <> @ID AND City = @City AND (
				(StartDate = @StartDate)
				OR (EndDate = @EndDate)
				OR (StartDate > @StartDate AND StartDate < @EndDate)
				OR (EndDate > @StartDate)
			)
		);
		IF @ConflictsCount <> 0 BEGIN
			DECLARE @Message varchar(100) = 'This operation has ' + cast(@ConflictsCount as varchar(5)) + ' conflicts';
			raiserror(@Message, 11, 1);
			ROLLBACK;
			RETURN;
		END
		FETCH InsertedCursor INTO @ID, @City, @StartDate, @EndDate, @Temperature;
	END
END
GO

INSERT INTO WEATHER(City, StartDate, EndDate, Temperature)
VALUES ('Минск', '01.01.2022 00:00', '01.01.2022 23:59', -6);
GO
INSERT INTO WEATHER(City, StartDate, EndDate, Temperature)
VALUES ('Минск', '01.01.2022 00:00', '01.01.2022 23:59', -2);
GO
SELECT * FROM WEATHER;
GO


-- Удаление триггеров и таблиц
DROP TRIGGER TR_TEACHER_INS;
DROP TRIGGER TR_TEACHER_DEL;
DROP TRIGGER TR_TEACHER_UPD;
DROP TRIGGER TR_TEACHER;
DROP TRIGGER TR_TEACHER_DEL1;
DROP TRIGGER TR_TEACHER_DEL2;
DROP TRIGGER TR_TEACHER_DEL3;
DROP TRIGGER TR_FACULTY_NODEL;
GO
DROP TABLE TR_AUDIT;
DROP TABLE WEATHER;
GO


SET NOCOUNT OFF;
GO
