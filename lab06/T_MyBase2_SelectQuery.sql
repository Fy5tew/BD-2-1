USE T_MyBase2;
GO


SELECT 
	Equipment.Name,
	AVG(Arrival.Quantity) AS 'Среднее',
	MIN(Arrival.Quantity) AS 'Минимальное',
	MAX(Arrival.Quantity) AS 'Максимальное'
FROM
	Arrival
	INNER JOIN Equipment ON Arrival.Equipment = Equipment.ID
GROUP BY
	Equipment.Name
ORDER BY Equipment.Name DESC
;


SELECT *
FROM (
	SELECT
		CASE
			WHEN Arrival.Quantity BETWEEN 1 AND 5 THEN 'От 1 до 5'
			WHEN Arrival.Quantity BETWEEN 6 AND 9 THEN 'От 6 до 9'
			ELSE 'Больше 9'
		END AS 'Количество товаров',
		COUNT(*) AS 'Количество поступлений'
	FROM Arrival
	GROUP BY
		CASE
			WHEN Arrival.Quantity BETWEEN 1 AND 5 THEN 'От 1 до 5'
			WHEN Arrival.Quantity BETWEEN 6 AND 9 THEN 'От 6 до 9'
			ELSE 'Больше 9'
		END
) AS T
ORDER BY
	CASE T.[Количество товаров]
		WHEN 'От 1 до 5' THEN 2
		WHEN 'От 6 до 9' THEN 1
		ELSE 0
	END
;


SELECT
	Arrival.InstallationDepartment,
	ROUND(AVG(CAST(Arrival.Quantity AS float(5))), 2) AS 'Среднее количество'
FROM Arrival
GROUP BY Arrival.InstallationDepartment
ORDER BY 'Среднее количество' DESC
;


SELECT
	Arrival.Quantity,
	COUNT(*) AS 'Количество поступлений'
FROM Arrival
WHERE Arrival.Quantity BETWEEN 3 AND 8
GROUP BY Arrival.Quantity
HAVING COUNT(*) > 0
ORDER BY Arrival.Quantity DESC
;
