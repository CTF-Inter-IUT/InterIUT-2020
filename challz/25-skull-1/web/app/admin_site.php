<?php
require_once("includes/config.php");
require_once("includes/functions.php");

include("includes/header.php");

if($_SESSION['admin'] === "yes_im_admin"){
	include("includes/admin_header.php");
}
?>

<?php
if($_SESSION['admin'] !== "yes_im_admin"){
	echo "<p>Vous devez être administrateur pour accèder à cette page. Veuillez <a href='/admin_login.php'>vous identifier</a>.</p>";
} else {
	echo "<p>Hello admin, here is your flag : ".Config::$flag2."</p>";
}
?>

<?php include("includes/footer.php"); ?>
