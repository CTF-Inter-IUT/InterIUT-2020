<?php

function connect_db(){
	$db = new mysqli(Config::$db_host, Config::$db_user, Config::$db_pass, Config::$db_db);

	if($db->connect_error){
		die($db->connect_error);
	}
	return $db;
}

function query_db($db, $query){
	$r = $db->query($query);
	$db->close();
	return $r;
}

function admin_login($username, $password){
	$b = false;

	$db = connect_db();
	$res = query_db($db, "select username, password from admins where id=1");

	if($res->num_rows > 0){
		$r = $res->fetch_assoc();
		$admin_username = $r['username'];
		$admin_password = $r['password'];

		if($admin_username === $username && $admin_password === $password){
			$b = true;
		}
	}

	return $b;
}

function set_admin(){
	$_SESSION['admin'] = "yes_im_admin";
}

function fetch_res($res){
	if($res->num_rows > 0){
		while($r = $res->fetch_assoc()){
			echo $r['id'].":".$r['username'].":".$r['password'];
		}
	} else {
		echo "No result.";
	}
}

function print_reports($res){
	if($res->num_rows >= 1){
		while($r = $res->fetch_array()){
			echo "<h2>".$r[0]."</h2>\n<p>".$r[1]."</p>\n";
		}
	} else {
		echo "<p>Il n'y a pas de témoignage correpondant.</p>";
    }
}

?>
