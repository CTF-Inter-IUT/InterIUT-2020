variable "team_per_namespace" {
	type = number
	default = 7
}

variable "challenges" {
	type = map(map(map(string)))
	description = "List of challenges"

	default = {
		web = {
			1 = {
				name = "01-monsql-injection-1"
				require_mysql = true
				mysql_user = "monsql-1"
				mysql_password = "cZEORwzLNiUaZiiLYnkSTvqZzWbSXiWWNdplDWTyIjmWQ0x"
				mysql_database = "base_de_donnees"
				mysql_init_script = "docker_data/db.sql"
			}
			2 = {
				name = "02-monsql-injection-2"
				require_mysql = true
				mysql_user = "monsql-2"
				mysql_password = "viCkKnlLwBbh8i1wIUE0rmCnfmnNqny9nBlcaQTVJDdZIOq"
				mysql_database = "h4xx0r_db"
				mysql_init_script = "docker_data/db.sql"
			}
//			3 = {
//				name = "03-monsql-injection-3"
//				require_mysql = 1
//				mysql_init_script = "docker_data/db.sql"
//			}
			4 = { name = "04-connaissez-vous-latex" }
			5 = { name = "05-latex-jail" }
			6 = { name = "06-commotion-cerebrale" }
			21 = { name = "21-dedeos-1" }
			22 = { name = "22-dedeos-2" }
			23 = { name = "23-dedeos-3" }
			25 = {
				name = "25-skull-1"
				require_mysql = true
				mysql_user = "skull"
				mysql_password = "kGaTXycudy1eywwtgm9or7TUiu4PYARYRRnmgC2yq05FwFZ"
				mysql_database = "database"
				mysql_init_script = "db/db.sql"
			}
			31 = { name = "31-air-cnc" }
			33 = { name = "33-homo-accerus" }
			34 = { name = "34-ninja-name-generator" }
			43 = { name = "43-cereales-en-ligne" }
			44 = { name = "44-shrug" }
			47 = { name = "47-discover-the-world" }
			54 = { name = "54-impossible" }
			66 = { name = "66-theourie-des-graphes" }			
			67 = {
				name = "67-dio-fucking-retard"
				require_mongo = true
				mongo_username = "challenge"
				mongo_password = "jd4nN2dcXkfJrXaEeJC8m3rZZBPSDL77"
			}
		}

		file = {
			7 = { name = "07-exfiltration-1" }
			8 = { name = "08-exfiltration-2" }
			9 = { name = "09-exfiltration-3" }
			10 = { name = "10-recuperation-de-donnees-1" }
			11 = { name = "11-ping-pong" }
			12 = { name = "12-xor-madness" }
			15 = { name = "15-frasm-reversing-1"}
			16 = { name = "16-frasm-reversing-2"}
			17 = { name = "17-frasm-reversing-3"}
			18 = { name = "18-random-authentication-system"}
			26 = { name = "26-capturez-le-drapeau"}
			29 = { name = "29-boc-1"}
			30 = { name = "30-boc-2"}
			42 = { name = "42-dna"}
			48 = { name = "48-prevoir-limprevisible"}
			49 = { name = "49-PNL-MHD-NTM-SCH-MSB"}
			50 = { name = "50-qui-passe"}
			51 = { name = "51-smali-beau-pays"}
			55 = { name = "55-le-sage-dore"}
			56 = { name = "56-la-voie-du-sage"}
			58 = { name = "58-bithagore"}
			59 = { name = "59-la-dgse-cest-moi"}
			60 = { name = "60-reverse-me-1" }
			61 = { name = "61-reverse-me-2" }
			62 = { name = "62-cybermalware" }
			63 = { name = "63-jankenpon" }
			65 = { name = "65-skull-2" }
			68 = { name = "68-space" }
			71 = { name = "71-we-will-rock-you" }
			72 = { name = "72-we-will-rock-you-again" }
			77 = { name = "77-comment-est-votre-blanquette" }
		}

		tcp = {
			14 = { name = "14-salut"}
			19 = { name = "19-random-operational-program", port = 5000, disable_checks = true }
			37 = { name = "37-hello-s", port=22 }
			38 = { name = "38-big-brain-time", port=22 }
			57 = { name = "57-decryptor"}
		}
	}
}

locals {
	challz_folder = "${dirname(dirname(abspath(path.module)))}/challz"

	ctf_configuration = {
		ctf_name = "InterIUT"
	}
	# flag_format = "H2G2{%s}"


	# grouped_teams = chunklist(var.teams, var.team_per_namespace)
}
