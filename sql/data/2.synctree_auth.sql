/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

USE `synctree_auth`;

/* Create table in target */
CREATE TABLE `certification`(
	`certification_id` int(10) NOT NULL  auto_increment COMMENT 'auth ID' , 
	`credential_target` tinyint(3) NOT NULL  DEFAULT 0 COMMENT 'credential 대상(0 : studio / 1 : portal)' , 
	`credential_id` int(10) NOT NULL  COMMENT 'credential ID' , 
	`certification_type` tinyint(3) NOT NULL  COMMENT 'authorization 타입(10 : Oauth / 20 : Simplekey / 30 : SecureProtocol)' , 
	`certification_environment` char(10) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'authorization 환경(dev, feature, stage, production, hotfix)' , 
	`client_id` varchar(80) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'oauth client ID' , 
	`client_secret` varchar(80) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'client secret' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	`modify_date` datetime NULL  COMMENT '수정일' , 
	`is_del` varchar(4) COLLATE utf8mb4_general_ci NOT NULL  DEFAULT 'N' COMMENT '삭제여부' , 
	`del_date` datetime NULL  COMMENT '삭제일' , 
	PRIMARY KEY (`certification_id`) , 
	UNIQUE KEY `uix-certification-client_id`(`client_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='인증 Table';


/* Create table in target */
CREATE TABLE `certification_match`(
	`certification_match_id` int(10) NOT NULL  auto_increment COMMENT 'authorization Match ID' , 
	`slave_id` smallint(5) NOT NULL  COMMENT '소유자 ID(slave_id)' , 
	`app_id` int(10) NOT NULL  COMMENT 'App ID' , 
	`credential_target` tinyint(3) NOT NULL  DEFAULT 0 COMMENT 'credential 대상(0 : studio / 1 : portal)' , 
	`credential_id` int(10) NOT NULL  COMMENT 'credential ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	PRIMARY KEY (`certification_match_id`) , 
	UNIQUE KEY `uix-certification_match-mix_id`(`credential_id`,`slave_id`,`app_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='인증 Match Table';


/* Create table in target */
CREATE TABLE `oauth_token_match`(
	`token_match_id` int(10) NOT NULL  auto_increment COMMENT 'Oauth Token Match ID' , 
	`access_token_id` int(10) NOT NULL  COMMENT 'Aceess Token ID' , 
	`refresh_token_id` int(10) NOT NULL  COMMENT 'Refresh Token ID' , 
	PRIMARY KEY (`token_match_id`) , 
	KEY `nix-access_tokens-access_tokens`(`access_token_id`) , 
	KEY `nix-refresh_tokens-refresh_tokens`(`refresh_token_id`) , 
	CONSTRAINT `fk-access_tokens-access_tokens` 
	FOREIGN KEY (`access_token_id`) REFERENCES `t_oauth_access_tokens` (`access_token_id`) , 
	CONSTRAINT `fk-refresh_tokens-refresh_tokens` 
	FOREIGN KEY (`refresh_token_id`) REFERENCES `t_oauth_refresh_tokens` (`refresh_token_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Oauth 인증 토큰 Match';


/* Create table in target */
CREATE TABLE `t_oauth_access_tokens`(
	`access_token_id` int(10) NOT NULL  auto_increment COMMENT 'Aceess Token ID' , 
	`access_token` varchar(700) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Access Token' , 
	`client_id` varchar(80) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Client ID' , 
	`user_id` varchar(1000) COLLATE utf8mb4_general_ci NULL  COMMENT '소유자 ID(slave_id)' , 
	`expires` datetime NULL  DEFAULT CURRENT_TIMESTAMP COMMENT '만료일자' , 
	`scope` varchar(1000) COLLATE utf8mb4_general_ci NULL  COMMENT '기능 범위' , 
	PRIMARY KEY (`access_token_id`) , 
	UNIQUE KEY `uix-access_token-access_token`(`access_token`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Oauth 인증 토큰';


/* Create table in target */
CREATE TABLE `t_oauth_authorization_codes`(
	`authorization_code` varchar(40) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '인증 Code' , 
	`client_id` varchar(80) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Client ID' , 
	`user_id` smallint(5) NULL  COMMENT '소유자 ID(slave_id)' , 
	`redirect_uri` varchar(4000) COLLATE utf8mb4_general_ci NULL  COMMENT '재전송 URI' , 
	`expires` datetime NULL  DEFAULT CURRENT_TIMESTAMP COMMENT '만료일자' , 
	`scope` varchar(1000) COLLATE utf8mb4_general_ci NULL  COMMENT '기능 범위' , 
	`id_token` varchar(1000) COLLATE utf8mb4_general_ci NULL  COMMENT 'ID Token' , 
	PRIMARY KEY (`authorization_code`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Oauth 인증 Code';


/* Create table in target */
CREATE TABLE `t_oauth_clients`(
	`client_id` varchar(80) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Client ID' , 
	`client_secret` varchar(80) COLLATE utf8mb4_general_ci NULL  COMMENT 'Client Secret' , 
	`redirect_uri` varchar(4000) COLLATE utf8mb4_general_ci NULL  COMMENT '재전송 URI' , 
	`grant_types` varchar(80) COLLATE utf8mb4_general_ci NULL  COMMENT '승인 방식' , 
	`scope` varchar(1000) COLLATE utf8mb4_general_ci NULL  COMMENT '기능 범위' , 
	`user_id` smallint(5) NULL  COMMENT '소유자 ID(slave_id)' , 
	PRIMARY KEY (`client_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci';


/* Create table in target */
CREATE TABLE `t_oauth_public_keys`(
	`client_id` varchar(80) COLLATE utf8mb4_general_ci NULL  COMMENT 'Client ID' , 
	`public_key` varchar(2000) COLLATE utf8mb4_general_ci NULL  COMMENT 'Public Key' , 
	`private_key` varchar(2000) COLLATE utf8mb4_general_ci NULL  COMMENT 'Private Key' , 
	`encryption_algorithm` varchar(100) COLLATE utf8mb4_general_ci NULL  DEFAULT 'RS256' COMMENT '암호화 알고리즘' , 
	KEY `nix-oauth_public-client_id`(`client_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Oauth Public Key';


/* Create table in target */
CREATE TABLE `t_oauth_refresh_tokens`(
	`refresh_token_id` int(10) NOT NULL  auto_increment COMMENT 'Refresh Token ID' , 
	`refresh_token` varchar(40) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Refresh Token' , 
	`client_id` varchar(80) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Client ID' , 
	`user_id` varchar(1000) COLLATE utf8mb4_general_ci NULL  COMMENT '소유자 ID(slave_id)' , 
	`expires` datetime NULL  DEFAULT CURRENT_TIMESTAMP COMMENT '만료일자' , 
	`scope` varchar(1000) COLLATE utf8mb4_general_ci NULL  COMMENT '기능 범위' , 
	PRIMARY KEY (`refresh_token_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Oauth Refresh Token';


/* Create table in target */
CREATE TABLE `t_oauth_scopes`(
	`scope` varchar(400) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '기능 범위' , 
	`is_default` tinyint(1) NULL  COMMENT 'Default 여부' , 
	PRIMARY KEY (`scope`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Oauth Scope';


/* Create table in target */
CREATE TABLE `t_oauth_users`(
	`username` varchar(50) COLLATE utf8mb4_general_ci NULL  COMMENT 'User 이름' , 
	`password` varchar(80) COLLATE utf8mb4_general_ci NULL  COMMENT '비밀번호' , 
	`first_name` varchar(32) COLLATE utf8mb4_general_ci NULL  COMMENT '성' , 
	`last_name` varchar(32) COLLATE utf8mb4_general_ci NULL  COMMENT '이름' , 
	`email` varchar(64) COLLATE utf8mb4_general_ci NULL  COMMENT 'Email' , 
	`email_verified` tinyint(1) NULL  COMMENT 'Email 확인(0:미확인/1:확인)' , 
	`scope` varchar(1000) COLLATE utf8mb4_general_ci NULL  COMMENT '기능 범위' , 
	KEY `nix-oauth_users-username`(`username`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Oauth User 정보';

/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `usp_add_oauth_etc`(
      IN pi_vch_client_id VARCHAR(80)
    , IN pi_vch_client_secret VARCHAR(80)
    , IN pi_int_credential_id INT(10)
    , IN pi_int_app_id INT(10)
    , in pi_ins_admin_id SMALLINT(5)
    , IN pi_ins_user_id SMALLINT(5)
    , IN pi_vch_redirect_uri VARCHAR(2000)
    , IN pi_vch_scope VARCHAR(1000)
    , IN pi_vch_environment VARCHAR(20)
    , IN pi_dt5_now DATETIME(0)
    , OUT po_int_return INT
)
    DETERMINISTIC
    COMMENT 'nauthor : 조규현 mail : jogyuhyeon@nntuple.com created date : 2021-04-16'
proc_body: BEGIN
    DECLARE v_vch_proc_name VARCHAR(100) DEFAULT 'usp_add_oauth_etc';
    DECLARE v_iny_proc_step TINYINT UNSIGNED DEFAULT 0;
    DECLARE v_txt_call_stack MEDIUMTEXT;
    DECLARE v_bit_write_exception_log BOOLEAN DEFAULT FALSE;
    DECLARE v_vch_sql_state VARCHAR(5);
    DECLARE v_int_error_no INT;
    DECLARE v_txt_error_msg TEXT;
    
    DECLARE v_jsn_key_value text;


    DECLARE CONTINUE HANDLER FOR NOT FOUND BEGIN END;
    DECLARE CONTINUE HANDLER FOR SQLWARNING BEGIN END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_vch_sql_state = RETURNED_SQLSTATE
            , v_int_error_no = MYSQL_ERRNO
            , v_txt_error_msg = MESSAGE_TEXT;

        ROLLBACK;

    END;


START TRANSACTION;

-- certification upsert
    SET v_iny_proc_step = 1;
	
	IF (select count(*) from certification where client_id = pi_vch_client_id) > 0 
	THEN
		UPDATE certification
		   set client_secret = pi_vch_client_secret
		     , modify_date = pi_dt5_now
		 where client_id = pi_vch_client_id;
	
	ELSE 
		INSERT INTO certification(credential_target, credential_id, certification_type, certification_environment, client_id, client_secret, register_date, modify_date, is_del, del_date)
		VALUES (0, pi_int_credential_id, 10, pi_vch_environment, pi_vch_client_id, pi_vch_client_secret, pi_dt5_now, NULL, 'N', NULL);
	
	END IF;

-- certification_match insert 
    SET v_iny_proc_step = 2;
	
	IF (SELECT COUNT(*) FROM certification_match WHERE slave_id = pi_ins_user_id and app_id = pi_int_app_id and credential_id = pi_int_credential_id) > 0
	THEN
        SET po_int_return = 2;
	
	ELSE
		INSERT INTO certification_match(slave_id, app_id, credential_target, credential_id, register_date)
		VALUES (pi_ins_user_id, pi_int_app_id, 0, pi_int_credential_id, pi_dt5_now);
	
	END IF;

-- t_oauth_clients upsert
    SET v_iny_proc_step = 3;

	IF (SELECT COUNT(*) FROM t_oauth_clients WHERE client_id = pi_vch_client_id) > 0 
	THEN
		UPDATE t_oauth_clients
		   SET client_secret = pi_vch_client_secret
		     , redirect_uri = pi_vch_redirect_uri
		     , scope = pi_vch_scope
		 WHERE client_id = pi_vch_client_id;
	
	ELSE 
		INSERT INTO t_oauth_clients(client_id, client_secret, redirect_uri, grant_types, scope, user_id)
		VALUES (pi_vch_client_id, pi_vch_client_secret, pi_vch_redirect_uri, NULL, pi_vch_scope, pi_ins_user_id);
	
	END IF;

-- crendential_detail upsert
    SET v_iny_proc_step = 4;
    
    SET v_jsn_key_value = CONCAT('{"id": "',pi_vch_client_id,'", "secret": "',pi_vch_client_secret,'"}');
		
	IF (SELECT COUNT(*) FROM synctree_studio.credential_detail WHERE JSON_UNQUOTE(JSON_EXTRACT(key_value, '$.id')) = pi_vch_client_id) > 0 
	then
		update synctree_studio.credential_detail
		   set key_value = v_jsn_key_value
		     , modify_date = pi_dt5_now
		 where JSON_UNQUOTE(JSON_EXTRACT(key_value, '$.id')) = pi_vch_client_id;
		
	else
		INSERT INTO synctree_studio.credential_detail(credential_id, credential_environment, credential_type, credential_detail_title, credential_detail_description, key_value, admin_id, user_id, access_privilege, register_date, modify_date, is_del, del_date)
		VALUES (pi_int_credential_id, pi_vch_environment, 10, 'Credential_Title', 'Credential_Desc', v_jsn_key_value, pi_ins_admin_id, pi_ins_user_id, 'public', pi_dt5_now, NULL, 'N', NULL);
	
	end if;
	SET v_iny_proc_step = 5;
	 
		if(select count(*) from t_oauth_public_keys where client_id = pi_vch_client_id) > 0
		then
			update t_oauth_public_keys
			   set private_key = md5(pi_vch_client_secret)
			     , public_key = md5(pi_vch_client_secret)
			     , encryption_algorithm = 'HS256'
			 where client_id = pi_vch_client_id;
		ELSE
			insert into t_oauth_public_keys(client_id, private_key, public_key, encryption_algorithm)
			values (pi_vch_client_id, md5(pi_vch_client_secret), md5(pi_vch_client_secret), 'HS256');
		end if;
   
   
COMMIT;

    SET po_int_return = 0;
END proc_body$$
DELIMITER ;


/* Create Procedure in target  */

DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `usp_del_oauth_etc`(
      IN pi_vch_client_id VARCHAR(80)
    , IN pi_vch_client_secret VARCHAR(80)
    , IN pi_int_credential_id INT(10)
    , IN pi_int_app_id INT(10)
    , IN pi_ins_user_id SMALLINT(5)
    , IN pi_dt5_now DATETIME(0)
    , OUT po_int_return INT
)
    DETERMINISTIC
    COMMENT 'nauthor : 조규현 mail : jogyuhyeon@nntuple.com created date : 2021-04-16'
proc_body: BEGIN
    DECLARE v_vch_proc_name VARCHAR(100) DEFAULT 'usp_del_oauth_etc';
    DECLARE v_iny_proc_step TINYINT UNSIGNED DEFAULT 0;
    DECLARE v_txt_call_stack MEDIUMTEXT;
    DECLARE v_bit_write_exception_log BOOLEAN DEFAULT FALSE;
    DECLARE v_vch_sql_state VARCHAR(5);
    DECLARE v_int_error_no INT;
    DECLARE v_txt_error_msg TEXT;
    
    DECLARE v_jsn_key_value TEXT;


    DECLARE CONTINUE HANDLER FOR NOT FOUND BEGIN END;
    DECLARE CONTINUE HANDLER FOR SQLWARNING BEGIN END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_vch_sql_state = RETURNED_SQLSTATE
            , v_int_error_no = MYSQL_ERRNO
            , v_txt_error_msg = MESSAGE_TEXT;

        ROLLBACK;

    END;


START TRANSACTION;

-- certification delete
    SET v_iny_proc_step = 1;
	
	UPDATE certification
	   SET is_del = 'Y'
	     , del_date = pi_dt5_now
	 where client_id = pi_vch_client_id
	   and client_secret = pi_vch_client_secret;

	
-- certification_match delete
    SET v_iny_proc_step = 2;
	
	DELETE
	  FROM certification_match
	 where slave_id = pi_ins_user_id
	   and app_id = pi_int_app_id
	   and credential_id = pi_int_credential_id;


-- t_oauth_clients delete
    SET v_iny_proc_step = 3;

	DELETE
	  FROM t_oauth_clients
	 WHERE client_id = pi_vch_client_id
	   and client_secret = pi_vch_client_secret;


-- crendential_detail delete
    SET v_iny_proc_step = 4;
    
    SET v_jsn_key_value = CONCAT('{"id": "',pi_vch_client_id,'", "secret": "',pi_vch_client_secret,'"}');
		
	UPDATE synctree_studio.credential_detail
	   SET is_del = 'Y'
	     , del_date = pi_dt5_now
	 WHERE JSON_UNQUOTE(JSON_EXTRACT(key_value, '$.id')) = pi_vch_client_id;

-- t_oauth_public_keys delete
    SET v_iny_proc_step = 5;
     
    delete
      from t_oauth_public_keys
     where client_id = pi_vch_client_id;
     
COMMIT;

    SET po_int_return = 0;
END proc_body$$
DELIMITER ;


/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;