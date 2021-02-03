# Writeup

## Installation de l'APK (optionnel)

Sur un device physique connecté en USB, débogage USB activé :

`adb install reverse_me_2.apk`

## Décompilation de l'APK

`apktool d reverse_me_2.apk`

## Lecture du code Smali

```bash
cd reverse_me_2/
grep -r firebase ./
```

On trouve une URL de DB Firebase. On la dump en tapant à URL/.json

## Exploit

Dans l'URL on a juste les flags publics, mais à la racine on trouve le dossier secret, qui contient le flag.
