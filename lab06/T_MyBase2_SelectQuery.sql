USE T_MyBase2;
GO


SELECT 
	Equipment.Name,
	AVG(Arrival.Quantity) AS '�������',
	MIN(Arrival.Quantity) AS '�����������',
	MAX(Arrival.Quantity) AS '������������'
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
			WHEN Arrival.Quantity BETWEEN 1 AND 5 THEN '�� 1 �� 5'
			WHEN Arrival.Quantity BETWEEN 6 AND 9 THEN '�� 6 �� 9'
			ELSE '������ 9'
		END AS '���������� �������',
		COUNT(*) AS '���������� �����������'
	FROM Arrival
	GROUP BY
		CASE
			WHEN Arrival.Quantity BETWEEN 1 AND 5 THEN '�� 1 �� 5'
			WHEN Arrival.Quantity BETWEEN 6 AND 9 THEN '�� 6 �� 9'
			ELSE '������ 9'
		END
) AS T
ORDER BY
	CASE T.[���������� �������]
		WHEN '�� 1 �� 5' THEN 2
		WHEN '�� 6 �� 9' THEN 1
		ELSE 0
	END
;


SELECT
	Arrival.InstallationDepartment,
	ROUND(AVG(CAST(Arrival.Quantity AS float(5))), 2) AS '������� ����������'
FROM Arrival
GROUP BY Arrival.InstallationDepartment
ORDER BY '������� ����������' DESC
;


SELECT
	Arrival.Quantity,
	COUNT(*) AS '���������� �����������'
FROM Arrival
WHERE Arrival.Quantity BETWEEN 3 AND 8
GROUP BY Arrival.Quantity
HAVING COUNT(*) > 0
ORDER BY Arrival.Quantity DESC
;
