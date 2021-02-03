# Writeup

## Recon
* /reports.php -> see reports, nothing interesting for the moment
* files/dir fuzzing
	* /robots.txt -> /flag1.txt, /admin_login.php...

## Flag 1
/flag1.txt -> OK

## Flag 2
/admin_login.php -> trying SQLi don't work that well.

Remember /reports.php ? See that get parameter ? Try to inject something here.

`' union select null,null;-- -`

get the DB name, tables, columns

`' union select username, password from admins;-- -`

Login as admin. Get flag2
