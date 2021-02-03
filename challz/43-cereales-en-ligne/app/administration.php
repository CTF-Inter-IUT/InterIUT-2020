<?php
include "include/cookies.php";
include "include/header.php";

$c = $_COOKIE["session"];
$u = unserialize(base64_decode($c));
echo "<div class='container'>";
if($u -> isAdmin == True) {
    if($u -> id == 0) {
        $flag = file_get_contents("/flag");
        echo "<pre><code>$flag</code></pre>";
    } else {
        echo "<h1 class='display-4'>Error: user with id " . $u -> id . " can't access this page.</h1>";
    }
} else {
    echo "<h1 class='display-4'>Forbidden</h1>";
}
echo "</div>";
?>

<?php
include "include/footer.php";
?>
