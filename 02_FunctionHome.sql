SELECT INSTR('ORACLEDATABASESYSTEM', 'S') FROM DUAL;

SELECT INSTR('ORACLEDATABASESYSTEM', 'A') FROM DUAL;


SELECT INSTR('ORACLEDATABASESYSTEM', 'A', 6) FROM DUAL;

SELECT INSTR('ORACLEDATABASESYSTEM', 'A', 6, 3 ) FROM DUAL;

-- EMPLOYEE 테이블에서 사원명, 이메일, 이메일 중 '@' 위치 조회

SELECT EMP_NAME , EMAIL , INSTR(EMAIL, '@') AS "@" 
FROM EMPLOYEE;


SELECT SUBSTR('ORACLEDATABASESYSTEM', 7) FROM DUAL;

-- EMPLOYEE 테이블에서 사원명, 이메일 중 아이디만 조회
SELECT EMP_NAME , EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) 
FROM EMPLOYEE;

SELECT TRIM('       babo     ') FROM DUAL;

SELECT TRIM('#' FROM '#########안녕#####') FROM DUAL; 
SELECT TRIM(BOTH '#' FROM '#########안녕#####') FROM DUAL; 
SELECT TRIM(LEADING '#' FROM '###   안녕#####') FROM DUAL; 
SELECT TRIM(TRAILING  '#' FROM '##안녕#####') FROM DUAL; 
SELECT TRIM(TRAILING  '#' FROM '#########안녕#') FROM DUAL; 

SELECT EMAIL, TRIM('_' FROM EMAIL)
FROM EMPLOYEE;

SELECT ABS(-10.45) FROM DUAL; 

SELECT MOD(20, 2) FROM DUAL;

-- EMPLOYEE 테이블에서 사원의 월급을 100만으로 나눴을 떄 나머지 조회

SELECT EMP_NAME , SALARY , MOD(SALARY, 1000000) 나머지
FROM EMPLOYEE
ORDER BY 나머지 DESC ;

-- EMPLOYEE 테이블에서 사번이 짝수인 사원의 사번, 이름 조회

SELECT EMP_ID , EMP_NAME 
FROM EMPLOYEE
WHERE MOD(EMP_ID,2) = 0; 

SELECT CEIL(150.2), FLOOR(168.2) FROM DUAL;

SELECT ROUND(MONTHS_BETWEEN(SYSDATE, '2023-07-10'),1) "수강 기간(개월)" FROM DUAL; 

-- EMPLOYEE 테이블에서
-- 사원의 이름, 입사일, 근무한 개월 수 , 근무 연차 조회

SELECT EMP_NAME , HIRE_DATE 
CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) "근무한 개월 수",
MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12 "근무 년차" 
FROM EMPLOYEE;

