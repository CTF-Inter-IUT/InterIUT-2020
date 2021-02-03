<?php
$user = 'nephael';
$pass = 'patrick_balkany';

header('Cache-Control: no-cache, must-revalidate, max-age=0');
$isCreds = !(empty($_SERVER['PHP_AUTH_USER']) && empty($_SERVER['PHP_AUTH_PW']));
$isNotAuth = (!$isCreds ||
    $_SERVER['PHP_AUTH_USER'] != $user ||
    $_SERVER['PHP_AUTH_PW'] != $pass
);

if($isNotAuth){
    header('HTTP/1.1 401 Authorization Required');
    header('WWW-Authenticate: Basic realm="Access denied"');
    echo "Cheh mon pote.";
} else {
    echo "ENSIBS{v3ry_b4s1c_AuTH_4_n3phAeL}";
}
?>
