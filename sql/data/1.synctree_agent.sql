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

/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;