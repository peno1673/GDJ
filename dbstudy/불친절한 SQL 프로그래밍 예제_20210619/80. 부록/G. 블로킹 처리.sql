--
WITH w1 AS (SELECT /*+ MATERIALIZE */ * FROM gv$session)
   , w2 AS (SELECT     a.*, LEVEL AS lv, ROWNUM AS rn
                  FROM w1 a
            START WITH EXISTS (SELECT 1
                                 FROM w1 x
                                WHERE x.blocking_instance = a.inst_id
                                  AND x.blocking_session = a.sid)
                   AND a.blocking_session IS NULL
            CONNECT BY PRIOR a.inst_id = a.blocking_instance
                   AND PRIOR a.sid = a.blocking_session
                 ORDER SIBLINGS
                    BY a.inst_id, a.sid, a.wait_time_micro)
SELECT   a.inst_id                                  -- �ν��Ͻ� ID
       , LPAD (' ', (a.lv - 1) * 2) || a.sid AS sid -- ���� ID
       , a.serial#                                  -- ���� �Ϸù�ȣ
       , b.spid                                     -- OS ���μ��� ID
       , c.lock_type                                -- �� ����
       , c.mode_requested                           -- �� ��û ���
       , a.sql_id                                   -- SQL ID
         /*
       , a.prev_sql_id
       , CASE WHEN d.owner IS NOT NULL
              THEN d.owner || '.' || d.object_name
              ELSE c.lock_id1
         END AS object_name                         -- ������Ʈ ��
       , a.event                                    -- ��� �̺�Ʈ
       , a.wait_class                               -- ��� �̺�Ʈ Ŭ����
         */
       , a.seconds_in_wait                          -- ��� �ð�(��)
    FROM w2 a
       , gv$process b
       , dba_lock_internal c
       , dba_objects d
   WHERE b.inst_id = a.inst_id
     AND b.addr = a.paddr
     AND c.session_id(+) = a.sid
     AND c.mode_requested(+) != 'None'
     AND d.object_id(+) = a.row_wait_obj#
ORDER BY rn;

--
ps -ef | grep -v grep | grep sqlplus

kill -9 1000

--
tasklist | find "sqlplus"

orakill 100 1000

--
ALTER SYSTEM KILL SESSION '100, 10000, @1' IMMEDIATE;

--
ALTER SYSTEM DISCONNECT SESSION '100, 10000' IMMEDIATE;

--
ALTER SYSTEM CANCEL SQL '100 10000 @1 58z1s77k33skb';
