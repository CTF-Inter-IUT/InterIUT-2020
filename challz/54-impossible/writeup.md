# Impossible ?

On doit exécuter une fonction en PHP.

## Recon

On a le code source. On veut exécuter la fonction `RecuperationDuMotDePasse()`, pour se faire on va utiliser le paramètre GET `code` qui va appeler une fonction de callback choisie (la valeur de `code`).

Or, un filtre est en place, pour exécuter la fonction de callback choisie dans le paramètre GET, il ne faut pas y avoir la chaîne `RecuperationDuMotDePasse`.

On peut se dire que le challenge est impossible à réaliser.

## Tests

En mettant en paramètre GET `code=RecuperationDuMotDePasse`, on va tester le filtre réalisé par le _leet lamer_.

Sans grande surprise ça ne marche pas, le filtre est bien solide sur ses appuis. On peut essayer de chercher d'autres fonctions qu pourraient nous être utile, mais la fonction `call_user_func()` n'accepte qu'un string (la fonction de callback à appeler), mais pas d'arguments à ajouter à la fonction susnommée. On ne peut alors essayer d'afficher le flag avec un `echo Config::FLAG`, ou `include include/config.php` etc...

## Exploit

MAIS pour notre plus grand plaisir, PHP a beaucoup de 'features' super cools, notament le fait d'être insenssible à la casse quant il s'agit d'appeler de fonctions.

Cela veut dire que :

```php
function wEsH_aLORs(){ echo "Jul le sang"; }

wesh_alors();
WESH_alors();
```

Les appels de la fonction vont se réaliser ! On peut alors récupérer sans crainte le flag :

`GET /?code=recuperationdumotdepasse`
