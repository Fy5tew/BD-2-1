USE T_MyBase2;
GO


SELECT
	ID AS 'id',
	LastName AS 'last_name',
	FirstName AS 'first_name',
	Patronymic AS 'patronymic',
	JobTitle AS 'job_title',
	EmploymentDate AS 'employment_date'
FROM Worker
ORDER BY ID
FOR XML RAW('worker'), ROOT('workers'), ELEMENTS
;


SELECT
	ID AS 'id',
	Name AS 'name',
	Type AS 'type'
FROM Equipment
ORDER BY ID
FOR XML AUTO, ROOT('equipments')
;


SELECT
	ID AS 'id',
	Equipment AS 'equipment_id',
	ArrivalDate AS 'arrival_date',
	Quantity AS 'quantity',
	InstallationDepartment AS 'installation_department',
	Responsible AS 'responsible_id'
FROM Arrival
ORDER BY ID
FOR XML PATH('arrival'), ROOT('arrivals')
;


SELECT
	ID AS 'id',
	Arrival AS 'arrival_id',
	Quantity AS 'quantity',
	WriteOffDate AS 'date',
	Reason AS 'reason',
	Responsible AS 'responsible_id'
FROM WriteOff AS [write_off]
ORDER BY ID
FOR XML AUTO, ROOT('write_offs'), ELEMENTS
;
