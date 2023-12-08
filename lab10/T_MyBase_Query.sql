USE T_MyBase2;
GO


CREATE INDEX #Worker_EmplDate ON Worker(EmploymentDate);
GO

DROP INDEX #Worker_EmplDate ON Worker;
GO

SELECT * FROM Worker
WHERE EmploymentDate > '2021-01-18'
ORDER BY EmploymentDate;
GO


CREATE INDEX #Equipment_Type ON Equipment(Type) INCLUDE (ID, Name);
GO

DROP INDEX #Equipment_Type ON Equipment;
GO

SELECT * FROM Equipment
WHERE Type = 'Аксессуар';
GO


CREATE INDEX #Arrival_Q ON Arrival(Quantity) INCLUDE (Equipment);
GO

DROP INDEX #Arrival_Q ON Arrival;
GO

SELECT Equipment, Quantity FROM Arrival
WHERE Quantity > 5;
GO
