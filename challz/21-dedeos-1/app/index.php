<!doctype html>
<html>
<head>
	<title>Dédé-OS v1.0</title>
	<meta charset="utf-8">
	<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>

	<h1>Dédé-OS</h1>
	<p>Dédé-OS est un système d'exploitation très pointu, orienté dans le hacking industriel. Malgré sa légèreté, son style unique, sa simplicité d'utilisation ou encore sa capacité à attaquer un système, Dédé-OS a du mal à percer et se faire connaître. Ce serveur en est muni, et pour prouver au public sa supériorité, j'ai mis à votre disposition une <i>infime</i> partie de sa puissace. Vous pouvez lancer une attaque sur un serveur distant afin de le mettre au tapis dans la minute.</p>
	<form method="post">
		<span>Adresse du serveur : </span>
		<input type="text" name="ip" placeholder="37.187.139.65">
		<input type="submit" name="submit" value="Attaquer !">
	</form>

	<?php

	if(isset($_POST['submit']) && isset($_POST['ip']) && !empty($_POST['ip'])){
		$ip = $_POST['ip'];
		echo "<p>Résultat de l'attaque :</p>";
		echo "<pre>".shell_exec("ping -c 1 $ip > /dev/null && echo 'Cible atteinte' || echo 'Cible non atteignable'")."</pre>";
	}

	?>

</body>
</html>
