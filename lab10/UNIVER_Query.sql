USE UNIVER;
GO


-- Задание №1
exec SP_HELPINDEX 'FACULTY';
exec SP_HELPINDEX 'PULPIT';
exec SP_HELPINDEX 'GROUPS';
exec SP_HELPINDEX 'PROFESSION';
exec SP_HELPINDEX 'STUDENT';
exec SP_HELPINDEX 'TEACHER';
exec SP_HELPINDEX 'SUBJECT';
exec SP_HELPINDEX 'AUDITORIUM_TYPE';
exec SP_HELPINDEX 'AUDITORIUM';
exec SP_HELPINDEX 'PROGRESS';
GO

DROP TABLE #TempTable1;
GO

CREATE TABLE #TempTable1 (
	ID int,
	SomeData int
);
GO

DECLARE @Counter int = 0;
WHILE (@Counter < 100000)
BEGIN
	INSERT INTO #TempTable1(ID, SomeData)
	VALUES(@Counter, FLOOR(10000 * RAND()));
	SET @Counter = @Counter + 1;
END
GO

checkpoint;
DBCC DROPCLEANBUFFERS;
CREATE CLUSTERED INDEX #TempTable1_CL ON #TempTable1(SomeData asc);
GO

DROP INDEX #TempTable1_CL ON #TempTable1;
GO

SELECT * FROM #TempTable1 WHERE SomeData BETWEEN 2500 AND 5000;
GO


-- Задание №2
DROP TABLE #TempTable2;
GO

CREATE TABLE #TempTable2 (
	SomeData1 int,
	SomeData2 int
);
GO

DECLARE @Counter int = 0;
WHILE (@Counter < 100000)
BEGIN
	INSERT INTO #TempTable2(SomeData1, SomeData2)
	VALUES (FLOOR(10000 * RAND()), FLOOR(10000 * RAND()));
	SET @Counter = @Counter + 1;
END
GO

checkpoint;
DBCC DROPCLEANBUFFERS;
CREATE NONCLUSTERED INDEX #TempTable2_NOCL ON #TempTable2(SomeData1, SomeData2);
GO

DROP INDEX #TempTable2_NOCL ON #TempTable2;
GO

SELECT * 
FROM #TempTable2
WHERE
	SomeData1 BETWEEN 3000 AND 5000
	AND SomeData2 BETWEEN 1000 AND 2500
;
SELECT *
FROM #TempTable2
ORDER BY SomeData1, SomeData2
;
SELECT *
FROM #TempTable2
WHERE SomeData1 = 1895 AND SomeData2 > 3000
;
GO


-- Задание №3
DROP TABLE #TempTable3;
GO

CREATE TABLE #TempTable3 (
	ID int,
	SomeData int
);
GO

DECLARE @Counter int = 0;
WHILE (@Counter < 100000)
BEGIN
	INSERT INTO #TempTable3(ID, SomeData)
	VALUES (@Counter, FLOOR(10000 * RAND()));
	SET @Counter = @Counter + 1;
END
GO

checkpoint;
DBCC DROPCLEANBUFFERS;
CREATE INDEX #TempTable3_INC ON #TempTable3(ID) INCLUDE (SomeData);
GO

DROP INDEX #TempTable3_INC ON #TempTable3;
GO

SELECT SomeData FROM #TempTable3 WHERE ID > 5000 AND ID < 10000;
GO


-- Задание №4
DROP TABLE #TempTable4;
GO

CREATE TABLE #TempTable4 (
	ID int
);
GO

DECLARE @Counter int = 0;
WHILE (@Counter < 100000)
BEGIN
	INSERT INTO #TempTable4(ID)
	VALUES (@Counter);
	SET @Counter = @Counter + 1;
END
GO

checkpoint;
DBCC DROPCLEANBUFFERS;
CREATE INDEX #TempTable4_FILTER ON #TempTable4(ID) WHERE (ID >= 5000 AND ID <= 25000);
GO

DROP INDEX #TempTable4_FILTER ON #TempTable4;
GO

SELECT * FROM #TempTable4 WHERE ID BETWEEN 10000 AND 15000;
GO


-- Задание №5
DROP TABLE #TempTable5;
GO

CREATE TABLE #TempTable5 (
	ID int,
	SomeData int
);
GO

DECLARE @Counter int = 0;
WHILE (@Counter < 1000)
BEGIN
	INSERT INTO #TempTable5(ID, SomeData)
	VALUES (@Counter, FLOOR(10000 * RAND()));
	SET @Counter = @Counter + 1;
END
GO

checkpoint;
DBCC DROPCLEANBUFFERS;
CREATE INDEX #TempTable5_NONCL ON #TempTable5(ID, SomeData);
GO

DROP INDEX #TempTable5_NONCL ON #TempTable5;
GO

USE tempdb;
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
FROM 
	sys.dm_db_index_physical_stats(
		DB_ID(N'TEMPDB'), 
		OBJECT_ID(N'#TempTable5'), NULL, NULL, NULL
	) ss  
	JOIN sys.indexes ii ON ss.object_id = ii.object_id and ss.index_id = ii.index_id 
WHERE name is not null;
GO

INSERT top(100000) #TempTable5(ID, SomeData) SELECT ID, SomeData FROM #TempTable5;
GO

ALTER INDEX #TempTable5_NONCL ON #TempTable5 REORGANIZE;
GO

ALTER INDEX #TempTable5_NONCL ON #TempTable5 REBUILD WITH (online = off);
GO


-- Задание №6
DROP TABLE #TempTable6;
GO

CREATE TABLE #TempTable6 (
	ID int,
	SomeData int
);
GO

DECLARE @Counter int = 0;
WHILE (@Counter < 1000)
BEGIN
	INSERT INTO #TempTable6(ID, SomeData)
	VALUES (@Counter, FLOOR(10000 * RAND()));
	SET @Counter = @Counter + 1;
END
GO

checkpoint;
DBCC DROPCLEANBUFFERS;
CREATE INDEX #TempTable6_NONCL ON #TempTable6(ID, SomeData) WITH (fillfactor = 65);
GO

DROP INDEX #TempTable6_NONCL ON #TempTable6;
GO

USE tempdb;
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
FROM 
	sys.dm_db_index_physical_stats(
		DB_ID(N'TEMPDB'), 
		OBJECT_ID(N'#TempTable5'), NULL, NULL, NULL
	) ss  
	JOIN sys.indexes ii ON ss.object_id = ii.object_id and ss.index_id = ii.index_id 
WHERE name is not null;
GO

INSERT top(100000) #TempTable6(ID, SomeData) SELECT ID, SomeData FROM #TempTable6;
GO
