/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

USE `synctree_studio_logdb`;

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
CREATE TABLE `BIL_PRD_USE_HIST`(
	`PAY_USER_ID` int(11) NOT NULL  COMMENT '결제사용자ID|결제 사용자의 ID|synctree_studio.account_master.master_id|' , 
	`REG_DTTM` datetime(4) NOT NULL  COMMENT '등록일시|등록된 일시, MS의 4자리 까지 기록||' , 
	`revision_sno` int(11) NOT NULL  COMMENT 'revision_sno|revision_sno|synctree_studio.revision.revision_sno|' , 
	`USE_CNT` int(11) NOT NULL  COMMENT '사용횟수|사용된 횟수, 1M 이상일 경우 올림처리 1.2M -> 2||' , 
	`REG_IP` int(11) unsigned NOT NULL  DEFAULT 2130706433 COMMENT '등록IP|등록자의 IP|INET_ATON(127.0.0.1) INET_NTOA(3520061480)|' , 
	PRIMARY KEY (`PAY_USER_ID`,`REG_DTTM`,`revision_sno`) , 
	KEY `BIL_PRD_USE_HIST_X01`(`REG_DTTM`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='빌링상품사용이력|빌링상품사용이력||';


/* Create table in target */
CREATE TABLE `BIL_PRD_USE_HIST_OLD`(
	`PAY_USER_ID` int(11) NOT NULL  COMMENT '결제사용자ID|결제 사용자의 ID|synctree_studio.account_master.master_id|' , 
	`REG_DTTM` datetime(4) NOT NULL  COMMENT '등록일시|등록된 일시, MS의 4자리 까지 기록||' , 
	`revision_sno` int(11) NOT NULL  COMMENT 'revision_sno|revision_sno|synctree_studio.revision.revision_sno|' , 
	`USE_CNT` int(11) NOT NULL  COMMENT '사용횟수|사용된 횟수, 1M 이상일 경우 올림처리 1.2M -> 2||' , 
	`REG_IP` int(11) unsigned NOT NULL  DEFAULT 2130706433 COMMENT '등록IP|등록자의 IP|INET_ATON(127.0.0.1) INET_NTOA(3520061480)|' , 
	PRIMARY KEY (`PAY_USER_ID`,`REG_DTTM`,`revision_sno`) , 
	KEY `BIL_PRD_USE_HIST_X01`(`REG_DTTM`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='빌링상품사용이력|빌링상품사용이력||';


/* Create table in target */
CREATE TABLE `proxy_api_log`(
	`proxy_api_log_id` bigint(20) unsigned NOT NULL  auto_increment COMMENT 'Proxy API Log ID' , 
	`portal_app_id` int(10) NULL  COMMENT 'Portal App ID' , 
	`bizunit_proxy_id` int(10) NOT NULL  COMMENT 'Bizunit_proxy ID' , 
	`bizunit_sno` int(10) NOT NULL  COMMENT 'Bizunit SNO' , 
	`bizunit_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Bizunit ID' , 
	`bizunit_version` varchar(12) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Bizunit Version' , 
	`revision_sno` int(10) NOT NULL  COMMENT 'Revision Sno' , 
	`revision_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Revision Id' , 
	`revision_environment` varchar(10) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Revision 환경 (dev, feature, stage, production, hotfix)' , 
	`latency` decimal(9,3) NOT NULL  COMMENT 'latency' , 
	`size` int(10) NOT NULL  COMMENT 'size' , 
	`response_status` int(3) NOT NULL  COMMENT '응답 코드' , 
	`transaction_key` char(32) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'transaction_key' , 
	`register_date` datetime NOT NULL  COMMENT '등록일' , 
	`timestamp_date` timestamp NOT NULL  DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP COMMENT '서버시간' , 
	PRIMARY KEY (`proxy_api_log_id`) , 
	KEY `nix-proxy_api_log-bizunit_proxy_id`(`bizunit_proxy_id`) , 
	KEY `nix-proxy_api_log-monitoring`(`bizunit_proxy_id`,`timestamp_date`,`latency`) , 
	KEY `nix-proxy_api_log-register_date`(`register_date`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Proxy API Log 적재 테이블';


/* Create table in target */
CREATE TABLE `t_api_log`(
	`log_id` bigint(20) unsigned NOT NULL  auto_increment COMMENT 'log_id' , 
	`master_id` int(11) unsigned NOT NULL  COMMENT 'master_id' , 
	`slave_id` int(11) unsigned NULL  COMMENT 'slave_id' , 
	`bizunit_sno` int(10) NULL  COMMENT 'BizunitSNO' , 
	`bizunit_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'BizunitID' , 
	`bizunit_version` varchar(12) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Bizunit version' , 
	`revision_sno` int(10) NULL  COMMENT 'revision-sno' , 
	`revision_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'revision-id' , 
	`environment` varchar(10) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '환경' , 
	`latency` decimal(9,3) NOT NULL  COMMENT 'latency' , 
	`size` int(10) NOT NULL  COMMENT 'size' , 
	`response_status` int(3) NOT NULL  COMMENT 'size' , 
	`regdate` datetime NOT NULL  COMMENT '서버시간' , 
	PRIMARY KEY (`log_id`) , 
	KEY `nix_t_api_log_01`(`revision_sno`) , 
	KEY `nix-t_api_log-regdate`(`regdate`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='t_api_log 테이블';


/* Create table in target */
CREATE TABLE `t_api_log_back`(
	`log_id` bigint(20) unsigned NOT NULL  DEFAULT 0 COMMENT 'log_id' , 
	`master_id` int(11) unsigned NOT NULL  COMMENT 'master_id' , 
	`slave_id` int(11) unsigned NULL  COMMENT 'slave_id' , 
	`bizunit_sno` int(10) NULL  COMMENT 'BizunitSNO' , 
	`bizunit_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'BizunitID' , 
	`bizunit_version` varchar(12) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'Bizunit version' , 
	`revision_sno` int(10) NULL  COMMENT 'revision-sno' , 
	`revision_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'revision-id' , 
	`environment` varchar(10) COLLATE utf8mb4_general_ci NOT NULL  COMMENT '환경' , 
	`latency` decimal(9,3) NOT NULL  COMMENT 'latency' , 
	`size` int(10) NOT NULL  COMMENT 'size' , 
	`response_status` int(3) NOT NULL  COMMENT 'size' , 
	`regdate` datetime NOT NULL  COMMENT '서버시간' 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci';


/* Create table in target */
CREATE TABLE `t_console_log`(
	`log_id` bigint(20) unsigned NOT NULL  auto_increment COMMENT 'log_id' , 
	`master_id` int(11) unsigned NOT NULL  COMMENT 'master-id' , 
	`slave_id` int(11) unsigned NOT NULL  COMMENT 'slave_id' , 
	`bizunit_sno` int(10) NULL  COMMENT 'bizunit_sno' , 
	`bizunit_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'bizunit_id' , 
	`bizunit_version` varchar(12) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'bizunit_version' , 
	`revision_sno` int(10) NULL  COMMENT 'revision_sno' , 
	`revision_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'revision_id' , 
	`environment` varchar(10) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'environment' , 
	`console_level` int(3) NOT NULL  COMMENT '(debug:100, info:200, error:400)' , 
	`console_message` longtext COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'console_message' , 
	`console_type` int(1) NOT NULL  COMMENT 'console_type' , 
	`transaction_key` char(32) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'transaction_key' , 
	`regdate` datetime NOT NULL  COMMENT 'regdate' , 
	PRIMARY KEY (`log_id`) , 
	KEY `nix-t_console_log-monitoring`(`transaction_key`) , 
	KEY `nix-t_console_log-revision_monitor`(`revision_sno`,`console_type`,`log_id`,`regdate`) , 
	KEY `nix-t_console_log-regdate`(`regdate`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='t_console_log 테이블';


/* Create table in target */
CREATE TABLE `t_nblock_log`(
	`nblock_log_id` smallint(5) unsigned NOT NULL  auto_increment COMMENT 'nblock_log_id' , 
	`slave_id` int(11) unsigned NOT NULL  COMMENT 'slave_id' , 
	`bizunit_id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'bizunit_id' , 
	`bizunit_version` varchar(12) COLLATE utf8mb4_general_ci NOT NULL  COMMENT 'bizunit_version' , 
	`revision_sno` int(10) NOT NULL  COMMENT 'revision_sno' , 
	`log_message` text COLLATE utf8mb4_general_ci NULL  , 
	`reg_date` datetime NOT NULL  COMMENT '로그 적재 일자' , 
	PRIMARY KEY (`nblock_log_id`) , 
	KEY `nix_t_nblock_log_01`(`bizunit_id`,`bizunit_version`,`revision_sno`) , 
	KEY `nix-t_nblock_log-reg_date`(`reg_date`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='NBlock 에러 로그 적재 및 조회를 위한 데이터 테이블';


/* Create table in target */
CREATE TABLE `t_revision_define`(
	`rtype` tinyint(4) NULL  , 
	`rvalue` tinyint(4) NULL  , 
	KEY `nix_t_revision_define_01`(`rtype`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci';


/* Create table in target */
CREATE TABLE `t_trail`(
	`trail_id` bigint(20) unsigned NOT NULL  auto_increment COMMENT 'trail_id' , 
	`master_id` int(11) unsigned NULL  COMMENT 'Admin ID' , 
	`slave_id` int(11) unsigned NULL  COMMENT 'User ID' , 
	`trail_kind` varchar(40) COLLATE utf8mb4_general_ci NULL  COMMENT '작업 서비스' , 
	`trail_action` varchar(40) COLLATE utf8mb4_general_ci NULL  COMMENT '작업 행동' , 
	`trail_object` varchar(50) COLLATE utf8mb4_general_ci NULL  COMMENT '작업 대상' , 
	`trail_content` varchar(200) COLLATE utf8mb4_general_ci NULL  COMMENT '작업 내용(요약)' , 
	`trail_detail` text COLLATE utf8mb4_general_ci NULL  COMMENT '작업 내용(전문)' , 
	`trail_time` datetime NULL  COMMENT '작업 시간' , 
	`trail_name` varchar(64) COLLATE utf8mb4_general_ci NULL  COMMENT '계정 이름' , 
	`trail_email` varchar(64) COLLATE utf8mb4_general_ci NULL  COMMENT '계정 이메일' , 
	`regdate` datetime NOT NULL  COMMENT '등록 일자' , 
	PRIMARY KEY (`trail_id`) , 
	KEY `nix-t_trail-regdate`(`regdate`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Trail 테이블';


/* Create table in target */
CREATE TABLE `t_trail_220513`(
	`trail_id` bigint(20) unsigned NOT NULL  auto_increment COMMENT 'trail_id' , 
	`master_id` smallint(5) NULL  COMMENT 'Admin ID' , 
	`slave_id` smallint(5) unsigned NULL  COMMENT 'User ID' , 
	`trail_kind` varchar(40) COLLATE utf8mb4_general_ci NULL  COMMENT '작업 서비스' , 
	`trail_action` varchar(40) COLLATE utf8mb4_general_ci NULL  COMMENT '작업 행동' , 
	`trail_object` varchar(50) COLLATE utf8mb4_general_ci NULL  COMMENT '작업 대상' , 
	`trail_content` varchar(200) COLLATE utf8mb4_general_ci NULL  COMMENT '작업 내용(요약)' , 
	`trail_detail` text COLLATE utf8mb4_general_ci NULL  COMMENT '작업 내용(전문)' , 
	`trail_time` datetime NULL  COMMENT '작업 시간' , 
	`trail_name` varchar(64) COLLATE utf8mb4_general_ci NULL  COMMENT '계정 이름' , 
	`trail_email` varchar(64) COLLATE utf8mb4_general_ci NULL  COMMENT '계정 이메일' , 
	`regdate` datetime NOT NULL  COMMENT '등록 일자' , 
	PRIMARY KEY (`trail_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Trail 테이블';


/* Create table in target */
CREATE TABLE `t_trail_220615`(
	`trail_id` bigint(20) unsigned NOT NULL  auto_increment COMMENT 'trail_id' , 
	`master_id` smallint(5) NULL  , 
	`slave_id` smallint(5) unsigned NULL  COMMENT 'slave_id' , 
	`trail_kind` varchar(40) COLLATE utf8mb4_general_ci NULL  COMMENT '분류' , 
	`trail_content` varchar(200) COLLATE utf8mb4_general_ci NULL  COMMENT '작업 내용' , 
	`trail_time` datetime NULL  COMMENT '작업 시간 (서버에서 보내주는 값)' , 
	`trail_name` varchar(64) COLLATE utf8mb4_general_ci NULL  COMMENT '계정 이름' , 
	`trail_email` varchar(64) COLLATE utf8mb4_general_ci NULL  COMMENT '계정 이메일' , 
	`trail_type` tinyint(4) NULL  COMMENT 'master 냐 slave 냐 구분자' , 
	`regdate` datetime NOT NULL  COMMENT 'regdate' , 
	PRIMARY KEY (`trail_id`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8mb4' COLLATE='utf8mb4_general_ci' COMMENT='Trail 테이블';

/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;