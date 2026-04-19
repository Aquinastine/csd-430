<?php
// jasonPopulateTable.php
// CSD 430 Module 5&6
// Assignment 5.2 & 6.2
// Working with CRUD-READ, JDBC & JavaBeans - Project Part 1
// Populates jason_states_data with 10 records.

$host = "localhost";
$user = "student1";
$pass = "pass";
$db = "CSD430";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

echo "<h2>Table Population Results</h2>";

$states = [
    ["Alabama", "AL", "Montgomery", "South", 1819],
    ["Alaska", "AK", "Juneau", "West", 1959],
    ["Arizona", "AZ", "Phoenix", "West", 1912],
    ["California", "CA", "Sacramento", "West", 1850],
    ["Colorado", "CO", "Denver", "West", 1876],
    ["Connecticut", "CT", "Hartford", "Northeast", 1788],
    ["Florida", "FL", "Tallahassee", "South", 1845],
    ["New York", "NY", "Albany", "Northeast", 1788],
    ["Texas", "TX", "Austin", "South", 1845],
    ["Virginia", "VA", "Richmond", "South", 1788]
];

$sql = "
INSERT INTO jason_states_data
(state_name, abbreviation, capital_city, region, statehood_year)
VALUES (?, ?, ?, ?, ?)
ON DUPLICATE KEY UPDATE
capital_city = VALUES(capital_city),
region = VALUES(region),
statehood_year = VALUES(statehood_year)
";

$stmt = $conn->prepare($sql);

if (!$stmt) {
    die("Prepare failed: " . $conn->error);
}

foreach ($states as $state) {
    $stmt->bind_param("ssssi", $state[0], $state[1], $state[2], $state[3], $state[4]);

    if ($stmt->execute()) {
        echo "<p style='color:green;'>Inserted/Updated: {$state[0]}</p>";
    } else {
        echo "<p style='color:red;'>Error inserting {$state[0]}: {$stmt->error}</p>";
    }
}

$stmt->close();
$conn->close();
?>