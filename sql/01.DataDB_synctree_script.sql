/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

USE `synctree_agent`;

/* Create table in target */
CREATE TABLE `receive_agent`(
	`receive_agent_id` int(10) NOT NULL  auto_increment COMMENT 'Recieve Agent ID' , 
	`deploy_project_id` int(10) NOT NULL  COMMENT 'Deploy Project ID' , 
	`receive_status` varchar(20) COLLATE utf8mb4_general_ci NOT NULL  DEFAULT 'progress' COMMENT 'Recieve 상태값(progress, fail, success)' , 
	`receive_retry` tinyint(3) NOT NULL  DEFAULT 0 COMMENT 'Recieve Agent 재시도 횟수' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	`end_date` datetime NULL  COMMENT '종료 일자' , 
	PRIMARY KEY (`receive_agent_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Deploy Recieve Agent';


/* Create table in target */
CREATE TABLE `send_agent`(
	`send_agent_id` int(10) NOT NULL  auto_increment COMMENT 'Send Agent ID' , 
	`deploy_project_id` int(10) NOT NULL  COMMENT 'Deploy Project ID' , 
	`send_status` varchar(20) COLLATE utf8mb4_general_ci NOT NULL  DEFAULT 'progress' COMMENT 'Send 상태값(progress, fail, success)' , 
	`send_retry` tinyint(3) NOT NULL  DEFAULT 0 COMMENT 'Send Agent 재시도 횟수' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	`end_date` datetime NULL  COMMENT '종료 일자' , 
	PRIMARY KEY (`send_agent_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Deploy Send Agent';


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
	`slave_id` int(11) NOT NULL  COMMENT '소유자 ID(slave_id)' , 
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
	`user_id` int(11) NULL  COMMENT '소유자 ID(slave_id)' , 
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
	`user_id` int(11) NULL  COMMENT '소유자 ID(slave_id)' , 
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
CREATE PROCEDURE `usp_add_oauth_etc`(
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
CREATE PROCEDURE `usp_del_oauth_etc`(
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


USE `synctree_marketplace`;

/* Create table in target */
CREATE TABLE `product`(
	`product_id` int(10) unsigned NOT NULL  auto_increment COMMENT '상품 ID' , 
	`product_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '상품 이름' , 
	`product_description` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '상품 설명' , 
	`product_category` json NULL  COMMENT '상품 카테고리' , 
	`product_owner` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '상품 판매자' , 
	`product_download` int(10) NULL  DEFAULT 0 COMMENT '상품 다운로드 수' , 
	`product_version` varchar(12) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '상품 버전' , 
	`product_icon` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '상품 아이콘' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	`modify_date` datetime NULL  COMMENT '수정일' , 
	PRIMARY KEY (`product_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='상품 정보';


/* Create table in target */
CREATE TABLE `product_bizunit`(
	`product_bizunit_sno` int(10) unsigned NOT NULL  auto_increment COMMENT '상품 BizUnit SNO' , 
	`product_bizunit_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '상품 BizUnit ID' , 
	`product_bizunit_version` varchar(12) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '상품 BizUnit 버전' , 
	`product_bizunit_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '상품 BizUnit 이름' , 
	`product_bizunit_desc` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '상품 BizUnit 설명' , 
	`product_bizunit_plan_version` varchar(10) COLLATE utf8mb4_general_ci NULL  COMMENT '상품 엔진 버전' , 
	`app_id` int(10) NOT NULL  COMMENT 'App ID' , 
	`bizunit_sno` int(10) NOT NULL  COMMENT 'BizUnit SNO' , 
	`revision_sno` int(10) NOT NULL  COMMENT 'Revision SNO' , 
	`operator_sno` int(10) NOT NULL  COMMENT 'Operator SNO' , 
	`operator_content` longtext COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Operator 내용' , 
	`product_id` int(10) unsigned NOT NULL  COMMENT '상품 ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	`modify_date` datetime NULL  COMMENT '수정일' , 
	PRIMARY KEY (`product_bizunit_sno`) , 
	KEY `nix-product_bizunit-product_id`(`product_id`) , 
	CONSTRAINT `fk-product_bizunit-product` 
	FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='상품 Bizunit 정보';


/* Create table in target */
CREATE TABLE `product_buy`(
	`product_buy_id` int(10) unsigned NOT NULL  auto_increment COMMENT '상품 구매 ID' , 
	`product_id` int(10) unsigned NOT NULL  COMMENT '상품 ID' , 
	`user_region` tinyint(3) NOT NULL  COMMENT 'User 지역(0 : Seoul / 1 : California)' , 
	`user_id` int(11) NOT NULL  COMMENT 'User ID(구매자)' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	`modify_date` datetime NULL  COMMENT '수정일' , 
	PRIMARY KEY (`product_buy_id`) , 
	KEY `nix-product_buy-product_id`(`product_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='상품 구매 정보';


/* Create table in target */
CREATE TABLE `product_library`(
	`product_library_sno` int(10) unsigned NOT NULL  auto_increment COMMENT 'Library SNO' , 
	`product_library_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Library ID' , 
	`product_library_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Library 이름' , 
	`product_library_desc` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Library 설명' , 
	`product_library_version` varchar(12) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Library 버전' , 
	`product_library_content` json NOT NULL  COMMENT 'Library 내용' , 
	`product_library_plan_version` varchar(10) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Library 엔진 버전' , 
	`product_id` int(10) unsigned NOT NULL  COMMENT '상품 ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	`modify_date` datetime NULL  COMMENT '수정일' , 
	PRIMARY KEY (`product_library_sno`) , 
	KEY `nix-product_library-product_id`(`product_id`) , 
	CONSTRAINT `fk-product_library-product` 
	FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='상품 Library 정보';



USE `synctree_plan`;

/* Create table in target */
CREATE TABLE `permission`(
	`permission_id` int(10) NOT NULL  auto_increment COMMENT 'Permission ID' , 
	`permission_type` tinyint(3) NOT NULL  DEFAULT 2 COMMENT 'Permission 타입(0 : Studio / 1: Portal / 2: Deploy)' , 
	`permission_name` varchar(40) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Permission 이름' , 
	`permission_desc` text COLLATE utf8mb4_general_ci NULL  COMMENT 'Permission 설명' , 
	PRIMARY KEY (`permission_id`) , 
	UNIQUE KEY `uix-permission-code`(`permission_type`,`permission_name`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='유저 권한 관리 테이블';


/* Create table in target */
CREATE TABLE `permission_detail`(
	`permission_detail_id` int(10) NOT NULL  auto_increment COMMENT 'Permission Detail ID' , 
	`permission_id` int(10) NOT NULL  COMMENT 'Permission ID' , 
	`permission_detail_name` varchar(40) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Permission Detail 이름' , 
	`permission_detail_desc` text COLLATE utf8mb4_general_ci NULL  COMMENT 'Permission Detail 설명' , 
	PRIMARY KEY (`permission_detail_id`) , 
	UNIQUE KEY `uix-permission_detail-code`(`permission_id`,`permission_detail_name`) , 
	KEY `nix-permission_detail-permission_id`(`permission_id`) , 
	CONSTRAINT `fk-permission-permission_detail` 
	FOREIGN KEY (`permission_id`) REFERENCES `permission` (`permission_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='유저 권한 상세 관리 테이블';


/* Create table in target */
CREATE TABLE `permission_match`(
	`permission_match_id` int(10) NOT NULL  auto_increment COMMENT 'Permission Match ID' , 
	`permission_id` int(10) NOT NULL  COMMENT 'Permission ID' , 
	`user_id` int(11) NOT NULL  COMMENT 'User ID' , 
	`user_type` tinyint(3) NOT NULL  DEFAULT 1 COMMENT 'User Type(0: Studio / 1: Portal)' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	PRIMARY KEY (`permission_match_id`) , 
	KEY `nix-permission_match-permission_id`(`permission_id`) , 
	CONSTRAINT `fk-permission-permission_match` 
	FOREIGN KEY (`permission_id`) REFERENCES `permission` (`permission_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='유저 권한 매칭 테이블';


/* Create table in target */
CREATE TABLE `t_plan`(
	`plan_sno` bigint(20) unsigned NOT NULL  auto_increment COMMENT 'Plan SNO' , 
	`plan_environment` varchar(10) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Plan 환경 (dev/feature/stage/production/hotfix/testing)' , 
	`bizunit_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Biz Unit ID' , 
	`bizunit_version` varchar(12) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Biz Unit 버전' , 
	`revision_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Revision ID' , 
	`plan_content` longtext COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Plan 내용' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	`modify_date` datetime NULL  COMMENT '수정일자' , 
	PRIMARY KEY (`plan_sno`) , 
	UNIQUE KEY `ux_t_plan_01`(`plan_environment`,`bizunit_id`,`bizunit_version`,`revision_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='BizUnit RDB 실행 기능 구축 테이블';



USE `synctree_portal`;

/* Create table in target */
CREATE TABLE `app_api_match`(
	`app_api_match_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'app_api_match ID' , 
	`portal_api_id` int(10) unsigned NOT NULL  COMMENT 'Portal_api ID' , 
	`portal_app_id` int(10) unsigned NOT NULL  COMMENT 'Portal_app ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	PRIMARY KEY (`app_api_match_id`) , 
	KEY `nix-app_api_match-portal_api_id`(`portal_api_id`) , 
	KEY `nix-app_api_match-portal_app_id`(`portal_app_id`) , 
	CONSTRAINT `fk-portal_api-app_api_match` 
	FOREIGN KEY (`portal_api_id`) REFERENCES `portal_api` (`portal_api_id`) , 
	CONSTRAINT `fk-portal_app-app_api_match` 
	FOREIGN KEY (`portal_app_id`) REFERENCES `portal_app` (`portal_app_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='APP&API match 정보';


/* Create table in target */
CREATE TABLE `bizunit_api_match`(
	`bizunit_api_match_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'bizunit_api_match ID' , 
	`portal_api_id` int(10) unsigned NOT NULL  COMMENT 'Portal_api ID' , 
	`bizunit_sno` int(10) unsigned NOT NULL  COMMENT 'Biz Unit SNO' , 
	`studio_app_id` int(10) NOT NULL  COMMENT 'Studio app ID' , 
	`test_toggle` enum('Y','N') COLLATE utf8mb4_general_ci NOT NULL  DEFAULT 'N' COMMENT '비회원 테스트 Toggle' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	`bizunit_sort_number` smallint(5) NULL  COMMENT 'Bizunit 노출 순서' , 
	PRIMARY KEY (`bizunit_api_match_id`) , 
	KEY `nix-bizunit_api_match-portal_api_id`(`portal_api_id`) , 
	CONSTRAINT `fk-portal_api-bizunit_api_match` 
	FOREIGN KEY (`portal_api_id`) REFERENCES `portal_api` (`portal_api_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Bizunit&Potal API match 정보';


/* Create table in target */
CREATE TABLE `deploy`(
	`deploy_id` int(10) NOT NULL  auto_increment COMMENT 'Deploy ID' , 
	`portal_list_id` int(10) unsigned NOT NULL  COMMENT 'Portal_List ID' , 
	`deploy_type` varchar(30) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '배포요청 항목' , 
	`deploy_sno` int(10) NOT NULL  COMMENT '배포 항목 idx(sno) 값' , 
	`deploy_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '배포 이름' , 
	`deploy_version` varchar(12) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '배포 버전' , 
	`deploy_comment` varchar(1000) COLLATE utf8mb4_general_ci NULL  COMMENT '배포 상세내용' , 
	`deploy_status` varchar(40) COLLATE utf8mb4_general_ci NOT NULL  DEFAULT '' COMMENT '배포 상태' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	`modify_date` datetime NULL  COMMENT '수정일자' , 
	PRIMARY KEY (`deploy_id`) , 
	KEY `nix-deploy-portal_list_id`(`portal_list_id`) , 
	CONSTRAINT `fk-deploy-portal_list` 
	FOREIGN KEY (`portal_list_id`) REFERENCES `portal_list` (`portal_list_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='배포요청 정보';


/* Create table in target */
CREATE TABLE `deploy_project`(
	`deploy_project_id` int(10) NOT NULL  auto_increment COMMENT 'Deploy Project ID' , 
	`portal_list_id` int(10) unsigned NOT NULL  COMMENT 'Portal_List ID' , 
	`portal_account_id` int(10) unsigned NOT NULL  COMMENT 'Portal_account ID' , 
	`project_sno` int(10) NOT NULL  COMMENT 'Project 숫자' , 
	`project_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Project 이름' , 
	`project_comment` varchar(1000) COLLATE utf8mb4_general_ci NULL  COMMENT 'Project 상세내용' , 
	`project_status` varchar(40) COLLATE utf8mb4_general_ci NULL  COMMENT 'Project 상태' , 
	`project_deploy_date` datetime NOT NULL  COMMENT 'project 배포 일자' , 
	`project_urgent` tinyint(3) NOT NULL  DEFAULT 0 COMMENT 'Project 긴급배포(0:배포 / 1: 긴급배포)' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	`modify_date` datetime NULL  COMMENT '수정일자' , 
	PRIMARY KEY (`deploy_project_id`) , 
	UNIQUE KEY `uix-project-project_sno`(`project_sno`,`portal_list_id`) , 
	KEY `nix-deploy_project-portal_list_id`(`portal_list_id`) , 
	KEY `nix-deploy_project-portal_account_id`(`portal_account_id`) , 
	CONSTRAINT `fk-deploy_project-portal_account` 
	FOREIGN KEY (`portal_account_id`) REFERENCES `portal_account` (`portal_account_id`) , 
	CONSTRAINT `fk-deploy_project-portal_list` 
	FOREIGN KEY (`portal_list_id`) REFERENCES `portal_list` (`portal_list_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Project 배포 정보';


/* Create table in target */
CREATE TABLE `deploy_project_match`(
	`deploy_project_match_id` int(10) NOT NULL  auto_increment COMMENT 'Deploy Project Match ID' , 
	`deploy_project_id` int(10) NOT NULL  COMMENT 'Deploy Project ID' , 
	`deploy_id` int(10) NOT NULL  COMMENT 'Deploy ID' , 
	`deploy_status` varchar(40) COLLATE utf8mb4_general_ci NOT NULL  DEFAULT '' COMMENT '배포 상태' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	PRIMARY KEY (`deploy_project_match_id`) , 
	KEY `nix-deploy_project_match-deploy_project_id`(`deploy_project_id`) , 
	KEY `nix-deploy_project_match-deploy_id`(`deploy_id`) , 
	CONSTRAINT `fk-deploy_project_match-deploy` 
	FOREIGN KEY (`deploy_id`) REFERENCES `deploy` (`deploy_id`) , 
	CONSTRAINT `fk-deploy_project_match-deploy_project` 
	FOREIGN KEY (`deploy_project_id`) REFERENCES `deploy_project` (`deploy_project_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Deploy Project Match';


/* Create table in target */
CREATE TABLE `deploy_project_tget`(
	`tget_seq` int(11) NOT NULL  auto_increment COMMENT 'tget sequence' , 
	`deploy_project_id` int(10) NOT NULL  COMMENT 'Deploy Project ID|deploy_project.deploy_project_id' , 
	`project_tget_id` varchar(10) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '프로젝트대상ID|' , 
	`project_status` varchar(40) COLLATE utf8mb4_general_ci NULL  COMMENT 'Project 상태' , 
	`project_deploy_date` datetime NULL  COMMENT 'project 배포 일자' , 
	`project_urgent` tinyint(3) NOT NULL  DEFAULT 0 COMMENT 'Project 긴급배포(0:배포 / 1: 긴급배포)' , 
	PRIMARY KEY (`tget_seq`) , 
	UNIQUE KEY `deploy_project_tget_UNQ01`(`deploy_project_id`,`project_tget_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Project 배포 대상 정보';


/* Create table in target */
CREATE TABLE `deploy_resource`(
	`deploy_resource_id` int(10) NOT NULL  auto_increment COMMENT 'Deploy Resource ID' , 
	`deploy_id` int(10) NOT NULL  COMMENT 'Deploy ID' , 
	`deploy_resource_type` varchar(30) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '배포요청 리소스 항목' , 
	`deploy_resource_sno` int(10) NOT NULL  COMMENT '배포요청 리소스 idx(sno) 값' , 
	`deploy_resource_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '배포요청 리소스 이름' , 
	`deploy_resource_content` longtext COLLATE utf8mb4_general_ci NULL  COMMENT '배포요청 리소스 내용' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	`modify_date` datetime NULL  COMMENT '수정일자' , 
	PRIMARY KEY (`deploy_resource_id`) , 
	KEY `nix-deploy_resource-deploy_id`(`deploy_id`) , 
	KEY `nix-deploy_resource-lock_find`(`deploy_resource_type`,`deploy_resource_sno`) , 
	CONSTRAINT `fk-deploy_resource-deploy` 
	FOREIGN KEY (`deploy_id`) REFERENCES `deploy` (`deploy_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='배포요청 리소스 정보';


/* Create table in target */
CREATE TABLE `portal_account`(
	`portal_account_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Portal_account ID' , 
	`portal_account_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Portal_account 이름' , 
	`portal_account_email` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Portal_account 이메일' , 
	`portal_account_passphrase` binary(32) NOT NULL  COMMENT 'Portal_account 로그인 비밀번호' , 
	`portal_account_role` tinyint(3) NOT NULL  DEFAULT 1 COMMENT 'Portal_account 역할(-1: SysAdmin / 0: Administrator / 1: User)' , 
	`portal_account_status_code` tinyint(3) unsigned NOT NULL  COMMENT 'Portal_account 상태 코드 (0=inactive, 1=active)' , 
	`portal_list_id` int(10) unsigned NOT NULL  COMMENT 'Portal_List ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	`modify_date` datetime NULL  COMMENT '수정일자' , 
	`modify_date_passphrase` datetime NULL  COMMENT '패스워드 수정 일자' , 
	`login_date` datetime NULL  COMMENT '로그인 일자' , 
	`inactive_reason` varchar(255) COLLATE utf8mb4_general_ci NULL  COMMENT '비활성화 사유' , 
	PRIMARY KEY (`portal_account_id`) , 
	KEY `nix-potal_account-portal_list_id`(`portal_list_id`) , 
	CONSTRAINT `fk-potal_list-portal_account` 
	FOREIGN KEY (`portal_list_id`) REFERENCES `portal_list` (`portal_list_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Portal 계정정보';


/* Create table in target */
CREATE TABLE `portal_account_group`(
	`portal_account_group_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Portal_account Group ID' , 
	`portal_account_company` varchar(50) COLLATE utf8mb4_general_ci NULL  COMMENT 'Portal_account 회사 정보' , 
	`portal_account_team` varchar(50) COLLATE utf8mb4_general_ci NULL  COMMENT 'Portal_account 팀 정보' , 
	`portal_account_position` varchar(50) COLLATE utf8mb4_general_ci NULL  COMMENT 'Portal_account 직급 정보' , 
	`phone_national_code` varchar(10) COLLATE utf8mb4_general_ci NULL  COMMENT '국가 번호' , 
	`portal_account_phone` varchar(20) COLLATE utf8mb4_general_ci NULL  COMMENT 'Portal_account 연락처' , 
	`portal_account_id` int(10) unsigned NOT NULL  COMMENT 'Portal_account ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	`modify_date` datetime NULL  COMMENT '수정일자' , 
	PRIMARY KEY (`portal_account_group_id`) , 
	KEY `nix-portal_account_group-portal_account_id`(`portal_account_id`) , 
	CONSTRAINT `fk-portal_account-portal_account_group` 
	FOREIGN KEY (`portal_account_id`) REFERENCES `portal_account` (`portal_account_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Portal 계정 그룹 정보';


/* Create table in target */
CREATE TABLE `portal_account_repasswd`(
	`portal_account_repasswd_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Portal_account password reset ID' , 
	`portal_account_id` int(10) unsigned NOT NULL  COMMENT 'Portal_account ID' , 
	`hash_status` tinyint(3) NOT NULL  DEFAULT 0 COMMENT 'Hash 상태값(0: 사용 X / 1: 사용 O)' , 
	`hash_passphrase` binary(32) NOT NULL  COMMENT 'Hash 데이터' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	`modify_date` datetime NULL  COMMENT '수정 일자' , 
	PRIMARY KEY (`portal_account_repasswd_id`) , 
	KEY `nix-portal_account_repasswd-portal_account_id`(`portal_account_id`) , 
	CONSTRAINT `fk-portal_account-portal_account_repasswd` 
	FOREIGN KEY (`portal_account_id`) REFERENCES `portal_account` (`portal_account_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Password 변경 이력';


/* Create table in target */
CREATE TABLE `portal_api`(
	`portal_api_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Portal_api ID' , 
	`portal_api_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Portal_api 이름' , 
	`portal_api_display_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Portal_api Display 이름' , 
	`portal_api_description` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Portal_api 설명' , 
	`portal_api_status` tinyint(3) NOT NULL  DEFAULT 1 COMMENT 'api 상태 코드(0=inactive 1=active)' , 
	`resources_count` int(10) NOT NULL  DEFAULT 0 COMMENT 'api의 bizunit resource 갯수' , 
	`portal_list_id` int(10) unsigned NOT NULL  COMMENT 'Portal_List ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	`modify_date` datetime NULL  COMMENT '수정일자' , 
	`api_sort_number` smallint(5) NULL  COMMENT 'api 노출 순서' , 
	PRIMARY KEY (`portal_api_id`) , 
	KEY `nix-portal_api-portal_list_id`(`portal_list_id`) , 
	CONSTRAINT `fk-portal_list-portal_api` 
	FOREIGN KEY (`portal_list_id`) REFERENCES `portal_list` (`portal_list_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Portal API 정보';


/* Create table in target */
CREATE TABLE `portal_api_220720`(
	`portal_api_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Portal_api ID' , 
	`portal_api_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Portal_api 이름' , 
	`portal_api_display_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Portal_api Display 이름' , 
	`portal_api_description` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Portal_api 설명' , 
	`portal_api_status` tinyint(3) NOT NULL  DEFAULT 1 COMMENT 'api 상태 코드(0=inactive 1=active)' , 
	`resources_count` int(10) NOT NULL  DEFAULT 0 COMMENT 'api의 bizunit resource 갯수' , 
	`portal_list_id` int(10) unsigned NOT NULL  COMMENT 'Portal_List ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	`modify_date` datetime NULL  COMMENT '수정일자' , 
	`api_sort_number` smallint(5) NULL  COMMENT 'api 노출 순서' , 
	PRIMARY KEY (`portal_api_id`) , 
	KEY `nix-portal_api-portal2_list_id`(`portal_list_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Portal API 정보';


/* Create table in target */
CREATE TABLE `portal_api_resource`(
	`portal_api_resource_id` int(10) NOT NULL  auto_increment COMMENT 'Portal api Resource ID' , 
	`bizunit_sno` int(10) NOT NULL  COMMENT 'Biz Unit SNO' , 
	`portal_api_resource_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Portal api Resource 이름' , 
	`portal_api_resource_description` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Portal_api Resource 설명' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	`modify_date` datetime NULL  COMMENT '수정일자' , 
	PRIMARY KEY (`portal_api_resource_id`) , 
	UNIQUE KEY `uix-portal_api_resource-bizunit_sno`(`bizunit_sno`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Portal API Resource 정보';


/* Create table in target */
CREATE TABLE `portal_app`(
	`portal_app_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Portal_app ID' , 
	`portal_app_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Portal_app 이름' , 
	`portal_app_description` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Portal_app 설명' , 
	`portal_account_id` int(10) unsigned NOT NULL  COMMENT 'Portal_account ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	`modify_date` datetime NULL  COMMENT '수정일자' , 
	PRIMARY KEY (`portal_app_id`) , 
	KEY `nix-portal_app-portal_id`(`portal_account_id`) , 
	CONSTRAINT `fk-potal_account-portal_id` 
	FOREIGN KEY (`portal_account_id`) REFERENCES `portal_account` (`portal_account_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Portal APP 정보';


/* Create table in target */
CREATE TABLE `portal_credential`(
	`portal_credential_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Portal_Credential ID' , 
	`portal_credential_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Portal_Credential 이름' , 
	`portal_credential_desc` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Portal_Credential 설명' , 
	`portal_app_id` int(10) unsigned NOT NULL  COMMENT 'Portal_app ID' , 
	`portal_credential_type` tinyint(3) NOT NULL  COMMENT 'Portal_credential 타입(10 : Oauth / 20 : Simplekey / 30 : SecureProtocol)' , 
	`key_value` json NOT NULL  COMMENT 'Key 값' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	PRIMARY KEY (`portal_credential_id`) , 
	KEY `nix-portal_credential-portal_app_id`(`portal_app_id`) , 
	CONSTRAINT `fk-portal_credential-portal_app_id` 
	FOREIGN KEY (`portal_app_id`) REFERENCES `portal_app` (`portal_app_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Portal Credential 정보';


/* Create table in target */
CREATE TABLE `portal_list`(
	`portal_list_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Portal_List ID' , 
	`portal_list_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Portal_List 이름' , 
	`portal_list_description` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Portal_List 설명' , 
	`portal_url` varchar(128) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'portal URL' , 
	`admin_id` int(11) NOT NULL  COMMENT 'Admin ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	`modify_date` datetime NULL  COMMENT '수정 일자' , 
	PRIMARY KEY (`portal_list_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Portal List 정보';


/* Create table in target */
CREATE TABLE `portal_trail`(
	`portal_trail_id` bigint(10) unsigned NOT NULL  auto_increment COMMENT 'Portal_trail ID' , 
	`portal_list_id` int(10) unsigned NOT NULL  COMMENT 'Portal_List ID' , 
	`portal_account_id` int(10) unsigned NOT NULL  COMMENT 'Portal_account ID' , 
	`resource_id` int(10) unsigned NOT NULL  COMMENT 'Resource ID' , 
	`trail_kind` varchar(20) COLLATE utf8mb4_general_ci NULL  COMMENT '분류(app, api)' , 
	`trail_content` varchar(200) COLLATE utf8mb4_general_ci NULL  COMMENT '작업 내용' , 
	`trail_name` varchar(64) COLLATE utf8mb4_general_ci NULL  COMMENT '계정 이름' , 
	`trail_email` varchar(64) COLLATE utf8mb4_general_ci NULL  COMMENT '계정 이메일' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	PRIMARY KEY (`portal_trail_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Portal Trail 테이블';


/* Create table in target */
CREATE TABLE `project_approver`(
	`project_approver_id` int(10) NOT NULL  auto_increment COMMENT 'Project Approver ID' , 
	`deploy_project_id` int(10) NOT NULL  COMMENT 'Deploy Project ID' , 
	`portal_account_id` int(10) unsigned NOT NULL  COMMENT 'Portal_account ID' , 
	`approver_num` tinyint(3) NOT NULL  COMMENT '승인 순서' , 
	`approver_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '승인자 이름' , 
	`approve_status` varchar(20) COLLATE utf8mb4_general_ci NULL  COMMENT '승인 상태' , 
	`approver_date` datetime NULL  COMMENT '승인 일자' , 
	`reject_comment` varchar(1000) COLLATE utf8mb4_general_ci NULL  COMMENT '반려 사유' , 
	PRIMARY KEY (`project_approver_id`) , 
	KEY `nix-project_approver-deploy_project`(`deploy_project_id`) , 
	KEY `nix-project_approver-portal_account_id`(`portal_account_id`) , 
	CONSTRAINT `fk-project_approver-deploy_project` 
	FOREIGN KEY (`deploy_project_id`) REFERENCES `deploy_project` (`deploy_project_id`) , 
	CONSTRAINT `fk-project_approver-portal_account` 
	FOREIGN KEY (`portal_account_id`) REFERENCES `portal_account` (`portal_account_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Project 배포 승인자 정보';


/* Create table in target */
CREATE TABLE `proxy_api_limit`(
	`proxy_api_limit_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Proxy Api Limit ID' , 
	`bizunit_proxy_id` int(10) NOT NULL  COMMENT 'Bizunit_proxy ID' , 
	`limit_rate_count` int(10) NOT NULL  COMMENT 'TPS 제한 갯수' , 
	`limit_rate_period` int(10) NOT NULL  COMMENT 'TPS 제한 시간(초)' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	`modify_date` datetime NOT NULL  COMMENT '수정일' , 
	PRIMARY KEY (`proxy_api_limit_id`) , 
	UNIQUE KEY `uix-proxy_api_limit-bizunit_proxy_id`(`bizunit_proxy_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Proxy API 유량제어';


/* Create table in target */
CREATE TABLE `proxy_api_statics`(
	`proxy_api_static_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Proxy API 통계 ID' , 
	`static_date` varchar(8) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '통계일자' , 
	`bizunit_proxy_id` int(10) NOT NULL  COMMENT 'Bizunit_proxy ID' , 
	`total_cnt` int(10) NOT NULL  COMMENT '합산 Count' , 
	`success_cnt` int(10) NOT NULL  COMMENT '성공 Count' , 
	`fail_cnt` int(10) NOT NULL  COMMENT '실패 Count' , 
	`latency_avg` decimal(9,3) NOT NULL  COMMENT '평균 Lantency' , 
	PRIMARY KEY (`proxy_api_static_id`) , 
	UNIQUE KEY `uix-portal_api_statics-static_date`(`static_date`,`bizunit_proxy_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Proxy API 통계 테이블';


/* Create table in target */
CREATE TABLE `proxy_shard_info`(
	`proxy_shard_info_id` int(10) NOT NULL  auto_increment COMMENT 'Proxy Shard info ID' , 
	`connection_string` varchar(2000) COLLATE utf8_general_ci NOT NULL  COMMENT 'DB Host,Port 내용' , 
	`accum_value` int(10) NOT NULL  COMMENT 'Proxy mapping 건수' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	PRIMARY KEY (`proxy_shard_info_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8' COLLATE='utf8_general_ci' COMMENT='Proxy shard 정보 테이블';


/* Create table in target */
CREATE TABLE `proxy_shard_match`(
	`proxy_shard_match_id` int(10) NOT NULL  auto_increment COMMENT 'Proxy Shard Match ID' , 
	`proxy_shard_info_id` int(10) NOT NULL  COMMENT 'Proxy Shard info ID' , 
	`bizunit_proxy_id` int(10) NOT NULL  COMMENT 'Bizunit Proxy ID' , 
	`user_id` int(11) NOT NULL  COMMENT 'User ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	PRIMARY KEY (`proxy_shard_match_id`) , 
	UNIQUE KEY `uix-proxy_shard_match-log`(`bizunit_proxy_id`,`user_id`) , 
	KEY `nix-proxy_shard_match-proxy_shard_info_id`(`proxy_shard_info_id`) , 
	CONSTRAINT `fk-proxy_shard_info-match` 
	FOREIGN KEY (`proxy_shard_info_id`) REFERENCES `proxy_shard_info` (`proxy_shard_info_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8' COLLATE='utf8_general_ci' COMMENT='Proxy shard 매핑 테이블';


/* Create table in target */
CREATE TABLE `trail_match`(
	`trail_match_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'trail_match ID' , 
	`portal_list_id` int(10) unsigned NOT NULL  COMMENT 'Portal_List ID' , 
	`resource_id` int(10) unsigned NOT NULL  COMMENT 'Resource ID' , 
	`trail_kind` varchar(20) COLLATE utf8mb4_general_ci NULL  COMMENT '분류(app, api)' , 
	`portal_trail_id` int(10) unsigned NOT NULL  COMMENT 'Portal_trail ID' , 
	PRIMARY KEY (`trail_match_id`) , 
	UNIQUE KEY `uix-trail_match_list`(`portal_list_id`,`resource_id`,`trail_kind`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='trail match 정보';


/*  Create Function in target  */

DELIMITER $$
CREATE FUNCTION `usf_hash_passphrase`(
      pi_vch_salt_value VARCHAR(64) 
    , pi_vch_record_key VARCHAR(50) 
    , pi_vch_passphrase VARCHAR(50) 
) RETURNS binary(32)
    DETERMINISTIC
    COMMENT '\r\nauthor : 김도열\r\ne-mail : purumae@nntuple.com\r\ncreated date : 2017-11-22\r\ndescription : 패스워드를 Hash합니다.\r\nparameter :\r\n      pi_vch_salt_value varchar(64) -- SALT 값\r\n    , pi_vch_record_key varchar(50) -- 행 식별자\r\n    , pi_vch_passphrase varchar(50) -- 패스워드의 평문\r\nusage :\r\n    SELECT usf_hash_passphrase("39aff09b-cf29-11e7-b9c9-f44d30abc64c", "purumae@nntuple.com", "1234");\r\n'
BEGIN
    DECLARE v_bin_return BINARY(32);

    SET v_bin_return = UNHEX(SHA2(CONCAT(pi_vch_salt_value, pi_vch_record_key, pi_vch_passphrase), 256));

    RETURN v_bin_return;
END$$
DELIMITER ;


USE `synctree_studio`;

/* Create table in target */
CREATE TABLE `account_corporation`(
	`corporation_id` smallint(5) unsigned NOT NULL  auto_increment COMMENT '법인 ID' , 
	`master_id` int(11) NOT NULL  COMMENT 'Master ID' , 
	`business_number` varchar(20) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '사업자 번호' , 
	PRIMARY KEY (`corporation_id`) , 
	KEY `fk-master-corporation`(`master_id`) , 
	CONSTRAINT `fk-master-corporation` 
	FOREIGN KEY (`master_id`) REFERENCES `account_master` (`master_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='계정 법인';


/* Create table in target */
CREATE TABLE `account_invite`(
	`account_invite_id` int(10) NOT NULL  auto_increment COMMENT 'Invite User ID' , 
	`invite_user_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Invite User 이름' , 
	`invite_user_email` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Invite User 이메일' , 
	`invite_cert_key` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Invite 인증 키 값' , 
	`invite_date` datetime NOT NULL  COMMENT 'User 초대 시작일' , 
	`expire_date` datetime NOT NULL  COMMENT 'User 초대 만료일' , 
	`invite_status_code` tinyint(3) unsigned NOT NULL  DEFAULT 1 COMMENT 'Invite User 상태 코드 (0=inactive, 1=active, 2=registerd)' , 
	`admin_id` int(11) NOT NULL  COMMENT '초대한 Admin ID' , 
	`user_id` int(11) NOT NULL  COMMENT '초대한 User ID' , 
	`permission_group_id` int(10) unsigned NOT NULL  DEFAULT 0 COMMENT '권한 그룹 ID' , 
	`invite_send_count` tinyint(5) NOT NULL  DEFAULT 0 COMMENT '초대 count 수' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	`modify_date` datetime NULL  COMMENT '수정일자' , 
	PRIMARY KEY (`account_invite_id`) , 
	KEY `nix-slave-master_id`(`user_id`) , 
	CONSTRAINT `fk-account_slave-account_invite` 
	FOREIGN KEY (`user_id`) REFERENCES `account_slave` (`slave_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='초대 User 정보';


/* Create table in target */
CREATE TABLE `account_master`(
	`master_id` int(11) NOT NULL  auto_increment COMMENT 'Admin ID' , 
	`master_account` varchar(10) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '계정 번호' , 
	`master_division` varchar(10) COLLATE utf8mb4_general_ci NOT NULL  DEFAULT 'public' COMMENT '계정 구분 (public, dedicate, enterprise)' , 
	`master_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Admin 이름' , 
	`master_email` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Admin 이메일' , 
	`master_passphrase` binary(32) NOT NULL  COMMENT 'Admin 로그인 비밀번호' , 
	`master_status_code` tinyint(3) unsigned NOT NULL  COMMENT 'Admin 상태 코드 (0=inactive, 1=active, 2=deactivated)' , 
	`product_sno` smallint(5) unsigned NOT NULL  DEFAULT 1 COMMENT '사용 상품 SNO' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	`modify_date` datetime NULL  COMMENT '수정일자' , 
	`login_date` datetime NULL  COMMENT '로그인 일자' , 
	PRIMARY KEY (`master_id`) , 
	UNIQUE KEY `uix-account_master-master_account`(`master_account`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='계정 Admin';


/* Create table in target */
CREATE TABLE `account_otp`(
	`otp_id` int(10) NOT NULL  auto_increment COMMENT 'OTP ID' , 
	`account_id` int(10) NOT NULL  COMMENT '계정 ID' , 
	`account_type` tinyint(3) NOT NULL  COMMENT 'Account Type (1: admin, 2: user)' , 
	`otp_type` varchar(12) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'OTP Type(Google)' , 
	`secret_key` varchar(12) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Secret key 값' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	`modify_date` datetime NULL  COMMENT '수정 일자' , 
	PRIMARY KEY (`otp_id`) , 
	UNIQUE KEY `uix-account_otp-account_id_type`(`account_id`,`account_type`) , 
	UNIQUE KEY `uix-account_otp-secret_key`(`secret_key`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='계정 OTP';


/* Create table in target */
CREATE TABLE `account_slave`(
	`slave_id` int(11) NOT NULL  auto_increment COMMENT 'User ID' , 
	`slave_type` tinyint(3) unsigned NOT NULL  DEFAULT 1 COMMENT 'User 유형 (0=Temporary, 1=Slave, 2=Root)' , 
	`slave_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'User 이름' , 
	`slave_email` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'User 이메일' , 
	`slave_passphrase` binary(32) NOT NULL  COMMENT 'User 로그인 비밀번호' , 
	`slave_expire_date` datetime NULL  COMMENT 'User 유효 기간' , 
	`slave_status_code` tinyint(3) unsigned NOT NULL  COMMENT 'User 상태 코드 (0=inactive, 1=active, 2=deactivated)' , 
	`slave_purpose` tinyint(3) unsigned NOT NULL  DEFAULT 0 COMMENT 'User 용도 (0=normal, 1=official)' , 
	`master_id` int(11) NOT NULL  COMMENT 'Admin ID' , 
	`master_account` varchar(10) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '계정 번호' , 
	`permission_group_id` int(10) unsigned NOT NULL  DEFAULT 0 COMMENT '권한 그룹 ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	`modify_date` datetime NULL  COMMENT '수정일자' , 
	`login_date` datetime NULL  COMMENT '로그인 일자' , 
	PRIMARY KEY (`slave_id`) , 
	UNIQUE KEY `uix-account_slave-slave_email`(`slave_email`) , 
	KEY `nix-slave-master_id`(`master_id`) , 
	KEY `account_slave_X01`(`register_date`) , 
	CONSTRAINT `fk-master-slave` 
	FOREIGN KEY (`master_id`) REFERENCES `account_master` (`master_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='계정 User';


/* Create table in target */
CREATE TABLE `account_social`(
	`social_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Social ID' , 
	`social_type` varchar(20) COLLATE utf8mb4_general_ci NOT NULL  DEFAULT 'google' COMMENT 'Social 유형' , 
	`social_email` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Social 이메일' , 
	`user_id` int(11) NOT NULL  COMMENT 'User ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	`login_date` datetime NULL  COMMENT '로그인 일자' , 
	`is_del` varchar(4) COLLATE utf8mb4_general_ci NOT NULL  DEFAULT 'N' COMMENT '삭제 여부' , 
	`del_date` datetime NULL  COMMENT '삭제 일자' , 
	PRIMARY KEY (`social_id`) , 
	KEY `nix-account_social-user_id`(`user_id`) , 
	CONSTRAINT `fk-slave-social` 
	FOREIGN KEY (`user_id`) REFERENCES `account_slave` (`slave_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='계정 Social 연동';


/* Create table in target */
CREATE TABLE `app`(
	`app_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'App ID' , 
	`app_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'App 이름' , 
	`app_description` varchar(1000) COLLATE utf8mb4_general_ci NULL  COMMENT 'App 설명' , 
	`admin_id` int(11) NOT NULL  COMMENT 'Admin ID' , 
	`user_id` int(11) NOT NULL  COMMENT 'User ID' , 
	`access_privilege` varchar(20) COLLATE utf8mb4_general_ci NULL  DEFAULT 'public' COMMENT '접근권한' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	`modify_date` datetime NULL  COMMENT '수정 일자' , 
	PRIMARY KEY (`app_id`) , 
	KEY `nix-account_slave-slave_id`(`user_id`) , 
	KEY `app_X01`(`register_date`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='App';


/* Create table in target */
CREATE TABLE `batch`(
	`batch_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Batch ID' , 
	`batch_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Batch 이름' , 
	`batch_description` text COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Batch 설명' , 
	`batch_content` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Batch 내용' , 
	`admin_id` int(11) NOT NULL  COMMENT 'Admin ID' , 
	`user_id` int(11) NOT NULL  COMMENT 'User ID' , 
	`access_privilege` varchar(20) COLLATE utf8mb4_general_ci NULL  DEFAULT 'public' COMMENT '접근권한' , 
	`send_email` json NULL  COMMENT '알림 이메일' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	`modify_date` datetime NULL  COMMENT '수정 일자' , 
	PRIMARY KEY (`batch_id`) , 
	KEY `nix-batch-user_id`(`user_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Batch';


/* Create table in target */
CREATE TABLE `batch_history`(
	`batch_history_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Batch History ID' , 
	`batch_id` int(10) unsigned NOT NULL  COMMENT 'Batch ID' , 
	`batch_match_id` int(10) unsigned NOT NULL  COMMENT 'Batch match ID' , 
	`bizunit_sno` int(10) unsigned NOT NULL  COMMENT 'Bizunit SNO' , 
	`revision_sno` int(10) unsigned NOT NULL  COMMENT 'Revision SNO' , 
	`batch_success` enum('Y','N','S') COLLATE utf8mb4_general_ci NULL  DEFAULT 'S' COMMENT '배치 성공여부' , 
	`batch_message` text COLLATE utf8mb4_general_ci NULL  COMMENT 'Batch 결과 내용' , 
	`exec_count` tinyint(5) NULL  DEFAULT 0 COMMENT '실행 횟수' , 
	`redo_count` tinyint(5) NULL  DEFAULT 0 COMMENT '재실행 카운트' , 
	`batch_mode` varchar(12) COLLATE utf8mb4_general_ci NULL  DEFAULT 'schedule' COMMENT 'Batch 실행방법' , 
	`batch_process_id` varchar(40) COLLATE utf8mb4_general_ci NULL  COMMENT 'Batch Process ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	`modify_date` datetime NULL  COMMENT '수정 일자' , 
	PRIMARY KEY (`batch_history_id`) , 
	KEY `nix-batch_history-batch_id`(`batch_id`) , 
	KEY `nix-batch_history-batch_match_id`(`batch_match_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Batch History';


/* Create table in target */
CREATE TABLE `batch_match`(
	`batch_match_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Batch match ID' , 
	`batch_id` int(10) unsigned NOT NULL  COMMENT 'Batch ID' , 
	`bizunit_sno` int(10) unsigned NOT NULL  COMMENT 'Bizunit SNO' , 
	`revision_sno` int(10) unsigned NOT NULL  COMMENT 'Revision SNO' , 
	`argument_header` json NULL  COMMENT 'Argument Header' , 
	`argument_body` text COLLATE utf8mb4_general_ci NULL  COMMENT 'Argument Body' , 
	`redo_count` tinyint(5) NULL  DEFAULT 0 COMMENT '재실행 카운트' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	`modify_date` datetime NULL  COMMENT '수정 일자' , 
	PRIMARY KEY (`batch_match_id`) , 
	UNIQUE KEY `uix-batch_match-batch_id`(`batch_id`,`bizunit_sno`,`revision_sno`) , 
	KEY `nix-batch_match-revision_sno`(`revision_sno`) , 
	CONSTRAINT `fk-batch-batch_match` 
	FOREIGN KEY (`batch_id`) REFERENCES `batch` (`batch_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Batch match';


/* Create table in target */
CREATE TABLE `bizunit`(
	`bizunit_sno` int(10) unsigned NOT NULL  auto_increment COMMENT 'Biz Unit SNO' , 
	`bizunit_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Biz Unit ID' , 
	`bizunit_version` varchar(12) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Biz Unit 버전' , 
	`app_id` int(10) unsigned NOT NULL  COMMENT 'App ID' , 
	`bizunit_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Biz Unit 이름' , 
	`bizunit_description` varchar(1000) COLLATE utf8mb4_general_ci NULL  COMMENT 'Biz Unit 설명' , 
	`plan_version` varchar(10) COLLATE utf8mb4_general_ci NULL  COMMENT '엔진 버전' , 
	`admin_id` int(11) NOT NULL  COMMENT 'Admin ID' , 
	`user_id` int(11) NOT NULL  COMMENT 'User ID' , 
	`access_privilege` varchar(20) COLLATE utf8mb4_general_ci NULL  DEFAULT 'public' COMMENT '접근권한' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	`modify_date` datetime NULL  COMMENT '수정 일자' , 
	PRIMARY KEY (`bizunit_sno`) , 
	UNIQUE KEY `uix-bizunit-bizunit_id`(`bizunit_id`,`bizunit_version`) , 
	KEY `nix-bizunit-app_id`(`app_id`) , 
	KEY `bizunit_X01`(`register_date`) , 
	CONSTRAINT `fk-app-bizunit` 
	FOREIGN KEY (`app_id`) REFERENCES `app` (`app_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Biz Unit';


/* Create table in target */
CREATE TABLE `bizunit_proxy`(
	`bizunit_proxy_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'bizunit_proxy ID' , 
	`bizunit_proxy_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'bizunit_proxy 이름' , 
	`bizunit_proxy_description` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'bizunit_proxy 설명' , 
	`bizunit_sno` int(10) unsigned NOT NULL  COMMENT 'Biz Unit SNO' , 
	`bizunit_proxy_base_path` varchar(256) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'bizunit_proxy 기본 경로' , 
	`bizunit_proxy_target_path` varchar(256) COLLATE utf8mb4_general_ci NULL  COMMENT 'bizunit_proxy target 경로' , 
	`bizunit_proxy_method` varchar(20) COLLATE utf8mb4_general_ci NOT NULL  DEFAULT 'POST' COMMENT 'bizunit_proxy Method' , 
	`master_account` varchar(10) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '계정 번호' , 
	`user_id` int(11) NOT NULL  COMMENT 'User ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	`modify_date` datetime NULL  COMMENT '수정 일자' , 
	PRIMARY KEY (`bizunit_proxy_id`) , 
	KEY `nix-bizunit_proxy-bizunit_sno`(`bizunit_sno`) , 
	KEY `nix-bizunit_proxy-path`(`bizunit_proxy_base_path`,`bizunit_proxy_method`) , 
	CONSTRAINT `fk-bizunit-bizunit_proxy` 
	FOREIGN KEY (`bizunit_sno`) REFERENCES `bizunit` (`bizunit_sno`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Biz Unit Proxy';


/* Create table in target */
CREATE TABLE `credential`(
	`credential_id` int(10) NOT NULL  auto_increment COMMENT 'credential ID' , 
	`credential_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'credential 이름' , 
	`credential_description` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'credential 설명' , 
	`admin_id` int(11) NOT NULL  COMMENT 'Admin ID' , 
	`user_id` int(11) NOT NULL  COMMENT 'User ID' , 
	`access_privilege` varchar(20) COLLATE utf8mb4_general_ci NULL  DEFAULT 'public' COMMENT '접근권한' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	`modify_date` datetime NULL  COMMENT '수정일' , 
	`is_del` varchar(4) COLLATE utf8mb4_general_ci NOT NULL  DEFAULT 'N' COMMENT '삭제여부' , 
	`del_date` datetime NULL  COMMENT '삭제일' , 
	PRIMARY KEY (`credential_id`) , 
	KEY `nix-slave-slave_id`(`user_id`) , 
	CONSTRAINT `fk-slave-credential` 
	FOREIGN KEY (`user_id`) REFERENCES `account_slave` (`slave_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='credential 기본 Table';


/* Create table in target */
CREATE TABLE `credential_detail`(
	`credential_detail_id` int(10) NOT NULL  auto_increment COMMENT 'credential_detail ID' , 
	`credential_id` int(10) NOT NULL  COMMENT 'credential ID' , 
	`credential_environment` char(10) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'credential 환경(dev, feature, stage, production, hotfix)' , 
	`credential_type` tinyint(3) NOT NULL  COMMENT 'credential 타입(10 : Oauth / 20 : Simplekey / 30 : SecureProtocol)' , 
	`credential_detail_title` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'credential_detail 제목' , 
	`credential_detail_description` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'credential_detail 설명' , 
	`key_value` json NOT NULL  COMMENT 'Key 값' , 
	`admin_id` int(11) NOT NULL  COMMENT 'Admin ID' , 
	`user_id` int(11) NOT NULL  COMMENT 'User ID' , 
	`access_privilege` varchar(20) COLLATE utf8mb4_general_ci NULL  DEFAULT 'public' COMMENT '접근권한' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	`modify_date` datetime NULL  COMMENT '수정일' , 
	`is_del` varchar(4) COLLATE utf8mb4_general_ci NOT NULL  DEFAULT 'N' COMMENT '삭제여부' , 
	`del_date` datetime NULL  COMMENT '삭제일' , 
	PRIMARY KEY (`credential_detail_id`) , 
	KEY `nix-credential-credential_id`(`credential_id`) , 
	CONSTRAINT `fk-credential-credential_detail` 
	FOREIGN KEY (`credential_id`) REFERENCES `credential` (`credential_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='credential 상세 Table';


/* Create table in target */
CREATE TABLE `credential_match`(
	`credential_match_id` int(10) NOT NULL  auto_increment COMMENT 'credential_match ID' , 
	`credential_id` int(10) NOT NULL  COMMENT 'credential ID' , 
	`app_id` int(10) unsigned NOT NULL  COMMENT '매칭 App ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	PRIMARY KEY (`credential_match_id`) , 
	UNIQUE KEY `uix-credential_match-mix_id`(`credential_id`,`app_id`) , 
	KEY `nix-credential-credential_id`(`credential_id`) , 
	KEY `nix-credential-app_id`(`app_id`) , 
	CONSTRAINT `fk-app-credential_match` 
	FOREIGN KEY (`app_id`) REFERENCES `app` (`app_id`) , 
	CONSTRAINT `fk-credential-credential_match` 
	FOREIGN KEY (`credential_id`) REFERENCES `credential` (`credential_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='credential 매칭 정보';


/* Create table in target */
CREATE TABLE `dictionary`(
	`dictionary_id` int(10) NOT NULL  auto_increment COMMENT 'dictionary ID' , 
	`dictionary_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'dictionary 이름' , 
	`dictionary_description` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'dictionary 설명' , 
	`admin_id` int(11) NOT NULL  COMMENT 'Admin ID' , 
	`user_id` int(11) NOT NULL  COMMENT 'User ID' , 
	`access_privilege` varchar(20) COLLATE utf8mb4_general_ci NULL  DEFAULT 'public' COMMENT '접근권한' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	`modify_date` datetime NULL  COMMENT '수정일' , 
	`is_del` varchar(4) COLLATE utf8mb4_general_ci NULL  DEFAULT 'N' COMMENT '삭제여부' , 
	`del_date` datetime NULL  COMMENT '삭제일' , 
	PRIMARY KEY (`dictionary_id`) , 
	KEY `nix-slave-slave_id`(`user_id`) , 
	CONSTRAINT `fk-slave-dictionary` 
	FOREIGN KEY (`user_id`) REFERENCES `account_slave` (`slave_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='dictionary 기본 Table';


/* Create table in target */
CREATE TABLE `dictionary_detail`(
	`dictionary_detail_id` int(10) NOT NULL  auto_increment COMMENT 'dictionary_detail ID' , 
	`dictionary_id` int(10) NULL  COMMENT 'dictionary ID' , 
	`dictionary_type` tinyint(3) NOT NULL  COMMENT 'dictionary 타입(10 : Config / 20 : Secret / 30: Extension)' , 
	`key_name` varchar(40) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Key 값' , 
	`dictionary_detail_description` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'dictionary_detail 설명' , 
	`key_value` json NOT NULL  COMMENT 'Key_Value값' , 
	`live_key_value` json NULL  COMMENT '운영 Key_Value값' , 
	`admin_id` int(11) NOT NULL  COMMENT 'Admin ID' , 
	`user_id` int(11) NOT NULL  COMMENT 'User ID' , 
	`access_privilege` varchar(20) COLLATE utf8mb4_general_ci NULL  DEFAULT 'public' COMMENT '접근권한' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	`modify_date` datetime NULL  COMMENT '수정일' , 
	`is_del` varchar(4) COLLATE utf8mb4_general_ci NOT NULL  DEFAULT 'N' COMMENT '삭제여부' , 
	`del_date` datetime NULL  COMMENT '삭제일' , 
	PRIMARY KEY (`dictionary_detail_id`) , 
	KEY `nix-dictionary_detail-user_id`(`user_id`) , 
	CONSTRAINT `fk-slave-dictionary_detail` 
	FOREIGN KEY (`user_id`) REFERENCES `account_slave` (`slave_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='dictionary 상세 Table';


/* Create table in target */
CREATE TABLE `dictionary_detail_match`(
	`dictionary_detail_match_id` int(10) NOT NULL  auto_increment COMMENT 'Dictionary_detail match ID' , 
	`dictionary_detail_id` int(10) NULL  COMMENT 'Dictionary_detail ID' , 
	`bizunit_sno` int(10) unsigned NOT NULL  COMMENT '매칭 Bizunit SNO' , 
	`revision_sno` int(10) unsigned NOT NULL  COMMENT '매칭 Revision SNO' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	PRIMARY KEY (`dictionary_detail_match_id`) , 
	UNIQUE KEY `uix-dictionary_match-mix_id`(`dictionary_detail_id`,`revision_sno`) , 
	KEY `nix-dictionary-dictionary_detail_id`(`dictionary_detail_id`) , 
	KEY `nix-dictionary-revision_sno`(`revision_sno`) , 
	CONSTRAINT `fk-dictionary-dictionary_detail_match` 
	FOREIGN KEY (`dictionary_detail_id`) REFERENCES `dictionary_detail` (`dictionary_detail_id`) , 
	CONSTRAINT `fk-revision-dictionary_detail_match` 
	FOREIGN KEY (`revision_sno`) REFERENCES `revision` (`revision_sno`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='dictionary detail 매칭 정보';


/* Create table in target */
CREATE TABLE `dictionary_match`(
	`dictionary_match_id` int(10) NOT NULL  auto_increment COMMENT 'dictionary_match ID' , 
	`dictionary_id` int(10) NOT NULL  COMMENT 'dictionary ID' , 
	`app_id` int(10) unsigned NOT NULL  COMMENT '매칭 App ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	PRIMARY KEY (`dictionary_match_id`) , 
	UNIQUE KEY `uix-dictionary_match-mix_id`(`dictionary_id`,`app_id`) , 
	KEY `nix-dictionary-dictionary_id`(`dictionary_id`) , 
	KEY `nix-dictionary-app_id`(`app_id`) , 
	CONSTRAINT `fk-app-dictionary_match` 
	FOREIGN KEY (`app_id`) REFERENCES `app` (`app_id`) , 
	CONSTRAINT `fk-dictionary-dictionary_match` 
	FOREIGN KEY (`dictionary_id`) REFERENCES `dictionary` (`dictionary_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='dictionary 매칭 정보';


/* Create table in target */
CREATE TABLE `extension_match`(
	`extension_match_id` int(10) NOT NULL  auto_increment COMMENT 'Extension_match ID' , 
	`dictionary_detail_id` int(10) NOT NULL  COMMENT 'Dictionary_detail ID' , 
	`extension_type` varchar(20) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Extension 종류' , 
	`extension_id` int(10) NOT NULL  COMMENT 'Extension ID' , 
	`extension_purpose` varchar(20) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Extension 사용용도' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	PRIMARY KEY (`extension_match_id`) , 
	UNIQUE KEY `uix-extension_match-mix_id`(`extension_type`,`extension_id`,`extension_purpose`,`dictionary_detail_id`) , 
	KEY `nix-extension_match-dictionary_detail_id`(`dictionary_detail_id`) , 
	CONSTRAINT `fk-dictionary_detail-extension_match` 
	FOREIGN KEY (`dictionary_detail_id`) REFERENCES `dictionary_detail` (`dictionary_detail_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Extension 매칭 정보';


/* Create table in target */
CREATE TABLE `library`(
	`library_sno` int(10) unsigned NOT NULL  auto_increment COMMENT 'Library SNO' , 
	`library_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Library ID' , 
	`library_group_id` int(10) unsigned NULL  COMMENT 'Library 그룹 ID' , 
	`library_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Library 이름' , 
	`library_desc` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Library 설명' , 
	`library_version` varchar(12) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Library 버전' , 
	`library_content` json NOT NULL  COMMENT 'Library 내용' , 
	`library_status_code` tinyint(3) NOT NULL  DEFAULT 0 COMMENT 'Library 상태 코드 (0=standby, 1=active)' , 
	`library_type` tinyint(3) NOT NULL  DEFAULT 0 COMMENT 'Library 종류(0 : studio / 1 : Marketplace)' , 
	`plan_version` varchar(10) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '엔진 버전' , 
	`bookmark_status` enum('Y','N') COLLATE utf8mb4_general_ci NOT NULL  DEFAULT 'N' COMMENT '즐겨찾기 상태 (Y:활성화, N:비활성화)' , 
	`source_slave_id` int(11) NOT NULL  COMMENT '출처 Slave ID' , 
	`source_library_id` varchar(64) COLLATE utf8mb4_general_ci NULL  COMMENT '출처 Library ID' , 
	`register_account` int(11) NOT NULL  COMMENT '등록자 (Slave ID)' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	`modify_date` datetime NULL  COMMENT '수정일' , 
	PRIMARY KEY (`library_sno`) , 
	UNIQUE KEY `uix-library-library_id`(`library_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Library';


/* Create table in target */
CREATE TABLE `library_group`(
	`group_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Library 그룹 ID' , 
	`group_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Library 그룹 이름' , 
	`source_slave_id` int(11) NULL  COMMENT '출처 Slave ID' , 
	`register_account` int(11) NOT NULL  COMMENT '등록자 (Slave ID)' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	`modify_date` datetime NULL  COMMENT '수정일' , 
	PRIMARY KEY (`group_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Library 그룹';


/* Create table in target */
CREATE TABLE `metrics`(
	`metrics_sno` int(10) unsigned NOT NULL  auto_increment COMMENT 'Metrics SNO' , 
	`metrics_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Metrics ID' , 
	`metrics_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Metrics 이름' , 
	`metrics_description` text COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Metrics 설명' , 
	`metrics_channel` varchar(40) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Metrics Channel Value' , 
	`metrics_menu` varchar(40) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Metrics Menu Value' , 
	`metrics_action` varchar(40) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Metrics Action Value' , 
	`user_id` int(11) NOT NULL  COMMENT 'User ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	`modify_date` datetime NULL  COMMENT '수정 일자' , 
	PRIMARY KEY (`metrics_sno`) , 
	UNIQUE KEY `uix-metrics-metrics_id`(`metrics_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Metrics';


/* Create table in target */
CREATE TABLE `metrics_history`(
	`metrics_history_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Metrics_History ID' , 
	`metrics_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Metrics ID' , 
	`metrics_channel` varchar(40) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Metrics Channel Value' , 
	`metrics_menu` varchar(40) COLLATE utf8mb4_general_ci NULL  COMMENT 'Metrics Menu Value' , 
	`metrics_action` varchar(40) COLLATE utf8mb4_general_ci NULL  COMMENT 'Metrics Action Value' , 
	`metrics_value` int(10) NOT NULL  COMMENT 'Metrics Value' , 
	`metrics_label` varchar(40) COLLATE utf8mb4_general_ci NULL  COMMENT 'Metrics Label' , 
	`bizunit_sno` int(10) unsigned NOT NULL  COMMENT 'BizUnit SNO' , 
	`revision_sno` int(10) unsigned NOT NULL  COMMENT 'Revision SNO' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	PRIMARY KEY (`metrics_history_id`) , 
	KEY `nix-metrics_history-metrics_channel`(`metrics_channel`) , 
	KEY `nix-metrics_history-metrics_menu`(`metrics_menu`) , 
	KEY `nix-metrics_history-metrics_action`(`metrics_action`) , 
	KEY `nix-metrics_history-bizunit_sno`(`bizunit_sno`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Metrics History';


/* Create table in target */
CREATE TABLE `object`(
	`object_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Object ID' , 
	`app_id` int(10) unsigned NOT NULL  COMMENT 'App ID' , 
	`object_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Object 이름' , 
	`object_description` varchar(1000) COLLATE utf8mb4_general_ci NULL  COMMENT 'Object 설명' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	`modify_date` datetime NULL  COMMENT '수정 일자' , 
	PRIMARY KEY (`object_id`) , 
	KEY `nix-object-app_id`(`app_id`) , 
	CONSTRAINT `fk-app-object` 
	FOREIGN KEY (`app_id`) REFERENCES `app` (`app_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Object';


/* Create table in target */
CREATE TABLE `operator`(
	`operator_sno` int(10) unsigned NOT NULL  auto_increment COMMENT 'Operator SNO' , 
	`operator_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Operator ID' , 
	`operator_seq` int(10) NOT NULL  COMMENT 'Operator 순서' , 
	`bizunit_sno` int(10) unsigned NOT NULL  DEFAULT 0 COMMENT 'Biz Unit SNO' , 
	`bizunit_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Biz Unit ID' , 
	`bizunit_version` varchar(12) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Biz Unit 버전' , 
	`revision_sno` int(10) unsigned NOT NULL  DEFAULT 0 COMMENT 'Revision SNO' , 
	`operator_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Operator 이름' , 
	`operator_desc` varchar(1000) COLLATE utf8mb4_general_ci NULL  COMMENT 'Operator 설명' , 
	`operator_content` longtext COLLATE utf8mb4_general_ci NULL  COMMENT 'Operator 내용' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	`modify_date` datetime NULL  COMMENT '수정 일자' , 
	`object_id` int(10) unsigned NOT NULL  COMMENT 'Object ID' , 
	`update_user_id` int(11) NOT NULL  COMMENT '수정자 User ID' , 
	PRIMARY KEY (`operator_sno`) , 
	UNIQUE KEY `uix-operator-revision_sno`(`revision_sno`) , 
	KEY `nix-operator-bizunit_id`(`bizunit_id`,`bizunit_version`) , 
	KEY `nix-operator-object_id`(`object_id`) , 
	KEY `nix-operator-bizunit_sno`(`bizunit_sno`,`revision_sno`) , 
	CONSTRAINT `fk-bizunit-operator` 
	FOREIGN KEY (`bizunit_id`, `bizunit_version`) REFERENCES `bizunit` (`bizunit_id`, `bizunit_version`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Operator';


/* Create table in target */
CREATE TABLE `permission`(
	`permission_id` int(10) unsigned NOT NULL  auto_increment COMMENT '권한 ID' , 
	`permission_category` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '권한 분류' , 
	`permission_code` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '권한 코드' , 
	`permission_desc` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '권한 설명' , 
	PRIMARY KEY (`permission_id`) , 
	UNIQUE KEY `uix-permission-code`(`permission_category`,`permission_code`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='권한';


/* Create table in target */
CREATE TABLE `permission_group`(
	`permission_group_id` int(10) unsigned NOT NULL  auto_increment COMMENT '권한 그룹 ID' , 
	`permission_group_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '권한 그룹 이름' , 
	`permission_category_list` json NOT NULL  COMMENT '권한 분류 리스트' , 
	PRIMARY KEY (`permission_group_id`) , 
	UNIQUE KEY `uix-permission_group-name`(`permission_group_name`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='권한 그룹';


/* Create table in target */
CREATE TABLE `permission_have`(
	`have_id` int(10) unsigned NOT NULL  auto_increment COMMENT '권한 보유 ID' , 
	`slave_id` int(11) NOT NULL  COMMENT 'Slave ID' , 
	`permission_id` int(10) unsigned NOT NULL  COMMENT '권한 ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	PRIMARY KEY (`have_id`) , 
	UNIQUE KEY `uix-permission_have-permission_id`(`slave_id`,`permission_id`) , 
	KEY `nix-permission_have-slave_id`(`slave_id`) , 
	KEY `nix-permission_have-permission_id`(`permission_id`) , 
	CONSTRAINT `fk-permission-permission_have` 
	FOREIGN KEY (`permission_id`) REFERENCES `permission` (`permission_id`) , 
	CONSTRAINT `fk-slave-permission_have` 
	FOREIGN KEY (`slave_id`) REFERENCES `account_slave` (`slave_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='권한 보유';


/* Create table in target */
CREATE TABLE `query_manager`(
	`query_sno` int(10) unsigned NOT NULL  auto_increment COMMENT 'Query SNO' , 
	`query_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Query 이름' , 
	`query_description` text COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Query 설명' , 
	`query_id` varchar(20) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Query ID' , 
	`user_id` int(11) NOT NULL  COMMENT 'User ID' , 
	`account_number` varchar(10) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '계정번호' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	`modify_date` datetime NULL  COMMENT '수정 일자' , 
	PRIMARY KEY (`query_sno`) , 
	KEY `nix-query_manager-user_id`(`user_id`) , 
	CONSTRAINT `fk-account_slave-user_id` 
	FOREIGN KEY (`user_id`) REFERENCES `account_slave` (`slave_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Query_manager';


/* Create table in target */
CREATE TABLE `query_manager_detail`(
	`query_detail_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Query_detail ID' , 
	`query_sno` int(10) unsigned NOT NULL  COMMENT 'Query SNO' , 
	`query_environment` varchar(12) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Query 환경 (dev, feature, stage, production, hotfix)' , 
	`query_content` text COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Query 내용' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	`modify_date` datetime NULL  COMMENT '수정 일자' , 
	PRIMARY KEY (`query_detail_id`) , 
	KEY `nix-query_manager_detail-query_sno`(`query_sno`) , 
	CONSTRAINT `fk-query_manager-query_sno` 
	FOREIGN KEY (`query_sno`) REFERENCES `query_manager` (`query_sno`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Query_manager 상세';


/* Create table in target */
CREATE TABLE `query_manager_match`(
	`query_match_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Query_match ID' , 
	`query_detail_id` int(10) unsigned NOT NULL  COMMENT 'Query_detail ID' , 
	`bizunit_sno` int(10) NOT NULL  COMMENT 'Bizunit SNO' , 
	`revision_sno` int(10) unsigned NOT NULL  COMMENT 'Revision SNO' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	PRIMARY KEY (`query_match_id`) , 
	KEY `nix-query_manager_match-query_detail_id`(`query_detail_id`) , 
	KEY `nix-query_manager_match-revision_sno`(`revision_sno`) , 
	CONSTRAINT `fk-query_manager_detail-query_detail_id` 
	FOREIGN KEY (`query_detail_id`) REFERENCES `query_manager_detail` (`query_detail_id`) , 
	CONSTRAINT `fk-query_manager_match-revision_sno` 
	FOREIGN KEY (`revision_sno`) REFERENCES `revision` (`revision_sno`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Query_manager Match';


/* Create table in target */
CREATE TABLE `revision`(
	`revision_sno` int(10) unsigned NOT NULL  auto_increment COMMENT 'Revision SNO' , 
	`revision_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Revision ID' , 
	`bizunit_sno` int(10) unsigned NOT NULL  COMMENT 'Biz Unit SNO' , 
	`revision_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Revision 이름' , 
	`revision_environment` varchar(10) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Revision 환경 (dev, feature, stage, production, hotfix)' , 
	`revision_status_code` tinyint(3) unsigned NOT NULL  COMMENT 'Revision 상태 코드 (0=standby, 1=active)' , 
	`revision_sharing` tinyint(3) unsigned NOT NULL  DEFAULT 0 COMMENT 'Revision 공유 유무 (0=공유 해제, 1=공유 중)' , 
	`new_creation` varchar(2) COLLATE utf8mb4_general_ci NULL  DEFAULT 'Y' COMMENT 'Revision 신규 생성 유무' , 
	`admin_id` int(11) NOT NULL  COMMENT 'Admin ID' , 
	`user_id` int(11) NOT NULL  COMMENT 'User ID' , 
	`access_privilege` varchar(20) COLLATE utf8mb4_general_ci NULL  DEFAULT 'public' COMMENT '접근권한' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	`modify_date` datetime NULL  COMMENT '수정일' , 
	PRIMARY KEY (`revision_sno`) , 
	UNIQUE KEY `uix-revision-revision_id`(`revision_id`,`bizunit_sno`) , 
	KEY `nix-revision-bizunit_sno`(`bizunit_sno`) , 
	CONSTRAINT `fk-bizunit-revision` 
	FOREIGN KEY (`bizunit_sno`) REFERENCES `bizunit` (`bizunit_sno`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Revision';


/* Create table in target */
CREATE TABLE `revision_history`(
	`history_sno` int(10) unsigned NOT NULL  auto_increment COMMENT 'History SNO' , 
	`bizunit_sno` int(10) unsigned NOT NULL  COMMENT 'Biz Unit SNO' , 
	`revision_sno` int(10) unsigned NOT NULL  COMMENT 'Revision SNO' , 
	`revision_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Revision 이름' , 
	`revision_environment` varchar(10) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Revision 환경' , 
	`history_message` varchar(1000) COLLATE utf8mb4_general_ci NULL  COMMENT 'History 시스템 메시지' , 
	`history_comment` varchar(1000) COLLATE utf8mb4_general_ci NULL  COMMENT 'History 사용자 메시지' , 
	`source_revision_sno` int(10) unsigned NULL  DEFAULT 0 COMMENT '출처 Revision SNO' , 
	`source_revision_name` varchar(100) COLLATE utf8mb4_general_ci NULL  COMMENT '출처 Revision 이름' , 
	`source_revision_environment` varchar(10) COLLATE utf8mb4_general_ci NULL  COMMENT '출처 Revision 환경' , 
	`register_account` int(11) NOT NULL  COMMENT '등록자 (Slave ID)' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	PRIMARY KEY (`history_sno`) , 
	KEY `nix-revision_history-bizunit_sno`(`bizunit_sno`) , 
	KEY `nix-revision_history-revision_sno`(`revision_sno`) , 
	CONSTRAINT `fk-bizunit-revision_history` 
	FOREIGN KEY (`bizunit_sno`) REFERENCES `bizunit` (`bizunit_sno`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Revision History';


/* Create table in target */
CREATE TABLE `revision_share`(
	`share_sno` int(10) unsigned NOT NULL  auto_increment COMMENT 'Revision 공유 SNO' , 
	`slave_id` int(11) NOT NULL  COMMENT 'Slave ID' , 
	`bizunit_sno` int(10) unsigned NOT NULL  COMMENT 'Biz Unit SNO' , 
	`revision_sno` int(10) unsigned NOT NULL  COMMENT 'Revision SNO' , 
	`register_date` datetime NOT NULL  DEFAULT CURRENT_TIMESTAMP COMMENT '등록일' , 
	PRIMARY KEY (`share_sno`) , 
	KEY `fk-bizunit-revision_share`(`bizunit_sno`) , 
	KEY `fk-revision-revision_share`(`revision_sno`) , 
	KEY `nix-account_slave-revision_share`(`slave_id`) , 
	CONSTRAINT `fk-bizunit-revision_share` 
	FOREIGN KEY (`bizunit_sno`) REFERENCES `bizunit` (`bizunit_sno`) , 
	CONSTRAINT `fk-revision-revision_share` 
	FOREIGN KEY (`revision_sno`) REFERENCES `revision` (`revision_sno`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Revision 공유';


/* Create table in target */
CREATE TABLE `rfc`(
	`rfc_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'RFC ID' , 
	`rfc_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'RFC 이름' , 
	`admin_id` int(11) NOT NULL  COMMENT 'Admin ID' , 
	`user_id` int(11) NOT NULL  COMMENT 'User ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	`modify_date` datetime NULL  COMMENT '수정 일자' , 
	`is_del` varchar(4) COLLATE utf8mb4_general_ci NOT NULL  DEFAULT 'N' COMMENT '삭제여부' , 
	`del_date` datetime NULL  COMMENT '삭제 일자' , 
	PRIMARY KEY (`rfc_id`) , 
	KEY `nix-rfc-slave_id`(`user_id`) , 
	KEY `nix-rfc-rfc_name`(`rfc_name`) , 
	CONSTRAINT `fk-rfc-slave_id` 
	FOREIGN KEY (`user_id`) REFERENCES `account_slave` (`slave_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='RFC';


/* Create table in target */
CREATE TABLE `rfc_match`(
	`rfc_match_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'RFC_Match ID' , 
	`rfc_id` int(10) unsigned NOT NULL  COMMENT 'RFC ID' , 
	`bizunit_sno` int(10) unsigned NOT NULL  COMMENT 'Bizunit SNO' , 
	`revision_sno` int(10) unsigned NOT NULL  COMMENT 'Revision SNO' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	PRIMARY KEY (`rfc_match_id`) , 
	KEY `nix-rfc_match-rfc_id`(`rfc_id`) , 
	KEY `nix-rfc_match-revision_sno`(`revision_sno`) , 
	CONSTRAINT `fk-rfc_match-rfc_id` 
	FOREIGN KEY (`rfc_id`) REFERENCES `rfc` (`rfc_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='RFC Match';


/* Create table in target */
CREATE TABLE `storage`(
	`storage_id` int(10) NOT NULL  auto_increment COMMENT 'storage ID' , 
	`storage_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'storage 이름' , 
	`storage_description` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'storage 설명' , 
	`admin_id` int(11) NOT NULL  COMMENT 'Admin ID' , 
	`user_id` int(11) NOT NULL  COMMENT '소유자(slave_id)' , 
	`access_privilege` varchar(20) COLLATE utf8mb4_general_ci NULL  DEFAULT 'public' COMMENT '접근권한' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	`modify_date` datetime NULL  COMMENT '수정일' , 
	`is_del` varchar(4) COLLATE utf8mb4_general_ci NOT NULL  DEFAULT 'N' COMMENT '삭제여부' , 
	`del_date` datetime NULL  COMMENT '삭제일' , 
	PRIMARY KEY (`storage_id`) , 
	KEY `nix-slave-slave_id`(`user_id`) , 
	CONSTRAINT `fk-slave-storage` 
	FOREIGN KEY (`user_id`) REFERENCES `account_slave` (`slave_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='storage 기본 Table';


/* Create table in target */
CREATE TABLE `storage_detail`(
	`storage_detail_id` int(10) NOT NULL  auto_increment COMMENT 'storage_detail ID' , 
	`storage_id` int(10) NULL  COMMENT 'storage ID' , 
	`storage_detail_name` varchar(40) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'storage_detail 이름' , 
	`storage_detail_description` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'storage_detail 설명' , 
	`storage_type` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'storage DB 유형' , 
	`storage_version` varchar(12) COLLATE utf8mb4_general_ci NULL  COMMENT 'storage DB 버전' , 
	`storage_db_info` longblob NOT NULL  COMMENT 'storage DB 정보' , 
	`live_storage_db_info` longblob NULL  COMMENT 'storage 운영 DB 정보' , 
	`admin_id` int(11) NOT NULL  COMMENT 'Admin ID' , 
	`user_id` int(11) NOT NULL  COMMENT 'User ID' , 
	`access_privilege` varchar(20) COLLATE utf8mb4_general_ci NULL  DEFAULT 'public' COMMENT '접근권한' , 
	`ssl_use` enum('Y','N') COLLATE utf8mb4_general_ci NOT NULL  DEFAULT 'N' COMMENT 'SSL 사용 여부' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	`modify_date` datetime NULL  COMMENT '수정일' , 
	`is_del` varchar(4) COLLATE utf8mb4_general_ci NOT NULL  DEFAULT 'N' COMMENT '삭제여부' , 
	`del_date` datetime NULL  COMMENT '삭제일' , 
	PRIMARY KEY (`storage_detail_id`) , 
	KEY `nix-storage_detail-user_id`(`user_id`) , 
	CONSTRAINT `fk-slave-storage_detail` 
	FOREIGN KEY (`user_id`) REFERENCES `account_slave` (`slave_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='storage 상세 Table';


/* Create table in target */
CREATE TABLE `storage_detail_match`(
	`storage_detail_match_id` int(10) NOT NULL  auto_increment COMMENT 'Storage_detail match ID' , 
	`storage_detail_id` int(10) NULL  COMMENT 'Storage_detail ID' , 
	`bizunit_sno` int(10) unsigned NOT NULL  COMMENT '매칭 Bizunit SNO' , 
	`revision_sno` int(10) unsigned NOT NULL  COMMENT '매칭 Revision SNO' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	PRIMARY KEY (`storage_detail_match_id`) , 
	UNIQUE KEY `uix-storage_match-mix_id`(`storage_detail_id`,`revision_sno`) , 
	KEY `nix-storage-storage_detail_id`(`storage_detail_id`) , 
	KEY `nix-storage-revision_sno`(`revision_sno`) , 
	CONSTRAINT `fk-revision-storage_detail_match` 
	FOREIGN KEY (`revision_sno`) REFERENCES `revision` (`revision_sno`) , 
	CONSTRAINT `fk-storage-storage_detail_match` 
	FOREIGN KEY (`storage_detail_id`) REFERENCES `storage_detail` (`storage_detail_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='storage detail 매칭 정보';


/* Create table in target */
CREATE TABLE `storage_match`(
	`storage_match_id` int(10) NOT NULL  auto_increment COMMENT 'storage_match ID' , 
	`storage_id` int(10) NOT NULL  COMMENT 'storage ID' , 
	`app_id` int(10) unsigned NOT NULL  COMMENT '매칭 App ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	PRIMARY KEY (`storage_match_id`) , 
	UNIQUE KEY `uix-storage_match-mix_id`(`storage_id`,`app_id`) , 
	KEY `nix-storage-storage_id`(`storage_id`) , 
	KEY `nix-storage-app_id`(`app_id`) , 
	CONSTRAINT `fk-app-storage_match` 
	FOREIGN KEY (`app_id`) REFERENCES `app` (`app_id`) , 
	CONSTRAINT `fk-storage-storage_match` 
	FOREIGN KEY (`storage_id`) REFERENCES `storage` (`storage_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='storage 매칭 정보';


/* Create table in target */
CREATE TABLE `storage_ssl`(
	`storage_ssl_id` int(10) NOT NULL  auto_increment COMMENT 'storage_ssl ID' , 
	`storage_detail_id` int(10) NOT NULL  COMMENT 'storage_detail ID' , 
	`storage_ssl_ca_name` varchar(40) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'storage_ssl CA 이름' , 
	`storage_ssl_ca_path` varchar(200) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'storage_ssl CA 경로' , 
	`storage_ssl_live_ca_name` varchar(40) COLLATE utf8mb4_general_ci NULL  COMMENT 'storage_ssl Live CA 이름' , 
	`storage_ssl_live_ca_path` varchar(200) COLLATE utf8mb4_general_ci NULL  COMMENT 'storage_ssl Live CA 경로' , 
	`storage_ssl_cert_name` varchar(40) COLLATE utf8mb4_general_ci NULL  COMMENT 'storage_ssl Cert 이름' , 
	`storage_ssl_cert_path` varchar(200) COLLATE utf8mb4_general_ci NULL  COMMENT 'storage_ssl Cert 경로' , 
	`storage_ssl_live_cert_name` varchar(40) COLLATE utf8mb4_general_ci NULL  COMMENT 'storage_ssl Live Cert 이름' , 
	`storage_ssl_live_cert_path` varchar(200) COLLATE utf8mb4_general_ci NULL  COMMENT 'storage_ssl Live Cert 경로' , 
	`storage_ssl_key_name` varchar(40) COLLATE utf8mb4_general_ci NULL  COMMENT 'storage_ssl Key 이름' , 
	`storage_ssl_key_path` varchar(200) COLLATE utf8mb4_general_ci NULL  COMMENT 'storage_ssl Key 경로' , 
	`storage_ssl_live_key_name` varchar(40) COLLATE utf8mb4_general_ci NULL  COMMENT 'storage_ssl Live Key 이름' , 
	`storage_ssl_live_key_path` varchar(200) COLLATE utf8mb4_general_ci NULL  COMMENT 'storage_ssl Live Key 경로' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	`modify_date` datetime NULL  COMMENT '수정 일자' , 
	PRIMARY KEY (`storage_ssl_id`) , 
	UNIQUE KEY `uix-storage_ssl-storage_detail_id`(`storage_detail_id`) , 
	CONSTRAINT `fk-storage_ssl-storage_detail` 
	FOREIGN KEY (`storage_detail_id`) REFERENCES `storage_detail` (`storage_detail_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='storage SSL Table';


/* Create table in target */
CREATE TABLE `SYN_DB_VER_INFO`(
	`DB_VER` varchar(20) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'DB버전|싱크트리의 DB 버전||' , 
	`RLS_VER` varchar(50) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '릴리즈버전|공개된 버전||' , 
	`SYN_VER` varchar(30) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '싱크트리버전|싱크트리의 버전||' , 
	`REG_DTTM` datetime NOT NULL  DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시|등록된 일시|current_timestamp()|' , 
	PRIMARY KEY (`DB_VER`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='싱크트리DB버전정보|싱크트리DB버전정보||';


/* Create table in target */
CREATE TABLE `t_account_certification`(
	`certification_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '인증 ID' , 
	`action_type` varchar(10) COLLATE utf8mb4_general_ci NULL  COMMENT 'join : 가입 , passpharse : 비번 변경 , find : account 찾기' , 
	`account_type` varchar(10) COLLATE utf8mb4_general_ci NULL  COMMENT 'master, slave 둘중에 하나' , 
	`masterorslave` int(11) NOT NULL  COMMENT 'master_id, slave_id 둘중에 하나 들어옴' , 
	`status_code` tinyint(3) unsigned NOT NULL  COMMENT '상태 코드 (0=inactive, 1=active, 2=expired)' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	`modify_date` datetime NULL  COMMENT '수정일' , 
	PRIMARY KEY (`certification_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='계정 인증';


/* Create table in target */
CREATE TABLE `t_board_forum`(
	`boardid` bigint(20) NOT NULL  auto_increment COMMENT 'boardid' , 
	`slave_id` int(11) NOT NULL  COMMENT 'slave_id' , 
	`bcategory` tinyint(4) NOT NULL  , 
	`bwriter` varchar(50) COLLATE utf8_general_ci NOT NULL  COMMENT '글쓴이' , 
	`bemail` varchar(64) COLLATE utf8_general_ci NOT NULL  COMMENT '이메일' , 
	`bsubject` varchar(100) COLLATE utf8_general_ci NOT NULL  COMMENT '제목' , 
	`bcontents` text COLLATE utf8_general_ci NOT NULL  COMMENT '내용' , 
	`breads` int(3) NOT NULL  COMMENT '조회수' , 
	`bcommentcount` int(3) NOT NULL  COMMENT '댓글수' , 
	`reg_date` datetime NOT NULL  COMMENT '등록날짜' , 
	`mod_date` datetime NULL  COMMENT '수정날짜' , 
	PRIMARY KEY (`boardid`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8' COLLATE='utf8_general_ci' COMMENT='개발자 포럼';


/* Create table in target */
CREATE TABLE `t_board_forum_comment`(
	`boardcommentid` bigint(20) NOT NULL  auto_increment , 
	`slave_id` int(11) NULL  , 
	`boardid` bigint(20) NOT NULL  , 
	`bwriter` varchar(50) COLLATE utf8_general_ci NOT NULL  , 
	`bcontents` text COLLATE utf8_general_ci NOT NULL  , 
	`reg_date` datetime NOT NULL  , 
	PRIMARY KEY (`boardcommentid`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8' COLLATE='utf8_general_ci' COMMENT='개발자 포럼 댓글';


/* Create table in target */
CREATE TABLE `t_board_notice`(
	`boardid` bigint(20) NOT NULL  auto_increment COMMENT 'boardid' , 
	`slave_id` int(11) NULL  COMMENT 'slave_id' , 
	`bwriter` varchar(50) COLLATE utf8_general_ci NOT NULL  COMMENT '글쓴이' , 
	`bsubject` varchar(100) COLLATE utf8_general_ci NOT NULL  COMMENT '제목' , 
	`bcontents` text COLLATE utf8_general_ci NOT NULL  COMMENT '내용' , 
	`bimportant` tinyint(4) NOT NULL  COMMENT '1: 이면 중요. 0 이면 중요하지 않음' , 
	`breads` int(3) NOT NULL  COMMENT '조회수' , 
	`reg_date` datetime NOT NULL  COMMENT '등록날짜' , 
	`mod_date` datetime NULL  COMMENT '수정날짜' , 
	PRIMARY KEY (`boardid`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8' COLLATE='utf8_general_ci' COMMENT='공지사항 게시판';


/* Create table in target */
CREATE TABLE `t_center_info`(
	`increment` bigint(20) NOT NULL  auto_increment COMMENT 'idx' , 
	`slave_id` varchar(10) COLLATE utf8_general_ci NULL  COMMENT 'slave_id' , 
	`shard_no` int(11) NOT NULL  COMMENT 'shard 번호' , 
	`reg_date` datetime NOT NULL  COMMENT '등록일' , 
	PRIMARY KEY (`increment`) , 
	KEY `nix_index_agent_idx`(`slave_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8' COLLATE='utf8_general_ci' COMMENT='user shard 정보 매핑 테이블';


/* Create table in target */
CREATE TABLE `t_inquiry`(
	`inquiry_id` int(11) NOT NULL  auto_increment COMMENT 'inquiry_id' , 
	`master_id` int(11) NOT NULL  COMMENT 'master_id' , 
	`slave_id` int(11) NULL  COMMENT 'slave_id' , 
	`receive_email` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'receive_email' , 
	`inquiry_title` varchar(40) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'inquiry_title' , 
	`inquiry_content` text COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'inquiry_content' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	PRIMARY KEY (`inquiry_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='유저 문의 접수 팝업 DB Table';


/* Create table in target */
CREATE TABLE `t_payment_history`(
	`ph_sno` int(10) unsigned NOT NULL  auto_increment COMMENT '결제 내역 SNO' , 
	`master_id` int(11) NOT NULL  COMMENT 'Master ID' , 
	`product_sno` smallint(5) unsigned NOT NULL  COMMENT '상품 SNO' , 
	`ph_pgCompany` tinyint(3) unsigned NOT NULL  COMMENT 'PG 사 코드 (1=다날, 2=페이팔)' , 
	`ph_tid` varchar(24) COLLATE utf8mb4_general_ci NULL  COMMENT '거래 키' , 
	`ph_oid` varchar(255) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '주문번호' , 
	`ph_itemName` varchar(255) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '상품명' , 
	`ph_amount` int(10) unsigned NOT NULL  COMMENT '결제금액' , 
	`ph_currency` varchar(3) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '통화 코드 (USD, KRW)' , 
	`ph_statusCode` tinyint(3) unsigned NOT NULL  DEFAULT 0 COMMENT '결제 상태 코드 (0=요청, 1=완료, 2=실패)' , 
	`ph_returnCode` varchar(4) COLLATE utf8mb4_general_ci NULL  COMMENT 'PG사 결과 코드' , 
	`ph_returnMsg` varchar(255) COLLATE utf8mb4_general_ci NULL  COMMENT 'PG사 결과 메시지' , 
	`ph_regDate` datetime NOT NULL  COMMENT '등록일' , 
	`ph_modDate` datetime NULL  COMMENT '수정일' , 
	PRIMARY KEY (`ph_sno`) , 
	KEY `fk-payment_history-account_master`(`master_id`) , 
	KEY `fk-payment_history-product`(`product_sno`) , 
	KEY `nix-payment_history-pgCompany_oid`(`ph_pgCompany`,`ph_oid`) , 
	CONSTRAINT `fk-payment_history-account_master` 
	FOREIGN KEY (`master_id`) REFERENCES `account_master` (`master_id`) , 
	CONSTRAINT `fk-payment_history-product` 
	FOREIGN KEY (`product_sno`) REFERENCES `t_product` (`product_sno`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='결제 내역';


/* Create table in target */
CREATE TABLE `t_payment_info`(
	`pi_sno` int(10) unsigned NOT NULL  auto_increment COMMENT '결제 정보 SNO' , 
	`master_id` int(11) NOT NULL  COMMENT 'Master ID' , 
	`pi_pgCompany` tinyint(3) unsigned NOT NULL  COMMENT 'PG 사 코드 (1=다날, 2=페이팔)' , 
	`pi_billDay` tinyint(3) unsigned NOT NULL  DEFAULT 1 COMMENT '자동 결제일' , 
	`pi_billKey` varchar(255) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '자동 결제용 Key' , 
	`pi_cardCode` varchar(4) COLLATE utf8mb4_general_ci NULL  COMMENT '카드사 코드' , 
	`pi_cardName` varchar(25) COLLATE utf8mb4_general_ci NULL  COMMENT '카드사 명' , 
	`pi_cardNo` varchar(20) COLLATE utf8mb4_general_ci NULL  COMMENT '카드번호' , 
	`pi_email` varchar(64) COLLATE utf8mb4_general_ci NULL  COMMENT '결제자 이메일' , 
	`pi_statusCode` tinyint(3) unsigned NOT NULL  DEFAULT 1 COMMENT '구독 상태 코드 (1=구독 중, 2=구독 해지)' , 
	`pi_expDate` datetime NOT NULL  COMMENT '구독 만료일' , 
	`pi_regDate` datetime NOT NULL  DEFAULT CURRENT_TIMESTAMP COMMENT '등록일' , 
	`pi_modDate` datetime NULL  COMMENT '수정일' , 
	PRIMARY KEY (`pi_sno`) , 
	KEY `fk-payment_info-account_master`(`master_id`) , 
	CONSTRAINT `fk-payment_info-account_master` 
	FOREIGN KEY (`master_id`) REFERENCES `account_master` (`master_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='결제 정보';


/* Create table in target */
CREATE TABLE `t_product`(
	`product_sno` smallint(5) unsigned NOT NULL  auto_increment COMMENT '상품 SNO' , 
	`product_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '상품 이름' , 
	`product_tier` varchar(20) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '상품 구분' , 
	`product_price` int(10) unsigned NOT NULL  COMMENT '상품 가격 - USD/월' , 
	`product_price_krw` int(10) unsigned NOT NULL  COMMENT '상품 가격 - KRW/월' , 
	`paypal_plan_id` varchar(50) COLLATE utf8mb4_general_ci NULL  COMMENT 'PayPal Plan ID' , 
	`register_date` datetime NOT NULL  DEFAULT CURRENT_TIMESTAMP COMMENT '등록일' , 
	`modify_date` datetime NULL  COMMENT '수정일' , 
	PRIMARY KEY (`product_sno`) , 
	UNIQUE KEY `uix-t_product-name_tier`(`product_name`,`product_tier`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='상품';


/* Create table in target */
CREATE TABLE `t_product_limit`(
	`limit_sno` smallint(5) unsigned NOT NULL  auto_increment COMMENT '상품 제한 SNO' , 
	`product_sno` smallint(5) unsigned NOT NULL  COMMENT '상품 SNO' , 
	`limit_account` smallint(5) NOT NULL  COMMENT '계정 수 (-1=무제한)' , 
	`limit_guest` tinyint(3) unsigned NOT NULL  COMMENT 'Guest 추가 가능 여부 (0=불가, 1=가능)' , 
	`limit_call` int(10) NOT NULL  COMMENT 'Call 수/일 (-1=무제한)' , 
	`limit_tps` tinyint(3) NOT NULL  COMMENT 'TPS (-1=무제한)' , 
	`limit_nosql_key` smallint(5) NOT NULL  COMMENT 'NoSQL Key 수 (-1=무제한)' , 
	`limit_nosql_expiry` smallint(5) NOT NULL  COMMENT 'NoSQL 데이터 보관일 (-1=무제한)' , 
	PRIMARY KEY (`limit_sno`) , 
	KEY `fk-product-product_limit`(`product_sno`) , 
	CONSTRAINT `fk-product-product_limit` 
	FOREIGN KEY (`product_sno`) REFERENCES `t_product` (`product_sno`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='상품 제한';


/* Create table in target */
CREATE TABLE `t_shard_info`(
	`shard_idx` bigint(20) NOT NULL  auto_increment , 
	`connection_string` varchar(2000) COLLATE utf8_general_ci NOT NULL  , 
	`accum_value` int(11) NOT NULL  , 
	`ratio` int(11) NOT NULL  , 
	`reg_date` datetime NOT NULL  , 
	PRIMARY KEY (`shard_idx`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8' COLLATE='utf8_general_ci' COMMENT='shard 정보 테이블';


/* Create table in target */
CREATE TABLE `tally`(
	`n` smallint(5) unsigned NOT NULL  COMMENT '1 ~ 10,000 정수' , 
	PRIMARY KEY (`n`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='mutex 용도의 테이블';


/* Create table in target */
CREATE TABLE `usecase`(
	`usecase_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'usecase ID' , 
	`usecase_icon` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'usecase API icon' , 
	`usecase_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'usecase 이름' , 
	`usecase_description` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'usecase 설명' , 
	`usecase_info` text COLLATE utf8mb4_general_ci NULL  COMMENT 'usecase 상세 설명' , 
	`usecase_content` json NOT NULL  COMMENT 'usecase 내용' , 
	`plan_version` varchar(10) COLLATE utf8mb4_general_ci NULL  COMMENT '엔진 버전' , 
	PRIMARY KEY (`usecase_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='usecase 기본 Table';


/* Create table in target */
CREATE TABLE `usecase_save`(
	`usecase_save_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'usecase_save ID' , 
	`usecase_id` int(10) unsigned NOT NULL  COMMENT 'usecase ID' , 
	`usecase_save_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'usecase_save 이름' , 
	`usecase_save_description` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'usecase_save 설명' , 
	`usecase_save_content` json NOT NULL  COMMENT 'usecase_save 내용' , 
	`usecase_session_key` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'usecase session key' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	`modify_date` datetime NULL  COMMENT '수정일' , 
	PRIMARY KEY (`usecase_save_id`) , 
	UNIQUE KEY `uix-usecase_save-session_key`(`usecase_session_key`) , 
	KEY `fk-usecase-usecase_save`(`usecase_id`) , 
	CONSTRAINT `fk-usecase-usecase_save` 
	FOREIGN KEY (`usecase_id`) REFERENCES `usecase` (`usecase_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='usecase 사용자 저장 Table';


/*  Alter Procedure in target  */

DELIMITER $$
DROP PROCEDURE IF EXISTS `usp_add_user`$$
CREATE PROCEDURE `usp_add_user`(
      IN pi_vch_name VARCHAR(50)
    , IN pi_vch_email VARCHAR(64)
    , IN pi_vch_passphrase VARCHAR(32)
    , IN pi_dt5_now DATETIME
    , OUT po_int_return INT
)
    DETERMINISTIC
    COMMENT 'nauthor : 조규현 mail : jogyuhyeon@nntuple.com created date : 2022-04-12'
proc_body: BEGIN
    DECLARE v_vch_proc_name VARCHAR(100) DEFAULT 'usp_add_user';
    DECLARE v_iny_proc_step TINYINT UNSIGNED DEFAULT 0;
    DECLARE v_txt_call_stack MEDIUMTEXT;
    DECLARE v_bit_write_exception_log BOOLEAN DEFAULT FALSE;
    DECLARE v_vch_sql_state VARCHAR(5);
    DECLARE v_int_error_no INT;
    DECLARE v_txt_error_msg TEXT;
    
    
    DECLARE int_master_id INT(10);
    DECLARE int_master_account INT(10);
    DECLARE vch_master_account VARCHAR(20);
    DECLARE vch_crypt_key VARCHAR(64);
    DECLARE int_slave_id INT(10);
    DECLARE int_portal_list_id INT(10);
    


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

-- master 계정 생성
    SET v_iny_proc_step = 1;

	SET vch_crypt_key = '47ee9ea25f9f0e0de7b991e50df3448d';
	
	SET int_master_account = CONVERT(FLOOR(RAND()*10000000000), SIGNED);

	SET vch_master_account = (SELECT CASE WHEN int_master_account >= 1000000000 
					 THEN CAST(int_master_account AS CHAR)
					 ELSE CONCAT(0,CAST(int_master_account AS CHAR)) END);

	INSERT INTO account_master (master_account, master_division, master_name, master_email, master_passphrase, master_status_code, product_sno, register_date, modify_date, login_date) 
	VALUES (vch_master_account, 'enterprise', pi_vch_name, pi_vch_email, usf_hash_passphrase(vch_crypt_key, pi_vch_email, pi_vch_passphrase), 1, 2, pi_dt5_now, NULL, NULL);
	
	SELECT LAST_INSERT_ID() INTO int_master_id;
	

-- slave 계정 생성
    SET v_iny_proc_step = 2;
	
	INSERT INTO account_slave (slave_type, slave_name, slave_email, slave_passphrase, slave_expire_date, slave_status_code, slave_purpose, master_id, master_account, permission_group_id, register_date, modify_date, login_date) 
	VALUES (2, pi_vch_name, pi_vch_email, usf_hash_passphrase(vch_crypt_key, pi_vch_email, pi_vch_passphrase), NULL, 1, 0, int_master_id, vch_master_account, 1, pi_dt5_now, NULL, NULL);

	SELECT LAST_INSERT_ID() INTO int_slave_id;

-- 각 계정 권한 부여
    SET v_iny_proc_step = 3;
	INSERT INTO permission_have (slave_id, permission_id, register_date) 
	VALUES
	(int_slave_id, 1, pi_dt5_now),
	(int_slave_id, 2, pi_dt5_now),
	(int_slave_id, 3, pi_dt5_now),
	(int_slave_id, 4, pi_dt5_now),
	(int_slave_id, 5, pi_dt5_now),
	(int_slave_id, 6, pi_dt5_now),
	(int_slave_id, 7, pi_dt5_now),
	(int_slave_id, 8, pi_dt5_now),
	(int_slave_id, 9, pi_dt5_now),
	(int_slave_id, 10, pi_dt5_now),
	(int_slave_id, 11, pi_dt5_now),
	(int_slave_id, 12, pi_dt5_now),
	(int_slave_id, 13, pi_dt5_now),
	(int_slave_id, 14, pi_dt5_now),
	(int_slave_id, 15, pi_dt5_now),
	(int_slave_id, 16, pi_dt5_now),
	(int_slave_id, 17, pi_dt5_now),
	(int_slave_id, 18, pi_dt5_now),
	(int_slave_id, 19, pi_dt5_now),
	(int_slave_id, 20, pi_dt5_now),
	(int_slave_id, 21, pi_dt5_now),
	(int_slave_id, 22, pi_dt5_now);

-- 계정 Portal 생성
    SET v_iny_proc_step = 4;

	INSERT INTO synctree_portal.portal_list(portal_list_name, portal_list_description, portal_url, admin_id, register_date)
	VALUES ('Synctree-Portal','Portal',CONV(CONCAT(UNIX_TIMESTAMP(pi_dt5_now), LPAD(1, 5, '0')), 10, 16),int_master_id,pi_dt5_now);
	
	SELECT LAST_INSERT_ID() INTO int_portal_list_id;
	

	SELECT portal_url FROM synctree_portal.portal_list WHERE portal_list_id = int_portal_list_id;

COMMIT;


    SET po_int_return = 0;
END proc_body$$
DELIMITER ;


/*  Alter Procedure in target  */

DELIMITER $$
DROP PROCEDURE IF EXISTS `usp_batch_datainsert`$$
CREATE PROCEDURE `usp_batch_datainsert`(
      IN pi_int_revision_sno INT(10)
    , OUT po_int_return INT
)
    DETERMINISTIC
    COMMENT 'nauthor : 조규현 mail : jogyuhyeon@nntuple.com created date : 2021-10-01'
proc_body: BEGIN
    DECLARE v_vch_proc_name VARCHAR(100) DEFAULT 'usp_batch_datainsert';
    DECLARE v_iny_proc_step TINYINT UNSIGNED DEFAULT 0;
    DECLARE v_txt_call_stack MEDIUMTEXT;
    DECLARE v_bit_write_exception_log BOOLEAN DEFAULT FALSE;
    DECLARE v_vch_sql_state VARCHAR(5);
    DECLARE v_int_error_no INT;
    DECLARE v_txt_error_msg TEXT;
    
    
    DECLARE int_master_id int(10);
    DECLARE int_slave_id int(10);
    DECLARE int_app_id int(10);
    DECLARE int_bizunit_sno int(10);
    DECLARE int_bizunit_proxy_id int(10);
    DECLARE int_metrics_sno int(10);
    DECLARE int_batch_id int(10);
    DECLARE int_batch_match_id int(10);
    DECLARE int_dictionary_id int(10);
    DECLARE int_dictionary_detail_id int(10);
    DECLARE int_dictionary_match_id int(10);
    DECLARE int_storage_id int(10);
    DECLARE int_storage_detail_id int(10);
    DECLARE int_storage_match_id int(10);
    DECLARE int_query_sno int(10);
    DECLARE int_query_detail_id int(10);
    DECLARE int_query_match_id int(10);
    DECLARE vch_bizunit_id VARCHAR(64);
    DECLARE vch_revision_id VARCHAR(64);
    


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

DROP TEMPORARY TABLE IF EXISTS deploy_temp;

CREATE TEMPORARY TABLE deploy_temp(deploy_resource_sno int(10), deploy_table varchar(100));

/*
DROP TEMPORARY TABLE IF EXISTS deploy_temp_query;

CREATE TEMPORARY TABLE deploy_temp_query(deploy_query text);
*/
-- revision 데이터 insert 및 bizunit_sno 찾기
    SET v_iny_proc_step = 1;
	INSERT INTO deploy_temp(deploy_resource_sno, deploy_table)
	SELECT revision_sno AS deploy_resource_sno
	     , 'revision' AS deploy_table
	  FROM revision
	 WHERE revision_sno = pi_int_revision_sno;


	SELECT bizunit_sno INTO int_bizunit_sno
	  FROM revision
	 WHERE revision_sno = pi_int_revision_sno;

	SELECT revision_id INTO vch_revision_id
	  FROM revision
	 WHERE revision_sno = pi_int_revision_sno;


-- bizunit 데이터 insert 및 app_id 찾기
    SET v_iny_proc_step = 2;
	
	INSERT INTO deploy_temp(deploy_resource_sno, deploy_table)
	SELECT bizunit_sno AS deploy_resource_sno
	     , 'bizunit' AS deploy_table
	  FROM bizunit
	 WHERE bizunit_sno = int_bizunit_sno;
	 
	INSERT INTO deploy_temp(deploy_resource_sno, deploy_table)
	SELECT bizunit_proxy_id AS deploy_resource_sno
	     , 'bizunit_proxy' AS deploy_table
	  FROM bizunit_proxy
	 WHERE bizunit_sno = int_bizunit_sno;
	 
	INSERT INTO deploy_temp(deploy_resource_sno, deploy_table)
	SELECT operator_sno AS deploy_resource_sno
	     , 'operator' AS deploy_table
	  FROM operator
	 WHERE bizunit_sno = int_bizunit_sno
	   and revision_sno = pi_int_revision_sno;
	 	   
	SELECT app_id INTO int_app_id
	  FROM bizunit
	 WHERE bizunit_sno = int_bizunit_sno;
	 
	SELECT bizunit_id INTO vch_bizunit_id
	  FROM bizunit
	 WHERE bizunit_sno = int_bizunit_sno;


-- app 데이터 insert 및 account_slave 찾기
    SET v_iny_proc_step = 3;
	
	INSERT INTO deploy_temp(deploy_resource_sno, deploy_table)
	SELECT app_id AS deploy_resource_sno
	     , 'app' AS deploy_table
	  FROM app
	 WHERE app_id = int_app_id;
	 
	
	INSERT INTO deploy_temp(deploy_resource_sno, deploy_table)
	SELECT plan_sno AS deploy_resource_sno
	     , 'synctree_plan.t_plan' AS deploy_table
	  FROM synctree_plan.t_plan
	 WHERE bizunit_id = vch_bizunit_id
	   AND revision_id = vch_revision_id;
	 
	 
	SELECT user_id INTO int_slave_id
	FROM app
	WHERE app_id = int_app_id;


-- account 데이터 insert 및 데이터 찾기
    SET v_iny_proc_step = 4;
    
	INSERT INTO deploy_temp(deploy_resource_sno, deploy_table)
	SELECT slave_id AS deploy_resource_sno
	     , 'account_slave' AS deploy_table
	  FROM account_slave
	 WHERE slave_id = int_slave_id;
	 	 	 
	SELECT master_id INTO int_master_id
	FROM account_slave
	WHERE slave_id = int_slave_id;
	
	
	INSERT INTO deploy_temp(deploy_resource_sno, deploy_table)
	SELECT master_id AS deploy_resource_sno
	     , 'account_master' AS deploy_table
	  FROM account_master
	 WHERE master_id = int_master_id;
	

-- metrics 데이터 insert 및 데이터 찾기
    SET v_iny_proc_step = 5;

	INSERT INTO deploy_temp(deploy_resource_sno, deploy_table)
	SELECT metrics_sno AS deploy_resource_sno
	     , 'metrics' AS deploy_table
	  FROM metrics
	 WHERE user_id = int_slave_id;


-- batch 데이터 insert 및 데이터 찾기
    SET v_iny_proc_step = 6;

	INSERT INTO deploy_temp(deploy_resource_sno, deploy_table)
	SELECT batch_id AS deploy_resource_sno
	     , 'batch' AS deploy_table
	  FROM batch
	 WHERE user_id = int_slave_id;
	 
	INSERT INTO deploy_temp(deploy_resource_sno, deploy_table)
	SELECT batch_match_id AS deploy_resource_sno
	     , 'batch_match' AS deploy_table
	  FROM batch_match
	 WHERE batch_id in (select deploy_resource_sno from deploy_temp where deploy_table = 'batch');
	 

-- dictionary 데이터 insert 및 데이터 찾기
    SET v_iny_proc_step = 7;

	INSERT INTO deploy_temp(deploy_resource_sno, deploy_table)
	SELECT dictionary_id AS deploy_resource_sno
	     , 'dictionary' AS deploy_table
	  FROM dictionary
	 WHERE user_id = int_slave_id;
	 	
	INSERT INTO deploy_temp(deploy_resource_sno, deploy_table)
	SELECT dictionary_detail_id AS deploy_resource_sno
	     , 'dictionary_detail' AS deploy_table
	  FROM dictionary_detail
	 WHERE dictionary_id in (SELECT deploy_resource_sno FROM deploy_temp WHERE deploy_table = 'dictionary');
	 
	INSERT INTO deploy_temp(deploy_resource_sno, deploy_table)
	SELECT dictionary_match_id AS deploy_resource_sno
	     , 'dictionary_match' AS deploy_table
	  FROM dictionary_match
	 WHERE dictionary_id in (SELECT deploy_resource_sno FROM deploy_temp WHERE deploy_table = 'dictionary')
	   and app_id = int_app_id;
	   


-- storage 데이터 insert 및 데이터 찾기
    SET v_iny_proc_step = 8;

	INSERT INTO deploy_temp(deploy_resource_sno, deploy_table)
	SELECT storage_id AS deploy_resource_sno
	     , 'storage' AS deploy_table
	  FROM `storage`
	 WHERE user_id = int_slave_id;
	 
	
	INSERT INTO deploy_temp(deploy_resource_sno, deploy_table)
	SELECT storage_match_id AS deploy_resource_sno
	     , 'storage_match' AS deploy_table
	  FROM storage_match
	 WHERE storage_id in (SELECT deploy_resource_sno FROM deploy_temp WHERE deploy_table = 'storage')
	   AND app_id = int_app_id;
	   
	INSERT INTO deploy_temp(deploy_resource_sno, deploy_table)
	SELECT storage_detail_id AS deploy_resource_sno
	     , 'storage_detail' AS deploy_table
	  FROM storage_detail
	 WHERE storage_id IN (SELECT deploy_resource_sno FROM deploy_temp WHERE deploy_table = 'storage');


-- query manager 데이터 insert 및 데이터 찾기
    SET v_iny_proc_step = 9;

	INSERT INTO deploy_temp(deploy_resource_sno, deploy_table)
	SELECT query_sno AS deploy_resource_sno
	     , 'query_manager' AS deploy_table
	  FROM query_manager
	 WHERE user_id = int_slave_id;
	  		   
	INSERT INTO deploy_temp(deploy_resource_sno, deploy_table)
	SELECT query_detail_id AS deploy_resource_sno
	     , 'query_manager_detail' AS deploy_table
	  FROM query_manager_detail
	 WHERE query_sno IN (SELECT deploy_resource_sno FROM deploy_temp WHERE deploy_table = 'query_manager');

	INSERT INTO deploy_temp(deploy_resource_sno, deploy_table)
	SELECT query_match_id AS deploy_resource_sno
	     , 'query_manager_match' AS deploy_table
	  FROM query_manager_match
	 WHERE query_detail_id IN (SELECT deploy_resource_sno FROM deploy_temp WHERE deploy_table = 'query_manager_detail');
/*	   AND bizunit_sno = int_bizunit_sno
	   and revision_sno = int_revision_sno;
*/	   	 

SELECT * FROM deploy_temp;

COMMIT;


    SET po_int_return = 0;
END proc_body$$
DELIMITER ;


/*  Alter Procedure in target  */

DELIMITER $$
DROP PROCEDURE IF EXISTS `usp_portal_proxy_log_test`$$
CREATE PROCEDURE `usp_portal_proxy_log_test`(
      IN pi_int_bizunit_sno INT(10)
    , IN pi_dt5_now DATETIME(0)
    , OUT po_int_return INT
)
    DETERMINISTIC
    COMMENT 'nauthor : 조규현 mail : jogyuhyeon@nntuple.com created date : 2021-06-24'
proc_body: BEGIN
    DECLARE v_vch_proc_name VARCHAR(100) DEFAULT 'usp_portal_proxy_log_test';
    DECLARE v_iny_proc_step TINYINT UNSIGNED DEFAULT 0;
    DECLARE v_txt_call_stack MEDIUMTEXT;
    DECLARE v_bit_write_exception_log BOOLEAN DEFAULT FALSE;
    DECLARE v_vch_sql_state VARCHAR(5);
    DECLARE v_int_error_no INT;
    DECLARE v_txt_error_msg TEXT;
    
    DECLARE v_int_bizunit_proxy_id INT(10);
    DECLARE v_int_bizunit_sno INT(10);
    DECLARE v_vch_bizunit_id VARCHAR(64);
    DECLARE v_vch_bizunit_version VARCHAR(12);
    DECLARE v_int_revision_sno INT(10);
    DECLARE v_vch_revision_id VARCHAR(64);
    DECLARE v_vch_revision_environment VARCHAR(10);
    DECLARE v_idx INT(10);
        

    DECLARE CONTINUE HANDLER FOR NOT FOUND BEGIN END;
    DECLARE CONTINUE HANDLER FOR SQLWARNING BEGIN END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_vch_sql_state = RETURNED_SQLSTATE
            , v_int_error_no = MYSQL_ERRNO
            , v_txt_error_msg = MESSAGE_TEXT;

        ROLLBACK;

    END;

-- Test Data create
    SET v_iny_proc_step = 1;	
    
	SELECT bizunit_proxy_id 
	  INTO v_int_bizunit_proxy_id
  	  FROM synctree_studio.bizunit_proxy 
	 WHERE bizunit_sno = pi_int_bizunit_sno;
	
	
	SELECT bizunit_sno
	     , bizunit_id
	     , bizunit_version
	  INTO v_int_bizunit_sno
	     , v_vch_bizunit_id
	     , v_vch_bizunit_version
	  FROM bizunit
	 WHERE bizunit_sno = pi_int_bizunit_sno;

	
	SELECT revision_sno
	     , revision_id
	     , revision_environment
	  INTO v_int_revision_sno
	     , v_vch_revision_id
	     , v_vch_revision_environment
	  FROM revision
	 WHERE bizunit_sno = pi_int_bizunit_sno
	   AND revision_environment = 'production';
	   
-- Test Data insert 
    SET v_iny_proc_step = 2;
	
    SET v_idx = 0;
    
	WHILE v_idx <= 1 DO
	
	-- INSERT INTO synctree_studio_logdb.proxy_api_log(bizunit_proxy_id, bizunit_sno, bizunit_id, bizunit_version, revision_sno, revision_id, revision_environment, latency, size, response_status, register_date, timestamp_date)
	SELECT v_int_bizunit_proxy_id, v_int_bizunit_sno, v_vch_bizunit_id, v_vch_bizunit_version, v_int_revision_sno, v_vch_revision_id, v_vch_revision_environment, CONVERT(ROUND(RAND() * 1.000 + 0.001, 3), DECIMAL(9,3)), CAST(RAND() * 100 AS SIGNED), 200, pi_dt5_now, pi_dt5_now;
	
	SET v_idx = v_idx+1;
	
	END WHILE;

-- Test Data insert 
    SET v_iny_proc_step = 3;
	
    SET v_idx = 0;
    
	WHILE v_idx <= 1 DO
	
	-- INSERT INTO synctree_studio_logdb.proxy_api_log(bizunit_proxy_id, bizunit_sno, bizunit_id, bizunit_version, revision_sno, revision_id, revision_environment, latency, size, response_status, register_date, timestamp_date)
	SELECT v_int_bizunit_proxy_id, v_int_bizunit_sno, v_vch_bizunit_id, v_vch_bizunit_version, v_int_revision_sno, v_vch_revision_id, v_vch_revision_environment, CONVERT(ROUND(RAND() * 1.000 + 0.001, 3), DECIMAL(9,3)), CAST(RAND() * 100 AS SIGNED), 500, pi_dt5_now, pi_dt5_now;

	SET v_idx = v_idx+1;
	
	END WHILE;

    SET po_int_return = 0;
END proc_body$$
DELIMITER ;


/*  Create Function in target  */

DELIMITER $$
CREATE FUNCTION `usf_data_encryption`(
      pi_vch_value	VARBINARY(10240)
    , pi_vch_record_key	VARCHAR(64)
) RETURNS varbinary(10240)
    DETERMINISTIC
    COMMENT 'author : 조규현 / e-mail : jogyuhyeon@nntuple.com / created date : 2020-09-22 / description : data 암호화 함수'
BEGIN
    DECLARE v_bin_return VARBINARY(10240);

    SET v_bin_return = AES_ENCRYPT(pi_vch_value, UNHEX(SHA2(pi_vch_record_key, 512)));

    RETURN v_bin_return;
END$$
DELIMITER ;


/*  Alter Function in target  */

DELIMITER $$
DROP FUNCTION IF EXISTS `usf_hash_passphrase`$$
CREATE FUNCTION `usf_hash_passphrase`(
      pi_vch_salt_value varchar(64) 
    , pi_vch_record_key varchar(50) 
    , pi_vch_passphrase varchar(50) 
) RETURNS binary(32)
    DETERMINISTIC
    COMMENT '\r\nauthor : 김도열\r\ne-mail : purumae@nntuple.com\r\ncreated date : 2017-11-22\r\ndescription : 패스워드를 Hash합니다.\r\nparameter :\r\n      pi_vch_salt_value varchar(64) -- SALT 값\r\n    , pi_vch_record_key varchar(50) -- 행 식별자\r\n    , pi_vch_passphrase varchar(50) -- 패스워드의 평문\r\nusage :\r\n    SELECT usf_hash_passphrase("39aff09b-cf29-11e7-b9c9-f44d30abc64c", "purumae@nntuple.com", "1234");\r\n'
BEGIN
    DECLARE v_bin_return binary(32);

    SET v_bin_return = UNHEX(SHA2(CONCAT(pi_vch_salt_value, pi_vch_record_key, pi_vch_passphrase), 256));

    RETURN v_bin_return;
END$$
DELIMITER ;


/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;

