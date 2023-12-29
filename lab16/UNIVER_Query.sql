USE UNIVER;
GO


-- ������ �1
SELECT
	LTRIM(RTRIM(TEACHER)) AS '�������������',
	TEACHER_NAME AS '���',
	GENDER AS '���',
	LTRIM(RTRIM(PULPIT)) AS '�������'
FROM TEACHER
WHERE PULPIT = '����'
FOR XML PATH('�������������'), ROOT('�������������'), ELEMENTS
;
GO


-- ������� �2
SELECT
	AUDITORIUM_NAME AS '������������_���������',
	AUDITORIUM_TYPENAME AS '���_���������',
	AUDITORIUM_CAPACITY AS '�����������'
FROM 
	AUDITORIUM INNER JOIN AUDITORIUM_TYPE ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
WHERE AUDITORIUM.AUDITORIUM_TYPE LIKE '��%'
FOR XML AUTO, ROOT('���������'), ELEMENTS
;
GO


-- ������� �3
DECLARE @h int = 0;
DECLARE @x varchar(2000) = '
	<?xml version="1.0" encoding="windows-1251" ?>
	<subjects>
		<subject id="����" name="���������� ���������� ������������ �����������" pulpit="����" />
		<subject id="����" name="������������ ������� � ����" pulpit="����" />
		<subject id="���" name="���������� ����� ����������������" pulpit="����" />
	</subjects>
';
BEGIN TRAN;
EXEC sp_xml_preparedocument @h output, @x;
INSERT INTO SUBJECT 
SELECT * 
FROM openxml(@h, '/subjects/subject', 0) with ([id] char(10), [name] varchar(100), [pulpit] char(20))
;
EXEC sp_xml_removedocument @h;
SELECT * FROM SUBJECT;
ROLLBACK TRAN
GO


-- ������� �4
DECLARE @Info xml = '
	<info>
		<series>BM</series>
		<number>74301014</number>
		<personal_number>437C050A127B601</personal_number>
		<date_of_issue>23.09.2014</date_of_issue>
		<place_of_residence>�. �����</place_of_residence>
	</info>
';

BEGIN TRANSACTION

INSERT INTO STUDENT (IDGROUP, NAME, BDAY, INFO)
VALUES (2, '������� ��� ����������', '1994-10-04', @Info);

UPDATE STUDENT
SET INFO = @Info
WHERE IDSTUDENT = 1069;

SELECT
	NAME,
	INFO.value('(/info/series)[1]', 'varchar(max)') AS '����� ��������',
	INFO.value('(/info/number)[1]', 'varchar(max)') AS '����� ��������',
	INFO.query('/info/place_of_residence') AS '�����'
FROM STUDENT 
WHERE INFO IS NOT NULL;

ROLLBACK TRANSACTION
GO


-- ������� �5
create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
           elementFormDefault="qualified"
           xmlns:xs="http://www.w3.org/2001/XMLSchema">
       <xs:element name="�������">  
       <xs:complexType><xs:sequence>
       <xs:element name="�������" maxOccurs="1" minOccurs="1">
       <xs:complexType>
       <xs:attribute name="�����" type="xs:string" use="required" />
       <xs:attribute name="�����" type="xs:unsignedInt" use="required"/>
       <xs:attribute name="����"  use="required" >  
       <xs:simpleType>  <xs:restriction base ="xs:string">
   <xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
   </xs:restriction> 	</xs:simpleType>
   </xs:attribute> </xs:complexType> 
   </xs:element>
   <xs:element maxOccurs="3" name="�������" type="xs:unsignedInt"/>
   <xs:element name="�����">   <xs:complexType><xs:sequence>
   <xs:element name="������" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="���" type="xs:string" />
   <xs:element name="��������" type="xs:string" />
   </xs:sequence></xs:complexType>  </xs:element>
   </xs:sequence></xs:complexType>
   </xs:element>
</xs:schema>';

BEGIN TRANSACTION

drop table progress;
drop table STUDENT;

create table STUDENT 
(
	IDSTUDENT integer  identity(1000,1)  primary key,
    IDGROUP integer  foreign key  references GROUPS(IDGROUP),        
    NAME nvarchar(100), 
    BDAY  date,
    STAMP timestamp,
    INFO   xml(Student),    -- �������������� ������� XML-����
    FOTO  varbinary
);

INSERT INTO STUDENT (IDGROUP, NAME, BDAY, INFO)
VALUES (2, '������� ��� ����������', '1994-10-04', '
	<�������>
		<������� �����="BM" �����="74301014" ����="23.09.2014" />
		<�������>335642345</�������>
		<�����>
			<������>��������</������>
			<�����>�����</�����>
			<�����>�����������</�����>
			<���>23</���>
			<��������>708�</��������>
		</�����>
	</�������>
');
INSERT INTO STUDENT (IDGROUP, NAME, BDAY, INFO)
VALUES (2, '������� ��� ����������', '1994-10-04', '
	<�������>
		<������� �����="BM" �����="74301014" ����="23.09.2014" />
		<�������>335642345</�������>
		<�����>
			<������>��������</������>
			<�����>�����</�����>
			<�����>�����������</�����>
			<���>23</���>
			<��������>708�</��������>
		</�����>
	</�������>
');

SELECT * FROM STUDENT;

UPDATE STUDENT SET INFO = '<�������></�������>' WHERE IDSTUDENT = 1000;

ROLLBACK TRANSACTION


-- ������� �7*
SELECT
	LTRIM(RTRIM(f.FACULTY)) AS '@���',
	(
		SELECT COUNT(*)
		FROM PULPIT AS p
		WHERE p.FACULTY = f.FACULTY
		FOR XML PATH('����������_������'), TYPE
	),
	(
		SELECT
			LTRIM(RTRIM(p.PULPIT)) AS '@���',
			(
				SELECT
					LTRIM(RTRIM(t.TEACHER)) AS '@���',
					LTRIM(RTRIM(t.TEACHER_NAME))
				FROM TEACHER AS t
				WHERE t.PULPIT = p.PULPIT
				FOR XML PATH('�������������'), ROOT('�������������'), TYPE
			)
		FROM PULPIT AS p
		WHERE p.FACULTY = f.FACULTY
		FOR XML PATH('�������'), ROOT('�������'), TYPE
	)
FROM
	FACULTY AS f
FOR XML PATH('���������'), ROOT('�����������')
;
GO
