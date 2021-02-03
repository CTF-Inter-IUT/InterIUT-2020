<?php
include "include/cookies.php";
include "include/header.php";
?>

<div class="container">
    <h1>Page de connexion</h1>

    <form method="post">
        <input type="text" placeholder="Identifiant">
        <input type="password" placeholder="Mot de passe">
        <input type="submit" value="Connexion">
    </form>

    <?php
    if(isset($_POST["submit"])){
        echo "Désolé, un problème est survenu, veuillez réessayer plus tard.";
    }
    ?>

</div>

<?php include "include/footer.php"; ?>
