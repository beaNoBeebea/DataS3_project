-- Create the database
CREATE DATABASE IF NOT EXISTS MNHS;

-- Create dedicated user
CREATE USER 'mnhs_user'@'localhost' IDENTIFIED BY 'MNHSpassword123!';

-- Grant privileges
GRANT SELECT, INSERT, UPDATE, DELETE ON MNHS.* TO 'mnhs_user'@'localhost';
FLUSH PRIVILEGES;

-- Switch to the database
USE MNHS;

-- Exit MySQL
EXIT;