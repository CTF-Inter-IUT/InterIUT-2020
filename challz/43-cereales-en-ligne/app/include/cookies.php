<?php
class User {
    var $id;
    var $isAdmin;
    var $basket = null;
    var $lastLogin;
    var $preferences;
    var $goBoussole = True;
}

$c = $_COOKIE["session"];

if(!isset($c)){
    $user = new User;
    $user -> id = 42;
    $user -> isAdmin = False;
    $user -> lastLogin = "Undefined";
    $user -> preferences = "GDPR_COMPLIANCE=False;CONSCENT_KEYLOGGER=True;I_AM_BATMAN=False;";
    $v = serialize($user);
    setcookie("session", base64_encode($v));
}
?>
