-- drop database if exists `database`;
-- create database `database`;
-- use `database`;
--
-- grant select on database.* to 'skull'@'%' identified by 'kGaTXycudy1eywwtgm9or7TUiu4PYARYRRnmgC2yq05FwFZ';

drop table if exists `admins`;
create table `admins` (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	username text not null,
	password text not null
);
insert into `admins` (username, password) values
	("admin","w00t_p455w0rd");

drop table if exists `reports`;
create table `reports` (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	title text not null,
	content text not null,
	category text
);
insert into `reports` (title, content, category) values
	("Témoignage poignant du petit Mohamed","Le petit Mohamed est un jeune venant de la cité à proximité du casino, il nous explique les liens de sa famille et la tribu Wakawaka. La suite va vous étonner.","aridjapouf"),
	("Jean-Phillibert, habitué du casino reste sans voix","En effet, il est né muet.","aridjapouf");
