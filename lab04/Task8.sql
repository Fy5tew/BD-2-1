USE UNIVER;


/*
CREATE TABLE TIMETABLE
(
    DAY_NAME   nvarchar(2) check (DAY_NAME in ('��', '��', '��', '��', '��', '��')),
    LESSON     int check (LESSON between 1 and 4),
    TEACHER    char(10) foreign key references TEACHER (TEACHER),
    AUDITORIUM char(20) foreign key references AUDITORIUM (AUDITORIUM),
    SUBJECT    char(10) foreign key references SUBJECT (SUBJECT),
    IDGROUP    int foreign key references GROUPS (IDGROUP),
)
GO


INSERT INTO TIMETABLE
VALUES ('��', 1, '����', '313-1', '����', 2),
       ('��', 2, '����', '313-1', '����', 4),
       ('��', 1, '���', '324-1', '����', 6),
       ('��', 3, '���', '324-1', '���', 4),
       ('��', 1, '���', '206-1', '���', 10),
       ('��', 4, '����', '206-1', '����', 3),
       ('��', 1, '�����', '301-1', '����', 7),
       ('��', 4, '�����', '301-1', '����', 7),
       ('��', 2, '�����', '413-1', '����', 8),
       ('��', 2, '���', '423-1', '����', 7),
       ('��', 4, '���', '423-1', '����', 2),
       ('��', 1, '����', '313-1', '����', 2),
       ('��', 2, '����', '313-1', '����', 4),
       ('��', 3, '���', '324-1', '���', 4),
       ('��', 4, '����', '206-1', '����', 3);
GO
*/


-- 1
SELECT DISTINCT AUDITORIUM, DAY_NAME
FROM TIMETABLE
WHERE AUDITORIUM NOT IN (
		SELECT DISTINCT AUDITORIUM FROM TIMETABLE
		WHERE LESSON = 2
	);


-- 2 
SELECT DISTINCT AUDITORIUM, LESSON
FROM TIMETABLE
WHERE AUDITORIUM NOT IN (
		SELECT DISTINCT AUDITORIUM FROM TIMETABLE
		WHERE DAY_NAME = '��'
	);


-- 3 
select GROUPS.IDGROUP, TIMETABLE.DAY_NAME, 
	case
		when ( count(*)= 0) then 4
		when ( count(*)= 1) then 3
		when ( count(*)= 2) then 2
		when ( count(*)= 3) then 1
		when ( count(*)= 4) then 0
    end [���-�� ����]
FROM  GROUPS inner join TIMETABLE on GROUPS.IDGROUP = TIMETABLE.IDGROUP
GROUP BY GROUPS.IDGROUP, TIMETABLE.DAY_NAME
ORDER BY GROUPS.IDGROUP;


-- 4
SELECT TEACHER.TEACHER_NAME, TIMETABLE.DAY_NAME, TIMETABLE.LESSON
FROM TIMETABLE CROSS JOIN TEACHER
WHERE TIMETABLE.TEACHER != TEACHER.TEACHER;


-- 5
SELECT GROUPS.IDGROUP, TIMETABLE.DAY_NAME, TIMETABLE.LESSON
FROM TIMETABLE CROSS JOIN GROUPS
WHERE TIMETABLE.IDGROUP != GROUPS.IDGROUP;
