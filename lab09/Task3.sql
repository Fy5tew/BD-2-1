USE UNIVER;
GO


-- ������� �3
PRINT 'SERVERNAME: ' + CAST(@@SERVERNAME AS varchar(15));
PRINT 'VERSION: ' + CAST(@@VERSION AS varchar(250));
PRINT 'SPID: ' + CAST(@@SPID AS varchar(10));
PRINT 'FETCH_STATUS: ' + CAST(@@FETCH_STATUS AS varchar(5));
PRINT 'TRANCOUNT: ' + CAST(@@TRANCOUNT AS varchar(5));
PRINT 'NESTLEVEL: ' + CAST(@@NESTLEVEL AS varchar(5));
PRINT 'ERROR: ' + CAST(@@ERROR AS varchar(10));
PRINT 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS varchar(5));
GO
