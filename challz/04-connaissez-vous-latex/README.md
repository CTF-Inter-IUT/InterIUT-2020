# LatexRce

Challenge d'injection de code en LaTeX

## Mise en place

```bash
php -S localhost:80
```

OU

```bash
docker build -t interiut/04-latex .
docker run -it --rm -p 80:80 interiut/04-latex
```

## Technologies

J'utilise du PHP7+ côté serveur et la librarie [Code Mirror](https://codemirror.net/) pour la coloration syntaxique dans la textarea.

## Le challenge

> Un de vos amis à développé un éditeur en ligne de LaTeX... Il est troué.
