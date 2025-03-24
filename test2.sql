ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
--계정을 생성하는 구문(username : kh , password: kh1234)
CREATE USER test2 IDENTIFIED BY test2;

--실습시 반드시 필요한 권한 부여
GRANT RESOURCE, CONNECT TO test2;
--사용자 계정에게 권한을 부여 설정
--리소스 권한 과 커넥트 권한.
--RESOURCE : 테이블이나 인덱스같은 DB객체를 생성할 권한
--CONNECT : DB에 연결하고 로그인 할수 있는 권한
--권한을 안준채로 로그인하면 연결 안댐

ALTER USER test2 DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;
--CTRL + SHIFT+N 
--여기에 적어논 아이디 와 비밀번호 적어주고
--원하는 계정으로 로그인 하면 됨!
------------------------------------------------------------------

CREATE TABLE TEST2(
USER_NO NUMBER NOT NULL,
USER_ID VARCHAR2(20),
USER_PW VARCHAR2(20),
USER_NAME VARCHAR2(30),
GENDER VARCHAR2(10),
PHONE VARCHAR2(30),
EMAIL VARCHAR2(50)
);
--그냥 VARCHAR2 : 한글 , 한자 3바이트 영어 숫자 기호 1바이트 -> 크기를 글자수 단위로 받음
--NVARCHAR2 : 모든 문자 2바이트 , 이모지 4바이트, 특수기호 4바이트 -> 크기를 글자수 단위로 받음
--VAR 가없는 그냥 CHAR : 고정 문자
--VARCHAR : 가변문자


--제약조건 : NOT NULL : 데이터에 NULL을 허락하지 않음

--UNIQUE : 중복된 값을 허용하지 않음 / NULL은 중복 가능
-- 유니크 복합 키 : 두개이상을 묶는건데 둘다 해당 되어야만 위배되는것 ( 테이블레벨에서만 가능 . 컬럼에서는 불가능)

--PRIMARY KEY : NULL 과 중복 값은 허용하지 않음 (컬럼의 고유 식별자로 사용하기 위해)
--한개만 걸거면 컬럼이나 테이블중 아무데서나 가능
-- 여러개로 복합으로 걸거면 테이블에서만 가능.
--NOT NULL + UNIQUE 합친게 프라이머리키




--FOREIGN KEY : 참조 되는 테이블의 컬럼의 값이 존재하면 허용

--부모/자식 

--CHECK : 저장 가능한 데이터 값의 범위나 조건을 지정하여 설정한 값만 허용


INSERT INTO TEST2 VALUES (1,'USER01','PASS01','JIN','FEMALE','010-0000-0000','USER01@NAVER.COM');
SELECT * FROM TEST2;