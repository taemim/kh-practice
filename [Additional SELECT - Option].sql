-- [Additional SELECT - Option]
-- 2022/01/22 과제 풀이

-- 1. 학생이름과 주소지를 표시하시오. 
-- 단, 출력 헤더는 "학생 이름", "주소지"로 하고, 정렬은 이름으로 오름차순 표시하도록 한다.
SELECT 
       S.STUDENT_NAME 학생이름
     , S.STUDENT_ADDRESS 주소지
  FROM TB_STUDENT S     
 ORDER BY 학생이름 ;
 
--2. 휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오.
SELECT
       S.STUDENT_NAME
     , S.STUDENT_SSN
  FROM TB_STUDENT S
 WHERE S.ABSENCE_YN = 'Y'
 ORDER BY TO_DATE(SUBSTR(S.STUDENT_SSN,1,6),'RRMMDD') DESC;
 
-- 3. 주소지가 강원도나 경기도인 학생들 중 1900년대 학번을 가진 
-- 학생들의 이름과 학번, 주소를 이름의 오름차순으로 화면에 출력하시오. 
-- 단, 출력헤더에는 "학생이름","학번", "거주지 주소" 가 출력되도록 한다. 
SELECT 
       S.STUDENT_NAME 학생이름
     , S.STUDENT_NO 학번
     , S.STUDENT_ADDRESS "거주지 주소"
  FROM TB_STUDENT S
 WHERE (S.STUDENT_ADDRESS LIKE '경기도%' 
    OR  S.STUDENT_ADDRESS LIKE '강원도%')
   AND S.STUDENT_NO LIKE '9%'
 ORDER BY 학생이름;
 
-- 4. 현재 법학과 교수 중 가장 나이가 많은 사람부터 
-- 이름을 확인할 수 있는 SQL 문장을 작성하시오. 
-- (법학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서 찾아 내도록 하자) 
SELECT 
       P.PROFESSOR_NAME
      ,P.PROFESSOR_SSN 
  FROM TB_PROFESSOR P
  JOIN TB_DEPARTMENT D ON (P.DEPARTMENT_NO = D.DEPARTMENT_NO)
 WHERE D.DEPARTMENT_NAME = '법학과'
 ORDER BY TO_DATE(SUBSTR(P.PROFESSOR_SSN,1,6),'RRMMDD'); 
 
-- 5. 2004년 2학기에 'C3118100' 과목을 수강한 학생들의 학점을 조회하려고 한다. 
-- 학점이 높은 학생부터 표시하고, 
-- 학점이 같으면 학번이 낮은 학생부터 표시하는 구문을 작성해보시오. 
SELECT 
       S.STUDENT_NO 학번
     , TO_CHAR(G.POINT, '0.00') 학점
  FROM TB_STUDENT S
  JOIN TB_GRADE G ON(S.STUDENT_NO = G.STUDENT_NO)
 WHERE G.CLASS_NO ='C3118100'
   AND G.TERM_NO = '200402'
 ORDER BY 학점 DESC , 학번 ASC;
 
-- 6. 학생 번호, 학생 이름, 학과 이름을 
-- 학생 이름으로 오름차순 정렬하여 출력하는 SQL 문을 작성하시오.
SELECT 
       S.STUDENT_NO
     , S.STUDENT_NAME  
     , D.DEPARTMENT_NAME
  FROM TB_STUDENT S
  JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO) 
 ORDER BY 2; 
 
-- 7. 춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력하는 SQL 문장을 작성하시오.
SELECT 
       C.CLASS_NAME
      , D.DEPARTMENT_NAME 
  FROM TB_CLASS C
  JOIN TB_DEPARTMENT D ON (C.DEPARTMENT_NO = D.DEPARTMENT_NO);
  
-- 8. 과목별 교수 이름을 찾으려고 한다. 
-- 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오.  
SELECT
       CLASS_NAME
     , PROFESSOR_NAME
  FROM TB_CLASS
  JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
  JOIN TB_PROFESSOR USING(PROFESSOR_NO);

-- 9. 8번의 결과 중 ‘인문사회’ 계열에 속한 과목의 교수 이름을 찾으려고 핚다. 
-- 이에 해당하는 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오.
SELECT
       V.CLASS_NAME
     , P.PROFESSOR_NAME
  FROM (SELECT C1.*
          FROM TB_CLASS C1
          JOIN TB_DEPARTMENT D ON(C1.DEPARTMENT_NO = D.DEPARTMENT_NO)
         WHERE D.CATEGORY = '인문사회') V
  JOIN TB_CLASS_PROFESSOR CP ON(V.CLASS_NO= CP.CLASS_NO)
  JOIN TB_PROFESSOR P ON (CP.PROFESSOR_NO = P.PROFESSOR_NO);
  
 SELECT
       C.CLASS_NAME
     , P.PROFESSOR_NAME
  FROM TB_CLASS C
  JOIN TB_CLASS_PROFESSOR CP USING(CLASS_NO)
  JOIN TB_PROFESSOR P USING(PROFESSOR_NO)
  JOIN TB_DEPARTMENT  D ON(P.DEPARTMENT_NO = D.DEPARTMENT_NO)
 WHERE D.CATEGORY = '인문사회'
  ; 
  
-- 10. ‘음악학과’ 학생들의 평점을 구하려고 한다. 
-- 음악학과 학생들의 "학번", "학생 이름", "전체 평점"을 출력하는 SQL 문장을 작성하시오. 
-- (단, 평점은 소수점 1자리까지만 반올림하여 표시한다.)

-- 인라인뷰 안에 음악학과 컬럼에 별칭 사용
SELECT 
       V.학번
     , V.학생이름 
     , ROUND(AVG(G.POINT),1) "전체 평점"
 FROM (SELECT S.STUDENT_NO 학번
            , S.STUDENT_NAME 학생이름 
         FROM TB_STUDENT S
         JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
       WHERE D.DEPARTMENT_NAME = '음악학과' 
       ) V
 JOIN TB_GRADE G ON (V.학번 = G.STUDENT_NO)                     
 GROUP BY V.학번, V.학생이름
 ORDER BY 학번;
 
-- 인라인뷰 단에 음악학과 정보를 모두 가져온뒤 메인쿼리문에서 컬럼에 별칭사용
SELECT 
       V.STUDENT_NO 학번
     , V.STUDENT_NAME 학생이름 
     , ROUND(AVG(G.POINT),1) "전체 평점"
 FROM (SELECT S.*
         FROM TB_STUDENT S
         JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
       WHERE D.DEPARTMENT_NAME = '음악학과' 
       ) V
 JOIN TB_GRADE G ON (V.STUDENT_NO = G.STUDENT_NO)                     
 GROUP BY V.STUDENT_NO, V.STUDENT_NAME
 ORDER BY 학번;
 
 
-- 11. 학번이 A313047인 학생이 학교에 나오고 있지 않다. 
-- 지도 교수에게 내용을 전달하기 위한 학과 이름, 학생 이름과 지도 교수 이름이 필요하다. 
-- 이때 사용할 SQL 문을 작성하시오. 
-- 단, 출력헤더는 ‚학과이름‚ 학생이름, 지도교수이름 으로 출력되도록 핚다.
SELECT
       D.DEPARTMENT_NAME 학과이름
     , S.STUDENT_NAME 학생이름
     , P.PROFESSOR_NAME 지도교수이름
FROM TB_STUDENT S
JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
JOIN TB_PROFESSOR P ON (S.COACH_PROFESSOR_NO = P.PROFESSOR_NO)
WHERE S.STUDENT_NO = 'A313047';

-- 12. 2007년도에 '인간관계론' 과목을 수강한
-- 학생을 찾아 학생이름과 수강학기를 표시하는 SQL 문장을 작성하시오.
SELECT 
      S.STUDENT_NAME
    , G.TERM_NO
  FROM TB_GRADE G
  JOIN TB_STUDENT S ON (S.STUDENT_NO = G.STUDENT_NO)
  JOIN TB_CLASS C ON (G.CLASS_NO = C.CLASS_NO)
 WHERE C.CLASS_NAME = '인간관계론'
   AND TERM_NO LIKE '2007__';
   
-- 13. 예체능 계열 과목 중 과목 담당교수를 한 명도 배정받지 못한 과목을 찾아 
-- 그 과목 이름과 학과 이름을 출력하는 SQL 문장을 작성하시오.
SELECT C.CLASS_NAME
     , D.DEPARTMENT_NAME
FROM TB_CLASS C
JOIN TB_DEPARTMENT D ON (C.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE D.CATEGORY = '예체능'
 AND C.CLASS_NO NOT IN ( SELECT CP.CLASS_NO
                           FROM TB_CLASS_PROFESSOR CP);

-- 14. 춘 기술대학교 서반아어학과 학생들의 지도교수를 게시하고자 한다.
-- 학생이름과 지도교수 이름을 찾고 만일 지도 교수가 없는 학생일 경우 
-- "지도교수 미지정‛으로 표시하도록 하는 SQL 문을 작성하시오. 
-- 단, 출력헤더는 ‚학생이름, ‚지도교수 로 표시하며 고학번 학생이 먼저 표시되도록 한다.

-- CASE문 사용한 방법
SELECT S.STUDENT_NAME 학생이름
      , CASE 
        WHEN s.coach_professor_no IS NULL
        THEN '지도교수미지정' 
        ELSE (SELECT P.PROFESSOR_NAME
                FROM TB_PROFESSOR P 
               WHERE S.COACH_PROFESSOR_NO = P.PROFESSOR_NO
              )
        END 지도교수
  FROM TB_STUDENT S
  JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
 WHERE D.DEPARTMENT_NAME = '서반아어학과';

-- UNION을 사용한 방법
SELECT 
      S.STUDENT_NAME 학생이름
    , p.professor_name 지도교수 
 FROM TB_STUDENT S
 JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
 JOIN tb_professor P ON (s.coach_professor_no= p.PROFESSOR_NO)
 WHERE D.DEPARTMENT_NAME = '서반아어학과'
UNION
SELECT 
      S.STUDENT_NAME 학생이름
    , '지도교수 미지정' AS 지도교수
 FROM TB_STUDENT S
 JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
 WHERE D.DEPARTMENT_NAME = '서반아어학과'
 AND s.coach_professor_no IS NULL;
 
-- LEFT조인을 이용한 방법 왼쪽 컬럼의 NULL값도 출력됨 NVL을 사용
SELECT 
      S.STUDENT_NAME 학생이름
    , NVL(P.PROFESSOR_NAME,'지도교수 미지정') 지도교수 
 FROM TB_STUDENT S
 LEFT JOIN TB_PROFESSOR P ON (S.COACH_PROFESSOR_NO= P.PROFESSOR_NO)
 JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
 WHERE D.DEPARTMENT_NAME = '서반아어학과';

-- 15. 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 
-- 그 학생의 학번, 이름, 학과 이름, 평점을 출력하는 SQL 문을 작성하시오.

-- 1) 스칼라 쿼리를 사용하여 SELECT문 안에 평점을 구하는 코드를 작성함.
SELECT
       S.STUDENT_NO 학번
     , S.STUDENT_NAME 이름
     , D.DEPARTMENT_NAME 학과이름
     , (SELECT TO_CHAR(AVG(G.POINT), '0.0')
          FROM TB_GRADE G
         WHERE S.STUDENT_NO = G.STUDENT_NO ) 평점
 FROM TB_STUDENT S
 JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO=D.DEPARTMENT_NO)
WHERE S.ABSENCE_YN = 'N'
  AND (SELECT ROUND(AVG(G.POINT),2)
         FROM TB_GRADE G
        WHERE S.STUDENT_NO = G.STUDENT_NO )>= 4.0; 

-- 2) 인라인뷰를 사용한 방법 
-- 평점이 4.0 이상인 조건을 판별하기 위해 위 코드는 평점에 대한 코드를 두번 작성해야 함.
-- 평점을 뷰 안에서 구하고, WHERE절에서 별칭으로 간단하게 작성할 수 있다. 
SELECT
       V.학번
     , V.이름
     , V.학과이름
     , V.평점
  FROM (SELECT S.STUDENT_NO 학번
             , S.STUDENT_NAME 이름
             , D.DEPARTMENT_NAME 학과이름
             ,(SELECT ROUND(AVG(G.POINT),2)
                 FROM TB_GRADE G
                WHERE S.STUDENT_NO = G.STUDENT_NO) 평점
        FROM TB_STUDENT S
        JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO=D.DEPARTMENT_NO)
        WHERE S.ABSENCE_YN = 'N'
     ) V --휴학생이 아닌 학생들의 학번,이름,학과이름,평점
WHERE 평점 >= 4.0;
        
--전체 학생들 평균 구하는 코드
SELECT S.STUDENT_NAME 이름
     , ROUND(AVG(G.POINT),2)
  FROM TB_STUDENT S
  JOIN TB_GRADE G ON (G.STUDENT_NO = S.STUDENT_NO)
 WHERE S.STUDENT_NO = G.STUDENT_NO
 GROUP BY S.STUDENT_NAME;


--16. 환경조경학과 전공과목들의 과목 별 평점을 파악할 수 있는 SQL 문을 작성하시오.
SELECT 
       C.CLASS_NO 전공과목번호
     , C.CLASS_NAME 전공과목명
     , ROUND(AVG(G.POINT),2) "과목 별 평점"
  FROM TB_CLASS C
  JOIN TB_DEPARTMENT D ON(C.DEPARTMENT_NO =D.DEPARTMENT_NO)
  JOIN TB_GRADE G ON (C.CLASS_NO = G.CLASS_NO)
 WHERE D.DEPARTMENT_NAME = '환경조경학과' 
   AND C.CLASS_TYPE LIKE '전공%'
 GROUP BY C.CLASS_NO, C.CLASS_NAME;
 
-- 17. 춘 기술대학교에 다니고 있는 최경희 학생과 
-- 같은 과 학생들의 이름과 주소를 출력하는 SQL 문을 작성하시오. 
SELECT 
       S.STUDENT_NAME
     , S.STUDENT_ADDRESS
FROM TB_STUDENT S
WHERE S.DEPARTMENT_NO = (SELECT S1.DEPARTMENT_NO
                           FROM TB_STUDENT S1
                         WHERE S1.STUDENT_NAME = '최경희'); 

-- 18. 국어국문학과에서 총 평점이 가장 높은 학생의 
-- 이름과 학번을 표시하는 SQL문을 작성하시오.
SELECT 
       V.학번
     , V.학생이름 
 FROM (SELECT 
             S1.STUDENT_NO 학번
           , S1.STUDENT_NAME 학생이름
           , ROUND(AVG(G.POINT),2) 평점
         FROM TB_STUDENT S1
         JOIN TB_DEPARTMENT D ON(S1.DEPARTMENT_NO = D.DEPARTMENT_NO)
         JOIN TB_GRADE G ON (S1.STUDENT_NO = G.STUDENT_NO)   
        WHERE D.DEPARTMENT_NAME = '국어국문학과' 
        group by S1.STUDENT_NO, S1.STUDENT_NAME 
        ORDER BY 평점 DESC
       ) V                        
 WHERE ROWNUM <= 1;
 
-- 19. 춘 기술대학교의 "환경조경학과"가 속한 같은 계열 학과들의 
-- 학과 별 전공과목 평점을 파악하기 위한 적절핚 SQL 문을 찾아내시오. 
-- 단, 출력헤더는 "계열 학과명", "전공평점"으로 표시되도록 하고, 
-- 평점은 소수점 한 자리까지만 반올림하여 표시되도록 한다.
SELECT 
      V.DEPARTMENT_NAME "계열 학과명"
    , ROUND(AVG(G.POINT),1) "전공평점"
FROM (SELECT D.*
        FROM TB_DEPARTMENT D
       WHERE D.CATEGORY = (SELECT D.CATEGORY
                             FROM TB_DEPARTMENT D
                            WHERE D.DEPARTMENT_NAME = '환경조경학과')
        ) V --환경조경학과와 같은 계열의 학과 뷰
  JOIN TB_CLASS C ON(V.DEPARTMENT_NO = C.DEPARTMENT_NO)
  JOIN TB_GRADE G ON (C.CLASS_NO=G.CLASS_NO)
 WHERE C.CLASS_TYPE LIKE '전공%' 
 GROUP BY V.DEPARTMENT_NAME;


-- 한경조경학과 계열 학과들
 SELECT 
        D.*
   FROM TB_DEPARTMENT D
  WHERE D.CATEGORY = (SELECT D.CATEGORY
                        FROM TB_DEPARTMENT D
                        WHERE D.DEPARTMENT_NAME = '환경조경학과'); 

-- 환경조경학과 계열  
SELECT D.CATEGORY
  FROM TB_DEPARTMENT D
 WHERE D.DEPARTMENT_NAME = '환경조경학과' ;

