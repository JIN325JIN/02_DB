--kh_shop이라는 사용자를 만들려면 sys로부터 사용자 권한을 부여받아햠

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;--이전구문 허용

CREATE USER kh_shop IDENTIFIED BY 1234;-- 생성

GRANT CREATE SESSION TO kh_shop;--권한부여

GRANT CREATE TABLE TO kh_shop;-- 테이블 만들 권한

ALTER USER kh_shop DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;-- 용량.
------------------------------------------------------------------------
--문제를 풀기위한 테이블 만들기--
CREATE TABLE CATEGORIES(
CATEGORY_ID NUMBER PRIMARY KEY,
CATEGORY_NAME VARCHAR2(100)
);

ALTER TABLE CATEGORIES
ADD CONSTRAINT CATEGORY_NAME_UNIQUE UNIQUE(CATEGORY_NAME);

COMMENT ON COLUMN CATEGORIES.CATEGORY_ID IS '카테고리 ID';
COMMENT ON COLUMN CATEGORIES.CATEGORY_NAME IS '카테고리 이름';

INSERT INTO CATEGORIES VALUES (1,'스마트폰');
INSERT INTO CATEGORIES VALUES (2,'TV');
INSERT INTO CATEGORIES VALUES (3,'GAMING');

SELECT * FROM CATEGORIES;-- 첫번째 테이블 확인
-----------------------------------------------------------------------------
CREATE TABLE PRODUCTS(
PRODUCT_ID NUMBER PRIMARY KEY,
PRODUCT_NAME VARCHAR2(100) NOT NULL,
CATEGORY NUMBER CONSTRAINT CATEGORY_FK REFERENCES CATEGORIES,
PRICE NUMBER DEFAULT 0,
STOCK_QUANTITY NUMBER DEFAULT 0);

COMMENT ON COLUMN PRODUCTS.PRODUCT_ID IS '상품 코드';
COMMENT ON COLUMN PRODUCTS.PRODUCT_NAME IS '상품 이름';
COMMENT ON COLUMN PRODUCTS.CATEGORY IS '카테고리';
COMMENT ON COLUMN PRODUCTS.PRICE IS '가격';
COMMENT ON COLUMN PRODUCTS.STOCK_QUANTITY IS '재고량';

INSERT INTO PRODUCTS VALUES (101,'APPLE IPHONE 12',1,1500000,30);
INSERT INTO PRODUCTS VALUES (102,'SAMSUNG GALAXY S24',1,1800000,50);
INSERT INTO PRODUCTS VALUES (201,'LG OLED TV',2,3600000,10);
INSERT INTO PRODUCTS VALUES (301,'SONY PLAYSTATION5',3,700000,15);

SELECT * FROM PRODUCTS;-- 두번째 테이블 확인
--------------------------------------------------------------------
CREATE TABLE CUSTOMERS(
CUSTOMER_ID NUMBER PRIMARY KEY,
NAME VARCHAR2(20) NOT NULL,
GENDER CHAR(3) CONSTRAINT GENDER_CHECK CHECK(GENDER IN ('남','여')),
ADDRESS VARCHAR2(100),
PHONE VARCHAR2(30)
);

COMMENT ON COLUMN CUSTOMERS.CUSTOMER_ID IS '고객 ID';
COMMENT ON COLUMN CUSTOMERS.NAME IS '이름';
COMMENT ON COLUMN CUSTOMERS.GENDER IS '성별';
COMMENT ON COLUMN CUSTOMERS.ADDRESS IS '주소';
COMMENT ON COLUMN CUSTOMERS.PHONE IS '전화번호';

INSERT INTO CUSTOMERS VALUES (1,'홍길동','남','서울시 성동구 왕십리','010-1111-2222');
INSERT INTO CUSTOMERS VALUES (2,'유관순','여','서울시 종로구 안국동','010-3333-1111');

SELECT * FROM CUSTOMERS; -- 세번째 테이블 확인
--------------------------------------------------------------------------
CREATE TABLE ORDERS(
ORDER_ID NUMBER PRIMARY KEY,
ORDER_DATE DATE DEFAULT TRUNC(SYSDATE),--절삭 까먹음
STATUS CHAR(1) CONSTRAINT STATUS_CHECK CHECK(STATUS IN ('Y','N')),
CUSTOMER_ID NUMBER CONSTRAINT CUSTOMER_ID_FK REFERENCES CUSTOMERS(CUSTOMER_ID) ON DELETE CASCADE
);

COMMENT ON COLUMN ORDERS.ORDER_ID IS '주문 번호';
COMMENT ON COLUMN ORDERS.ORDER_DATE IS '주문 일';
COMMENT ON COLUMN ORDERS.STATUS IS '처리 상태';
COMMENT ON COLUMN ORDERS.CUSTOMER_ID IS '고객 ID';

INSERT INTO ORDERS VALUES (576,'2024-02-29','N',1);
INSERT INTO ORDERS VALUES (978,'2024-03-11','Y',2);
INSERT INTO ORDERS VALUES (777,'2024-03-11','N',2);
INSERT INTO ORDERS VALUES (134,'2022-12-25','Y',1);
INSERT INTO ORDERS VALUES (499,'2020-01-03','Y',1);

SELECT * FROM ORDERS; -- 네번째 테이블 확인
----------------------------------------------------------------------
CREATE TABLE ORDER_DETAILS(
ORDER_DETAIL_ID NUMBER PRIMARY KEY,
ORDER_ID NUMBER CONSTRAINT ORDER_ID_FK REFERENCES ORDERS(ORDER_ID) ON DELETE CASCADE,
PRODUCT_ID NUMBER CONSTRAINT PRODUCT_ID_FK REFERENCES PRODUCTS(PRODUCT_ID) ON DELETE SET NULL,
QUANTITY NUMBER,
PRICE_PER_UNIT NUMBER
);

COMMENT ON COLUMN ORDER_DETAILS.ORDER_DETAIL_ID IS '주문 상세';
COMMENT ON COLUMN ORDER_DETAILS.ORDER_ID IS '주문 번호';
COMMENT ON COLUMN ORDER_DETAILS.PRODUCT_ID IS '상품 코드';
COMMENT ON COLUMN ORDER_DETAILS.QUANTITY IS '수량';
COMMENT ON COLUMN ORDER_DETAILS.PRICE_PER_UNIT IS '가격';

INSERT INTO ORDER_DETAILS VALUES (111,576,101,1,1500000);
INSERT INTO ORDER_DETAILS VALUES (222,978,201,2,3600000);
INSERT INTO ORDER_DETAILS VALUES (333,978,102,1,1800000);
INSERT INTO ORDER_DETAILS VALUES (444,777,301,5,700000);
INSERT INTO ORDER_DETAILS VALUES (555,134,102,1,1800000);
INSERT INTO ORDER_DETAILS VALUES (666,499,201,3,3600000);

SELECT * FROM ORDER_DETAILS; --다섯번째 테이블 확인
-----------------------------------------------------------------------------------------
--DML 과 DDL 섞어서 만들지 말것...!!




-----------------------------------------------------------------------------------------

--1. 쇼핑몰 관리자가 주문은 받았으나, 아직 처리가 안된 주문을 처리하려고한다. 
--현재 주문 내역 중 아직 처리되지 않은 주문을 조회하시오.(고객명, 주문일, 처리상태)
SELECT NAME AS "고객명 ",TO_CHAR(ORDER_DATE,'YYYY/MM/DD HH24: MI:SS') AS "주문 일",STATUS AS "처리상태"
FROM CUSTOMERS
JOIN ORDERS USING (CUSTOMER_ID)
WHERE STATUS ='N';

--2. 홍길동 고객이 2024년도에 본인이 주문한 전체 내역을 조회하고자 한다.
--주문번호, 주문날짜, 처리상태 조회하시오(ORDER_DETAILS.ORDER_ID,ORDERS.ORDER_DATE,ORDERS.STATUS)

SELECT ORDER_ID AS "주문 번호 ",TO_CHAR (ORDER_DATE, 'YYYY/MM/DD HH24:MI:SS') AS "주문 날짜",STATUS AS "처리 상태"
FROM ORDERS
JOIN ORDER_DETAILS USING (ORDER_ID)
JOIN CUSTOMERS USING (CUSTOMER_ID)
WHERE NAME ='홍길동' AND ORDER_DATE LIKE '24%';-- 왜 LIKE '2024-%'하면 조회안될까?


--3. 유관순 고객이 지금껏 주문한 상품의 수량 별 금액을 조회하려고 한다.
--주문번호, 상품명, 수량, 개별금액, 주문별금액을 조회하시오.

SELECT ORDER_ID AS "주문 번호",PRODUCT_NAME AS "상품 명",QUANTITY AS "수량",PRICE_PER_UNIT AS "개별 금액",PRICE_PER_UNIT * QUANTITY AS"주문별 금액 합계"
FROM ORDER_DETAILS 
JOIN ORDERS o USING (ORDER_ID)
JOIN PRODUCTS p USING (PRODUCT_ID)
JOIN CUSTOMERS c ON c.CUSTOMER_ID = o.CUSTOMER_ID
JOIN CATEGORIES ct ON ct.CATEGORY_ID  =p.CATEGORY
WHERE NAME = '유관순'
ORDER BY QUANTITY DESC ;--수량순으로 정렬?


