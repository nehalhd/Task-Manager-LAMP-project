<?php
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

// Handle form submission to add or update a task
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['task_id'])) {
        // Update task
        $task_id = $_POST['task_id'];
        $task_description = $conn->real_escape_string($_POST['task']);
        $sql = "UPDATE tasks SET description='$task_description' WHERE id=$task_id";
        if ($conn->query($sql) === TRUE) {
            echo "<p>Task updated successfully!</p>";
        } else {
            echo "<p>Error: " . $conn->error . "</p>";
        }
    } else {
        // Add new task
        $task_description = $conn->real_escape_string($_POST['task']);
        $sql = "INSERT INTO tasks (description) VALUES ('$task_description')";
        if ($conn->query($sql) === TRUE) {
            echo "<p>Task added successfully!</p>";
        } else {
            echo "<p>Error: " . $conn->error . "</p>";
        }
    }
}

// Handle task deletion
if (isset($_GET['delete_id'])) {
    $delete_id = $_GET['delete_id'];
    $sql = "DELETE FROM tasks WHERE id=$delete_id";
    if ($conn->query($sql) === TRUE) {
        echo "<p>Task deleted successfully!</p>";
    } else {
        echo "<p>Error: " . $conn->error . "</p>";
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

    <!-- Form to Add/Update Task -->
    <form method="POST">
        <label for="task">Task Description:</label>
        <input type="text" id="task" name="task" required>
        <button type="submit">Add Task</button>
    </form>

    <h2>Task List</h2>
    <ul>
        <?php if ($result->num_rows > 0): ?>
            <?php while ($row = $result->fetch_assoc()): ?>
                <li>
                    <?php echo htmlspecialchars($row['description']); ?>
                    <a href="index.php?edit_id=<?php echo $row['id']; ?>">Edit</a>
                    <a href="index.php?delete_id=<?php echo $row['id']; ?>" onclick="return confirm('Are you sure you want to delete this task?')">Delete</a>
                </li>
            <?php endwhile; ?>
        <?php else: ?>
            <p>No tasks found.</p>
        <?php endif; ?>
    </ul>

    <?php
    // If an edit is requested, populate the form with the task to edit
    if (isset($_GET['edit_id'])) {
        $edit_id = $_GET['edit_id'];
        $sql = "SELECT * FROM tasks WHERE id=$edit_id";
        $result = $conn->query($sql);
        if ($result->num_rows > 0) {
            $task = $result->fetch_assoc();
            echo '<script>document.getElementById("task").value = "'.$task['description'].'";</script>';
            echo '<form method="POST">
                    <input type="hidden" name="task_id" value="'.$task['id'].'">
                    <button type="submit">Update Task</button>
                  </form>';
        }
    }
    ?>
</body>
</html>

<?php $conn->close(); ?>
