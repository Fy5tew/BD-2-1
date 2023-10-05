USE master;
GO

DROP DATABASE TASK5;
GO

CREATE DATABASE TASK5;
GO

USE TASK5;


CREATE TABLE TABLE1 (
	id int,
	title nvarchar(20),

	CONSTRAINT PK_TABLE1 PRIMARY KEY (id),
);
GO

CREATE TABLE TABLE2 (
	id int,
	description nvarchar(40),
	payload int,

	CONSTRAINT FK_TABLE2 FOREIGN KEY (id) REFERENCES TABLE1(id),
);
GO


INSERT INTO TABLE1 (id, title)
VALUES
	(1, 'some title1'),
	(2, 'some title2'),
	(3, 'some title3');
GO

INSERT INTO TABLE2 (id, description, payload)
VALUES
	(1, 'some description for some title1', 34),
	(2, 'some description for some title2', 12);
GO


SELECT title, description FROM TABLE1 FULL OUTER JOIN TABLE2 ON TABLE1.id = TABLE2.id;
SELECT title, description FROM TABLE2 FULL OUTER JOIN TABLE1 ON TABLE1.id = TABLE2.id;
