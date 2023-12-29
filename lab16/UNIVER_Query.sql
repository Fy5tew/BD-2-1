USE UNIVER;
GO


-- Здание №1
SELECT
	LTRIM(RTRIM(TEACHER)) AS 'идентификатор',
	TEACHER_NAME AS 'фио',
	GENDER AS 'пол',
	LTRIM(RTRIM(PULPIT)) AS 'кафедра'
FROM TEACHER
WHERE PULPIT = 'ИСиТ'
FOR XML PATH('преподаватель'), ROOT('преподаватели'), ELEMENTS
;
GO


-- Задание №2
SELECT
	AUDITORIUM_NAME AS 'наименование_аудитории',
	AUDITORIUM_TYPENAME AS 'тип_аудитории',
	AUDITORIUM_CAPACITY AS 'вместимость'
FROM 
	AUDITORIUM INNER JOIN AUDITORIUM_TYPE ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
WHERE AUDITORIUM.AUDITORIUM_TYPE LIKE 'ЛК%'
FOR XML AUTO, ROOT('аудитории'), ELEMENTS
;
GO


-- Задание №3
DECLARE @h int = 0;
DECLARE @x varchar(2000) = '
	<?xml version="1.0" encoding="windows-1251" ?>
	<subjects>
		<subject id="ТРПО" name="Технология разработки программного обеспечения" pulpit="ИСиТ" />
		<subject id="КСиС" name="Компьютерные системы и сети" pulpit="ИСиТ" />
		<subject id="СЯП" name="Скриптовые языки программирования" pulpit="ИСиТ" />
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


-- Задание №4
DECLARE @Info xml = '
	<info>
		<series>BM</series>
		<number>74301014</number>
		<personal_number>437C050A127B601</personal_number>
		<date_of_issue>23.09.2014</date_of_issue>
		<place_of_residence>г. Минск</place_of_residence>
	</info>
';

BEGIN TRANSACTION

INSERT INTO STUDENT (IDGROUP, NAME, BDAY, INFO)
VALUES (2, 'Осадчая Эла Васильевна', '1994-10-04', @Info);

UPDATE STUDENT
SET INFO = @Info
WHERE IDSTUDENT = 1069;

SELECT
	NAME,
	INFO.value('(/info/series)[1]', 'varchar(max)') AS 'серия паспорта',
	INFO.value('(/info/number)[1]', 'varchar(max)') AS 'номер паспорта',
	INFO.query('/info/place_of_residence') AS 'адрес'
FROM STUDENT 
WHERE INFO IS NOT NULL;

ROLLBACK TRANSACTION
GO


-- Задание №5
create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
           elementFormDefault="qualified"
           xmlns:xs="http://www.w3.org/2001/XMLSchema">
       <xs:element name="студент">  
       <xs:complexType><xs:sequence>
       <xs:element name="паспорт" maxOccurs="1" minOccurs="1">
       <xs:complexType>
       <xs:attribute name="серия" type="xs:string" use="required" />
       <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
       <xs:attribute name="дата"  use="required" >  
       <xs:simpleType>  <xs:restriction base ="xs:string">
   <xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
   </xs:restriction> 	</xs:simpleType>
   </xs:attribute> </xs:complexType> 
   </xs:element>
   <xs:element maxOccurs="3" name="телефон" type="xs:unsignedInt"/>
   <xs:element name="адрес">   <xs:complexType><xs:sequence>
   <xs:element name="страна" type="xs:string" />
   <xs:element name="город" type="xs:string" />
   <xs:element name="улица" type="xs:string" />
   <xs:element name="дом" type="xs:string" />
   <xs:element name="квартира" type="xs:string" />
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
    INFO   xml(Student),    -- типизированный столбец XML-типа
    FOTO  varbinary
);

INSERT INTO STUDENT (IDGROUP, NAME, BDAY, INFO)
VALUES (2, 'Осадчая Эла Васильевна', '1994-10-04', '
	<студент>
		<паспорт серия="BM" номер="74301014" дата="23.09.2014" />
		<телефон>335642345</телефон>
		<адрес>
			<страна>Беларусь</страна>
			<город>Минск</город>
			<улица>Белорусская</улица>
			<дом>23</дом>
			<квартира>708А</квартира>
		</адрес>
	</студент>
');
INSERT INTO STUDENT (IDGROUP, NAME, BDAY, INFO)
VALUES (2, 'Осадчая Эла Васильевна', '1994-10-04', '
	<студент>
		<паспорт серия="BM" номер="74301014" дата="23.09.2014" />
		<телефон>335642345</телефон>
		<адрес>
			<страна>Беларусь</страна>
			<город>Минск</город>
			<улица>Белорусская</улица>
			<дом>23</дом>
			<квартира>708А</квартира>
		</адрес>
	</студент>
');

SELECT * FROM STUDENT;

UPDATE STUDENT SET INFO = '<студент></студент>' WHERE IDSTUDENT = 1000;

ROLLBACK TRANSACTION


-- Задание №7*
SELECT
	LTRIM(RTRIM(f.FACULTY)) AS '@код',
	(
		SELECT COUNT(*)
		FROM PULPIT AS p
		WHERE p.FACULTY = f.FACULTY
		FOR XML PATH('количество_кафедр'), TYPE
	),
	(
		SELECT
			LTRIM(RTRIM(p.PULPIT)) AS '@код',
			(
				SELECT
					LTRIM(RTRIM(t.TEACHER)) AS '@код',
					LTRIM(RTRIM(t.TEACHER_NAME))
				FROM TEACHER AS t
				WHERE t.PULPIT = p.PULPIT
				FOR XML PATH('преподаватель'), ROOT('преподаватели'), TYPE
			)
		FROM PULPIT AS p
		WHERE p.FACULTY = f.FACULTY
		FOR XML PATH('кафедра'), ROOT('кафедры'), TYPE
	)
FROM
	FACULTY AS f
FOR XML PATH('факультет'), ROOT('университет')
;
GO
