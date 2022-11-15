--
SELECT   a.��ǰ�ڵ�
       , CASE b.�����ȣ WHEN a.��ȹ����� THEN '��ȹ' ELSE '����' END AS ���
       , b.�����
    FROM ��ǰ a, ��� b
   WHERE b.�����ȣ IN (a.��ȹ�����, a.���Ŵ����)
ORDER BY 1, 2;

--
SELECT   a.��ǰ�ڵ�
       , CASE b.�����ȣ WHEN a.��ȹ����� THEN '��ȹ' ELSE '����' END AS ���
       , b.�����
    FROM ��ǰ a, ��� b
   WHERE (b.�����ȣ = a.��ȹ����� OR b.�����ȣ = a.���Ŵ����)
ORDER BY 1, 2;

--
SELECT   a.��ǰ�ڵ�, b.�μ���
    FROM ��ǰ a, �μ� b
   WHERE a.��ǰ�ڵ� = 'A'
     AND ',' || a.���úμ���� || ',' LIKE '%,' || b.�μ���ȣ || ',%'
ORDER BY 2;

--
SELECT   a.��ǰ�ڵ�, b.�μ���
    FROM ��ǰ a, �μ� b
   WHERE a.��ǰ�ڵ� = 'A'
     AND INSTR (',' || a.���úμ���� || ',', ',' || b.�μ���ȣ || ',') >= 1
ORDER BY 2;

--
SELECT   a.��ǰ�ڵ�, b.��������, b.��������, b.��ǰ����
    FROM ��ǰ a, ��ǰ���� b
   WHERE b.��ǰ�ڵ� = a.��ǰ�ڵ�
ORDER BY 1, 2;

--
SELECT   a.��ǰ�ڵ�, b.��������, b.��������, b.��ǰ����
    FROM ��ǰ a, ��ǰ���� b
   WHERE b.��ǰ�ڵ� = a.��ǰ�ڵ�
     AND b.��ǰ���� >= 400
ORDER BY 1, 2;

--
SELECT   a.��ǰ�ڵ�, b.��������, b.��������, b.��ǰ����
    FROM ��ǰ a, ��ǰ���� b
   WHERE b.��ǰ�ڵ�(+) = a.��ǰ�ڵ�
     AND b.��ǰ����(+) >= 400
ORDER BY 1, 2;

--
SELECT   a.��ǰ�ڵ�, b.��������, b.��������, b.���κ���
    FROM ��ǰ a, �������� b
   WHERE b.����ǰ�ڵ�(+) = a.��ǰ�ڵ�
ORDER BY 1, 2, 3;

--
SELECT   a.��ǰ�ڵ�, b.����� AS ��ȹ�������, c.����� AS ���Ŵ������
    FROM ��ǰ a, ��� b, ��� c
   WHERE b.�����ȣ    = a.��ȹ�����
     AND c.�����ȣ(+) = a.���Ŵ����
ORDER BY 1;

--
SELECT   a.����, b.�ֹι�ȣ
    FROM �� a, ���ΰ� b
   WHERE b.����ȣ = a.����ȣ
ORDER BY 1;

--
SELECT   a.��ǰ��, b.��������, b.��������, b.��ǰ����
    FROM ��ǰ a, ��ǰ���� b
   WHERE a.��ǰ�ڵ� = 'A'
     AND b.��ǰ�ڵ� = a.��ǰ�ڵ�
ORDER BY 2;

--
SELECT a.��ǰ��, b.��������, b.��������, b.��ǰ����
  FROM ��ǰ a, ��ǰ���� b
 WHERE a.��ǰ�ڵ� = 'A'
   AND b.��ǰ�ڵ� = a.��ǰ�ڵ�
   AND b.�������� = DATE '2012-01-01';

--
SELECT a.��ǰ��, b.��������, b.��������, b.��ǰ����
  FROM ��ǰ a, ��ǰ���� b
 WHERE a.��ǰ�ڵ� = 'A'
   AND b.��ǰ�ڵ� = a.��ǰ�ڵ�
   AND b.�������� = DATE '9999-12-31';

--
SELECT a.��ǰ��, b.��������, b.��������, b.��ǰ����
  FROM ��ǰ a, ��ǰ���� b
 WHERE a.��ǰ�ڵ� = 'A'
   AND b.��ǰ�ڵ�(+) = a.��ǰ�ڵ�
   AND SYSDATE BETWEEN b.��������(+) AND b.��������(+);

--
SELECT   a.�ֹ�����, b.��ǰ�ڵ�, b.�ֹ�����
       , c.��ǰ����, d.���κ���, c.��ǰ���� * NVL (1 - d.���κ���, 1) AS ���ΰ���
    FROM �ֹ� a, �ֹ��� b, ��ǰ���� c, �������� d
   WHERE a.�ֹ����� >= DATE '2011-07-01'                    -- (1) �Ϲ� (a)
     AND b.�ֹ���ȣ = a.�ֹ���ȣ                            -- (2) ���� (b = a)
     AND b.�ֹ����� >= 100                                  -- (3) �Ϲ� (b)
     AND c.��ǰ�ڵ� = b.��ǰ�ڵ�                            -- (4) ���� (c = b)
     AND a.�ֹ����� BETWEEN c.�������� AND c.��������       -- (5) ���� (c >= a AND c <= a)
     AND d.����ǰ�ڵ�(+) = c.��ǰ�ڵ�                     -- (6) ���� (d = c)
     AND a.�ֹ����� BETWEEN d.��������(+) AND d.��������(+) -- (7) ���� (d >= a AND d <= a)
ORDER BY 1, 2, 3;

--
SELECT   a.�ֹ�����, b.��ǰ�ڵ�, b.�ֹ�����
       , c.��ǰ����, d.���κ���, c.��ǰ���� * NVL (1 - d.���κ���, 1) AS ���ΰ���
    FROM �ֹ� a, �ֹ��� b, ��ǰ���� c, �������� d
   WHERE a.�ֹ���ȣ = b.�ֹ���ȣ
     AND a.�ֹ����� BETWEEN c.�������� AND c.��������
     AND a.�ֹ����� BETWEEN d.��������(+) AND d.��������(+)
     AND a.�ֹ����� >= DATE '2011-07-01'
     AND b.��ǰ�ڵ� = c.��ǰ�ڵ�
     AND b.�ֹ����� >= 100
     AND c.��ǰ�ڵ� = d.����ǰ�ڵ�(+)
ORDER BY 1, 2, 3;

--
SELECT   a.�ֹ�����, b.��ǰ�ڵ�, b.�ֹ�����
       , c.��ǰ����, d.���κ���, c.��ǰ���� * NVL (1 - d.���κ���, 1) AS ���ΰ���
    FROM �ֹ� a, �ֹ��� b, ��ǰ���� c, �������� d
   WHERE a.�ֹ���ȣ = b.�ֹ���ȣ
     AND b.��ǰ�ڵ� = c.��ǰ�ڵ�
     AND c.��ǰ�ڵ� = d.����ǰ�ڵ�(+)
     AND a.�ֹ����� BETWEEN c.�������� AND c.��������
     AND a.�ֹ����� BETWEEN d.��������(+) AND d.��������(+)
     AND a.�ֹ����� >= DATE '2011-07-01'
     AND b.�ֹ����� >= 100
ORDER BY 1, 2, 3;

--
DROP TABLE ���� PURGE;
CREATE TABLE ���� AS SELECT ROWNUM AS ���� FROM XMLTABLE ('1 to 100');

--
SELECT * FROM ����;

--
SELECT   CASE b.���� WHEN 1 THEN a.��ǰ�ڵ� END AS ��ǰ�ڵ�
       , SUM (�Ǹűݾ�) AS �Ǹűݾ�
    FROM �Ǹ���� a, ���� b
   WHERE b.���� <= 2
GROUP BY CASE b.���� WHEN 1 THEN a.��ǰ�ڵ� END
ORDER BY 1;

--
SELECT   ��ǰ�ڵ�, SUM (�Ǹűݾ�) AS �Ǹűݾ�
    FROM �Ǹ����
GROUP BY ROLLUP (��ǰ�ڵ�)
ORDER BY 1;

--
SELECT   a.��ǰ�ڵ�
       , CASE b.���� WHEN 1 THEN '��ȹ' ELSE'����' END AS ���
       , c.�����
    FROM ��ǰ a, ���� b, ��� c
   WHERE b.���� <= 2
     AND c.�����ȣ = CASE b.���� WHEN 1 THEN a.��ȹ����� ELSE a.���Ŵ���� END
ORDER BY 1, 2, 3;

--
SELECT   a.��ǰ�ڵ�, c.�μ���
    FROM ��ǰ a, ���� b, �μ� c
   WHERE a.��ǰ�ڵ� = 'A'
     AND b.���� <= REGEXP_COUNT (a.���úμ����, ',') + 1
     AND c.�μ���ȣ = REGEXP_SUBSTR (a.���úμ����, '[^,]+', 1, b.����)
ORDER BY b.����;

--
SELECT b.�μ���ȣ, b.�μ���
  FROM �μ� a, �μ� b
 WHERE a.�μ���ȣ = 3
   AND b.�μ���ȣ = a.�����μ���ȣ;

--
SELECT c.�μ���ȣ, c.�μ���
  FROM �μ� a, �μ� b, �μ� c
 WHERE a.�μ���ȣ = 3
   AND b.�μ���ȣ = a.�����μ���ȣ
   AND c.�μ���ȣ = b.�����μ���ȣ;

--
SELECT   a.��ǰ�ڵ�, a.���ؿ���, a.�Ǹűݾ�, SUM (b.�Ǹűݾ�) AS �����Ǹűݾ�
    FROM �Ǹ���� a, �Ǹ���� b
   WHERE b.��ǰ�ڵ� = a.��ǰ�ڵ�
     AND b.���ؿ��� <= a.���ؿ���
GROUP BY a.��ǰ�ڵ�, a.���ؿ���, a.�Ǹűݾ�
ORDER BY 1, 2;

--
SELECT   ��ǰ�ڵ�, ���ؿ���, �Ǹűݾ�
       , SUM (�Ǹűݾ�) OVER (PARTITION BY ��ǰ�ڵ� ORDER BY ���ؿ���) AS �����Ǹűݾ�
    FROM �Ǹ����
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
SELECT   a.*, b.��������, b.��������, b.���κ���
    FROM ��ǰ���� a, �������� b
   WHERE a.��ǰ�ڵ� = 'A'
     AND b.����ǰ�ڵ� = a.��ǰ�ڵ�
     AND b.�������� <= a.��������
     AND b.�������� >= a.��������
ORDER BY a.��������, b.��������;

--
DROP TABLE ���� PURGE;

CREATE TABLE ���� AS
SELECT TO_CHAR (ADD_MONTHS (DATE '2011-01-01', ROWNUM - 1), 'YYYYMM') AS ���ؿ���
     , ADD_MONTHS (DATE '2011-01-01', ROWNUM - 1)                     AS ��������
     , ADD_MONTHS (DATE '2011-01-01', ROWNUM) -1                      AS ��������
  FROM XMLTABLE ('1 to 24');

--
SELECT * FROM ����;

--
SELECT   a.���ؿ���
       , MAX (b.��ǰ����) KEEP (DENSE_RANK FIRST ORDER BY a.�������� DESC) AS ��ǰ����
    FROM ���� a, ��ǰ���� b
   WHERE a.���ؿ��� BETWEEN '201110' AND '201203'
     AND b.��ǰ�ڵ�(+) = 'A'
     AND b.��������(+) <= a.��������
     AND b.��������(+) >= a.��������
GROUP BY a.���ؿ���
ORDER BY 1;

--
SELECT   a.����ȣ, a.������, NVL (b.�ֹι�ȣ, c.���ι�ȣ) AS �ĺ���ȣ
    FROM �� a, ���ΰ� b, ���ΰ� c
   WHERE b.����ȣ(+) = a.����ȣ
     AND c.����ȣ(+) = a.����ȣ
ORDER BY 1;

--
SELECT   a.����ȣ, a.������, NVL (b.�ֹι�ȣ, c.���ι�ȣ) AS �ĺ���ȣ
    FROM �� a, ���ΰ� b, ���ΰ� c
   WHERE b.����ȣ(+) = DECODE (a.������, 'P', a.����ȣ)
     AND c.����ȣ(+) = DECODE (a.������, 'C', a.����ȣ)
ORDER BY 1;

--
SELECT   a.��ǰ�ڵ�, NVL2 (a.���Ŵ����, '����', '��ȹ') AS ���, b.�����
    FROM ��ǰ a, ��� b
   WHERE b.�����ȣ = COALESCE (a.���Ŵ����, a.��ȹ�����)
ORDER BY 1;

--
SELECT   a.��ǰ�ڵ�, b.�����, b.�ҼӺμ���ȣ
    FROM ��ǰ a, ��� b
   WHERE b.�����ȣ = DECODE (b.�ҼӺμ���ȣ, 2, a.��ȹ�����, 3, a.���Ŵ����)
ORDER BY 1, 2;

--
SELECT   a.��ǰ�ڵ�, b.�����, b.�ҼӺμ���ȣ
    FROM ��ǰ a, ��� b
   WHERE (   (b.�����ȣ = a.��ȹ����� AND b.�ҼӺμ���ȣ = 2)
          OR (b.�����ȣ = a.���Ŵ���� AND b.�ҼӺμ���ȣ = 3))
ORDER BY 1, 2;

--
SELECT   a.���ؿ���, NVL (b.�Ǹűݾ�, 0) AS �Ǹűݾ�
    FROM ���� a
    LEFT OUTER
    JOIN �Ǹ���� b
      ON b.���ؿ��� = a.���ؿ���
     AND b.��ǰ�ڵ� = 'A'
   WHERE a.���ؿ��� LIKE '2011%'
ORDER BY 1;

--
SELECT   b.��ǰ�ڵ�, a.���ؿ���, NVL (b.�Ǹűݾ�, 0) AS �Ǹűݾ�
    FROM ���� a
    LEFT OUTER
    JOIN �Ǹ���� b
      ON b.���ؿ��� = a.���ؿ���
     AND b.��ǰ�ڵ� IN ('A', 'B')
   WHERE a.���ؿ��� LIKE '2011%'
ORDER BY 1, 2;

--
SELECT   a.��ǰ�ڵ�, b.���ؿ���, NVL (c.�Ǹűݾ�, 0) AS �Ǹűݾ�
    FROM (��ǰ a CROSS JOIN ���� b)
    LEFT OUTER
    JOIN �Ǹ���� c
      ON c.��ǰ�ڵ� = a.��ǰ�ڵ�
     AND c.���ؿ��� = b.���ؿ���
   WHERE a.��ǰ�ڵ� IN ('A', 'B')
     AND b.���ؿ��� LIKE '2011%'
ORDER BY 1, 2;

--
SELECT   b.��ǰ�ڵ�, a.���ؿ���, b.�Ǹűݾ�
    FROM ���� a
    LEFT OUTER
    JOIN �Ǹ���� b PARTITION BY (b.��ǰ�ڵ�)
      ON b.���ؿ��� = a.���ؿ���
     AND b.��ǰ�ڵ� IN ('A', 'B')
   WHERE a.���ؿ��� LIKE '2011%'
ORDER BY 1, 2;
