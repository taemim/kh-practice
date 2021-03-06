-- 과제 [DML]

--1. INSERT 행 추가
INSERT INTO TB_CLASS_TYPE VALUES ('01','전공필수');
INSERT INTO TB_CLASS_TYPE VALUES ('02','전공선택');
INSERT INTO TB_CLASS_TYPE VALUES ('03','교양필수');
INSERT INTO TB_CLASS_TYPE VALUES ('04','교양선택');
INSERT INTO TB_CLASS_TYPE VALUES ('05','논문지도');

-- NAME 컬럼 자료형 크기 수정
ALTER TABLE TB_CLASS_TYPE
MODIFY NAME VARCHAR2(20); 


--2. 서브쿼리를 활용한 테이블 생성
CREATE TABLE TB_학생일반정보
AS
SELECT
       S.STUDENT_NO 학번
     , S.STUDENT_NAME 학생이름
     , S.STUDENT_ADDRESS 주소
  FROM TB_STUDENT S;


--3. 학과정보 테이블 생성
CREATE TABLE TB_국어국문학과
AS
SELECT S.STUDENT_NO 학번
     , S.STUDENT_NAME 학생이름
     , TO_DATE(SUBSTR(STUDENT_SSN,1,2),'YYYY') 출생년도
     , NVL(P.PROFESSOR_NAME, '지도교수 미지정') 지도교수
  FROM TB_STUDENT S
  LEFT JOIN TB_PROFESSOR P ON(S.COACH_PROFESSOR_NO = P.PROFESSOR_NO)
  JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
 WHERE D.DEPARTMENT_NAME = '국어국문학과';


--오라클 전용 구문
CREATE TABLE TB_국어국문학과2
AS 
SELECT STUDENT_NO 학번
     , STUDENT_NAME 학생이름
     , 19||SUBSTR(STUDENT_SSN,1,2) 출생년도
     , PROFESSOR_NAME 교수이름
  FROM TB_STUDENT S
     , TB_PROFESSOR P
     , TB_DEPARTMENT D
 WHERE S.COACH_PROFESSOR_NO = P.PROFESSOR_NO(+)
   AND S.DEPARTMENT_NO = D.DEPARTMENT_NO
   AND DEPARTMENT_NAME = '국어국문학과';


--4. 컬럼에 값을 10% 증가시키기
UPDATE TB_DEPARTMENT D
   SET D.CAPACITY = ROUND(D.CAPACITY * 1.1);

-- 증가된 값 확인
SELECT D.CAPACITY 
FROM TB_DEPARTMENT D;


--5. 학생의 주소지 변경
UPDATE TB_STUDENT S
SET S.STUDENT_ADDRESS = '서울시 종로구 숭인동 181-21' 
WHERE S.STUDENT_NO = 'A413042';

-- 변경된 값 확인
SELECT S.*
  FROM TB_STUDENT S
 WHERE S.STUDENT_NO = 'A413042';


--6.학생정보 테이블에서 주민번호 뒷자리를 저장하지 않기로 함.
UPDATE TB_STUDENT S
SET S.STUDENT_SSN = SUBSTR(S.STUDENT_SSN,1,6);


--7.학생의 과목 성적 정정
UPDATE TB_GRADE G
SET G.POINT ='3.3'
WHERE (G.STUDENT_NO,G.CLASS_NO,G.TERM_NO) 
      IN (SELECT S.STUDENT_NO
               , C.CLASS_NO
               , G.TERM_NO
            FROM TB_STUDENT S
            JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
            JOIN TB_CLASS C ON (D.DEPARTMENT_NO = C.DEPARTMENT_NO)
            JOIN TB_GRADE G ON (C.CLASS_NO = G.CLASS_NO)
           WHERE S.STUDENT_NAME = '김명훈'
             AND D.DEPARTMENT_NAME = '의학과'
             AND C.CLASS_NAME = '피부생리학'
             AND G.TERM_NO = '200501');    
--정답코드 )             
UPDATE 
       TB_GRADE
   SET POINT = 3.5
 WHERE TERM_NO = '200501'
   AND STUDENT_NO = (SELECT STUDENT_NO
                       FROM TB_STUDENT
                       JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
                      WHERE STUDENT_NAME = '김명훈'
                        AND DEPARTMENT_NAME = '의학과')
   AND CLASS_NO = (SELECT CLASS_NO
                     FROM TB_CLASS
                    WHERE CLASS_NAME = '피부생리학');
        

-- 8. 휴학생들의 성적항목을 제거
DELETE FROM TB_GRADE G
WHERE G.STUDENT_NO IN (SELECT S.STUDENT_NO
                         FROM TB_STUDENT S
                        WHERE S.ABSENCE_YN ='Y'
                       ); -- 483행 삭제
                  
ROLLBACK;