-- JOIN 연습문제

-- 1. 이름에 '형'자가 들어가는 직원들의
-- 사번, 사원명, 직급명을 조회하세요.
-- ANSI 표준
SELECT 
       E.EMP_ID 사번
     , E.EMP_NAME 사원명
     , J.JOB_NAME 직급명
  FROM EMPLOYEE E
  JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
 WHERE E.EMP_NAME LIKE '%형%';  
  
-- 오라클 전용
SELECT 
       E.EMP_ID 사번
     , E.EMP_NAME 사원명
     , J.JOB_NAME 직급명
  FROM EMPLOYEE E
     , JOB J
 WHERE E.JOB_CODE = J.JOB_CODE
   AND E.EMP_NAME LIKE '%형%';  



-- 2. 주민번호가 70년대 생이면서 성별이 여자이고, 
--    성이 전씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하세요.
-- ANSI 표준
SELECT 
        E.EMP_NAME 사원명
      , E.EMP_NO 주민번호
      , D.DEPT_TITLE 부서명
      , J.JOB_NAME 직급명
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
 WHERE E.EMP_NAME LIKE '전%'
   AND SUBSTR(E.EMP_NO,1,1) = 7 ;
  
  
-- 오라클 전용
SELECT 
        E.EMP_NAME 사원명
      , E.EMP_NO 주민번호
      , D.DEPT_TITLE 부서명
      , J.JOB_NAME 직급명
  FROM EMPLOYEE E
     , DEPARTMENT D 
     , JOB J
 WHERE E.DEPT_CODE = D.DEPT_ID
   AND E.JOB_CODE = J.JOB_CODE
   AND E.EMP_NAME LIKE '전%'
   AND SUBSTR(E.EMP_NO,1,1) = 7;


-- 3. 가장 나이가 적은 직원의 사번, 사원명, 
--    나이, 부서명, 직급명을 조회하세요.
-- ANSI 표준
SELECT 
       E.EMP_ID 사번
     , E.EMP_NAME 사원명
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,6), 'RRMMDD'))) +1 나이
     , D.DEPT_TITLE 부서명
     , J.JOB_NAME 직급명
 FROM  EMPLOYEE E
 JOIN DEPARTMENT D ON (E. DEPT_CODE = D.DEPT_ID)
 JOIN JOB J ON(E.JOB_CODE= J.JOB_CODE)
WHERE EMP_ID NOT IN (200,201,214)
  AND EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,6), 'RRMMDD'))) +1 = 
     (SELECT 
             MIN(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,6), 'RRMMDD'))) +1)
        FROM EMPLOYEE
       WHERE EMP_ID NOT IN (200,201,214)
     );
     
SELECT 
       E.EMP_ID 사번
     , E.EMP_NAME 사원명
     , FLOOR(MONTHS_BETWEEN(SYSDATE,TO_DATE((SUBSTR(EMP_NO,1,6)), 'RRMMDD'))/12) 만나이
     , D.DEPT_TITLE 부서명
     , J.JOB_NAME 직급명
 FROM  EMPLOYEE E
 JOIN DEPARTMENT D ON (E. DEPT_CODE = D.DEPT_ID)
 JOIN JOB J ON(E.JOB_CODE= J.JOB_CODE)
WHERE EMP_ID NOT IN (200,201,214)
  AND  FLOOR(MONTHS_BETWEEN(SYSDATE,TO_DATE((SUBSTR(EMP_NO,1,6)), 'RRMMDD'))/12) = 
     (SELECT 
             MIN( FLOOR(MONTHS_BETWEEN(SYSDATE,TO_DATE((SUBSTR(EMP_NO,1,6)), 'RRMMDD'))/12))
        FROM EMPLOYEE
       WHERE EMP_ID NOT IN (200,201,214)
     );
  
-- ORACLE 전용
SELECT 
       E.EMP_ID 사번
     , E.EMP_NAME 사원명
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,6), 'RRMMDD'))) +1 나이
     , D.DEPT_TITLE 부서명
     , J.JOB_NAME 직급명
 FROM  EMPLOYEE E
     , DEPARTMENT D 
     , JOB J 
WHERE EMP_ID NOT IN (200,201,214)
  AND E. DEPT_CODE = D.DEPT_ID
  AND E.JOB_CODE= J.JOB_CODE      
  AND EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,6), 'RRMMDD'))) +1 = 
     (SELECT 
             MIN(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,6), 'RRMMDD'))) +1)
        FROM EMPLOYEE
       WHERE EMP_ID NOT IN (200,201,214)
     );
  

-- 4. 부서코드가 D2인 직원들의 사원명, 
--    직급명, 부서명, 근무지역명을 조회하세요.
-- ANSI 표준
SELECT 
       E.EMP_NAME 사원명
     , J.JOB_NAME 직급명
     , D.DEPT_TITLE 부서명
     , L.LOCAL_NAME 근무지역명
  FROM EMPLOYEE E
  JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
  JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
  JOIN LOCATION L ON( D.LOCATION_ID = L.LOCAL_CODE)
 WHERE E.DEPT_CODE = 'D2';

-- 오라클 전용
SELECT 
       E.EMP_NAME 사원명
     , J.JOB_NAME 직급명
     , D.DEPT_TITLE 부서명
     , L.LOCAL_NAME 근무지역명
  FROM EMPLOYEE E
     , JOB J
     , DEPARTMENT D
     , LOCATION L
 WHERE E.JOB_CODE = J.JOB_CODE
   AND E.DEPT_CODE = D.DEPT_ID
   AND D.LOCATION_ID = L.LOCAL_CODE
   AND E.DEPT_CODE = 'D2';


-- 5. 보너스포인트가 없는 직원들 중에서 직급코드가 
--     J4와 J7인 직원들의 사원명, 직급명, 급여를 조회하세요.
-- ANSI 표준
SELECT 
       E.EMP_NAME 사원명
     , J.JOB_NAME 직급명
--   , J.JOB_CODE 별칭 불가능
     , JOB_CODE 직급코드 -- 별칭없이는 가능
     , E.SALARY 급여
  FROM EMPLOYEE E
  JOIN JOB J USING(JOB_CODE) 
           --USING을 사용한 컬럼은 별칭을 사용 못한다.
 WHERE JOB_CODE IN ('J4','J7')
   AND BONUS IS NULL;

-- 오라클 전용
SELECT 
       E.EMP_NAME 사원명
     , J.JOB_NAME 직급명
     , E.SALARY 급여
  FROM EMPLOYEE E
     , JOB J
 WHERE E.JOB_CODE = J.JOB_CODE
   AND E.JOB_CODE IN ('J4','J7')
   AND E.BONUS IS NULL;

-- 6. 보너스포인트를 받는 직원들의 사원명, 
--    보너스포인트, 부서명, 근무지역명을 조회하세요.
-- ANSI 표준
SELECT 
       E.EMP_NAME 사원명
     , E.BONUS 보너스포인트
     , D.DEPT_TITLE 부서명
     , L.LOCAL_NAME 근무지역명
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
 WHERE E.BONUS IS NOT NULL;

-- 오라클 전용
SELECT 
       E.EMP_NAME 사원명
     , E.BONUS 보너스포인트
     , D.DEPT_TITLE 부서명
     , L.LOCAL_NAME 근무지역명
  FROM EMPLOYEE E
     , DEPARTMENT D 
     , LOCATION L 
 WHERE E.DEPT_CODE = D.DEPT_ID
   AND D.LOCATION_ID = L.LOCAL_CODE
   AND E.BONUS IS NOT NULL;
 
 
-- 7. 해외영업팀에 근무하는 사원명, 
--    직급명, 부서코드, 부서명을 조회하세요.
-- ANSI 표준
SELECT 
       E.EMP_NAME 사원명
     , J.JOB_NAME 직급명
     , E.DEPT_CODE 부서코드
     , D.DEPT_TITLE 부서명
  FROM EMPLOYEE E
  JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
  JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
 WHERE D.DEPT_TITLE LIKE '해외영업%'; 
       
-- 오라클 전용
SELECT 
       E.EMP_NAME 사원명
     , J.JOB_NAME 직급명
     , E.DEPT_CODE 부서코드
     , D.DEPT_TITLE 부서명
  FROM EMPLOYEE E
     , JOB J
     , DEPARTMENT D
 WHERE E.JOB_CODE = J.JOB_CODE
   AND E.DEPT_CODE = D.DEPT_ID
   AND D.DEPT_TITLE LIKE '해외영업%'; 
 
-- 8. 본인 급여 등급의 최소급여(MIN_SAL)를 초과하여 급여를 받는 직원들의
--    사원명, 직급명, 급여, 보너스포함 연봉을 조회하세요.
--    연봉에 보너스포인트를 적용한다.
-- ANSI 표준
SELECT 
       E.EMP_NAME 사원명
     , J.JOB_NAME 직급명
     , E.SALARY 급여
     , SALARY*12*(NVL(BONUS,1)+1) "보너스포함연봉"
  FROM EMPLOYEE E
  JOIN JOB J ON(E.JOB_CODE=J.JOB_CODE)
  JOIN SAL_GRADE S ON(SALARY BETWEEN MIN_SAL AND MAX_SAL) 
  WHERE E.SALARY > S.MIN_SAL;
 
-- 오라클 전용
SELECT 
       E.EMP_NAME 사원명
     , J.JOB_NAME 직급명
     , E.SALARY 급여
     , SALARY*12*(NVL(BONUS,1)+1) "보너스포함연봉"
  FROM EMPLOYEE E
     , JOB J 
     , SAL_GRADE S
  WHERE E.JOB_CODE=J.JOB_CODE
    AND SALARY BETWEEN MIN_SAL AND MAX_SAL
    AND E.SALARY > S.MIN_SAL;

-- 9. 한국과 일본에 근무하는 직원들의 
--    사원명, 부서명, 지역명, 국가명을 조회하세요.
-- ANSI 표준
SELECT 
       E.EMP_NAME 사원명
     , D.DEPT_TITLE  부서명
     , L.LOCAL_NAME 지역명
     , N.NATIONAL_NAME 국가명
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE=D.DEPT_ID)
  JOIN LOCATION L ON (D.LOCATION_ID=L.LOCAL_CODE)
  JOIN NATIONAL N ON (L.NATIONAL_CODE=N.NATIONAL_CODE)
 WHERE N.NATIONAL_NAME IN ('한국','일본')
 ORDER BY 국가명 DESC;

-- 오라클 전용
SELECT 
       E.EMP_NAME 사원명
     , D.DEPT_TITLE  부서명
     , L.LOCAL_NAME 지역명
     , N.NATIONAL_NAME 국가명
  FROM EMPLOYEE E
     , DEPARTMENT D
     , LOCATION L
     ,NATIONAL N
 WHERE E.DEPT_CODE=D.DEPT_ID
   AND D.LOCATION_ID=L.LOCAL_CODE
   AND L.NATIONAL_CODE=N.NATIONAL_CODE
   AND N.NATIONAL_NAME IN ('한국','일본')
 ORDER BY 국가명 DESC;


-- 10. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 
--     동료이름을 조회하세요. self join 사용 (60행)
-- ANSI 표준
SELECT 
       E1.EMP_NAME
     , E1.DEPT_CODE
     , E2.EMP_NAME 
  FROM EMPLOYEE E1
  JOIN EMPLOYEE E2 ON (E1.DEPT_CODE = E2.DEPT_CODE)
WHERE E1.EMP_NAME != E2.EMP_NAME;

-- 오라클 전용
SELECT 
       E1.EMP_NAME
     , E1.DEPT_CODE
     , E2.EMP_NAME 
  FROM EMPLOYEE E1
     , EMPLOYEE E2
WHERE E1.DEPT_CODE = E2.DEPT_CODE
  AND E1.EMP_NAME != E2.EMP_NAME;
