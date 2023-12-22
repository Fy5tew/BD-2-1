USE T_MyBase2;
GO


DROP PROCEDURE PArrival;
GO

CREATE PROCEDURE PArrival
AS BEGIN
	SELECT 
		Equipment AS '�� ������',
		InstallationDepartment AS '�����'
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
		ID AS '��',
		Reason AS '�������'
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
		Name AS '��������',
		Type AS '���'
	FROM Equipment
	;
END;
GO

EXEC PEquipment;
GO