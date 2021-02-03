# Writeup

Le but du challenge est d'accèder à la configuration du serveur pour y trouver des informations intéressantes.

## Recon

On se trouve sur une page web avec un input qui semble être traité par le serveur, puis affiché sur la page.

Le nom du challenge et le site (ninja) nous font penser au moteur de templates Jinja sous Flask.

## Tests

On peut tester notre intuition en mettant comme nom : `{{ 7*7 }}`.

49 est affiché en retour, il s'agit ici d'une SSTI. On s'assure d'être face à un Jinja2 (on ne peut pas en être sûr à ce moment là, car Twig à un conmportement très similaire) : `{{ 7*'7' }}`, on a `7777777` en retour, on est sur la bonne voie.

## Exploit

Affichons la configuration du serveur : `{{ config }}`.

On y trouve une variable intéresante : `{'SUPER_SECRET_PATH':'_5uPer_s3cret_'}`.

On se dirige alors vers la page `/_5uPer_s3cret_`, et on a le flag.
