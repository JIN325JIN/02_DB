-- 한줄 주석

/*범위 주석 java랑 동일*/

--선택한 SQL 수행 : 구문에 커서를 두고 CTRL +ENTER 
-- 전체 SQL 수행 : 전체 구문을 활성화(ctrl+a) 시킨 채로 alt+x

--12c 버전 이전 문법 허용 구문
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
--계정을 생성하는 구문(username : kh , password: kh1234)
CREATE USER todo_jdbc IDENTIFIED BY todoList1234;

--실습시 반드시 필요한 권한 부여
GRANT RESOURCE, CONNECT TO todo_jdbc;
--사용자 계정에게 권한을 부여 설정
--리소스 권한 과 커넥트 권한.
--RESOURCE : 테이블이나 인덱스같은 DB객체를 생성할 권한
--CONNECT : DB에 연결하고 로그인 할수 있는 권한
--권한을 안준채로 로그인하면 연결 안댐

ALTER USER todo_jdbc DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;
--객체가 생성될수 있는 공간 할당량 무제한 지정