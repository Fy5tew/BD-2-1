USE UNIVER;


/*
CREATE TABLE TIMETABLE
(
    DAY_NAME   nvarchar(2) check (DAY_NAME in ('ОМ', 'БР', 'ЯП', 'ВР', 'ОР', 'ЯА')),
    LESSON     int check (LESSON between 1 and 4),
    TEACHER    char(10) foreign key references TEACHER (TEACHER),
    AUDITORIUM char(20) foreign key references AUDITORIUM (AUDITORIUM),
    SUBJECT    char(10) foreign key references SUBJECT (SUBJECT),
    IDGROUP    int foreign key references GROUPS (IDGROUP),
)
GO


INSERT INTO TIMETABLE
VALUES ('ОМ', 1, 'ялкб', '313-1', 'ясад', 2),
       ('ОМ', 2, 'ялкб', '313-1', 'нюХо', 4),
       ('ОМ', 1, 'лпг', '324-1', 'ясад', 6),
       ('ОМ', 3, 'спа', '324-1', 'охя', 4),
       ('ОМ', 1, 'спа', '206-1', 'охя', 10),
       ('ОМ', 4, 'ялкб', '206-1', 'нюХо', 3),
       ('ЯП', 1, 'апйбв', '301-1', 'ясад', 7),
       ('ОМ', 4, 'апйбв', '301-1', 'нюХо', 7),
       ('ЯП', 2, 'апйбв', '413-1', 'ясад', 8),
       ('ВР', 2, 'дрй', '423-1', 'ясад', 7),
       ('ОМ', 4, 'дрй', '423-1', 'нюХо', 2),
       ('БР', 1, 'ялкб', '313-1', 'ясад', 2),
       ('БР', 2, 'ялкб', '313-1', 'нюХо', 4),
       ('БР', 3, 'спа', '324-1', 'охя', 4),
       ('БР', 4, 'ялкб', '206-1', 'нюХо', 3);
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
		WHERE DAY_NAME = 'БР'
	);


-- 3 
select GROUPS.IDGROUP, TIMETABLE.DAY_NAME, 
	case
		when ( count(*)= 0) then 4
		when ( count(*)= 1) then 3
		when ( count(*)= 2) then 2
		when ( count(*)= 3) then 1
		when ( count(*)= 4) then 0
    end [йНК-БН НЙНМ]
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
