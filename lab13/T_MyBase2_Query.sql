USE T_MyBase2;
GO


DROP PROCEDURE PArrival;
GO

CREATE PROCEDURE PArrival
AS BEGIN
	SELECT 
		Equipment AS 'ИД товара',
		InstallationDepartment AS 'Отдел'
	FROM Arrival
	;
END;
GO

EXEC PArrival;
GO


DROP PROCEDURE PWriteOff;
GO

CREATE PROCEDURE PWriteOff
AS BEGIN
	SELECT 
		ID AS 'ИД',
		Reason AS 'Причина'
	FROM WriteOff
	;
END;
GO

EXEC PWriteOff;
GO


DROP PROCEDURE PEquipment;
GO

CREATE PROCEDURE PEquipment
AS BEGIN
	SELECT 
		Name AS 'Название',
		Type AS 'Тип'
	FROM Equipment
	;
END;
GO

EXEC PEquipment;
GO