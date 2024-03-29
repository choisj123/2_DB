

/* - 데이터 딕셔너리란?
 * 
 * 자원을 효율적으로 관리하기 위한 다양한 정보를 저장하는 시스템 테이블
 * 데이터 딕셔너리는 사용자가 테이블을 생성하거나 사용자를 변경하는 등의
 * 작업을 할 때 데이터베이스 서버에 의해 자동으로 갱신되는 테이블
 *
 */

-------------------------------------------------------------------------------------------------------------------------

/* DQL(DATA QUERY LANGUAGE) : 데이터 질의(조회) 언어 --> SELECT
 * DML(DATA MANIPULATION LANGUAGE) : 데이터 조작 언어 --> INSERT 삽입, UPDATE 수정, DELETE 삭제 / 데이블에 있는 데이터를 삽입, 수정, 삭제
 * TCL(TRANSACTION CONTROL LANGUAGE) : 트랜잭션 제어 언어 --> COMMIT, ROLLBACK / DML에서 수행한 내용을 COMMIT, ROLLBACK
 * DDL(DATA DEFINITION LANGUAGE) : 데이터 정의 언어 --> CREATE, DROP, ALTER 
 * ----> 객체(OBJECT)를 만들고(CREATE), 수정하고(ALTER), 삭제(DROP) 등
 * -----> 데이터의 전체 구조를 정의하는 언어로 DB관리자, 설계자가 사용함
 * 
 * 오라클에서의 객체 : 테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE),
 * 						인덱스(INDEX), 패키지(PACKAGE), 트리거(TRIGGER),
 * 						프로시져(PROCEDURE), 함수(FUNCTION), 동의어(SYNOMYM), 사용자(USER)
 * 
 * 
 */ 
----------------------------------------------------------------------------------------------------------------------------


-- CREATE
-- 테이블이나 인덱스, 뷰 등 다양한 데이터베이스 객체를 생성하는 구문
-- 테이블로 생성된 객체는 DROP구문을 통해 제거할 수 있음

--1. 테이블 생성하기
-- 테이블이란?
-- 행과 열로 구성되는 가장 기본적인 데이터베이스 객체
-- 테이터베이스 내에서 모든 데이터는 테이블을 통해서 저장된다

/*
 [표현식]

CREATE TABLE 테이블명 (
	컬렴명 자료형(크기),
	컬렴명 자료형(크기),
	컬렴명 자료형(크기),
	 ....
 );
 
*/


/* 자료형
 * 
 * NUMBER : 숫자형(정수, 실수)
 * 
 * CHAR(크기) : 고정길이 문자형 (최대 2000 BYTE)
 * --> EX) CHAR(10) 컬럼에 'ABC' 3 BYTE 문자열만 저장해도 10 BYTE 저장공간을 모두 사용
 * 
 * VARCHAR2(크기) : 가변길이 문자형 (최대 4000 BYTE)
 * --> EX) VARCHAR2(10) 컬럼에 'ABC' 3 BYTE 문자열만 저장하면 나머지 7BYTE는 자동으로 반환함
 * 
 * DATE : 날짜 타입
 * BLOB : 대용량 이진 데이터(4GB)
 * CLOB : 대용량 문자 데이터(4GB)
 * 
 * 1BYTE * 1024 = 1KB
 * 1KB * 1024 = 1MB
 * 1MB * 1024 = 1GB * 4 = 4GB
 * 
 * 
 */

DROP TABLE MEMBER;

-- MEMBER 테이블 생성
CREATE TABLE MEMBER /* "MEMBER"*/(
	MEMBER_ID VARCHAR2(20),
	MEMBER_PWD VARCHAR2(20),
	MEMBER_NAME VARCHAR2(30),
	MEMBER_SSN CHAR(14),
	ENROLL_DATE DATE DEFAULT SYSDATE
);

-- SQL 작성법 : 대문자 작성(권장), 연결된 단어 사이에는 "_"(언더바) 사용!
-- 문자 인코딩 UTF-8 : 영어, 숫자 1BYTE, 한글, 특수문자 등은 3BYTE 취급

-- 만든 테이블 확인
SELECT * FROM MEMBER/* "MEMBER"*/;


-- 2. 컬럼에 주석 달기
-- [표현식]
-- COMMENT ON COLUMN 테이블명.컬럼명 IS '주석 내용';

COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원 아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '회원 비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원 이름';
COMMENT ON COLUMN MEMBER.MEMBER_SSN IS '회원 주민번호';
COMMENT ON COLUMN MEMBER.ENROLL_DATE IS '회원 가입일'; 



-- USER_TABLES : 사용자가 작성한 테이블을 확인하는 뷰
-- 데이터 딕셔너리에 정의되어 있음
SELECT * FROM USER_TABLES;
SELECT TABLE_NAME, NUM_ROWS FROM USER_TABLES;


-- MEMBER 테이블에 샘플 테이터 삽입
-- INSERT INTO 테이블명 컬럼명 VALUES(값1, 값2....);

INSERT INTO MEMBER VALUES('MEM01', '12345ABC', '홍길동', '991224-1234567', DEFAULT) ;
																		-- SYSDATE

-- INSERT / UPDATE 시 컬럼값으로 DEFAULT를 작성하면
-- 테이블 생성 시 해당 컬럼에 지정된 DEFAULT 값으로 삽입이 된다!

SELECT * FROM MEMBER;

INSERT INTO MEMBER VALUES('MEM02', '12345DEF', '김바보', '870602-1234876', SYSDATE);
INSERT INTO MEMBER VALUES('MEM03', '12345GHI', '이바보', '650812-1234927', DEFAULT);

COMMIT;

-- INSERT 시 미작성 하는 경우(가입일) DEFAULT 값이 반영됨
INSERT INTO MEMBER(MEMBER_ID, MEMBER_PWD, MEMBER_NAME)
VALUES('MEM04', 'ABC1237', '박바보');

SELECT * FROM MEMBER;


--  ** JDBC에서 날짜를 입력 받았을 때 삽입하는 방법 **
-- '2023-01-13 10:33:27'
INSERT INTO MEMBER VALUES ('MEM05', 'PASS05', '김준수', '121212-1234563', 
					TO_DATE('2023-01-13 10:33:27', 'YYYY-MM-DD HH24:MI:SS')
);

SELECT * FROM MEMBER;
COMMIT;

--MEMBER2 테이블(아이디, 비밀번호, 이름, 전화번호)

DROP TABLE MEMBER2;

CREATE TABLE MEMBER2 (
	MEMBER_ID VARCHAR2(20),
	MEMBER_PWD VARCHAR2(20),
	MEMBER_NAME VARCHAR2(30),
	MEMBER_TEL NUMBER
);


SELECT * FROM MEMBER2;

COMMENT ON COLUMN MEMBER2.MEMBER_ID IS '회원 아이디';
COMMENT ON COLUMN MEMBER2.MEMBER_PWD IS '회원 비밀번호';
COMMENT ON COLUMN MEMBER2.MEMBER_NAME IS '회원 이름';
COMMENT ON COLUMN MEMBER2.MEMBER_TEL IS '전화번호';


INSERT INTO MEMBER2 VALUES('MEM01', 'PASS01', '이현경', 7712341234);
INSERT INTO MEMBER2 VALUES('MEM02', 'PASS02', '최정오', 01012341234);
--> NUMBER타입 컬럼에 데이터 삽입시 제일 앞에 0이 있으면 자동으로 제거함
----> 전화번호, 주민등록번호처럼 숫자로만 되어있는 데이터지만 
	-- 0으로 시작할 가능성이 있으면 CHAR 또는 VARCHAR2 같은 문자형 사용해야 한다!


---------------------------------------------------------------------------------------

-- 제약 조건(CONSTRAINTS)
-- NOT NULL

/*
 * 사용자가 원하는 조건의 데이터만 유지하기 위해서 특정 컬럼에 설정하는 제약
 * 데이터 무결성 보장을 목적으로 함
 * --> 중복데이터 X 
 * 
 * + 입력 데이터에 문제가 없는지 자동으로 검사하는 목적
 * + 데이터의 수정 / 삭제 가능 여부 검사 등을 목적으로 한다
 * ---> 제약 조건을 위배하는 DML 구문은 수행할 수 없음!
 * 
 * 제약조건 종류
 * PRIMARY KEY / NOT NULL / UNIQUE / CHECK / FOREIGN KEY
 * 
 * 
 */


-- USER_CONSTRANINTS : 사용자가 작성한 제약조건을 확인하는 딕셔너리 뷰
SELECT * FROM USER_CONSTRAINTS;

-- 1. NOT NULL
-- 해당 컬럼에 반드시 값이 기록되어야 하는 경우 사용
-- 삽입/수정 시 NULL값을 허용하지 않도록 컬럼레벨에서 제한

-- * 컬럼 레벨? 테이블 생성 시 컬럼을 정의하는 부분에 작성하는것

DROP TABLE USER_USED_NN; 

CREATE TABLE USER_USED_NN (
	USER_NO NUMBER NOT NULL, -- 사용자 번호(모든 사용자는 사용자 번호가 있어야 한다)
						   	 --> 컬럼 레벨 제약 조건 설정
	USER_ID VARCHAR2(20),
	USER_PWD VARCHAR2(30),
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50)
);

INSERT INTO USER_USED_NN 
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-1234', 'hong_dd12@kh.or.kr');

SELECT * FROM USER_USED_NN ;

INSERT INTO USER_USED_NN 
VALUES(NULL, NULL, NULL, NULL, '남', '010-1234-1234', 'hong_dd12@kh.or.kr');
-- SQL Error [1400] [23000]: ORA-01400: cannot insert NULL into ("KH"."USER_USER_NN"."USER_NO")
--> NOT NULL 제약조건에 위배되어 오류 발생


---------------------------------------------------------------------------------------------------

-- 2. UNIQUE 제약 조건
-- 컬럼에 입력값에 대해서 중복을 제한하는 제약조건
-- 컬럼레벨에서 설정 가능, 테이블 레벨에서 설정 가능
-- 단, UNIQUE 제약조건이 설정된 컬럼에 NULL 값은 중복으로 삽입 가능

-- * 테이블 레벨 : 테이블 생성시 컬럼 정의가 끝난 후 마지막에 작성
-- * 제약조건 지정방벙
-- 1) 컬럼 레벨 : [CONSTRAINT 제약조건명] 제약조건 
-- 2) 테이블 레벨 : [CONSTRAINT 제약조건명] 제약조건(컬럼명) 

DROP TABLE USER_USED_UK;

CREATE TABLE USER_USED_UK(
	USER_NO NUMBER ,
	USER_ID VARCHAR(20) UNIQUE, --컬럼 레벨
	--USER_ID VARCHAR(20),
	USER_PWD VARCHAR2(30),
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50)
	--테이블 레벨
	--CONSTRAINT USER_ID_U UNIQUE(USER_ID) --테이블레벨에서 제약조건 지정
);

CREATE TABLE USER_USED_UK(
	USER_NO NUMBER NOT NULL,
	USER_ID VARCHAR(20),
	USER_PWD VARCHAR2(30),
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50),
	--테이블 레벨
	UNIQUE(USER_ID) --테이블레벨에서 제약조건 지정
);


--SQL Error [2261] [42000]: ORA-02261: such unique or primary key already exists in the table


SELECT * FROM USER_USED_UK;

DROP TABLE USER_USED_UK; 

INSERT INTO USER_USED_UK 
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-1234', 'hong_dd12@kh.or.kr');

INSERT INTO USER_USED_UK 
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-1234', 'hong_dd12@kh.or.kr'); 
--오류 : ID uniqe 제약
INSERT INTO USER_USED_UK 
VALUES(1, 'user02', 'pass01', '홍길동', '남', '010-1234-1234', 'hong_dd12@kh.or.kr');

INSERT INTO USER_USED_UK 
VALUES(1, NULL, 'pass01', '홍길동', '남', '010-1234-1234', 'hong_dd12@kh.or.kr'); 
--> 아이디에 NULL값 확인 가능

INSERT INTO USER_USED_UK 
VALUES(1, NULL, 'pass01', '홍길동', '남', '010-1234-1234', 'hong_dd12@kh.or.kr'); 
-->NULL값 중복 삽입 가능


SELECT * FROM USER_USED_UK;



---------------------------------------------------------------------------------------------------

-- UNIQUE 복합키
-- 두개 이상의 컬럼을 묶어서 하나의 UNIQUE 제약 조건을 설정함

-- * 복합키 지정은 테이블 레벨에서만 가능하다!
-- * 복합키는 지정된 모든 컬럼의 값이 같을 때 위배된다

DROP TABLE USER_USED_UK2; 

CREATE TABLE USER_USED_UK2(
	USER_NO NUMBER ,
	USER_ID VARCHAR(20),
	USER_PWD VARCHAR2(30) NOT NULL,
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50),
	--테이블 레벨 UNIQUE 복합키 지정
	CONSTRAINT USER_ID_NAME_U UNIQUE(USER_ID, USER_NAME)
	
	
);


SELECT * FROM USER_USED_UK2;

 
INSERT INTO USER_USED_UK2 
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-1234', 'hong_dd12@kh.or.kr');

INSERT INTO USER_USED_UK2 
VALUES(2, 'user02', 'pass01', '홍길동', '남', '010-1234-1234', 'hong_dd12@kh.or.kr');
-- 아이디 다름

INSERT INTO USER_USED_UK2 
VALUES(3, 'user01', 'pass01', '고길동', '남', '010-1234-1234', 'hong_dd12@kh.or.kr');
--이름 다름

INSERT INTO USER_USED_UK2 
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-1234', 'hong_dd12@kh.or.kr');
--아이디, 이름 다 같음
-- SQL Error [1] [23000]: ORA-00001: unique constraint (KH.USER_ID_NAME_U) violated


---------------------------------------------------------------------------------------------------


-- 3. PRIMARY KEY(기본키) 제약조건

-- 테이블에서 한 행의 정보를 찾기 위해 사용할 컬럼을 위미함
-- 테이블에 대한 식별자(학번, 회원번호, 사번 등) 역할을 함

-- NOT NULL + UNIQUE 제약조건의 의미 --> 중복되지 않는 값이 필수로 존재해야 함!
-- 한 테이블 당 한개만 설정 할 수 있음
-- 컬럼 레벨, 테이블 레벨 둘다 설정 가능함

DROP TABLE USER_USED_PK; 

CREATE TABLE USER_USED_PK(
	USER_NO NUMBER CONSTRAINT USER_NO_PK PRIMARY KEY, --컬럼 레벨
	USER_ID VARCHAR(20) UNIQUE,
	USER_PWD VARCHAR2(30) NOT NULL,
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50)	
	-- 테이블 레벨
	-- CONSTRAINT USER_NO_PK PRIMARY KEY(USER_NO)
);

CREATE TABLE USER_USED_PK(
	USER_NO NUMBER ,
	USER_ID VARCHAR(20) UNIQUE,
	USER_PWD VARCHAR2(30) NOT NULL,
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50),
	CONSTRAINT USER_NO_PK PRIMARY KEY(USER_NO)
);

SELECT * FROM USER_USED_PK;

INSERT INTO USER_USED_PK
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-1234', 'hong_dd12@kh.or.kr');

INSERT INTO USER_USED_PK
VALUES(1, 'user02', 'pass02', '고길순', '여', '010-1234-5678', 'go_gs12@kh.or.kr');
-- SQL Error [1] [23000]: ORA-00001: unique constraint (KH.USER_NO_PK) violated

INSERT INTO USER_USED_PK
VALUES(2, 'user02', 'pass02', '고길순', '여', '010-1234-5678', 'go_gs12@kh.or.kr');


INSERT INTO USER_USED_PK
VALUES(NULL, 'user03', 'pass03', '고길동', '남', '010-1234-5678', 'go_gs12@kh.or.kr');
--SQL Error [1400] [23000]: ORA-01400: cannot insert NULL into ("KH"."USER_USED_PK"."USER_NO")
--> 기본키가 NULL이므로 오류


---------------------------------------------------------------------------------------------------

--4. FOREIGN KEY(외부키 / 외래키) 제약조건
-- 참조된 다른 테이블의 컬럼이 제공하는 값만 사용할 수 있음
-- FOREIGN KEY 제약조건에 의해서 테이블 간의 관계가 형성됨
-- 제공되는 값 외에는 NULL을 사용할 수 있음

-- 컬럼 레벨일 경우 
-- 컬럼명 자료형(크기) [CONSTRAINT 이름] REFERENCES 참조할테이블명 [(참조할컬럼)] [삭제룰]

-- 테이블 레벨일 경우
-- [CONSTRAINT 이름] FOREIGN KEY(적용할컬럼명) REFERENCES 참조할테이블명 [(참조할컬럼)] [삭제룰]


CREATE TABLE USER_GRADE(
	GRADE_CODE NUMBER PRIMARY KEY,
	GRADE_NAME VARCHAR2(30) NOT NULL
);

INSERT INTO USER_GRADE VALUES(10, '일반회원');
INSERT INTO USER_GRADE VALUES(20, '우수회원');
INSERT INTO USER_GRADE VALUES(30, '특별회원');

SELECT * FROM USER_GRADE;

CREATE TABLE USER_USED_FK(
	USER_NO NUMBER PRIMARY KEY,
	USER_ID VARCHAR2(20) UNIQUE,
	USER_PWD VARCHAR2(30) NOT NULL,
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50),
	GRADE_CODE NUMBER CONSTRAINT GRADE_CODE_FK REFERENCES USER_GRADE /*(GRADE_CODE)*/
																		--PK
	--컬럼명 미작성시 USER_GRADE 테이블의 PK를 자동 참조
);

SELECT * FROM USER_USED_FK;

COMMIT;


INSERT INTO USER_USED_FK 
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong_gd12@kh.or.kr', 10);

INSERT INTO USER_USED_FK 
VALUES(2, 'user02', 'pass02', '고길동', '남', '010-5678-5678', 'go_gd12@kh.or.kr', 20);

INSERT INTO USER_USED_FK 
VALUES(3, 'user03', 'pass03', '최길동', '여', '010-5554-5678', 'choi_gd12@kh.or.kr', 30);

INSERT INTO USER_USED_FK 
VALUES(4, 'user04', 'pass04', '이길동', '남', '010-1944-5678', 'choi_gd12@kh.or.kr', 10);

INSERT INTO USER_USED_FK 
VALUES(5, 'user05', 'pass05', '박길동','여', '010-1884-5678', 'park_gd12@kh.or.kr', null);

INSERT INTO USER_USED_FK 
VALUES(6, 'user06', 'pass06', '강길동','여', '010-1846-5382', 'kang_gd12@kh.or.kr', 50);
--SQL Error [2291] [23000]: ORA-02291: integrity constraint (KH.GRADE_CODE_FK) violated - parent key not found
--> 50이라는 값은 USER_GRADE 테이블의 GRADE_CODE 컬럼에서 제공하는 값이 아니므로
--	외래키 제약 조건에 위배되어 오류 발생


SELECT * FROM USER_USED_FK ORDER BY USER_NO;

COMMIT;



---------------------------------------------------------------------------------------------------


-- FOREIGM KEY 삭제 옵션
-- 부모 테이블의 데이터 삭제 시 자식 테이블의 데이터를 어떤식으로 
-- 처리할지에 대한 내용을 설정할 수 있다


SELECT * FROM USER_GRADE;
SELECT * FROM USER_USED_FK;


-- 1) ON DELETE RESTRICTED(삭제 제한)로 기본 지정되어 있음
-- FOREIGN KEY로 지정된 컬럼에서 사용되고 있는 값일 경우
-- 제공하는 컬럼의 값은 삭제하지 못함
DELETE FROM USER_GRADE WHERE GRADE_CODE = 30;
--SQL Error [2292] [23000]: ORA-02292: integrity constraint (KH.GRADE_CODE_FK) violated - child record found

UPDATE USER_USED_FK SET GRADE_CODE = 10
WHERE USER_NAME = '고길동';

DELETE FROM USER_GRADE WHERE GRADE_CODE = 30;

UPDATE USER_USED_FK SET GRADE_CODE = 30
WHERE GRADE_CODE = 20;

SELECT * FROM USER_USED_FK
ORDER BY USER_NO ;


-- GRADE_CODE 중 20은 외래키로 참조되고 있지 않으므로 삭제 가능
DELETE FROM USER_GRADE WHERE GRADE_CODE = 20;

SELECT * FROM USER_GRADE;

ROLLBACK;


SELECT * FROM USER_GRADE;

SELECT * FROM USER_USED_FK
ORDER BY USER_NO ;

-- 2) ON DELETE SET NULL : 부모키 삭제 시 자식키를 NULL로 변경하는 옵션

CREATE TABLE USER_GRADE2(
	GRADE_CODE NUMBER PRIMARY KEY,
	GRADE_NAME VARCHAR2(30) NOT NULL
);

SELECT * FROM USER_GRADE2;

INSERT INTO USER_GRADE2 VALUES(10, '일반회원');
INSERT INTO USER_GRADE2 VALUES(20, '우수회원');
INSERT INTO USER_GRADE2 VALUES(30, '특별회원');

DROP TABLE USER_USED_FK2;

CREATE TABLE USER_USED_FK2(
	USER_NO NUMBER PRIMARY KEY,
	USER_ID VARCHAR2(20) UNIQUE,
	USER_PWD VARCHAR2(30) NOT NULL,
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50),
	GRADE_CODE NUMBER CONSTRAINT GRADE_CODE_FK2 REFERENCES USER_GRADE2 ON DELETE SET NULL
);

SELECT * FROM USER_USED_FK2;


INSERT INTO USER_USED_FK2
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong_gd12@kh.or.kr', 10);

INSERT INTO USER_USED_FK2 
VALUES(2, 'user02', 'pass02', '고길동', '남', '010-5678-5678', 'go_gd12@kh.or.kr', 10);

INSERT INTO USER_USED_FK2 
VALUES(3, 'user03', 'pass03', '최길동', '여', '010-5554-5678', 'choi_gd12@kh.or.kr', 30);

INSERT INTO USER_USED_FK2 
VALUES(4, 'user04', 'pass04', '이길동', '남', '010-1944-5678', 'choi_gd12@kh.or.kr', NULL);


COMMIT;

SELECT * FROM USER_USED_FK2;

-- 부모 테이블인 USER_GRADE2에서 GRADE_CODE= 10 삭제 

DELETE FROM USER_GRADE2
WHERE GRADE_CODE = 10;

SELECT * FROM USER_USED_FK2;
SELECT * FROM USER_GRADE2;


-- 3) ON DELETE CASCADE : 부모키 삭제시 자식키도 함께 삭제됨
-- 부모키 삭제시 값을 사용하는 자식 테이블의 컬럼에 해당하는 행이 삭제가 됨

DROP TABLE USER_GRADE3;

CREATE TABLE USER_GRADE3(
	GRADE_CODE NUMBER PRIMARY KEY,
	GRADE_NAME VARCHAR2(30) NOT NULL
);

SELECT * FROM USER_GRADE3;

INSERT INTO USER_GRADE3 VALUES(10, '일반회원');
INSERT INTO USER_GRADE3 VALUES(20, '우수회원');
INSERT INTO USER_GRADE3 VALUES(30, '특별회원');

DROP TABLE USER_USED_FK3; 

-- ON DELETE CASCADE 삭제 옵션이 적용된 테이블 생성
CREATE TABLE USER_USED_FK3(
	USER_NO NUMBER PRIMARY KEY,
	USER_ID VARCHAR2(20) UNIQUE,
	USER_PWD VARCHAR2(30) NOT NULL,
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50),
	GRADE_CODE NUMBER, 
	CONSTRAINT GRADE_CODE_FK3 FOREIGN KEY(GRADE_CODE) 
	REFERENCES USER_GRADE3(GRADE_CODE) ON DELETE CASCADE
);

SELECT * FROM USER_USED_FK3;


INSERT INTO USER_USED_FK3
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong_gd12@kh.or.kr', 10);

INSERT INTO USER_USED_FK3 
VALUES(2, 'user02', 'pass02', '고길동', '남', '010-5678-5678', 'go_gd12@kh.or.kr', 10);

INSERT INTO USER_USED_FK3 
VALUES(3, 'user03', 'pass03', '최길동', '여', '010-5554-5678', 'choi_gd12@kh.or.kr', 30);

INSERT INTO USER_USED_FK3 
VALUES(4, 'user04', 'pass04', '이길동', '남', '010-1944-5678', 'choi_gd12@kh.or.kr', NULL);


COMMIT;


SELECT * FROM USER_GRADE3;
SELECT * FROM USER_USED_FK3;


-- 부모테이블인 USER_GRADE3에서 GRADE_CODE = 10 삭제

DELETE FROM USER_GRADE3
WHERE GRADE_CODE = 10;


SELECT * FROM USER_GRADE3;
SELECT * FROM USER_USED_FK3;






--1/19
-----------------------------------------------------------------------------------------

-- 5. CHECK 제약 조건 : 컬럼에 기록되는 값에 조건을 설정 할 수 있음
-- CHECK (컬럼명 비교연산자 비교값)
-- 주의 : 비교값은 리터럴만 사용할 수 있음, 변하는 값 or 함수 사용 못함

DROP TABLE USER_USED_CHECK; 

CREATE TABLE USER_USED_CHECK(
	USER_NO NUMBER PRIMARY KEY,
	USER_ID VARCHAR2(20) UNIQUE,
	USER_PWD VARCHAR2(30) NOT NULL,
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10) CONSTRAINT GENDER_CHECK CHECK(GENDER IN ('남', '여')),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50)
);

INSERT INTO USER_USED_CHECK
VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-1234', 'HOND@TEST.COM');


SELECT * FROM USER_USED_CHECK;

INSERT INTO USER_USED_CHECK
VALUES(2, 'USER01', 'PASS01', '홍길동', '남자', '010-1234-1234', 'HOND@TEST.COM');

-- ORA-02290: 체크 제약조건(KH.GENDER_CHECK)이 위배되었습니다
-- CHECK 제약조건으로 GENDER컬럼을 설정했기 때문에, 남 또는 여 만 기록 가능한데
-- 남자라는 조건 이외의 값이 들어와 에러 발생


--- [연습 문제]
-- 회원가입용 테이블 생성(USER_TEST)
-- 컬럼명 : USER_NO(회원번호) - 기본키(PK_USER_TEST), 
--         USER_ID(회원아이디) - 중복금지(UK_USER_ID),
--         USER_PWD(회원비밀번호) - NULL값 허용안함(NN_USER_PWD),
--         PNO(주민등록번호) - 중복금지(UK_PNO), NULL 허용안함(NN_PNO),
--         GENDER(성별) - '남' 혹은 '여'로 입력(CK_GENDER),
--         PHONE(연락처),
--         ADDRESS(주소),
--         STATUS(탈퇴여부) - NOT NULL(NN_STATUS), 'Y' 혹은 'N'으로 입력(CK_STATUS)
-- 각 컬럼의 제약조건에 이름 부여할 것
-- 5명 이상 INSERT할 것
CREATE TABLE USER_TEST(
	USER_NO NUMBER CONSTRAINT PK_USER_TEST PRIMARY KEY,
	USER_ID VARCHAR2(20) CONSTRAINT UK_USER_ID UNIQUE,
	USER_PWD VARCHAR2(20) CONSTRAINT NN_USER_PWD NOT NULL,
	PNO VARCHAR2(20) CONSTRAINT NN_PNO NOT NULL,
	GENDER VARCHAR2(3) CONSTRAINT CK_GENDER CHECK(GENDER IN ('남', '여')),
	PHONE VARCHAR2(20),
	ADDRESS VARCHAR2(100),
	STATUS VARCHAR2(3) DEFAULT 'N' CONSTRAINT NN_STATUS NOT NULL,
	
	
	CONSTRAINT CK_STATUS CHECK(STATUS IN ('Y', 'N')),
	CONSTRAINT UK_PNO UNIQUE (PNO)
);


COMMENT ON COLUMN USER_TEST.USER_NO IS '회원번호';
COMMENT ON COLUMN USER_TEST.USER_ID IS '회원아이디';
COMMENT ON COLUMN USER_TEST.USER_PWD IS '비밀번호';
COMMENT ON COLUMN USER_TEST.PNO IS '주민등록번호';
COMMENT ON COLUMN USER_TEST.GENDER IS '성별';
COMMENT ON COLUMN USER_TEST.PHONE IS '연락처';
COMMENT ON COLUMN USER_TEST.ADDRESS IS '주소';
COMMENT ON COLUMN USER_TEST.STATUS IS '탈퇴여부';


INSERT INTO USER_TEST
VALUES (1, 'user01', 'pass01', '880122-1234567', '남', '010-1111-9999', '서울시 강남구 역삼동', 'N');
INSERT INTO USER_TEST
VALUES (2, 'user02', 'pass02', '890222-2234567', '여', '010-2222-9999', '서울시 강남구 삼성동', 'N');
INSERT INTO USER_TEST
VALUES (3, 'user03', 'pass03', '900322-2234567', '여', '010-3333-9999', '서울시 강남구 청담동', 'Y');
INSERT INTO USER_TEST
VALUES (4, 'user04', 'pass04', '910422-1234567', '남', '010-4444-9999', '서울시 강남구 도곡동', 'N');
INSERT INTO USER_TEST
VALUES (5, 'user05', 'pass05', '920522-2234567', '여', '010-5555-9999', '서울시 강남구 대치동', 'N');

-- 테이블 확인
SELECT * FROM USER_TEST;

-- 테이블 주석 확인
SELECT * FROM USER_COL_COMMENTS
WHERE TABLE_NAME = 'USER_TEST';

-- 테이블 제약 조건 확인
SELECT * FROM USER_CONSTRAINTS C1
JOIN USER_CONS_COLUMNS C2 USING(CONSTRAINT_NAME)
WHERE C1.TABLE_NAME = 'USER_TEST';



-----------------------------------------------------------------
-- 6. SUBQUERY 이용한 테이블 생성법
-- 컬럼명, 데이터 타입, 값이 복사되고, 제약조건은 NOT NULL만 복사됨

DROP TABLE EMPLOYEE_COPY; 

-- 1) 테이블 전체 복사
CREATE TABLE EMPLOYEE_COPY
AS SELECT * FROM EMPLOYEE;
--> 서브쿼리의 조회결과 (RESULT SET)의 모양대로 테이블이 생성됨

-- comment, 제약조건은  복사 안됨 not null  

DROP TABLE EMPLOYEE_COPY2; 

--2) JOIN 후 원하는 컬럼만 테이블로 복사
CREATE TABLE EMPLOYEE_COPY2
AS
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE);


--> 서브쿼리로 테이블 생성 시 
-- 테이블의 형태(컬럼명, 데이터 타입) + NOT NULL 제약조건만 복사
-- 제약조건, 코멘트는 복사되지 않기 때문에 별도 추가 작업이 필요하다



-----------------------------------------------------------------
-- 7. 제약조건 추가
-- ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] PRIMARY KEY(컬럼명)
-- ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] 
--  FOREIGN KEY(컬럼명) REFERENCES 참조 테이블명(참조컬럼명)
     --> 참조 테이블의 PK를 기본키를 FK로 사용하는 경우 참조컬럼명 생략 가능
                                                                                                                                                      
-- ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] UNIQUE(컬럼명)
-- ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] CHECK(컬럼명 비교연산자 비교값)
-- ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL;


-- 테이블 제약 조건 확인
SELECT *
FROM USER_CONSTRAINTS C1
JOIN USER_CONS_COLUMNS C2 USING(CONSTRAINT_NAME)
WHERE C1.TABLE_NAME = 'EMPLOYEE_COPY';


-- NOT NULL 제약 조건만 복사된 EMPLOYEE_COPY 테이블에
-- EMP_ID 컬럼에 PRIMARY KEY 제약조건 추가
ALTER TABLE EMPLOYEE_COPY ADD CONSTRAINT PK_EMP_COPY PRIMARY KEY(EMP_ID);


-- EMPLOYEE테이블의 DEPT_CODE에 외래키 제약조건 추가
-- 참조 테이블은 DEPARTMENT, 참조 컬럼은 DEPARTMENT의 기본키
ALTER TABLE EMPLOYEE ADD CONSTRAINT EMP_DEPT_CODE
FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT ON DELETE SET NULL;


-- EMPLOYEE테이블의 JOB_CODE 외래키 제약조건 추가
-- 참조 테이블은 JOB, 참조 컬럼은 JOB의 기본키
ALTER TABLE EMPLOYEE ADD CONSTRAINT EMP_JOB_CODE
FOREIGN KEY(JOB_CODE) REFERENCES JOB ON DELETE SET NULL;

ALTER TABLE EMPLOYEE ADD CONSTRAINT emp_job_code 
FOREIGN key(job_code) REFERENCES job ON DELETE SET NULL;

-- EMPLOYEE테이블의 SAL_LEVEL 외래키 제약조건 추가
-- 참조 테이블은 SAL_GRADE, 참조 컬럼은 SAL_GRADE의 기본키
ALTER TABLE EMPLOYEE ADD CONSTRAINT EMP_SAL_LEVEL
FOREIGN KEY(SAL_LEVEL) REFERENCES SAL_GRADE ON DELETE SET NULL;



-- DEPARTMENT테이블의 LOCATION_ID에 외래키 제약조건 추가
-- 참조 테이블은 LOCATION, 참조 컬럼은 LOCATION의 기본키

ALTER TABLE DEPARTMENT ADD CONSTRAINT DEPT_LOCATION_ID
FOREIGN KEY(LOCATION_ID) REFERENCES LOCATION ON DELETE SET NULL;


-- LOCATION테이블의 NATIONAL_CODE에 외래키 제약조건 추가
-- 참조 테이블은 NATIONAL, 참조 컬럼은 NATIONAL의 기본키

ALTER TABLE LOCATION ADD CONSTRAINT LOC_NATIONAL_CODE
FOREIGN KEY(NATIONAL_CODE) REFERENCES NATIONAL ON DELETE SET NULL;














