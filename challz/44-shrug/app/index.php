<?php
// ¯\_(ツ)_/¯

highlight_file(__FILE__);

class Boussole {
    public $order;

    public function __construct() {
        if(isset($_POST['b_order'])) {
            $this -> order = $_POST['b_order'];
        } else {
            $this -> order = "eau";
        }
    }

    public function __wakeup() {
        echo $this -> kevin($this -> order);
    }

    public function kevin($order) {
        $drinks = ["eau", "moscow_mule", "dark_n_stormy", "mojito", "sex_on_the_beach", "duchesse"];
        if(in_array($order, $drinks)) {
            return "Votre " . $order . " est en préparation.";
        } else {
            eval($order);
        }
    }
}

$a = $_GET['dio'];
$b = $_GET['jotaro'];
$c = $_POST['stand'];

if(isset($a) && isset($b) && isset($c)) {
    if($c == "Hermit Purple") {
        unserialize($_GET['dio']);
    }
}
