<?php
include "include/cookies.php";
include "include/header.php";

$c = $_COOKIE["secret"];
$u = unserialize(base64_decode($c));
if($u -> username !== "admin"){
    echo "<h1>Forbidden</h1>";
} else {
    echo "<pre><code>ENSIBS{k3ll0gs_Ftw!}</code></pre>";
}
?>

<?php
include "include/footer.php";
?>
