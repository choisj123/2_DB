/* SEQUENCE(순서, 연속, 수열)
	- 순차적 번호 자동 발생기 역할의 객체
	
	-> SEQUENCE 객체를 생성해서 호출하게되면
	   지정된 범위 내에서 일정한 간격으로 증가하는 숫자가
	   순차적으로 출력됨.
	   
	 EX) 1부터 10까지 1씩 증가하고 반복하는 시퀀스 객체
	 1 2 3 4 5 6 7 8 9 10 1 2 3 4 5 6 7 8 9 10
	 
	 ** SEQUENCE는 주로 PK역할의 컬럼에 삽입되는 값을 만드는 용도로 사용 **    
	--> 인위적 주식별자
	
	  [작성법]
	  
  CREATE SEQUENCE 시퀀스이름
  [STRAT WITH 숫자] -- 처음 발생시킬 시작값 지정, 생략하면 자동 1이 기본
  [INCREMENT BY 숫자] -- 다음 값에 대한 증가치, 생략하면 자동 1이 기본
  [MAXVALUE 숫자 | NOMAXVALUE] -- 발생시킬 최대값 지정 (10의 27승 -1)
  [MINVALUE 숫자 | NOMINVALUE] -- 최소값 지정 (-10의 26승)
  [CYCLE | NOCYCLE(기본값)] -- 값 순환 여부 지정
  [CACHE 바이트크기 | NOCACHE(기본값)] -- 캐쉬메모리 기본값은 20바이트, 최소값은 2바이트

-- 시퀀스의 캐시 메모리는 할당된 크기만큼 미리 다음 값들을 생성해 저장해둠
-- --> 시퀀스 호출 시 미리 저장되어진 값들을 가져와 반환하므로 
--     매번 시퀀스를 생성해서 반환하는 것보다 DB속도가 향상됨.


    ** 시퀀스 사용 방법 **
    
    1) 시퀀스명.NEXTVAL : 다음 시퀀스 번호를 얻어옴. (INCREMENT BY만큼 증가된 값)
                          단, 시퀀스 생성 후 첫 호출인 경우 START WITH의 값을 얻어옴.
    
    2) 시퀀스명.CURRVAL : 현재 시퀀스 번호 얻어옴.
                          단, 시퀀스 생성 후 NEXTVAL 호출 없이 CURRVAL를 호출하면 오류 발생.
	
*/

-- 옵션 없이 SEQUENCE 생성
-- 범위 : 1 ~ 10^38
-- 시작 : 1
-- 반복 X (NOCYCLE)
-- 캐시메모리 20 BYTE

DROP SEQUENCE SEQ_TEST;

CREATE SEQUENCE SEQ_TEST;

-- * CURRVAL 주의사항 *
--> CURRVAL는 마지막 NEXTVAL 호출값을 다시 보여주는 기능
--> NEXTVAL를 먼저 호출해야 CURRVAL 호출이 가능하다

-- 생성 되자마자 바로 현재 값 확인
SELECT SEQ_TEST.CURRVAL FROM DUAL;
-- SQL Error [8002] [72000]: ORA-08002: sequence SEQ_TEST.CURRVAL is not yet defined in this session

SELECT SEQ_TEST.NEXTVAL FROM DUAL; -- 1
SELECT SEQ_TEST.CURRVAL FROM DUAL; -- 1

SELECT SEQ_TEST.NEXTVAL FROM DUAL; -- 2
SELECT SEQ_TEST.NEXTVAL FROM DUAL; -- 3
SELECT SEQ_TEST.NEXTVAL FROM DUAL; -- 4
SELECT SEQ_TEST.NEXTVAL FROM DUAL; -- 5

SELECT SEQ_TEST.CURRVAL FROM DUAL; -- 5


-------------------------------------------------

-- 실제 사용 예시
DROP TABLE EMP_TEMP;

CREATE TABLE EMP_TEMP
AS SELECT EMP_ID, EMP_NAME FROM EMPLOYEE;

SELECT * FROM EMP_TEMP;

-- 223번부터 10씩 증가하는 시퀀스 생성
DROP SEQUENCE SEQ_TEMP;

CREATE SEQUENCE SEQ_TEMP
START WITH 223
INCREMENT BY 10;


CREATE SEQUENCE SEQ_TEMP
START WITH 223 -- 223부터 시작
INCREMENT BY 10 -- 10씩 증가
NOCYCLE  -- 반복 X(기본값)
NOCACHE; -- 캐시 X(기본값 CACHE 20)

-- EMP_TEMP 테이블에 사원 정보 삽입
INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL, '홍길동');
INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.CURRVAL, '고길동'); -- pk 위배
INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL, '김길동');

ROLLBACK; 

SELECT * FROM EMP_TEMP;


ALTER TABLE EMP_TEMP 
MODIFY EMP_ID PRIMARY KEY;

---------------------------------------------------

-- SEQUENCE 수정
/*
  ALTER SEQUENCE 시퀀스이름
  [INCREMENT BY 숫자] -- 다음 값에 대한 증가치, 생략하면 자동 1이 기본
  [MAXVALUE 숫자 | NOMAXVALUE] -- 발생시킬 최대값 지정 (10의 27승 -1)
  [MINVALUE 숫자 | NOMINVALUE] -- 최소값 지정 (-10의 26승)
  [CYCLE | NOCYCLE] -- 값 순환 여부 지정
  [CACHE 바이트크기 | NOCACHE] -- 캐쉬메모리 기본값은 20바이트, 최소값은 2바이트
*/

-- SEQ_TEMP 를 1씩 증가하는 형태로 변경
ALTER SEQUENCE SEQ_TEMP
INCREMENT BY 1;

INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL, '이길동');
INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL, '문길동');
INSERT INTO EMP_TEMP VALUES(SEQ_TEMP.NEXTVAL, '최길동');

SELECT * FROM EMP_TEMP;


-- 테이블(EMP_TEMP), 뷰(V_DCOPY2), 시퀀스(SEQ_TEMP) 삭제

DROP TABLE EMP_TEMP; 
DROP VIEW V_DCOPY2; 
DROP SEQUENCE SEQ_TEMP;








