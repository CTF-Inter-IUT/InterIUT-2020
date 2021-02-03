# LatexRce

Challenge de lecture de fichier locaux via LaTeX

## Flag

Le flag est dans le fichier à la racine : ENSIBS{LaTeX_c0mp1l4t10n_15_a_b1t_r15ky}

## Contexte

> Un de vos amis à développé un éditeur en ligne de LaTeX... Il est troué. Moins que la première fois mais toujours troué.

## Mise en place

Pour lancer le service facilement : [Dockerfile](Dockerfile).

```bash
docker build -t interiut/04-latex .
docker run -it --rm -p 80:80 interiut/05-latex
```

Pour tester sans Docker :
```bash
php -S localhost:80
```

## Explications

Les différentes étapes d'exploitation de la LFI sont détaillées [ici](writeup.md).
