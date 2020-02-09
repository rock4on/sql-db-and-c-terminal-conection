<?php>
$user = 'root';
$password = 'root';
$db = 'Proiect_bd';
$host = 'localhost';
$port = 3306;

$link = mysqli_init();
$success = mysqli_real_connect(
   $link, 
   $host, 
   $user, 
   $password, 
   $db,
   $port
);	

$comanda=$_POST["data"];
$result = $link->query($comanda);

if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
        foreach ($row as $item)
		{
			echo $item. " ";
			
		}
		echo "\n";
    }
} else {
    echo "0 results";
}
?>