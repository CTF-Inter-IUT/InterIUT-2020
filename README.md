# InterIUT 2k20
![Docker](https://github.com/CTF-Inter-IUT/InterIUT/workflows/Docker/badge.svg)

## Commencer à travailler

* Execution du script `./setup.sh` (qui pour le moment n'ajoute qu'un hook pour décider des conteneurs à build dans la CI)

## Procédure d'ajout d'un challenge

* Ajout et détail dans le drive
* Ajout dans l'[outil de gestion de projet](https://github.com/CTF-Inter-IUT/InterIUT/projects/1)
* Création du dossier à partir du template (`cp -r 00-challs-exemple XX-nom-du-chall`)
* Si le challenge a besoin d'un conteneur, creer le Dockerfile qui hebergera le challenge. Sauf exceptions, celui soit se baser sur une image `registry.alfred.cafe/interiut/interiut-base-xxx` avec xxx etant l'un des dossiers `./docker/xxx`
* Dès que le Dockerfile est correct et que vous faites un commit le script `.githooks/pre-commit` va generer le fichier `.github/workflows/docker-publish.yml` a partir du drive et l'arborescence du depot. Des lors, l'image docker du challenge est build par la CI et se retrouve sur [registry.alfred.cafe]() a chaque push.

## Procedure de deploiement d'un challenge

* Verifiez que toutes les etape de `Procédure d'ajout d'un challenge` ont ete respectes.
* Lire le fichier [infra/README.md](./infra/README.md) pour faire connaissance avec l'infra et installer tous les outils
* La liste de tous les challenges se trouve dans le fichier [infra/dev/challz/variable.tf]()

**Il existe (pour l'instant) 3 types de challenges :**
### Challenge "file"
J'avoue c'est pas tres explicite comme nom, mais un challenge _"file"_ est un challenge qui n'a besoin que d'un ajout du CTFd. Par exemple un chall ou on fournit un `pcap`.

### Challenge "web"
Un challenge qui a besoin d'au moins un conteneur pour heberger le challenge. Celui ci doit exposer **un seul port** dans son Dockerfile pour etre detecte par traefik. L'url du challenge sera alors `nom-du-dossier-sans-l'id.challz.interiut.ctf`.

Si le challenge web a besoin d'une BDD, alors vous pouvez rajouter l'argument `require_mysql = 1` afin de monter une base de donnees mysql. Celle ci sera accessible sous le nom d'hote `database` avec l'utilisateur `root` et sans mot de passe. Vous pouvez aussi fournit un script de provisioning avec la variable `mysql_init_script = 'xxx.sql'` qui est un chemin relatif au dossier du challenge.

### Challenge "tcp"
Un challenge qui a besoin d'un port dedie a son fonctionnement. Vous devez alors avoir un `Dockerfile` valide qui expose un port quelconque. Vous devez indiquer le port a exposer avec la variable `port = 1337`.

## Procédure de déploiement et infra
Voir [infra/README.md]()

## Connection au VPN sur linux

Si vous utilisez network-manager, wireguard est supporte depuis la version 1.16, mais uniquement avec nmcli :
```bash
nmcli connection import type wireguard file wg0.conf
nmcli c modify wg0 ipv4.dns-search interiut.ctf
```

Sinon vous pouvez utiliser wg-quick (Qui est inclu dans le package wireguard) :
```bash
sudo cp wg0.conf /etc/wireguard/
sudo wg-quick up wg0
```

## Challenges pour l'inter IUT

* [01-monsql-injection-1](challz/01-monsql-injection-1)
* [02-monsql-injection-2](challz/02-monsql-injection-2)
* [03-monsql-injection-3](challz/03-monsql-injection-3)
* [04-connaissez-vous-latex](challz/04-connaissez-vous-latex)
* [05-connaissez-vous-latex-bis](challz/05-connaissez-vous-latex-bis)
* [06-commotion-cerebrale](challz/06-commotion-cerebrale)
* [07-exfiltration-1](challz/07-exfiltration-1)
* [08-exfiltration-2](challz/08-exfiltration-2)
* [09-exfiltration-3](challz/09-exfiltration-3)
* [10-recuperation-de-donnees-1](challz/10-recuperation-de-donnees-1)
* [11-ping-pong](challz/11-ping-pong)
* [12-xor-madness](challz/12-xor-madness)
* [13-rien-a-signaler-tu-dois-avoir](challz/13-rien-a-signaler-tu-dois-avoir)
* [14-salut](challz/14-salut)
* [15-frasm-reversing-1](challz/15-frasm-reversing-1)
* [16-frasm-reversing-2](challz/16-frasm-reversing-2)
* [17-frasm-reversing-3](challz/17-frasm-reversing-3)
* [21-dedeos-1](challz/21-dedeos-1)
* [22-dedeos-2](challz/22-dedeos-2)
* [23-dedeos-3](challz/23-dedeos-3)
* [25-skull-1](challz/25-skull-1)
* [31-air-cnc](challz/31-air-cnc)
* [33-homo-accerus](challz/33-homo-accerus)
* [34-ninja-name-generator](challz/34-ninja-name-generator)
* [36-ready-set-install](challz/36-ready-set-install)
* [37-hello-s](challz/37-hello-s)
* [38-big-brain-time](challz/38-big-brain-time)
* [39-noot-noot](challz/39-noot-noot)
* [43-cereales-en-ligne](challz/43-cereales-en-ligne)
* [44-shrug](challz/44-shrug)
* [47-discover-the-world](challz/47-discover-the-world)
* [49-PNL-MHD-NTM-SCH-MSB](challz/49-PNL-MHD-NTM-SCH-MSB)
* [50-qui-passe](challz/50-qui-passe)
* [51-smali-beau-pays](challz/51-smali-beau-pays)
* [52-luksury](challz/52-luksury)
* [54-impossible](challz/54-impossible)
* [55-le-grand-sage](challz/55-le-grand-sage)
* [55-le-sage-dore](challz/55-le-sage-dore)
* [57-decryptor](challz/57-decryptor)
* [60-reverse-me-1](challz/60-reverse-me-1)
* [61-reverse-me-2](challz/61-reverse-me-2)
* [65-skull-2](challz/65-skull-2)
* [66-theourie-des-graphes](challz/66-theourie-des-graphes)
* [67-dio-fucking-retard](challz/67-dio-fucking-retard)
