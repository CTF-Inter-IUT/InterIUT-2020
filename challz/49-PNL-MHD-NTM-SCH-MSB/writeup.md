# PNL, MHD, NTM, SCH, MSB

Grâce au titre du challenge on devine que les données sont stockées dans le MSB (Most Significant Bit), l'opposé du LSB (Least Significant Bit).
Puis grâce à l'énoncé on devine que c'est précisément le MSB du canal rouge qui contient les données recherchées.

On pourra utiliser ici la bibliothèque Python PIL qui facilite fortement la manipulation d'image.
J'aurais préféré prendre C, qui aurait été plus simple pour la manipulation de données bas niveau mais je n'ai pas eu le courage d'analyser le format `.png`.
BREF, on lit l'image en colonne comme le laisse supposer la trainée rouge en haut à gauche et on extrait le MSB du canal rouge de chaque pixel.

```
#!/usr/bin/env python3
# coding: utf-8

from PIL import Image

chall = Image.open("39-chall.png")
width, height = chall.size

msb = ""
for x in range(width):
    for y in range(height):
        current_red = chall.getpixel((x,y))[0]
        msb += str((current_red & 128) >> 7)

print(msb)
```

Enfin on récupère le début du binaire sorti et on le convertit en ASCII, et voilà le flag !
