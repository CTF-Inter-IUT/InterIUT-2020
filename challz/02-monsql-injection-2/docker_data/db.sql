-- drop database if exists `h4xx0r_db`;
-- create database `h4xx0r_db`;
-- grant select on h4xx0r_db.* to 'monsql-2'@'%' identified by 'viCkKnlLwBbh8i1wIUE0rmCnfmnNqny9nBlcaQTVJDdZIOq';
-- use `h4xx0r_db`;

drop table if exists `database`.`wr1t3_up5`;
drop table if exists `database`.`tut0ri4lz`;
create table `h4xx0r_db`.`wr1t3_up5` (
	id int not null auto_increment,
	t1tl3 text not null,
	ctf_n4m3 text not null,
	p4th_t0_f1l3 text not null,
	acc3ss_c0d3 text,
	primary key (id)
);

create table `h4xx0r_db`.`tut0ri4lz` (
	id int not null auto_increment,
	t1tl3 text not null,
	c4t3g0ry text not null,
	p4th_t0_f1l3 text not null,
	primary key (id)
);

INSERT INTO `h4xx0r_db`.`wr1t3_up5` (t1tl3, ctf_n4m3, p4th_t0_f1l3, acc3ss_c0d3) values
	("Where is the file", "PicoCTF 2019", "ls", null),
	("Frauthmage", "RacletteCTF 2020", "savoyarde", null),
	("It's a SIGn", "ApériCTF 2019", "sign", null),
	("MonSQL Injection 1", "InterIUT 2020", "monsql-injection-1", null),
	("MonSQL Injection 2", "InterIUT 2020", "monsql-injection-2", "v3ry_v3rY_s3cur3_p455w0rd");

INSERT INTO `h4xx0r_db`.`tut0ri4lz` (t1tl3, c4t3g0ry, p4th_t0_f1l3) values
	("Consseille de PRO sur MonSQL", "Système", "monsql"),
	("Comen instaler PHP7 sur son serveur", "Système", "php-sept"),
	("Trouver les fichié cacher", "Forensique", "fichier-caches"),
	("Comen sécurrisé son sit web", "Web", "securite-web"),
	("Lé fcihiés à allé voir tt 2 suit", "Web", "fichiers-importants");
