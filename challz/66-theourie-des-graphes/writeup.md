# La théourie des graphes

Un chall GraphQL, il y a des notes publiées par le professeur,et d'autres encore secretes.

Faut chopper la note avec l'id 69 (la seule non publiée, donc c'est scriptable et y'a des indices donc pas trop guessing ?), on voit qu'il nous donne une route de l'application. On y va et on voit des notes en vrac, soit on les lit toutes, soit Ctrl+F 'ENSIBS' et on a le flag.

```
{
    GetCourse(id: 69) {
        title, content, published
    }
}
```

`curl /secret_notes | grep ENSIBS`
