


/* SELECT문 해석 순서
 * 
 * 5: SELECT 컬럼명 AS 별칭, 계산식, 함수식
 * 1: FROM 참조할 테이블명
 * 2: WHERE 컬럼명 | 함수식 비교연산자 비교값
 * 3: GROUP BY 그룹을 묶을 컬럼명 --> 별칭 X
 * 4: HAVING 그룹함수식 비교연산자 비교값
 * 6: ORDER BY 컬럼명 | 별칭 | 컬럼순번 정렬방식 [NULLS FIRST / LAST]
 * 
 */

-- GROUP BY 절 : 같은 값들이 여러개 기록된 컬럼을 가지고 같은 값들을 하나의 그룹으로 묶음
-- GROUP BY 컬럼명 | 함수식, ...
-- 여러개의 값을 묶어서 하나로 처리할 목적으로 사용함
-- 그룹으로 묶은 값에 대해서 SELECT 절에서 그룹함수를 사용함


--1) 부서코드만 조회

SELECT DEPT_CODE
FROM EMPLOYEE
ORDER BY dept_code;

--2) 전체 급여 합 조회
SELECT SUM(SALARY) 
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 부서코드, 부서'별' 급여 합 조회
SELECT DEPT_CODE 부서명 , SUM(SALARY) 합계
FROM EMPLOYEE
GROUP BY DEPT_CODE --> DEPT_CODE가 같은 행끼리 하나의 그룹이 됨
ORDER BY DEPT_CODE; 


-- EMPLOYEE 테이블에서 
-- 직급코드가 같은 사람의 직급코드, 급여 평균, 인원 수를 
-- 직급코드 오름차순으로 조회


SELECT JOB_CODE 직급코드, ROUND(AVG(SALARY)) "급여 평균", COUNT(*) "인원 수"
FROM EMPLOYEE
GROUP BY JOB_CODE 
ORDER BY JOB_CODE;

SELECT JOB_CODE FROM EMPLOYEE;

--부서별 평균 급여, 인원수
SELECT DEPT_CODE 부서코드, ROUND(AVG(SALARY)) "급여 평균", COUNT(*) "인원 수"
FROM EMPLOYEE
GROUP BY DEPT_CODE 
ORDER BY DEPT_CODE;


-- EMPLOYEE 테이블에서 
-- 성별 (남/여)과 성별 별 인원 수, 급여 합을 
-- 인원수 오름차순으로 조회


SELECT DECODE(SUBSTR(EMP_NO,8,1), '1', '남', '2', '여') AS 성별, 
	COUNT(*) AS "인원 수", 
	SUM(SALARY) "급여 합"  
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO,8,1), '1', '남', '2', '여') 
ORDER BY "인원 수"; 


SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') AS 성별,
	COUNT(*) AS "인원 수",
	SUM(SALARY) AS "급여 합" 
FROM EMPLOYEE 
GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') --> 별칭 사용 못함(해석 순서때문!)
ORDER BY "인원 수"; --> 별칭 사용 가능(해석 순서때문!)

/***** 해석 순서 중요!!!!! ********/


---------------------------------------------------------------------------

-- EMPLOYEE 테이블에서 부서코드가 D5, D6인 부서의 평균 급여, 인원 수 조회

SELECT DEPT_CODE 부서코드 , ROUND(AVG(SALARY)) "평균 급여", COUNT(*) "인원 수"  
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5','D6')
GROUP BY DEPT_CODE;

SELECT DEPT_CODE 부서코드 , ROUND(AVG(SALARY)) "평균 급여", COUNT(*) "인원 수"  
FROM EMPLOYEE
WHERE DEPT_CODE ='D5' OR DEPT_CODE ='D6'
GROUP BY DEPT_CODE;

-- EMPLOYEE 테이블에서 직급별 2000년도 이후(2000년 포함) 입사자들의 급여 합을 조회
-- 직급 코드 오름차순




SELECT JOB_CODE ,SUM(SALARY)
FROM EMPLOYEE e 
WHERE EXTRACT(YEAR FROM HIRE_DATE) >= 2000
--WHERE TO_NUMBER(SUBSTR(TO_CHAR(HIRE_DATE),1,4)) >= 2000 
GROUP BY JOB_CODE
ORDER BY JOB_CODE;


SELECT JOB_CODE, SUM(SALARY) 
FROM EMPLOYEE
WHERE EXTRACT (YEAR FROM HIRE_DATE) >= 2000
-- HIRE_DATE >= TO_DATE('2000-01-01')
-- TO_NUMBER(SUBSTR(TO_CHAR(HIRE_DATE),1,4)) >= 2000
GROUP BY JOB_CODE
ORDER BY JOB_CODE; --1도 가능(select 순서번호)


-- EMPLOYEE 테이블에서 부서별로 같은 직급인 사원의 수를 조회
-- 부서코드 오름차순, 직급코드 내림차순

SELECT DEPT_CODE 부서코드 , JOB_CODE 직급코드 , COUNT(*) "사원 수" 
FROM EMPLOYEE
GROUP BY DEPT_CODE , JOB_CODE -- DEPT_CODE로 그룹을 나누고,
							-- 나눠진 그룹 내에서 JOB_CODE로 또 그룹을 분류
ORDER BY DEPT_CODE , JOB_CODE DESC;


-- GROUP BY 사용시 주의사항
--> SELECT문에 GROUP BY절을 사용할 경우
--	SELECT 절에 명시한  조회하려는 컬럼 중
--	그룹함수가 적용되지 않은 컬럼을 모두 GROUP BY절에 작성해야 함


----------------------------------------------------------------------------------


-- 부서별 평균 급여가 3백만원 이상인 부서를 조회(부서코드 오름차순)

SELECT DEPT_CODE AS "평균 급여 300이상"
FROM EMPLOYEE
--WHERE ROUND(AVG(SALARY)) >= 3000000
GROUP BY DEPT_CODE 
HAVING ROUND(AVG(SALARY)) >= 3000000 --> DEPT_CODE 그룹 중 급여 평균이 3백만 이상인 그룹만 남음
ORDER BY DEPT_CODE ;



-- EMPLOYEE 테이블에서 직급별 인원수가 5명 이하인 직급코드, 인원 수 조회 
-- (직급코드 오름차순)

SELECT JOB_CODE "직급 코드" , COUNT(*) "인원 수"
FROM EMPLOYEE 
GROUP BY JOB_CODE 
HAVING COUNT(*) <= 5 -->HAVING절에는 그룹 함수가 반드시 작성된다!!
ORDER BY JOB_CODE ;



SELECT JOB_CODE , COUNT(*) 
FROM EMPLOYEE
GROUP BY JOB_CODE 
HAVING COUNT(*) <= 5 
ORDER BY JOB_CODE;












