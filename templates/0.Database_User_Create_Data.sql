DROP DATABASE IF EXISTS synctree_agent;
DROP DATABASE IF EXISTS synctree_studio;
DROP DATABASE IF EXISTS synctree_plan;
DROP DATABASE IF EXISTS synctree_auth;
DROP DATABASE IF EXISTS synctree_portal;
DROP DATABASE IF EXISTS synctree_marketplace;


CREATE DATABASE synctree_agent DEFAULT CHARACTER SET utf8mb4 ;
CREATE DATABASE synctree_studio DEFAULT CHARACTER SET utf8mb4;
CREATE DATABASE synctree_plan DEFAULT CHARACTER SET utf8mb4;
CREATE DATABASE synctree_auth DEFAULT CHARACTER SET utf8mb4;
CREATE DATABASE synctree_portal DEFAULT CHARACTER SET utf8mb4;
CREATE DATABASE synctree_marketplace DEFAULT CHARACTER SET utf8mb4;


CREATE USER 'admin'@'%' IDENTIFIED BY 'YOUR-ADMIN-PASSWORD';

GRANT USAGE ON *.* TO 'admin'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, PROCESS, REFERENCES, INDEX, ALTER, SHOW DATABASES, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER, LOAD FROM S3, SELECT INTO S3, INVOKE LAMBDA, INVOKE SAGEMAKER, INVOKE COMPREHEND ON *.* TO 'admin'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;