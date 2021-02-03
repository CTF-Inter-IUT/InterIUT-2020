<?php
class User {
    var $username;
    var $basket = null;
}

$c = $_COOKIE["secret"];

if(!isset($c)){
    $user = new User;
    $user -> username = "guest";
    $v = serialize($user);
    setcookie("secret", base64_encode($v));
}
?>
