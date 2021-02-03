# _Homo_ Acceruss

En étudiant le .pcapng on récupère l'adresse du serveur, le format des transactions monétaires ainsi que la requête à réaliser pour créer son compte.

On créé son compte :
```bash
curl server.address/api/accounts/new/:username

{
	"id": "0000-0000-0001",
	"username": "MasterFox",
	"balance": 0
}
```

On récupère les requêtes pour détrousser le monsieur très riche qu'on a vu. On exploite l'homomorphisme du RSA en multipliant les chiffrés entre eux pour obtenir la somme la plus importante possible.

```bash
curl server.address/api/transactions/new

{
	"transaction-id": "0000-0000-0001",
	"vendor": "ENSIBS-2019-BANK",
	"emetteur": "0000-0000-0069", //ID du monsieur très riche
	"destinataire": "0000-0000-0001",
	"value": "MTAwMDAwCg==" //Le résultat du produit des chiffrés
}
```

On a alors le message de félicitation avec le flag.

