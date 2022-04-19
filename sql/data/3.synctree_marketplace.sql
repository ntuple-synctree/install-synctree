/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

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
	`user_id` smallint(5) unsigned NOT NULL  COMMENT 'User ID(구매자)' , 
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

/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;