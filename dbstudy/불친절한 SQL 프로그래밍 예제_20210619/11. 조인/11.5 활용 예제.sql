--
SELECT   a.상품코드
       , CASE b.사원번호 WHEN a.기획담당사번 THEN '기획' ELSE '구매' END AS 담당
       , b.사원명
    FROM 상품 a, 사원 b
   WHERE b.사원번호 IN (a.기획담당사번, a.구매담당사번)
ORDER BY 1, 2;

--
SELECT   a.상품코드
       , CASE b.사원번호 WHEN a.기획담당사번 THEN '기획' ELSE '구매' END AS 담당
       , b.사원명
    FROM 상품 a, 사원 b
   WHERE (b.사원번호 = a.기획담당사번 OR b.사원번호 = a.구매담당사번)
ORDER BY 1, 2;

--
SELECT   a.상품코드, b.부서명
    FROM 상품 a, 부서 b
   WHERE a.상품코드 = 'A'
     AND ',' || a.관련부서목록 || ',' LIKE '%,' || b.부서번호 || ',%'
ORDER BY 2;

--
SELECT   a.상품코드, b.부서명
    FROM 상품 a, 부서 b
   WHERE a.상품코드 = 'A'
     AND INSTR (',' || a.관련부서목록 || ',', ',' || b.부서번호 || ',') >= 1
ORDER BY 2;

--
SELECT   a.상품코드, b.시작일자, b.종료일자, b.상품가격
    FROM 상품 a, 상품가격 b
   WHERE b.상품코드 = a.상품코드
ORDER BY 1, 2;

--
SELECT   a.상품코드, b.시작일자, b.종료일자, b.상품가격
    FROM 상품 a, 상품가격 b
   WHERE b.상품코드 = a.상품코드
     AND b.상품가격 >= 400
ORDER BY 1, 2;

--
SELECT   a.상품코드, b.시작일자, b.종료일자, b.상품가격
    FROM 상품 a, 상품가격 b
   WHERE b.상품코드(+) = a.상품코드
     AND b.상품가격(+) >= 400
ORDER BY 1, 2;

--
SELECT   a.상품코드, b.발행일자, b.만료일자, b.할인비율
    FROM 상품 a, 할인쿠폰 b
   WHERE b.대상상품코드(+) = a.상품코드
ORDER BY 1, 2, 3;

--
SELECT   a.상품코드, b.사원명 AS 기획담당사원명, c.사원명 AS 구매담당사원명
    FROM 상품 a, 사원 b, 사원 c
   WHERE b.사원번호    = a.기획담당사번
     AND c.사원번호(+) = a.구매담당사번
ORDER BY 1;

--
SELECT   a.고객명, b.주민번호
    FROM 고객 a, 개인고객 b
   WHERE b.고객번호 = a.고객번호
ORDER BY 1;

--
SELECT   a.상품명, b.시작일자, b.종료일자, b.상품가격
    FROM 상품 a, 상품가격 b
   WHERE a.상품코드 = 'A'
     AND b.상품코드 = a.상품코드
ORDER BY 2;

--
SELECT a.상품명, b.시작일자, b.종료일자, b.상품가격
  FROM 상품 a, 상품가격 b
 WHERE a.상품코드 = 'A'
   AND b.상품코드 = a.상품코드
   AND b.시작일자 = DATE '2012-01-01';

--
SELECT a.상품명, b.시작일자, b.종료일자, b.상품가격
  FROM 상품 a, 상품가격 b
 WHERE a.상품코드 = 'A'
   AND b.상품코드 = a.상품코드
   AND b.종료일자 = DATE '9999-12-31';

--
SELECT a.상품명, b.시작일자, b.종료일자, b.상품가격
  FROM 상품 a, 상품가격 b
 WHERE a.상품코드 = 'A'
   AND b.상품코드(+) = a.상품코드
   AND SYSDATE BETWEEN b.시작일자(+) AND b.종료일자(+);

--
SELECT   a.주문일자, b.상품코드, b.주문수량
       , c.상품가격, d.할인비율, c.상품가격 * NVL (1 - d.할인비율, 1) AS 할인가격
    FROM 주문 a, 주문상세 b, 상품가격 c, 할인쿠폰 d
   WHERE a.주문일자 >= DATE '2011-07-01'                    -- (1) 일반 (a)
     AND b.주문번호 = a.주문번호                            -- (2) 조인 (b = a)
     AND b.주문수량 >= 100                                  -- (3) 일반 (b)
     AND c.상품코드 = b.상품코드                            -- (4) 조인 (c = b)
     AND a.주문일자 BETWEEN c.시작일자 AND c.종료일자       -- (5) 조인 (c >= a AND c <= a)
     AND d.대상상품코드(+) = c.상품코드                     -- (6) 조인 (d = c)
     AND a.주문일자 BETWEEN d.발행일자(+) AND d.만료일자(+) -- (7) 조인 (d >= a AND d <= a)
ORDER BY 1, 2, 3;

--
SELECT   a.주문일자, b.상품코드, b.주문수량
       , c.상품가격, d.할인비율, c.상품가격 * NVL (1 - d.할인비율, 1) AS 할인가격
    FROM 주문 a, 주문상세 b, 상품가격 c, 할인쿠폰 d
   WHERE a.주문번호 = b.주문번호
     AND a.주문일자 BETWEEN c.시작일자 AND c.종료일자
     AND a.주문일자 BETWEEN d.발행일자(+) AND d.만료일자(+)
     AND a.주문일자 >= DATE '2011-07-01'
     AND b.상품코드 = c.상품코드
     AND b.주문수량 >= 100
     AND c.상품코드 = d.대상상품코드(+)
ORDER BY 1, 2, 3;

--
SELECT   a.주문일자, b.상품코드, b.주문수량
       , c.상품가격, d.할인비율, c.상품가격 * NVL (1 - d.할인비율, 1) AS 할인가격
    FROM 주문 a, 주문상세 b, 상품가격 c, 할인쿠폰 d
   WHERE a.주문번호 = b.주문번호
     AND b.상품코드 = c.상품코드
     AND c.상품코드 = d.대상상품코드(+)
     AND a.주문일자 BETWEEN c.시작일자 AND c.종료일자
     AND a.주문일자 BETWEEN d.발행일자(+) AND d.만료일자(+)
     AND a.주문일자 >= DATE '2011-07-01'
     AND b.주문수량 >= 100
ORDER BY 1, 2, 3;

--
DROP TABLE 복제 PURGE;
CREATE TABLE 복제 AS SELECT ROWNUM AS 순번 FROM XMLTABLE ('1 to 100');

--
SELECT * FROM 복제;

--
SELECT   CASE b.순번 WHEN 1 THEN a.상품코드 END AS 상품코드
       , SUM (판매금액) AS 판매금액
    FROM 판매통계 a, 복제 b
   WHERE b.순번 <= 2
GROUP BY CASE b.순번 WHEN 1 THEN a.상품코드 END
ORDER BY 1;

--
SELECT   상품코드, SUM (판매금액) AS 판매금액
    FROM 판매통계
GROUP BY ROLLUP (상품코드)
ORDER BY 1;

--
SELECT   a.상품코드
       , CASE b.순번 WHEN 1 THEN '기획' ELSE'구매' END AS 담당
       , c.사원명
    FROM 상품 a, 복제 b, 사원 c
   WHERE b.순번 <= 2
     AND c.사원번호 = CASE b.순번 WHEN 1 THEN a.기획담당사번 ELSE a.구매담당사번 END
ORDER BY 1, 2, 3;

--
SELECT   a.상품코드, c.부서명
    FROM 상품 a, 복제 b, 부서 c
   WHERE a.상품코드 = 'A'
     AND b.순번 <= REGEXP_COUNT (a.관련부서목록, ',') + 1
     AND c.부서번호 = REGEXP_SUBSTR (a.관련부서목록, '[^,]+', 1, b.순번)
ORDER BY b.순번;

--
SELECT b.부서번호, b.부서명
  FROM 부서 a, 부서 b
 WHERE a.부서번호 = 3
   AND b.부서번호 = a.상위부서번호;

--
SELECT c.부서번호, c.부서명
  FROM 부서 a, 부서 b, 부서 c
 WHERE a.부서번호 = 3
   AND b.부서번호 = a.상위부서번호
   AND c.부서번호 = b.상위부서번호;

--
SELECT   a.상품코드, a.기준연월, a.판매금액, SUM (b.판매금액) AS 누적판매금액
    FROM 판매통계 a, 판매통계 b
   WHERE b.상품코드 = a.상품코드
     AND b.기준연월 <= a.기준연월
GROUP BY a.상품코드, a.기준연월, a.판매금액
ORDER BY 1, 2;

--
SELECT   상품코드, 기준연월, 판매금액
       , SUM (판매금액) OVER (PARTITION BY 상품코드 ORDER BY 기준연월) AS 누적판매금액
    FROM 판매통계
ORDER BY 1, 2;

--
SELECT a.ename, a.sal, b.grade, b.losal, b.hisal
  FROM emp a, salgrade b
 WHERE a.deptno = 10
   AND a.sal BETWEEN b.losal AND b.hisal;

--
SELECT a.ename, a.sal, b.grade, b.losal, b.hisal
  FROM emp a, salgrade b
 WHERE a.deptno = 10
   AND b.losal <= a.sal
   AND b.hisal >= a.sal;

--
SELECT   a.*, b.발행일자, b.만료일자, b.할인비율
    FROM 상품가격 a, 할인쿠폰 b
   WHERE a.상품코드 = 'A'
     AND b.대상상품코드 = a.상품코드
     AND b.발행일자 <= a.종료일자
     AND b.만료일자 >= a.시작일자
ORDER BY a.시작일자, b.발행일자;

--
DROP TABLE 연월 PURGE;

CREATE TABLE 연월 AS
SELECT TO_CHAR (ADD_MONTHS (DATE '2011-01-01', ROWNUM - 1), 'YYYYMM') AS 기준연월
     , ADD_MONTHS (DATE '2011-01-01', ROWNUM - 1)                     AS 시작일자
     , ADD_MONTHS (DATE '2011-01-01', ROWNUM) -1                      AS 종료일자
  FROM XMLTABLE ('1 to 24');

--
SELECT * FROM 연월;

--
SELECT   a.기준연월
       , MAX (b.상품가격) KEEP (DENSE_RANK FIRST ORDER BY a.시작일자 DESC) AS 상품가격
    FROM 연월 a, 상품가격 b
   WHERE a.기준연월 BETWEEN '201110' AND '201203'
     AND b.상품코드(+) = 'A'
     AND b.시작일자(+) <= a.종료일자
     AND b.종료일자(+) >= a.시작일자
GROUP BY a.기준연월
ORDER BY 1;

--
SELECT   a.고객번호, a.고객유형, NVL (b.주민번호, c.법인번호) AS 식별번호
    FROM 고객 a, 개인고객 b, 법인고객 c
   WHERE b.고객번호(+) = a.고객번호
     AND c.고객번호(+) = a.고객번호
ORDER BY 1;

--
SELECT   a.고객번호, a.고객유형, NVL (b.주민번호, c.법인번호) AS 식별번호
    FROM 고객 a, 개인고객 b, 법인고객 c
   WHERE b.고객번호(+) = DECODE (a.고객유형, 'P', a.고객번호)
     AND c.고객번호(+) = DECODE (a.고객유형, 'C', a.고객번호)
ORDER BY 1;

--
SELECT   a.상품코드, NVL2 (a.구매담당사번, '구매', '기획') AS 담당, b.사원명
    FROM 상품 a, 사원 b
   WHERE b.사원번호 = COALESCE (a.구매담당사번, a.기획담당사번)
ORDER BY 1;

--
SELECT   a.상품코드, b.사원명, b.소속부서번호
    FROM 상품 a, 사원 b
   WHERE b.사원번호 = DECODE (b.소속부서번호, 2, a.기획담당사번, 3, a.구매담당사번)
ORDER BY 1, 2;

--
SELECT   a.상품코드, b.사원명, b.소속부서번호
    FROM 상품 a, 사원 b
   WHERE (   (b.사원번호 = a.기획담당사번 AND b.소속부서번호 = 2)
          OR (b.사원번호 = a.구매담당사번 AND b.소속부서번호 = 3))
ORDER BY 1, 2;

--
SELECT   a.기준연월, NVL (b.판매금액, 0) AS 판매금액
    FROM 연월 a
    LEFT OUTER
    JOIN 판매통계 b
      ON b.기준연월 = a.기준연월
     AND b.상품코드 = 'A'
   WHERE a.기준연월 LIKE '2011%'
ORDER BY 1;

--
SELECT   b.상품코드, a.기준연월, NVL (b.판매금액, 0) AS 판매금액
    FROM 연월 a
    LEFT OUTER
    JOIN 판매통계 b
      ON b.기준연월 = a.기준연월
     AND b.상품코드 IN ('A', 'B')
   WHERE a.기준연월 LIKE '2011%'
ORDER BY 1, 2;

--
SELECT   a.상품코드, b.기준연월, NVL (c.판매금액, 0) AS 판매금액
    FROM (상품 a CROSS JOIN 연월 b)
    LEFT OUTER
    JOIN 판매통계 c
      ON c.상품코드 = a.상품코드
     AND c.기준연월 = b.기준연월
   WHERE a.상품코드 IN ('A', 'B')
     AND b.기준연월 LIKE '2011%'
ORDER BY 1, 2;

--
SELECT   b.상품코드, a.기준연월, b.판매금액
    FROM 연월 a
    LEFT OUTER
    JOIN 판매통계 b PARTITION BY (b.상품코드)
      ON b.기준연월 = a.기준연월
     AND b.상품코드 IN ('A', 'B')
   WHERE a.기준연월 LIKE '2011%'
ORDER BY 1, 2;
