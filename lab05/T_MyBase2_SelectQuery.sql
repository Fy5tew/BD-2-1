USE T_MyBase2;
GO


SELECT 
	Arrival.ID,
	Equipment.Type,
	Equipment.Name
FROM 
	Arrival, 
	Equipment
WHERE
	Arrival.Equipment = Equipment.ID
	AND Equipment.Type IN (
		SELECT TYPE
		FROM Equipment
		WHERE TYPE LIKE '%ор%'
	)
;


SELECT 
	Arrival.ID,
	Equipment.Type,
	Equipment.Name
FROM 
	Arrival
	INNER JOIN Equipment ON Arrival.Equipment = Equipment.ID
WHERE
	Equipment.Type IN (
		SELECT TYPE
		FROM Equipment
		WHERE TYPE LIKE '%ор%'
	)
;


SELECT 
	Arrival.ID,
	Equipment.Type,
	Equipment.Name
FROM 
	Arrival
	INNER JOIN Equipment ON Arrival.Equipment = Equipment.ID
WHERE
	Equipment.Type LIKE '%ор%'
;


SELECT a.ID
FROM Arrival AS a
WHERE NOT EXISTS (
	SELECT *
	FROM WriteOff as w
	WHERE w.Arrival = a.ID
)
;


SELECT 
	(
		SELECT AVG(Arrival.Quantity)
		FROM Arrival
	) AS 'AVG Arrival',
	(
		SELECT AVG(WriteOff.Quantity)
		FROM WriteOff
	) AS 'AVG WriteOff'
;


SELECT Arrival.ID
FROM Arrival
WHERE Arrival.Quantity >= all(
	SELECT Quantity
	FROM WriteOff
)
;


SELECT Arrival.ID
FROM Arrival
WHERE Arrival.Quantity >= any(
	SELECT Quantity
	FROM WriteOff
)
;
