USE T_MyBase2;
GO


SET IMPLICIT_TRANSACTIONS ON
INSERT INTO Equipment(ID, Name, Type)
VALUES (100, 'Test1', 'Test1'),
		(101, 'Test2', 'Test2'),
		(102, 'Test3', 'Test3')
;
SELECT * FROM Equipment;
ROLLBACK
SELECT * FROM Equipment;
SET IMPLICIT_TRANSACTIONS OFF


BEGIN TRAN
INSERT INTO Equipment(ID, Name, Type)
VALUES (100, 'Test1', 'Test1'),
		(101, 'Test2', 'Test2'),
		(102, 'Test3', 'Test3')
;
SELECT * FROM Equipment;
ROLLBACK
SELECT * FROM Equipment;


BEGIN TRY
	INSERT INTO Equipment(ID, Name, Type)
	VALUES (1, 'Test1', 'Test1'),
			(2, 'Test2', 'Test2'),
			(3, 'Test3', 'Test3')
	;
	SELECT * FROM Equipment;
	COMMIT
END TRY
BEGIN CATCH
	PRINT 'Ошибка с кодом: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10)) + ', сообщение об ошибке: ' + ERROR_MESSAGE();
	IF @@TRANCOUNT > 0 ROLLBACK;
END CATCH
SELECT * FROM Equipment;
