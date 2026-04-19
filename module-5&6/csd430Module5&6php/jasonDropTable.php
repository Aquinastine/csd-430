<?php
// jasonDropTable.php
// CSD 430 Module 5&6
// Assignment 5.2 & 6.2
// Working with CRUD-READ, JDBC & JavaBeans - Project Part 1
// Drops the jason_states_data table from CSD430.

$host = "localhost";
$user = "student1";
$pass = "pass";
$db = "CSD430";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "DROP TABLE IF EXISTS jason_states_data";

echo "<h2>Table Deletion Results</h2>";

if ($conn->query($sql) === TRUE) {
    echo "<p style='color:green;'>Table jason_states_data deleted successfully.</p>";
} else {
    echo "<p style='color:red;'>Error deleting table:</p>";
    echo "<p>" . $conn->error . "</p>";
}

$conn->close();
?>