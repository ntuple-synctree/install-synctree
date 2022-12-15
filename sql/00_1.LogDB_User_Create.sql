DROP DATABASE IF EXISTS synctree_studio_logdb;

CREATE DATABASE synctree_studio_logdb DEFAULT CHARACTER SET utf8mb4;


CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'Dpsxjvmf12!';
CREATE USER IF NOT EXISTS  'appserver'@'%' IDENTIFIED BY 'Tldzmtjqj12!';
CREATE USER IF NOT EXISTS  'devel'@'%' IDENTIFIED BY 'Tldzmdevel12!';

GRANT USAGE ON *.* TO 'admin'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, PROCESS, REFERENCES, INDEX, ALTER, SHOW DATABASES, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER, LOAD FROM S3, SELECT INTO S3, INVOKE LAMBDA, INVOKE SAGEMAKER, INVOKE COMPREHEND ON *.* TO 'admin'@'%' WITH GRANT OPTION;

GRANT USAGE ON *.* TO 'appserver'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON `synctree_studio_logdb`.* TO 'appserver'@'%';

GRANT USAGE ON *.* TO 'devel'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON `synctree_studio_logdb`.* TO 'devel'@'%';
