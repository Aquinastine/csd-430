/* 
Jason Luttrell
CSD 430 Module 5&6
Assignment 5.2 & 6.2
Working with CRUD-READ, JDBC & JavaBeans - Project Part 1
Create a database and Populate it with data for follow on work

This is the SQL code to create and populate the database for the project. 
*/

--Create the database and user for the project, and grant permissions 
--to the user.
CREATE DATABASE IF NOT EXISTS CSD430;

CREATE USER IF NOT EXISTS 'student1'@'localhost'
IDENTIFIED BY 'pass';

GRANT ALL PRIVILEGES ON CSD430.* TO 'student1'@'localhost';

FLUSH PRIVILEGES;

USE CSD430;

--Optional code to verify the database and user were created 
--successfully, and that the user has the correct permissions.
SHOW DATABASES;
SELECT user, host FROM mysql.user WHERE user = 'student1';
SHOW GRANTS FOR 'student1'@'localhost';
