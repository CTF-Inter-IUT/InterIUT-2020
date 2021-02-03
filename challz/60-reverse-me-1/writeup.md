# Writeup

## Installation de l'APK (optionnel)

Sur un device physique connecté en USB, débogage USB activé :

`adb install reverse_me_1.apk`

## Décompilation de l'APK

`apktool d reverse_me_1.apk`

## Lecture du code Smali

```bash
cd reverse_me_1/smali/ctf/interiut/reverse_me_1/
ls # on trouve NotFlag.smali et MainActivity.smali
```

* MainActivity.smali :

    On voit que l'appli apelle la méthode `getFlag()` de la classe NotFlag, avec comme argument le texte entré par l'utilisateur. Si la méthode retourne `true` un Toast est créé et affiche un message qui dit que c'est bien le flag. Sinon nique vous.

* NotFlag.smali :

    Une seule méthode est présente : `getFlag()`, des Strings sont instanciés, puis concaténés dans un certain ordre. L'entrée utilisateur est ensuite testée, si elle est identique à la chaîne formée, la méthode renvoie `true`, `false` sinon.

## Exploit

Dans la classe NotFlag on a le flag, on fait la concaténation des différents Strings dans le bon ordre et on a le flag.
