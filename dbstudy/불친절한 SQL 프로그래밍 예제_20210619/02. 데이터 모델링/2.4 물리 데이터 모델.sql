--
CREATE TABLE �μ� (
    �μ���ȣ     NUMBER       NOT NULL
  , �μ���       VARCHAR2(10) NOT NULL
  , �����μ���ȣ NUMBER           NULL
  , CONSTRAINTS �μ�_PK PRIMARY KEY (�μ���ȣ)
  , CONSTRAINTS �μ�_F1 FOREIGN KEY (�����μ���ȣ) REFERENCES �μ� (�μ���ȣ));

--
CREATE TABLE ��� (
    �����ȣ     NUMBER       NOT NULL
  , �����       VARCHAR2(10) NOT NULL
  , �޿�         NUMBER       NOT NULL
  , �ҼӺμ���ȣ NUMBER       NOT NULL
  , CONSTRAINTS ���_PK PRIMARY KEY (�����ȣ)
  , CONSTRAINTS ���_F1 FOREIGN KEY (�ҼӺμ���ȣ) REFERENCES �μ� (�μ���ȣ));
