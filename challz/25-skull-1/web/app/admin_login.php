<?php

require_once("includes/config.php");
require_once("includes/functions.php");

include("includes/header.php");

if($_SESSION['admin'] === "yes_im_admin"){
	include("includes/admin_header.php");
}

?>

<h1>Page de connexion admin</h1>

<?php
if($_SESSION['admin'] === "yes_im_admin"){
	
	echo "<p>Vous êtes connecté avec l'utilisateur 'admin'.</p>";

} else {

	echo "<form method='post'>
	<div>
		<span>Nom d'utilisateur : </span>
		<input type='text' name='username' placeholder='admin'>
	</div>
	<div>
		<span>Mot de passe : </span>
		<input type='password' name='password' placeholder='password'>
	</div>
	<input type='submit' name='submit' value='Connexion'>
	</form>";

	if(isset($_POST["submit"]) && !empty($_POST["submit"])){
		if(isset($_POST["username"]) && !empty($_POST["username"])){
			if(isset($_POST["password"]) && !empty($_POST["password"])){
				$username = $_POST["username"];
				$password = $_POST["password"];

				if(admin_login($username, $password)){
					set_admin();
					$t = basename($_SERVER['PHP_SELF']);
					echo "<script>document.location='$t'</script>";
				} else {
					echo "Mauvais couple (utilisater, mot de de passe).";
				}
			}
		}
	}
}
?>

<?php include("includes/footer.php"); ?>
