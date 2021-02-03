<?php
require_once("includes/config.php");
require_once("includes/functions.php");

include("includes/header.php");
if($_SESSION['admin'] === "yes_im_admin"){
	include("includes/admin_header.php");
}
?>


<?php

$c = "";

if(isset($_GET['categorie'])){
	$c = $_GET['categorie'];
}

if($c === "aridjapouf"){
	echo "<h1>Témoignages sur le crâne d'Aridjapouf</h1>";
}

$db = connect_db();
$q = "select title, content from reports where category='$c'";
$r = query_db($db, $q);
echo "<div id='articles'>";
print_reports($r);
echo "</div>";

?>

<?php include("includes/footer.php"); ?>
