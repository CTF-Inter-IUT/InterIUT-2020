# SALUT

On interagit avec un serveur qui nous envoie des messages codés bizarrement. Il faut convertir de base en base à partir de la base 2 jusqu'à la base 35 (non standard). 

## Flag

Le flag que renvoie le serveur : __ENSIBS{D0_y0u_l1k3_14_pur33_?}__

## Contexte

> 2202 1012 1221 10220 11001 1220 11020 1221 10220 11021 1012 11021 1221 11101 1210 10220 11020 1012 10200 1210 11001 11001 1220 11002 11022 1012 10210 1221 10220 11020 1220 1012 11100 11002 1220 1012 10122 1210 11002 11002 1220 1012 11011 11100 11020 1220 1220

## Mise en place

Pour lancer le service facilement : [Dockerfile](Dockerfile).
```bash
docker build -t interiut/14-salut .
```

Pour tester sans Docker :
```bash
./salut.py #Lance le service sur le port 4444
nc localhost 4444
```

## Explications

Il s'agit ici de scripting assez simple. On se connecte au serveur, on fait la conversion de base, on lui envoie puis on recommence.

Les étapes de création du script sont détaillées [ici](writeup.md).

## Ressources

* [Conversion en base X](http://www.courstechinfo.be/MathInfo/ConvBaseB.html)
