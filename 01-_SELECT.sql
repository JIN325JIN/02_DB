-- SQL (Structured Query Language,구조적 질의 언어) 
-- 데이터베이스와 상호작용을 하기 위해 사용하는 표준언어
-- 데이터의 조회, 삽입, 수정, 삭제 등


/*SELECT (DNL 또는 DQL ) : 조회 
 * 
 * 데이터를 조회(select)하면 조건에 맞는 행들이 조회됨.
 * 
 * 이때, 조회된 행들의 집합을 "RESULT SET"이라고 한다.
 * 
 * -RESULT SET은 0개 이상의 행을 포함할 수 있다.
 * --왜 0개? 조건에 맞는 행이 없을 수도 있어서.
 *
 */
 
 
 --작성법
 -- SELECT 컬럼명 FROM 테이블명;
 --> SELET가 조회하겠다, 이 컬럼을 이 테이블에서.
 --> 테이블에 특정 컬럼을 조회하겠다.
 SELECT * FROM EMPLOYEE;