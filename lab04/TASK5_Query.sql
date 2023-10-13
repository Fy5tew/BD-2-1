USE master;
GO

DROP DATABASE TASK5;
GO

CREATE DATABASE TASK5;
GO

USE TASK5;
Go


CREATE TABLE TABLE1 (
	id int,
	title nvarchar(20),

	CONSTRAINT PK_TABLE1 PRIMARY KEY (id),
);
GO

CREATE TABLE TABLE2 (
	id int,
	description nvarchar(40),

	CONSTRAINT PK_TABLE2 PRIMARY KEY (id),
);
GO


INSERT INTO TABLE1 (id, title)
VALUES
	(1, 'some title1'),
	(2, 'some title2'),
	(3, 'some title3');
GO

INSERT INTO TABLE2 (id, description)
VALUES
	(1, 'some description for some title1'),
	(2, 'some description for some title2'),
	(4, 'some description for some title3');
GO


-- Коммутативность
SELECT title, description FROM TABLE1 FULL OUTER JOIN TABLE2 ON TABLE1.id = TABLE2.id;
SELECT title, description FROM TABLE2 FULL OUTER JOIN TABLE1 ON TABLE1.id = TABLE2.id;

-- 5.1
SELECT title, description
FROM TABLE1 FULL OUTER JOIN TABLE2
ON TABLE1.id = TABLE2.id
WHERE title IS NOT NULL AND description IS NULL;

-- 5.2
SELECT title, description
FROM TABLE1 FULL OUTER JOIN TABLE2
ON TABLE1.id = TABLE2.id
WHERE title IS NULL AND description IS NOT NULL;

-- 5.3
SELECT title, description
FROM TABLE1 FULL OUTER JOIN TABLE2
ON TABLE1.id = TABLE2.id;
