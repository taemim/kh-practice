--1. SYSDATE를 기준으로 만 65세가 된 교수는 정년퇴임 명단에 넣고자 한다. 
--대상자들을 찾는 적절한 SQL 구문을 작성하시오.
SELECT 
       P.PROFESSOR_NAME 교수이름
     , D.CATEGORY 계열명
     , D.DEPARTMENT_NAME 학과명
     , FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE(SUBSTR(PROFESSOR_SSN, 1, 6), 'RRMMDD')) / 12) 나이
  FROM TB_PROFESSOR P 
  JOIN TB_DEPARTMENT D USING (DEPARTMENT_NO)
 WHERE FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE(SUBSTR(PROFESSOR_SSN, 1, 6), 'RRMMDD')) / 12) = 65
 ORDER BY 1;
 

--2. '국어국문학과'에서는 정년퇴임하는 교수를 위해 고별회를 열고자 한다. 
--해당 교수가 지도교수인 학생 중 학점이 가장 높은 우수 학생이 대표로 행사에 참여하도록 조회하는 SQL 구문을 작성하시오.
SELECT 
       (SELECT P.PROFESSOR_NAME
          FROM TB_PROFESSOR P
          JOIN TB_DEPARTMENT D USING(DEPARTMENT_NO)
         WHERE FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE(CONCAT('19', SUBSTR(PROFESSOR_SSN, 1, 6)), 'RRRRMMDD')) / 12) = 65
           AND D.DEPARTMENT_NAME = '국어국문학과') "교수 이름"
     , V.STUDENT_NAME "학생 이름"
  FROM (SELECT
               S.STUDENT_NAME
             , AVG(G.POINT) 평점
          FROM TB_STUDENT S
          JOIN TB_GRADE G ON(S.STUDENT_NO = G.STUDENT_NO)
         WHERE S.COACH_PROFESSOR_NO = (SELECT P.PROFESSOR_NO
                                         FROM TB_PROFESSOR P
                                         JOIN TB_DEPARTMENT D USING(DEPARTMENT_NO)
                                        WHERE FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE(CONCAT('19', SUBSTR(PROFESSOR_SSN, 1, 6)), 'RRRRMMDD')) / 12) = 65
                                          AND D.DEPARTMENT_NAME = '국어국문학과')
         GROUP BY S.STUDENT_NAME
         ORDER BY 평점 DESC) V
 WHERE ROWNUM = 1;


-- 3. 2006년 1학기부터 '정책사례연구' 과목은 전 학기 선수과목의 학점이 2.0 이상이어야 한다. 
-- 정책사례 연구 수업을 듣기위해 선수과목을 재수강해야 할 학생의 
-- 이름, 선수과목명, 수강학기, 학점을 조회하는 SQL 구문을 작성하시오.
SELECT 
       S.STUDENT_NAME 학생명
     , C.CLASS_NAME 선수과목명
     , G.TERM_NO 수강학기
     , G.POINT 학점
  FROM TB_STUDENT S
     , TB_DEPARTMENT D
     , TB_CLASS C
     , TB_GRADE G
WHERE S.DEPARTMENT_NO = D.DEPARTMENT_NO
  AND D.DEPARTMENT_NO = C.DEPARTMENT_NO
  AND C.CLASS_NO = G.CLASS_NO
  AND C.CLASS_NO = ( SELECT C1.PREATTENDING_CLASS_NO
                       FROM TB_CLASS C1
                      WHERE C1.CLASS_NAME ='정책사례연구'
                   )
  AND G.POINT < 2.0     
  AND G.TERM_NO = '200502';

-- 정책사례연구 선수과목 번호
SELECT C1.PREATTENDING_CLASS_NO
FROM TB_CLASS C1
WHERE C1.CLASS_NAME ='정책사례연구';


--4. 2056년 '자연과학대학'에서 코로나 종식 기념 신입생 환영회 술자리를 열었다. 
--이 학과의 교수 중 성이 전씨인 교수님이 만취하고 말았다..
-- 해당 교수와 집이 가장 가까운 학생이 교수님들 댁까지 모셔다 드리기로 한다. 
--주소의 구가 같고 교수와 성별이 같은 학생 중 알맞은 사람을 조회하는 SQL 구문을 작성하시오.
--(단, 교수의 주소와 학생의 주소는 INSERT(교수주소,1,'구')) )
SELECT 
       VP.교수이름
     , VP.교수주소
     , VS.학생이름
     , VS.학생주소
FROM (SELECT P.PROFESSOR_NAME 교수이름
           , SUBSTR(P.PROFESSOR_ADDRESS,1,INSTR(P.PROFESSOR_ADDRESS,'구',1)) 교수주소
           , DECODE(SUBSTR(P.PROFESSOR_SSN,8,1),'1','남','여') 성별
           , D.CATEGORY 단과
       FROM TB_PROFESSOR P
            , TB_DEPARTMENT D
       WHERE P.DEPARTMENT_NO = D.DEPARTMENT_NO
       AND D.CATEGORY = '자연과학') VP
       JOIN (SELECT  S1.STUDENT_NAME 학생이름
                    , SUBSTR(S1.STUDENT_ADDRESS,1,INSTR(S1.STUDENT_ADDRESS,'구',1)) 학생주소
                    , DECODE(SUBSTR(S1.STUDENT_SSN,8,1),'1','남','여') 성별
                    , D.CATEGORY 단과
               FROM TB_STUDENT S1
                    , TB_DEPARTMENT d
               WHERE S1.DEPARTMENT_NO = D.DEPARTMENT_NO
               AND D.CATEGORY = '자연과학') VS
         ON (VP.단과 = VS.단과)
WHERE VP.교수주소 = VS.학생주소 
AND VP.교수이름 LIKE '전%'
AND VP.성별 = VP.성별 ;


--2040년 동기 엠티를 가고자 한다. 
--환갑이 넘은 동문들을 위해 ‘서울’에 사는 동문들을 대상으로 버스 대절 인원 명단을 만들려고 한다.
CREATE TABLE TB_BUS
(
  NAME VARCHAR2(10)
, SSN VARCHAR2(14)
, DEPARTMENT VARCHAR2(40)
, CATEGORY VARCHAR2(40)
, ADDRESS VARCHAR2(200)
);


INSERT INTO TB_BUS
SELECT  
        S.STUDENT_NAME
      , S.STUDENT_SSN
      , D.DEPARTMENT_NAME 
      , D.CATEGORY 
      , S.STUDENT_ADDRESS
  FROM TB_STUDENT S
  JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
  WHERE FLOOR(MONTHS_BETWEEN(TO_DATE('400101', 'YYMMDD'), TO_DATE(SUBSTR(STUDENT_SSN, 1, 6), 'RRMMDD')) / 12) >= 60
  AND S.STUDENT_ADDRESS LIKE '서울%';

DELETE TB_BUS
WHERE NAME IN (SELECT S.STUDENT_NAME
                FROM TB_STUDENT S
                JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO= D.DEPARTMENT_NO)
                WHERE D.DEPARTMENT_NAME = '호텔관광학과');

ALTER TABLE TB_BUS
ADD(ROOM CHAR(1));

ROLLBACK;
 