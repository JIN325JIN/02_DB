---SELECT 예제 다품----
----BASIC SELECT-----

----1번-----
SELECT * FROM TB_DEPARTMENT;
SELECT DEPARTMENT_NAME AS "학과명",CATEGORY AS "계열" FROM TB_DEPARTMENT;

----2번-------
SELECT DEPARTMENT_NAME||' 의 정원은', CAPACITY||'명 입니다.'AS "학과별 정원" FROM TB_DEPARTMENT;

---3번----여성인거 따오기가 어려워서 그냥 -2 포함
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO ='001' AND ABSENCE_YN ='Y'AND STUDENT_SSN LIKE '%-2%';

---3-1번-------
SELECT DEPARTMENT_NO,STUDENT_NAME ,ABSENCE_YN,STUDENT_SSN
FROM TB_STUDENT
WHERE SUBSTR (STUDENT_SSN,8,1)='2'
AND DEPARTMENT_NO ='001' AND ABSENCE_YN ='Y' ;

---4번----
SELECT  STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO IN('A513079' ,'A513090','A513091', 'A513110', 'A513119')
ORDER BY STUDENT_NAME DESC;

----5번-----
SELECT DEPARTMENT_NAME, CATEGORY
FROM TB_DEPARTMENT
WHERE CAPACITY BETWEEN 20 AND 30;

----6번----
SELECT * FROM TB_PROFESSOR;
SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;

----7번 -----

SELECT * FROM TB_STUDENT;
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL;

----8번------
SELECT * FROM TB_CLASS;
SELECT PREATTENDING_CLASS_NO AS "CLASS_NO"
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;

-----9번-------
SELECT *FROM TB_DEPARTMENT;
SELECT DISTINCT CATEGORY FROM TB_DEPARTMENT;

-----10번--------
SELECT STUDENT_NO,STUDENT_NAME,STUDENT_SSN
FROM TB_STUDENT
WHERE STUDENT_ADDRESS LIKE '%전주%'AND ABSENCE_YN ='N'AND ENTRANCE_DATE BETWEEN '2002-01-01' AND '2002-12-31';









--2025-03-18 --
--select : basic

---1번----
SELECT DEPARTMENT_NAME AS 학과명,CATEGORY AS 계열
FROM TB_DEPARTMENT;

---2번---
SELECT DEPARTMENT_NAME|| '의 정원은',CAPACITY ||'명 입니다' AS "학과 별 정원"
FROM TB_DEPARTMENT;
---3번---
SELECT DEPARTMENT_NO
FROM TB_DEPARTMENT
WHERE DEPARTMENT_NAME = '국어국문학과';


SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO =(SELECT DEPARTMENT_NO FROM TB_DEPARTMENT WHERE DEPARTMENT_NAME = '국어국문학과')
AND ABSENCE_YN = 'Y' AND SUBSTR(STUDENT_SSN,8,1)='2';
---4번---
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO IN('A513079','A513090','A513091','A513110','A513119')
ORDER BY STUDENT_NAME DESC;
--5번---
SELECT DEPARTMENT_NAME,CATEGORY
FROM TB_DEPARTMENT
WHERE CAPACITY BETWEEN 20 AND 30;
--6번--
SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;
--7번--
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL;

--8번--
SELECT CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;
--9번--
SELECT DISTINCT CATEGORY
FROM TB_DEPARTMENT;
--10번--
SELECT STUDENT_NO,STUDENT_NAME,STUDENT_SSN,STUDENT_ADDRESS 
FROM TB_STUDENT
WHERE STUDENT_ADDRESS LIKE '%전주%' AND ABSENCE_YN = 'N' AND ENTRANCE_DATE LIKE '02%';


--함수--
--1번 완료--
SELECT STUDENT_NO AS "학번",STUDENT_NAME AS "이름",TO_CHAR(ENTRANCE_DATE,'YYYY-MM-DD') AS "입학 일자"
FROM TB_STUDENT
WHERE DEPARTMENT_NO ='002'
ORDER BY ENTRANCE_DATE;
--2번 완료--
SELECT PROFESSOR_NAME,PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE PROFESSOR_NAME NOT LIKE '___';

--3번--하는중---어렵네--재호랑같이함
SELECT PROFESSOR_NAME,SUBSTR(PROFESSOR_SSN,1,6) 생년월일,FLOOR(MONTHS_BETWEEN(SYSDATE,TO_DATE('19'||SUBSTR(PROFESSOR_SSN,1,6),'RRRRMMDD'))/12) 나이
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN,8,1)='1'
ORDER BY "나이";
--4번 완료--
SELECT SUBSTR(PROFESSOR_NAME,2)
FROM TB_PROFESSOR
WHERE PROFESSOR_NAME LIKE '%__';
--5번--하는중----
SELECT STUDENT_SSN FROM TB_STUDENT;
SELECT STUDENT_NO,STUDENT_NAME,STUDENT_SSN,ENTRANCE_DATE
FROM TB_STUDENT
WHERE 19*365< ENTRANCE_DATE - TO_DATE(SUBSTR(STUDENT_SSN,1,6),'RRMMDD');




--5번 답안--
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE) - EXTRACT(YEAR FROM TO_DATE('19'||SUBSTR(STUDENT_SSN, 1, 6),'YYYYMMDD')) > 19;

SELECT EXTRACT(YEAR FROM ENTRANCE_DATE) -- 입학년도
FROM TB_STUDENT;

SELECT EXTRACT(YEAR FROM ENTRANCE_DATE) - EXTRACT(YEAR FROM TO_DATE('19'||SUBSTR(STUDENT_SSN, 1, 6),'YYYYMMDD')) -- 학생이 태어난 년도
FROM TB_STUDENT;

--6번 완료--
--크리스마스 요일 구하기
SELECT TO_CHAR(TO_DATE('2020-12-25'),'DAY')FROM DUAL;
--7번 완료--
SELECT TO_DATE('99/10/11','YY/MM/DD') FROM DUAL;--2099
SELECT TO_DATE('49/10/11','YY/MM/DD') FROM DUAL;--2049
SELECT TO_DATE('99/10/11','RR/MM/DD') FROM DUAL;--1999
SELECT TO_DATE('49/10/11','RR/MM/DD') FROM DUAL;--2049
SELECT TO_DATE('50/10/11','RR/MM/DD') FROM DUAL;--1951
--8번 완료--
SELECT STUDENT_NO,STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO NOT LIKE '%A%';
--9번 완료 (힌트)--
SELECT ROUND(AVG(POINT),1) AS "평점" 
FROM TB_GRADE
JOIN TB_STUDENT USING (STUDENT_NO)
JOIN TB_CLASS USING (CLASS_NO)
WHERE STUDENT_NAME ='한아름';
--10번 완료 (힌트)--
SELECT * FROM TB_STUDENT;
SELECT DEPARTMENT_NO AS "학과번호", COUNT (*) AS "학생 수 (명)"
FROM TB_DEPARTMENT
JOIN TB_STUDENT USING (DEPARTMENT_NO)
GROUP BY DEPARTMENT_NO
ORDER BY 학과번호 ;
--11번 완료--
SELECT COUNT(*)
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;
--12번 힌트--
SELECT SUBSTR(TERM_NO,1,4) AS "년도",ROUND(AVG(POINT),1) AS "년도 별 평점"
FROM TB_GRADE
JOIN TB_STUDENT USING(STUDENT_NO)
WHERE STUDENT_NO ='A112113'
GROUP BY SUBSTR(TERM_NO,1,4)
ORDER BY 년도;
--13번--학과 휴학생
SELECT DEPARTMENT_NO ,COUNT(*)
FROM TB_DEPARTMENT
JOIN TB_STUDENT USING (DEPARTMENT_NO)TB_CLASS
WHERE ABSENCE_YN = 'N'
GROUP BY DEPARTMENT_NO;
--14번힌트 동명이인-
SELECT STUDENT_NAME AS "동일이름",COUNT (*) AS "동명이인 수"
FROM TB_STUDENT
GROUP BY STUDENT_NAME
HAVING COUNT(*) > 1
ORDER BY 동일이름;
--15번--모르겠음
SELECT TERM_NO FROM TB_GRADE;
SELECT SUBSTR(TERM_NO,1,4) AS 년도, SUBSTR(TERM_NO,5,6) AS 학기, ROUND(AVG(POINT),1)AS 평점
FROM TB_GRADE
WHERE STUDENT_NO ='A112113'
GROUP BY ROLLUP( SUBSTR(TERM_NO,5,6),SUBSTR(TERM_NO,5,6))
ORDER BY SUBSTR(TERM_NO,1,4);
--옵션--

--1번 완료--
SELECT STUDENT_NAME AS "학생 이름", STUDENT_ADDRESS AS "주소지"
FROM TB_STUDENT
ORDER BY "학생 이름" ASC;
--2번 완료--
SELECT STUDENT_NAME,STUDENT_SSN
FROM TB_STUDENT
WHERE ABSENCE_YN ='Y'
ORDER BY STUDENT_SSN DESC;
--3번 완료--
SELECT STUDENT_NAME AS "학생이름",STUDENT_NO AS "학번",STUDENT_ADDRESS AS "거주지 주소"
FROM TB_STUDENT
WHERE STUDENT_NO LIKE '9%' 
AND STUDENT_ADDRESS LIKE '경기%' 
OR STUDENT_ADDRESS LIKE '강원도%'
ORDER BY STUDENT_NAME;
--4번 완료--
SELECT DEPARTMENT_NO
FROM TB_DEPARTMENT
WHERE DEPARTMENT_NAME ='법학과'; 

SELECT PROFESSOR_NAME,PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO =(SELECT DEPARTMENT_NO
FROM TB_DEPARTMENT
WHERE DEPARTMENT_NAME ='법학과')
ORDER BY PROFESSOR_SSN ;

SELECT * FROM TB_GRADE;
--5번 완료--
SELECT STUDENT_NO,TO_CHAR(POINT,'FM999999990.00')AS POINT
FROM TB_GRADE
WHERE TERM_NO ='200402'AND CLASS_NO ='C3118100'
ORDER BY POINT DESC;


--6번 완료--
SELECT STUDENT_NO,STUDENT_NAME,DEPARTMENT_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO);

--7번 완료--
SELECT CLASS_NAME,DEPARTMENT_NAME
FROM TB_CLASS
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO);
--8번 완료--
SELECT CLASS_NAME,PROFESSOR_NAME
FROM TB_CLASS_PROFESSOR
JOIN TB_CLASS USING (CLASS_NO)
JOIN TB_PROFESSOR USING (PROFESSOR_NO)
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO);
--9번--힌트--
SELECT CLASS_NAME,PROFESSOR_NAME
FROM TB_CLASS
JOIN TB_CLASS_PROFESSOR USING (CLASS_NO)
JOIN TB_PROFESSOR P USING (PROFESSOR_NO)
JOIN TB_DEPARTMENT D ON(P.DEPARTMENT_NO= D.DEPARTMENT_NO)
WHERE CATEGORY = '인문사회';

--10번--
SELECT DEPARTMENT_NO
FROM TB_DEPARTMENT
WHERE DEPARTMENT_NAME ='음악학과';


SELECT STUDENT_NO AS "학번",STUDENT_NAME AS "학생 이름",ROUND(AVG(POINT),1)AS "전체 평점"
FROM TB_STUDENT
JOIN TB_GRADE USING (STUDENT_NO)
WHERE DEPARTMENT_NO = (SELECT DEPARTMENT_NO FROM TB_DEPARTMENT WHERE DEPARTMENT_NAME ='음악학과')
GROUP BY DEPARTMENT_NO;


--10번 답지--
SELECT S.STUDENT_NO 학번, STUDENT_NAME "학생 이름", ROUND(AVG(POINT),1) "전체 평점"
FROM TB_GRADE G
JOIN TB_STUDENT S ON(S.STUDENT_NO = G.STUDENT_NO)
JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '음악학과'
GROUP BY S.STUDENT_NO, STUDENT_NAME
ORDER BY 1;



--11번 완료--
SELECT DEPARTMENT_NAME AS "학과이름",STUDENT_NAME AS "학생이름",PROFESSOR_NAME AS "지도교수이름"
FROM TB_STUDENT
JOIN TB_PROFESSOR ON (TB_STUDENT.COACH_PROFESSOR_NO =TB_PROFESSOR.PROFESSOR_NO )
JOIN TB_DEPARTMENT ON (TB_DEPARTMENT.DEPARTMENT_NO = TB_STUDENT.DEPARTMENT_NO )
WHERE STUDENT_NO = 'A313047';
--12번 완료--
SELECT STUDENT_NAME,TERM_NO
FROM TB_GRADE
JOIN TB_STUDENT USING (STUDENT_NO)
JOIN TB_CLASS USING(CLASS_NO)
WHERE CLASS_NAME ='인간관계론' AND TERM_NO LIKE '2007%';

--13번 하는중--
SELECT CLASS_NAME,DEPARTMENT_NAME
FROM TB_CLASS
JOIN TB_CLASS_PROFESSOR USING (CLASS_NO)
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE CATEGORY ='예체능' AND PROFESSOR_NO IS NULL ;

--13번 답지
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS C
LEFT JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE CATEGORY = '예체능'
AND PROFESSOR_NO IS NULL;

--14번 완료--
SELECT DEPARTMENT_NO
FROM TB_DEPARTMENT
WHERE DEPARTMENT_NAME ='서반아어학과';

SELECT STUDENT_NAME AS "학생이름",NVL(COACH_PROFESSOR_NO,'지도교수 미지정') AS" 지도교수"
FROM TB_STUDENT
WHERE DEPARTMENT_NO = (SELECT DEPARTMENT_NO
FROM TB_DEPARTMENT
WHERE DEPARTMENT_NAME ='서반아어학과')
ORDER BY STUDENT_NO ;
--15번--도움
SELECT STUDENT_NO 학번,STUDENT_NAME 이름,DEPARTMENT_NAME "학과 이름 ",ROUND(AVG(POINT),1) AS "평점"
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
JOIN TB_GRADE USING (STUDENT_NO)
WHERE  ABSENCE_YN = 'N'
GROUP BY STUDENT_NO,STUDENT_NAME,DEPARTMENT_NAME
HAVING AVG(POINT)>= 4.0
ORDER BY STUDENT_NO;
--16번--하는중
SELECT DEPARTMENT_NO FROM TB_DEPARTMENT WHERE DEPARTMENT_NAME ='환경조경학과';--934
SELECT DEPARTMENT_NO,CLASS_NAME FROM TB_CLASS
WHERE DEPARTMENT_NO ='034';--9과목

SELECT CLASS_NO,CLASS_NAME,AVG(POINT)
FROM TB_CLASS
JOIN TB_GRADE USING (CLASS_NO)
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
WHERE DEPARTMENT_NO = '034' AND CLASS_TYPE LIKE '전공%'
GROUP BY CLASS_NO,CLASS_NAME
ORDER BY CLASS_NO;

-- 16번답안
-- 환경조경학과 전공과목들의 과목 별 평점을 파악할 수 있는 SQL 문을 작성하시오.
-- ANSI
SELECT CLASS_NO, CLASS_NAME, TRUNC(AVG(POINT),8)
FROM TB_CLASS 
JOIN TB_GRADE USING(CLASS_NO)
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '환경조경학과'
AND CLASS_TYPE LIKE '전공%'
GROUP BY CLASS_NO, CLASS_NAME
ORDER BY 1;


--17번--
SELECT DEPARTMENT_NO
FROM TB_STUDENT
WHERE STUDENT_NAME = '최경희';

SELECT STUDENT_NAME,STUDENT_ADDRESS
FROM TB_STUDENT
WHERE DEPARTMENT_NO = (SELECT DEPARTMENT_NO
FROM TB_STUDENT
WHERE STUDENT_NAME = '최경희');
--18번--모르겠음 ㅠㅠㅠ
SELECT STUDENT_NAME,MAX(POINT)
FROM TB_GRADE
JOIN TB_STUDENT USING(STUDENT_NO)
GROUP BY DEPARTMENT_NO;



SELECT STUDENT_NO,STUDENT_NAME
FROM TB_STUDENT
JOIN TB_TABLE USING (STUDENT_NO)
WHERE MAX(POINT);
--19번--

SELECT CATEGORY
FROM TB_DEPARTMENT
WHERE DEPARTMENT_NAME = '환경조경학과';-- 자연과학

SELECT DEPARTMENT_NAME "계열 학과명",ROUND(AVG(POINT),1)"전공 평점"
FROM TB_DEPARTMENT
JOIN TB_CLASS USING (DEPARTMENT_NO)
JOIN TB_GRADE USING (CLASS_NO)
WHERE CATEGORY =( SELECT CATEGORY FROM TB_DEPARTMENT WHERE DEPARTMENT_NAME = '환경조경학과')
AND CLASS_TYPE LIKE '전공%'
GROUP BY DEPARTMENT_NAME
ORDER BY "계열 학과명" DESC;



--서브쿼리--

SELECT DEPARTMENT_NO
FROM TB_STUDENT
WHERE STUDENT_NAME ='서가람';

SELECT DEPARTMENT_NO
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO);

SELECT P.PROFESSOR_NAME 교수이름, S.STUDENT_NO 아이디,S.STUDENT_NAME 이름, D.DEPARTMENT_NAME 학과명
FROM TB_STUDENT S
JOIN TB_PROFESSOR P ON (P.PROFESSOR_NO = S.COACH_PROFESSOR_NO)
JOIN TB_DEPARTMENT D ON (D.DEPARTMENT_NO = S.DEPARTMENT_NO)
WHERE S.DEPARTMENT_NO = (SELECT DEPARTMENT_NO FROM TB_STUDENT WHERE STUDENT_NAME ='서가람')
ORDER BY 교수이름 DESC;


SELECT PROFESSOR_NAME, STUDENT_NO,STUDENT_NAME
FROM TB_STUDENT S
JOIN TB_PROFESSOR P ON (P.PROFESSOR_NO = S.COACH_PROFESSOR_NO)
JOIN TB_DEPARTMENT D ON (D.DEPARTMENT_NO = S.DEPARTMENT_NO);




SELECT A.AREA_NAME 지역명, M.MEMBER_ID 아이디,M.MEMBER_NAME 이름, G.GRADE_NAME 등급명
FROM TB_MEMBER M
JOIN TB_AREA A USING (AREA_CODE)
JOIN TB_GRADE G ON (G.GRADE_CODE = M.GRADE)
WHERE M.MEMBER_NAME = (SELECT AREA_CODE FROM TB_MEMBER WHERE MEMBER_NAME ='김영희')
ORDER BY 이름;















