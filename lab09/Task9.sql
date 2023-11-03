USE UNIVER;
GO


-- ������� �9
BEGIN TRY
	UPDATE PROGRESS 
	SET IDSTUDENT = 9 
	WHERE IDSTUDENT = 1001;
END TRY
BEGIN CATCH
	PRINT 'ERROR_NUMBER: ' + CAST(ERROR_NUMBER() AS varchar(5));
	PRINT 'ERROR_MESSAGE: ' + CAST(ERROR_MESSAGE() AS varchar(500));
	PRINT 'ERROR_LINE: ' + CAST(ERROR_LINE() AS varchar(5));
	PRINT 'ERROR_PROCEDURE: ' + CAST(ERROR_PROCEDURE() AS varchar(15));
	PRINT 'ERROR_SEVERITY: ' + CAST(ERROR_SEVERITY() AS varchar(5));
	PRINT 'ERROR_STATE: ' + CAST(ERROR_STATE() AS varchar(5));
END CATCH
