<?
# Test database connection.
try {
    $dbh = new PDO('mysql:host=mysql;port=3306;dbname=mydb', 'admin', 'secret');
    $dbi = 'Database connected successfully!';
} catch (PDOException $e) {
    $dbi = 'Error!: ' . $e->getMessage();
}
?>

<div style="width: 934px; 
            margin: 0px auto; 
            box-shadow: 1px 2px 3px #ccc;
            background-color: #99c;
            font-weight: bold;
            border: 1px solid #666;
            font-size: 85%;
            padding: 10px 5px;
            box-sizing: border-box;">
    <div style="font-size: 130%;
                margin-bottom: 10px;">
        MySQL Connection
    </div>
    <?= $dbi ?>
</div>

<?
# Show PHP info.
phpinfo();