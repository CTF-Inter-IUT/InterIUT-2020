# Decryptor 
Il s'agit d'un oracle RSA, le service distant proposé de déchiffrer un message chiffré envoyé par l'utilisateur, sauf le flag chiffré au certains de ces dérivés.

## Flag

Flag déchiffré : H2G2{20eaa863cf1c658485713636e608151c}

## Contexte
> Chall sans contexte particulier.

## Mise en place

Dockerfile : [Dockerfile](Dockerfile).


## Explications


On a p = c^d [n] avec c = M^e [n]

c_4 = 5^e [n]

On calcule C = c*c_4 = (M^e)*(5^e) = (5M)^e

Si on envoie C l'oracle nous retourne p = ((5*M)^e)^d [n] = 5*M

Le Flag est donc M/5

L'exploitation est détaillée [ici](writeup.md).

## Ressources
