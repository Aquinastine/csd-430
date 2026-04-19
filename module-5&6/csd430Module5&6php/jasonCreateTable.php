<?php
// jasonCreateTable.php
// Jason Luttrell
// CSD 430 Module 5&6
// Assignment 5.2 & 6.2
// Working with CRUD-READ, JDBC & JavaBeans - Project Part 1
// Uses the student1 account to create the states table inside CSD430.

$host = "localhost";
$user = "student1";
$pass = "pass";
$db = "CSD430";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "
CREATE TABLE IF NOT EXISTS jason_states_data (
    state_id INT AUTO_INCREMENT PRIMARY KEY,
    state_name VARCHAR(50) NOT NULL UNIQUE,
    abbreviation CHAR(2) NOT NULL UNIQUE,
    capital_city VARCHAR(50) NOT NULL,
    region VARCHAR(25) NOT NULL,
    statehood_year INT NOT NULL
)";

echo "<h2>Table Creation Results</h2>";

if ($conn->query($sql) === TRUE) {
    echo "<p style='color:green;'>Table jason_states_data created successfully.</p>";
} else {
    echo "<p style='color:red;'>Error creating table:</p>";
    echo "<p>" . $conn->error . "</p>";
}

$conn->close();
?>