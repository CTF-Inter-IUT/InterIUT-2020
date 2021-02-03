# Air CnC

Pwn de panel C&C via SSTI into RCE.

## Flag

__ENSIBS{JAIMELIS}__

## Contexte
> Vous avez découvert un panel C&C, vous avez pu trouver les identifiants de connexion admin qui plus est ! Vous savez qu'il y a un code secret de caché sur ce serveur, trouvez-le.

## Mise en place

Si il y a un Dockerfile : [Dockerfile](Dockerfile).

Sinon si il y a une procédure de build :
```bash
docker build -t air-cnc . && docker run -p 80:80 air-cnc

# curl localhost
```

## Explications

Résumé de l'exploitation du chall

L'exploitation est détaillée [ici](writeup.md).

## Ressources

Démerdez-vous les mecs.
