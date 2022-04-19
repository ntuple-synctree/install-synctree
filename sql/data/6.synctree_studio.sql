/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

USE `synctree_studio`;

/* Create table in target */
CREATE TABLE `account_corporation`(
	`corporation_id` smallint(5) unsigned NOT NULL  auto_increment COMMENT '법인 ID' , 
	`master_id` smallint(5) unsigned NOT NULL  COMMENT 'Master ID' , 
	`business_number` varchar(20) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '사업자 번호' , 
	PRIMARY KEY (`corporation_id`) , 
	KEY `fk-master-corporation`(`master_id`) , 
	CONSTRAINT `fk-master-corporation` 
	FOREIGN KEY (`master_id`) REFERENCES `account_master` (`master_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='계정 법인';


/* Create table in target */
CREATE TABLE `account_master`(
	`master_id` smallint(5) unsigned NOT NULL  auto_increment COMMENT 'Admin ID' , 
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
	`slave_id` smallint(5) unsigned NOT NULL  auto_increment COMMENT 'User ID' , 
	`slave_type` tinyint(3) unsigned NOT NULL  DEFAULT 1 COMMENT 'User 유형 (0=Temporary, 1=Slave, 2=Root)' , 
	`slave_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'User 이름' , 
	`slave_email` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'User 이메일' , 
	`slave_passphrase` binary(32) NOT NULL  COMMENT 'User 로그인 비밀번호' , 
	`slave_expire_date` datetime NULL  COMMENT 'User 유효 기간' , 
	`slave_status_code` tinyint(3) unsigned NOT NULL  COMMENT 'User 상태 코드 (0=inactive, 1=active, 2=deactivated)' , 
	`slave_purpose` tinyint(3) unsigned NOT NULL  DEFAULT 0 COMMENT 'User 용도 (0=normal, 1=official)' , 
	`master_id` smallint(5) unsigned NOT NULL  COMMENT 'Admin ID' , 
	`master_account` varchar(10) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '계정 번호' , 
	`permission_group_id` int(10) unsigned NOT NULL  DEFAULT 0 COMMENT '권한 그룹 ID' , 
	`register_date` datetime NOT NULL  COMMENT '등록일자' , 
	`modify_date` datetime NULL  COMMENT '수정일자' , 
	`login_date` datetime NULL  COMMENT '로그인 일자' , 
	PRIMARY KEY (`slave_id`) , 
	UNIQUE KEY `uix-account_slave-slave_email`(`slave_email`) , 
	KEY `nix-slave-master_id`(`master_id`) , 
	CONSTRAINT `fk-master-slave` 
	FOREIGN KEY (`master_id`) REFERENCES `account_master` (`master_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='계정 User';


/* Create table in target */
CREATE TABLE `app`(
	`app_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'App ID' , 
	`app_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'App 이름' , 
	`app_description` varchar(1000) COLLATE utf8mb4_general_ci NULL  COMMENT 'App 설명' , 
	`admin_id` smallint(5) unsigned NOT NULL  COMMENT 'Admin ID' , 
	`user_id` smallint(5) unsigned NOT NULL  COMMENT 'User ID' , 
	`access_privilege` varchar(20) COLLATE utf8mb4_general_ci NULL  DEFAULT 'public' COMMENT '접근권한' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	`modify_date` datetime NULL  COMMENT '수정 일자' , 
	PRIMARY KEY (`app_id`) , 
	KEY `nix-account_slave-slave_id`(`user_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='App';


/* Create table in target */
CREATE TABLE `batch`(
	`batch_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Batch ID' , 
	`batch_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Batch 이름' , 
	`batch_description` text COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Batch 설명' , 
	`batch_content` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Batch 내용' , 
	`admin_id` smallint(5) NOT NULL  COMMENT 'Admin ID' , 
	`user_id` smallint(5) unsigned NOT NULL  COMMENT 'User ID' , 
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
	`admin_id` smallint(5) unsigned NOT NULL  COMMENT 'Admin ID' , 
	`user_id` smallint(5) unsigned NOT NULL  COMMENT 'User ID' , 
	`access_privilege` varchar(20) COLLATE utf8mb4_general_ci NULL  DEFAULT 'public' COMMENT '접근권한' , 
	`register_date` datetime NOT NULL  COMMENT '등록 일자' , 
	`modify_date` datetime NULL  COMMENT '수정 일자' , 
	PRIMARY KEY (`bizunit_sno`) , 
	UNIQUE KEY `uix-bizunit-bizunit_id`(`bizunit_id`,`bizunit_version`) , 
	KEY `nix-bizunit-app_id`(`app_id`) , 
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
	`user_id` smallint(5) NOT NULL  DEFAULT 0 COMMENT 'User ID' , 
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
	`admin_id` smallint(5) unsigned NOT NULL  COMMENT 'Admin ID' , 
	`user_id` smallint(5) unsigned NOT NULL  COMMENT 'User Id' , 
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
	`admin_id` smallint(5) unsigned NOT NULL  COMMENT 'Admin ID' , 
	`user_id` smallint(5) unsigned NOT NULL  COMMENT 'User ID' , 
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
	`admin_id` smallint(5) unsigned NOT NULL  COMMENT 'Admin ID' , 
	`user_id` smallint(5) unsigned NOT NULL  COMMENT 'User ID' , 
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
	`dictionary_type` tinyint(3) NOT NULL  COMMENT 'dictionary 타입(10 : Config / 20 : Secret)' , 
	`key_name` varchar(40) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Key 값' , 
	`dictionary_detail_description` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'dictionary_detail 설명' , 
	`key_value` json NOT NULL  COMMENT 'Key_Value값' , 
	`live_key_value` json NULL  COMMENT '운영 Key_Value값' , 
	`admin_id` smallint(5) unsigned NOT NULL  COMMENT 'Admin ID' , 
	`user_id` smallint(5) unsigned NOT NULL  COMMENT 'User ID' , 
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
	`source_slave_id` smallint(5) unsigned NOT NULL  COMMENT '출처 Slave ID' , 
	`source_library_id` varchar(64) COLLATE utf8mb4_general_ci NULL  COMMENT '출처 Library ID' , 
	`register_account` smallint(5) unsigned NOT NULL  COMMENT '등록자 (Slave ID)' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	`modify_date` datetime NULL  COMMENT '수정일' , 
	PRIMARY KEY (`library_sno`) , 
	UNIQUE KEY `uix-library-library_id`(`library_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Library';


/* Create table in target */
CREATE TABLE `library_group`(
	`group_id` int(10) unsigned NOT NULL  auto_increment COMMENT 'Library 그룹 ID' , 
	`group_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Library 그룹 이름' , 
	`source_slave_id` smallint(5) unsigned NULL  COMMENT '출처 Slave ID' , 
	`register_account` smallint(5) unsigned NOT NULL  COMMENT '등록자 (Slave ID)' , 
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
	`user_id` smallint(5) unsigned NOT NULL  COMMENT 'User ID' , 
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
	`update_user_id` smallint(5) unsigned NOT NULL  COMMENT '수정자 User ID' , 
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
	`slave_id` smallint(5) unsigned NOT NULL  COMMENT 'Slave ID' , 
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
	`user_id` smallint(5) unsigned NOT NULL  COMMENT 'User ID' , 
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
	`admin_id` smallint(5) unsigned NOT NULL  COMMENT 'Admin ID' , 
	`user_id` smallint(5) unsigned NOT NULL  COMMENT 'User ID' , 
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
	`register_account` smallint(5) unsigned NOT NULL  COMMENT '등록자 (Slave ID)' , 
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
	`slave_id` smallint(5) unsigned NOT NULL  COMMENT 'Slave ID' , 
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
CREATE TABLE `storage`(
	`storage_id` int(10) NOT NULL  auto_increment COMMENT 'storage ID' , 
	`storage_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'storage 이름' , 
	`storage_description` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'storage 설명' , 
	`admin_id` smallint(5) unsigned NOT NULL  COMMENT 'Admin ID' , 
	`user_id` smallint(5) unsigned NOT NULL  COMMENT '소유자(slave_id)' , 
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
	`admin_id` smallint(5) unsigned NOT NULL  COMMENT 'Admin ID' , 
	`user_id` smallint(5) unsigned NOT NULL  COMMENT 'User ID' , 
	`access_privilege` varchar(20) COLLATE utf8mb4_general_ci NULL  DEFAULT 'public' COMMENT '접근권한' , 
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
CREATE TABLE `storage_detail_inside`(
	`storage_detail_id` int(10) NOT NULL  auto_increment COMMENT 'storage_detail ID' , 
	`storage_id` int(10) NOT NULL  COMMENT 'storage ID' , 
	`storage_detail_name` varchar(40) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'storage_detail 이름' , 
	`storage_detail_description` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'storage_detail 설명' , 
	`storage_type` varchar(100) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'storage DB 유형' , 
	`storage_version` varchar(12) COLLATE utf8mb4_general_ci NULL  COMMENT 'storage DB 버전' , 
	`storage_db_info` longblob NOT NULL  COMMENT 'storage DB 정보' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	`modify_date` datetime NULL  COMMENT '수정일' , 
	`is_del` varchar(4) COLLATE utf8mb4_general_ci NOT NULL  DEFAULT 'N' COMMENT '삭제여부' , 
	`del_date` datetime NULL  COMMENT '삭제일' , 
	PRIMARY KEY (`storage_detail_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='storage 상세 Table (내부용)';


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
CREATE TABLE `t_account_certification`(
	`certification_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '인증 ID' , 
	`action_type` varchar(10) COLLATE utf8mb4_general_ci NULL  COMMENT 'join : 가입 , passpharse : 비번 변경 , find : account 찾기' , 
	`account_type` varchar(10) COLLATE utf8mb4_general_ci NULL  COMMENT 'master, slave 둘중에 하나' , 
	`masterorslave` smallint(5) unsigned NOT NULL  COMMENT 'master_id, slave_id 둘중에 하나 들어옴' , 
	`status_code` tinyint(3) unsigned NOT NULL  COMMENT '상태 코드 (0=inactive, 1=active, 2=expired)' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	`modify_date` datetime NULL  COMMENT '수정일' , 
	PRIMARY KEY (`certification_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='계정 인증';


/* Create table in target */
CREATE TABLE `t_board_forum`(
	`boardid` bigint(20) NOT NULL  auto_increment COMMENT 'boardid' , 
	`slave_id` smallint(5) NOT NULL  COMMENT 'slave_id' , 
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
	`slave_id` smallint(5) NULL  , 
	`boardid` bigint(20) NOT NULL  , 
	`bwriter` varchar(50) COLLATE utf8_general_ci NOT NULL  , 
	`bcontents` text COLLATE utf8_general_ci NOT NULL  , 
	`reg_date` datetime NOT NULL  , 
	PRIMARY KEY (`boardcommentid`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8' COLLATE='utf8_general_ci' COMMENT='개발자 포럼 댓글';


/* Create table in target */
CREATE TABLE `t_board_notice`(
	`boardid` bigint(20) NOT NULL  auto_increment COMMENT 'boardid' , 
	`slave_id` smallint(5) NULL  COMMENT 'slave_id' , 
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
	`master_id` smallint(5) unsigned NOT NULL  COMMENT 'master_id' , 
	`slave_id` smallint(5) NULL  COMMENT 'slave_id' , 
	`receive_email` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'receive_email' , 
	`inquiry_title` varchar(40) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'inquiry_title' , 
	`inquiry_content` text COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'inquiry_content' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	PRIMARY KEY (`inquiry_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='유저 문의 접수 팝업 DB Table';


/* Create table in target */
CREATE TABLE `t_payment_history`(
	`ph_sno` int(10) unsigned NOT NULL  auto_increment COMMENT '결제 내역 SNO' , 
	`master_id` smallint(5) unsigned NOT NULL  COMMENT 'Master ID' , 
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
	`master_id` smallint(5) unsigned NOT NULL  COMMENT 'Master ID' , 
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

/*  Create Function in target  */

DELIMITER $$
CREATE DEFINER=`admin`@`%` FUNCTION `usf_data_encryption`(
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


/*  Create Function in target  */

DELIMITER $$
CREATE DEFINER=`admin`@`%` FUNCTION `usf_hash_passphrase`(
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