/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

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
	`user_id` int(10) NOT NULL  COMMENT 'User ID' , 
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

/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;