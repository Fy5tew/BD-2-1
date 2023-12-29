USE T_MyBase2;
GO


DROP TRIGGER TR_EQUIPMENT_INS;
GO

CREATE TRIGGER TR_EQUIPMENT_INS
ON Equipment AFTER INSERT
AS BEGIN
	PRINT 'TR_EQUIPMENT_INS is called';
END
GO


DROP TRIGGER TR_EQUIPMENT_DEL;
GO

CREATE TRIGGER TR_EQUIPMENT_DEL
ON Equipment AFTER DELETE
AS BEGIN
	PRINT 'TR_EQUIPMENT_DEL is called';
END
GO


DROP TRIGGER TR_EQUIPMENT_UPD;
GO

CREATE TRIGGER TR_EQUIPMENT_UPD
ON Equipment AFTER INSERT
AS BEGIN
	PRINT 'TR_EQUIPMENT_UPD is called';
END
GO


DROP TRIGGER TR_EQUIPMENT;
GO

CREATE TRIGGER TR_EQUIPMENT
ON Equipment AFTER INSERT, UPDATE, DELETE
AS BEGIN
	PRINT 'TR_EQUIPMENT is called';
END
GO


BEGIN TRAN;
SET NOCOUNT ON;
INSERT INTO Equipment(ID, Name, Type)
VALUES (100, 'Test1', 'Test1');
INSERT INTO Equipment(ID, Name, Type)
VALUES (101, 'Test2', 'Test2');
INSERT INTO Equipment(ID, Name, Type)
VALUES (102, 'Test3', 'Test3');
UPDATE Equipment
SET Name = 'Test Test'
WHERE ID = 101;
UPDATE Equipment
SET Name = 'Test Test 1'
WHERE ID = 100;
UPDATE Equipment
SET Name = 'Test Test 5'
WHERE ID = 102;
DELETE FROM Equipment WHERE ID = 101;
DELETE FROM Equipment WHERE ID = 100;
DELETE FROM Equipment WHERE ID = 102;
SET NOCOUNT OFF;
ROLLBACK TRAN;
GO
