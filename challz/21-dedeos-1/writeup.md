# Writeup
Pas trop détaillé psq nik la poliss

## Recon
On comprend que le serveur ping ce que l'on écrit dans l'input, on voit qu'il n'y a pas de filtre en place.
On se dit que le serveur fait un truc du genre :
```bash
ping -c 1 $ip
```

## Exploit
On peut essayer quelques payloads à la zeub, on a par exemple :
```bash
;ls;
```

Qui nous liste le répertoire courant de l'application.
On trouve le dossier `secret`, on continue comme ça : `/secret/the/flag/is/here/` et on trouve le fichier `.flag`.

## Résumé
```bash
;cat secret/the/flag/is/here/.flag;
```
