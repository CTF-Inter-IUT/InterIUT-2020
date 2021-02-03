# Titre du chall

Vous avez trouvé un site qui parle d'une nouvelle locale de votre bonne Normandie, cependant vous avez l'impression qu'il n'est pas vraiment sécurisé.

## Flag

À changer

1. __flag{bite de poulet1}__
2. __flag{bite de poulet2}__

## Contexte
> Stupeur et consternation vendredi dernier au sein des équipes de chercheurs-orpailleurs scientifiques de Lisieux, une petite ville de Normandie. En effet, l'étonnement pour ce groupe d'experts ne fût pas mince lorsqu'ils tombèrent nez-à-nez avec ce crâne humain retrouvé sur la plage d'Houlgate, non loin du casino.
Vous voulez en savoir plus sur ce site web.

## Mise en place

Si il y a un Dockerfile : [docker-compose](docker-compose.yml).

Sinon si il y a une procédure de build :
```bash
docker-compose build

docker-compose up
```

## Explications

Recon web basique, into SQLi pas trop dure.

L'exploitation est détaillée [ici](writeup.md).

## Ressources

