--
SELECT * FROM t1 WHERE c1 = (SELECT MAX (c1) AS c1 FROM t2);

--
SELECT * FROM t1 WHERE c1 = 2;

--
SELECT * FROM t1 WHERE c1 = (SELECT c1 FROM t2);

--
SELECT *
  FROM t1
 WHERE c1 = (SELECT MAX (c1) FROM t2)
   AND c2 = (SELECT MAX (c2) FROM t2);

--
SELECT * FROM t1 WHERE (c1, c2) = (SELECT MAX (c1), MAX (c2) FROM t2);

--
SELECT * FROM t1 WHERE (c1, c2) = ((2, 3));

--
SELECT   c1, MIN (c2) AS c2
    FROM t1
GROUP BY c1
  HAVING MIN (c2) = (SELECT MIN (c1) FROM t2);

--
SELECT * FROM t1 WHERE c1 IN (SELECT c1 FROM t2);

--
SELECT * FROM t1 WHERE c1 IN (1, 2);

--
SELECT * FROM t1 WHERE c1 IN (SELECT DISTINCT c1 FROM t2);

--
SELECT * FROM t1 WHERE (c1, c2) IN (SELECT c1, c2 FROM t2);

--
SELECT * FROM t1 WHERE c1 NOT IN (SELECT c1 FROM t2);

--
SELECT * FROM t1 WHERE c2 NOT IN (SELECT c2 FROM t2);

--
SELECT * FROM t1 WHERE c2 NOT IN (2, 3, NULL);

--
SELECT * FROM t1 WHERE c2 NOT IN (SELECT c2 FROM t2 WHERE c2 IS NOT NULL);

--
SELECT * FROM t1 WHERE (c1, c2) NOT IN (SELECT c1, c2 FROM t2);

--
SELECT * FROM t1 WHERE (c1, c2) NOT IN ((1, 2), (2, 3), (2, NULL));

--
SELECT * FROM t1 WHERE (c1, c2) NOT IN (SELECT c1, c2 FROM t2 WHERE c2 IS NOT NULL);

--
SELECT *
  FROM t1
 WHERE c1 > ALL (SELECT c1 FROM t2);

SELECT *
  FROM t1
 WHERE c1 > (SELECT MAX (c1) FROM t2);

--
SELECT a.* FROM t1 a WHERE a.c2 = (SELECT MAX (x.c2) FROM t2 x WHERE x.c1 = a.c1);

--
SELECT a.* FROM t1 a WHERE EXISTS (SELECT 1 FROM t2 x WHERE x.c1 = a.c1);

--
SELECT a.*
  FROM t1 a
 WHERE a.c1 = 2
   AND EXISTS (SELECT 1
                 FROM t2 x
                WHERE x.c2 = a.c2);

SELECT a.*
  FROM t1 a
 WHERE EXISTS (SELECT 1
                 FROM t2 x
                WHERE a.c1 = 2
                  AND x.c2 = a.c2);

--
SELECT a.*
  FROM t1 a
 WHERE EXISTS (SELECT 1 FROM DUAL WHERE a.c1 = 2 UNION ALL
               SELECT 1 FROM t2 x WHERE x.c2 = a.c2);

--
SELECT a.* FROM t1 a WHERE EXISTS (SELECT 1 FROM t2 x WHERE x.c1 = c1);

--
SELECT a.* FROM t1 a WHERE EXISTS (SELECT 1 FROM t2 x WHERE x.c1 = x.c1);

--
SELECT a.* FROM t1 a WHERE NOT EXISTS (SELECT 1 FROM t2 x WHERE x.c1 = a.c1);

--
SELECT a.*
  FROM t1 a
 WHERE a.c1 = 2
   AND NOT EXISTS (SELECT 1
                     FROM t2 x
                    WHERE x.c2 = a.c2);

SELECT a.*
  FROM t1 a
 WHERE NOT EXISTS (SELECT 1
                     FROM t2 x
                    WHERE a.c1 = 2
                      AND x.c2 = a.c2);

--
SELECT a.*
  FROM t1 a
 WHERE NOT EXISTS (SELECT 1 FROM t2 x WHERE a.c1 != 2 AND x.c2 = a.c2);

--
SELECT ����ȣ, ����
  FROM ��
 WHERE ����ȣ = (SELECT MAX (�ֹ�����ȣ) KEEP (DENSE_RANK FIRST ORDER BY �ֹ����� DESC)
                     FROM �ֹ�);

--
SELECT �ֹ���ȣ, �ֹ�����
  FROM �ֹ�
 WHERE �ֹ�����ȣ = (SELECT ����ȣ FROM ���ΰ� WHERE �ֹι�ȣ = '0101013000001');

--
SELECT b.�ֹ���ȣ, b.�ֹ�����
  FROM ���ΰ� a, �ֹ� b
 WHERE a.�ֹι�ȣ = '0101013000001'
   AND b.�ֹ�����ȣ = a.����ȣ;

--
CREATE OR REPLACE FUNCTION f1 (i_�ֹι�ȣ IN VARCHAR2) RETURN NUMBER
IS
    l_����ȣ ���ΰ�.����ȣ%TYPE;
BEGIN
    SELECT ����ȣ INTO l_����ȣ FROM ���ΰ� WHERE �ֹι�ȣ = i_�ֹι�ȣ;
    RETURN l_����ȣ;
END f1;
/

--
SELECT �ֹ���ȣ, �ֹ�����
  FROM �ֹ�
 WHERE �ֹ�����ȣ = f1 ('0101013000001');

--
SELECT �ֹ���ȣ, �ֹ�����
  FROM �ֹ�
 WHERE �ֹ�����ȣ = (SELECT f1 ('0101013000001') FROM DUAL);

--
SELECT a.����ȣ, b.�ֹ���ȣ, b.�ֹ�����
  FROM ���ΰ� a, �ֹ� b
 WHERE b.�ֹ�����ȣ = a.����ȣ
   AND b.�ֹ����� = (SELECT MAX (x.�ֹ�����) FROM �ֹ� x WHERE x.�ֹ�����ȣ = a.����ȣ);

--
SELECT a.*
  FROM t1 a
 WHERE (SELECT MAX (x.c2)
          FROM t2 x
         WHERE x.c1 = a.c1) >= 3;

SELECT *
  FROM t1
 WHERE c1 IN (SELECT   c1
                  FROM t2
              GROUP BY c1
                HAVING MAX (c2) >= 3);

--
SELECT a.*
  FROM t1 a
 WHERE (SELECT MAX (1)
          FROM t2 x
         WHERE x.c1 = a.c1) IS NOT NULL;

SELECT a.*
  FROM t1 a
 WHERE EXISTS (SELECT 1
                 FROM t2 x
                WHERE x.c1 = a.c1);

--
SELECT deptno, dname
  FROM dept
 WHERE deptno IN (SELECT deptno FROM emp);

SELECT a.deptno, a.dname
  FROM dept a
 WHERE EXISTS (SELECT 1
                 FROM emp x
                WHERE x.deptno = a.deptno);

--
SELECT *
  FROM t1
 WHERE c2 IN (SELECT c2 FROM t2);

SELECT a.*
  FROM t1 a
 WHERE EXISTS (SELECT 1
                 FROM t2 x
                WHERE x.c2 = a.c2);

--
SELECT *
  FROM t1
 WHERE c2 NOT IN (SELECT c2 FROM t2);

SELECT a.*
  FROM t1 a
 WHERE NOT EXISTS (SELECT 1
                     FROM t2 x
                    WHERE x.c2 = a.c2);

--
SELECT *
  FROM t1
 WHERE (c1, c2) NOT IN (SELECT c1, c2 FROM t2);

SELECT a.*
  FROM t1 a
 WHERE NOT EXISTS (SELECT 1
                     FROM t2 x
                    WHERE x.c1 = a.c1
                      AND x.c2 = a.c2);
