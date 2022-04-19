-- 주의 필독
-- WAS Synctree 설정파일 config ( synctree > config > config.ini )에서 아래 정보와 일치해야함
-- #; userinfo crypt info
-- #; echo hash('md5','dev_kb_synctree_userinfo',false);
-- #userinfo_key = "8990eeeb7f3e48dad5f643155b230853"
-- SET @crypt_key = '8990eeeb7f3e48dad5f643155b230853';
-- ----------------------------------------------------------------------------------------------------------------------
-- 5.5.7 부터 FOREIGN KEY 설정이 된 테이블을 TRUNCATE 하려면 FOREIGN_KEY_CHECKS을 0으로 지정해야한다. 
-- 안 그러면 Cannot truncate a table referenced in a foreign key constraint 오류가 발생한다.
-- SET FOREIGN_KEY_CHECKS = 0; -- Disable foreign key checking.
-- SET FOREIGN_KEY_CHECKS = 1; -- Enable foreign key checking.
-- ----------------------------------------------------------------------------------------------------------------------


USE synctree_studio;

SET FOREIGN_KEY_CHECKS = 0; -- Disable foreign key checking.
TRUNCATE TABLE permission_have;
TRUNCATE TABLE account_slave;
TRUNCATE TABLE account_master;
TRUNCATE TABLE synctree_portal.portal_list;
SET FOREIGN_KEY_CHECKS = 1; -- Enable foreign key checking.

SET @name = 'YOUR-STUDIO-USERNAME';
SET @email = 'YOUR-STUDIO-EMAIL';
SET @int_master_account = CONVERT(FLOOR(RAND()*10000000000), SIGNED);
SET @vch_master_account = (SELECT CASE WHEN @int_master_account >= 1000000000 THEN CAST(@int_master_account AS CHAR) ELSE CONCAT(0,CAST(@int_master_account AS CHAR)) END);
SET @crypt_key = '47ee9ea25f9f0e0de7b991e50df3448d';
SET @passphrase = 'YOUR-STUDIO-PASSWORD'; 

SET @register_date = DATE_ADD(NOW(), INTERVAL 9 HOUR);


INSERT INTO account_master (master_account, master_division, master_name, master_email, master_passphrase, master_status_code, product_sno, register_date, modify_date, login_date) VALUES
(@vch_master_account, 'enterprise', @name, @email, usf_hash_passphrase(@crypt_key, @email, @passphrase), 1, 2, @register_date, NULL, NULL);

INSERT INTO account_slave (slave_type, slave_name, slave_email, slave_passphrase, slave_expire_date, slave_status_code, slave_purpose, master_id, master_account, permission_group_id, register_date, modify_date, login_date) VALUES
(2, @name, @email, usf_hash_passphrase(@crypt_key, @email, @passphrase), NULL, 1, 0, 1, @vch_master_account, 1, @register_date, NULL, NULL);
INSERT INTO permission_have (slave_id, permission_id, register_date) VALUES
(1, 1, @register_date),
(1, 2, @register_date),
(1, 3, @register_date),
(1, 4, @register_date),
(1, 5, @register_date),
(1, 6, @register_date),
(1, 7, @register_date),
(1, 8, @register_date),
(1, 9, @register_date),
(1, 10, @register_date),
(1, 11, @register_date),
(1, 12, @register_date),
(1, 13, @register_date),
(1, 14, @register_date),
(1, 15, @register_date),
(1, 16, @register_date),
(1, 17, @register_date),
(1, 18, @register_date),
(1, 19, @register_date),
(1, 20, @register_date),
(1, 21, @register_date),
(1, 22, @register_date);


USE synctree_portal;

SET @portal_name = 'Synctree-Portal';

INSERT INTO portal_list(portal_list_name, portal_list_description, portal_url, admin_id, register_date)
VALUES (@portal_name,'Portal',CONV(CONCAT(UNIX_TIMESTAMP(@register_date), LPAD(1, 5, '0')), 10, 16),1,@register_date);

select portal_url from portal_list where portal_list_id = 1;
