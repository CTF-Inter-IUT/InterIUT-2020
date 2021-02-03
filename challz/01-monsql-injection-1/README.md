# MonSQL injection 1

Injection en MonSQL assez basique dans un champ dédié au requêtage MonSQL.

## Flag

Seule donnée dans la table INFOS\_SENSIBLE : __ENSIBS{J\_4D0R3\_M4JU5CUL3R}__

## Contexte

> L'ANESCIE vient de dédier une page à la création du MonSQL, 

## Mise en place

Le [Dockerfile](Dockerfile)est idéal ici.

Pour le construire :
```bash
docker build -t interiut/01-monsql-injection .
docker run -it --rm -p 3306:3306 -p 80:80 interiut/01-monsql-injection
```


Sinon pour tester le côté client (il y aura des erreurs sans BDD):
```bash
cd app/
php -S localhost:80
```

## Explications

Résumé de l'exploitation du chall

L'exploitation est détaillée [ici](writeup.md).

## Ressources

* [MonSQL-php](https://github.com/MaitreRenard/MonSQL-php)
* [Documentation MonSQL](monsql.raclette.site)
