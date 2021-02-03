# Infra

## Création du template de VM

Le dossier **template** contient les fichiers nécéssaires afin de générer un template de VM :
- Alpine Linux
- Docker
- Openssh (root/interiut)
- open-vm-tools (pour VMWare)

## Déploiement avec terraform
[https://asciinema.org/a/O2hssfiSVHJZeFdsWazicJxZU]()

Les deux dossiers **dev** et **cyberrange** correspondent aux deux environnement possibles.

Les dossiers d'environnement doivent contenir majoritairement de la config spécifique, car
les véritables ressources sont rédigés dans le dossier `modules`.

### Prérequis 

- **Terraform >= 0.13** : [https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html)
- **ctfcli** : `pip3 install --user ctfcli`
- **ssh** : Vos clef SSH doivent etre installees sur les serveurs (challz.interiut.ctf et ctfd.interiut.ctf).
- **Wireguard** doit etre connecte

Placez-vous à la racine et utilisez la commande 
`terraform init infra/xxx` pour installer tous les modules nécessaires.

Vous devez aussi vous assurer que vous avez installé votre clef publique SSH sur les
VM qui seront contactés. Terraform initie **beaucoup** de connections SSH pour vérifier puis
déployer les resources, et ca serait casse couille pour vous de devoir taper le mdp h24. Et puis si vous etes sur arch (Comme le `0xNinja`), alors terraform ne vous demandera meme pas votre passphrase.

### Stockage du .tfstate
L'etat general de l'infra est normalement stocke dans un fichier `.tfstate`, ce qui fout le bazare quand plusieurs personnes appliquent des modifications en meme temps. Du coup on utilise un backend postgres qui est heberge sur la meme machine que le serveur wireguard : `wireguard.interiut.ctf`. Ainsi des qu'une personne modifie l'infra, le state est immediatement mis a jour et accessible par tous dans le BDD. De plus postgres permet de verouiller le state pour que deux personnes ne puissent pas effectuer de modifications concurrentes.

### Application d'une modification
Si vous avez fait des modifications sur la configuration d'un challenge, alors la liste
des ajouts/modifications/suppressions devrait vous être présenté.

Si la liste des actions vous parait correct, alors vous pouvez lancer un `terraform apply infra/xxx`
pour déployer vos changements. 

**Note :** Evitez de modifier le nom du dossier d'un challenge, car il sert d'identifiant pour la ressource terraform.
