# Hello %s !

Binaire accessible sur le serveur avec un suid

## Flag

Contenu du fichier flag : __ENSIBS{VOICI LE FLAG J'AI PAS D'IDÉE}__

## Contexte

> Hello %s, do you know C ?

## Mise en place

Si il y a un Dockerfile : [Dockerfile](Dockerfile).
```bash
docker build -t interiut/37-salut-format-string .
docker run -it --rm interiut/37-salut-format-string
```

## Explications

Changement du nom de l'exécutable pour exploiter la format string.

L'exploitation est détaillée [ici](writeup.md).

## Ressources

* [Format string resource](http://www.cis.syr.edu/~wedu/Teaching/cis643/LectureNotes_New/Format_String.pdf)
