<?php

// Check connection
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Your original PHP code starts here
require_once __DIR__ . '/vendor/autoload.php';

// Database credentials
$servername = "localhost";
$username = "root";
$password = "StrongPassword123!";
$dbname = "taskdb";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
// Handle form submission to add a task
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $task = $conn->real_escape_string($_POST['task']);
    $sql = "INSERT INTO tasks (description) VALUES ('$task')";
    if ($conn->query($sql) === TRUE) {
        echo "<p>Task added successfully!</p>";
    } else {
        echo "<p>Error: " . $sql . "<br>" . $conn->error . "</p>";
    }
}

// Fetch all tasks
$sql = "SELECT * FROM tasks";
$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="./style.css">

    <title>Task Manager</title>
</head>
<body>
    <h1>Task Manager</h1>
    <form method="POST">
        <label for="task">New Task:</label>
        <input type="text" id="task" name="task" required>
        <button type="submit">Add Task</button>
    </form>

    <h2>Task List</h2>
    <ul>
        <?php if ($result->num_rows > 0): ?>
            <?php while ($row = $result->fetch_assoc()): ?>
                <li><?php echo htmlspecialchars($row['description']); ?></li>
            <?php endwhile; ?>
        <?php else: ?>
            <p>No tasks found.</p>
        <?php endif; ?>
    </ul>
</body>
</html>
