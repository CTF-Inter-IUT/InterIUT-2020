<!DOCTYPE html>
<html lang="fr">
	<head>
		<title>ERREUR</title>
		<meta charset="utf-8">

		<!-- Feuilles de styles-->
		<link rel="stylesheet" href="css/style.css">


		<!-- Meilleure gestion des mobiles -->
		<meta name="theme-color" content="#fff">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0">
	</head>
	<body>
		<h1><?= htmlspecialchars($_GET['error_name']); ?></h1>
		<p><?= htmlspecialchars($_GET['error']); ?></p>
	</body>
</html>