--
CREATE TABLE 부서 (
    부서번호     NUMBER       NOT NULL
  , 부서명       VARCHAR2(10) NOT NULL
  , 상위부서번호 NUMBER           NULL
  , CONSTRAINTS 부서_PK PRIMARY KEY (부서번호)
  , CONSTRAINTS 부서_F1 FOREIGN KEY (상위부서번호) REFERENCES 부서 (부서번호));

--
CREATE TABLE 사원 (
    사원번호     NUMBER       NOT NULL
  , 사원명       VARCHAR2(10) NOT NULL
  , 급여         NUMBER       NOT NULL
  , 소속부서번호 NUMBER       NOT NULL
  , CONSTRAINTS 사원_PK PRIMARY KEY (사원번호)
  , CONSTRAINTS 사원_F1 FOREIGN KEY (소속부서번호) REFERENCES 부서 (부서번호));
