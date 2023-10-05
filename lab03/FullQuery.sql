USE master;
GO


-- �������� ���� ������
DROP DATABASE T_MyBase2;
GO


-- �������� ���� ������
CREATE DATABASE T_MyBase2
	CONTAINMENT = NONE
	ON PRIMARY (
		NAME = 'T_MyBase2',
		FILENAME = 'D:\Study\2c1s\DB\lab03\DATABASE\T_MyBase2.mdf',
		SIZE = 5120KB,
		MAXSIZE = UNLIMITED,
		FILEGROWTH = 1024KB
	)
	LOG ON (
		NAME = 'T_MyBase2_log',
		FILENAME = 'D:\Study\2c1s\DB\lab03\DATABASE\T_MyBase2_log.ldf',
		SIZE = 1024KB,
		MAXSIZE = 2048GB,
		FILEGROWTH = 10%
	)
GO


USE T_MyBase2;
GO


-- �������� ������
CREATE TABLE Equipment (
	ID int NOT NULL,
	Name varchar(50) NOT NULL,
	Type varchar(20) NOT NULL,

	CONSTRAINT PK_Equipment PRIMARY KEY (ID),
);

CREATE TABLE Worker (
	ID int NOT NULL,
	LastName varchar(25) NOT NULL,
	FirstName varchar(15) NOT NULL,
	Patronymic varchar(20) NOT NULL,
	JobTitle varchar(50) NOT NULL,
	EmploymentDate date NOT NULL,

	CONSTRAINT PK_Worker PRIMARY KEY (ID),
);

CREATE TABLE Arrival (
	ID int NOT NULL,
	Equipment int NOT NULL,
	ArrivalDate datetime NOT NULL,
	Quantity int NOT NULL,
	InstallationDepartment varchar(50) NOT NULL,
	Responsible int NOT NULL,

	CONSTRAINT PK_Arrival PRIMARY KEY (ID),
	CONSTRAINT FK_Arrival_Equipment FOREIGN KEY (Equipment) REFERENCES Equipment(ID),
	CONSTRAINT FK_Arrival_Worker FOREIGN KEY (Responsible) REFERENCES Worker(ID),
);

CREATE TABLE WriteOff (
	ID int NOT NULL,
	Arrival int NOT NULL,
	Quantity int NOT NULL,
	WriteOffDate datetime NOT NULL,
	Reason varchar(100) NOT NULL,
	Responsible int NOT NULL,

	CONSTRAINT PK_WriteOff PRIMARY KEY (ID),
	CONSTRAINT FK_WriteOff_Arrival FOREIGN KEY (Arrival) REFERENCES Arrival(ID),
	CONSTRAINT FK_WriteOff_Worker FOREIGN KEY (Responsible) REFERENCES Worker(ID),
);

GO


-- ��������� ������� (���������� �������)
ALTER TABLE Equipment 
ADD HasGuarantee varchar(5) NOT NULL,
CONSTRAINT CHK_Equipment_HasGuarantee check (HasGuarantee in ('false', 'true'));
GO


-- ��������� ������� (�������� �������)
ALTER TABLE Equipment DROP CONSTRAINT CHK_Equipment_HasGuarantee;
ALTER TABLE Equipment DROP COLUMN HasGuarantee;
GO


-- ������� �������� � �������
INSERT INTO Equipment (ID, Name, Type)
VALUES
    (1, '������� HP', '��������'),
    (2, '������� Dell', '�������'),
    (3, '������� LG', '�������'),
    (4, '������ Canon', '������'),
    (5, '���������� Logitech', '���������'),
    (6, '���� Microsoft', '���������'),
    (7, '�������� Samsung', '��������'),
    (8, '������ TP-Link', '������� ������������'),
    (9, '���������� Nikon', '����������'),
    (10, '�������� Epson', '��������');
GO

INSERT INTO Worker (ID, LastName, FirstName, Patronymic, JobTitle, EmploymentDate)
VALUES
    (1, '������', '����', '���������', '��������', '2020-03-15'),
    (2, '������', '������', '��������', '�������', '2019-08-22'),
    (3, '��������', '�����', '�������������', '���������', '2021-01-10'),
    (4, '������', '���������', '������������', '�����������', '2018-05-07'),
    (5, '�������', '������', '��������', '��������', '2022-02-18'),
    (6, '���������', '�����', '���������', 'HR-����������', '2020-11-30'),
    (7, '��������', '�������', '����������', '�����������', '2019-04-25'),
    (8, '��������', '�����', '����������', '��������', '2021-09-03'),
    (9, '��������', '�����', '��������', '����������', '2017-07-12'),
    (10, '�������', '�����', '�������������', '�������� �� ��������', '2022-06-14');
GO

INSERT INTO Arrival (ID, Equipment, ArrivalDate, Quantity, InstallationDepartment, Responsible)
VALUES
    (1, 1, '2023-01-15T10:30:00', 5, '����� ������', 1),
    (2, 2, '2023-02-20T14:45:00', 3, '����� ����������', 2),
    (3, 3, '2023-03-10T11:15:00', 2, '����� ������������', 3),
    (4, 4, '2023-04-05T09:00:00', 1, '����� ������', 4),
    (5, 5, '2023-05-12T16:20:00', 10, '����� ����������', 5),
    (6, 6, '2023-06-25T13:10:00', 8, '����� ������������', 6),
    (7, 7, '2023-07-18T08:45:00', 7, '����� ������', 7),
    (8, 8, '2023-08-09T17:30:00', 4, '����� ����', 8),
    (9, 9, '2023-09-02T10:00:00', 2, '����� ����������', 9),
    (10, 10, '2023-09-10T12:15:00', 1, '����� ����������', 10);
GO

INSERT INTO WriteOff (ID, Arrival, Quantity, WriteOffDate, Reason, Responsible)
VALUES
    (1, 1, 2, '2023-02-01T11:00:00', '�������������', 1),
	(2, 8, 1, '2023-09-05T17:15:00', '��������', 8),
	(3, 7, 2, '2023-08-12T09:30:00', '�������������', 7),
	(4, 3, 1, '2023-04-10T14:15:00', '�������������', 3),
	(5, 10, 1, '2023-09-25T11:45:00', '�������', 10),
	(6, 9, 1, '2023-09-20T10:30:00', '�������������', 9),
	(7, 5, 3, '2023-06-20T16:00:00', '�������������', 5),
	(8, 6, 2, '2023-07-08T13:20:00', '�������', 6),
	(9, 4, 1, '2023-05-02T10:45:00', '�������', 4),
	(10, 2, 1, '2023-03-05T15:30:00', '��������', 2);
GO


-- ������� ������
SELECT * FROM Equipment;
GO

SELECT * FROM Worker;
GO

SELECT * FROM Arrival;
GO

SELECT * FROM WriteOff;
GO

SELECT LastName, JobTitle FROM Worker;
GO

SELECT count(*) AS [Arrival Count] FROM Arrival;
GO

-- ��������� ������
SELECT * FROM Worker WHERE LastName = '��������';
GO

UPDATE Worker SET JobTitle = '��������� ��������' WHERE LastName = '��������';
GO

SELECT * FROM Worker WHERE LastName = '��������';
GO


-- �������� ������
SELECT * FROM WriteOff WHERE ID = 7;
GO

DELETE FROM WriteOff WHERE ID = 7;
GO

SELECT * FROM WriteOff WHERE ID = 7;
GO
