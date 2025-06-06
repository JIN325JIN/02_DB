-- 1. 전지연 사원이 속해있는 부서원들을 조회하시오 (단, 전지연은 제외)
-- 사번, 사원명, 전화번호, 고용일, 부서명

--서브쿼리--
SELECT DEPT_CODE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
WHERE EMP_NAME ='전지연'; --D1

--메인쿼리--
SELECT EMP_ID,EMP_NAME, PHONE,TO_CHAR(HIRE_DATE,'YY/MM/DD')
FROM EMPLOYEE
WHERE DEPT_CODE =(SELECT DEPT_CODE FROM EMPLOYEE LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID) WHERE EMP_NAME ='전지연')
AND EMP_NAME != '전지연';

-- 2. 고용일이 2000년도 이후인 사원들 중 급여가 가장 높은 사원의
-- 사번, 사원명, 전화번호, 급여, 직급명을 조회하시오.

--서브쿼리
SELECT MAX(SALARY)
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '2000-01-01'AND SYSDATE;
--메인쿼리
SELECT EMP_ID,EMP_NAME,PHONE,SALARY,JOB_NAME
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE SALARY =(SELECT MAX(SALARY) FROM EMPLOYEE WHERE HIRE_DATE BETWEEN '2000-01-01'AND SYSDATE);

-- 3. 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회하시오. (단, 노옹철 사원은 제외)
-- 사번, 이름, 부서코드, 직급코드, 부서명, 직급명


SELECT DEPT_TITLE,JOB_NAME
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_ID =DEPT_CODE)
WHERE EMP_NAME = '노옹철';-- 총무부, 부사장

SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE,DEPT_TITLE,JOB_NAME
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE (DEPT_TITLE,JOB_NAME) =(SELECT DEPT_TITLE,JOB_NAME FROM EMPLOYEE JOIN JOB USING (JOB_CODE) LEFT JOIN DEPARTMENT ON (DEPT_ID =DEPT_CODE)
WHERE EMP_NAME = '노옹철')
AND EMP_NAME != '노옹철';


-- 4. 2000년도에 입사한 사원과 부서와 직급이 같은 사원을 조회하시오
-- 사번, 이름, 부서코드, 직급코드, 고용일


SELECT DEPT_CODE,JOB_CODE
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE HIRE_DATE BETWEEN '2000-01-01'AND '2000-12-31';-- 유재식, D6,J3


SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE,TO_CHAR (HIRE_DATE,'YY/MM/DD')
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE (DEPT_CODE,JOB_CODE) =(SELECT DEPT_CODE,JOB_CODE FROM EMPLOYEE JOIN JOB USING (JOB_CODE) LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE HIRE_DATE BETWEEN '2000-01-01'AND '2000-12-31');


-- 5. 77년생 여자 사원과 동일한 부서이면서 동일한 사수를 가지고 있는 사원을 조회하시오
-- 사번, 이름, 부서코드, 사수번호, 주민번호, 고용일

SELECT * FROM EMPLOYEE;

SELECT DEPT_CODE,MANAGER_ID
FROM EMPLOYEE
WHERE EMP_NO LIKE '77%' AND SUBSTR(EMP_NO,8,1)=2 ;--D1,214

SELECT EMP_ID,EMP_NAME,DEPT_CODE,MANAGER_ID,EMP_NO
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
WHERE (DEPT_CODE,MANAGER_ID)=(SELECT DEPT_CODE,MANAGER_ID
FROM EMPLOYEE
WHERE EMP_NO LIKE '77%' AND SUBSTR(EMP_NO,8,1)=2);


-- 6. 부서별 입사일이 가장 빠른 사원의
-- 사번, 이름, 부서명(NULL이면 '소속없음'), 직급명, 입사일을 조회하고
-- 입사일이 빠른 순으로 조회하시오
-- 단, 퇴사한 직원은 제외하고 조회..

SELECT DEPT_TITLE,MIN(HIRE_DATE)
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE;--1990-02-06 00:00:00.000


SELECT EMP_ID,EMP_NAME,NVL(DEPT_TITLE,'소속없음'),JOB_NAME,TO_CHAR(HIRE_DATE,'YY/MM/DD')
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE ENT_YN ='N'
ORDER BY HIRE_DATE;--22명 , 1명 이태림 퇴사.



SELECT MIN (HIRE_DATE)
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE =DEPT_ID)
WHERE DEPT_CODE = 'D1';--2007-03-20 00:00:00.000

SELECT MIN (HIRE_DATE)
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE =DEPT_ID)
WHERE DEPT_CODE = 'D2';--1994-01-20 00:00:00.000


SELECT EMP_ID,EMP_NAME,NVL(DEPT_TITLE,'소속없음'),JOB_NAME,TO_CHAR(HIRE_DATE,'YY/MM/DD')
FROM EMPLOYEE MAIN 
JOIN JOB USING (JOB_CODE) LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE ENT_YN ='N'AND HIRE_DATE =(SELECT MIN (HIRE_DATE) FROM EMPLOYEE SUB LEFT JOIN DEPARTMENT ON(DEPT_CODE =DEPT_ID) WHERE MAIN.DEPT_CODE = SUB.DEPT_CODE)
ORDER BY HIRE_DATE;--5명출력

SELECT EMP_ID,EMP_NAME,NVL(DEPT_TITLE,'소속없음'),JOB_NAME,TO_CHAR(HIRE_DATE,'YY/MM/DD')
FROM EMPLOYEE MAIN
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE HIRE_DATE =(SELECT MIN (HIRE_DATE) FROM EMPLOYEE SUB WHERE MAIN.DEPT_CODE = SUB.DEPT_CODE AND ENT_YN ='N')
ORDER BY HIRE_DATE;--6명출력(하동운이 안나와)

SELECT EMP_ID,EMP_NAME,NVL(DEPT_TITLE,'소속없음'),JOB_NAME,TO_CHAR(HIRE_DATE,'YY/MM/DD')
FROM EMPLOYEE MAIN
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE HIRE_DATE =(SELECT MIN (HIRE_DATE) FROM EMPLOYEE SUB WHERE MAIN.DEPT_CODE = SUB.DEPT_CODE AND ENT_YN ='N'OR SUB.DEPT_CODE IS NULL AND MAIN.DEPT_CODE IS NULL)
ORDER BY HIRE_DATE;--7명출력

--NULL 때문에 재호 도움 받음!

-- 7. 직급별 나이가 가장 어린 직원의
-- 사번, 이름, 직급명, 나이, 보너스 포함 연봉을 조회하고
-- 나이순으로 내림차순 정렬하세요
-- 단 연봉은 \124,800,000 으로 출력되게 하세요. (\ : 원 단위 기호)

SELECT * FROM JOB;

--직급별 나이가 가장 어린 사람 1명을 7개 부서에서 
SELECT MAX(EMP_NO)
FROM EMPLOYEE
GROUP BY JOB_CODE;--7행 


SELECT EMP_ID,EMP_NAME,JOB_NAME,TO_CHAR(SYSDATE,'YYMMDD'),SUBSTR(EMP_NO,1,6) AS "생년월일",(SALARY*12+(12*SALARY)*BONUS) AS "연봉"
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
ORDER BY EMP_NO;