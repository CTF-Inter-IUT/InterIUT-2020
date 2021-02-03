# Ninja name generator

Un générateur de nom de ninja qui utilise Jinja2 comme moteur detemplate.

## Flag

__ENSIBS{JAIMELIS}__

## Contexte
> L'histoire du chall

## Mise en place

Si il y a un Dockerfile : [Dockerfile](Dockerfile).

Sinon si il y a une procédure de build :
```bash
docker build -t nng . && docker run -p 5000:5000 nng
```

## Explications

Résumé de l'exploitation du chall

L'exploitation est détaillée [ici](writeup.md).

## Ressources

* [Jinja2 doc](https://jinja.palletsprojects.com/en/2.10.x/)
