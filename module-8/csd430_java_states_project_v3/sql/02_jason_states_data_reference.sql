/* 
Jason Luttrell
CSD 430 Module 5&6
Assignment 5.2 & 6.2
Working with CRUD-READ, JDBC & JavaBeans - Project Part 1
Create a database and Populate it with data for follow on work

This is the SQL code to create and populate the database for the project. 
*/

USE CSD430;

--Create the table to hold the states data, with appropriate 
--columns and data types.    
CREATE TABLE IF NOT EXISTS jason_states_data (
    state_id INT AUTO_INCREMENT PRIMARY KEY,
    state_name VARCHAR(50) NOT NULL,
    abbreviation CHAR(2) NOT NULL,
    capital_city VARCHAR(50) NOT NULL,
    region VARCHAR(30) NOT NULL,
    statehood_year INT NOT NULL
);

--Insert data for at least 10 states into the table, ensuring that the
--data is accurate and complete.
INSERT INTO jason_states_data
(state_name, abbreviation, capital_city, region, statehood_year)
VALUES
('Alabama', 'AL', 'Montgomery', 'South', 1819),
('Alaska', 'AK', 'Juneau', 'West', 1959),
('Arizona', 'AZ', 'Phoenix', 'West', 1912),
('California', 'CA', 'Sacramento', 'West', 1850),
('Colorado', 'CO', 'Denver', 'West', 1876),
('Connecticut', 'CT', 'Hartford', 'Northeast', 1788),
('Florida', 'FL', 'Tallahassee', 'South', 1845),
('New York', 'NY', 'Albany', 'Northeast', 1788),
('Texas', 'TX', 'Austin', 'South', 1845),
('Virginia', 'VA', 'Richmond', 'South', 1788);

SELECT * FROM jason_states_data;
