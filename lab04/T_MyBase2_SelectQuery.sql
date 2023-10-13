USE T_MyBase2;
GO


-- 7.1
SELECT 
	Arrival.ID,
	Equipment.Name,
	Equipment.Type,
	Arrival.ArrivalDate,
	Arrival.Quantity,
	Arrival.InstallationDepartment,
	Worker.LastName,
	Worker.FirstName,
	Worker.Patronymic
FROM 
	Arrival
	INNER JOIN Equipment ON Arrival.Equipment = Equipment.ID
	INNER JOIN Worker ON Arrival.Responsible = Worker.ID
;


-- 7.2
SELECT 
	Arrival.ID,
	Equipment.Name,
	Equipment.Type,
	Arrival.ArrivalDate,
	Arrival.Quantity,
	Arrival.InstallationDepartment
FROM Arrival INNER JOIN Equipment ON Arrival.Equipment = Equipment.ID
WHERE Equipment.Name LIKE '%ноутбук%';


-- 7.3
SELECT 
	Equipment.Name,
	Equipment.Type,
	Arrival.Quantity AS 'Arrival Quantity',
	Arrival.ArrivalDate,
	WriteOff.Quantity AS 'WriteOff Quantity',
	CASE 
		WHEN (WriteOff.Quantity = 1) THEN 'Одно'
		ELSE 'Несколько'
	END 'WriteOff count',
	WriteOff.WriteOffDate,
	WriteOff.Reason AS 'WriteOff Reason',
	Arrival.InstallationDepartment,
	Worker.LastName + ' ' + Worker.FirstName + ' ' + Worker.Patronymic AS 'WriteOff Responsible'
FROM
	WriteOff
	INNER JOIN Worker ON WriteOff.Responsible = Worker.ID
	INNER JOIN Arrival ON WriteOff.Arrival = Arrival.ID
	INNER JOIN Equipment ON Arrival.Equipment = Equipment.ID
WHERE 
	Arrival.Quantity BETWEEN 3 AND 7
ORDER BY WriteOff.Quantity DESC
;


-- 7.4
SELECT 
	Arrival.ID AS 'Поступление',
	isnull(cast(WriteOff.ID AS nvarchar(10)), 'Без списаний') AS 'Списание'
FROM 
	Arrival LEFT OUTER JOIN WriteOff ON WriteOff.ID = Arrival.ID
;