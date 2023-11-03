USE UNIVER;
GO

-- ������� �6
SELECT
	CASE
		WHEN PROGRESS.NOTE < 4 THEN '�����'
		WHEN PROGRESS.NOTE BETWEEN 4 AND 5 THEN '�����������������'
		WHEN PROGRESS.NOTE BETWEEN 6 AND 7 THEN '���������'
		WHEN PROGRESS.NOTE BETWEEN 8 AND 10 THEN '�������'
		ELSE CAST(PROGRESS.NOTE AS varchar(3))
	END AS '������',
	COUNT(*) AS '����������'
FROM 
	PROGRESS
	INNER JOIN STUDENT ON STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
	INNER JOIN GROUPS ON GROUPS.IDGROUP = STUDENT.IDGROUP
	INNER JOIN FACULTY ON FACULTY.FACULTY = GROUPS.FACULTY
WHERE
	FACULTY.FACULTY = '��'
GROUP BY
	CASE
		WHEN PROGRESS.NOTE < 4 THEN '�����'
		WHEN PROGRESS.NOTE BETWEEN 4 AND 5 THEN '�����������������'
		WHEN PROGRESS.NOTE BETWEEN 6 AND 7 THEN '���������'
		WHEN PROGRESS.NOTE BETWEEN 8 AND 10 THEN '�������'
		ELSE CAST(PROGRESS.NOTE AS varchar(3))
	END
ORDER BY '����������' ASC
;
