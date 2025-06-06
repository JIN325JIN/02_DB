-- DDL(Data Definition Language)
-- 객체를 만들고(CREATE), 바꾸고(ALTER), 삭제(DROP) 하는 데이터 정의 언어


/*
 * ALTER(바꾸다, 수정하다, 변조하다)
 * 
 * -- 테이블에서 수정할 수 있는 것
 * 1) 제약 조건(추가/삭제)
 * 2) 컬럼(추가/수정/삭제)
 * 3) 이름변경 (테이블명, 컬럼명..)
 * 
 * 
 * */


-- 1) 제약조건(추가/삭제)-- 

-- [작성법]
-- 1) 추가 : ALTER TABLE 테이블명
--			ADD [CONSTRAINT 제약조건명] 제약조건(지정할컬럼명)
--			[REFERENCES 테이블명[(컬럼명)]]; <-- FK 인 경우 추가

-- 2) 삭제 : ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;

-- * 제약조건 자체를 수정하는 구문은 별도 존재하지 않음!
--> 삭제 후 추가를 해야함.

--DERPARTMENT 테이블 복사(컬럼명, 데이터 타입, NOT NULL제약조건만 복사가 된다.)
CREATE TABLE DEPT_COPY AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;

--DEPT_COPY 의 DEPT_TITLE 컬럼에 UNIQUE 제약 추가(DEPT_TITLE은 그러면 중복 X) : 이미 만들어진 테이블 수정

ALTER TABLE DEPT_COPY
ADD CONSTRAINT DEPT_COPY_TITLE_UNIQUE UNIQUE (DEPT_TITLE);

--DEPT_COPY 의 DEPT_TITLE 컬럼에 QUIQUE 삭제 : 이것도 수정인거지
ALTER TABLE DEPT_COPY
DROP CONSTRAINT DEPT_COPY_TITLE_UNIQUE;


--****DEPT_COPY 의 DEPT_TITLE 컬럼에 NOT NULL 제약조건 추가/삭제

ALTER TABLE DEPT_COPY 
ADD CONSTRAINT DEPT_COPY_NN NOT NULL (DEPT_TITLE);
--SQL Error [904] [42000]: ORA-00904: : 부적합한 식별자
-->NOT NULL제약조건은 새로운 조건을 추가하는것이 아닌, 컬럼 자체에 NULL을 허용/ 비허용 을 제어하는 성질 변경의 형태


--MODIFY(수정하다) 구문을 사용해서 NULL 제어 
ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE NOT NULL;-- DEPT_TITLE 컬럼에 NOT NULL적용

ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE NULL; --DEPT_TITLE에 NULL 허용.

------------------------------------------------------------------------------------------
-- 2. 컬럼(추가/수정/삭제)

-- 컬럼 추가
-- ALTER TABLE 테이블명 ADD(컬럼명 데이터타입 [DEFAULT '값']);


-- 컬럼 수정
-- ALTER TABLE 테이블명 MODIFY 컬럼명 데이터타입; --> 데이터 타입 변경

-- ALTER TABLE 테이블명 MODIFY 컬럼명 DEFAULT '값'; --> DEFAULT 값 변경


-- 컬럼 삭제
-- ALTER TABLE 테이블명 DROP (삭제할컬럼명);
-- ALTER TABLE 테이블명 DROP COLUMN 삭제할컬럼명;

SELECT * FROM DEPT_COPY;
--CNAME 컬럼 추가

ALTER TABLE DEPT_COPY ADD (CNAME VARCHAR2(30));
SELECT * FROM DEPT_COPY;--CNAME 추가완료.
--NULL으로 추가됨. (DEFAULT없니깐)

--LNAME 추가(기본값'한국')
ALTER TABLE DEPT_COPY ADD (LNAME VARCHAR2(30) DEFAULT '한국');
SELECT * FROM DEPT_COPY;--컬럼이 생성되면서 DEFAULT값이 한국으로 잘 추가됨.

--D10개발1팀 추가
INSERT INTO DEPT_COPY VALUES ('D10','개발1팀','L1',NULL,DEFAULT);
--SQL Error [12899] [72000]: ORA-12899: "KH"."DEPT_COPY"."DEPT_ID" 열에 대한 값이 너무 큼(실제: 3, 최대값: 2)
--DEPT_ID의 DATA TYPE이 CHAR(2) 이므로 영어,숫자 합쳐서 2글자 까지만 저장 가능한데 우리는 D10으로 3바이트 넣고싶어함.
-->VARCHAR2(3)으로 변경해보기 (남는 바이트 메모리 반환 위해! )

--DEPT_ID 컬럼 데이터 타입 수정
ALTER TABLE DEPT_COPY MODIFY DEPT_ID VARCHAR2(3);
--컬럼 데이터 타입 수정 후 다시 위 INSERT구문 실행시 삽입 성공 확인 
INSERT INTO DEPT_COPY VALUES ('D10','개발1팀','L1',NULL,DEFAULT);
SELECT * FROM DEPT_COPY;

--LNAME기본값을 'KOREA'로 수정
ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT 'KOREA';
SELECT * FROM DEPT_COPY;

--기본값을 변경했다고 해서, 기존 데이터가 변하지는 않는다. (한국-> KOREA)
-- 앞으로 INSERT될 데이터만 변경된 내용으로 삽입 됨.

--LNAME '한국'->'KOREA'변경
UPDATE DEPT_COPY SET LNAME = DEFAULT WHERE LNAME ='한국';
SELECT * FROM DEPT_COPY; -- 수정완료

COMMIT;

--DEPT COPY 모든 컬럼 삭제
ALTER TABLE DEPT_COPY DROP(LNAME);
ALTER TABLE DEPT_COPY DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID;
--SQL Error [12983] [72000]: ORA-12983: 테이블에 모든 열들을 삭제할 수 없습니다

--테이블이란? 행과 열로 이루어진 DB의 가장 기본적인 객체. -> 테이블 최소 1개이상의 컬럼이 존재해야하기 때문에
-- 모든 컬럼을 다 삭제할순 없다.



--테이블 삭제
DROP TABLE DEPT_COPY; -- 테이블 삭제됨
SELECT * FROM DEPT_COPY;-- 삭제되서 조회안됨...

--DEPARTMENT 테이블 복사해서 DEPT_COPY 생성
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;
--> 컬럼명, 데이터 타입, NOT NULL 여부만 복사


--DEPT_COPY 테이블에 PK추가 (컬럼: DEPT_ID. 제약조건명 : D_COPY _PK)
ALTER TABLE DEPT_COPY 
ADD CONSTRAINT D_COPY_PK PRIMARY KEY (DEPT_ID);

--3. 이름 변경(컬럼명, 테이블명, 제약조건명)

--1) 컬럼명 변경 (DEPT_TITLE -> DEPT_NAME)
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

SELECT * FROM DEPT_COPY;-- 컬럼명 변경 확인

--2) 제약조건 명 변경(D_COPY_PK -> DEPT_COPY_PK)
ALTER TABLE DEPT_COPY RENAME CONSTRAINT D_COPY_PK TO DEPT_COPY_PK;
SELECT * FROM DEPT_COPY;

--3) 테이블명 변경 (DEPT_COPY->DCOPY)
ALTER TABLE DEPT_COPY RENAME TO DCOPY;

SELECT * FROM DEPT_COPY; -- 테이블명 변경해서 이제 없는 테이블됨
SELECT * FROM DCOPY; -- 조회 잘됨

----------------------------------------------------------------------
--4. 테이블 삭제
-- DROP TABLE 테이블명 [CASCADE CONSTRAINTS];

--1) 관계가 형성되지 않은 테이블 삭제
DROP TABLE DCOPY;
--2)관계가 형성된 테이블 삭제 
CREATE TABLE TB1(
TB1_PK NUMBER PRIMARY KEY,
TB1_COL NUMBER );-- 부모테이블

CREATE TABLE TB2(
TB2_PK NUMBER PRIMARY KEY,
TB2_COL NUMBER REFERENCES TB1
);-- 자식 테이블 , FK제약 조건 설정


--TB1에 샘플 데이터 삽입
INSERT INTO TB1 VALUES(1,100);
INSERT INTO TB1 VALUES(2,200);
INSERT INTO TB1 VALUES(3,300);

SELECT * FROM TB1;


--TB2에 샘플 데이터 삽입
INSERT INTO TB2 VALUES (11,1);
INSERT INTO TB2 VALUES (12,2);
INSERT INTO TB2 VALUES (13,3);

SELECT * FROM TB2;

COMMIT;

--TB1과 TB2는 부모-자식 테이블 관계 형성
--부모인 TB1 테이블을 삭제하려고 할때
DROP TABLE TB1;
--SQL Error [2449] [72000]: ORA-02449: 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다
--TB1 테이블에 자식이 존재한다는 뜻

--> 해결방법
-- 1) 자식 삭제 후 부모테이블 삭제
-- 2) ALTER구문 이용해서 FK 제약조건 삭제 후 TB1 삭제
--3) DROP TABLE 삭제 옵션 CASCADE CONSTRAINTS 사용
--> CASCADE CONSTRAINTS : 삭제 하려는 테이블과 연결된 FK 제약조건을 모두 삭제 


DROP TABLE TB1 CASCADE CONSTRAINTS;--부모삭제
-- 테이블 삭제시 FK 관계도 모두 삭제


SELECT * FROM TB1;
--SQL Error [942] [42000]: ORA-00942: 테이블 또는 뷰가 존재하지 않습니다
--삭제 확인
SELECT * FROM TB2;-- 자식테이블 TB2 만 아주 관계 없이 남게 됨.
----------------------------------------------------------------------
/*DDL 주의 사항*/
--1) DDL 은 COMMIT/ ROLLBACK이 되지 않는다. (DML만 가능)
--2) DDL 과 DML구문 섞어서 수행하면 안된다.
--DDL (CREATE,ALTER,DROP : 객체 생성/ 수정/삭제)
--DML (INSERT,UPDATE,DELETE : 데이터 (행)추가/갱신/삭제)
--> DDL은 수행시 존재하고 있는 트랜잭션을 모두 DB에 강제 COMMIT 시킴
--> DDL이 종료된 후에 DML구문을 수행할수 있도록 권장!

SELECT * FROM TB2; 
COMMIT;
--트랜잭션 바구니 비어있는 상태에서 
--DML(INSERT수행)
INSERT INTO TB2 VALUES(14,4); 
INSERT INTO TB2 VALUES(15,5); 
SELECT * FROM TB2;


--DDL (컬럼명 변경)
ALTER TABLE TB2 RENAME COLUMN TB2_COL TO TB2_COLUMN;

ROLLBACK;
SELECT * FROM TB2;
--롤백 안된다... 위에서 DDL구문중 ALTER를 사용해서 그 시점에 강제 COMMIT 되었기 때문에 
