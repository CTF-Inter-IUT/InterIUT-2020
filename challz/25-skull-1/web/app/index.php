<?php
require_once("includes/config.php");
require_once("includes/functions.php");

include("includes/header.php");
if($_SESSION['admin'] === "yes_im_admin"){
	include("includes/admin_header.php");
}
?>

<div id="container">
	<div id="skull">
		<h1>Skull</h1>
		<img src="skull.png" title="Crâne d'Aridjapouf, le dernier chef de la tribu">
	</div>
	<p>Stupeur et consternation vendredi dernier au sein des équipes de chercheurs-orpailleurs scientifiques de Lisieux, une petite ville de Normandie. En effet, l'étonnement pour ce groupe d'experts ne fût pas mince lorsqu'ils tombèrent nez-à-nez avec ce crâne humain retrouvé sur la plage d'Houlgate, non loin du casino. Cette soirée sera mémorable pour ces quatres chercheurs pendant de nombreuses années. Notre équipe de journalistes à enquêté sur ce crâne légendaire, en effet il semble appartenir au grand Aridjapouf, chef de la tribu afghane déchue : 'Wakawaka'. Mais comment se crâne a pu se retrouver ici en Normandie ? Certains parlent d'un signe divin, d'autres d'un coup des illiminatis. Nous avons recuielli quelques témoignages auprès des jeunes de cité pour éclaircir cette histoire.</p>
</div>

<?php include("includes/footer.php"); ?>
