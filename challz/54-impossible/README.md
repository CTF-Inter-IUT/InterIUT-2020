# Impossible vous pensez ?

Exploit de feature PHP pour exécuter une fonction filtrée.

## Flag

__ENSIBS{JAIMELIS}__

## Contexte
> Un leet lamer vous met au défi d'exécuter une fonction en PHP.
> Il a bien évidement mit en place une sécurité pour vous en empêcher.

## Mise en place

Si il y a un Dockerfile : [Dockerfile](Dockerfile).

Sinon si il y a une procédure de build :
```bash
docker buld -t impossible . && docker run -p 80:80 impossible
```

## Explications

Résumé de l'exploitation du chall

L'exploitation est détaillée [ici](writeup.md).

## Ressources

