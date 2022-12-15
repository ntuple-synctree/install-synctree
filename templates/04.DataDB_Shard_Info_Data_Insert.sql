-- 주의 필독
-- connection_string에 입력되는 IP, PORT는 현재 설치된 DB정보로 변경해서 입력

USE synctree_studio;

-- data db ip와 port
SET @connection_string = 'YOUR-AURORA-LOG-ENDPOINT,YOUR-AURORA-LOG-PORT';
INSERT INTO t_shard_info (connection_string, accum_value, ratio, reg_date) VALUES (@connection_string, 1, 1, DATE_ADD(NOW(), INTERVAL 9 HOUR));

USE synctree_portal;

SET @connection_string = 'YOUR-AURORA-LOG-ENDPOINT,YOUR-AURORA-LOG-PORT';
INSERT INTO proxy_shard_info (connection_string, accum_value, register_date) VALUES (@connection_string, 1, DATE_ADD(NOW(), INTERVAL 9 HOUR));
