<?php
// jasonDeleteDatabase.php
// Jason Luttrell
// CSD 430 Module 5&6
// Assignment 5.2 & 6.2
// Working with CRUD-READ, JDBC & JavaBeans - Project Part 1
// Create a database and Populate it with data for follow on work
// Uses XAMPP admin account to delete the database.

$host = "localhost";
$adminUser = "root";
$adminPass = "";   // Change if your XAMPP root password is not blank.

$conn = new mysqli($host, $adminUser, $adminPass);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

echo "<h2>Database Deletion Results</h2>";

$sql = "DROP DATABASE IF EXISTS CSD430";

if ($conn->query($sql) === TRUE) {
    echo "<p style='color:green;'>Database CSD430 deleted successfully.</p>";
} else {
    echo "<p style='color:red;'>Error deleting database:</p>";
    echo "<p>" . $conn->error . "</p>";
}

/*
Optional reset if you also want to remove the MySQL user:
$conn->query("DROP USER IF EXISTS 'student1'@'localhost'");
$conn->query("FLUSH PRIVILEGES");
*/

$conn->close();
?>