/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

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
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
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
CREATE TABLE `deploy_resource`(
	`deploy_resource_id` int(10) NOT NULL  auto_increment COMMENT 'Deploy Resource ID' , 
	`deploy_id` int(10) NOT NULL  COMMENT 'Deploy ID' , 
	`deploy_resource_type` varchar(30) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '배포요청 리소스 항목' , 
	`deploy_resource_sno` int(10) NOT NULL  COMMENT '배포요청 리소스 idx(sno) 값' , 
	`deploy_resource_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '배포요청 리소스 이름' , 
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
	`portal_account_role` tinyint(3) NOT NULL  DEFAULT 1 COMMENT 'Portal_account 역할(0: Administrator / 1: User)' , 
	`portal_account_status_code` tinyint(3) unsigned NOT NULL  COMMENT 'Portal_account 상태 코드 (0=inactive, 1=active)' , 
	`portal_list_id` int(10) unsigned NOT NULL  COMMENT 'Portal_List ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	`modify_date` datetime NULL  COMMENT '수정일자' , 
	`login_date` datetime NULL  COMMENT '로그인 일자' , 
	PRIMARY KEY (`portal_account_id`) , 
	KEY `nix-potal_account-portal_list_id`(`portal_list_id`) , 
	CONSTRAINT `fk-potal_list-portal_account` 
	FOREIGN KEY (`portal_list_id`) REFERENCES `portal_list` (`portal_list_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Portal 계정정보';


/* Create table in target */
CREATE TABLE `portal_api`(
	`portal_api_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Portal_api ID' , 
	`portal_api_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Portal_api 이름' , 
	`portal_api_display_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Portal_api Display 이름' , 
	`portal_api_description` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Portal_api 설명' , 
	`portal_list_id` int(10) unsigned NOT NULL  COMMENT 'Portal_List ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	`modify_date` datetime NULL  COMMENT '수정일자' , 
	PRIMARY KEY (`portal_api_id`) , 
	KEY `nix-portal_api-portal_list_id`(`portal_list_id`) , 
	CONSTRAINT `fk-portal_list-portal_api` 
	FOREIGN KEY (`portal_list_id`) REFERENCES `portal_list` (`portal_list_id`) 
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
	`admin_id` smallint(5) unsigned NOT NULL  COMMENT 'Admin ID' , 
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
	`user_id` smallint(5) NOT NULL  COMMENT 'User ID' , 
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
CREATE DEFINER=`admin`@`%` FUNCTION `usf_hash_passphrase`(
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


/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;