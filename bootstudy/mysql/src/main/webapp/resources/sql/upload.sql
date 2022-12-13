USE team;

-- 다중 첨부(게시글 하나에 여러 개의 첨부가 가능)


-- 드랍 테이블
DROP TABLE IF EXISTS ATTACH;
DROP TABLE IF EXISTS UPLOAD;
-- 파일 첨부 정보


-- 게시판

CREATE TABLE UPLOAD
(
    UPLOAD_NO INT NOT NULL AUTO_INCREMENT,  -- PK
    TITLE VARCHAR(100),   -- 제목
    CONTENT VARCHAR(100), -- 내용
    CREATE_DATE DATETIME,      -- 작성일
    MODIFY_DATE DATETIME,    -- 수정일
	CONSTRAINT PK_UPLOAD PRIMARY KEY(UPLOAD_NO)
);


CREATE TABLE ATTACH
(
    ATTACH_NO INT NOT NULL AUTO_INCREMENT,     -- PK
    PATH VARCHAR(300),       -- 파일의 경로
    ORIGIN VARCHAR(300),     -- 파일의 원래 이름
    FILESYSTEM VARCHAR(42),  -- 파일의 저장된 이름
    DOWNLOAD_CNT INT,           -- 다운로드 횟수
    HAS_THUMBNAIL SMALLINT,          -- 썸네일이 있으면 1, 없으면 0
    UPLOAD_NO INT,              -- 게시글번호, FK
	CONSTRAINT PK_ATTACH PRIMARY KEY(ATTACH_NO),
    CONSTRAINT FK_ATTACH_UPLOAD
        FOREIGN KEY(UPLOAD_NO) REFERENCES UPLOAD(UPLOAD_NO)
            ON DELETE CASCADE
);

-- 페이징 처리 없는 목록 보기 쿼리 2종
-- 1. 조인
SELECT U.UPLOAD_NO, U.TITLE, U.CONTENT, U.CREATE_DATE, U.MODIFY_DATE, COUNT(A.ATTACH_NO) AS ATTACH_CNT
  FROM UPLOAD U LEFT OUTER JOIN ATTACH A
    ON U.UPLOAD_NO = A.UPLOAD_NO
 GROUP BY U.UPLOAD_NO, U.TITLE, U.CONTENT, U.CREATE_DATE, U.MODIFY_DATE;

-- 2. 스칼라 서브쿼리
SELECT U.UPLOAD_NO, U.TITLE, U.CONTENT, U.CREATE_DATE, U.MODIFY_DATE, (SELECT COUNT(*) FROM ATTACH A WHERE U.UPLOAD_NO = A.UPLOAD_NO) AS ATTACH_CNT
  FROM UPLOAD U;


-- 페이징 처리한 목록 보기 쿼리
SELECT U.UPLOAD_NO, U.TITLE, U.CONTENT, U.CREATE_DATE, U.MODIFY_DATE, (SELECT COUNT(*) FROM ATTACH A WHERE U.UPLOAD_NO = A.UPLOAD_NO) AS ATTACH_CNT
  FROM (SELECT ROW_NUMBER() OVER(ORDER BY UPLOAD_NO DESC) AS ROW_NUM, UPLOAD_NO, TITLE, CONTENT, CREATE_DATE, MODIFY_DATE
          FROM UPLOAD) U
 WHERE U.ROW_NUM BETWEEN 1 AND 5;