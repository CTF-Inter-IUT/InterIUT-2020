<!doctype html>
<html>
<head>
    <title>Impossible mec</title>
    <meta charset="utf-8">
</head>
<body>
<?php
    # Personne ne peut trouer cette sécurité ! Tiens, je te donne même le code source. Bonne chance hein ;)

    require_once("include/config.php");

    highlight_file(__FILE__);

    function RecuperationDuMotDePasse(){
        echo "Mon mot de passe est : <b>" . file_get_contents("/flag") . "</b>";
    }

    if(isset($_GET["code"]) && !empty($_GET["code"])){
        $code = $_GET["code"];

        # Parce que faut pas déconner non plus !
        $code = filtrage($code);

        if(strpos($code, "RecuperationDuMotDePasse") === false){
            call_user_func($code);
        } else {
            echo "Ahaha je le savais. Im-po-ssible j'ai dis.";
        }
    }
?>
</body>
</html>
