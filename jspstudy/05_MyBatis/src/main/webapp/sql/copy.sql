INSERT INTO BOARD(BOARD_NO, TITLE, CONTENT,CREATE_DATE)
VALUES (BOARD_SEQ.NEXTVAL, #{title}, #{content}, SYSDATE);