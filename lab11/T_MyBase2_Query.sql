USE T_MyBase2;
GO


DECLARE
	@LastName nvarchar(30),
	@FirstName nvarchar(30),
	@Patronymic nvarchar(30)
;
DECLARE WorkerCur CURSOR LOCAL DYNAMIC FOR
	SELECT LastName, FirstName, Patronymic FROM Worker
;
OPEN WorkerCur;
FETCH WorkerCur INTO @LastName, @FirstName, @Patronymic;
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @LastName + ' ' + @FirstName + ' ' + @Patronymic;
	FETCH WorkerCur INTO @LastName, @FirstName, @Patronymic;
END
GO


DECLARE
	@Name nvarchar(30),
	@Type nvarchar(30)
;
DECLARE ProductCur CURSOR LOCAL STATIC FOR
	SELECT Name, Type FROM Equipment
;
OPEN ProductCur;
FETCH ProductCur INTO @Name, @Type;
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @Name + ' - ' + @Type;
	FETCH ProductCur INTO @Name, @Type;
END
GO


DECLARE
	@ID int,
	@Eq nvarchar(30)
;
DECLARE ArrivalCur CURSOR LOCAL STATIC SCROLL FOR
	SELECT Arrival.ID, Equipment.Name FROM Arrival INNER JOIN Equipment ON Arrival.Equipment = Equipment.ID ORDER BY Arrival.ID
;
OPEN ArrivalCur;
FETCH FIRST FROM ArrivalCur INTO @ID, @Eq;
PRINT 'Первый: ' + cast(@ID as varchar(5)) + ' ' + @Eq;
FETCH LAST FROM ArrivalCur INTO @ID, @Eq;
PRINT 'Последний: ' + cast(@ID as varchar(5)) + ' ' + @Eq;
FETCH ABSOLUTE 5 FROM ArrivalCur INTO @ID, @Eq;
PRINT 'Пятый: ' + cast(@ID as varchar(5)) + ' ' + @Eq;
GO
