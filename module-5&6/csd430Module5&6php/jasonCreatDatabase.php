<?php
// jasonCreateDatabase.php
// Jason Luttrell
// CSD 430 Module 5&6
// Assignment 5.2 & 6.2
// Working with CRUD-READ, JDBC & JavaBeans - Project Part 1
// Create a database and Populate it with data for follow on work
// Uses XAMPP admin account to create the database and application user.

$host = "localhost";
$adminUser = "root";
$adminPass = "";   // XAMPP default is often blank. Change if yours is different.

$conn = new mysqli($host, $adminUser, $adminPass);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sqlStatements = [
    "CREATE DATABASE IF NOT EXISTS CSD430",
    "CREATE USER IF NOT EXISTS 'student1'@'localhost' IDENTIFIED BY 'pass'",
    "GRANT ALL PRIVILEGES ON CSD430.* TO 'student1'@'localhost'",
    "FLUSH PRIVILEGES"
];

echo "<h2>Database Creation Results</h2>";

foreach ($sqlStatements as $sql) {
    if ($conn->query($sql) === TRUE) {
        echo "<p style='color:green;'>Success:</p><pre>$sql</pre>";
    } else {
        echo "<p style='color:red;'>Error:</p><pre>$sql</pre>";
        echo "<p>" . $conn->error . "</p>";
    }
}

$conn->close();
?>