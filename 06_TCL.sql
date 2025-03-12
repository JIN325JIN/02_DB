-- TCL (Transaction Control Language) : 트랜잭션 제어 언어
-- COMMIT, ROLLBACK, SAVEPOINT

-- DML : 데이터 조작언어로 데이터의 삽입/삭제/수정
--> 트랜잭션은 DML과 관련되어 있음..

/* TRANSACTION 이란?
 * - 데이터베이스의 논리적 연산 단위
 * - 데이터 변경 사항을 묶어서 하나의 트랜잭션에 담아 처리함.
 * - 트랜잭션의 대상이 되는 데이터 변경 사항 : INSERT, UPDATE, DELETE, MERGE
 *
 * INSERT 수행 ------------------------------------------------> DB 반영 (X)
 *
 * INSERT 수행 -----> 트랜잭션에 추가 ---> COMMIT -------------> DB 반영 (O)
 *
 * INSERT 10번 수행 --> 1개 트랜잭션에 10개 추가 --> ROLLBACK --> DB 반영 (X)
 *
 *
 * 1 ) COMMIT : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 DB에 반영
 *
 * 2 ) ROLLBACK : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 삭제하고
 *                마지막 COMMIT 상태로 돌아감 (DB에 변경 내용 반영 X)
 *
 *
 * 3 ) SAVEPOINT : 메모리 버퍼(트랜잭션)에 저장 지점을 정의하여
 *                ROLLBACK 수행 시 전체 작업을 삭제하는 것이 아닌
 *                저장 지점까지만 일부 ROLLBACK
 *
 *
 * [SAVEPOINT 사용법]
 *
 * ...
 * SAVEPOINT "포인트명1";
 *
 * ...
 * SAVEPOINT "포인트명2";
 *
 * ...
 * ROLLBACK TO "포인트명1"; -- 포인트1 지점까지 데이터 변경사항 삭제
 *
 *
 * ** SAVEPOINT 지정 및 호출 시 이름에 ""(쌍따옴표) 붙여야함 !!! ***
 *
 * */


--새로운 데이터를 DEPARTMENT2 에 INSERT 삽입
SELECT * FROM DEPARTMENT2;
INSERT INTO DEPARTMENT2 VALUES ('T1','개발1팀','L2');
INSERT INTO DEPARTMENT2 VALUES ('T2','개발2팀','L2');
INSERT INTO DEPARTMENT2 VALUES ('T3','개발3팀','L2');

--INSERT잘되었는지 확인하기
SELECT * FROM DEPARTMENT2;

-->DB에 반영이 된것처럼 보이지만, 실제로는 아직 DB에 영구 반영 된것이 아님.
--트랜잭션 하나의 바구니에 INSERT 3개 있음

--ROLLBACK
ROLLBACK;--마지막 커밋시점
--롤백 확인
SELECT * FROM DEPARTMENT2;--내가만든 개발1,2,3팀 없어짐.

--COMMIT후에 ROLLBACK 확인
INSERT INTO DEPARTMENT2 VALUES ('T1','개발1팀','L2');
INSERT INTO DEPARTMENT2 VALUES ('T2','개발2팀','L2');
INSERT INTO DEPARTMENT2 VALUES ('T3','개발3팀','L2');
--INSERT 잘 되었는지 확인
SELECT * FROM DEPARTMENT2; -- 다시 개발 1,2,3팀 생성.(현재 트랜잭션에 있는 상태)
COMMIT; -- DB에 영구반영
SELECT * FROM DEPARTMENT2;
ROLLBACK;
--커밋후 ROLLBACK되는지 확인하기
SELECT * FROM DEPARTMENT2;-- 이미 커밋을 한 후라서 ROLLBACK수행안됨.
----------------------------------------------------------------------------
--SAVE POINT 확인
INSERT INTO DEPARTMENT2 VALUES ('T4','개발4팀','L2');
SAVEPOINT "SP1";--SAVE POINT 지정 

INSERT INTO DEPARTMENT2 VALUES ('T5','개발5팀','L2');
SAVEPOINT "SP2";--SAVE POINT 지정 

INSERT INTO DEPARTMENT2 VALUES ('T6','개발6팀','L2');
SAVEPOINT "SP3";--SAVE POINT 지정 

SELECT * FROM DEPARTMENT2;--개발 6팀까지 조회됨

ROLLBACK TO "SP1";--SP1지점으로 롤백하기

SELECT * FROM DEPARTMENT2;--개발 4팀 남음

ROLLBACK TO "SP2";--SQL Error [1086] [72000]: ORA-01086: 'SP2' 저장점이 이 세션에 설정되지 않았거나 부적합합니다.
--ROLLBACK TO SP1 구문 수행 시 이후에 설정된 SP2,SP3도 삭제됨.

--다시 5팀,6팀 생성
INSERT INTO DEPARTMENT2 VALUES ('T5','개발5팀','L2');
SAVEPOINT "SP2";--SAVE POINT 지정 

INSERT INTO DEPARTMENT2 VALUES ('T6','개발6팀','L2');
SAVEPOINT "SP3";--SAVE POINT 지정 

SELECT * FROM DEPARTMENT2;--456팀은 아직 트랜잭션에 잇음 COMMIT한적없으니

--개발팀 전체 삭제 해보기
DELETE FROM DEPARTMENT2
WHERE DEPT_ID LIKE 'T%';

SELECT * FROM DEPARTMENT2;--삭제확인

ROLLBACK TO "SP2";

SELECT * FROM DEPARTMENT2;--개발 6팀만 없음 : SP2지점 SAVEPOINT전에 개발4,5팀 있으니까

ROLLBACK TO "SP1";
SELECT * FROM DEPARTMENT2;--개발 4팀만 남아있음.

--ROLLBACK 수행
ROLLBACK;
SELECT * FROM DEPARTMENT2;--마지막 커밋시점으로 가면 개발 1,2,3팀만 있음